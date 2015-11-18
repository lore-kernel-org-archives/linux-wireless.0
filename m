Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-lb0-f176.google.com ([209.85.217.176]:35458 "EHLO
	mail-lb0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752782AbbKRF7c (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 18 Nov 2015 00:59:32 -0500
Received: by lbbsy6 with SMTP id sy6so18357699lbb.2
        for <linux-wireless@vger.kernel.org>; Tue, 17 Nov 2015 21:59:30 -0800 (PST)
From: Michal Kazior <michal.kazior@tieto.com>
To: ath10k@lists.infradead.org
Cc: linux-wireless@vger.kernel.org,
	Michal Kazior <michal.kazior@tieto.com>
Subject: [PATCH v3 1/9] ath10k: merge is_protected with nohwcrypt
Date: Wed, 18 Nov 2015 06:59:15 +0100
Message-Id: <1447826363-16818-2-git-send-email-michal.kazior@tieto.com> (sfid-20151118_065937_704727_F5CE2E2B)
In-Reply-To: <1447826363-16818-1-git-send-email-michal.kazior@tieto.com>
References: <87mvuj585b.fsf@kamboji.qca.qualcomm.com>
 <1447826363-16818-1-git-send-email-michal.kazior@tieto.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

It was wasteful to have two flags describing
the same thing.

While at it fix code style of
ath10k_tx_h_use_hwcrypto().

Signed-off-by: Michal Kazior <michal.kazior@tieto.com>
---
 drivers/net/wireless/ath/ath10k/core.h   |  1 -
 drivers/net/wireless/ath/ath10k/htt_tx.c |  3 ---
 drivers/net/wireless/ath/ath10k/mac.c    | 14 ++++++++++----
 3 files changed, 10 insertions(+), 8 deletions(-)

diff --git a/drivers/net/wireless/ath/ath10k/core.h b/drivers/net/wireless/ath/ath10k/core.h
index 938431ffed4d..b91f69286a4f 100644
--- a/drivers/net/wireless/ath/ath10k/core.h
+++ b/drivers/net/wireless/ath/ath10k/core.h
@@ -86,7 +86,6 @@ struct ath10k_skb_cb {
 	u8 eid;
 	u8 vdev_id;
 	enum ath10k_hw_txrx_mode txmode;
-	bool is_protected;
 
 	struct {
 		u8 tid;
diff --git a/drivers/net/wireless/ath/ath10k/htt_tx.c b/drivers/net/wireless/ath/ath10k/htt_tx.c
index 8f76b9d96486..b57335d47c78 100644
--- a/drivers/net/wireless/ath/ath10k/htt_tx.c
+++ b/drivers/net/wireless/ath/ath10k/htt_tx.c
@@ -663,9 +663,6 @@ int ath10k_htt_tx(struct ath10k_htt *htt, struct sk_buff *msdu)
 	if (skb_cb->htt.nohwcrypt)
 		flags0 |= HTT_DATA_TX_DESC_FLAGS0_NO_ENCRYPT;
 
-	if (!skb_cb->is_protected)
-		flags0 |= HTT_DATA_TX_DESC_FLAGS0_NO_ENCRYPT;
-
 	flags1 |= SM((u16)vdev_id, HTT_DATA_TX_DESC_FLAGS1_VDEV_ID);
 	flags1 |= SM((u16)tid, HTT_DATA_TX_DESC_FLAGS1_EXT_TID);
 	if (msdu->ip_summed == CHECKSUM_PARTIAL &&
diff --git a/drivers/net/wireless/ath/ath10k/mac.c b/drivers/net/wireless/ath/ath10k/mac.c
index 20e73729c397..ab2e5677f771 100644
--- a/drivers/net/wireless/ath/ath10k/mac.c
+++ b/drivers/net/wireless/ath/ath10k/mac.c
@@ -3200,14 +3200,22 @@ ath10k_tx_h_get_txmode(struct ath10k *ar, struct ieee80211_vif *vif,
 }
 
 static bool ath10k_tx_h_use_hwcrypto(struct ieee80211_vif *vif,
-				     struct sk_buff *skb) {
-	struct ieee80211_tx_info *info = IEEE80211_SKB_CB(skb);
+				     struct sk_buff *skb)
+{
+	const struct ieee80211_tx_info *info = IEEE80211_SKB_CB(skb);
+	const struct ieee80211_hdr *hdr = (void *)skb->data;
 	const u32 mask = IEEE80211_TX_INTFL_DONT_ENCRYPT |
 			 IEEE80211_TX_CTL_INJECTED;
+
+	if (!ieee80211_has_protected(hdr->frame_control))
+		return false;
+
 	if ((info->flags & mask) == mask)
 		return false;
+
 	if (vif)
 		return !ath10k_vif_to_arvif(vif)->nohwcrypt;
+
 	return true;
 }
 
@@ -3646,7 +3654,6 @@ static void ath10k_tx(struct ieee80211_hw *hw,
 	struct ieee80211_vif *vif = info->control.vif;
 	struct ieee80211_sta *sta = control->sta;
 	struct ieee80211_hdr *hdr = (struct ieee80211_hdr *)skb->data;
-	__le16 fc = hdr->frame_control;
 
 	/* We should disable CCK RATE due to P2P */
 	if (info->flags & IEEE80211_TX_CTL_NO_CCK_RATE)
@@ -3658,7 +3665,6 @@ static void ath10k_tx(struct ieee80211_hw *hw,
 	ATH10K_SKB_CB(skb)->htt.nohwcrypt = !ath10k_tx_h_use_hwcrypto(vif, skb);
 	ATH10K_SKB_CB(skb)->vdev_id = ath10k_tx_h_get_vdev_id(ar, vif);
 	ATH10K_SKB_CB(skb)->txmode = ath10k_tx_h_get_txmode(ar, vif, sta, skb);
-	ATH10K_SKB_CB(skb)->is_protected = ieee80211_has_protected(fc);
 
 	switch (ATH10K_SKB_CB(skb)->txmode) {
 	case ATH10K_HW_TXRX_MGMT:
-- 
2.1.4

