Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from paleale.coelho.fi ([176.9.41.70]:40648 "EHLO
        farmhouse.coelho.fi" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1754651AbeDTKtj (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 20 Apr 2018 06:49:39 -0400
From: Luca Coelho <luca@coelho.fi>
To: johannes@sipsolutions.net
Cc: linux-wireless@vger.kernel.org,
        Gregory Greenman <gregory.greenman@intel.com>,
        Luca Coelho <luciano.coelho@intel.com>
Date: Fri, 20 Apr 2018 13:49:24 +0300
Message-Id: <20180420104926.8816-8-luca@coelho.fi> (sfid-20180420_125008_193590_3311D303)
In-Reply-To: <20180420104926.8816-1-luca@coelho.fi>
References: <20180420104926.8816-1-luca@coelho.fi>
Subject: [PATCH 7/9] mac80211: add api to set CSA counter in mac80211
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Gregory Greenman <gregory.greenman@intel.com>

Sometimes the most updated CSA counter values are known only
to the device. Add an API to pass this data to mac80211.

Signed-off-by: Gregory Greenman <gregory.greenman@intel.com>
Signed-off-by: Luca Coelho <luciano.coelho@intel.com>
---
 include/net/mac80211.h | 13 +++++++++++++
 net/mac80211/tx.c      | 25 +++++++++++++++++++++++++
 2 files changed, 38 insertions(+)

diff --git a/include/net/mac80211.h b/include/net/mac80211.h
index d2279b2d61aa..52f36c43f35f 100644
--- a/include/net/mac80211.h
+++ b/include/net/mac80211.h
@@ -4449,6 +4449,19 @@ static inline struct sk_buff *ieee80211_beacon_get(struct ieee80211_hw *hw,
  */
 u8 ieee80211_csa_update_counter(struct ieee80211_vif *vif);
 
+/**
+ * ieee80211_csa_set_counter - request mac80211 to set csa counter
+ * @vif: &struct ieee80211_vif pointer from the add_interface callback.
+ * @counter: the new value for the counter
+ *
+ * The csa counter can be changed by the device, this API should be
+ * used by the device driver to update csa counter in mac80211.
+ *
+ * It should never be used together with ieee80211_csa_update_counter(),
+ * as it will cause a race condition around the counter value.
+ */
+void ieee80211_csa_set_counter(struct ieee80211_vif *vif, u8 counter);
+
 /**
  * ieee80211_csa_finish - notify mac80211 about channel switch
  * @vif: &struct ieee80211_vif pointer from the add_interface callback.
diff --git a/net/mac80211/tx.c b/net/mac80211/tx.c
index 05a265cd573d..34499f6300d8 100644
--- a/net/mac80211/tx.c
+++ b/net/mac80211/tx.c
@@ -4085,6 +4085,31 @@ u8 ieee80211_csa_update_counter(struct ieee80211_vif *vif)
 }
 EXPORT_SYMBOL(ieee80211_csa_update_counter);
 
+void ieee80211_csa_set_counter(struct ieee80211_vif *vif, u8 counter)
+{
+	struct ieee80211_sub_if_data *sdata = vif_to_sdata(vif);
+	struct beacon_data *beacon = NULL;
+
+	rcu_read_lock();
+
+	if (sdata->vif.type == NL80211_IFTYPE_AP)
+		beacon = rcu_dereference(sdata->u.ap.beacon);
+	else if (sdata->vif.type == NL80211_IFTYPE_ADHOC)
+		beacon = rcu_dereference(sdata->u.ibss.presp);
+	else if (ieee80211_vif_is_mesh(&sdata->vif))
+		beacon = rcu_dereference(sdata->u.mesh.beacon);
+
+	if (!beacon)
+		goto unlock;
+
+	if (counter < beacon->csa_current_counter)
+		beacon->csa_current_counter = counter;
+
+unlock:
+	rcu_read_unlock();
+}
+EXPORT_SYMBOL(ieee80211_csa_set_counter);
+
 bool ieee80211_csa_is_complete(struct ieee80211_vif *vif)
 {
 	struct ieee80211_sub_if_data *sdata = vif_to_sdata(vif);
-- 
2.17.0
