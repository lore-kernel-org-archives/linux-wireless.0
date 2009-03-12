Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:53618 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753085AbZCLWGr (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 12 Mar 2009 18:06:47 -0400
Subject: [PATCH] mac80211: remove ieee80211_num_regular_queues
From: Johannes Berg <johannes@sipsolutions.net>
To: John Linville <linville@tuxdriver.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain
Date: Thu, 12 Mar 2009 11:15:56 +0100
Message-Id: <1236852956.4175.19.camel@johannes.local> (sfid-20090312_230649_854981_F34993F5)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This inline is useless and actually makes the code _longer_
rather than shorter.

Signed-off-by: Johannes Berg <johannes@sipsolutions.net>
---
 include/net/mac80211.h |    5 -----
 net/mac80211/mlme.c    |    2 +-
 net/mac80211/tx.c      |    7 +++----
 3 files changed, 4 insertions(+), 10 deletions(-)

--- wireless-testing.orig/include/net/mac80211.h	2009-03-11 17:05:43.000000000 +0100
+++ wireless-testing/include/net/mac80211.h	2009-03-12 11:14:58.000000000 +0100
@@ -1017,11 +1017,6 @@ static inline void SET_IEEE80211_PERM_AD
 	memcpy(hw->wiphy->perm_addr, addr, ETH_ALEN);
 }
 
-static inline int ieee80211_num_regular_queues(struct ieee80211_hw *hw)
-{
-	return hw->queues;
-}
-
 static inline struct ieee80211_rate *
 ieee80211_get_tx_rate(const struct ieee80211_hw *hw,
 		      const struct ieee80211_tx_info *c)
--- wireless-testing.orig/net/mac80211/mlme.c	2009-03-11 13:46:20.000000000 +0100
+++ wireless-testing/net/mac80211/mlme.c	2009-03-12 11:14:58.000000000 +0100
@@ -1834,7 +1834,7 @@ void ieee80211_sta_setup_sdata(struct ie
 	ifmgd->flags |= IEEE80211_STA_CREATE_IBSS |
 		IEEE80211_STA_AUTO_BSSID_SEL |
 		IEEE80211_STA_AUTO_CHANNEL_SEL;
-	if (ieee80211_num_regular_queues(&sdata->local->hw) >= 4)
+	if (sdata->local->hw.queues >= 4)
 		ifmgd->flags |= IEEE80211_STA_WMM_ENABLED;
 }
 
--- wireless-testing.orig/net/mac80211/tx.c	2009-03-09 17:09:04.000000000 +0100
+++ wireless-testing/net/mac80211/tx.c	2009-03-12 11:14:58.000000000 +0100
@@ -1664,8 +1664,7 @@ int ieee80211_subif_start_xmit(struct sk
 	}
 
 	/* receiver and we are QoS enabled, use a QoS type frame */
-	if (sta_flags & WLAN_STA_WME &&
-	    ieee80211_num_regular_queues(&local->hw) >= 4) {
+	if (sta_flags & WLAN_STA_WME && local->hw.queues >= 4) {
 		fc |= cpu_to_le16(IEEE80211_STYPE_QOS_DATA);
 		hdrlen += 2;
 	}
@@ -1800,7 +1799,7 @@ void ieee80211_clear_tx_pending(struct i
 	int i, j;
 	struct ieee80211_tx_stored_packet *store;
 
-	for (i = 0; i < ieee80211_num_regular_queues(&local->hw); i++) {
+	for (i = 0; i < local->hw.queues; i++) {
 		if (!test_bit(i, local->queues_pending))
 			continue;
 		store = &local->pending_packet[i];
@@ -1825,7 +1824,7 @@ void ieee80211_tx_pending(unsigned long 
 	int i, ret;
 
 	netif_tx_lock_bh(dev);
-	for (i = 0; i < ieee80211_num_regular_queues(&local->hw); i++) {
+	for (i = 0; i < local->hw.queues; i++) {
 		/* Check that this queue is ok */
 		if (__netif_subqueue_stopped(local->mdev, i) &&
 		    !test_bit(i, local->queues_pending_run))


