Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-fx0-f46.google.com ([209.85.161.46]:52504 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932187Ab1CWWXu convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 23 Mar 2011 18:23:50 -0400
Received: by fxm17 with SMTP id 17so7768631fxm.19
        for <linux-wireless@vger.kernel.org>; Wed, 23 Mar 2011 15:23:49 -0700 (PDT)
From: Helmut Schaa <helmut.schaa@googlemail.com>
To: Senthil Balasubramanian <senthilkumar@atheros.com>
Subject: Re: [PATCH 1/2] ath9k: Fix kernel panic caused by invalid rate index access.
Date: Wed, 23 Mar 2011 23:22:02 +0100
Cc: linville@tuxdriver.com, linux-wireless@vger.kernel.org
References: <1300901842-3350-1-git-send-email-senthilkumar@atheros.com>
In-Reply-To: <1300901842-3350-1-git-send-email-senthilkumar@atheros.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Message-Id: <201103232322.02763.helmut.schaa@googlemail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi,

Am Mittwoch, 23. März 2011 schrieb Senthil Balasubramanian:
> With the recent tx status optimization in mac80211, we bail out as
> and and when invalid rate index is found. So the behavior of resetting
> rate idx to -1 and count to 0 has changed for the rate indexes that
> were not part of the driver's retry series.
> 
> This has resulted in ath9k using incorrect rate table index which
> caused the system to panic. Ideally ath9k need to loop only for the
> indexes that were part of the retry series and so simply use hw->max_rates
> as the loop counter.

Sorry for the trouble. I didn't consider rc algorithms
outside of net/mac80211/ ...

> ---
>  drivers/net/wireless/ath/ath9k/rc.c |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
> 
> diff --git a/drivers/net/wireless/ath/ath9k/rc.c b/drivers/net/wireless/ath/ath9k/rc.c
> index 960d717..a3241cd 100644
> --- a/drivers/net/wireless/ath/ath9k/rc.c
> +++ b/drivers/net/wireless/ath/ath9k/rc.c
> @@ -1328,7 +1328,7 @@ static void ath_tx_status(void *priv, struct ieee80211_supported_band *sband,
>  
>  	hdr = (struct ieee80211_hdr *)skb->data;
>  	fc = hdr->frame_control;
> -	for (i = 0; i < IEEE80211_TX_MAX_RATES; i++) {
> +	for (i = 0; i < sc->hw->max_rates; i++) {
>  		struct ieee80211_tx_rate *rate = &tx_info->status.rates[i];
>  		if (!rate->count)
>  			break;

You could also just change that check to

	if (rate->idx < 0)
		break;

instead as mac80211 already assumes the tx status rates array is terminated
by the driver by setting the idx to -1.

Helmut
