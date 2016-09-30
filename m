Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:41180 "EHLO sipsolutions.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S933265AbcI3HUo (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 30 Sep 2016 03:20:44 -0400
Message-ID: <1475220037.17481.3.camel@sipsolutions.net> (sfid-20160930_092056_454534_C8F7DF11)
Subject: Re: [PATCH 1/3] mac80211: filter multicast data packets on AP /
 AP_VLAN
From: Johannes Berg <johannes@sipsolutions.net>
To: Michael Braun <michael-dev@fami-braun.de>
Cc: linux-wireless@vger.kernel.org
Date: Fri, 30 Sep 2016 09:20:37 +0200
In-Reply-To: <1474821596-12155-2-git-send-email-michael-dev@fami-braun.de> (sfid-20160925_184004_593715_152E8F66)
References: <1474821596-12155-1-git-send-email-michael-dev@fami-braun.de>
         <1474821596-12155-2-git-send-email-michael-dev@fami-braun.de>
         (sfid-20160925_184004_593715_152E8F66)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

[snip]

I think this makes sense, but it's not clear to me why you add two
counters and keep the old one? It seems to me that it would be
sufficient to have a single counter per AP/VLAN interface?

The usage in __ieee80211_request_smps_ap() can just be removed since it
goes to iterate the stations next. That should be a separate, first,
patch in the series, but after that I don't see a need to keep
num_mcast_sta, or rather, I see no reason not to remove the VLAN
stations from the AP's num_mcast_sta, and add a new per-VLAN
num_mcast_sta.

> +/**
> + * @returns number of multicast stations connected
> + *  -1 if unsupported (no-AP, 4addr mode)
> + */
> +static inline int
> +ieee80211_vif_get_num_mcast_if(struct ieee80211_sub_if_data *sdata)

That's not a valid kernel-doc comment, but you've tagged it as one with
the /** - please fix by removing the /** and the @, and writing a real
sentence out of that, or by making it a real kernel-doc comment.

johannes
