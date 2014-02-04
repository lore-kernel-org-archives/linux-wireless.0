Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtprelay0029.hostedemail.com ([216.40.44.29]:48870 "EHLO
	smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752394AbaBDDen (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 3 Feb 2014 22:34:43 -0500
Message-ID: <1391484878.2538.11.camel@joe-AO722> (sfid-20140204_043446_506156_CD9118F2)
Subject: Re: [PATCH 1/3] ath9k: Fix build error on ARM
From: Joe Perches <joe@perches.com>
To: Sujith Manoharan <sujith@msujith.org>
Cc: John Linville <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org, ath9k-devel@lists.ath9k.org
Date: Mon, 03 Feb 2014 19:34:38 -0800
In-Reply-To: <1391483274-20331-2-git-send-email-sujith@msujith.org>
References: <1391483274-20331-1-git-send-email-sujith@msujith.org>
	 <1391483274-20331-2-git-send-email-sujith@msujith.org>
Content-Type: text/plain; charset="ISO-8859-1"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, 2014-02-04 at 08:37 +0530, Sujith Manoharan wrote:
> From: Sujith Manoharan <c_manoha@qca.qualcomm.com>
> 
> Use mdelay instead of udelay to fix this error:
> 
> ERROR: "__bad_udelay" [drivers/net/wireless/ath/ath9k/ath9k_hw.ko] undefined!
> make[1]: *** [__modpost] Error 1
> make: *** [modules] Error 2
> 
> Reported-by: Josh Boyer <jwboyer@fedoraproject.org>
> Signed-off-by: Sujith Manoharan <c_manoha@qca.qualcomm.com>
> ---
>  drivers/net/wireless/ath/ath9k/hw.c | 5 ++---
>  1 file changed, 2 insertions(+), 3 deletions(-)
> 
> diff --git a/drivers/net/wireless/ath/ath9k/hw.c b/drivers/net/wireless/ath/ath9k/hw.c
> index fbf43c0..11eab9f 100644
> --- a/drivers/net/wireless/ath/ath9k/hw.c
> +++ b/drivers/net/wireless/ath/ath9k/hw.c
> @@ -1316,7 +1316,7 @@ static bool ath9k_hw_set_reset(struct ath_hw *ah, int type)
>  	if (AR_SREV_9300_20_OR_LATER(ah))
>  		udelay(50);
>  	else if (AR_SREV_9100(ah))
> -		udelay(10000);
> +		mdelay(10);
>  	else
>  		udelay(100);

How can this help?
There are udelays above and below this line.

>  
> @@ -2051,9 +2051,8 @@ static bool ath9k_hw_set_power_awake(struct ath_hw *ah)
>  
>  	REG_SET_BIT(ah, AR_RTC_FORCE_WAKE,
>  		    AR_RTC_FORCE_WAKE_EN);
> -
>  	if (AR_SREV_9100(ah))
> -		udelay(10000);
> +		mdelay(10);
>  	else
>  		udelay(50);
>  



