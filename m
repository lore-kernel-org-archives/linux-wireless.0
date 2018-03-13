Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:50302 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752391AbeCMQsH (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 13 Mar 2018 12:48:07 -0400
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Subject: Re: [v2] bcma: Prevent build of PCI host features in module
From: Kalle Valo <kvalo@codeaurora.org>
In-Reply-To: <1519898292-12155-1-git-send-email-matt.redfearn@mips.com>
References: <1519898292-12155-1-git-send-email-matt.redfearn@mips.com>
To: Matt Redfearn <matt.redfearn@mips.com>
Cc: <zajec5@gmail.com>, <linux-wireless@vger.kernel.org>,
        <linux-mips@linux-mips.org>, <jhogan@kernel.org>,
        Matt Redfearn <matt.redfearn@mips.com>
Message-Id: <20180313164807.597C260848@smtp.codeaurora.org> (sfid-20180313_174815_402975_F4F4640F)
Date: Tue, 13 Mar 2018 16:48:07 +0000 (UTC)
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

Patch applied to wireless-drivers-next.git, thanks.

79ca239a68f8 bcma: Prevent build of PCI host features in module

-- 
https://patchwork.kernel.org/patch/10250739/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches
