Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wg0-f42.google.com ([74.125.82.42]:42432 "EHLO
	mail-wg0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751295AbaBWT5R (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 23 Feb 2014 14:57:17 -0500
Received: by mail-wg0-f42.google.com with SMTP id k14so2191252wgh.5
        for <linux-wireless@vger.kernel.org>; Sun, 23 Feb 2014 11:57:15 -0800 (PST)
From: Emmanuel Grumbach <egrumbach@gmail.com>
To: linux-wireless@vger.kernel.org
Cc: Johannes Berg <johannes.berg@intel.com>,
	Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Subject: [PATCH 02/17] iwlwifi: make various things const
Date: Sun, 23 Feb 2014 21:56:53 +0200
Message-Id: <1393185428-8524-2-git-send-email-egrumbach@gmail.com> (sfid-20140223_205727_770363_16AB065E)
In-Reply-To: <530A51A4.6000007@gmail.com>
References: <530A51A4.6000007@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

There are a number of things in the .data section that should
really be in .rodata, for example all ops structs and strings.
Mark everything const that can be, leaving the .data section
pretty much empty.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
---
 drivers/net/wireless/iwlwifi/dvm/agn.h       |    4 ++--
 drivers/net/wireless/iwlwifi/dvm/devices.c   |    2 +-
 drivers/net/wireless/iwlwifi/dvm/mac80211.c  |    2 +-
 drivers/net/wireless/iwlwifi/dvm/rx.c        |    2 +-
 drivers/net/wireless/iwlwifi/iwl-trans.h     |    2 +-
 drivers/net/wireless/iwlwifi/mvm/mac80211.c  |    2 +-
 drivers/net/wireless/iwlwifi/mvm/mvm.h       |    3 +--
 drivers/net/wireless/iwlwifi/mvm/ops.c       |    2 +-
 drivers/net/wireless/iwlwifi/mvm/utils.c     |    4 ++--
 drivers/net/wireless/iwlwifi/pcie/internal.h |    2 +-
 10 files changed, 12 insertions(+), 13 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/dvm/agn.h b/drivers/net/wireless/iwlwifi/dvm/agn.h
index 562772d..c160dad 100644
--- a/drivers/net/wireless/iwlwifi/dvm/agn.h
+++ b/drivers/net/wireless/iwlwifi/dvm/agn.h
@@ -109,7 +109,7 @@ extern const struct iwl_dvm_cfg iwl_dvm_6030_cfg;
 
 struct iwl_ucode_capabilities;
 
-extern struct ieee80211_ops iwlagn_hw_ops;
+extern const struct ieee80211_ops iwlagn_hw_ops;
 
 static inline void iwl_set_calib_hdr(struct iwl_calib_hdr *hdr, u8 cmd)
 {
@@ -480,7 +480,7 @@ do {									\
 } while (0)
 #endif				/* CONFIG_IWLWIFI_DEBUG */
 
-extern const char *iwl_dvm_cmd_strings[REPLY_MAX];
+extern const char *const iwl_dvm_cmd_strings[REPLY_MAX];
 
 static inline const char *iwl_dvm_get_cmd_string(u8 cmd)
 {
diff --git a/drivers/net/wireless/iwlwifi/dvm/devices.c b/drivers/net/wireless/iwlwifi/dvm/devices.c
index 7b140e4..758c54e 100644
--- a/drivers/net/wireless/iwlwifi/dvm/devices.c
+++ b/drivers/net/wireless/iwlwifi/dvm/devices.c
@@ -317,7 +317,7 @@ static const struct iwl_sensitivity_ranges iwl5000_sensitivity = {
 	.nrg_th_cca = 62,
 };
 
-static struct iwl_sensitivity_ranges iwl5150_sensitivity = {
+static const struct iwl_sensitivity_ranges iwl5150_sensitivity = {
 	.min_nrg_cck = 95,
 	.auto_corr_min_ofdm = 90,
 	.auto_corr_min_ofdm_mrc = 170,
diff --git a/drivers/net/wireless/iwlwifi/dvm/mac80211.c b/drivers/net/wireless/iwlwifi/dvm/mac80211.c
index c24d1d3..f576089 100644
--- a/drivers/net/wireless/iwlwifi/dvm/mac80211.c
+++ b/drivers/net/wireless/iwlwifi/dvm/mac80211.c
@@ -1564,7 +1564,7 @@ static void iwlagn_mac_sta_notify(struct ieee80211_hw *hw,
 	IWL_DEBUG_MAC80211(priv, "leave\n");
 }
 
-struct ieee80211_ops iwlagn_hw_ops = {
+const struct ieee80211_ops iwlagn_hw_ops = {
 	.tx = iwlagn_mac_tx,
 	.start = iwlagn_mac_start,
 	.stop = iwlagn_mac_stop,
diff --git a/drivers/net/wireless/iwlwifi/dvm/rx.c b/drivers/net/wireless/iwlwifi/dvm/rx.c
index 7a1bc1c..cd83773 100644
--- a/drivers/net/wireless/iwlwifi/dvm/rx.c
+++ b/drivers/net/wireless/iwlwifi/dvm/rx.c
@@ -39,7 +39,7 @@
 
 #define IWL_CMD_ENTRY(x) [x] = #x
 
-const char *iwl_dvm_cmd_strings[REPLY_MAX] = {
+const char *const iwl_dvm_cmd_strings[REPLY_MAX] = {
 	IWL_CMD_ENTRY(REPLY_ALIVE),
 	IWL_CMD_ENTRY(REPLY_ERROR),
 	IWL_CMD_ENTRY(REPLY_ECHO),
diff --git a/drivers/net/wireless/iwlwifi/iwl-trans.h b/drivers/net/wireless/iwlwifi/iwl-trans.h
index 7b19274..8cdb0dd 100644
--- a/drivers/net/wireless/iwlwifi/iwl-trans.h
+++ b/drivers/net/wireless/iwlwifi/iwl-trans.h
@@ -393,7 +393,7 @@ struct iwl_trans_config {
 	bool rx_buf_size_8k;
 	bool bc_table_dword;
 	unsigned int queue_watchdog_timeout;
-	const char **command_names;
+	const char *const *command_names;
 };
 
 struct iwl_trans;
diff --git a/drivers/net/wireless/iwlwifi/mvm/mac80211.c b/drivers/net/wireless/iwlwifi/mvm/mac80211.c
index ba4dcab..42f7046 100644
--- a/drivers/net/wireless/iwlwifi/mvm/mac80211.c
+++ b/drivers/net/wireless/iwlwifi/mvm/mac80211.c
@@ -2233,7 +2233,7 @@ static int iwl_mvm_mac_testmode_cmd(struct ieee80211_hw *hw,
 }
 #endif
 
-struct ieee80211_ops iwl_mvm_hw_ops = {
+const struct ieee80211_ops iwl_mvm_hw_ops = {
 	.tx = iwl_mvm_mac_tx,
 	.ampdu_action = iwl_mvm_mac_ampdu_action,
 	.start = iwl_mvm_mac_start,
diff --git a/drivers/net/wireless/iwlwifi/mvm/mvm.h b/drivers/net/wireless/iwlwifi/mvm/mvm.h
index ebea5f2..bde8190 100644
--- a/drivers/net/wireless/iwlwifi/mvm/mvm.h
+++ b/drivers/net/wireless/iwlwifi/mvm/mvm.h
@@ -91,8 +91,7 @@ enum iwl_mvm_tx_fifo {
 	IWL_MVM_TX_FIFO_MCAST = 5,
 };
 
-extern struct ieee80211_ops iwl_mvm_hw_ops;
-extern const struct iwl_mvm_power_ops pm_mac_ops;
+extern const struct ieee80211_ops iwl_mvm_hw_ops;
 
 /**
  * struct iwl_mvm_mod_params - module parameters for iwlmvm
diff --git a/drivers/net/wireless/iwlwifi/mvm/ops.c b/drivers/net/wireless/iwlwifi/mvm/ops.c
index a46f0b8..ae347fb 100644
--- a/drivers/net/wireless/iwlwifi/mvm/ops.c
+++ b/drivers/net/wireless/iwlwifi/mvm/ops.c
@@ -245,7 +245,7 @@ static const struct iwl_rx_handlers iwl_mvm_rx_handlers[] = {
 #undef RX_HANDLER
 #define CMD(x) [x] = #x
 
-static const char *iwl_mvm_cmd_strings[REPLY_MAX] = {
+static const char *const iwl_mvm_cmd_strings[REPLY_MAX] = {
 	CMD(MVM_ALIVE),
 	CMD(REPLY_ERROR),
 	CMD(INIT_COMPLETE_NOTIF),
diff --git a/drivers/net/wireless/iwlwifi/mvm/utils.c b/drivers/net/wireless/iwlwifi/mvm/utils.c
index f4598cb..2021b57 100644
--- a/drivers/net/wireless/iwlwifi/mvm/utils.c
+++ b/drivers/net/wireless/iwlwifi/mvm/utils.c
@@ -289,8 +289,8 @@ u8 iwl_mvm_next_antenna(struct iwl_mvm *mvm, u8 valid, u8 last_idx)
 	return last_idx;
 }
 
-static struct {
-	char *name;
+static const struct {
+	const char *name;
 	u8 num;
 } advanced_lookup[] = {
 	{ "NMI_INTERRUPT_WDG", 0x34 },
diff --git a/drivers/net/wireless/iwlwifi/pcie/internal.h b/drivers/net/wireless/iwlwifi/pcie/internal.h
index e851f26..3120bc5 100644
--- a/drivers/net/wireless/iwlwifi/pcie/internal.h
+++ b/drivers/net/wireless/iwlwifi/pcie/internal.h
@@ -304,7 +304,7 @@ struct iwl_trans_pcie {
 	bool bc_table_dword;
 	u32 rx_page_order;
 
-	const char **command_names;
+	const char *const *command_names;
 
 	/* queue watchdog */
 	unsigned long wd_timeout;
-- 
1.7.9.5

