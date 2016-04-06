Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from cavan.codon.org.uk ([93.93.128.6]:39925 "EHLO
	cavan.codon.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754733AbcDFW5D (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 6 Apr 2016 18:57:03 -0400
Date: Wed, 6 Apr 2016 23:19:43 +0100
From: Matthew Garrett <mjg59@srcf.ucam.org>
To: Lukas Wunner <lukas@wunner.de>
Cc: Bjorn Helgaas <helgaas@kernel.org>, linux-pci@vger.kernel.org,
	linux-wireless@vger.kernel.org, zajec5@gmail.com,
	b43-dev@lists.infradead.org,
	Matt Fleming <matt@codeblueprint.co.uk>,
	linux-efi@vger.kernel.org
Subject: Re: [PATCH] PCI: Add Broadcom 4331 reset quirk to prevent IRQ storm
Message-ID: <20160406221943.GA10955@srcf.ucam.org> (sfid-20160407_005711_636087_B342AD84)
References: <811539524df8b5ed7e2817c1c3e3e08560c97964.1459275517.git.lukas@wunner.de>
 <20160405194015.GC15353@localhost>
 <20160406213029.GA12421@wunner.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20160406213029.GA12421@wunner.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, Apr 06, 2016 at 11:30:29PM +0200, Lukas Wunner wrote:

> Matthew's grub patch puts the wireless card into D3hot, which does not
> stop the interrupts. I have tested this. (It may stop the DMA, I cannot
> verify that as it doesn't occur on my machine for lack of an access point.)

Ah, interesting. One thing to note (and which I've just noticed) is that 
it looks like this fixup is only called when you boot with the "linux" 
command and not with the "linuxefi" command. If you're using Ubuntu, 
"linux" may fall back to "linuxefi" without executing this fixup. So we 
need to add it to the kernel EFI stub anyway.

-- 
Matthew Garrett | mjg59@srcf.ucam.org
