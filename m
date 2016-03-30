Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga14.intel.com ([192.55.52.115]:24696 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754114AbcC3OFy (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 30 Mar 2016 10:05:54 -0400
From: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
To: linux-wireless@vger.kernel.org
Cc: Sara Sharon <sara.sharon@intel.com>,
	Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Subject: [PATCH 14/43] iwlwifi: mvm: add support for new TX CMD API
Date: Wed, 30 Mar 2016 17:04:46 +0300
Message-Id: <1459346715-7954-14-git-send-email-emmanuel.grumbach@intel.com> (sfid-20160330_160610_246318_B7C1E735)
In-Reply-To: <1459346667.4731.9.camel@intel.com>
References: <1459346667.4731.9.camel@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Sara Sharon <sara.sharon@intel.com>

TX CMD API has changed to support offload assist.
Currently we do not enable checksum yet, but must set the
padding indication, to avoid FW errors.
Set other amsdu flag as well.
The rest of the flags will be configured only if HW csum
is enabled and will be set in future patches.
This change is backward compatible.

Signed-off-by: Sara Sharon <sara.sharon@intel.com>
Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
---
 drivers/net/wireless/intel/iwlwifi/mvm/fw-api-tx.h | 35 ++++++++++++++++++++--
 drivers/net/wireless/intel/iwlwifi/mvm/tx.c        |  9 +++++-
 2 files changed, 41 insertions(+), 3 deletions(-)

diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/fw-api-tx.h b/drivers/net/wireless/intel/iwlwifi/mvm/fw-api-tx.h
index ba3f0bb..dadcccd 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/fw-api-tx.h
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/fw-api-tx.h
@@ -6,6 +6,7 @@
  * GPL LICENSE SUMMARY
  *
  * Copyright(c) 2012 - 2014 Intel Corporation. All rights reserved.
+ * Copyright(c) 2016 Intel Deutschland GmbH
  *
  * This program is free software; you can redistribute it and/or modify
  * it under the terms of version 2 of the GNU General Public License as
@@ -193,11 +194,41 @@ enum iwl_tx_pm_timeouts {
 #define IWL_BAR_DFAULT_RETRY_LIMIT		60
 #define IWL_LOW_RETRY_LIMIT			7
 
+/**
+ * enum iwl_tx_offload_assist_flags_pos -  set %iwl_tx_cmd offload_assist values
+ * @TX_CMD_OFFLD_IP_HDR_OFFSET: offset to start of IP header (in words)
+ *	from mac header end. For normal case it is 4 words for SNAP.
+ *	note: tx_cmd, mac header and pad are not counted in the offset.
+ *	This is used to help the offload in case there is tunneling such as
+ *	IPv6 in IPv4, in such case the ip header offset should point to the
+ *	inner ip header and IPv4 checksum of the external header should be
+ *	calculated by driver.
+ * @TX_CMD_OFFLD_L4_EN: enable TCP/UDP checksum
+ * @TX_CMD_OFFLD_L3_EN: enable IP header checksum
+ * @TX_CMD_OFFLD_MH_SIZE: size of the mac header in words. Includes the IV
+ *	field. Doesn't include the pad.
+ * @TX_CMD_OFFLD_PAD: mark 2-byte pad was inserted after the mac header for
+ *	alignment
+ * @TX_CMD_OFFLD_AMSDU: mark TX command is A-MSDU
+ */
+enum iwl_tx_offload_assist_flags_pos {
+	TX_CMD_OFFLD_IP_HDR =		0,
+	TX_CMD_OFFLD_L4_EN =		6,
+	TX_CMD_OFFLD_L3_EN =		7,
+	TX_CMD_OFFLD_MH_SIZE =		8,
+	TX_CMD_OFFLD_PAD =		13,
+	TX_CMD_OFFLD_AMSDU =		14,
+};
+
+#define IWL_TX_CMD_OFFLD_MH_MASK	0x1f
+#define IWL_TX_CMD_OFFLD_IP_HDR_MASK	0x3f
+
 /* TODO: complete documentation for try_cnt and btkill_cnt */
 /**
  * struct iwl_tx_cmd - TX command struct to FW
  * ( TX_CMD = 0x1c )
  * @len: in bytes of the payload, see below for details
+ * @offload_assist: TX offload configuration
  * @tx_flags: combination of TX_CMD_FLG_*
  * @rate_n_flags: rate for *all* Tx attempts, if TX_CMD_FLG_STA_RATE_MSK is
  *	cleared. Combination of RATE_MCS_*
@@ -231,7 +262,7 @@ enum iwl_tx_pm_timeouts {
  */
 struct iwl_tx_cmd {
 	__le16 len;
-	__le16 next_frame_len;
+	__le16 offload_assist;
 	__le32 tx_flags;
 	struct {
 		u8 try_cnt;
@@ -255,7 +286,7 @@ struct iwl_tx_cmd {
 	__le16 reserved4;
 	u8 payload[0];
 	struct ieee80211_hdr hdr[0];
-} __packed; /* TX_CMD_API_S_VER_3 */
+} __packed; /* TX_CMD_API_S_VER_6 */
 
 /*
  * TX response related data
diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/tx.c b/drivers/net/wireless/intel/iwlwifi/mvm/tx.c
index 75870e6..138d64d 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/tx.c
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/tx.c
@@ -126,6 +126,9 @@ void iwl_mvm_set_tx_cmd(struct iwl_mvm *mvm, struct sk_buff *skb,
 		u8 *qc = ieee80211_get_qos_ctl(hdr);
 		tx_cmd->tid_tspec = qc[0] & 0xf;
 		tx_flags &= ~TX_CMD_FLG_SEQ_CTL;
+		if (*qc & IEEE80211_QOS_CTL_A_MSDU_PRESENT)
+			tx_cmd->offload_assist |=
+				cpu_to_le16(BIT(TX_CMD_OFFLD_AMSDU));
 	} else if (ieee80211_is_back_req(fc)) {
 		struct ieee80211_bar *bar = (void *)skb->data;
 		u16 control = le16_to_cpu(bar->control);
@@ -186,9 +189,13 @@ void iwl_mvm_set_tx_cmd(struct iwl_mvm *mvm, struct sk_buff *skb,
 	/* Total # bytes to be transmitted */
 	tx_cmd->len = cpu_to_le16((u16)skb->len +
 		(uintptr_t)info->driver_data[0]);
-	tx_cmd->next_frame_len = 0;
 	tx_cmd->life_time = cpu_to_le32(TX_CMD_LIFE_TIME_INFINITE);
 	tx_cmd->sta_id = sta_id;
+
+	/* padding is inserted later in transport */
+	if (ieee80211_hdrlen(fc) % 4 &&
+	    !(tx_cmd->offload_assist & cpu_to_le16(BIT(TX_CMD_OFFLD_AMSDU))))
+		tx_cmd->offload_assist |= cpu_to_le16(BIT(TX_CMD_OFFLD_PAD));
 }
 
 /*
-- 
2.5.0

