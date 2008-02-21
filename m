Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from crystal.sipsolutions.net ([195.210.38.204]:44595 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756818AbYBUKYP (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 21 Feb 2008 05:24:15 -0500
Subject: [PATCH] mac80211: fix debugfs_sta print_mac() warning
From: Johannes Berg <johannes@sipsolutions.net>
To: John Linville <linville@tuxdriver.com>
Cc: David Miller <davem@davemloft.net>, joe@perches.com,
	netdev@vger.kernel.org,
	Harvey Harrison <harvey.harrison@gmail.com>,
	linux-wireless <linux-wireless@vger.kernel.org>
In-Reply-To: <1203588993.20345.27.camel@brick> (sfid-20080221_101622_275557_F35DFAB3)
References: <1203587699.17534.135.camel@johannes.berg>
	 <20080221.020343.190715910.davem@davemloft.net>
	 <1203588498.20345.20.camel@brick>
	 <20080221.021228.09081608.davem@davemloft.net>
	 <1203588993.20345.27.camel@brick> (sfid-20080221_101622_275557_F35DFAB3)
Content-Type: text/plain
Date: Thu, 21 Feb 2008 11:22:12 +0100
Message-Id: <1203589332.17534.150.camel@johannes.berg> (sfid-20080221_102421_689163_49870CA5)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

When print_mac() was marked as __pure to avoid emitting a function
call in pr_debug() scenarios, a warning in this code surfaced since
it relies on the fact that the buffer is modified and doesn't use
the return value. This patch makes it use the return value instead.

Signed-off-by: Johannes Berg <johannes@sipsolutions.net>
Reported-by: Harvey Harrison <harvey.harrison@gmail.com>
---
 net/mac80211/debugfs_sta.c |    5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

--- everything.orig/net/mac80211/debugfs_sta.c	2008-02-21 11:17:48.000000000 +0100
+++ everything/net/mac80211/debugfs_sta.c	2008-02-21 11:17:59.000000000 +0100
@@ -297,12 +297,13 @@ STA_OPS_WR(agg_status);
 void ieee80211_sta_debugfs_add(struct sta_info *sta)
 {
 	struct dentry *stations_dir = sta->local->debugfs.stations;
-	DECLARE_MAC_BUF(mac);
+	DECLARE_MAC_BUF(mbuf);
+	u8 *mac;
 
 	if (!stations_dir)
 		return;
 
-	print_mac(mac, sta->addr);
+	mac = print_mac(mbuf, sta->addr);
 
 	sta->debugfs.dir = debugfs_create_dir(mac, stations_dir);
 	if (!sta->debugfs.dir)


