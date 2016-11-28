Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:39298 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932127AbcK1LxN (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 28 Nov 2016 06:53:13 -0500
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Subject: Re: rtl8xxxu: tx rate reported before set
From: Kalle Valo <kvalo@codeaurora.org>
In-Reply-To: <20161126021158.GA12838@box64.home.org>
References: <20161126021158.GA12838@box64.home.org>
To: Barry Day <briselec@gmail.com>
Cc: Jes Sorensen <Jes.Sorensen@redhat.com>,
        linux-wireless@vger.kernel.org
Message-Id: <20161128115312.4E2646134E@smtp.codeaurora.org> (sfid-20161128_125316_123585_B2AE0334)
Date: Mon, 28 Nov 2016 11:53:12 +0000 (UTC)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Barry Day <briselec@gmail.com> wrote:
> Move the dev_info call that attempts to show the rate used before it is set.
> 
> Signed-off-by: Barry Day <briselec@gmail.com>

Jes, I would like to take this directly to fix the compiler warning. Also I'll
change the commit log to:

rtl8xxxu: tx rate reported before set

Move the dev_info call that attempts to show the rate used before it is set.
Fixes a compiler warning:

drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu_core.c: In function 'rtl8xxxu_fill_txdesc_v2':
include/linux/device.h:1214:36: warning: 'rate' may be used uninitialized in this function [-Wmaybe-uninitialized]
 #define dev_info(dev, fmt, arg...) _dev_info(dev, fmt, ##arg)

Fixes: b4c3d9cfb607 ("rtl8xxxu: Pass tx_info to fill_txdesc in order to have access to retry count")
Reported-by: Stephen Rothwell <sfr@canb.auug.org.au>
Signed-off-by: Barry Day <briselec@gmail.com>

-- 
https://patchwork.kernel.org/patch/9448225/

Documentation about submitting wireless patches and checking status
from patchwork:

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches
