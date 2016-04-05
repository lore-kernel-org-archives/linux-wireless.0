Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from cavan.codon.org.uk ([93.93.128.6]:50997 "EHLO
	cavan.codon.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752757AbcDEUXL (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 5 Apr 2016 16:23:11 -0400
Date: Tue, 5 Apr 2016 20:59:46 +0100
From: Matthew Garrett <mjg59@srcf.ucam.org>
To: Bjorn Helgaas <helgaas@kernel.org>
Cc: Lukas Wunner <lukas@wunner.de>, linux-pci@vger.kernel.org,
	linux-wireless@vger.kernel.org, zajec5@gmail.com,
	b43-dev@lists.infradead.org
Subject: Re: [PATCH] PCI: Add Broadcom 4331 reset quirk to prevent IRQ storm
Message-ID: <20160405195946.GA18194@srcf.ucam.org> (sfid-20160405_222314_295305_CF84458B)
References: <811539524df8b5ed7e2817c1c3e3e08560c97964.1459275517.git.lukas@wunner.de>
 <20160405194015.GC15353@localhost>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20160405194015.GC15353@localhost>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, Apr 05, 2016 at 02:40:15PM -0500, Bjorn Helgaas wrote:

> https://bugzilla.kernel.org/show_bug.cgi?id=111781 and
> https://mjg59.dreamwidth.org/11235.html describe a sort of similar
> issue, but with DMA.  An interrupt from the device is probably to
> signal a DMA completion, but these problem reports only mention the
> "IRQ nobody cared" issue; I don't see anything about memory
> corruption.

I "fixed" this with 
https://github.com/mjg59/grub-fedora/commit/21fcd6d79b7601e4b20ad70c5408adff2dabbc1d 
- doing the same in the kernel EFI stub would probably be the best way 
to handle it. This way you're guaranteed to stop DMA before the kernel 
reclaims boot services memory, which guarantees you won't have any 
corruption.

-- 
Matthew Garrett | mjg59@srcf.ucam.org
