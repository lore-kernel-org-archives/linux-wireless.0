Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:43464 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752571AbeB1OjB (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 28 Feb 2018 09:39:01 -0500
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Subject: Re: ssb: Prevent build of PCI host features in module
From: Kalle Valo <kvalo@codeaurora.org>
In-Reply-To: <1515767159-17226-1-git-send-email-matt.redfearn@mips.com>
References: <1515767159-17226-1-git-send-email-matt.redfearn@mips.com>
To: Matt Redfearn <matt.redfearn@mips.com>
Cc: Michael Buesch <m@bues.ch>, <linux-wireless@vger.kernel.org>,
        Matt Redfearn <matt.redfearn@mips.com>,
        <linux-kernel@vger.kernel.org>
Message-Id: <20180228143901.4799760272@smtp.codeaurora.org> (sfid-20180228_153917_849975_059D7DC2)
Date: Wed, 28 Feb 2018 14:39:01 +0000 (UTC)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Matt Redfearn <matt.redfearn@mips.com> wrote:

> Attempting to build ssb.ko with CONFIG_SSB_DRIVER_PCICORE=y results in
> a build error due to use of symbols not exported from vmlinux:
> 
> ERROR: "pcibios_enable_device" [drivers/ssb/ssb.ko] undefined!
> ERROR: "register_pci_controller" [drivers/ssb/ssb.ko] undefined!
> make[1]: *** [scripts/Makefile.modpost:92: __modpost] Error 1
> 
> To prevent this, don't allow the host mode feature to be built if
> CONFIG_SSB=m
> 
> Signed-off-by: Matt Redfearn <matt.redfearn@mips.com>

Patch applied to wireless-drivers-next.git, thanks.

882164a4a928 ssb: Prevent build of PCI host features in module

-- 
https://patchwork.kernel.org/patch/10161131/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches
