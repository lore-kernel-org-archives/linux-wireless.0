Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.atheros.com ([12.36.123.2]:57938 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750932AbZBLGM1 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 12 Feb 2009 01:12:27 -0500
Received: from mail.atheros.com ([10.10.20.108])
	by sidewinder.atheros.com
	for <linux-wireless@vger.kernel.org>; Wed, 11 Feb 2009 22:12:26 -0800
From: Sujith <Sujith.Manoharan@atheros.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Message-ID: <18835.48357.7271.454072@gargle.gargle.HOWL> (sfid-20090212_071231_361530_5402841A)
Date: Thu, 12 Feb 2009 11:38:37 +0530
To: <linville@tuxdriver.com>
CC: <linux-wireless@vger.kernel.org>, <johannes@sipsolutions.net>,
	<Jouni.Malinen@Atheros.com>
Subject: [PATCH v2] mac80211: Extend the rate control API with an update callback
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
v2:
--
* Rebased over [PATCH] mac80211: split IBSS/managed code

 include/net/mac80211.h |   13 +++++++++++++
 net/mac80211/ht.c      |   13 +++++++++++++
 net/mac80211/rate.h    |   12 ++++++++++++
 3 files changed, 38 insertions(+), 0 deletions(-)

diff --git a/include/net/mac80211.h b/include/net/mac80211.h
index 31fd8ba..e01c63a 100644
--- a/include/net/mac80211.h
+++ b/include/net/mac80211.h
@@ -1975,6 +1975,16 @@ struct ieee80211_sta *ieee80211_find_sta(struct ieee80211_hw *hw,
 /* Rate control API */
 
 /**
+ * enum rate_control_changed - flags to indicate which parameter changed
+ *
+ * @IEEE80211_RC_HT_CHANGED: The HT parameters of the operating channel have
+ *	changed, rate control algorithm can update its internal state if needed.
+ */
+enum rate_control_changed {
+	IEEE80211_RC_HT_CHANGED = BIT(0)
+};
+
+/**
  * struct ieee80211_tx_rate_control - rate control information for/from RC algo
  *
  * @hw: The hardware the algorithm is invoked for.
@@ -2010,6 +2020,9 @@ struct rate_control_ops {
 	void *(*alloc_sta)(void *priv, struct ieee80211_sta *sta, gfp_t gfp);
 	void (*rate_init)(void *priv, struct ieee80211_supported_band *sband,
 			  struct ieee80211_sta *sta, void *priv_sta);
+	void (*rate_update)(void *priv, struct ieee80211_supported_band *sband,
+			    struct ieee80211_sta *sta,
+			    void *priv_sta, u32 changed);
 	void (*free_sta)(void *priv, struct ieee80211_sta *sta,
 			 void *priv_sta);
 
diff --git a/net/mac80211/ht.c b/net/mac80211/ht.c
index 69b6e9a..4e3c72f 100644
--- a/net/mac80211/ht.c
+++ b/net/mac80211/ht.c
@@ -17,6 +17,7 @@
 #include <net/wireless.h>
 #include <net/mac80211.h>
 #include "ieee80211_i.h"
+#include "rate.h"
 
 void ieee80211_ht_cap_ie_to_sta_ht_cap(struct ieee80211_supported_band *sband,
 				       struct ieee80211_ht_cap *ht_cap_ie,
@@ -93,7 +94,9 @@ u32 ieee80211_enable_ht(struct ieee80211_sub_if_data *sdata,
 {
 	struct ieee80211_local *local = sdata->local;
 	struct ieee80211_supported_band *sband;
+	struct ieee80211_if_managed *ifmgd = &sdata->u.mgd;
 	struct ieee80211_bss_ht_conf ht;
+	struct sta_info *sta;
 	u32 changed = 0;
 	bool enable_ht = true, ht_changed;
 	enum nl80211_channel_type channel_type = NL80211_CHAN_NO_HT;
@@ -136,6 +139,16 @@ u32 ieee80211_enable_ht(struct ieee80211_sub_if_data *sdata,
 	if (ht_changed) {
                 /* channel_type change automatically detected */
 		ieee80211_hw_config(local, 0);
+
+		rcu_read_lock();
+
+		sta = sta_info_get(local, ifmgd->bssid);
+		if (sta)
+			rate_control_rate_update(local, sband, sta,
+						 IEEE80211_RC_HT_CHANGED);
+
+		rcu_read_unlock();
+
         }
 
 	/* disable HT */
diff --git a/net/mac80211/rate.h b/net/mac80211/rate.h
index 928da62..b9164c9 100644
--- a/net/mac80211/rate.h
+++ b/net/mac80211/rate.h
@@ -62,6 +62,18 @@ static inline void rate_control_rate_init(struct sta_info *sta)
 	ref->ops->rate_init(ref->priv, sband, ista, priv_sta);
 }
 
+static inline void rate_control_rate_update(struct ieee80211_local *local,
+				    struct ieee80211_supported_band *sband,
+				    struct sta_info *sta, u32 changed)
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

