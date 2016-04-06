Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:36216 "EHLO sipsolutions.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933756AbcDFJYM (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 6 Apr 2016 05:24:12 -0400
Message-ID: <1459934648.17504.65.camel@sipsolutions.net> (sfid-20160406_112416_050221_F23692EF)
Subject: Re: [PATCHv3 RESEND 10/11] mac80211: Add API to report nan function
 match
From: Johannes Berg <johannes@sipsolutions.net>
To: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Cc: linux-wireless@vger.kernel.org,
	Andrei Otcheretianski <andrei.otcheretianski@intel.com>
Date: Wed, 06 Apr 2016 11:24:08 +0200
In-Reply-To: <1459244109-16038-10-git-send-email-emmanuel.grumbach@intel.com>
References: <1459244109-16038-1-git-send-email-emmanuel.grumbach@intel.com>
	 <1459244109-16038-10-git-send-email-emmanuel.grumbach@intel.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, 2016-03-29 at 12:35 +0300, Emmanuel Grumbach wrote:
> 
> +void ieee80211_nan_func_match(struct ieee80211_vif *vif,
> +			      struct cfg80211_nan_match_params
> *match,
> +			      gfp_t gfp)
> +{
> +	struct ieee80211_sub_if_data *sdata = vif_to_sdata(vif);
> +	struct ieee80211_nan_func *func;
> +	struct wireless_dev *wdev;
> +
> +	if (WARN_ON(vif->type != NL80211_IFTYPE_NAN))
> +		return;
> +
> +	spin_lock_bh(&sdata->u.nan.func_lock);
> +
> +	func = ieee80211_find_nan_func(sdata, match->inst_id);
> +	if (WARN_ON(!func)) {
> +		spin_unlock_bh(&sdata->u.nan.func_lock);
> +		return;
> +	}
> +	match->cookie = func->func.cookie;
> 
Ok maybe this requires a spinlock - due to how drivers want to call it
- but could also use RCU? Particularly with IDR that shouldn't be
difficult.

johannes
