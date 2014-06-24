Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wg0-f49.google.com ([74.125.82.49]:55566 "EHLO
	mail-wg0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755280AbaFXTxF (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 24 Jun 2014 15:53:05 -0400
Received: by mail-wg0-f49.google.com with SMTP id y10so950368wgg.32
        for <linux-wireless@vger.kernel.org>; Tue, 24 Jun 2014 12:53:03 -0700 (PDT)
From: Emmanuel Grumbach <egrumbach@gmail.com>
To: linux-wireless@vger.kernel.org
Cc: David Spinadel <david.spinadel@intel.com>,
	Andrei Otcheretianski <andrei.otcheretianski@intel.com>,
	Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Subject: [PATCH 25/27] iwlwifi: mvm: support extended beacon notification
Date: Tue, 24 Jun 2014 22:52:19 +0300
Message-Id: <1403639541-4621-25-git-send-email-egrumbach@gmail.com> (sfid-20140624_220200_706284_EEA03ACF)
In-Reply-To: <53A9D6CF.9040100@gmail.com>
References: <53A9D6CF.9040100@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: David Spinadel <david.spinadel@intel.com>

Use extended beacon notification when supported by FW.
Set last beacon system time to AP or GO interface.
System time of last beacon can be used to avoid TBTT overlapping
between two interfaces, CSA and other uses.

Signed-off-by: David Spinadel <david.spinadel@intel.com>
Signed-off-by: Andrei Otcheretianski <andrei.otcheretianski@intel.com>
Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-fw.h        |  2 ++
 drivers/net/wireless/iwlwifi/mvm/fw-api-tx.h | 14 ++++++++++++
 drivers/net/wireless/iwlwifi/mvm/mac-ctxt.c  | 32 +++++++++++++++++++---------
 drivers/net/wireless/iwlwifi/mvm/mac80211.c  |  1 +
 drivers/net/wireless/iwlwifi/mvm/mvm.h       |  3 +++
 5 files changed, 42 insertions(+), 10 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-fw.h b/drivers/net/wireless/iwlwifi/iwl-fw.h
index c713310..13e5d69 100644
--- a/drivers/net/wireless/iwlwifi/iwl-fw.h
+++ b/drivers/net/wireless/iwlwifi/iwl-fw.h
@@ -119,11 +119,13 @@ enum iwl_ucode_tlv_flag {
 /**
  * enum iwl_ucode_tlv_api - ucode api
  * @IWL_UCODE_TLV_API_WOWLAN_CONFIG_TID: wowlan config includes tid field.
+ * @IWL_UCODE_TLV_CAPA_EXTENDED_BEACON: Support Extended beacon notification
  * @IWL_UCODE_TLV_API_CSA_FLOW: ucode can do unbind-bind flow for CSA.
  * @IWL_UCODE_TLV_API_DISABLE_STA_TX: ucode supports tx_disable bit.
  */
 enum iwl_ucode_tlv_api {
 	IWL_UCODE_TLV_API_WOWLAN_CONFIG_TID	= BIT(0),
+	IWL_UCODE_TLV_CAPA_EXTENDED_BEACON	= BIT(1),
 	IWL_UCODE_TLV_API_CSA_FLOW		= BIT(4),
 	IWL_UCODE_TLV_API_DISABLE_STA_TX	= BIT(5),
 };
diff --git a/drivers/net/wireless/iwlwifi/mvm/fw-api-tx.h b/drivers/net/wireless/iwlwifi/mvm/fw-api-tx.h
index 6cc5f52..bdd6ff6 100644
--- a/drivers/net/wireless/iwlwifi/mvm/fw-api-tx.h
+++ b/drivers/net/wireless/iwlwifi/mvm/fw-api-tx.h
@@ -549,6 +549,20 @@ struct iwl_beacon_notif {
 } __packed;
 
 /**
+ * struct iwl_extended_beacon_notif - notifies about beacon transmission
+ * @beacon_notify_hdr: tx response command associated with the beacon
+ * @tsf: last beacon tsf
+ * @ibss_mgr_status: whether IBSS is manager
+ * @gp2: last beacon time in gp2
+ */
+struct iwl_extended_beacon_notif {
+	struct iwl_mvm_tx_resp beacon_notify_hdr;
+	__le64 tsf;
+	__le32 ibss_mgr_status;
+	__le32 gp2;
+} __packed; /* BEACON_NTFY_API_S_VER_5 */
+
+/**
  * enum iwl_dump_control - dump (flush) control flags
  * @DUMP_TX_FIFO_FLUSH: Dump MSDUs until the the FIFO is empty
  *	and the TFD queues are empty.
diff --git a/drivers/net/wireless/iwlwifi/mvm/mac-ctxt.c b/drivers/net/wireless/iwlwifi/mvm/mac-ctxt.c
index 8b53027..3b0390b 100644
--- a/drivers/net/wireless/iwlwifi/mvm/mac-ctxt.c
+++ b/drivers/net/wireless/iwlwifi/mvm/mac-ctxt.c
@@ -1205,19 +1205,31 @@ int iwl_mvm_rx_beacon_notif(struct iwl_mvm *mvm,
 			    struct iwl_device_cmd *cmd)
 {
 	struct iwl_rx_packet *pkt = rxb_addr(rxb);
-	struct iwl_beacon_notif *beacon = (void *)pkt->data;
-	u16 status __maybe_unused =
-		le16_to_cpu(beacon->beacon_notify_hdr.status.status);
-	u32 rate __maybe_unused =
-		le32_to_cpu(beacon->beacon_notify_hdr.initial_rate);
+	struct iwl_mvm_tx_resp *beacon_notify_hdr;
+	u64 tsf;
 
 	lockdep_assert_held(&mvm->mutex);
 
-	IWL_DEBUG_RX(mvm, "beacon status %#x retries:%d tsf:0x%16llX rate:%d\n",
-		     status & TX_STATUS_MSK,
-		     beacon->beacon_notify_hdr.failure_frame,
-		     le64_to_cpu(beacon->tsf),
-		     rate);
+	if (mvm->fw->ucode_capa.api[0] & IWL_UCODE_TLV_CAPA_EXTENDED_BEACON) {
+		struct iwl_extended_beacon_notif *beacon = (void *)pkt->data;
+
+		beacon_notify_hdr = &beacon->beacon_notify_hdr;
+		tsf = le64_to_cpu(beacon->tsf);
+		mvm->ap_last_beacon_gp2 = le32_to_cpu(beacon->gp2);
+	} else {
+		struct iwl_beacon_notif *beacon = (void *)pkt->data;
+
+		beacon_notify_hdr = &beacon->beacon_notify_hdr;
+		tsf = le64_to_cpu(beacon->tsf);
+	}
+
+	IWL_DEBUG_RX(mvm,
+		     "beacon status %#x retries:%d tsf:0x%16llX gp2:0x%X rate:%d\n",
+		     le16_to_cpu(beacon_notify_hdr->status.status) &
+								TX_STATUS_MSK,
+		     beacon_notify_hdr->failure_frame, tsf,
+		     mvm->ap_last_beacon_gp2,
+		     le32_to_cpu(beacon_notify_hdr->initial_rate));
 
 	if (unlikely(mvm->csa_vif && mvm->csa_vif->csa_active)) {
 		if (!ieee80211_csa_is_complete(mvm->csa_vif)) {
diff --git a/drivers/net/wireless/iwlwifi/mvm/mac80211.c b/drivers/net/wireless/iwlwifi/mvm/mac80211.c
index f22be88..f2fde36 100644
--- a/drivers/net/wireless/iwlwifi/mvm/mac80211.c
+++ b/drivers/net/wireless/iwlwifi/mvm/mac80211.c
@@ -1465,6 +1465,7 @@ static void iwl_mvm_stop_ap_ibss(struct ieee80211_hw *hw,
 	mutex_lock(&mvm->mutex);
 
 	mvmvif->ap_ibss_active = false;
+	mvm->ap_last_beacon_gp2 = 0;
 
 	iwl_mvm_bt_coex_vif_change(mvm);
 
diff --git a/drivers/net/wireless/iwlwifi/mvm/mvm.h b/drivers/net/wireless/iwlwifi/mvm/mvm.h
index 8419840..da69258 100644
--- a/drivers/net/wireless/iwlwifi/mvm/mvm.h
+++ b/drivers/net/wireless/iwlwifi/mvm/mvm.h
@@ -658,6 +658,9 @@ struct iwl_mvm {
 	bool ps_disabled;
 
 	struct ieee80211_vif *csa_vif;
+
+	/* system time of last beacon (for AP/GO interface) */
+	u32 ap_last_beacon_gp2;
 };
 
 /* Extract MVM priv from op_mode and _hw */
-- 
1.8.3.2

