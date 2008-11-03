Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx2.redhat.com ([66.187.237.31]:57129 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753968AbYKCBqy (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sun, 2 Nov 2008 20:46:54 -0500
Subject: Re: [PATCH] ath5k: enable RXing beacons
From: Dan Williams <dcbw@redhat.com>
To: "Luis R. Rodriguez" <lrodriguez@atheros.com>
Cc: linville@tuxdriver.com, linux-wireless@vger.kernel.org
In-Reply-To: <1225672612-15106-1-git-send-email-lrodriguez@atheros.com>
References: <1225672612-15106-1-git-send-email-lrodriguez@atheros.com>
Content-Type: text/plain
Date: Sun, 02 Nov 2008 20:39:13 -0500
Message-Id: <1225676353.13684.2.camel@localhost.localdomain> (sfid-20081103_024659_278755_58969E57)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sun, 2008-11-02 at 16:36 -0800, Luis R. Rodriguez wrote:
> Prior to this we would rely only on probe responses
> from the AP to keep associated. We now receive beacons
> on ath5k. This should fix sporadic disassociations.
> 
> Signed-off-by: Luis R. Rodriguez <lrodriguez@atheros.com>

Is this also a candidate for -stable?

> ---
>  drivers/net/wireless/ath5k/base.c |    2 ++
>  1 files changed, 2 insertions(+), 0 deletions(-)
> 
> diff --git a/drivers/net/wireless/ath5k/base.c b/drivers/net/wireless/ath5k/base.c
> index f5f46fe..5505f45 100644
> --- a/drivers/net/wireless/ath5k/base.c
> +++ b/drivers/net/wireless/ath5k/base.c
> @@ -2948,6 +2948,8 @@ static void ath5k_configure_filter(struct ieee80211_hw *hw,
>  			AR5K_RX_FILTER_PROBEREQ | AR5K_RX_FILTER_PROM;
>  	if (sc->opmode != NL80211_IFTYPE_STATION)
>  		rfilt |= AR5K_RX_FILTER_PROBEREQ;
> +	if (sc->opmode == NL80211_IFTYPE_STATION)
> +		rfilt |= AR5K_RX_FILTER_BEACON;
>  	if (sc->opmode != NL80211_IFTYPE_AP &&
>  		sc->opmode != NL80211_IFTYPE_MESH_POINT &&
>  		test_bit(ATH_STAT_PROMISC, sc->status))

