Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ea0-f176.google.com ([209.85.215.176]:51984 "EHLO
	mail-ea0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753965Ab3LQUpV (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 17 Dec 2013 15:45:21 -0500
Received: by mail-ea0-f176.google.com with SMTP id h14so3103802eaj.21
        for <linux-wireless@vger.kernel.org>; Tue, 17 Dec 2013 12:45:20 -0800 (PST)
From: Emmanuel Grumbach <egrumbach@gmail.com>
To: linux-wireless@vger.kernel.org
Cc: Alexander Bondar <alexander.bondar@intel.com>,
	Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Subject: [PATCH 25/36] iwlwifi: mvm: Add and examine TLV flag for P2P client uAPSD support
Date: Tue, 17 Dec 2013 22:44:28 +0200
Message-Id: <1387313079-28123-25-git-send-email-egrumbach@gmail.com> (sfid-20131217_215150_269045_F9906266)
In-Reply-To: <52B0B72A.5070704@gmail.com>
References: <52B0B72A.5070704@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Alexander Bondar <alexander.bondar@intel.com>

Current firmware doesn't handle well uAPSD in P2P Client.
When it will be fixed, the firmware will set a TLV flag to notify
the driver that uAPSD is supported in P2P client mode.
Check this flag when sending power command for P2P client.

Signed-off-by: Alexander Bondar <alexander.bondar@intel.com>
Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-fw.h    |    2 ++
 drivers/net/wireless/iwlwifi/mvm/power.c |    4 ++++
 2 files changed, 6 insertions(+)

diff --git a/drivers/net/wireless/iwlwifi/iwl-fw.h b/drivers/net/wireless/iwlwifi/iwl-fw.h
index 959562d..8704e304 100644
--- a/drivers/net/wireless/iwlwifi/iwl-fw.h
+++ b/drivers/net/wireless/iwlwifi/iwl-fw.h
@@ -94,6 +94,7 @@
  *	containing CAM (Continuous Active Mode) indication.
  * @IWL_UCODE_TLV_FLAGS_P2P_PS: P2P client power save is supported (only on a
  *	single bound interface).
+ * @IWL_UCODE_TLV_FLAGS_P2P_PS_UAPSD: P2P client supports uAPSD power save
  */
 enum iwl_ucode_tlv_flag {
 	IWL_UCODE_TLV_FLAGS_PAN			= BIT(0),
@@ -117,6 +118,7 @@ enum iwl_ucode_tlv_flag {
 	IWL_UCODE_TLV_FLAGS_DEVICE_PS_CMD	= BIT(20),
 	IWL_UCODE_TLV_FLAGS_P2P_PS		= BIT(21),
 	IWL_UCODE_TLV_FLAGS_UAPSD_SUPPORT	= BIT(24),
+	IWL_UCODE_TLV_FLAGS_P2P_PS_UAPSD	= BIT(26),
 };
 
 /* The default calibrate table size if not specified by firmware file */
diff --git a/drivers/net/wireless/iwlwifi/mvm/power.c b/drivers/net/wireless/iwlwifi/mvm/power.c
index d173ea2..483ecc6 100644
--- a/drivers/net/wireless/iwlwifi/mvm/power.c
+++ b/drivers/net/wireless/iwlwifi/mvm/power.c
@@ -358,6 +358,10 @@ static void iwl_mvm_power_build_cmd(struct iwl_mvm *mvm,
 	if (!memcmp(mvmvif->uapsd_misbehaving_bssid, vif->bss_conf.bssid,
 		    ETH_ALEN))
 		allow_uapsd = false;
+
+	if (vif->p2p &&
+	    !(mvm->fw->ucode_capa.flags & IWL_UCODE_TLV_FLAGS_P2P_PS_UAPSD))
+		allow_uapsd = false;
 	/*
 	 * Avoid using uAPSD if P2P client is associated to GO that uses
 	 * opportunistic power save. This is due to current FW limitation.
-- 
1.7.9.5

