Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wg0-f51.google.com ([74.125.82.51]:50943 "EHLO
	mail-wg0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932354AbaKXOgu (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 24 Nov 2014 09:36:50 -0500
Received: by mail-wg0-f51.google.com with SMTP id k14so12246603wgh.38
        for <linux-wireless@vger.kernel.org>; Mon, 24 Nov 2014 06:36:49 -0800 (PST)
From: Emmanuel Grumbach <egrumbach@gmail.com>
To: linux-wireless@vger.kernel.org
Cc: Chaya Rachel Ivgy <chaya.rachel.ivgi@intel.com>,
	Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Subject: [PATCH 70/75] iwlwifi: mvm: add support to MFUART loading notification
Date: Mon, 24 Nov 2014 16:34:46 +0200
Message-Id: <1416839691-28533-70-git-send-email-egrumbach@gmail.com> (sfid-20141124_153701_891325_B25A3944)
In-Reply-To: <CANUX_P32q7EFvuOvm+c=yYP9okVEfSUvdDg0gDHHCSg2G+gA0g@mail.gmail.com>
References: <CANUX_P32q7EFvuOvm+c=yYP9okVEfSUvdDg0gDHHCSg2G+gA0g@mail.gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Chaya Rachel Ivgy <chaya.rachel.ivgi@intel.com>

Add support to MFUART loading notification (print notification
data with IWL_DEBUG_INFO)

Signed-off-by: Chaya Rachel Ivgy <chaya.rachel.ivgi@intel.com>
Reviewed-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
---
 drivers/net/wireless/iwlwifi/mvm/fw-api.h | 17 +++++++++++++++++
 drivers/net/wireless/iwlwifi/mvm/fw.c     | 16 ++++++++++++++++
 drivers/net/wireless/iwlwifi/mvm/mvm.h    |  2 ++
 drivers/net/wireless/iwlwifi/mvm/ops.c    |  1 +
 4 files changed, 36 insertions(+)

diff --git a/drivers/net/wireless/iwlwifi/mvm/fw-api.h b/drivers/net/wireless/iwlwifi/mvm/fw-api.h
index 0f3c07a..2ff4f41 100644
--- a/drivers/net/wireless/iwlwifi/mvm/fw-api.h
+++ b/drivers/net/wireless/iwlwifi/mvm/fw-api.h
@@ -201,6 +201,8 @@ enum {
 	/* Power - new power table command */
 	MAC_PM_POWER_TABLE = 0xa9,
 
+	MFUART_LOAD_NOTIFICATION = 0xb1,
+
 	REPLY_RX_PHY_CMD = 0xc0,
 	REPLY_RX_MPDU_CMD = 0xc1,
 	BA_NOTIF = 0xc5,
@@ -1212,6 +1214,21 @@ struct iwl_missed_beacons_notif {
 } __packed; /* MISSED_BEACON_NTFY_API_S_VER_3 */
 
 /**
+ * struct iwl_mfuart_load_notif - mfuart image version & status
+ * ( MFUART_LOAD_NOTIFICATION = 0xb1 )
+ * @installed_ver: installed image version
+ * @external_ver: external image version
+ * @status: MFUART loading status
+ * @duration: MFUART loading time
+*/
+struct iwl_mfuart_load_notif {
+	__le32 installed_ver;
+	__le32 external_ver;
+	__le32 status;
+	__le32 duration;
+} __packed; /*MFU_LOADER_NTFY_API_S_VER_1*/
+
+/**
  * struct iwl_set_calib_default_cmd - set default value for calibration.
  * ( SET_CALIB_DEFAULT_CMD = 0x8e )
  * @calib_index: the calibration to set value for
diff --git a/drivers/net/wireless/iwlwifi/mvm/fw.c b/drivers/net/wireless/iwlwifi/mvm/fw.c
index 5757790..bbb78710 100644
--- a/drivers/net/wireless/iwlwifi/mvm/fw.c
+++ b/drivers/net/wireless/iwlwifi/mvm/fw.c
@@ -599,3 +599,19 @@ int iwl_mvm_rx_radio_ver(struct iwl_mvm *mvm, struct iwl_rx_cmd_buffer *rxb,
 		       le32_to_cpu(radio_version->radio_dash));
 	return 0;
 }
+
+int iwl_mvm_rx_mfuart_notif(struct iwl_mvm *mvm,
+			    struct iwl_rx_cmd_buffer *rxb,
+			    struct iwl_device_cmd *cmd)
+{
+	struct iwl_rx_packet *pkt = rxb_addr(rxb);
+	struct iwl_mfuart_load_notif *mfuart_notif = (void *)pkt->data;
+
+	IWL_DEBUG_INFO(mvm,
+		       "MFUART: installed ver: 0x%08x, external ver: 0x%08x, status: 0x%08x, duration: 0x%08x\n",
+		       le32_to_cpu(mfuart_notif->installed_ver),
+		       le32_to_cpu(mfuart_notif->external_ver),
+		       le32_to_cpu(mfuart_notif->status),
+		       le32_to_cpu(mfuart_notif->duration));
+	return 0;
+}
diff --git a/drivers/net/wireless/iwlwifi/mvm/mvm.h b/drivers/net/wireless/iwlwifi/mvm/mvm.h
index e6079f4..2ab59b8 100644
--- a/drivers/net/wireless/iwlwifi/mvm/mvm.h
+++ b/drivers/net/wireless/iwlwifi/mvm/mvm.h
@@ -964,6 +964,8 @@ int iwl_mvm_rx_card_state_notif(struct iwl_mvm *mvm,
 				struct iwl_device_cmd *cmd);
 int iwl_mvm_rx_radio_ver(struct iwl_mvm *mvm, struct iwl_rx_cmd_buffer *rxb,
 			 struct iwl_device_cmd *cmd);
+int iwl_mvm_rx_mfuart_notif(struct iwl_mvm *mvm, struct iwl_rx_cmd_buffer *rxb,
+			    struct iwl_device_cmd *cmd);
 
 /* MVM PHY */
 int iwl_mvm_phy_ctxt_add(struct iwl_mvm *mvm, struct iwl_mvm_phy_ctxt *ctxt,
diff --git a/drivers/net/wireless/iwlwifi/mvm/ops.c b/drivers/net/wireless/iwlwifi/mvm/ops.c
index cc83ef5..b3ae094 100644
--- a/drivers/net/wireless/iwlwifi/mvm/ops.c
+++ b/drivers/net/wireless/iwlwifi/mvm/ops.c
@@ -260,6 +260,7 @@ static const struct iwl_rx_handlers iwl_mvm_rx_handlers[] = {
 
 	RX_HANDLER(TDLS_CHANNEL_SWITCH_NOTIFICATION, iwl_mvm_rx_tdls_notif,
 		   true),
+	RX_HANDLER(MFUART_LOAD_NOTIFICATION, iwl_mvm_rx_mfuart_notif, false),
 
 };
 #undef RX_HANDLER
-- 
1.9.1

