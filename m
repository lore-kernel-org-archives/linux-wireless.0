Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga02.intel.com ([134.134.136.20]:16699 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751327AbYDEABQ (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 4 Apr 2008 20:01:16 -0400
From: Reinette Chatre <reinette.chatre@intel.com>
To: linville@tuxdriver.com, johannes@sipsolutions.net
Cc: linux-wireless@vger.kernel.org,
	ipw3945-devel@lists.sourceforge.net,
	Mohamed Abbas <mabbas@linux.intel.com>,
	Reinette Chatre <reinette.chatre@intel.com>
Subject: [PATCH v2] mac80211: notify mac from low level driver (iwlwifi)
Date: Fri,  4 Apr 2008 16:59:58 -0700
Message-Id: <1207353598-461-1-git-send-email-reinette.chatre@intel.com> (sfid-20080405_010120_519160_9DFAA506)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Mohamed Abbas <mabbas@linux.intel.com>

Add new API to MAC80211 to allow low level driver to
notify MAC with driver status.

Signed-off-by: Mohamed Abbas <mabbas@linux.intel.com>
Signed-off-by: Reinette Chatre <reinette.chatre@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl3945-base.c |    1 +
 drivers/net/wireless/iwlwifi/iwl4965-base.c |    1 +
 include/net/mac80211.h                      |   19 +++++++++++++++++++
 net/mac80211/ieee80211_sta.c                |   23 +++++++++++++++++++++++
 4 files changed, 44 insertions(+), 0 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl3945-base.c b/drivers/net/wireless/iwlwifi/iwl3945-base.c
index d4daa04..19a14ad 100644
--- a/drivers/net/wireless/iwlwifi/iwl3945-base.c
+++ b/drivers/net/wireless/iwlwifi/iwl3945-base.c
@@ -5883,6 +5883,7 @@ static void iwl3945_alive_start(struct iwl3945_priv *priv)
 	if (priv->error_recovering)
 		iwl3945_error_recovery(priv);
 
+	ieee80211_notify_mac(priv->hw, IEEE80211_NOTIFY_RE_ASSOC);
 	return;
 
  restart:
diff --git a/drivers/net/wireless/iwlwifi/iwl4965-base.c b/drivers/net/wireless/iwlwifi/iwl4965-base.c
index 4517e4c..4de81d8 100644
--- a/drivers/net/wireless/iwlwifi/iwl4965-base.c
+++ b/drivers/net/wireless/iwlwifi/iwl4965-base.c
@@ -5711,6 +5711,7 @@ static void iwl4965_alive_start(struct iwl_priv *priv)
 		iwl4965_error_recovery(priv);
 
 	iwlcore_low_level_notify(priv, IWLCORE_START_EVT);
+	ieee80211_notify_mac(priv->hw, IEEE80211_NOTIFY_RE_ASSOC);
 	return;
 
  restart:
diff --git a/include/net/mac80211.h b/include/net/mac80211.h
index 01b3215..0bc73e2 100644
--- a/include/net/mac80211.h
+++ b/include/net/mac80211.h
@@ -74,6 +74,14 @@
  */
 
 /**
+ * enum ieee80211_notification_type - Low level driver notification
+ * @IEEE80211_NOTIFY_RE_ASSOC: start the re-association sequence
+ */
+enum ieee80211_notification_types {
+	IEEE80211_NOTIFY_RE_ASSOC,
+};
+
+/**
  * struct ieee80211_ht_bss_info - describing BSS's HT characteristics
  *
  * This structure describes most essential parameters needed
@@ -1677,4 +1685,15 @@ void ieee80211_stop_tx_ba_cb(struct ieee80211_hw *hw, u8 *ra, u8 tid);
 void ieee80211_stop_tx_ba_cb_irqsafe(struct ieee80211_hw *hw, const u8 *ra,
 				     u16 tid);
 
+/**
+ * ieee80211_notify_mac - low level driver notification
+ * @hw: pointer as obtained from ieee80211_alloc_hw().
+ * @notification_types: enum ieee80211_notification_types
+ *
+ * This function must be called by low level driver to inform mac80211 of
+ * low level driver status change or force mac80211 to re-assoc for low
+ * level driver internal error that require re-assoc.
+ */
+void ieee80211_notify_mac(struct ieee80211_hw *hw,
+			  enum ieee80211_notification_types  notif_type);
 #endif /* MAC80211_H */
diff --git a/net/mac80211/ieee80211_sta.c b/net/mac80211/ieee80211_sta.c
index f3c8a21..833b225 100644
--- a/net/mac80211/ieee80211_sta.c
+++ b/net/mac80211/ieee80211_sta.c
@@ -4235,3 +4235,26 @@ int ieee80211_sta_disassociate(struct net_device *dev, u16 reason)
 	ieee80211_set_disassoc(dev, ifsta, 0);
 	return 0;
 }
+
+void ieee80211_notify_mac(struct ieee80211_hw *hw,
+			  enum ieee80211_notification_types  notif_type)
+{
+	struct ieee80211_local *local = hw_to_local(hw);
+	struct ieee80211_sub_if_data *sdata;
+
+	switch (notif_type) {
+	case IEEE80211_NOTIFY_RE_ASSOC:
+		rcu_read_lock();
+		list_for_each_entry_rcu(sdata, &local->interfaces, list) {
+
+			if (sdata->vif.type == IEEE80211_IF_TYPE_STA) {
+				ieee80211_sta_req_auth(sdata->dev,
+						       &sdata->u.sta);
+			}
+
+		}
+		rcu_read_unlock();
+		break;
+	}
+}
+EXPORT_SYMBOL(ieee80211_notify_mac);
-- 
1.5.3.4

