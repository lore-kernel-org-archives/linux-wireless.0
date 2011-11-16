Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nbd.name ([46.4.11.11]:48432 "EHLO nbd.name"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756641Ab1KPMQ5 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 16 Nov 2011 07:16:57 -0500
From: Felix Fietkau <nbd@openwrt.org>
To: linux-wireless@vger.kernel.org
Cc: linville@tuxdriver.com, johannes@sipsolutions.net
Subject: [PATCH] mac80211: call ieee80211_recalc_idle() after sending packets
Date: Wed, 16 Nov 2011 13:16:51 +0100
Message-Id: <1321445811-72118-1-git-send-email-nbd@openwrt.org> (sfid-20111116_131700_878358_0DBB9FBD)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Some drivers (e.g. ath9k) assume that it's safe to go into low-power mode
immediately after the idle state changes. To support that, mac80211 even
calls drv_flush() before that happens.
In some instances, mac80211 sent a packet right after recalculating the
idle state, this patch fixes that.

Signed-off-by: Felix Fietkau <nbd@openwrt.org>
---
 net/mac80211/mlme.c       |   11 +++++------
 net/mac80211/offchannel.c |    4 ++--
 2 files changed, 7 insertions(+), 8 deletions(-)

diff --git a/net/mac80211/mlme.c b/net/mac80211/mlme.c
index f9ec15b..21ff330 100644
--- a/net/mac80211/mlme.c
+++ b/net/mac80211/mlme.c
@@ -1359,9 +1359,6 @@ static void __ieee80211_connection_loss(struct ieee80211_sub_if_data *sdata)
 	ieee80211_set_disassoc(sdata, true, true);
 	mutex_unlock(&ifmgd->mtx);
 
-	mutex_lock(&local->mtx);
-	ieee80211_recalc_idle(local);
-	mutex_unlock(&local->mtx);
 	/*
 	 * must be outside lock due to cfg80211,
 	 * but that's not a problem.
@@ -1370,6 +1367,10 @@ static void __ieee80211_connection_loss(struct ieee80211_sub_if_data *sdata)
 				       IEEE80211_STYPE_DEAUTH,
 				       WLAN_REASON_DISASSOC_DUE_TO_INACTIVITY,
 				       NULL, true);
+
+	mutex_lock(&local->mtx);
+	ieee80211_recalc_idle(local);
+	mutex_unlock(&local->mtx);
 }
 
 void ieee80211_beacon_connection_loss_work(struct work_struct *work)
@@ -2136,9 +2137,6 @@ static void ieee80211_sta_connection_lost(struct ieee80211_sub_if_data *sdata,
 
 	ieee80211_set_disassoc(sdata, true, true);
 	mutex_unlock(&ifmgd->mtx);
-	mutex_lock(&local->mtx);
-	ieee80211_recalc_idle(local);
-	mutex_unlock(&local->mtx);
 	/*
 	 * must be outside lock due to cfg80211,
 	 * but that's not a problem.
@@ -2147,6 +2145,7 @@ static void ieee80211_sta_connection_lost(struct ieee80211_sub_if_data *sdata,
 			IEEE80211_STYPE_DEAUTH, reason,
 			NULL, true);
 	mutex_lock(&ifmgd->mtx);
+	ieee80211_recalc_idle(local);
 }
 
 void ieee80211_sta_work(struct ieee80211_sub_if_data *sdata)
diff --git a/net/mac80211/offchannel.c b/net/mac80211/offchannel.c
index 3d41441..ebd8ccc 100644
--- a/net/mac80211/offchannel.c
+++ b/net/mac80211/offchannel.c
@@ -212,8 +212,6 @@ static void ieee80211_hw_roc_start(struct work_struct *work)
 		return;
 	}
 
-	ieee80211_recalc_idle(local);
-
 	if (local->hw_roc_skb) {
 		sdata = IEEE80211_DEV_TO_SUB_IF(local->hw_roc_dev);
 		ieee80211_tx_skb(sdata, local->hw_roc_skb);
@@ -227,6 +225,8 @@ static void ieee80211_hw_roc_start(struct work_struct *work)
 					  GFP_KERNEL);
 	}
 
+	ieee80211_recalc_idle(local);
+
 	mutex_unlock(&local->mtx);
 }
 
-- 
1.7.3.2

