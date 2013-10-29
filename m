Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtprelay0038.hostedemail.com ([216.40.44.38]:35770 "EHLO
	smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751292Ab3J2Wvm (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 29 Oct 2013 18:51:42 -0400
Message-ID: <1383087091.12439.33.camel@joe-AO722> (sfid-20131029_235145_637334_8F7F320B)
Subject: Re: [PATCH 3/3] ath: fix dynamic user regulatory domain support
From: Joe Perches <joe@perches.com>
To: "Luis R. Rodriguez" <mcgrof@do-not-panic.com>
Cc: linville@tuxdriver.com, johannes@sipsolutions.net,
	linux-wireless@vger.kernel.org
Date: Tue, 29 Oct 2013 15:51:31 -0700
In-Reply-To: <1383086346-2096-4-git-send-email-mcgrof@do-not-panic.com>
References: <1383086346-2096-1-git-send-email-mcgrof@do-not-panic.com>
	 <1383086346-2096-4-git-send-email-mcgrof@do-not-panic.com>
Content-Type: text/plain; charset="ISO-8859-1"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, 2013-10-29 at 23:39 +0100, Luis R. Rodriguez wrote:
> As it stands dynamic user regulatory domain support is
> only possible for a few programmed regulatory domains as
> a few countries do not allow for this.
[]
> diff --git a/drivers/net/wireless/ath/regd.c b/drivers/net/wireless/ath/regd.c
][
> @@ -296,6 +296,7 @@ static void ath_force_no_ir_freq(struct wiphy *wiphy, u16 center_freq)
>  
>  static void
>  __ath_reg_apply_beaconing_flags(struct wiphy *wiphy,
> +				struct ath_regulatory *reg,
>  				enum nl80211_reg_initiator initiator,
>  				struct ieee80211_channel *ch)
>  {
> @@ -307,6 +308,9 @@ __ath_reg_apply_beaconing_flags(struct wiphy *wiphy,
>  	case NL80211_REGDOM_SET_BY_COUNTRY_IE:
>  		ath_force_clear_no_ir_chan(wiphy, ch);
>  		break;
> +	case NL80211_REGDOM_SET_BY_USER:
> +		if (ath_reg_dyn_country_user_allow(reg))
> +			ath_force_clear_no_ir_chan(wiphy, ch);

Nicer to add explicit /* fallthrough */

>  	default:
>  		if (ch->beacon_found)
>  			ch->flags &= ~IEEE80211_CHAN_NO_IR;

> @@ -370,6 +376,11 @@ ath_reg_apply_ir_flags(struct wiphy *wiphy,
>  		ath_force_clear_no_ir_freq(wiphy, 2467);
>  		ath_force_clear_no_ir_freq(wiphy, 2472);
>  		break;
> +	case NL80211_REGDOM_SET_BY_USER:
> +		if (!ath_reg_dyn_country_user_allow(reg))
> +			break;
> +		ath_force_clear_no_ir_freq(wiphy, 2467);
> +		ath_force_clear_no_ir_freq(wiphy, 2472);

Missing break?

>  	default:
>  		ath_force_no_ir_freq(wiphy, 2467);
>  		ath_force_no_ir_freq(wiphy, 2472);


