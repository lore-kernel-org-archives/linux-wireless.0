Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga03.intel.com ([143.182.124.21]:25828 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752972AbYCSTav (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 19 Mar 2008 15:30:51 -0400
From: Reinette Chatre <reinette.chatre@intel.com>
To: linville@tuxdriver.com, johannes@sipsolutions.net
Cc: linux-wireless@vger.kernel.org,
	ipw3945-devel@lists.sourceforge.net,
	Ron Rindjunsky <ron.rindjunsky@intel.com>,
	Tomas Winkler <tomas.winkler@intel.com>
Subject: [PATCH 2/3] mac80211: fixing debug prints for AddBA request
Date: Tue, 18 Mar 2008 15:00:31 -0700
Message-Id: <1205877632-11680-3-git-send-email-reinette.chatre@intel.com> (sfid-20080319_193127_875086_8A39F93D)
In-Reply-To: <1205877632-11680-2-git-send-email-reinette.chatre@intel.com>
References: <1205877632-11680-1-git-send-email-reinette.chatre@intel.com>
 <1205877632-11680-2-git-send-email-reinette.chatre@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Ron Rindjunsky <ron.rindjunsky@intel.com>

This patch also fixes the Rx timer's comments

Signed-off-by: Ron Rindjunsky <ron.rindjunsky@intel.com>
Signed-off-by: Tomas Winkler <tomas.winkler@intel.com>
---
 net/mac80211/ieee80211_sta.c |    8 ++++----
 1 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/net/mac80211/ieee80211_sta.c b/net/mac80211/ieee80211_sta.c
index 6e673df..8006c28 100644
--- a/net/mac80211/ieee80211_sta.c
+++ b/net/mac80211/ieee80211_sta.c
@@ -1145,7 +1145,7 @@ static void ieee80211_sta_process_addba_request(struct net_device *dev,
 		status = WLAN_STATUS_INVALID_QOS_PARAM;
 #ifdef CONFIG_MAC80211_HT_DEBUG
 		if (net_ratelimit())
-			printk(KERN_DEBUG "Block Ack Req with bad params from "
+			printk(KERN_DEBUG "AddBA Req with bad params from "
 				"%s on tid %u. policy %d, buffer size %d\n",
 				print_mac(mac, mgmt->sa), tid, ba_policy,
 				buf_size);
@@ -1169,7 +1169,7 @@ static void ieee80211_sta_process_addba_request(struct net_device *dev,
 	if (tid_agg_rx->state != HT_AGG_STATE_IDLE) {
 #ifdef CONFIG_MAC80211_HT_DEBUG
 		if (net_ratelimit())
-			printk(KERN_DEBUG "unexpected Block Ack Req from "
+			printk(KERN_DEBUG "unexpected AddBA Req from "
 				"%s on tid %u\n",
 				print_mac(mac, mgmt->sa), tid);
 #endif /* CONFIG_MAC80211_HT_DEBUG */
@@ -1497,8 +1497,8 @@ timer_expired_exit:
 }
 
 /*
- * After receiving Block Ack Request (BAR) we activated a
- * timer after each frame arrives from the originator.
+ * After accepting the AddBA Request we activated a timer,
+ * resetting it after each frame that arrives from the originator.
  * if this timer expires ieee80211_sta_stop_rx_ba_session will be executed.
  */
 void sta_rx_agg_session_timer_expired(unsigned long data)
-- 
1.5.3.4

