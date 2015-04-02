Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga02.intel.com ([134.134.136.20]:40007 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752718AbbDBGmZ (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 2 Apr 2015 02:42:25 -0400
From: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
To: linux-wireless@vger.kernel.org
Cc: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Subject: [PATCH 20/31] iwlwifi: check the size of the trigger struct from the firmware file
Date: Thu,  2 Apr 2015 09:41:08 +0300
Message-Id: <1427956879-11725-20-git-send-email-emmanuel.grumbach@intel.com> (sfid-20150402_090417_516962_220260F5)
In-Reply-To: <1427956656.8122.2.camel@egrumbacBox>
References: <1427956656.8122.2.camel@egrumbacBox>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

When we access the triggers we need to make sure that the
data we expect was actually provided by the firmware file.
Check this when we decode the triggers from the firmware
file.

Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-drv.c | 28 ++++++++++++++++++++++++++++
 1 file changed, 28 insertions(+)

diff --git a/drivers/net/wireless/iwlwifi/iwl-drv.c b/drivers/net/wireless/iwlwifi/iwl-drv.c
index 885c787..b8e5690 100644
--- a/drivers/net/wireless/iwlwifi/iwl-drv.c
+++ b/drivers/net/wireless/iwlwifi/iwl-drv.c
@@ -1102,6 +1102,7 @@ static void iwl_req_fw_callback(const struct firmware *ucode_raw, void *context)
 	const unsigned int api_max = drv->cfg->ucode_api_max;
 	unsigned int api_ok = drv->cfg->ucode_api_ok;
 	const unsigned int api_min = drv->cfg->ucode_api_min;
+	size_t trigger_tlv_sz[FW_DBG_TRIGGER_MAX];
 	u32 api_ver;
 	int i;
 	bool load_module = false;
@@ -1221,8 +1222,35 @@ static void iwl_req_fw_callback(const struct firmware *ucode_raw, void *context)
 		}
 	}
 
+	memset(&trigger_tlv_sz, 0xff, sizeof(trigger_tlv_sz));
+
+	trigger_tlv_sz[FW_DBG_TRIGGER_MISSED_BEACONS] =
+		sizeof(struct iwl_fw_dbg_trigger_missed_bcon);
+	trigger_tlv_sz[FW_DBG_TRIGGER_CHANNEL_SWITCH] = 0;
+	trigger_tlv_sz[FW_DBG_TRIGGER_FW_NOTIF] =
+		sizeof(struct iwl_fw_dbg_trigger_cmd);
+	trigger_tlv_sz[FW_DBG_TRIGGER_MLME] =
+		sizeof(struct iwl_fw_dbg_trigger_mlme);
+	trigger_tlv_sz[FW_DBG_TRIGGER_STATS] =
+		sizeof(struct iwl_fw_dbg_trigger_stats);
+	trigger_tlv_sz[FW_DBG_TRIGGER_RSSI] =
+		sizeof(struct iwl_fw_dbg_trigger_low_rssi);
+	trigger_tlv_sz[FW_DBG_TRIGGER_TXQ_TIMERS] =
+		sizeof(struct iwl_fw_dbg_trigger_txq_timer);
+
 	for (i = 0; i < ARRAY_SIZE(drv->fw.dbg_trigger_tlv); i++) {
 		if (pieces->dbg_trigger_tlv[i]) {
+			/*
+			 * If the trigger isn't long enough, WARN and exit.
+			 * Someone is trying to debug something and he won't
+			 * be able to catch the bug he is trying to chase.
+			 * We'd better be noisy to be sure he knows what's
+			 * going on.
+			 */
+			if (WARN_ON(pieces->dbg_trigger_tlv_len[i] <
+				    (trigger_tlv_sz[i] +
+				     sizeof(struct iwl_fw_dbg_trigger_tlv))))
+				goto out_free_fw;
 			drv->fw.dbg_trigger_tlv_len[i] =
 				pieces->dbg_trigger_tlv_len[i];
 			drv->fw.dbg_trigger_tlv[i] =
-- 
1.9.1

