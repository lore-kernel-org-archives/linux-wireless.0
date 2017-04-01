Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga06.intel.com ([134.134.136.31]:31375 "EHLO mga06.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751958AbdDAWbG (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Sat, 1 Apr 2017 18:31:06 -0400
Date: Sun, 2 Apr 2017 00:30:51 +0200
From: Samuel Ortiz <sameo@linux.intel.com>
To: Nicholas Mc Guire <der.herr@hofr.at>
Cc: Clement Perrochaud <clement.perrochaud@effinnov.com>,
        Charles Gorand <charles.gorand@effinnov.com>,
        linux-nfc@ml01.01.org, linux-wireless@vger.kernel.org,
        linux-kernel@vger.kernel.org, Nicholas Mc Guire <hofrat@osadl.org>
Subject: Re: [PATCH] nfc: nxp-nci: use msleep for long delays
Message-ID: <20170401223024.GG22034@zurbaran.ger.intel.com> (sfid-20170402_003126_033050_52A7C287)
References: <1485088119-17986-1-git-send-email-der.herr@hofr.at>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1485088119-17986-1-git-send-email-der.herr@hofr.at>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Nicholas,

On Sun, Jan 22, 2017 at 01:28:39PM +0100, Nicholas Mc Guire wrote:
> ulseep_range() uses hrtimers and provides no advantage over msleep()
> for larger delays. For this large delay msleep() is preferable.
> 
> Fixes: commit 6be88670fc59 ("NFC: nxp-nci_i2c: Add I2C support to NXP NCI driver")
> Link: http://lkml.org/lkml/2017/1/11/377
> Signed-off-by: Nicholas Mc Guire <hofrat@osadl.org>
> ---
> Problem was found by cocinelle script.
> 
> nxp_nci_i2c_write takes the negative return code as indicator that the
> NFC device was probably in stand-by mode, the first transaction attempt
> woke it up and that after 110ms latest it would be ready to receive.
> Overrunning this time by a few milliseconds will not hurt though so
> msleep() should be fine here.
> 
> Patch was compile tested with: x86_64_defconfig + CONFIG_NFC=m,
> CONFIG_NFC_NCI=m, CONFIG_NFC_NXP_NCI=m, CONFIG_NFC_NXP_NCI_I2C=m
> 
> Patch is against 4.10-rc4 (localversion-next is next-20170120)
> 
>  drivers/nfc/nxp-nci/i2c.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
Applied to nfc-next, thanks.

Cheers,
Samuel.
