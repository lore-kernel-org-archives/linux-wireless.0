Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga09.intel.com ([134.134.136.24]:51544 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755225Ab2CDUnN (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sun, 4 Mar 2012 15:43:13 -0500
From: Wey-Yi Guy <wey-yi.w.guy@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	Johannes Berg <johannes.berg@intel.com>,
	Wey-Yi Guy <wey-yi.w.guy@intel.com>
Subject: [PATCH 097/101] iwlwifi: make iwl_init_context static
Date: Sun,  4 Mar 2012 11:29:51 -0800
Message-Id: <1330889395-533-98-git-send-email-wey-yi.w.guy@intel.com> (sfid-20120304_214430_837533_07394879)
In-Reply-To: <1330889395-533-1-git-send-email-wey-yi.w.guy@intel.com>
References: <1330889395-533-1-git-send-email-wey-yi.w.guy@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

It's not needed anywhere but during init.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Wey-Yi Guy <wey-yi.w.guy@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-agn.c |    2 +-
 drivers/net/wireless/iwlwifi/iwl-agn.h |    1 -
 2 files changed, 1 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-agn.c b/drivers/net/wireless/iwlwifi/iwl-agn.c
index 76ee2dd..f150edc 100644
--- a/drivers/net/wireless/iwlwifi/iwl-agn.c
+++ b/drivers/net/wireless/iwlwifi/iwl-agn.c
@@ -488,7 +488,7 @@ static void iwl_bg_tx_flush(struct work_struct *work)
 	iwlagn_dev_txfifo_flush(priv, IWL_DROP_ALL);
 }
 
-void iwl_init_context(struct iwl_priv *priv, u32 ucode_flags)
+static void iwl_init_context(struct iwl_priv *priv, u32 ucode_flags)
 {
 	int i;
 
diff --git a/drivers/net/wireless/iwlwifi/iwl-agn.h b/drivers/net/wireless/iwlwifi/iwl-agn.h
index eb96855..5410dfd 100644
--- a/drivers/net/wireless/iwlwifi/iwl-agn.h
+++ b/drivers/net/wireless/iwlwifi/iwl-agn.h
@@ -118,7 +118,6 @@ void iwlagn_config_ht40(struct ieee80211_conf *conf,
 int iwlagn_rx_calib_result(struct iwl_priv *priv,
 			    struct iwl_rx_cmd_buffer *rxb,
 			    struct iwl_device_cmd *cmd);
-void iwl_init_context(struct iwl_priv *priv, u32 ucode_flags);
 int iwl_send_bt_env(struct iwl_priv *priv, u8 action, u8 type);
 void iwl_send_prio_tbl(struct iwl_priv *priv);
 int iwl_init_alive_start(struct iwl_priv *priv);
-- 
1.7.0.4

