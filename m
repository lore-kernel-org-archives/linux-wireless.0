Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([144.76.43.152]:38514 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752201Ab3EXKaD (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 24 May 2013 06:30:03 -0400
Message-ID: <1369391399.8290.6.camel@jlt4.sipsolutions.net> (sfid-20130524_123008_090233_8978D260)
Subject: Re: [PATCH 2/2] ath9k: check for Rx-STBC flag and pass it to
 ieee80211
From: Johannes Berg <johannes@sipsolutions.net>
To: Oleksij Rempel <linux@rempel-privat.de>
Cc: ath9k-devel@lists.ath9k.org, linux-wireless@vger.kernel.org
Date: Fri, 24 May 2013 12:29:59 +0200
In-Reply-To: <1369390711-992-3-git-send-email-linux@rempel-privat.de> (sfid-20130524_121845_309854_63769133)
References: <1368949136-6079-1-git-send-email-linux@rempel-privat.de>
	 <1369390711-992-1-git-send-email-linux@rempel-privat.de>
	 <1369390711-992-3-git-send-email-linux@rempel-privat.de>
	 (sfid-20130524_121845_309854_63769133)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, 2013-05-24 at 12:18 +0200, Oleksij Rempel wrote:
> Signed-off-by: Oleksij Rempel <linux@rempel-privat.de>
> ---
>  drivers/net/wireless/ath/ath9k/init.c | 9 +++++++--
>  drivers/net/wireless/ath/ath9k/mac.c  | 5 +++++
>  drivers/net/wireless/ath/ath9k/mac.h  | 3 ++-
>  3 files changed, 14 insertions(+), 3 deletions(-)
> 
> diff --git a/drivers/net/wireless/ath/ath9k/init.c b/drivers/net/wireless/ath/ath9k/init.c
> index aba4151..7739b05 100644
> --- a/drivers/net/wireless/ath/ath9k/init.c
> +++ b/drivers/net/wireless/ath/ath9k/init.c
> @@ -769,8 +769,13 @@ void ath9k_set_hw_capab(struct ath_softc *sc, struct ieee80211_hw *hw)
>  		IEEE80211_HW_REPORTS_TX_ACK_STATUS |
>  		IEEE80211_HW_SUPPORTS_RC_TABLE;
>  
> -	if (sc->sc_ah->caps.hw_caps & ATH9K_HW_CAP_HT)
> -		 hw->flags |= IEEE80211_HW_AMPDU_AGGREGATION;
> +	if (sc->sc_ah->caps.hw_caps & ATH9K_HW_CAP_HT) {
> +		hw->flags |= IEEE80211_HW_AMPDU_AGGREGATION;
> +
> +		if (AR_SREV_9280_20_OR_LATER(ah))
> +			hw->radiotap_mcs_details |=
> +				IEEE80211_RADIOTAP_MCS_HAVE_STBC;
> +	}

Are you sure this is right? It seems that if other devices don't support
STBC they can report all frames to be w/o STBC. Or do they support STBC
but don't report it?

johannes

