Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:47125 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751485Ab0DFJWq (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 6 Apr 2010 05:22:46 -0400
Message-Id: <20100406092141.761810465@sipsolutions.net>
Date: Tue, 06 Apr 2010 11:18:46 +0200
From: Johannes Berg <johannes@sipsolutions.net>
To: John Linville <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org
Subject: [PATCH 5/7] mac80211: rename WLAN_STA_SUSPEND to WLAN_STA_BLOCK_BA
References: <20100406091841.549805267@sipsolutions.net>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

I want to use it during station destruction as well
so rename it to WLAN_STA_BLOCK_BA which is also the
only use of it now.

Signed-off-by: Johannes Berg <johannes@sipsolutions.net>
---
 net/mac80211/agg-rx.c   |    2 +-
 net/mac80211/agg-tx.c   |    2 +-
 net/mac80211/pm.c       |    2 +-
 net/mac80211/sta_info.h |    6 +++---
 net/mac80211/util.c     |    2 +-
 5 files changed, 7 insertions(+), 7 deletions(-)

--- wireless-testing.orig/net/mac80211/agg-rx.c	2010-04-05 19:24:17.000000000 +0200
+++ wireless-testing/net/mac80211/agg-rx.c	2010-04-05 19:24:50.000000000 +0200
@@ -173,7 +173,7 @@ void ieee80211_process_addba_request(str
 
 	status = WLAN_STATUS_REQUEST_DECLINED;
 
-	if (test_sta_flags(sta, WLAN_STA_SUSPEND)) {
+	if (test_sta_flags(sta, WLAN_STA_BLOCK_BA)) {
 #ifdef CONFIG_MAC80211_HT_DEBUG
 		printk(KERN_DEBUG "Suspend in progress. "
 		       "Denying ADDBA request\n");
--- wireless-testing.orig/net/mac80211/agg-tx.c	2010-04-05 19:24:17.000000000 +0200
+++ wireless-testing/net/mac80211/agg-tx.c	2010-04-05 19:24:50.000000000 +0200
@@ -245,7 +245,7 @@ int ieee80211_start_tx_ba_session(struct
 		return -EINVAL;
 	}
 
-	if (test_sta_flags(sta, WLAN_STA_SUSPEND)) {
+	if (test_sta_flags(sta, WLAN_STA_BLOCK_BA)) {
 #ifdef CONFIG_MAC80211_HT_DEBUG
 		printk(KERN_DEBUG "Suspend in progress. "
 		       "Denying BA session request\n");
--- wireless-testing.orig/net/mac80211/pm.c	2010-04-05 19:24:17.000000000 +0200
+++ wireless-testing/net/mac80211/pm.c	2010-04-05 19:24:50.000000000 +0200
@@ -46,7 +46,7 @@ int __ieee80211_suspend(struct ieee80211
 
 	if (hw->flags & IEEE80211_HW_AMPDU_AGGREGATION) {
 		list_for_each_entry_rcu(sta, &local->sta_list, list) {
-			set_sta_flags(sta, WLAN_STA_SUSPEND);
+			set_sta_flags(sta, WLAN_STA_BLOCK_BA);
 			ieee80211_sta_tear_down_BA_sessions(sta);
 		}
 	}
--- wireless-testing.orig/net/mac80211/sta_info.h	2010-04-05 19:24:17.000000000 +0200
+++ wireless-testing/net/mac80211/sta_info.h	2010-04-05 19:25:19.000000000 +0200
@@ -35,8 +35,8 @@
  *	IEEE80211_TX_CTL_CLEAR_PS_FILT control flag) when the next
  *	frame to this station is transmitted.
  * @WLAN_STA_MFP: Management frame protection is used with this STA.
- * @WLAN_STA_SUSPEND: Set/cleared during a suspend/resume cycle.
- *	Used to deny ADDBA requests (both TX and RX).
+ * @WLAN_STA_BLOCK_BA: Used to deny ADDBA requests (both TX and RX)
+ *	during suspend/resume.
  * @WLAN_STA_PS_DRIVER: driver requires keeping this station in
  *	power-save mode logically to flush frames that might still
  *	be in the queues
@@ -57,7 +57,7 @@ enum ieee80211_sta_info_flags {
 	WLAN_STA_WDS		= 1<<7,
 	WLAN_STA_CLEAR_PS_FILT	= 1<<9,
 	WLAN_STA_MFP		= 1<<10,
-	WLAN_STA_SUSPEND	= 1<<11,
+	WLAN_STA_BLOCK_BA	= 1<<11,
 	WLAN_STA_PS_DRIVER	= 1<<12,
 	WLAN_STA_PSPOLL		= 1<<13,
 	WLAN_STA_DISASSOC       = 1<<14,
--- wireless-testing.orig/net/mac80211/util.c	2010-04-05 19:24:17.000000000 +0200
+++ wireless-testing/net/mac80211/util.c	2010-04-05 19:24:50.000000000 +0200
@@ -1140,7 +1140,7 @@ int ieee80211_reconfig(struct ieee80211_
 
 	if (hw->flags & IEEE80211_HW_AMPDU_AGGREGATION) {
 		list_for_each_entry_rcu(sta, &local->sta_list, list) {
-			clear_sta_flags(sta, WLAN_STA_SUSPEND);
+			clear_sta_flags(sta, WLAN_STA_BLOCK_BA);
 		}
 	}
 


