Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ob0-f170.google.com ([209.85.214.170]:36486 "EHLO
	mail-ob0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753677AbcDFL2d (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 6 Apr 2016 07:28:33 -0400
MIME-Version: 1.0
In-Reply-To: <20160405195946.GA18194@srcf.ucam.org>
References: <811539524df8b5ed7e2817c1c3e3e08560c97964.1459275517.git.lukas@wunner.de>
	<20160405194015.GC15353@localhost>
	<20160405195946.GA18194@srcf.ucam.org>
Date: Wed, 6 Apr 2016 21:28:27 +1000
Message-ID: <CA+Y=x3=02_ScR_jVcxy_9O0LE-HhdjOT80kPCT6oJX949i+Crg@mail.gmail.com> (sfid-20160406_132846_631527_F5774744)
Subject: Re: [PATCH] PCI: Add Broadcom 4331 reset quirk to prevent IRQ storm
From: Andrew Worsley <amworsley@gmail.com>
To: Matthew Garrett <mjg59@srcf.ucam.org>
Cc: Bjorn Helgaas <helgaas@kernel.org>, linux-pci@vger.kernel.org,
	linux-wireless@vger.kernel.org, b43-dev@lists.infradead.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

That patch appears to be the grub 1 equivalent  to  grub2
git://git.savannah.gnu.org/grub.git rev 9d34bb8 which puts the network
device into D3 power state.

I am running grub2 with that patch and it doesn't fix my irq 17 problem.

Can we not fix this in grub2 via something like Lukas original patch
or disable any DMA transfers before the kernel starts?

Andrew
On 6 April 2016 at 05:59, Matthew Garrett <mjg59@srcf.ucam.org> wrote:
> On Tue, Apr 05, 2016 at 02:40:15PM -0500, Bjorn Helgaas wrote:
>
>> https://bugzilla.kernel.org/show_bug.cgi?id=111781 and
>> https://mjg59.dreamwidth.org/11235.html describe a sort of similar
>> issue, but with DMA.  An interrupt from the device is probably to
>> signal a DMA completion, but these problem reports only mention the
>> "IRQ nobody cared" issue; I don't see anything about memory
>> corruption.
>
> I "fixed" this with
> https://github.com/mjg59/grub-fedora/commit/21fcd6d79b7601e4b20ad70c5408adff2dabbc1d
> - doing the same in the kernel EFI stub would probably be the best way
> to handle it. This way you're guaranteed to stop DMA before the kernel
> reclaims boot services memory, which guarantees you won't have any
> corruption.
