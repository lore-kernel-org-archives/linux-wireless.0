Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga03.intel.com ([143.182.124.21]:63215 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752606Ab1BZTBP (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sat, 26 Feb 2011 14:01:15 -0500
From: Wey-Yi Guy <wey-yi.w.guy@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	ipw3945-devel@lists.sourceforge.net,
	Wey-Yi Guy <wey-yi.w.guy@intel.com>
Subject: [PATCH 1/5] iwlagn: name change for BT config command
Date: Sat, 26 Feb 2011 10:46:02 -0800
Message-Id: <1298745966-25130-2-git-send-email-wey-yi.w.guy@intel.com>
In-Reply-To: <1298745966-25130-1-git-send-email-wey-yi.w.guy@intel.com>
References: <1298745966-25130-1-git-send-email-wey-yi.w.guy@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

No functional changes, name changes to reflect the structure used by
6000 series.

Signed-off-by: Wey-Yi Guy <wey-yi.w.guy@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-agn-lib.c  |    2 +-
 drivers/net/wireless/iwlwifi/iwl-commands.h |    2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-agn-lib.c b/drivers/net/wireless/iwlwifi/iwl-agn-lib.c
index 0d0572c..8c70f0b 100644
--- a/drivers/net/wireless/iwlwifi/iwl-agn-lib.c
+++ b/drivers/net/wireless/iwlwifi/iwl-agn-lib.c
@@ -1804,7 +1804,7 @@ static const __le32 iwlagn_concurrent_lookup[12] = {
 
 void iwlagn_send_advance_bt_config(struct iwl_priv *priv)
 {
-	struct iwlagn_bt_cmd bt_cmd = {
+	struct iwl6000_bt_cmd bt_cmd = {
 		.max_kill = IWLAGN_BT_MAX_KILL_DEFAULT,
 		.bt3_timer_t7_value = IWLAGN_BT3_T7_DEFAULT,
 		.bt3_prio_sample_time = IWLAGN_BT3_PRIO_SAMPLE_DEFAULT,
diff --git a/drivers/net/wireless/iwlwifi/iwl-commands.h b/drivers/net/wireless/iwlwifi/iwl-commands.h
index 0a1d4ae..58919f8 100644
--- a/drivers/net/wireless/iwlwifi/iwl-commands.h
+++ b/drivers/net/wireless/iwlwifi/iwl-commands.h
@@ -2477,7 +2477,7 @@ struct iwl_bt_cmd {
 					IWLAGN_BT_VALID_BT4_TIMES | \
 					IWLAGN_BT_VALID_3W_LUT)
 
-struct iwlagn_bt_cmd {
+struct iwl6000_bt_cmd {
 	u8 flags;
 	u8 ledtime; /* unused */
 	u8 max_kill;
-- 
1.7.0.4

