Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga03.intel.com ([143.182.124.21]:43140 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755228AbYC1XZd (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 28 Mar 2008 19:25:33 -0400
From: Reinette Chatre <reinette.chatre@intel.com>
To: linville@tuxdriver.com, johannes@sipsolutions.net
Cc: linux-wireless@vger.kernel.org,
	ipw3945-devel@lists.sourceforge.net,
	Mohamed Abbas <mabbas@linux.intel.com>,
	Reinette Chatre <reinette.chatre@intel.com>
Subject: [PATCH 3/8] mac80211: enable driver to notify mac of status, change iwlwifi
Date: Fri, 28 Mar 2008 16:21:07 -0700
Message-Id: <1206746472-10443-4-git-send-email-reinette.chatre@intel.com> (sfid-20080328_232536_318067_F3E5BC46)
In-Reply-To: <1206746472-10443-3-git-send-email-reinette.chatre@intel.com>
References: <1206746472-10443-1-git-send-email-reinette.chatre@intel.com>
 <1206746472-10443-2-git-send-email-reinette.chatre@intel.com>
 <1206746472-10443-3-git-send-email-reinette.chatre@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Mohamed Abbas <mabbas@linux.intel.com>

Add new API to MAC80211 to allow low level driver to
notify MAC with driver status like comming from suspend
and HW rfkill. Modify iwlwifi driver to use new API.

Signed-off-by: Mohamed Abbas <mabbas@linux.intel.com>
Signed-off-by: Reinette Chatre <reinette.chatre@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl3945-base.c |    1 +
 drivers/net/wireless/iwlwifi/iwl4965-base.c |    1 +
 include/net/mac80211.h                      |   24 ++++++++++++++++++++++
 net/mac80211/ieee80211_sta.c                |   29 +++++++++++++++++++++++++++
 4 files changed, 55 insertions(+), 0 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl3945-base.c b/drivers/net/wireless/iwlwifi/iwl3945-base.c
index ab635dc..02b4245 100644
--- a/drivers/net/wireless/iwlwifi/iwl3945-base.c
+++ b/drivers/net/wireless/iwlwifi/iwl3945-base.c
@@ -5869,6 +5869,7 @@ static void iwl3945_alive_start(struct iwl3945_priv *priv)
 	if (priv->error_recovering)
 		iwl3945_error_recovery(priv);
 
+	ieee80211_notify_mac(priv->hw, TYPE_RE_ASSOC);
 	return;
 
  restart:
diff --git a/drivers/net/wireless/iwlwifi/iwl4965-base.c b/drivers/net/wireless/iwlwifi/iwl4965-base.c
index 7f56565..96daece 100644
--- a/drivers/net/wireless/iwlwifi/iwl4965-base.c
+++ b/drivers/net/wireless/iwlwifi/iwl4965-base.c
@@ -5733,6 +5733,7 @@ static void iwl4965_alive_start(struct iwl_priv *priv)
 		iwl4965_error_recovery(priv);
 
 	iwlcore_low_level_notify(priv, IWLCORE_START_EVT);
+	ieee80211_notify_mac(priv->hw, TYPE_RE_ASSOC);
 	return;
 
  restart:
diff --git a/include/net/mac80211.h b/include/net/mac80211.h
index 48428a6..0679adc 100644
--- a/include/net/mac80211.h
+++ b/include/net/mac80211.h
@@ -74,6 +74,20 @@
  */
 
 /**
+ * enum ieee80211_notification_type - Low level driver notification
+ * @TYPE_RE_ASSOC: start the re-association sequence
+ * @TYPE_DISCONNECT: disconnect from current association
+ * @TYPE_RESET: low level driver HW problem reset
+ */
+enum ieee80211_notification_types {
+	TYPE_RE_ASSOC,
+	TYPE_DISCONNECT,
+	TYPE_RESET,
+	/* keep last */
+	NUM_IEEE80211_NOTIFICATION_TYPES
+};
+
+/**
  * struct ieee80211_ht_bss_info - describing BSS's HT characteristics
  *
  * This structure describes most essential parameters needed
@@ -1663,4 +1677,14 @@ void ieee80211_stop_tx_ba_cb(struct ieee80211_hw *hw, u8 *ra, u8 tid);
 void ieee80211_stop_tx_ba_cb_irqsafe(struct ieee80211_hw *hw, const u8 *ra,
 				     u16 tid);
 
+/*
+ * ieee80211_notify_mac - low level driver notification
+ * @hw: pointer as obtained from ieee80211_alloc_hw().
+ * @notification_types: enum ieee80211_notification_types
+ *
+ * This function must be called by low level driver to sync mac80211
+ * with low level state.
+ */
+void ieee80211_notify_mac(struct ieee80211_hw *hw,
+			  enum ieee80211_notification_types  notif_type);
 #endif /* MAC80211_H */
diff --git a/net/mac80211/ieee80211_sta.c b/net/mac80211/ieee80211_sta.c
index f9cf2f1..b1c9a5a 100644
--- a/net/mac80211/ieee80211_sta.c
+++ b/net/mac80211/ieee80211_sta.c
@@ -4216,3 +4216,32 @@ int ieee80211_sta_disassociate(struct net_device *dev, u16 reason)
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
+	case TYPE_RE_ASSOC:
+		rcu_read_lock();
+		list_for_each_entry_rcu(sdata, &local->interfaces, list) {
+
+			/* No need to wake the master device. */
+			if (sdata->dev == local->mdev)
+				continue;
+
+			if (sdata->vif.type == IEEE80211_IF_TYPE_STA) {
+				ieee80211_sta_req_auth(sdata->dev,
+						       &sdata->u.sta);
+			}
+
+		}
+		rcu_read_unlock();
+		break;
+	default:
+		break;
+	}
+}
+EXPORT_SYMBOL(ieee80211_notify_mac);
-- 
1.5.3.4

