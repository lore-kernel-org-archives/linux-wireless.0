Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine02.qualcomm.com ([199.106.114.251]:10114 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756403AbbKEGFc (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 5 Nov 2015 01:05:32 -0500
From: Vasanthakumar Thiagarajan <vthiagar@qti.qualcomm.com>
To: <ath10k@lists.infradead.org>
CC: <linux-wireless@vger.kernel.org>,
	Vasanthakumar Thiagarajan <vthiagar@qti.qualcomm.com>
Subject: [PATCH V3 3/3] ath10k: Fix peerid configuration in htt tx desc for htt version < 3.4
Date: Thu, 5 Nov 2015 11:34:00 +0530
Message-ID: <1446703440-13880-4-git-send-email-vthiagar@qti.qualcomm.com> (sfid-20151105_070535_400586_AB5C7A44)
In-Reply-To: <1446703440-13880-1-git-send-email-vthiagar@qti.qualcomm.com>
References: <1446703440-13880-1-git-send-email-vthiagar@qti.qualcomm.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Of a word in struct htt_data_tx_desc htt version >= 3.4 firmware uses
LSB 16-bit for frequency configuration which is used for offchannel tx
and MSB 16-bit is for peerid. But other firmwares using version 2.X
(10.1, 10.2.2, 10.2.4 and 10.4) are using 32-bit for peerid in htt tx
desc. So far no issue is found with the existing code setting peerid and
freq for HTT version 2.X, this could be mainly because of 0 as frequecy
(home channel) is being always passed with those firmwares. There may be
issues when non-zero freq is passed with firmware using < 3.4 htt version.
To be safe use target_version_major and target_version_minor along with
htt-op-version before configuring peer id and freq in htt tx desc. This
patch extends ath10k_mac_tx_frm_has_freq() to check for htt_op_version_tlv
and uses the helper while setting peerid in htt_tx_desc.

Fixes: 8d6d36243610 ("ath10k: fix offchan reliability")
Signed-off-by: Vasanthakumar Thiagarajan <vthiagar@qti.qualcomm.com>
---
 drivers/net/wireless/ath/ath10k/htt.h    |  9 +++++++--
 drivers/net/wireless/ath/ath10k/htt_tx.c | 11 +++++++++--
 drivers/net/wireless/ath/ath10k/mac.c    |  5 +++--
 drivers/net/wireless/ath/ath10k/mac.h    |  1 +
 4 files changed, 20 insertions(+), 6 deletions(-)

diff --git a/drivers/net/wireless/ath/ath10k/htt.h b/drivers/net/wireless/ath/ath10k/htt.h
index 74ccfb29..2b87ed6 100644
--- a/drivers/net/wireless/ath/ath10k/htt.h
+++ b/drivers/net/wireless/ath/ath10k/htt.h
@@ -166,8 +166,13 @@ struct htt_data_tx_desc {
 	__le16 len;
 	__le16 id;
 	__le32 frags_paddr;
-	__le16 peerid;
-	__le16 freq;
+	union {
+		__le32 peerid;
+		struct {
+			__le16 peerid;
+			__le16 freq;
+		} __packed offchan_tx;
+	} __packed;
 	u8 prefetch[0]; /* start of frame, for FW classification engine */
 } __packed;
 
diff --git a/drivers/net/wireless/ath/ath10k/htt_tx.c b/drivers/net/wireless/ath/ath10k/htt_tx.c
index bd8f264..8f76b9d 100644
--- a/drivers/net/wireless/ath/ath10k/htt_tx.c
+++ b/drivers/net/wireless/ath/ath10k/htt_tx.c
@@ -688,8 +688,15 @@ int ath10k_htt_tx(struct ath10k_htt *htt, struct sk_buff *msdu)
 	skb_cb->htt.txbuf->cmd_tx.len = __cpu_to_le16(msdu->len);
 	skb_cb->htt.txbuf->cmd_tx.id = __cpu_to_le16(msdu_id);
 	skb_cb->htt.txbuf->cmd_tx.frags_paddr = __cpu_to_le32(frags_paddr);
-	skb_cb->htt.txbuf->cmd_tx.peerid = __cpu_to_le16(HTT_INVALID_PEERID);
-	skb_cb->htt.txbuf->cmd_tx.freq = __cpu_to_le16(skb_cb->htt.freq);
+	if (ath10k_mac_tx_frm_has_freq(ar)) {
+		skb_cb->htt.txbuf->cmd_tx.offchan_tx.peerid =
+				__cpu_to_le16(HTT_INVALID_PEERID);
+		skb_cb->htt.txbuf->cmd_tx.offchan_tx.freq =
+				__cpu_to_le16(skb_cb->htt.freq);
+	} else {
+		skb_cb->htt.txbuf->cmd_tx.peerid =
+				__cpu_to_le32(HTT_INVALID_PEERID);
+	}
 
 	trace_ath10k_htt_tx(ar, msdu_id, msdu->len, vdev_id, tid);
 	ath10k_dbg(ar, ATH10K_DBG_HTT,
diff --git a/drivers/net/wireless/ath/ath10k/mac.c b/drivers/net/wireless/ath/ath10k/mac.c
index 363a99c..76484a9 100644
--- a/drivers/net/wireless/ath/ath10k/mac.c
+++ b/drivers/net/wireless/ath/ath10k/mac.c
@@ -3287,7 +3287,7 @@ static void ath10k_tx_h_add_p2p_noa_ie(struct ath10k *ar,
 	}
 }
 
-static bool ath10k_mac_tx_frm_has_freq(struct ath10k *ar)
+bool ath10k_mac_tx_frm_has_freq(struct ath10k *ar)
 {
 	/* FIXME: Not really sure since when the behaviour changed. At some
 	 * point new firmware stopped requiring creation of peer entries for
@@ -3296,7 +3296,8 @@ static bool ath10k_mac_tx_frm_has_freq(struct ath10k *ar)
 	 * because that's when the `freq` was introduced to TX_FRM HTT command.
 	 */
 	return (ar->htt.target_version_major >= 3 &&
-		ar->htt.target_version_minor >= 4);
+		ar->htt.target_version_minor >= 4 &&
+		ar->htt.op_version == ATH10K_FW_HTT_OP_VERSION_TLV);
 }
 
 static int ath10k_mac_tx_wmi_mgmt(struct ath10k *ar, struct sk_buff *skb)
diff --git a/drivers/net/wireless/ath/ath10k/mac.h b/drivers/net/wireless/ath/ath10k/mac.h
index e3cefe4..f504804 100644
--- a/drivers/net/wireless/ath/ath10k/mac.h
+++ b/drivers/net/wireless/ath/ath10k/mac.h
@@ -74,6 +74,7 @@ void ath10k_mac_tx_lock(struct ath10k *ar, int reason);
 void ath10k_mac_tx_unlock(struct ath10k *ar, int reason);
 void ath10k_mac_vif_tx_lock(struct ath10k_vif *arvif, int reason);
 void ath10k_mac_vif_tx_unlock(struct ath10k_vif *arvif, int reason);
+bool ath10k_mac_tx_frm_has_freq(struct ath10k *ar);
 
 static inline struct ath10k_vif *ath10k_vif_to_arvif(struct ieee80211_vif *vif)
 {
-- 
1.9.1

