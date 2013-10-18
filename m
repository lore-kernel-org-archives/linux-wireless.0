Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from charlotte.tuxdriver.com ([70.61.120.58]:42185 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756397Ab3JRSPe (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 18 Oct 2013 14:15:34 -0400
Date: Fri, 18 Oct 2013 14:01:07 -0400
From: "John W. Linville" <linville@tuxdriver.com>
To: "Luis R. Rodriguez" <mcgrof@do-not-panic.com>
Cc: johannes@sipsolutions.net, linux-wireless@vger.kernel.org
Subject: Re: [PATCH 1/6] cfg80211: export reg_initiator_name()
Message-ID: <20131018180107.GG28130@tuxdriver.com> (sfid-20131018_201539_095853_034BB2CC)
References: <1381797731-2454-1-git-send-email-mcgrof@do-not-panic.com>
 <1381797731-2454-2-git-send-email-mcgrof@do-not-panic.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1381797731-2454-2-git-send-email-mcgrof@do-not-panic.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

I'm going to merge this series, including the cfg80211.h change...FYI!

On Mon, Oct 14, 2013 at 05:42:06PM -0700, Luis R. Rodriguez wrote:
> Drivers can now use this to parse the regulatory request and
> be more verbose when needed.
> 
> Signed-off-by: Luis R. Rodriguez <mcgrof@do-not-panic.com>
> ---
>  include/net/cfg80211.h |  9 +++++++++
>  net/wireless/reg.c     | 27 +++++++++++++++++----------
>  2 files changed, 26 insertions(+), 10 deletions(-)
> 
> diff --git a/include/net/cfg80211.h b/include/net/cfg80211.h
> index 45f6bf5..419202c 100644
> --- a/include/net/cfg80211.h
> +++ b/include/net/cfg80211.h
> @@ -3483,6 +3483,15 @@ void wiphy_apply_custom_regulatory(struct wiphy *wiphy,
>  const struct ieee80211_reg_rule *freq_reg_info(struct wiphy *wiphy,
>  					       u32 center_freq);
>  
> +/**
> + * reg_initiator_name - map regulatory request initiator enum to name
> + * @initiator: the regulatory request initiator
> + *
> + * You can use this to map the regulatory request initiator enum to a
> + * proper string representation.
> + */
> +const char *reg_initiator_name(enum nl80211_reg_initiator initiator);
> +
>  /*
>   * callbacks for asynchronous cfg80211 methods, notification
>   * functions and BSS handling helpers
> diff --git a/net/wireless/reg.c b/net/wireless/reg.c
> index edb2ba4e..9851a2b 100644
> --- a/net/wireless/reg.c
> +++ b/net/wireless/reg.c
> @@ -768,23 +768,25 @@ const struct ieee80211_reg_rule *freq_reg_info(struct wiphy *wiphy,
>  }
>  EXPORT_SYMBOL(freq_reg_info);
>  
> -#ifdef CONFIG_CFG80211_REG_DEBUG
> -static const char *reg_initiator_name(enum nl80211_reg_initiator initiator)
> +const char *reg_initiator_name(enum nl80211_reg_initiator initiator)
>  {
>  	switch (initiator) {
>  	case NL80211_REGDOM_SET_BY_CORE:
> -		return "Set by core";
> +		return "core";
>  	case NL80211_REGDOM_SET_BY_USER:
> -		return "Set by user";
> +		return "user";
>  	case NL80211_REGDOM_SET_BY_DRIVER:
> -		return "Set by driver";
> +		return "driver";
>  	case NL80211_REGDOM_SET_BY_COUNTRY_IE:
> -		return "Set by country IE";
> +		return "country IE";
>  	default:
>  		WARN_ON(1);
> -		return "Set by bug";
> +		return "bug";
>  	}
>  }
> +EXPORT_SYMBOL(reg_initiator_name);
> +
> +#ifdef CONFIG_CFG80211_REG_DEBUG
>  
>  static void chan_reg_rule_print_dbg(struct ieee80211_channel *chan,
>  				    const struct ieee80211_reg_rule *reg_rule)
> @@ -986,14 +988,17 @@ static bool ignore_reg_update(struct wiphy *wiphy,
>  	struct regulatory_request *lr = get_last_request();
>  
>  	if (!lr) {
> -		REG_DBG_PRINT("Ignoring regulatory request %s since last_request is not set\n",
> +		REG_DBG_PRINT("Ignoring regulatory request set by %s "
> +			      "since last_request is not set\n",
>  			      reg_initiator_name(initiator));
>  		return true;
>  	}
>  
>  	if (initiator == NL80211_REGDOM_SET_BY_CORE &&
>  	    wiphy->flags & WIPHY_FLAG_CUSTOM_REGULATORY) {
> -		REG_DBG_PRINT("Ignoring regulatory request %s since the driver uses its own custom regulatory domain\n",
> +		REG_DBG_PRINT("Ignoring regulatory request set by %s "
> +			      "since the driver uses its own custom "
> +			      "regulatory domain\n",
>  			      reg_initiator_name(initiator));
>  		return true;
>  	}
> @@ -1005,7 +1010,9 @@ static bool ignore_reg_update(struct wiphy *wiphy,
>  	if (wiphy_strict_alpha2_regd(wiphy) && !wiphy->regd &&
>  	    initiator != NL80211_REGDOM_SET_BY_COUNTRY_IE &&
>  	    !is_world_regdom(lr->alpha2)) {
> -		REG_DBG_PRINT("Ignoring regulatory request %s since the driver requires its own regulatory domain to be set first\n",
> +		REG_DBG_PRINT("Ignoring regulatory request set by %s "
> +			      "since the driver requires its own regulatory "
> +			      "domain to be set first\n",
>  			      reg_initiator_name(initiator));
>  		return true;
>  	}
> -- 
> 1.8.4.rc3
> 
> 

-- 
John W. Linville		Someday the world will need a hero, and you
linville@tuxdriver.com			might be all we have.  Be ready.
