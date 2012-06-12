Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-we0-f174.google.com ([74.125.82.174]:62481 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751976Ab2FLJkd (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 12 Jun 2012 05:40:33 -0400
Received: by weyu7 with SMTP id u7so2698262wey.19
        for <linux-wireless@vger.kernel.org>; Tue, 12 Jun 2012 02:40:32 -0700 (PDT)
From: Eliad Peller <eliad@wizery.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: <linux-wireless@vger.kernel.org>
Subject: [PATCH] mac80211: check sdata_running on ieee80211_set_bitrate_mask
Date: Tue, 12 Jun 2012 12:41:15 +0300
Message-Id: <1339494075-28068-1-git-send-email-eliad@wizery.com> (sfid-20120612_114044_023893_750D8C94)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Otherwise, we might call the driver callback before
the interface was uploaded.

Solves the following warning:
[64811.717315] WARNING: at net/mac80211/driver-ops.h:12 ieee80211_set_bitrate_mask+0xbc/0x18c [mac80211]()
[64811.727264] wlan0:  Failed check-sdata-in-driver check, flags: 0x0
[64811.733856] Modules linked in: wlcore_sdio wl12xx wl18xx wlcore mac80211 cfg80211 [last unloaded: cfg80211]
[64811.744232] [<c001b964>] (unwind_backtrace+0x0/0x12c) from [<c0495550>] (dump_stack+0x20/0x24)
[64811.753417] [<c0495550>] (dump_stack+0x20/0x24) from [<c003ee28>] (warn_slowpath_common+0x5c/0x74)
[64811.762939] [<c003ee28>] (warn_slowpath_common+0x5c/0x74) from [<c003eefc>] (warn_slowpath_fmt+0x40/0x48)
[64811.773284] [<c003eefc>] (warn_slowpath_fmt+0x40/0x48) from [<bf5c1ad0>] (ieee80211_set_bitrate_mask+0xbc/0x18c [mac80211])
[64811.785491] [<bf5c1ad0>] (ieee80211_set_bitrate_mask+0xbc/0x18c [mac80211]) from [<bf575960>] (nl80211_set_tx_bitrate_mask+0x350/0x358 [cfg80211])
[64811.799530] [<bf575960>] (nl80211_set_tx_bitrate_mask+0x350/0x358 [cfg80211]) from [<c03e9e94>] (genl_rcv_msg+0x1a8/0x1e8)
[64811.811248] [<c03e9e94>] (genl_rcv_msg+0x1a8/0x1e8) from [<c03e9164>] (netlink_rcv_skb+0x5c/0xc0)
[64811.820648] [<c03e9164>] (netlink_rcv_skb+0x5c/0xc0) from [<c03e9ce0>] (genl_rcv+0x28/0x34)
[64811.829467] [<c03e9ce0>] (genl_rcv+0x28/0x34) from [<c03e8e74>] (netlink_unicast+0x158/0x234)
[64811.838531] [<c03e8e74>] (netlink_unicast+0x158/0x234) from [<c03e93e0>] (netlink_sendmsg+0x218/0x298)
[64811.848419] [<c03e93e0>] (netlink_sendmsg+0x218/0x298) from [<c03b4e5c>] (sock_sendmsg+0xa4/0xc0)
[64811.857849] [<c03b4e5c>] (sock_sendmsg+0xa4/0xc0) from [<c03b5af4>] (__sys_sendmsg+0x1d8/0x254)
[64811.867065] [<c03b5af4>] (__sys_sendmsg+0x1d8/0x254) from [<c03b5ca8>] (sys_sendmsg+0x4c/0x70)
[64811.876251] [<c03b5ca8>] (sys_sendmsg+0x4c/0x70) from [<c0013980>] (ret_fast_syscall+0x0/0x3c)

Signed-off-by: Eliad Peller <eliad@wizery.com>
---
 net/mac80211/cfg.c |    3 +++
 1 files changed, 3 insertions(+), 0 deletions(-)

diff --git a/net/mac80211/cfg.c b/net/mac80211/cfg.c
index 498c94e..85ac364 100644
--- a/net/mac80211/cfg.c
+++ b/net/mac80211/cfg.c
@@ -2097,6 +2097,9 @@ static int ieee80211_set_bitrate_mask(struct wiphy *wiphy,
 	struct ieee80211_local *local = wdev_priv(dev->ieee80211_ptr);
 	int i, ret;
 
+	if (!ieee80211_sdata_running(sdata))
+		return -ENETDOWN;
+
 	if (local->hw.flags & IEEE80211_HW_HAS_RATE_CONTROL) {
 		ret = drv_set_bitrate_mask(local, sdata, mask);
 		if (ret)
-- 
1.7.6.401.g6a319

