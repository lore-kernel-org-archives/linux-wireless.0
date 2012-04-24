Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga11.intel.com ([192.55.52.93]:8196 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758586Ab2DXXv3 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 24 Apr 2012 19:51:29 -0400
From: Wey-Yi Guy <wey-yi.w.guy@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org, Wey-Yi Guy <wey-yi.w.guy@intel.com>
Subject: [PATCH 06/11] iwlwifi: send reduce tx power info in command
Date: Tue, 24 Apr 2012 16:45:59 -0700
Message-Id: <1335311164-10252-7-git-send-email-wey-yi.w.guy@intel.com> (sfid-20120425_015157_848095_1139ECA0)
In-Reply-To: <1335311164-10252-1-git-send-email-wey-yi.w.guy@intel.com>
References: <1335311164-10252-1-git-send-email-wey-yi.w.guy@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Add the reduce tx power information in bt coex host command

Signed-off-by: Wey-Yi Guy <wey-yi.w.guy@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-agn-lib.c  |    1 +
 drivers/net/wireless/iwlwifi/iwl-commands.h |    3 ++-
 2 files changed, 3 insertions(+), 1 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-agn-lib.c b/drivers/net/wireless/iwlwifi/iwl-agn-lib.c
index 994a7da..ac483eb 100644
--- a/drivers/net/wireless/iwlwifi/iwl-agn-lib.c
+++ b/drivers/net/wireless/iwlwifi/iwl-agn-lib.c
@@ -256,6 +256,7 @@ void iwlagn_send_advance_bt_config(struct iwl_priv *priv)
 
 	basic.kill_ack_mask = priv->kill_ack_mask;
 	basic.kill_cts_mask = priv->kill_cts_mask;
+	basic.reduce_txpower = priv->reduced_txpower;
 	basic.valid = priv->bt_valid;
 
 	/*
diff --git a/drivers/net/wireless/iwlwifi/iwl-commands.h b/drivers/net/wireless/iwlwifi/iwl-commands.h
index 15e9bfb..e5dfbfd 100644
--- a/drivers/net/wireless/iwlwifi/iwl-commands.h
+++ b/drivers/net/wireless/iwlwifi/iwl-commands.h
@@ -1916,7 +1916,8 @@ struct iwl_basic_bt_cmd {
 	u8 bt3_timer_t2_value;
 	__le16 bt4_reaction_time; /* unused */
 	__le32 bt3_lookup_table[IWLAGN_BT_DECISION_LUT_SIZE];
-	__le16 bt4_decision_time; /* unused */
+	u8 reduce_txpower;
+	u8 reserved;
 	__le16 valid;
 };
 
-- 
1.7.0.4

