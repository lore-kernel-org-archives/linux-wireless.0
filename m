Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([144.76.63.242]:35760 "EHLO
        sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754485AbeF2Jj3 (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 29 Jun 2018 05:39:29 -0400
Message-ID: <1530265167.3481.45.camel@sipsolutions.net> (sfid-20180629_113933_973790_31892D21)
Subject: Re: [PATCH 6/7] cfg80211: Accept multiple RSSI threholds for
 STA_MON command
From: Johannes Berg <johannes@sipsolutions.net>
To: Tamizh chelvam <tamizhr@codeaurora.org>
Cc: linux-wireless@vger.kernel.org
Date: Fri, 29 Jun 2018 11:39:27 +0200
In-Reply-To: <1528886747-26342-7-git-send-email-tamizhr@codeaurora.org>
References: <1528886747-26342-1-git-send-email-tamizhr@codeaurora.org>
         <1528886747-26342-7-git-send-email-tamizhr@codeaurora.org>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 2018-06-13 at 16:15 +0530, Tamizh chelvam wrote:
> Change the NL80211_CMD_STA_MON RSSI threshold attribut to

This seems weird - you just introduced it a few patches back, and now
you change it and even worry about compatibility and have both cfg80211
callbacks etc. Just remove set_sta_mon_rssi_config() and ask that
drivers/mac80211 implement set_sta_mon_rssi_range_config?

>   * @NL80211_EXT_FEATURE_STA_MON_RSSI_CONFIG: With this driver can set
>   *	rssi threshold using %NL80211_ATTR_STA_MON_RSSI_THOLD attribute
>   *	for a connected station.
> + * @NL80211_EXT_FEATURE_STA_MON_RSSI_LIST: With this driver the
> + *	%NL80211_ATTR_STA_MON_RSSI_THOLD attribute accepts a list of zero or
> + *	more RSSI threshold values to monitor rather than exactly one threshold.

And maybe not have two bits here either?

Or do you expect somebody to actually really need the single threshold
in the near future? It seems you're implementing it for mac80211 only,
which doesn't care.

johannes
