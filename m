Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ww0-f46.google.com ([74.125.82.46]:57840 "EHLO
	mail-ww0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751143Ab0FPILY (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 16 Jun 2010 04:11:24 -0400
Received: by wwb18 with SMTP id 18so5419591wwb.19
        for <linux-wireless@vger.kernel.org>; Wed, 16 Jun 2010 01:11:21 -0700 (PDT)
Date: Wed, 16 Jun 2010 10:12:27 +0200
From: Kristoffer Ericson <kristoffer.ericson@gmail.com>
To: "Luis R. Rodriguez" <lrodriguez@atheros.com>
Cc: stable@kernel.org, greg@kroah.com, linux-wireless@vger.kernel.org,
	Peter Stuge <peter@stuge.se>,
	"Justin P. Mattock" <justinmattock@gmail.com>,
	"John W. Linville" <linville@tuxdriver.com>
Subject: Re: [PATCH 2.6.32.y] ath9k: re-enable ps by default for new single
 chip families
Message-ID: <20100616081227.GA1118@boggieman>
Reply-To: Kristoffer Ericson <kristoffer.ericson@gmail.com>
References: <1276640359-25360-1-git-send-email-lrodriguez@atheros.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
In-Reply-To: <1276640359-25360-1-git-send-email-lrodriguez@atheros.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, Jun 15, 2010 at 06:19:19PM -0400, Luis R. Rodriguez wrote:
> commit 14acdde6e527950f66c084dbf19bad6fbfcaeedc upstream.
> 
> The newer single chip hardware family of chipsets have not been
> experiencing issues with power saving set by default with recent
> fixes merged (even into stable). The remaining issues are only
> reported with AR5416 and since enabling PS by default can increase
> power savings considerably best to take advantage of that feature
> as this has been tested properly.

I havent had any issues lately. But that said Ive moved on to
2.6.33, 2.6.34 which seems to work fine. Believe you set
to disabled by default on those?

/Kristoffer

> 
> For more details on this issue see the bug report:
> 
> http://bugzilla.kernel.org/show_bug.cgi?id=14267
> 
> We leave AR5416 with PS disabled by default, that seems to require
> some more work.
> 
> Cc: stable@kernel.org
> Cc: Peter Stuge <peter@stuge.se>
> Cc: Justin P. Mattock  <justinmattock@gmail.com>
> Cc: Kristoffer Ericson <kristoffer.ericson@gmail.com>
> Signed-off-by: Luis R. Rodriguez <lrodriguez@atheros.com>
> Signed-off-by: John W. Linville <linville@tuxdriver.com>
> ---
> 
> Greg, this is the long promised backport of the patch titled
> "ath9k: re-enable ps by default for new single chip families" backported
> down to 2.6.32.y. This just goes test compiled. Manual backport
> was required from the upstream Linus patch since the flag
> WIPHY_FLAG_PS_ON_BY_DEFAULT was not used back on 2.6.32 so instead
> we use the equivalent hw->wiphy->ps_default bool.
> 
> Apologies for the delay, was just stuck with other stuff.
> 
> I'll remove this from the stable pending list for 802.11 [1] once
> this gets sucked in.
> 
> [1] http://wireless.kernel.org/en/developers/stable-pending
> 
>  drivers/net/wireless/ath/ath9k/main.c |    7 ++++++-
>  1 files changed, 6 insertions(+), 1 deletions(-)
> 
> diff --git a/drivers/net/wireless/ath/ath9k/main.c b/drivers/net/wireless/ath/ath9k/main.c
> index 15eb245..dba27b7 100644
> --- a/drivers/net/wireless/ath/ath9k/main.c
> +++ b/drivers/net/wireless/ath/ath9k/main.c
> @@ -1538,6 +1538,8 @@ bad_no_ah:
>  
>  void ath_set_hw_capab(struct ath_softc *sc, struct ieee80211_hw *hw)
>  {
> +	struct ath_hw *ah = sc->sc_ah;
> +
>  	hw->flags = IEEE80211_HW_RX_INCLUDES_FCS |
>  		IEEE80211_HW_HOST_BROADCAST_PS_BUFFERING |
>  		IEEE80211_HW_SIGNAL_DBM |
> @@ -1556,7 +1558,10 @@ void ath_set_hw_capab(struct ath_softc *sc, struct ieee80211_hw *hw)
>  		BIT(NL80211_IFTYPE_ADHOC) |
>  		BIT(NL80211_IFTYPE_MESH_POINT);
>  
> -	hw->wiphy->ps_default = false;
> +	if (AR_SREV_5416(ah))
> +		hw->wiphy->ps_default = false;
> +	else
> +		hw->wiphy->ps_default = true;
>  
>  	hw->queues = 4;
>  	hw->max_rates = 4;
> -- 
> 1.6.3.3
