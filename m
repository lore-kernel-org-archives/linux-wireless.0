Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:48334 "EHLO sipsolutions.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1755956AbdDRKuG (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 18 Apr 2017 06:50:06 -0400
Message-ID: <1492512604.2472.20.camel@sipsolutions.net> (sfid-20170418_125009_969366_CDE58AB4)
Subject: Re: [PATCH V2 3/3] cfg80211: Share Channel DFS state across wiphys
 of same DFS domain
From: Johannes Berg <johannes@sipsolutions.net>
To: Vasanthakumar Thiagarajan <vthiagar@qti.qualcomm.com>
Cc: linux-wireless@vger.kernel.org, Jouni Malinen <j@w1.fi>
Date: Tue, 18 Apr 2017 12:50:04 +0200
In-Reply-To: <1488195275-29371-4-git-send-email-vthiagar@qti.qualcomm.com>
References: <1488195275-29371-1-git-send-email-vthiagar@qti.qualcomm.com>
         <1488195275-29371-4-git-send-email-vthiagar@qti.qualcomm.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


> +void regulatory_propagate_dfs_state(struct wiphy *wiphy,
> +				    struct cfg80211_chan_def
> *chandef,
> +				    enum nl80211_dfs_state
> dfs_state,
> +				    enum nl80211_radar_event event)
> +{
> +	struct cfg80211_registered_device *rdev;
> +
> +	ASSERT_RTNL();
> +
> +	if (WARN_ON(!cfg80211_chandef_valid(chandef)))
> +		return;
> +
> +	if (WARN_ON(!(chandef->chan->flags & IEEE80211_CHAN_RADAR)))
> +		return;


This warn on reliably triggers for me when I run the "ap_vht160" hwsim
test from wpa_supplicant.

I think there might be some confusion about this when parts of the 160
MHz channel require radar and parts don't? But I haven't looked into
this at all.

Please send me a fix ASAP so Jouni doesn't shout at me for test
failures :)

johannes
