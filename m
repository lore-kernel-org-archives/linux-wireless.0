Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from na3sys009aog131.obsmtp.com ([74.125.149.247]:55882 "EHLO
	na3sys009aog131.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753972Ab2EHMXj (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 8 May 2012 08:23:39 -0400
Received: by obbuo13 with SMTP id uo13so652349obb.15
        for <linux-wireless@vger.kernel.org>; Tue, 08 May 2012 05:23:38 -0700 (PDT)
From: Yoni Divinsky <yoni.divinsky@ti.com>
To: <linux-wireless@vger.kernel.org>
Cc: Johannes Berg <johannes@sipsolutions.net>
Subject: [PATCH] mac80211: add op to configure default key id to driver
Date: Tue,  8 May 2012 15:18:38 +0300
Message-Id: <1336479518-23006-1-git-send-email-yoni.divinsky@ti.com> (sfid-20120508_142344_204037_B2FB544D)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

When hw_accel is enabled and encryption type is set to WEP,
the driver should get the default key index from mac80211.

Signed-off-by: Yoni Divinsky <yoni.divinsky@ti.com>
---
 include/net/mac80211.h    |    6 +++++-
 net/mac80211/cfg.c        |    3 +--
 net/mac80211/driver-ops.h |   17 +++++++++++++++++
 net/mac80211/key.c        |    6 +++++-
 net/mac80211/key.h        |    2 +-
 5 files changed, 29 insertions(+), 5 deletions(-)

diff --git a/include/net/mac80211.h b/include/net/mac80211.h
index 4d6e6c6..883fb72 100644
--- a/include/net/mac80211.h
+++ b/include/net/mac80211.h
@@ -1427,6 +1427,9 @@ void ieee80211_free_txskb(struct ieee80211_hw *hw, struct sk_buff *skb);
  * rekeying), it will not include a valid phase 1 key. The valid phase 1 key is
  * provided by update_tkip_key only. The trigger that makes mac80211 call this
  * handler is software decryption with wrap around of iv16.
+ *
+ * The set_default_key_idx() call updates the default WEP key index configured
+ * to the hardware for WEP encryption type.
  */
 
 /**
@@ -2361,7 +2364,6 @@ struct ieee80211_ops {
 					u16 tids, int num_frames,
 					enum ieee80211_frame_release_type reason,
 					bool more_data);
-
 	int	(*get_et_sset_count)(struct ieee80211_hw *hw,
 				     struct ieee80211_vif *vif, int sset);
 	void	(*get_et_stats)(struct ieee80211_hw *hw,
@@ -2370,6 +2372,8 @@ struct ieee80211_ops {
 	void	(*get_et_strings)(struct ieee80211_hw *hw,
 				  struct ieee80211_vif *vif,
 				  u32 sset, u8 *data);
+	int (*set_default_key_idx)(struct ieee80211_hw *hw,
+				    struct ieee80211_vif *vif, int idx);
 };
 
 /**
diff --git a/net/mac80211/cfg.c b/net/mac80211/cfg.c
index 0221270..6a82ae3 100644
--- a/net/mac80211/cfg.c
+++ b/net/mac80211/cfg.c
@@ -309,9 +309,8 @@ static int ieee80211_config_default_key(struct wiphy *wiphy,
 {
 	struct ieee80211_sub_if_data *sdata = IEEE80211_DEV_TO_SUB_IF(dev);
 
-	ieee80211_set_default_key(sdata, key_idx, uni, multi);
+	return ieee80211_set_default_key(sdata, key_idx, uni, multi);
 
-	return 0;
 }
 
 static int ieee80211_config_default_mgmt_key(struct wiphy *wiphy,
diff --git a/net/mac80211/driver-ops.h b/net/mac80211/driver-ops.h
index 6d33a0c..361705e 100644
--- a/net/mac80211/driver-ops.h
+++ b/net/mac80211/driver-ops.h
@@ -845,4 +845,21 @@ drv_allow_buffered_frames(struct ieee80211_local *local,
 						  more_data);
 	trace_drv_return_void(local);
 }
+
+static inline int
+drv_set_default_unicast_key(struct ieee80211_local *local,
+		    struct ieee80211_sub_if_data *sdata,
+		    int key_idx)
+{
+	int ret = 0;
+	check_sdata_in_driver(sdata);
+
+	if (local->ops->set_default_key_idx)
+		ret = local->ops->set_default_key_idx(&local->hw, &sdata->vif,
+						key_idx);
+
+	trace_drv_return_int(local, ret);
+
+	return ret;
+}
 #endif /* __MAC80211_DRIVER_OPS */
diff --git a/net/mac80211/key.c b/net/mac80211/key.c
index 5bb600d..365a521 100644
--- a/net/mac80211/key.c
+++ b/net/mac80211/key.c
@@ -232,12 +232,16 @@ static void __ieee80211_set_default_key(struct ieee80211_sub_if_data *sdata,
 	ieee80211_debugfs_key_update_default(sdata);
 }
 
-void ieee80211_set_default_key(struct ieee80211_sub_if_data *sdata, int idx,
+int ieee80211_set_default_key(struct ieee80211_sub_if_data *sdata, int idx,
 			       bool uni, bool multi)
 {
+	int ret = 0;
 	mutex_lock(&sdata->local->key_mtx);
 	__ieee80211_set_default_key(sdata, idx, uni, multi);
+	if (uni)
+		ret = drv_set_default_unicast_key(sdata->local, sdata, idx);
 	mutex_unlock(&sdata->local->key_mtx);
+	return ret;
 }
 
 static void
diff --git a/net/mac80211/key.h b/net/mac80211/key.h
index 7d4e31f..046d2b3 100644
--- a/net/mac80211/key.h
+++ b/net/mac80211/key.h
@@ -136,7 +136,7 @@ int __must_check ieee80211_key_link(struct ieee80211_key *key,
 void __ieee80211_key_free(struct ieee80211_key *key);
 void ieee80211_key_free(struct ieee80211_local *local,
 			struct ieee80211_key *key);
-void ieee80211_set_default_key(struct ieee80211_sub_if_data *sdata, int idx,
+int ieee80211_set_default_key(struct ieee80211_sub_if_data *sdata, int idx,
 			       bool uni, bool multi);
 void ieee80211_set_default_mgmt_key(struct ieee80211_sub_if_data *sdata,
 				    int idx);
-- 
1.7.0.4

