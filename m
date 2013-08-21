Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([144.76.43.152]:60441 "EHLO
	sipsolutions.net" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752542Ab3HUUgH (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 21 Aug 2013 16:36:07 -0400
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Cc: Johannes Berg <johannes.berg@intel.com>
Subject: [RFC] mac80211: fix locking with ieee80211_resume_disconnect()
Date: Wed, 21 Aug 2013 22:35:41 +0200
Message-Id: <1377117341-9327-1-git-send-email-johannes@sipsolutions.net> (sfid-20130821_223611_796711_D6CA0ED5)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

If it is needed to disconnect multiple virtual interfaces after
(WoWLAN-) suspend, the most obvious approach would be to iterate
all interfaces by calling ieee80211_iterate_active_interfaces()
and then call ieee80211_resume_disconnect() for each one. This
is what the iwlmvm driver does.

Unfortunately, this causes a locking dependency from mac80211's
iflist_mtx to the key_mtx. This is problematic as the former is
intentionally never held while calling any driver operation to
allow drivers to iterate with their own locks held. The key_mtx
is held while installing a key into the driver though, so this
new lock dependency means drivers implementing the logic above
can no longer hold their own lock while iterating.

To fix this, modify the ieee80211_resume_disconnect() API to do
the iteration in there (using RCU) while holding the key_mtx so
there's no new lock dependency, and let the driver device which
interface should be disconnected by passing a decision function
that returns true/false.

This also adjusts users accordingly, the iwldvm one introduces
a behavioural change (previously only a single interface would
have been disconnected) but this is acceptable since it only
supports a single one for WoWLAN, so the other one would have
been disconnected by the AP while sleeping anyway. For iwlmvm
this fixes the bug described above.

The decision-making callback would therefore not be necessary
right now, but I'm working on a future patch to keep a single
connection in iwlmvm open, at which point that one should not
be disconnected, though all other ones should, so the API is
prepared for that change already.

Change-Id: I9b578c7dacefbb818b4113da12770aec9d0b06c4
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 drivers/net/wireless/iwlwifi/dvm/mac80211.c |  2 +-
 drivers/net/wireless/iwlwifi/mvm/d3.c       | 12 +----------
 include/net/mac80211.h                      | 24 ++++++++++++++--------
 net/mac80211/util.c                         | 31 ++++++++++++++++-------------
 4 files changed, 35 insertions(+), 34 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/dvm/mac80211.c b/drivers/net/wireless/iwlwifi/dvm/mac80211.c
index 4bd2ca9..1810b23 100644
--- a/drivers/net/wireless/iwlwifi/dvm/mac80211.c
+++ b/drivers/net/wireless/iwlwifi/dvm/mac80211.c
@@ -571,7 +571,7 @@ static int iwlagn_mac_resume(struct ieee80211_hw *hw)
 	mutex_unlock(&priv->mutex);
 	IWL_DEBUG_MAC80211(priv, "leave\n");
 
-	ieee80211_resume_disconnect(vif);
+	ieee80211_resume_disconnect(priv->hw, NULL, NULL);
 
 	return 1;
 }
diff --git a/drivers/net/wireless/iwlwifi/mvm/d3.c b/drivers/net/wireless/iwlwifi/mvm/d3.c
index 5585538..29a7192 100644
--- a/drivers/net/wireless/iwlwifi/mvm/d3.c
+++ b/drivers/net/wireless/iwlwifi/mvm/d3.c
@@ -1362,13 +1362,6 @@ static void iwl_mvm_read_d3_sram(struct iwl_mvm *mvm)
 #endif
 }
 
-static void iwl_mvm_d3_disconnect_iter(void *data, u8 *mac,
-				       struct ieee80211_vif *vif)
-{
-	if (vif->type == NL80211_IFTYPE_STATION)
-		ieee80211_resume_disconnect(vif);
-}
-
 static int __iwl_mvm_resume(struct iwl_mvm *mvm, bool test)
 {
 	struct iwl_d3_iter_data resume_iter_data = {
@@ -1411,10 +1404,7 @@ static int __iwl_mvm_resume(struct iwl_mvm *mvm, bool test)
 
  out:
 	if (!test)
-		ieee80211_iterate_active_interfaces(mvm->hw,
-						    IEEE80211_IFACE_ITER_NORMAL,
-						    iwl_mvm_d3_disconnect_iter,
-						    NULL);
+		ieee80211_resume_disconnect(mvm->hw, NULL, NULL);
 
 	/* return 1 to reconfigure the device */
 	set_bit(IWL_MVM_STATUS_IN_HW_RESTART, &mvm->status);
diff --git a/include/net/mac80211.h b/include/net/mac80211.h
index cb5eba8..194efe7 100644
--- a/include/net/mac80211.h
+++ b/include/net/mac80211.h
@@ -4104,13 +4104,18 @@ void ieee80211_connection_loss(struct ieee80211_vif *vif);
 /**
  * ieee80211_resume_disconnect - disconnect from AP after resume
  *
- * @vif: &struct ieee80211_vif pointer from the add_interface callback.
- *
- * Instructs mac80211 to disconnect from the AP after resume.
- * Drivers can use this after WoWLAN if they know that the
- * connection cannot be kept up, for example because keys were
- * used while the device was asleep but the replay counters or
- * similar cannot be retrieved from the device during resume.
+ * @hw: pointer obtained from ieee80211_alloc_hw().
+ * @decision: decision function, return %true if the interface should be
+ *	disconnected, only interfaces of type %NL80211_IFTYPE_STATION
+ *	(P2P and non-P2P) will be passed for decision-making. May be %NULL
+ *	which is equivalent to always returning %true.
+ *
+ * Instructs mac80211 to disconnect from the AP after resume for those
+ * interfaces where the decision-making function returned %true. Drivers
+ * can use this after WoWLAN if they know that the connection cannot be
+ * kept up, for example because keys were used while the device was asleep
+ * but the replay counters or similar cannot be retrieved from the device
+ * during resume.
  *
  * Note that due to implementation issues, if the driver uses
  * the reconfiguration functionality during resume the interface
@@ -4122,7 +4127,10 @@ void ieee80211_connection_loss(struct ieee80211_vif *vif);
  * calls this function, or at least not any locks it needs in the
  * key configuration paths (if it supports HW crypto).
  */
-void ieee80211_resume_disconnect(struct ieee80211_vif *vif);
+void ieee80211_resume_disconnect(struct ieee80211_hw *hw,
+				 bool (*decision)(struct ieee80211_vif *vif,
+						  void *data),
+				 void *decision_data);
 
 /**
  * ieee80211_cqm_rssi_notify - inform a configured connection quality monitoring
diff --git a/net/mac80211/util.c b/net/mac80211/util.c
index d23c5a7..ba85533 100644
--- a/net/mac80211/util.c
+++ b/net/mac80211/util.c
@@ -1753,29 +1753,32 @@ int ieee80211_reconfig(struct ieee80211_local *local)
 	return 0;
 }
 
-void ieee80211_resume_disconnect(struct ieee80211_vif *vif)
+void ieee80211_resume_disconnect(struct ieee80211_hw *hw,
+				 bool (*decision)(struct ieee80211_vif *vif,
+						  void *data),
+				 void *decision_data)
 {
+	struct ieee80211_local *local = hw_to_local(hw);
 	struct ieee80211_sub_if_data *sdata;
-	struct ieee80211_local *local;
 	struct ieee80211_key *key;
 
-	if (WARN_ON(!vif))
-		return;
-
-	sdata = vif_to_sdata(vif);
-	local = sdata->local;
-
 	if (WARN_ON(!local->resuming))
 		return;
 
-	if (WARN_ON(vif->type != NL80211_IFTYPE_STATION))
-		return;
+	mutex_lock(&local->key_mtx);
+	rcu_read_lock();
 
-	sdata->flags |= IEEE80211_SDATA_DISCONNECT_RESUME;
+	list_for_each_entry_rcu(sdata, &local->interfaces, list) {
+		if (sdata->vif.type != NL80211_IFTYPE_STATION)
+			continue;
+		if (decision && !decision(&sdata->vif, decision_data))
+			continue;
+		sdata->flags |= IEEE80211_SDATA_DISCONNECT_RESUME;
+		list_for_each_entry(key, &sdata->key_list, list)
+			key->flags |= KEY_FLAG_TAINTED;
+	}
 
-	mutex_lock(&local->key_mtx);
-	list_for_each_entry(key, &sdata->key_list, list)
-		key->flags |= KEY_FLAG_TAINTED;
+	rcu_read_unlock();
 	mutex_unlock(&local->key_mtx);
 }
 EXPORT_SYMBOL_GPL(ieee80211_resume_disconnect);
-- 
1.8.4.rc2

