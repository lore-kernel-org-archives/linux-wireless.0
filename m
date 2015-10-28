Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:42251 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S964806AbbJ1S5s (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 28 Oct 2015 14:57:48 -0400
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Subject: Re: ath9k: fix phyerror codes
From: Kalle Valo <kvalo@codeaurora.org>
In-Reply-To: <1445343566-24776-1-git-send-email-zefir.kurtisi@neratec.com>
To: Zefir Kurtisi <zefir.kurtisi@neratec.com>
Cc: linux-wireless@vger.kernel.org, kvalo@qca.qualcomm.com,
	ath9k-devel@lists.ath9k.org, adrian@freebsd.org
Message-Id: <20151028185748.50E06141566@smtp.codeaurora.org> (sfid-20151028_195752_677267_DF826F34)
Date: Wed, 28 Oct 2015 18:57:48 +0000 (UTC)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


> Some of the ath9k_phyerr enums were wrong from the
> beginning (and even before). Most of the time the
> codes were used for counters to be displayed over
> debugfs, which made this a non-functional issue.
> 
> Some (e.g. ATH9K_PHYERR_FALSE_RADAR_EXT) are used
> for radar detection and require the correct code
> to work as intended.
> 
> This patch includes:
> a) fixes
>   ATH9K_PHYERR_FALSE_RADAR_EXT:    24 => 36
>   ATH9K_PHYERR_CCK_LENGTH_ILLEGAL: 32 => 28
>   ATH9K_PHYERR_CCK_POWER_DROP:     33 => 29
>   ATH9K_PHYERR_HT_CRC_ERROR:       34 => 32
>   ATH9K_PHYERR_HT_LENGTH_ILLEGAL:  35 => 33
>   ATH9K_PHYERR_HT_RATE_ILLEGAL:    36 => 34
> 
> b) extensions
>   ATH9K_PHYERR_CCK_BLOCKER = 24
>   ATH9K_PHYERR_HT_ZLF      = 35
>   ATH9K_PHYERR_GREEN_FIELD = 37
> 
> Aside from the correction and completion made in
> the enum, the patch also extends the display of
> the related counters in the debugfs.
> 
> Signed-off-by: Zefir Kurtisi <zefir.kurtisi@neratec.com>

Thanks, applied to wireless-drivers-next.git.

Kalle Valo
