Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from Galois.linutronix.de ([146.0.238.70]:60925 "EHLO
        Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751408AbdJEKN6 (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 5 Oct 2017 06:13:58 -0400
Date: Thu, 5 Oct 2017 12:13:49 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: Daniel Drake <drake@endlessm.com>
cc: LKML <linux-kernel@vger.kernel.org>, linux-pci@vger.kernel.org,
        x86@kernel.org, linux-wireless@vger.kernel.org,
        ath9k-devel@qca.qualcomm.com, linux@endlessm.com,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
        Andy Shevchenko <andy@infradead.org>
Subject: Re: [PATCH] PCI MSI: allow alignment restrictions on vector
 allocation
In-Reply-To: <20171005042316.12261-1-drake@endlessm.com>
Message-ID: <alpine.DEB.2.20.1710051046040.2083@nanos> (sfid-20171005_121412_194643_21519A6C)
References: <alpine.DEB.2.20.1710021540030.2185@nanos> <20171005042316.12261-1-drake@endlessm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, 5 Oct 2017, Daniel Drake wrote:
> On Mon, Oct 2, 2017 at 10:38 PM, Thomas Gleixner <tglx@linutronix.de> wrote:
> > What's wrong with just using the legacy INTx emulation if you cannot
> > allocate 4 MSI vectors?
> 
> The Legacy interrupt simply doesn't work for the wifi on at least 8 new Acer
> laptop products based on Intel Apollo Lake.
> Plus 4 Dell systems included in the patches in this thread:
> https://lkml.org/lkml/2017/9/26/55
> (the 2 which I can find specs for are also Apollo Lake)
>
> We have tried taking the mini-PCIe wifi module out of one of the affected
> Acer products and moved it to another computer, where it is working fine
> with legacy interrupts. So this suggests that the wifi module itself is OK,
> but we are facing a hardware limitation or BIOS limitation on the affected
> products. In the Dell thread it says "Some platform(BIOS) blocks legacy
> interrupts (INTx)".
>
> If you have any suggestions for how we might solve this without getting into
> the MSI mess then that would be much appreciated. If the BIOS blocks the
> interrupts, can Linux unblock them?

I'm pretty sure we can. Cc'ed Rafael and Andy. They might know, if not they
certainly know whom to ask @Intel.

> Just for reference I'm attaching my latest attempt at enabling MULTI_PCI_MSI.
> It would definitely need further work if we proceed here - so far I've
> ignored the affinity considerations that you explained, and it's not
> particularly clean.

Yeah, I know how that looks. When I rewrote the allocator I initialy had
that multi-vector mode implemented and then ditched it due to the affinity
setting mess and because its hard vs. the global best effort reservation
mode, which is way more important to have than multi MSI.

>  int irq_matrix_alloc(struct irq_matrix *m, const struct cpumask *msk,
> -		     bool reserved, unsigned int *mapped_cpu);
> +		     bool reserved, unsigned int *mapped_cpu, unsigned int num,
> +		     unsigned int align_mask);

That's not needed. We can assume that multivector allocations must be
aligned in the following way:

	count = __roundup_pow_of_two(count);
	mask = ilog2(count);

That's a sane assumption in general.

Thanks,

	tglx
