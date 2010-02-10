Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.atheros.com ([12.36.123.2]:54823 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752657Ab0BJJEF (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 10 Feb 2010 04:04:05 -0500
Received: from mail.atheros.com ([10.10.20.108])
	by sidewinder.atheros.com
	for <linux-wireless@vger.kernel.org>; Wed, 10 Feb 2010 01:04:05 -0800
From: Sujith <Sujith.Manoharan@atheros.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Message-ID: <19314.31437.647232.84860@gargle.gargle.HOWL>
Date: Wed, 10 Feb 2010 14:52:21 +0530
To: <linville@tuxdriver.com>
CC: <johannes@sipsolutions.net>, <linux-wireless@vger.kernel.org>
Subject: [PATCH] mac80211: Deny TX BA session requests during disassociation
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

In associated state, when bringing an interface down, existing
BA sessions are torn down. When this is in progress, nothing
prevents mac80211 from accepting another BA session start request.

Use a new station flag to fix this.

Signed-off-by: Sujith <Sujith.Manoharan@atheros.com>
---
 net/mac80211/agg-tx.c   |    8 ++++++++
 net/mac80211/mlme.c     |    4 +++-
 net/mac80211/sta_info.h |    4 ++++
 3 files changed, 15 insertions(+), 1 deletions(-)

diff --git a/net/mac80211/agg-tx.c b/net/mac80211/agg-tx.c
index 718fbcf..5538e1b 100644
--- a/net/mac80211/agg-tx.c
+++ b/net/mac80211/agg-tx.c
@@ -237,6 +237,14 @@ int ieee80211_start_tx_ba_session(struct ieee80211_sta *pubsta, u16 tid)
 	    sdata->vif.type != NL80211_IFTYPE_AP)
 		return -EINVAL;
 
+	if (test_sta_flags(sta, WLAN_STA_DISASSOC)) {
+#ifdef CONFIG_MAC80211_HT_DEBUG
+		printk(KERN_DEBUG "Disassociation is in progress. "
+		       "Denying BA session request\n");
+#endif
+		return -EINVAL;
+	}
+
 	if (test_sta_flags(sta, WLAN_STA_SUSPEND)) {
 #ifdef CONFIG_MAC80211_HT_DEBUG
 		printk(KERN_DEBUG "Suspend in progress. "
diff --git a/net/mac80211/mlme.c b/net/mac80211/mlme.c
index ee9443d..bfc4a50 100644
--- a/net/mac80211/mlme.c
+++ b/net/mac80211/mlme.c
@@ -797,8 +797,10 @@ static void ieee80211_set_disassoc(struct ieee80211_sub_if_data *sdata)
 
 	rcu_read_lock();
 	sta = sta_info_get(sdata, bssid);
-	if (sta)
+	if (sta) {
+		set_sta_flags(sta, WLAN_STA_DISASSOC);
 		ieee80211_sta_tear_down_BA_sessions(sta);
+	}
 	rcu_read_unlock();
 
 	changed |= ieee80211_reset_erp_info(sdata);
diff --git a/net/mac80211/sta_info.h b/net/mac80211/sta_info.h
index 5ff611a..822d845 100644
--- a/net/mac80211/sta_info.h
+++ b/net/mac80211/sta_info.h
@@ -42,6 +42,9 @@
  *	be in the queues
  * @WLAN_STA_PSPOLL: Station sent PS-poll while driver was keeping
  *	station in power-save mode, reply when the driver unblocks.
+ * @WLAN_STA_DISASSOC: Disassociation in progress.
+ *	This is used to reject TX BA session requests when disassociation
+ *	is in progress.
  */
 enum ieee80211_sta_info_flags {
 	WLAN_STA_AUTH		= 1<<0,
@@ -57,6 +60,7 @@ enum ieee80211_sta_info_flags {
 	WLAN_STA_SUSPEND	= 1<<11,
 	WLAN_STA_PS_DRIVER	= 1<<12,
 	WLAN_STA_PSPOLL		= 1<<13,
+	WLAN_STA_DISASSOC       = 1<<14,
 };
 
 #define STA_TID_NUM 16
-- 
1.6.6.1

