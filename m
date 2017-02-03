Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from paleale.coelho.fi ([176.9.41.70]:37840 "EHLO
        farmhouse.coelho.fi" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1752641AbdBCOi1 (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 3 Feb 2017 09:38:27 -0500
From: Luca Coelho <luca@coelho.fi>
To: linux-wireless@vger.kernel.org
Cc: kvalo@codeaurora.org, Golan Ben-Ami <golan.ben.ami@intel.com>,
        Luca Coelho <luciano.coelho@intel.com>
Date: Fri,  3 Feb 2017 16:37:50 +0200
Message-Id: <20170203143812.7525-4-luca@coelho.fi> (sfid-20170203_153831_102360_F9662DF1)
In-Reply-To: <20170203143812.7525-1-luca@coelho.fi>
References: <20170203143812.7525-1-luca@coelho.fi>
Subject: [PATCH 03/25] iwlwifi: mvm: support v2 of mfuart load notification
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Golan Ben-Ami <golan.ben.ami@intel.com>

Add to the v1 of the mfuart loading notification, the size
of the mfuart image, and write it to dmesg once the notification
is received.

Signed-off-by: Golan Ben-Ami <golan.ben.ami@intel.com>
Signed-off-by: Luca Coelho <luciano.coelho@intel.com>
---
 drivers/net/wireless/intel/iwlwifi/mvm/fw-api.h |  5 ++++-
 drivers/net/wireless/intel/iwlwifi/mvm/fw.c     | 21 +++++++++++++++------
 2 files changed, 19 insertions(+), 7 deletions(-)

diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/fw-api.h b/drivers/net/wireless/intel/iwlwifi/mvm/fw-api.h
index 563b17796017..0b77073e719a 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/fw-api.h
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/fw-api.h
@@ -1256,13 +1256,16 @@ struct iwl_missed_beacons_notif {
  * @external_ver: external image version
  * @status: MFUART loading status
  * @duration: MFUART loading time
+ * @image_size: MFUART image size in bytes
 */
 struct iwl_mfuart_load_notif {
 	__le32 installed_ver;
 	__le32 external_ver;
 	__le32 status;
 	__le32 duration;
-} __packed; /*MFU_LOADER_NTFY_API_S_VER_1*/
+	/* image size valid only in v2 of the command */
+	__le32 image_size;
+} __packed; /*MFU_LOADER_NTFY_API_S_VER_2*/
 
 /**
  * struct iwl_set_calib_default_cmd - set default value for calibration.
diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/fw.c b/drivers/net/wireless/intel/iwlwifi/mvm/fw.c
index dd8c8d8e9f18..3c70fb1199d7 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/fw.c
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/fw.c
@@ -1407,10 +1407,19 @@ void iwl_mvm_rx_mfuart_notif(struct iwl_mvm *mvm,
 	struct iwl_rx_packet *pkt = rxb_addr(rxb);
 	struct iwl_mfuart_load_notif *mfuart_notif = (void *)pkt->data;
 
-	IWL_DEBUG_INFO(mvm,
-		       "MFUART: installed ver: 0x%08x, external ver: 0x%08x, status: 0x%08x, duration: 0x%08x\n",
-		       le32_to_cpu(mfuart_notif->installed_ver),
-		       le32_to_cpu(mfuart_notif->external_ver),
-		       le32_to_cpu(mfuart_notif->status),
-		       le32_to_cpu(mfuart_notif->duration));
+	if (iwl_rx_packet_payload_len(pkt) == sizeof(*mfuart_notif))
+		IWL_DEBUG_INFO(mvm,
+			       "MFUART: installed ver: 0x%08x, external ver: 0x%08x, status: 0x%08x, duration: 0x%08x, image size: 0x%08x\n",
+			       le32_to_cpu(mfuart_notif->installed_ver),
+			       le32_to_cpu(mfuart_notif->external_ver),
+			       le32_to_cpu(mfuart_notif->status),
+			       le32_to_cpu(mfuart_notif->duration),
+			       le32_to_cpu(mfuart_notif->image_size));
+	else
+		IWL_DEBUG_INFO(mvm,
+			       "MFUART: installed ver: 0x%08x, external ver: 0x%08x, status: 0x%08x, duration: 0x%08x\n",
+			       le32_to_cpu(mfuart_notif->installed_ver),
+			       le32_to_cpu(mfuart_notif->external_ver),
+			       le32_to_cpu(mfuart_notif->status),
+			       le32_to_cpu(mfuart_notif->duration));
 }
-- 
2.11.0
