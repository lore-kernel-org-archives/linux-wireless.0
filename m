Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga02.intel.com ([134.134.136.20]:37930 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754607AbbCLNGb (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 12 Mar 2015 09:06:31 -0400
From: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
To: linux-wireless@vger.kernel.org
Cc: Eran Harary <eran.harary@intel.com>,
	Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Subject: [PATCH 46/49] iwlwifi: mvm: Always enable the smart FIFO
Date: Thu, 12 Mar 2015 15:04:31 +0200
Message-Id: <1426165474-25586-46-git-send-email-emmanuel.grumbach@intel.com> (sfid-20150312_143419_830874_A1E719F4)
In-Reply-To: <1426164431.19690.4.camel@egrumbacBox>
References: <1426164431.19690.4.camel@egrumbacBox>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Eran Harary <eran.harary@intel.com>

We previously enabled the smart FIFO (SF) in BSS only after
association.
This cause interrupt latency on P2P on certain devices.
Change the working model to enable the SF all the time and
play with the timeout values based on the association state.
This change was not tested on older firwmares, so make it
happen only on -13.ucode and up.

Signed-off-by: Eran Harary <eran.harary@intel.com>
Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
---
 drivers/net/wireless/iwlwifi/mvm/fw-api.h | 14 ++++++-
 drivers/net/wireless/iwlwifi/mvm/sf.c     | 64 ++++++++++++++++++++++++++-----
 2 files changed, 68 insertions(+), 10 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/mvm/fw-api.h b/drivers/net/wireless/iwlwifi/mvm/fw-api.h
index d89b0dd..aab68cb 100644
--- a/drivers/net/wireless/iwlwifi/mvm/fw-api.h
+++ b/drivers/net/wireless/iwlwifi/mvm/fw-api.h
@@ -1447,7 +1447,19 @@ enum iwl_sf_scenario {
 #define SF_W_MARK_LEGACY 4096
 #define SF_W_MARK_SCAN 4096
 
-/* SF Scenarios timers for FULL_ON state (aligned to 32 uSec) */
+/* SF Scenarios timers for default configuration (aligned to 32 uSec) */
+#define SF_SINGLE_UNICAST_IDLE_TIMER_DEF 160	/* 150 uSec  */
+#define SF_SINGLE_UNICAST_AGING_TIMER_DEF 400	/* 0.4 mSec */
+#define SF_AGG_UNICAST_IDLE_TIMER_DEF 160		/* 150 uSec */
+#define SF_AGG_UNICAST_AGING_TIMER_DEF 400		/* 0.4 mSec */
+#define SF_MCAST_IDLE_TIMER_DEF 160		/* 150 mSec */
+#define SF_MCAST_AGING_TIMER_DEF 400		/* 0.4 mSec */
+#define SF_BA_IDLE_TIMER_DEF 160			/* 150 uSec */
+#define SF_BA_AGING_TIMER_DEF 400			/* 0.4 mSec */
+#define SF_TX_RE_IDLE_TIMER_DEF 160			/* 150 uSec */
+#define SF_TX_RE_AGING_TIMER_DEF 400		/* 0.4 mSec */
+
+/* SF Scenarios timers for BSS MAC configuration (aligned to 32 uSec) */
 #define SF_SINGLE_UNICAST_IDLE_TIMER 320	/* 300 uSec  */
 #define SF_SINGLE_UNICAST_AGING_TIMER 2016	/* 2 mSec */
 #define SF_AGG_UNICAST_IDLE_TIMER 320		/* 300 uSec */
diff --git a/drivers/net/wireless/iwlwifi/mvm/sf.c b/drivers/net/wireless/iwlwifi/mvm/sf.c
index 4b9f6c6..b0f59fd 100644
--- a/drivers/net/wireless/iwlwifi/mvm/sf.c
+++ b/drivers/net/wireless/iwlwifi/mvm/sf.c
@@ -99,7 +99,35 @@ static void iwl_mvm_bound_iface_iterator(void *_data, u8 *mac,
 
 /*
  * Aging and idle timeouts for the different possible scenarios
- * in SF_FULL_ON state.
+ * in default configuration
+ */
+static const
+__le32 sf_full_timeout_def[SF_NUM_SCENARIO][SF_NUM_TIMEOUT_TYPES] = {
+	{
+		cpu_to_le32(SF_SINGLE_UNICAST_AGING_TIMER_DEF),
+		cpu_to_le32(SF_SINGLE_UNICAST_IDLE_TIMER_DEF)
+	},
+	{
+		cpu_to_le32(SF_AGG_UNICAST_AGING_TIMER_DEF),
+		cpu_to_le32(SF_AGG_UNICAST_IDLE_TIMER_DEF)
+	},
+	{
+		cpu_to_le32(SF_MCAST_AGING_TIMER_DEF),
+		cpu_to_le32(SF_MCAST_IDLE_TIMER_DEF)
+	},
+	{
+		cpu_to_le32(SF_BA_AGING_TIMER_DEF),
+		cpu_to_le32(SF_BA_IDLE_TIMER_DEF)
+	},
+	{
+		cpu_to_le32(SF_TX_RE_AGING_TIMER_DEF),
+		cpu_to_le32(SF_TX_RE_IDLE_TIMER_DEF)
+	},
+};
+
+/*
+ * Aging and idle timeouts for the different possible scenarios
+ * in single BSS MAC configuration.
  */
 static const __le32 sf_full_timeout[SF_NUM_SCENARIO][SF_NUM_TIMEOUT_TYPES] = {
 	{
@@ -124,7 +152,8 @@ static const __le32 sf_full_timeout[SF_NUM_SCENARIO][SF_NUM_TIMEOUT_TYPES] = {
 	},
 };
 
-static void iwl_mvm_fill_sf_command(struct iwl_sf_cfg_cmd *sf_cmd,
+static void iwl_mvm_fill_sf_command(struct iwl_mvm *mvm,
+				    struct iwl_sf_cfg_cmd *sf_cmd,
 				    struct ieee80211_sta *sta)
 {
 	int i, j, watermark;
@@ -163,22 +192,37 @@ static void iwl_mvm_fill_sf_command(struct iwl_sf_cfg_cmd *sf_cmd,
 					cpu_to_le32(SF_LONG_DELAY_AGING_TIMER);
 		}
 	}
-	BUILD_BUG_ON(sizeof(sf_full_timeout) !=
-		     sizeof(__le32) * SF_NUM_SCENARIO * SF_NUM_TIMEOUT_TYPES);
 
-	memcpy(sf_cmd->full_on_timeouts, sf_full_timeout,
-	       sizeof(sf_full_timeout));
+	if (sta || IWL_UCODE_API(mvm->fw->ucode_ver) < 13) {
+		BUILD_BUG_ON(sizeof(sf_full_timeout) !=
+			     sizeof(__le32) * SF_NUM_SCENARIO *
+			     SF_NUM_TIMEOUT_TYPES);
+
+		memcpy(sf_cmd->full_on_timeouts, sf_full_timeout,
+		       sizeof(sf_full_timeout));
+	} else {
+		BUILD_BUG_ON(sizeof(sf_full_timeout_def) !=
+			     sizeof(__le32) * SF_NUM_SCENARIO *
+			     SF_NUM_TIMEOUT_TYPES);
+
+		memcpy(sf_cmd->full_on_timeouts, sf_full_timeout_def,
+		       sizeof(sf_full_timeout_def));
+	}
+
 }
 
 static int iwl_mvm_sf_config(struct iwl_mvm *mvm, u8 sta_id,
 			     enum iwl_sf_state new_state)
 {
 	struct iwl_sf_cfg_cmd sf_cmd = {
-		.state = cpu_to_le32(new_state),
+		.state = cpu_to_le32(SF_FULL_ON),
 	};
 	struct ieee80211_sta *sta;
 	int ret = 0;
 
+	if (IWL_UCODE_API(mvm->fw->ucode_ver) < 13)
+		sf_cmd.state = cpu_to_le32(new_state);
+
 	if (mvm->cfg->disable_dummy_notification)
 		sf_cmd.state |= cpu_to_le32(SF_CFG_DUMMY_NOTIF_OFF);
 
@@ -191,6 +235,8 @@ static int iwl_mvm_sf_config(struct iwl_mvm *mvm, u8 sta_id,
 
 	switch (new_state) {
 	case SF_UNINIT:
+		if (IWL_UCODE_API(mvm->fw->ucode_ver) >= 13)
+			iwl_mvm_fill_sf_command(mvm, &sf_cmd, NULL);
 		break;
 	case SF_FULL_ON:
 		if (sta_id == IWL_MVM_STATION_COUNT) {
@@ -205,11 +251,11 @@ static int iwl_mvm_sf_config(struct iwl_mvm *mvm, u8 sta_id,
 			rcu_read_unlock();
 			return -EINVAL;
 		}
-		iwl_mvm_fill_sf_command(&sf_cmd, sta);
+		iwl_mvm_fill_sf_command(mvm, &sf_cmd, sta);
 		rcu_read_unlock();
 		break;
 	case SF_INIT_OFF:
-		iwl_mvm_fill_sf_command(&sf_cmd, NULL);
+		iwl_mvm_fill_sf_command(mvm, &sf_cmd, NULL);
 		break;
 	default:
 		WARN_ONCE(1, "Invalid state: %d. not sending Smart Fifo cmd\n",
-- 
1.9.1

