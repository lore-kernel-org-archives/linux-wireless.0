Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from charlotte.tuxdriver.com ([70.61.120.58]:49423 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757203Ab1FUSqb (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 21 Jun 2011 14:46:31 -0400
Date: Tue, 21 Jun 2011 14:38:00 -0400
From: "John W. Linville" <linville@tuxdriver.com>
To: Hauke Mehrtens <hauke@hauke-m.de>
Cc: mb@bu3sch.de, ralf@linux-mips.org, linux-mips@linux-mips.org,
	linux-wireless@vger.kernel.org
Subject: Re: [PATCH] ssb: add __devinit to some functions
Message-ID: <20110621183800.GB2273@tuxdriver.com> (sfid-20110621_204638_115648_5032F79F)
References: <20110621150227.GB14197@linux-mips.org>
 <1308680889-4217-1-git-send-email-hauke@hauke-m.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1308680889-4217-1-git-send-email-hauke@hauke-m.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, Jun 21, 2011 at 08:28:09PM +0200, Hauke Mehrtens wrote:
> Two functions in ssb are using register_pci_controller() which is
> __devinit. The functions ssb_pcicore_init_hostmode() and
> ssb_gige_probe() should also be __devinit.
> 
> This fixes the following warning:
> WARNING: vmlinux.o(.text+0x2727b8): Section mismatch in reference from the function ssb_pcicore_init_hostmode() to the function .devinit.text:register_pci_controller()
> The function ssb_pcicore_init_hostmode() references
> the function __devinit register_pci_controller().
> This is often because ssb_pcicore_init_hostmode lacks a __devinit
> annotation or the annotation of register_pci_controller is wrong.
> 
> WARNING: vmlinux.o(.text+0x273398): Section mismatch in reference from the function ssb_gige_probe() to the function .devinit.text:register_pci_controller()
> The function ssb_gige_probe() references
> the function __devinit register_pci_controller().
> This is often because ssb_gige_probe lacks a __devinit
> annotation or the annotation of register_pci_controller is wrong.
> 
> Reported-by: Ralf Baechle <ralf@linux-mips.org>

Signed-off-by??

-- 
John W. Linville		Someday the world will need a hero, and you
linville@tuxdriver.com			might be all we have.  Be ready.
