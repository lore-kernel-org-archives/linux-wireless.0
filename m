Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.atheros.com ([12.19.149.2]:58198 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755060Ab0I3Vnj (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 30 Sep 2010 17:43:39 -0400
Received: from mail.atheros.com ([10.10.20.105])
	by sidewinder.atheros.com
	for <linux-wireless@vger.kernel.org>; Thu, 30 Sep 2010 14:43:31 -0700
Date: Thu, 30 Sep 2010 14:43:37 -0700
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
To: Bill Jordan <bjordan@rajant.com>
CC: "John W. Linville" <linville@tuxdriver.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	Luis Rodriguez <Luis.Rodriguez@Atheros.com>
Subject: Re: [PATCH] ath9k: Enable WDS for the ath9k
Message-ID: <20100930214337.GB8930@tux>
References: <AANLkTi=cN7ZKa488MmXYDu_ywW95E8TcqJW4yfyKr0JR@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
In-Reply-To: <AANLkTi=cN7ZKa488MmXYDu_ywW95E8TcqJW4yfyKr0JR@mail.gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, Sep 30, 2010 at 02:29:37PM -0700, Bill Jordan wrote:
> As requested, I'm breaking up my previous patch.

Please resubmit but remove this verbose stuff above.
> 
> This patch enables WDS for the ath9k driver.
> 
> For WDS to fully work, patches to mac80211 are also needed
> (submitted separately).

and this too.

> Signed-off-by: Bill Jordan <bjordan@rajant.com>
> ---

If you want to add verbose messages that should not
be part of the commit log entry add them here after
the three dashes ("---").

  Luis

>  drivers/net/wireless/ath/ath9k/init.c |    1 +
>  drivers/net/wireless/ath/ath9k/main.c |    3 +++
>  2 files changed, 4 insertions(+), 0 deletions(-)
> 
> diff --git a/drivers/net/wireless/ath/ath9k/init.c
> b/drivers/net/wireless/ath/ath9k/init.c
> index de33938..c2792c9 100644
> --- a/drivers/net/wireless/ath/ath9k/init.c
> +++ b/drivers/net/wireless/ath/ath9k/init.c
> @@ -639,6 +639,7 @@ void ath9k_set_hw_capab(struct ath_softc *sc,
> struct ieee80211_hw *hw)
> 
>  	hw->wiphy->interface_modes =
>  		BIT(NL80211_IFTYPE_AP) |
> +		BIT(NL80211_IFTYPE_WDS) |
>  		BIT(NL80211_IFTYPE_STATION) |
>  		BIT(NL80211_IFTYPE_ADHOC) |
>  		BIT(NL80211_IFTYPE_MESH_POINT);
> diff --git a/drivers/net/wireless/ath/ath9k/main.c
> b/drivers/net/wireless/ath/ath9k/main.c
> index a133878..d67067f 100644
> --- a/drivers/net/wireless/ath/ath9k/main.c
> +++ b/drivers/net/wireless/ath/ath9k/main.c
> @@ -1384,6 +1384,9 @@ static int ath9k_add_interface(struct ieee80211_hw *hw,
>  	case NL80211_IFTYPE_STATION:
>  		ic_opmode = NL80211_IFTYPE_STATION;
>  		break;
> +	case NL80211_IFTYPE_WDS:
> +		ic_opmode = NL80211_IFTYPE_WDS;
> +		break;
>  	case NL80211_IFTYPE_ADHOC:
>  	case NL80211_IFTYPE_AP:
>  	case NL80211_IFTYPE_MESH_POINT:
> -- 
> 1.7.2.3
