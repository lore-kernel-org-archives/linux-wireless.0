Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pw0-f46.google.com ([209.85.160.46]:58468 "EHLO
	mail-pw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754164Ab0FPCUQ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 15 Jun 2010 22:20:16 -0400
Received: by pwi1 with SMTP id 1so3645832pwi.19
        for <linux-wireless@vger.kernel.org>; Tue, 15 Jun 2010 19:20:16 -0700 (PDT)
Message-ID: <4C1834F0.2050001@gmail.com>
Date: Tue, 15 Jun 2010 19:20:32 -0700
From: "Justin P. Mattock" <justinmattock@gmail.com>
MIME-Version: 1.0
To: "Luis R. Rodriguez" <lrodriguez@atheros.com>
CC: stable@kernel.org, greg@kroah.com, linux-wireless@vger.kernel.org,
	Peter Stuge <peter@stuge.se>,
	Kristoffer Ericson <kristoffer.ericson@gmail.com>,
	"John W. Linville" <linville@tuxdriver.com>
Subject: Re: [PATCH 2.6.32.y] ath9k: re-enable ps by default for new single
 chip families
References: <1276640359-25360-1-git-send-email-lrodriguez@atheros.com>
In-Reply-To: <1276640359-25360-1-git-send-email-lrodriguez@atheros.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 06/15/2010 03:19 PM, Luis R. Rodriguez wrote:
> commit 14acdde6e527950f66c084dbf19bad6fbfcaeedc upstream.
>
> The newer single chip hardware family of chipsets have not been
> experiencing issues with power saving set by default with recent
> fixes merged (even into stable). The remaining issues are only
> reported with AR5416 and since enabling PS by default can increase
> power savings considerably best to take advantage of that feature
> as this has been tested properly.
>
> For more details on this issue see the bug report:
>
> http://bugzilla.kernel.org/show_bug.cgi?id=14267
>
> We leave AR5416 with PS disabled by default, that seems to require
> some more work.
>
> Cc: stable@kernel.org
> Cc: Peter Stuge<peter@stuge.se>
> Cc: Justin P. Mattock<justinmattock@gmail.com>
> Cc: Kristoffer Ericson<kristoffer.ericson@gmail.com>
> Signed-off-by: Luis R. Rodriguez<lrodriguez@atheros.com>
> Signed-off-by: John W. Linville<linville@tuxdriver.com>
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
>   drivers/net/wireless/ath/ath9k/main.c |    7 ++++++-
>   1 files changed, 6 insertions(+), 1 deletions(-)
>
> diff --git a/drivers/net/wireless/ath/ath9k/main.c b/drivers/net/wireless/ath/ath9k/main.c
> index 15eb245..dba27b7 100644
> --- a/drivers/net/wireless/ath/ath9k/main.c
> +++ b/drivers/net/wireless/ath/ath9k/main.c
> @@ -1538,6 +1538,8 @@ bad_no_ah:
>
>   void ath_set_hw_capab(struct ath_softc *sc, struct ieee80211_hw *hw)
>   {
> +	struct ath_hw *ah = sc->sc_ah;
> +
>   	hw->flags = IEEE80211_HW_RX_INCLUDES_FCS |
>   		IEEE80211_HW_HOST_BROADCAST_PS_BUFFERING |
>   		IEEE80211_HW_SIGNAL_DBM |
> @@ -1556,7 +1558,10 @@ void ath_set_hw_capab(struct ath_softc *sc, struct ieee80211_hw *hw)
>   		BIT(NL80211_IFTYPE_ADHOC) |
>   		BIT(NL80211_IFTYPE_MESH_POINT);
>
> -	hw->wiphy->ps_default = false;
> +	if (AR_SREV_5416(ah))
> +		hw->wiphy->ps_default = false;
> +	else
> +		hw->wiphy->ps_default = true;
>
>   	hw->queues = 4;
>   	hw->max_rates = 4;

I'll have to check and see if my machine run's properly with the 
powersaving tuned on..

Justin P. Mattock
