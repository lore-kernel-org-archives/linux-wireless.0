Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga03.intel.com ([134.134.136.65]:53947 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751998AbbLUUwZ (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 21 Dec 2015 15:52:25 -0500
From: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
To: linux-wireless@vger.kernel.org
Cc: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Subject: [PATCH 33/45] iwlwifi: mvm: small update in the firmware API
Date: Mon, 21 Dec 2015 22:50:34 +0200
Message-Id: <1450731046-2796-33-git-send-email-emmanuel.grumbach@intel.com> (sfid-20151221_220101_495443_2FB4473F)
In-Reply-To: <0BA3FCBA62E2DC44AF3030971E174FB32E949792@hasmsx107.ger.corp.intel.com>
References: <0BA3FCBA62E2DC44AF3030971E174FB32E949792@hasmsx107.ger.corp.intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Small change in firmware API, no functional change.

Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
---
 drivers/net/wireless/intel/iwlwifi/mvm/fw-api-rx.h | 10 +++++++++-
 1 file changed, 9 insertions(+), 1 deletion(-)

diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/fw-api-rx.h b/drivers/net/wireless/intel/iwlwifi/mvm/fw-api-rx.h
index af7f9dd..75c79e1 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/fw-api-rx.h
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/fw-api-rx.h
@@ -79,6 +79,11 @@
 #define IWL_RX_INFO_ENERGY_ANT_B_POS 8
 #define IWL_RX_INFO_ENERGY_ANT_C_POS 16
 
+enum iwl_mac_context_info {
+	MAC_CONTEXT_INFO_NONE,
+	MAC_CONTEXT_INFO_GSCAN,
+};
+
 /**
  * struct iwl_rx_phy_info - phy info
  * (REPLY_RX_PHY_CMD = 0xc0)
@@ -97,6 +102,8 @@
  * @frame_time: frame's time on the air, based on byte count and frame rate
  *	calculation
  * @mac_active_msk: what MACs were active when the frame was received
+ * @mac_context_info: additional info on the context in which the frame was
+ *	received as defined in &enum iwl_mac_context_info
  *
  * Before each Rx, the device sends this data. It contains PHY information
  * about the reception of the packet.
@@ -114,7 +121,8 @@ struct iwl_rx_phy_info {
 	__le32 non_cfg_phy[IWL_RX_INFO_PHY_CNT];
 	__le32 rate_n_flags;
 	__le32 byte_count;
-	__le16 mac_active_msk;
+	u8 mac_active_msk;
+	u8 mac_context_info;
 	__le16 frame_time;
 } __packed;
 
-- 
2.5.0

