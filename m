Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([144.76.63.242]:50636 "EHLO
        sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752783AbeBSNOM (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 19 Feb 2018 08:14:12 -0500
Message-ID: <1519046050.16723.8.camel@sipsolutions.net> (sfid-20180219_141427_720260_60554423)
Subject: Re: [PATCHv2 1/3] cfg80211: enable setting cqm rssi config for AP
 mode
From: Johannes Berg <johannes@sipsolutions.net>
To: Tamizh chelvam <tamizhr@codeaurora.org>
Cc: linux-wireless@vger.kernel.org
Date: Mon, 19 Feb 2018 14:14:10 +0100
In-Reply-To: <1518513656-22324-2-git-send-email-tamizhr@codeaurora.org>
References: <1518513656-22324-1-git-send-email-tamizhr@codeaurora.org>
         <1518513656-22324-2-git-send-email-tamizhr@codeaurora.org>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, 2018-02-13 at 14:50 +0530, Tamizh chelvam wrote:
> 
> @@ -9903,8 +9906,10 @@ static int nl80211_set_cqm_rssi(struct genl_info *info,
>  		prev = thresholds[i];
>  	}
>  
> -	if (wdev->iftype != NL80211_IFTYPE_STATION &&
> -	    wdev->iftype != NL80211_IFTYPE_P2P_CLIENT)
> +	if ((wdev->iftype != NL80211_IFTYPE_STATION &&
> +	     wdev->iftype != NL80211_IFTYPE_P2P_CLIENT &&
> +	     !wiphy_ext_feature_isset(&rdev->wiphy,
> +				NL80211_EXT_FEATURE_AP_STA_CQM_RSSI_CONFIG)))
>  		return -EOPNOTSUPP;

This enables for everything though - not sure we want that?

johannes
