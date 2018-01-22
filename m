Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([144.76.63.242]:45822 "EHLO
        sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751086AbeAVM4t (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 22 Jan 2018 07:56:49 -0500
Message-ID: <1516625807.2508.22.camel@sipsolutions.net> (sfid-20180122_135652_370374_93485EB8)
Subject: Re: [PATCH 2/4] cfg80211: enable setting cqm config for AP mode
From: Johannes Berg <johannes@sipsolutions.net>
To: tamizhr@codeaurora.org
Cc: linux-wireless@vger.kernel.org, tamizhr@qti.qualcomm.com,
        Pradeep Kumar Chitrapu <pradeepc@codeaurora.org>
Date: Mon, 22 Jan 2018 13:56:47 +0100
In-Reply-To: <1516174276-16789-3-git-send-email-tamizhr@codeaurora.org>
References: <1516174276-16789-1-git-send-email-tamizhr@codeaurora.org>
         <1516174276-16789-3-git-send-email-tamizhr@codeaurora.org>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 2018-01-17 at 13:01 +0530, tamizhr@codeaurora.org wrote:
> From: Pradeep Kumar Chitrapu <pradeepc@codeaurora.org>
> 
> Enable connection monitoring for AP mode which makes it possible to
> track signal strength of connected stations.

>  	if (wdev->iftype != NL80211_IFTYPE_STATION &&
> -	    wdev->iftype != NL80211_IFTYPE_P2P_CLIENT)
> +	    wdev->iftype != NL80211_IFTYPE_P2P_CLIENT &&
> +	    wdev->iftype != NL80211_IFTYPE_AP &&
> +	    wdev->iftype != NL80211_IFTYPE_P2P_GO &&
> +	    wdev->iftype != NL80211_IFTYPE_AP_VLAN)
>  		return -EOPNOTSUPP;
> 
This seems problematic - you'll probably need a driver support flag for
this. And since clients might want to know whether this works or not,
just make that an nl80211 extended feature bit?

johannes
