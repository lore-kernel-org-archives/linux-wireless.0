Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mout.gmx.net ([212.227.15.15]:49421 "EHLO mout.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754087Ab3EXLf3 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 24 May 2013 07:35:29 -0400
Received: from mailout-de.gmx.net ([10.1.76.17]) by mrigmx.server.lan
 (mrigmx002) with ESMTP (Nemesis) id 0MW5VH-1UzKBd1pqT-00XK3q for
 <linux-wireless@vger.kernel.org>; Fri, 24 May 2013 13:35:28 +0200
Message-ID: <519F507C.6090000@rempel-privat.de> (sfid-20130524_133533_108658_89C09372)
Date: Fri, 24 May 2013 13:35:24 +0200
From: Oleksij Rempel <linux@rempel-privat.de>
MIME-Version: 1.0
To: Oleksij Rempel <linux@rempel-privat.de>
CC: ath9k-devel@lists.ath9k.org, linux-wireless@vger.kernel.org
Subject: Re: [PATCH 2/2] ath9k: check for Rx-STBC flag and pass it to ieee80211
References: <1368949136-6079-1-git-send-email-linux@rempel-privat.de> <1369390711-992-1-git-send-email-linux@rempel-privat.de> <1369390711-992-3-git-send-email-linux@rempel-privat.de>
In-Reply-To: <1369390711-992-3-git-send-email-linux@rempel-privat.de>
Content-Type: text/plain; charset=UTF-8; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Am 24.05.2013 12:18, schrieb Oleksij Rempel:
> Signed-off-by: Oleksij Rempel <linux@rempel-privat.de>
> ---
>   drivers/net/wireless/ath/ath9k/init.c | 9 +++++++--
>   drivers/net/wireless/ath/ath9k/mac.c  | 5 +++++
>   drivers/net/wireless/ath/ath9k/mac.h  | 3 ++-
>   3 files changed, 14 insertions(+), 3 deletions(-)
>
> diff --git a/drivers/net/wireless/ath/ath9k/init.c b/drivers/net/wireless/ath/ath9k/init.c
> index aba4151..7739b05 100644
> --- a/drivers/net/wireless/ath/ath9k/init.c
> +++ b/drivers/net/wireless/ath/ath9k/init.c
> @@ -769,8 +769,13 @@ void ath9k_set_hw_capab(struct ath_softc *sc, struct ieee80211_hw *hw)
>   		IEEE80211_HW_REPORTS_TX_ACK_STATUS |
>   		IEEE80211_HW_SUPPORTS_RC_TABLE;
>
> -	if (sc->sc_ah->caps.hw_caps & ATH9K_HW_CAP_HT)
> -		 hw->flags |= IEEE80211_HW_AMPDU_AGGREGATION;
> +	if (sc->sc_ah->caps.hw_caps & ATH9K_HW_CAP_HT) {
> +		hw->flags |= IEEE80211_HW_AMPDU_AGGREGATION;
> +
> +		if (AR_SREV_9280_20_OR_LATER(ah))
> +			hw->radiotap_mcs_details |=
> +				IEEE80211_RADIOTAP_MCS_HAVE_STBC;

comment for my self. i forgot to include <net/ieee80211_radiotap.h>
for IEEE80211_RADIOTAP_MCS_HAVE_STBC. This patch is broken.

-- 
Regards,
Oleksij
