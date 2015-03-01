Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga09.intel.com ([134.134.136.24]:50389 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753303AbbCATcm (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sun, 1 Mar 2015 14:32:42 -0500
From: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
To: linux-wireless@vger.kernel.org
Cc: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Subject: [PATCH 26/31] iwlwifi: mvm: add trigger for firmware dump upon channel switch
Date: Sun,  1 Mar 2015 21:31:39 +0200
Message-Id: <1425238304-498-26-git-send-email-emmanuel.grumbach@intel.com> (sfid-20150301_203417_620848_07C9B897)
In-Reply-To: <1425238186.30202.5.camel@egrumbacBox>
References: <1425238186.30202.5.camel@egrumbacBox>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

We fire the trigger when the channel switch starts, but
the delay is configurable. That makes is easier to catch
channel switches that fail.

Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-fw-error-dump.h | 2 ++
 drivers/net/wireless/iwlwifi/mvm/mac80211.c      | 3 +++
 2 files changed, 5 insertions(+)

diff --git a/drivers/net/wireless/iwlwifi/iwl-fw-error-dump.h b/drivers/net/wireless/iwlwifi/iwl-fw-error-dump.h
index 7d74126..1ee58b3 100644
--- a/drivers/net/wireless/iwlwifi/iwl-fw-error-dump.h
+++ b/drivers/net/wireless/iwlwifi/iwl-fw-error-dump.h
@@ -243,12 +243,14 @@ iwl_fw_error_next_data(struct iwl_fw_error_dump_data *data)
  * @FW_DBG_TRIGGER_FW_ASSERT: trigger log collection when the firmware asserts
  * @FW_DBG_TRIGGER_MISSED_BEACONS: trigger log collection when beacons are
  *	missed.
+ * @FW_DBG_TRIGGER_CHANNEL_SWITCH: trigger log collection upon channel switch.
  */
 enum iwl_fw_dbg_trigger {
 	FW_DBG_TRIGGER_INVALID = 0,
 	FW_DBG_TRIGGER_USER,
 	FW_DBG_TRIGGER_FW_ASSERT,
 	FW_DBG_TRIGGER_MISSED_BEACONS,
+	FW_DBG_TRIGGER_CHANNEL_SWITCH,
 
 	/* must be last */
 	FW_DBG_TRIGGER_MAX,
diff --git a/drivers/net/wireless/iwlwifi/mvm/mac80211.c b/drivers/net/wireless/iwlwifi/mvm/mac80211.c
index 3b6b9f6..5a5d5c8 100644
--- a/drivers/net/wireless/iwlwifi/mvm/mac80211.c
+++ b/drivers/net/wireless/iwlwifi/mvm/mac80211.c
@@ -3481,6 +3481,9 @@ static int iwl_mvm_pre_channel_switch(struct ieee80211_hw *hw,
 	IWL_DEBUG_MAC80211(mvm, "pre CSA to freq %d\n",
 			   chsw->chandef.center_freq1);
 
+	iwl_fw_dbg_trigger_simple_stop(mvm, vif, FW_DBG_TRIGGER_CHANNEL_SWITCH,
+				       NULL, 0);
+
 	switch (vif->type) {
 	case NL80211_IFTYPE_AP:
 		csa_vif =
-- 
1.9.1

