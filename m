Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.atheros.com ([12.36.123.2]:62290 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750979Ab0BEEdq (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 4 Feb 2010 23:33:46 -0500
Received: from mail.atheros.com ([10.10.20.108])
	by sidewinder.atheros.com
	for <linux-wireless@vger.kernel.org>; Thu, 04 Feb 2010 20:33:46 -0800
From: Sujith <Sujith.Manoharan@atheros.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Message-ID: <19307.41957.838154.472055@gargle.gargle.HOWL>
Date: Fri, 5 Feb 2010 10:21:49 +0530
To: Benoit Papillault <benoit.papillault@free.fr>
CC: "johannes@sipsolutions.net" <johannes@sipsolutions.net>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: [PATCH] ath9k: Fix rate table choice
In-Reply-To: <1265317566-15372-1-git-send-email-benoit.papillault@free.fr>
References: <1265317566-15372-1-git-send-email-benoit.papillault@free.fr>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Benoit Papillault wrote:
> ath9k rate control choose the rate table based on the current channel
> (if it is ht40 or not). However, it happens that at this stage, the
> channel is still ht20 even if the peer sta capabilities would later
> allow ht40. So let's use peer sta capabilities directly.
> 
> Signed-off-by: Benoit Papillault <benoit.papillault@free.fr>
> ---
>  drivers/net/wireless/ath/ath9k/rc.c |    6 ++----
>  1 files changed, 2 insertions(+), 4 deletions(-)
> 
> diff --git a/drivers/net/wireless/ath/ath9k/rc.c b/drivers/net/wireless/ath/ath9k/rc.c
> index 1196884..5ce9da5 100644
> --- a/drivers/net/wireless/ath/ath9k/rc.c
> +++ b/drivers/net/wireless/ath/ath9k/rc.c
> @@ -1341,10 +1341,8 @@ static void ath_rate_update(void *priv, struct ieee80211_supported_band *sband,
>                 if (sc->sc_ah->opmode != NL80211_IFTYPE_STATION)
>                         return;
> 
> -               if (sc->hw->conf.channel_type == NL80211_CHAN_HT40MINUS ||
> -                   sc->hw->conf.channel_type == NL80211_CHAN_HT40PLUS)
> -                       oper_cw40 = true;
> -
> +               oper_cw40 = (sta->ht_cap.cap &
> +                            IEEE80211_HT_CAP_SUP_WIDTH_20_40) ? true : false;
>                 oper_sgi40 = (sta->ht_cap.cap & IEEE80211_HT_CAP_SGI_40) ?
>                         true : false;
> 

This is wrong, the AP can certainly support HT40/HT20 and switch between them
dynamically - this patch changes how ath9k reacts to channel switching.

The AP can switch its operating channel to HT20 - but the HT40 supported bit
will _still_ be set. Can you capture the association sequence and check the
HT_INFO IE ( which is different from HT CAP) ?

Sujith
