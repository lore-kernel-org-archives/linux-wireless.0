Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.atheros.com ([12.36.123.2]:54382 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752348AbZBBKby (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 2 Feb 2009 05:31:54 -0500
Received: from mail.atheros.com ([10.10.20.108])
	by sidewinder.atheros.com
	for <linux-wireless@vger.kernel.org>; Mon, 02 Feb 2009 02:31:54 -0800
From: Sujith <Sujith.Manoharan@atheros.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Message-ID: <18822.51903.216795.888284@gargle.gargle.HOWL> (sfid-20090202_113203_727304_848B8B2A)
Date: Mon, 2 Feb 2009 15:58:15 +0530
To: <linux-wireless@vger.kernel.org>
CC: <johannes@sipsolutions.net>, <Jouni.Malinen@Atheros.com>,
	<linville@tuxdriver.com>
Subject: [PATCH] mac80211: Extend the rate control API with an update callback
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The AP can switch dynamically between 20/40 Mhz channel width,
in which case we switch the local operating channel, but the
rate control algorithm is not notified. This patch adds a new callback
to indicate such changes to the RC algorithm.

Currently, HT channel width change is notified, but this callback
can be used to indicate any new requirements that might come up later on.

Signed-off-by: Sujith <Sujith.Manoharan@atheros.com>
---
 include/net/mac80211.h |   13 +++++++++++++
 net/mac80211/ht.c      |   12 ++++++++++++
 net/mac80211/rate.h    |   12 ++++++++++++
 3 files changed, 37 insertions(+), 0 deletions(-)

diff --git a/include/net/mac80211.h b/include/net/mac80211.h
index e2144f0..88d4b8c 100644
--- a/include/net/mac80211.h
+++ b/include/net/mac80211.h
@@ -1984,6 +1984,16 @@ struct ieee80211_sta *ieee80211_find_sta(struct ieee80211_hw *hw,
 /* Rate control API */
 
 /**
+ * enum rate_control_changed - flags to indicate which parameter changed
+ *
+ * @IEEE80211_RC_CHANNEL_CHANGED: The operating channel has changed, rate
+ *	control algorithm can update its internal state if needed.
+ */
+enum rate_control_changed {
+	IEEE80211_RC_CHANNEL_CHANGED = BIT(0)
+};
+
+/**
  * struct ieee80211_tx_rate_control - rate control information for/from RC algo
  *
  * @hw: The hardware the algorithm is invoked for.
@@ -2019,6 +2029,9 @@ struct rate_control_ops {
 	void *(*alloc_sta)(void *priv, struct ieee80211_sta *sta, gfp_t gfp);
 	void (*rate_init)(void *priv, struct ieee80211_supported_band *sband,
 			  struct ieee80211_sta *sta, void *priv_sta);
+	void (*rate_update)(void *priv, struct ieee80211_supported_band *sband,
+			    struct ieee80211_sta *sta,
+			    void *priv_sta, u32 changed);
 	void (*free_sta)(void *priv, struct ieee80211_sta *sta,
 			 void *priv_sta);
 
diff --git a/net/mac80211/ht.c b/net/mac80211/ht.c
index 7a38d2e..d2daddd 100644
--- a/net/mac80211/ht.c
+++ b/net/mac80211/ht.c
@@ -19,6 +19,7 @@
 #include "ieee80211_i.h"
 #include "sta_info.h"
 #include "wme.h"
+#include "rate.h"
 
 void ieee80211_ht_cap_ie_to_sta_ht_cap(struct ieee80211_supported_band *sband,
 				       struct ieee80211_ht_cap *ht_cap_ie,
@@ -94,8 +95,10 @@ u32 ieee80211_enable_ht(struct ieee80211_sub_if_data *sdata,
 			u16 ap_ht_cap_flags)
 {
 	struct ieee80211_local *local = sdata->local;
+	struct ieee80211_if_sta *ifsta = &sdata->u.sta;
 	struct ieee80211_supported_band *sband;
 	struct ieee80211_bss_ht_conf ht;
+	struct sta_info *sta;
 	u32 changed = 0;
 	bool enable_ht = true, ht_changed;
 	enum nl80211_channel_type channel_type = NL80211_CHAN_NO_HT;
@@ -138,6 +141,15 @@ u32 ieee80211_enable_ht(struct ieee80211_sub_if_data *sdata,
 	if (ht_changed) {
                 /* channel_type change automatically detected */
 		ieee80211_hw_config(local, 0);
+
+		rcu_read_lock();
+
+		sta = sta_info_get(local, ifsta->bssid);
+		if (sta)
+			rate_control_rate_update(local, sband, sta,
+					 IEEE80211_RC_CHANNEL_CHANGED);
+
+		rcu_read_unlock();
         }
 
 	/* disable HT */
diff --git a/net/mac80211/rate.h b/net/mac80211/rate.h
index 928da62..8b869f2 100644
--- a/net/mac80211/rate.h
+++ b/net/mac80211/rate.h
@@ -62,6 +62,18 @@ static inline void rate_control_rate_init(struct sta_info *sta)
 	ref->ops->rate_init(ref->priv, sband, ista, priv_sta);
 }
 
+static inline void rate_control_rate_update(struct ieee80211_local *local,
+					    struct ieee80211_supported_band *sband,
+					    struct sta_info *sta, u32 changed)
+{
+	struct rate_control_ref *ref = local->rate_ctrl;
+	struct ieee80211_sta *ista = &sta->sta;
+	void *priv_sta = sta->rate_ctrl_priv;
+
+	if (ref->ops->rate_update)
+		ref->ops->rate_update(ref->priv, sband, ista,
+				      priv_sta, changed);
+}
 
 static inline void *rate_control_alloc_sta(struct rate_control_ref *ref,
 					   struct ieee80211_sta *sta,
-- 
1.6.1

