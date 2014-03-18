Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ee0-f43.google.com ([74.125.83.43]:49298 "EHLO
	mail-ee0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756126AbaCROqL (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 18 Mar 2014 10:46:11 -0400
Received: by mail-ee0-f43.google.com with SMTP id e53so5449251eek.2
        for <linux-wireless@vger.kernel.org>; Tue, 18 Mar 2014 07:46:09 -0700 (PDT)
From: Emmanuel Grumbach <egrumbach@gmail.com>
To: linux-wireless@vger.kernel.org
Cc: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Subject: [PATCH 15/35] iwlwifi: mvm: BT Coex - classify packet priority in BT code
Date: Tue, 18 Mar 2014 16:45:19 +0200
Message-Id: <1395153939-23897-15-git-send-email-egrumbach@gmail.com> (sfid-20140318_155650_231927_20E8E9A2)
In-Reply-To: <53285AF8.7050305@gmail.com>
References: <53285AF8.7050305@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Emmanuel Grumbach <emmanuel.grumbach@intel.com>

This code is really related to BT Coex - move it to the coex
file.
Also - prepare for a FW API change that will happen soon:
Bits 11 and 12 will be allocated for BT priority. Today, we
only have bit 12.

Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
---
 drivers/net/wireless/iwlwifi/mvm/coex.c      | 17 +++++++++++++++++
 drivers/net/wireless/iwlwifi/mvm/fw-api-tx.h |  3 +++
 drivers/net/wireless/iwlwifi/mvm/mvm.h       |  2 ++
 drivers/net/wireless/iwlwifi/mvm/tx.c        |  8 ++------
 4 files changed, 24 insertions(+), 6 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/mvm/coex.c b/drivers/net/wireless/iwlwifi/mvm/coex.c
index 0b2e351..43027c3 100644
--- a/drivers/net/wireless/iwlwifi/mvm/coex.c
+++ b/drivers/net/wireless/iwlwifi/mvm/coex.c
@@ -61,6 +61,8 @@
  *
  *****************************************************************************/
 
+#include <linux/ieee80211.h>
+#include <linux/etherdevice.h>
 #include <net/mac80211.h>
 
 #include "fw-api-coex.h"
@@ -1205,6 +1207,21 @@ bool iwl_mvm_bt_coex_is_mimo_allowed(struct iwl_mvm *mvm,
 	return iwl_get_coex_type(mvm, mvmsta->vif) == BT_COEX_TIGHT_LUT;
 }
 
+u8 iwl_mvm_bt_coex_tx_prio(struct iwl_mvm *mvm, struct ieee80211_hdr *hdr,
+			   struct ieee80211_tx_info *info)
+{
+	__le16 fc = hdr->frame_control;
+
+	/* High prio packet (wrt. BT coex) if it is EAPOL, MCAST or MGMT */
+	if (info->band == IEEE80211_BAND_2GHZ &&
+	    (info->control.flags & IEEE80211_TX_CTRL_PORT_CTRL_PROTO ||
+	     is_multicast_ether_addr(hdr->addr1) ||
+	     ieee80211_is_back_req(fc) || ieee80211_is_mgmt(fc)))
+		return 2;
+
+	return 0;
+}
+
 void iwl_mvm_bt_coex_vif_change(struct iwl_mvm *mvm)
 {
 	if (!(mvm->fw->ucode_capa.flags & IWL_UCODE_TLV_FLAGS_NEWBT_COEX))
diff --git a/drivers/net/wireless/iwlwifi/mvm/fw-api-tx.h b/drivers/net/wireless/iwlwifi/mvm/fw-api-tx.h
index b674c2a..8e122f3 100644
--- a/drivers/net/wireless/iwlwifi/mvm/fw-api-tx.h
+++ b/drivers/net/wireless/iwlwifi/mvm/fw-api-tx.h
@@ -76,6 +76,8 @@
  * @TX_CMD_FLG_VHT_NDPA: mark frame is NDPA for VHT beamformer sequence
  * @TX_CMD_FLG_HT_NDPA: mark frame is NDPA for HT beamformer sequence
  * @TX_CMD_FLG_CSI_FDBK2HOST: mark to send feedback to host (only if good CRC)
+ * @TX_CMD_FLG_BT_PRIO_POS: the position of the BT priority (bit 11 is ignored
+ *	on old firmwares).
  * @TX_CMD_FLG_BT_DIS: disable BT priority for this frame
  * @TX_CMD_FLG_SEQ_CTL: set if FW should override the sequence control.
  *	Should be set for mgmt, non-QOS data, mcast, bcast and in scan command
@@ -107,6 +109,7 @@ enum iwl_tx_flags {
 	TX_CMD_FLG_VHT_NDPA		= BIT(8),
 	TX_CMD_FLG_HT_NDPA		= BIT(9),
 	TX_CMD_FLG_CSI_FDBK2HOST	= BIT(10),
+	TX_CMD_FLG_BT_PRIO_POS		= 11,
 	TX_CMD_FLG_BT_DIS		= BIT(12),
 	TX_CMD_FLG_SEQ_CTL		= BIT(13),
 	TX_CMD_FLG_MORE_FRAG		= BIT(14),
diff --git a/drivers/net/wireless/iwlwifi/mvm/mvm.h b/drivers/net/wireless/iwlwifi/mvm/mvm.h
index 4c38654..221a482 100644
--- a/drivers/net/wireless/iwlwifi/mvm/mvm.h
+++ b/drivers/net/wireless/iwlwifi/mvm/mvm.h
@@ -912,6 +912,8 @@ u16 iwl_mvm_coex_agg_time_limit(struct iwl_mvm *mvm,
 				struct ieee80211_sta *sta);
 bool iwl_mvm_bt_coex_is_mimo_allowed(struct iwl_mvm *mvm,
 				     struct ieee80211_sta *sta);
+u8 iwl_mvm_bt_coex_tx_prio(struct iwl_mvm *mvm, struct ieee80211_hdr *hdr,
+			   struct ieee80211_tx_info *info);
 int iwl_mvm_bt_coex_reduced_txp(struct iwl_mvm *mvm, u8 sta_id, bool enable);
 
 enum iwl_bt_kill_msk {
diff --git a/drivers/net/wireless/iwlwifi/mvm/tx.c b/drivers/net/wireless/iwlwifi/mvm/tx.c
index 6cdbf7b..dd813d4 100644
--- a/drivers/net/wireless/iwlwifi/mvm/tx.c
+++ b/drivers/net/wireless/iwlwifi/mvm/tx.c
@@ -90,12 +90,8 @@ static void iwl_mvm_set_tx_cmd(struct iwl_mvm *mvm, struct sk_buff *skb,
 	else if (ieee80211_is_back_req(fc))
 		tx_flags |= TX_CMD_FLG_ACK | TX_CMD_FLG_BAR;
 
-	/* High prio packet (wrt. BT coex) if it is EAPOL, MCAST or MGMT */
-	if (info->band == IEEE80211_BAND_2GHZ &&
-	    (info->control.flags & IEEE80211_TX_CTRL_PORT_CTRL_PROTO ||
-	     is_multicast_ether_addr(hdr->addr1) ||
-	     ieee80211_is_back_req(fc) || ieee80211_is_mgmt(fc)))
-		tx_flags |= TX_CMD_FLG_BT_DIS;
+	tx_flags |= iwl_mvm_bt_coex_tx_prio(mvm, hdr, info) <<
+			TX_CMD_FLG_BT_PRIO_POS;
 
 	if (ieee80211_has_morefrags(fc))
 		tx_flags |= TX_CMD_FLG_MORE_FRAG;
-- 
1.8.3.2

