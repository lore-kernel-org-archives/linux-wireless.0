Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.atheros.com ([12.19.149.2]:12286 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753186Ab1EFPSn (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 6 May 2011 11:18:43 -0400
Received: from mail.atheros.com ([10.234.20.104])
	by sidewinder.atheros.com
	for <linux-wireless@vger.kernel.org>; Fri, 06 May 2011 08:18:15 -0700
Message-ID: <4DC4114D.5060001@atheros.com> (sfid-20110506_171846_497012_86DB6058)
Date: Fri, 6 May 2011 20:48:37 +0530
From: Mohammed Shafi <mshajakhan@atheros.com>
MIME-Version: 1.0
To: "linville@tuxdriver.com" <linville@tuxdriver.com>
CC: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	Luis Rodriguez <Luis.Rodriguez@Atheros.com>
Subject: Re: [PATCH] ath9k: make npending frames as bool
References: <1304694900-4317-1-git-send-email-mshajakhan@atheros.com>
In-Reply-To: <1304694900-4317-1-git-send-email-mshajakhan@atheros.com>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Friday 06 May 2011 08:45 PM, Mohammed Shajakhan wrote:
> From: Mohammed Shafi Shajakhan<mshajakhan@atheros.com>
>
> Signed-off-by: Mohammed Shafi Shajakhan<mshajakhan@atheros.com>
> ---
>   drivers/net/wireless/ath/ath9k/main.c |    4 ++--
>   1 files changed, 2 insertions(+), 2 deletions(-)
>
> diff --git a/drivers/net/wireless/ath/ath9k/main.c b/drivers/net/wireless/ath/ath9k/main.c
> index 3de115d..453a5f1 100644
> --- a/drivers/net/wireless/ath/ath9k/main.c
> +++ b/drivers/net/wireless/ath/ath9k/main.c
> @@ -2267,7 +2267,7 @@ static void ath9k_flush(struct ieee80211_hw *hw, bool drop)
>   		timeout = 1;
>
>   	for (j = 0; j<  timeout; j++) {
> -		int npend = 0;
> +		bool npend = false;
>
>   		if (j)
>   			usleep_range(1000, 2000);
> @@ -2276,7 +2276,7 @@ static void ath9k_flush(struct ieee80211_hw *hw, bool drop)
>   			if (!ATH_TXQ_SETUP(sc, i))
>   				continue;
>
> -			npend += ath9k_has_pending_frames(sc,&sc->tx.txq[i]);
> +			npend |= ath9k_has_pending_frames(sc,&sc->tx.txq[i]);
>   		}
>
>   		if (!npend)

John, please drop this patch I had sent it by mistake.

thanks,
shafi
