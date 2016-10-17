Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:49564 "EHLO sipsolutions.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752123AbcJQJo0 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 17 Oct 2016 05:44:26 -0400
Message-ID: <1476697463.19992.18.camel@sipsolutions.net> (sfid-20161017_114430_020664_6F8DBBE8)
Subject: Re: [PATCHv5 2/2] mac80211: fix A-MSDU outer SA/DA
From: Johannes Berg <johannes@sipsolutions.net>
To: Michael Braun <michael-dev@fami-braun.de>
Cc: linux-wireless@vger.kernel.org, projekt-wlan@fem.tu-ilmenau.de,
        Felix Fietkau <nbd@openwrt.org>
Date: Mon, 17 Oct 2016 11:44:23 +0200
In-Reply-To: <1476530899-24241-2-git-send-email-michael-dev@fami-braun.de>
References: <1476530899-24241-1-git-send-email-michael-dev@fami-braun.de>
         <1476530899-24241-2-git-send-email-michael-dev@fami-braun.de>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sat, 2016-10-15 at 13:28 +0200, Michael Braun wrote:
> According to IEEE 802.11-2012 section 8.3.2 table 8-19, the outer
> SA/DA
> of A-MSDU frames need to be changed depending on FromDS/ToDS values.

Also applied,

> +	if (bssid && ieee80211_has_fromds(hdr->frame_control))
> +		memcpy(h_80211_src, bssid, ETH_ALEN);
> +
> +	if (bssid && ieee80211_has_tods(hdr->frame_control))
> +		memcpy(h_80211_dst, bssid, ETH_ALEN);

but I also changed these to ether_addr_copy()

johannes
