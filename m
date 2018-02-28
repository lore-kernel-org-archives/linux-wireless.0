Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:42738 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752441AbeB1Ogt (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 28 Feb 2018 09:36:49 -0500
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Subject: Re: bcma: Prevent build of PCI host features in module
From: Kalle Valo <kvalo@codeaurora.org>
In-Reply-To: <1515767119-17117-1-git-send-email-matt.redfearn@mips.com>
References: <1515767119-17117-1-git-send-email-matt.redfearn@mips.com>
To: Matt Redfearn <matt.redfearn@mips.com>
Cc: =?UTF-8?q?Rafa=C5=82=20Mi=C5=82ecki?= <zajec5@gmail.com>,
        <linux-wireless@vger.kernel.org>,
        Matt Redfearn <matt.redfearn@mips.com>,
        <linux-kernel@vger.kernel.org>
Message-Id: <20180228143648.BD42B60390@smtp.codeaurora.org> (sfid-20180228_153704_408764_16C508DC)
Date: Wed, 28 Feb 2018 14:36:48 +0000 (UTC)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Matt Redfearn <matt.redfearn@mips.com> wrote:

> Attempting to build bcma.ko with BCMA_DRIVER_PCI_HOSTMODE=y results in
> a build error due to use of symbols not exported from vmlinux:
> 
> ERROR: "pcibios_enable_device" [drivers/bcma/bcma.ko] undefined!
> ERROR: "register_pci_controller" [drivers/bcma/bcma.ko] undefined!
> make[1]: *** [scripts/Makefile.modpost:92: __modpost] Error 1
> 
> To prevent this, don't allow the host mode feature to be built if
> CONFIG_BCMA=m
> 
> Signed-off-by: Matt Redfearn <matt.redfearn@mips.com>

This does not apply to wireless-drivers-next anymore. Also please CC:

linux-mips@linux-mips.org
James Hogan <jhogan@kernel.org>

Recorded preimage for 'drivers/bcma/Kconfig'
error: Failed to merge in the changes.
Applying: bcma: Prevent build of PCI host features in module
Using index info to reconstruct a base tree...
M	drivers/bcma/Kconfig
Falling back to patching base and 3-way merge...
Auto-merging drivers/bcma/Kconfig
CONFLICT (content): Merge conflict in drivers/bcma/Kconfig
Patch failed at 0001 bcma: Prevent build of PCI host features in module
The copy of the patch that failed is found in: .git/rebase-apply/patch

Patch set to Changes Requested.

-- 
https://patchwork.kernel.org/patch/10161087/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches
