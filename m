Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga14.intel.com ([192.55.52.115]:24696 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753032AbcC3OFx (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 30 Mar 2016 10:05:53 -0400
From: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
To: linux-wireless@vger.kernel.org
Cc: Sara Sharon <sara.sharon@intel.com>,
	Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Subject: [PATCH 13/43] iwlwifi: pcie: do not pad QoS AMSDU
Date: Wed, 30 Mar 2016 17:04:45 +0300
Message-Id: <1459346715-7954-13-git-send-email-emmanuel.grumbach@intel.com> (sfid-20160330_160800_489452_4B7B3AC8)
In-Reply-To: <1459346667.4731.9.camel@intel.com>
References: <1459346667.4731.9.camel@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Sara Sharon <sara.sharon@intel.com>

We insert padding if the MAC header's size is not a multiple of 4
to ensure that the SNAP header is DWORD aligned. When we do so, we
let the firmware know by setting a bit in Tx command
(TX_CMD_FLG_MH_PAD) which will instruct the firmware to drop those
2 bytes before sending the frame.
However, this is not needed for AMSDU as the sub frame header (14B)
complements the MAC header (26B) so that the SNAP header is DWORD
aligned without adding any pad.

Until 9000, the firmware didn't check the TX_CMD_FLG_MH_PAD bit
but rather checked the length of the MAC header itself and
assumed the entity that enqueued the frame (driver or internal
firmware code) added the pad.
Since the driver inserted the pad even for AMSDU this logic applied.
Note that the padding is a DMA optimization but it's not strictly
needed, so we could pad even if it was not needed.

However, the CSUM hardware introduced for the 9000 devices requires
to not pad AMSDU as it is not needed, and will fail if such a pad
exists.
Due to older FW not checking the padding bit but checking the mac
header size itself - we cannot do this adjustments for older
generations.
Do not align the size if it is an AMSDU and HW checksum is enabled -
which will only happen on 9000 devices and on.

Signed-off-by: Sara Sharon <sara.sharon@intel.com>
Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
---
 drivers/net/wireless/intel/iwlwifi/pcie/tx.c | 21 ++++++++++++++-------
 1 file changed, 14 insertions(+), 7 deletions(-)

diff --git a/drivers/net/wireless/intel/iwlwifi/pcie/tx.c b/drivers/net/wireless/intel/iwlwifi/pcie/tx.c
index cc6fa00..e1f7a3f 100644
--- a/drivers/net/wireless/intel/iwlwifi/pcie/tx.c
+++ b/drivers/net/wireless/intel/iwlwifi/pcie/tx.c
@@ -2210,6 +2210,7 @@ int iwl_trans_pcie_tx(struct iwl_trans *trans, struct sk_buff *skb,
 	__le16 fc;
 	u8 hdr_len;
 	u16 wifi_seq;
+	bool amsdu;
 
 	txq = &trans_pcie->txq[txq_id];
 	q = &txq->q;
@@ -2301,11 +2302,18 @@ int iwl_trans_pcie_tx(struct iwl_trans *trans, struct sk_buff *skb,
 	 */
 	len = sizeof(struct iwl_tx_cmd) + sizeof(struct iwl_cmd_header) +
 	      hdr_len - IWL_HCMD_SCRATCHBUF_SIZE;
-	tb1_len = ALIGN(len, 4);
-
-	/* Tell NIC about any 2-byte padding after MAC header */
-	if (tb1_len != len)
-		tx_cmd->tx_flags |= TX_CMD_FLG_MH_PAD_MSK;
+	/* do not align A-MSDU to dword as the subframe header aligns it */
+	amsdu = ieee80211_is_data_qos(fc) &&
+		(*ieee80211_get_qos_ctl(hdr) &
+		 IEEE80211_QOS_CTL_A_MSDU_PRESENT);
+	if (trans_pcie->sw_csum_tx || !amsdu) {
+		tb1_len = ALIGN(len, 4);
+		/* Tell NIC about any 2-byte padding after MAC header */
+		if (tb1_len != len)
+			tx_cmd->tx_flags |= TX_CMD_FLG_MH_PAD_MSK;
+	} else {
+		tb1_len = len;
+	}
 
 	/* The first TB points to the scratchbuf data - min_copy bytes */
 	memcpy(&txq->scratchbufs[q->write_ptr], &dev_cmd->hdr,
@@ -2323,8 +2331,7 @@ int iwl_trans_pcie_tx(struct iwl_trans *trans, struct sk_buff *skb,
 		goto out_err;
 	iwl_pcie_txq_build_tfd(trans, txq, tb1_phys, tb1_len, false);
 
-	if (ieee80211_is_data_qos(fc) &&
-	    (*ieee80211_get_qos_ctl(hdr) & IEEE80211_QOS_CTL_A_MSDU_PRESENT)) {
+	if (amsdu) {
 		if (unlikely(iwl_fill_data_tbs_amsdu(trans, skb, txq, hdr_len,
 						     out_meta, dev_cmd,
 						     tb1_len)))
-- 
2.5.0

