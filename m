Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from Galois.linutronix.de ([146.0.238.70]:38494 "EHLO
        Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751067AbdJBOi4 (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 2 Oct 2017 10:38:56 -0400
Date: Mon, 2 Oct 2017 16:38:50 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: Daniel Drake <drake@endlessm.com>
cc: linux-kernel@vger.kernel.org, linux-pci@vger.kernel.org,
        x86@kernel.org, linux-wireless@vger.kernel.org,
        ath9k-devel@qca.qualcomm.com, linux@endlessm.com
Subject: Re: [PATCH] PCI MSI: allow alignment restrictions on vector
 allocation
In-Reply-To: <20171002085732.4039-1-drake@endlessm.com>
Message-ID: <alpine.DEB.2.20.1710021540030.2185@nanos> (sfid-20171002_163900_447097_C8D5C0A4)
References: <alpine.DEB.2.20.1709271555430.2027@nanos> <20171002085732.4039-1-drake@endlessm.com>
MIME-Version: 1.0
Content-Type: multipart/mixed; BOUNDARY="8323329-597251528-1506955133=:2185"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

--8323329-597251528-1506955133=:2185
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT

Daniel,

On Mon, 2 Oct 2017, Daniel Drake wrote:
> On Wed, Sep 27, 2017 at 11:28 PM, Thomas Gleixner <tglx@linutronix.de> wrote:
> On another system, I have multiple devices using IR-PCI-MSI according
> to /proc/interrupts, and lspci shows that a MSI Message Data value 0
> is used for every single MSI-enabled device.
> 
> I don't know if that's just luck, but its a value that would work
> fine for ath9k.

It's an implementation detail...

> After checking out the new code and thinking this through a bit, I think
> perhaps the only generic approach that would work is to make the
> ath9k driver require a vector allocation that enables the entire block
> of 4 MSI IRQs that the hardware supports (which is what Windows is doing).

I wonder how Windows deals with the affinity problem for multi-MSI. Or does
it just not allow to set it at all?

> This way the alignment requirement is automatically met and ath9k is
> free to stamp all over the lower 2 bits of the MSI Message Data.
> 
> MSI_FLAG_MULTI_PCI_MSI is already supported by a couple of non-x86 drivers
> and the interrupt remapping code, but it is not supported by the generic
> pci_msi_controller, and the new vector allocator still rejects
> X86_IRQ_ALLOC_CONTIGUOUS_VECTORS.

Yes, and it does so because Multi-MSI on x86 requires single destination
for all vectors, that means the affinity is the same for all vectors. This
has two implications:

  1) The generic interrupt code and its affinity management are not able to
     deal with that. Probably a solvable problem, but not trivial either.

  2) The affinity setting of straight MSI interrupts (w/o remapping) on x86
     requires to make the affinity change from the interrupt context of the
     current active vector in order not to lose interrupts or worst case
     getting into a stale state.

     That works for single vectors, but trying to move all vectors in one
     go is more or less impossible, as there is no reliable way to
     determine that none of the other vectors is on flight.

     There might be some 'workarounds' for that, but I rather avoid that
     unless we get an official documented one from Intel/AMD.

With interrupt remapping this is a different story as the remapping unit
removes all these problems and things just work.

The switch to best effort reservation mode for vectors is another
interesting problem. This cannot work with non remapped multi-MSI, unless
we just give up for these type of interrupts and associate them straight
away. I could be persuaded to do so, but the above problems (especially #2)
wont magically go away.

> I will try to take a look at enabling this for the generic allocator,
> unless you have any other ideas.

See above.

> In the mean time, at least for reference, below is an updated version
> of the previous patch based on the new allocator and incorporating
> your feedback. (It's still rather ugly though)
> 
> > I doubt that this can be made generic enough to make it work all over the
> > place. Tell Acer/Foxconn to fix their stupid firmware.
> 
> We're also working on this approach ever since the problematic models
> first appeared months ago, but since these products are in mass production,

I really wonder how they managed to screw that up. The spec is pretty
strict about that:

  "The Multiple Message Enable field (bits 6-4 of the Message Control
   register) defines the number of low order message data bits the function
   is permitted to modify to generate its system software allocated
   vectors. For example, a Multiple Message Enable encoding of “010”
   indicates the function has been allocated four vectors and is permitted
   to modify message data bits 1 and 0 (a function modifies the lower
   message data bits to generate the allocated number of vectors). If the
   Multiple Message Enable field is “000”, the function is not permitted to
   modify the message data."

Not permitted is the keyword here.

> I think ultimately we are going to need a Linux workaround.

What's wrong with just using the legacy INTx emulation if you cannot
allocate 4 MSI vectors?

Thanks,

	tglx
--8323329-597251528-1506955133=:2185--
