Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([144.76.63.242]:35094 "EHLO
        sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751106AbeC2IwK (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 29 Mar 2018 04:52:10 -0400
Message-ID: <1522313528.5932.1.camel@sipsolutions.net> (sfid-20180329_105213_649908_92D8C66F)
Subject: Re: [PATCH v3 2/3] mac80211: limit wmm params to comply with ETSI
 requirements
From: Johannes Berg <johannes@sipsolutions.net>
To: Luca Coelho <luca@coelho.fi>
Cc: linux-wireless@vger.kernel.org,
        Haim Dreyfuss <haim.dreyfuss@intel.com>,
        Luca Coelho <luciano.coelho@intel.com>
Date: Thu, 29 Mar 2018 10:52:08 +0200
In-Reply-To: <20180328102411.25677-3-luca@coelho.fi>
References: <20180328102411.25677-1-luca@coelho.fi>
         <20180328102411.25677-3-luca@coelho.fi>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 2018-03-28 at 13:24 +0300, Luca Coelho wrote:
> 
> --- a/net/wireless/reg.c
> +++ b/net/wireless/reg.c
> @@ -135,12 +135,12 @@ static void restore_regulatory_settings(bool reset_user);
>  
>  static const struct ieee80211_regdomain *get_cfg80211_regdom(void)
>  {
> -	return rtnl_dereference(cfg80211_regdomain);
> +	return rcu_dereference_rtnl(cfg80211_regdomain);
>  }
>  
>  const struct ieee80211_regdomain *get_wiphy_regdom(struct wiphy *wiphy)
>  {
> -	return rtnl_dereference(wiphy->regd);
> +	return rcu_dereference_rtnl(wiphy->regd);
>  }
>  
>  static const char *reg_dfs_region_str(enum nl80211_dfs_regions dfs_region)

This should've stayed a separate commit, I'll take that from our tree.

johannes
