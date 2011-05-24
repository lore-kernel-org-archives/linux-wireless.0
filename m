Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nbd.name ([46.4.11.11]:50663 "EHLO nbd.name"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756109Ab1EXNT3 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 24 May 2011 09:19:29 -0400
Message-ID: <4DDBB052.6030200@openwrt.org> (sfid-20110524_151932_654144_980EDF23)
Date: Tue, 24 May 2011 15:19:14 +0200
From: Felix Fietkau <nbd@openwrt.org>
MIME-Version: 1.0
To: Fabrice Deyber <fabricedeyber@agilemesh.com>
CC: linville@tuxdriver.com, devel@lists.open80211s.org,
	ath9k-devel@lists.ath9k.org, linux-wireless@vger.kernel.org,
	lrodriguez@atheros.com
Subject: Re: [PATCH] ath9k: Further fix for mesh beaconing
References: <1306240937-19011-1-git-send-email-fabricedeyber@agilemesh.com>
In-Reply-To: <1306240937-19011-1-git-send-email-fabricedeyber@agilemesh.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 2011-05-24 2:42 PM, Fabrice Deyber wrote:
> This fix ensure the timers to be set at beacon interval boundaries. Without
> this change timers can be set improperly resulting in the absence of beacons.
>
> Signed-off-by: Fabrice Deyber<fabricedeyber@agilemesh.com>
> ---
>   drivers/net/wireless/ath/ath9k/beacon.c |   15 +++------------
>   1 files changed, 3 insertions(+), 12 deletions(-)
>
> diff --git a/drivers/net/wireless/ath/ath9k/beacon.c b/drivers/net/wireless/ath/ath9k/beacon.c
> index d4d8cec..34675ae 100644
> --- a/drivers/net/wireless/ath/ath9k/beacon.c
> +++ b/drivers/net/wireless/ath/ath9k/beacon.c
> @@ -656,19 +656,10 @@ static void ath_beacon_config_adhoc(struct ath_softc *sc,
>
>   	ath9k_reset_beacon_status(sc);
>
> -	tsf = ath9k_hw_gettsf32(ah) + TU_TO_USEC(FUDGE);
>   	intval = TU_TO_USEC(conf->beacon_interval&  ATH9K_BEACON_PERIOD);
> -
> -	if (!sc->beacon.bc_tstamp)
> -		nexttbtt = tsf + intval;
> -	else {
> -		if (tsf>  sc->beacon.bc_tstamp)
> -			delta = (tsf - sc->beacon.bc_tstamp);
> -		else
> -			delta = (tsf + 1 + (~0U - sc->beacon.bc_tstamp));
> -		nexttbtt = tsf + intval - (delta % intval);
> -	}
> -
> +    tsf = roundup(ath9k_hw_gettsf32(ah) + TU_TO_USEC(FUDGE), intval);	
> +    nexttbtt = tsf + intval;
There's some whitespace damage here, please fix the indentation.

- Felix
