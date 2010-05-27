Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp3-g21.free.fr ([212.27.42.3]:45970 "EHLO smtp3-g21.free.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754752Ab0E0GCR (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 27 May 2010 02:02:17 -0400
Message-ID: <4BFE0ADE.2090403@free.fr>
Date: Thu, 27 May 2010 08:02:06 +0200
From: Benoit Papillault <benoit.papillault@free.fr>
MIME-Version: 1.0
To: Bruno Randolf <br1@einfach.org>
CC: linville@tuxdriver.com, juuso.oikarinen@nokia.com,
	johannes@sipsolutions.net, ath5k-devel@lists.ath5k.org,
	linux-wireless@vger.kernel.org
Subject: Re: [ath5k-devel] [PATCH] mac80211: mark 1, 2,	5.5 and 11Mbps as
 mandatory rates for 802.11b
References: <1274883276.3658.15.camel@jlt3.sipsolutions.net> <20100527004545.11541.88667.stgit@tt-desk>
In-Reply-To: <20100527004545.11541.88667.stgit@tt-desk>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Le 27/05/2010 02:45, Bruno Randolf a écrit :
> IEEE802.11-2007 clause 18.2.3.3 (p640) states that 1, 2, 5.5&  11 Mbits are
> mandatory rates for what they call High Rate direct sequence spread spectrum
> (HR/DSSS) PHY (with long PLCP).
>
> Signed-off-by: Bruno Randolf<br1@einfach.org>
> ---
>   net/wireless/util.c |   12 ++++++------
>   1 files changed, 6 insertions(+), 6 deletions(-)
>
> diff --git a/net/wireless/util.c b/net/wireless/util.c
> index 3416373..f6f4101 100644
> --- a/net/wireless/util.c
> +++ b/net/wireless/util.c
> @@ -100,17 +100,17 @@ static void set_mandatory_flags_band(struct ieee80211_supported_band *sband,
>   	case IEEE80211_BAND_2GHZ:
>   		want = 7;
>   		for (i = 0; i<  sband->n_bitrates; i++) {
> -			if (sband->bitrates[i].bitrate == 10) {
> +			if (sband->bitrates[i].bitrate == 10 ||
> +			    sband->bitrates[i].bitrate == 20 ||
> +			    sband->bitrates[i].bitrate == 55 ||
> +			    sband->bitrates[i].bitrate == 110) {
>   				sband->bitrates[i].flags |=
>   					IEEE80211_RATE_MANDATORY_B |
>   					IEEE80211_RATE_MANDATORY_G;
>   				want--;
>   			}
>
> -			if (sband->bitrates[i].bitrate == 20 ||
> -			    sband->bitrates[i].bitrate == 55 ||
> -			    sband->bitrates[i].bitrate == 110 ||
> -			    sband->bitrates[i].bitrate == 60 ||
> +			if (sband->bitrates[i].bitrate == 60 ||
>   			    sband->bitrates[i].bitrate == 120 ||
>   			    sband->bitrates[i].bitrate == 240) {
>   				sband->bitrates[i].flags |=
> @@ -125,7 +125,7 @@ static void set_mandatory_flags_band(struct ieee80211_supported_band *sband,
>   				sband->bitrates[i].flags |=
>   					IEEE80211_RATE_ERP_G;
>   		}
> -		WARN_ON(want != 0&&  want != 3&&  want != 6);
> +		WARN_ON(want != 0&&  want != 3);
>   		break;
>   	case IEEE80211_NUM_BANDS:
>   		WARN_ON(1);
>

Acked-by: Benoit Papillault <benoit.papillault@free.fr>

Regards,
Benoit
