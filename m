Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from paleale.coelho.fi ([176.9.41.70]:51884 "EHLO
        farmhouse.coelho.fi" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1753782AbdDNJFQ (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 14 Apr 2017 05:05:16 -0400
From: Luca Coelho <luca@coelho.fi>
To: linux-wireless@vger.kernel.org
Cc: kvalo@codeaurora.org,
        Emmanuel Grumbach <emmanuel.grumbach@intel.com>,
        Luca Coelho <luciano.coelho@intel.com>
Date: Fri, 14 Apr 2017 12:02:00 +0300
Message-Id: <20170414090210.31397-17-luca@coelho.fi> (sfid-20170414_110608_583355_774D7E3B)
In-Reply-To: <20170414090210.31397-1-luca@coelho.fi>
References: <20170414090210.31397-1-luca@coelho.fi>
Subject: [PATCH v2 16/26] iwlwifi: mvm: tell the firmware about the U-APSD parameters
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Emmanuel Grumbach <emmanuel.grumbach@intel.com>

Newer firmware versions will be able to handle all the
WMM-PS flows internally when we act as a GO. The firwmare
relies on the fact that the drivers puts frames for
different peers in different queues (DQA) to achieve this.
The driver will not be aware of the power state of the peers
anymore.

Tell the firmware about the WMM-PS parameters of earch peer
that connects to us so that it can know what are the
trigger-enabled ACs, the delivery-enableds ACs and the
Service Period length.

This API change is backward compatible since older firmware
versions will simply ignore the newly added values.

Since we don't support ieee80211 TSPECs for now, just copy
the trigger-enabled ACs to the delivery enabled ones.

Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Signed-off-by: Luca Coelho <luciano.coelho@intel.com>
---
 drivers/net/wireless/intel/iwlwifi/mvm/fw-api-sta.h | 11 ++++++-----
 drivers/net/wireless/intel/iwlwifi/mvm/sta.c        | 10 ++++++----
 2 files changed, 12 insertions(+), 9 deletions(-)

diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/fw-api-sta.h b/drivers/net/wireless/intel/iwlwifi/mvm/fw-api-sta.h
index 4f8648f53879..e79df1c53d68 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/fw-api-sta.h
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/fw-api-sta.h
@@ -179,7 +179,7 @@ enum iwl_sta_key_flag {
  * enum iwl_sta_modify_flag - indicate to the fw what flag are being changed
  * @STA_MODIFY_QUEUE_REMOVAL: this command removes a queue
  * @STA_MODIFY_TID_DISABLE_TX: this command modifies %tid_disable_tx
- * @STA_MODIFY_UAPSD_ACS: this command modifies %uapsd_trigger_acs
+ * @STA_MODIFY_UAPSD_ACS: this command modifies %uapsd_acs
  * @STA_MODIFY_ADD_BA_TID: this command modifies %add_immediate_ba_tid
  * @STA_MODIFY_REMOVE_BA_TID: this command modifies %remove_immediate_ba_tid
  * @STA_MODIFY_SLEEPING_STA_TX_COUNT: this command modifies %sleep_tx_count
@@ -354,8 +354,9 @@ struct iwl_mvm_add_sta_cmd_v7 {
  * @tfd_queue_msk: tfd queues used by this station.
  *	Obselete for new TX API (9 and above).
  * @rx_ba_window: aggregation window size
- * @scd_queue_bank: queue bank in used. Each bank contains 32 queues. 0 means
- *	that the queues used by this station are in the first 32.
+ * @sp_length: the size of the SP as it appears in the WME IE
+ * @uapsd_acs:  4 LS bits are trigger enabled ACs, 4 MS bits are the deliver
+ *	enabled ACs.
  *
  * The device contains an internal table of per-station information, with info
  * on security keys, aggregation parameters, and Tx rates for initial Tx
@@ -385,8 +386,8 @@ struct iwl_mvm_add_sta_cmd {
 	__le16 beamform_flags;
 	__le32 tfd_queue_msk;
 	__le16 rx_ba_window;
-	u8 scd_queue_bank;
-	u8 uapsd_trigger_acs;
+	u8 sp_length;
+	u8 uapsd_acs;
 } __packed; /* ADD_STA_CMD_API_S_VER_9 */
 
 /**
diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/sta.c b/drivers/net/wireless/intel/iwlwifi/mvm/sta.c
index ffbfd34d8e92..20a8f529760f 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/sta.c
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/sta.c
@@ -215,13 +215,15 @@ int iwl_mvm_sta_send_to_fw(struct iwl_mvm *mvm, struct ieee80211_sta *sta,
 		add_sta_cmd.modify_mask |= STA_MODIFY_UAPSD_ACS;
 
 		if (sta->uapsd_queues & IEEE80211_WMM_IE_STA_QOSINFO_AC_BK)
-			add_sta_cmd.uapsd_trigger_acs |= BIT(AC_BK);
+			add_sta_cmd.uapsd_acs |= BIT(AC_BK);
 		if (sta->uapsd_queues & IEEE80211_WMM_IE_STA_QOSINFO_AC_BE)
-			add_sta_cmd.uapsd_trigger_acs |= BIT(AC_BE);
+			add_sta_cmd.uapsd_acs |= BIT(AC_BE);
 		if (sta->uapsd_queues & IEEE80211_WMM_IE_STA_QOSINFO_AC_VI)
-			add_sta_cmd.uapsd_trigger_acs |= BIT(AC_VI);
+			add_sta_cmd.uapsd_acs |= BIT(AC_VI);
 		if (sta->uapsd_queues & IEEE80211_WMM_IE_STA_QOSINFO_AC_VO)
-			add_sta_cmd.uapsd_trigger_acs |= BIT(AC_VO);
+			add_sta_cmd.uapsd_acs |= BIT(AC_VO);
+		add_sta_cmd.uapsd_acs |= add_sta_cmd.uapsd_acs << 4;
+		add_sta_cmd.sp_length = sta->max_sp;
 	}
 
 	status = ADD_STA_SUCCESS;
-- 
2.11.0
