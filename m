Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nbd.name ([88.198.39.176]:47297 "EHLO ds10.mine.nu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750945AbYLVPLh (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 22 Dec 2008 10:11:37 -0500
Message-ID: <494FAE25.6000401@openwrt.org> (sfid-20081222_161145_024525_E06B6FDC)
Date: Mon, 22 Dec 2008 16:11:33 +0100
From: Felix Fietkau <nbd@openwrt.org>
MIME-Version: 1.0
To: Christian Lamparter <chunkeey@web.de>
CC: wireless <linux-wireless@vger.kernel.org>,
	John W Linville <linville@tuxdriver.com>,
	Johannes Berg <johannes@sipsolutions.net>
Subject: Re: [PATCH] minstrel: fix warning if lowest supported rate index
 is not 0
References: <200812221535.32032.chunkeey@web.de>
In-Reply-To: <200812221535.32032.chunkeey@web.de>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Christian Lamparter wrote:
> This patch fixes the following WARNING (caused by rix_to_ndx): "
>>WARNING: at net/mac80211/rc80211_minstrel.c:69 minstrel_rate_init+0xd2/0x33a [mac80211]()
>>[...]
>>Call Trace:
>> warn_on_slowpath+0x51/0x75
>> _format_mac_addr+0x4c/0x88
>> minstrel_rate_init+0xd2/0x33a [mac80211]
>> print_mac+0x16/0x1b
>> schedule_hrtimeout_range+0xdc/0x107
>> ieee80211_add_station+0x158/0x1bd [mac80211]
>> nl80211_new_station+0x1b3/0x20b [cfg80211]
> 
> The reason is that I'm experimenting with "g" only mode on a 802.11 b/g card.
> 
> Therefore rate_lowest_index returns 4 (= 6Mbit, instead of usual 0 = 1Mbit).
> Since mi->r array is initialized with zeros in minstrel_alloc_sta,
> rix_to_ndx has a hard time to find the 6Mbit entry and will trigged the WARNING.
> 
> Signed-off-by: Christian Lamparter <chunkeey@web.de>
Acked-by: Felix Fietkau <nbd@openwrt.org>
