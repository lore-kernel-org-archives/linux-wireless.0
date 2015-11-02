Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-lb0-f175.google.com ([209.85.217.175]:35546 "EHLO
	mail-lb0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753143AbbKBOEJ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 2 Nov 2015 09:04:09 -0500
Received: by lbbes7 with SMTP id es7so88523818lbb.2
        for <linux-wireless@vger.kernel.org>; Mon, 02 Nov 2015 06:04:08 -0800 (PST)
From: Michal Kazior <michal.kazior@tieto.com>
To: ath10k@lists.infradead.org
Cc: linux-wireless@vger.kernel.org,
	Michal Kazior <michal.kazior@tieto.com>
Subject: [PATCH 6/8] ath10k: pack up flags in skb_cb
Date: Mon,  2 Nov 2015 15:03:06 +0100
Message-Id: <1446472988-2603-7-git-send-email-michal.kazior@tieto.com> (sfid-20151102_150421_162835_BB16661E)
In-Reply-To: <1446472988-2603-1-git-send-email-michal.kazior@tieto.com>
References: <1446472988-2603-1-git-send-email-michal.kazior@tieto.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

It was wasteful to have all the flags as separate
bools.

Signed-off-by: Michal Kazior <michal.kazior@tieto.com>
---
 drivers/net/wireless/ath/ath10k/core.h   | 13 +++++++------
 drivers/net/wireless/ath/ath10k/htt_tx.c |  4 ++--
 drivers/net/wireless/ath/ath10k/mac.c    | 10 +++++++---
 drivers/net/wireless/ath/ath10k/wmi.c    | 12 ++++++++----
 4 files changed, 24 insertions(+), 15 deletions(-)

diff --git a/drivers/net/wireless/ath/ath10k/core.h b/drivers/net/wireless/ath/ath10k/core.h
index 64a248f780b9..59ec9a8098d0 100644
--- a/drivers/net/wireless/ath/ath10k/core.h
+++ b/drivers/net/wireless/ath/ath10k/core.h
@@ -81,22 +81,23 @@ static inline const char *ath10k_bus_str(enum ath10k_bus bus)
 	return "unknown";
 }
 
+enum ath10k_skb_flags {
+	ATH10K_SKB_F_NO_HWCRYPT = BIT(0),
+	ATH10K_SKB_F_DTIM_ZERO = BIT(1),
+	ATH10K_SKB_F_DELIVER_CAB = BIT(2),
+};
+
 struct ath10k_skb_cb {
 	dma_addr_t paddr;
+	u8 flags;
 	u8 eid;
 	u8 vdev_id;
 
 	struct {
 		u8 tid;
-		bool nohwcrypt;
 		struct ath10k_htt_txbuf *txbuf;
 		u32 txbuf_paddr;
 	} __packed htt;
-
-	struct {
-		bool dtim_zero;
-		bool deliver_cab;
-	} bcn;
 } __packed;
 
 struct ath10k_skb_rxcb {
diff --git a/drivers/net/wireless/ath/ath10k/htt_tx.c b/drivers/net/wireless/ath/ath10k/htt_tx.c
index 05ce99ad6ca2..a572576bf6c4 100644
--- a/drivers/net/wireless/ath/ath10k/htt_tx.c
+++ b/drivers/net/wireless/ath/ath10k/htt_tx.c
@@ -579,7 +579,7 @@ int ath10k_htt_tx(struct ath10k_htt *htt, enum ath10k_hw_txrx_mode txmode,
 	     ieee80211_is_disassoc(hdr->frame_control)) &&
 	     ieee80211_has_protected(hdr->frame_control)) {
 		skb_put(msdu, IEEE80211_CCMP_MIC_LEN);
-	} else if (!skb_cb->htt.nohwcrypt &&
+	} else if (!(skb_cb->flags & ATH10K_SKB_F_NO_HWCRYPT) &&
 		   txmode == ATH10K_HW_TXRX_RAW &&
 		   ieee80211_has_protected(hdr->frame_control)) {
 		skb_put(msdu, IEEE80211_CCMP_MIC_LEN);
@@ -659,7 +659,7 @@ int ath10k_htt_tx(struct ath10k_htt *htt, enum ath10k_hw_txrx_mode txmode,
 			prefetch_len);
 	skb_cb->htt.txbuf->htc_hdr.flags = 0;
 
-	if (skb_cb->htt.nohwcrypt)
+	if (skb_cb->flags & ATH10K_SKB_F_NO_HWCRYPT)
 		flags0 |= HTT_DATA_TX_DESC_FLAGS0_NO_ENCRYPT;
 
 	flags1 |= SM((u16)vdev_id, HTT_DATA_TX_DESC_FLAGS1_VDEV_ID);
diff --git a/drivers/net/wireless/ath/ath10k/mac.c b/drivers/net/wireless/ath/ath10k/mac.c
index ddf2ad2f3955..105a2e61c2ae 100644
--- a/drivers/net/wireless/ath/ath10k/mac.c
+++ b/drivers/net/wireless/ath/ath10k/mac.c
@@ -3661,6 +3661,7 @@ static void ath10k_tx(struct ieee80211_hw *hw,
 		      struct sk_buff *skb)
 {
 	struct ath10k *ar = hw->priv;
+	struct ath10k_skb_cb *skb_cb = ATH10K_SKB_CB(skb);
 	struct ieee80211_tx_info *info = IEEE80211_SKB_CB(skb);
 	struct ieee80211_vif *vif = info->control.vif;
 	struct ieee80211_sta *sta = control->sta;
@@ -3673,9 +3674,12 @@ static void ath10k_tx(struct ieee80211_hw *hw,
 
 	txmode = ath10k_mac_tx_h_get_txmode(ar, vif, sta, skb);
 
-	ATH10K_SKB_CB(skb)->htt.tid = ath10k_tx_h_get_tid(hdr);
-	ATH10K_SKB_CB(skb)->htt.nohwcrypt = !ath10k_tx_h_use_hwcrypto(vif, skb);
-	ATH10K_SKB_CB(skb)->vdev_id = ath10k_tx_h_get_vdev_id(ar, vif);
+	skb_cb->flags = 0;
+	if (!ath10k_tx_h_use_hwcrypto(vif, skb))
+		skb_cb->flags |= ATH10K_SKB_F_NO_HWCRYPT;
+
+	skb_cb->htt.tid = ath10k_tx_h_get_tid(hdr);
+	skb_cb->vdev_id = ath10k_tx_h_get_vdev_id(ar, vif);
 
 	switch (txmode) {
 	case ATH10K_HW_TXRX_MGMT:
diff --git a/drivers/net/wireless/ath/ath10k/wmi.c b/drivers/net/wireless/ath/ath10k/wmi.c
index 7569db0f69b5..022d42d29486 100644
--- a/drivers/net/wireless/ath/ath10k/wmi.c
+++ b/drivers/net/wireless/ath/ath10k/wmi.c
@@ -1660,6 +1660,8 @@ static void ath10k_wmi_tx_beacon_nowait(struct ath10k_vif *arvif)
 	struct ath10k *ar = arvif->ar;
 	struct ath10k_skb_cb *cb;
 	struct sk_buff *bcn;
+	bool dtim_zero;
+	bool deliver_cab;
 	int ret;
 
 	spin_lock_bh(&ar->data_lock);
@@ -1679,12 +1681,14 @@ static void ath10k_wmi_tx_beacon_nowait(struct ath10k_vif *arvif)
 		arvif->beacon_state = ATH10K_BEACON_SENDING;
 		spin_unlock_bh(&ar->data_lock);
 
+		dtim_zero = !!(cb->flags & ATH10K_SKB_F_DTIM_ZERO);
+		deliver_cab = !!(cb->flags & ATH10K_SKB_F_DELIVER_CAB);
 		ret = ath10k_wmi_beacon_send_ref_nowait(arvif->ar,
 							arvif->vdev_id,
 							bcn->data, bcn->len,
 							cb->paddr,
-							cb->bcn.dtim_zero,
-							cb->bcn.deliver_cab);
+							dtim_zero,
+							deliver_cab);
 
 		spin_lock_bh(&ar->data_lock);
 
@@ -3115,10 +3119,10 @@ static void ath10k_wmi_update_tim(struct ath10k *ar,
 	memcpy(tim->virtual_map, arvif->u.ap.tim_bitmap, pvm_len);
 
 	if (tim->dtim_count == 0) {
-		ATH10K_SKB_CB(bcn)->bcn.dtim_zero = true;
+		ATH10K_SKB_CB(bcn)->flags |= ATH10K_SKB_F_DTIM_ZERO;
 
 		if (__le32_to_cpu(tim_info->tim_mcast) == 1)
-			ATH10K_SKB_CB(bcn)->bcn.deliver_cab = true;
+			ATH10K_SKB_CB(bcn)->flags |= ATH10K_SKB_F_DELIVER_CAB;
 	}
 
 	ath10k_dbg(ar, ATH10K_DBG_MGMT, "dtim %d/%d mcast %d pvmlen %d\n",
-- 
2.1.4

