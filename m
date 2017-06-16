Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:49930 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750760AbdFPFH1 (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 16 Jun 2017 01:07:27 -0400
From: Kalle Valo <kvalo@codeaurora.org>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: Wireless <linux-wireless@vger.kernel.org>,
        Linux-Next Mailing List <linux-next@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Arend Van Spriel <arend.vanspriel@broadcom.com>
Subject: Re: linux-next: build warning after merge of the wireless-drivers tree
References: <20170616082507.1e824796@canb.auug.org.au>
Date: Fri, 16 Jun 2017 08:07:21 +0300
In-Reply-To: <20170616082507.1e824796@canb.auug.org.au> (Stephen Rothwell's
        message of "Fri, 16 Jun 2017 08:25:07 +1000")
Message-ID: <87a858ed12.fsf@codeaurora.org> (sfid-20170616_070745_149396_F48CD133)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Stephen Rothwell <sfr@canb.auug.org.au> writes:

> After merging the wireless-drivers tree, today's linux-next build
> (x86_64 allmodconfig) produced this warning:
>
> drivers/net/wireless/broadcom/brcm80211/brcmfmac/usb.c: In function
> 'brcmf_usb_probe_phase2':
> drivers/net/wireless/broadcom/brcm80211/brcmfmac/usb.c:1198:2:
> warning: 'devinfo' may be used uninitialized in this function
> [-Wmaybe-uninitialized]
>   mutex_unlock(&devinfo->dev_init_lock);
>   ^
>
> Introduced by commit
>
>   6d0507a777fb ("brcmfmac: add parameter to pass error code in firmware callback")

Thanks, for the report. I also noticed this, only after I had applied
the patch, but hopefully Arend sends a patch to fix this soon.

-- 
Kalle Valo
