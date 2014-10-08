Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s72.web-hosting.com ([198.187.29.22]:51579 "EHLO
	s72.web-hosting.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751280AbaJHDMc (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 7 Oct 2014 23:12:32 -0400
From: Sujith Manoharan <sujith@msujith.org>
To: John Linville <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org, ath9k-devel@qca.qualcomm.com
Subject: [PATCH v3 1/4] ath9k: Fix sequence number assignment
Date: Wed,  8 Oct 2014 08:43:19 +0530
Message-Id: <1412738002-7636-2-git-send-email-sujith@msujith.org> (sfid-20141008_051235_517871_9F08CC52)
In-Reply-To: <1412738002-7636-1-git-send-email-sujith@msujith.org>
References: <1412738002-7636-1-git-send-email-sujith@msujith.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Sujith Manoharan <c_manoha@qca.qualcomm.com>

Currently, ath9k uses a global counter for all
frames that need to be assigned a sequence number.
QoS-data frames are handled properly since they
have a per-tid counter. But, beacons and other
management frames use the same counter even if
multiple interfaces or contexts are present.

Fix this issue by making the counter per-interface
and using it when mac80211 sets IEEE80211_TX_CTL_ASSIGN_SEQ.

Signed-off-by: Sujith Manoharan <c_manoha@qca.qualcomm.com>
---
 drivers/net/wireless/ath/ath9k/ath9k.h  |  4 +++-
 drivers/net/wireless/ath/ath9k/beacon.c | 12 ++----------
 drivers/net/wireless/ath/ath9k/tx99.c   |  8 +++++++-
 drivers/net/wireless/ath/ath9k/xmit.c   | 34 ++++++++++++++++++++++-----------
 4 files changed, 35 insertions(+), 23 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/ath9k.h b/drivers/net/wireless/ath/ath9k/ath9k.h
index bfa0b15..01a7db0 100644
--- a/drivers/net/wireless/ath/ath9k/ath9k.h
+++ b/drivers/net/wireless/ath/ath9k/ath9k.h
@@ -294,7 +294,6 @@ struct ath_tx_control {
  *  (axq_qnum).
  */
 struct ath_tx {
-	u16 seq_no;
 	u32 txqsetup;
 	spinlock_t txbuflock;
 	struct list_head txbuf;
@@ -563,6 +562,7 @@ int ath_tx_init(struct ath_softc *sc, int nbufs);
 int ath_txq_update(struct ath_softc *sc, int qnum,
 		   struct ath9k_tx_queue_info *q);
 void ath_update_max_aggr_framelen(struct ath_softc *sc, int queue, int txop);
+void ath_assign_seq(struct ath_common *common, struct sk_buff *skb);
 int ath_tx_start(struct ieee80211_hw *hw, struct sk_buff *skb,
 		 struct ath_tx_control *txctl);
 void ath_tx_cabq(struct ieee80211_hw *hw, struct ieee80211_vif *vif,
@@ -592,6 +592,8 @@ void ath9k_release_buffered_frames(struct ieee80211_hw *hw,
 struct ath_vif {
 	struct list_head list;
 
+	u16 seq_no;
+
 	/* BSS info */
 	u8 bssid[ETH_ALEN];
 	u16 aid;
diff --git a/drivers/net/wireless/ath/ath9k/beacon.c b/drivers/net/wireless/ath/ath9k/beacon.c
index a6af855..ecb783b 100644
--- a/drivers/net/wireless/ath/ath9k/beacon.c
+++ b/drivers/net/wireless/ath/ath9k/beacon.c
@@ -144,16 +144,8 @@ static struct ath_buf *ath9k_beacon_generate(struct ieee80211_hw *hw,
 	mgmt_hdr->u.beacon.timestamp = avp->tsf_adjust;
 
 	info = IEEE80211_SKB_CB(skb);
-	if (info->flags & IEEE80211_TX_CTL_ASSIGN_SEQ) {
-		/*
-		 * TODO: make sure the seq# gets assigned properly (vs. other
-		 * TX frames)
-		 */
-		struct ieee80211_hdr *hdr = (struct ieee80211_hdr *)skb->data;
-		sc->tx.seq_no += 0x10;
-		hdr->seq_ctrl &= cpu_to_le16(IEEE80211_SCTL_FRAG);
-		hdr->seq_ctrl |= cpu_to_le16(sc->tx.seq_no);
-	}
+
+	ath_assign_seq(common, skb);
 
 	if (vif->p2p)
 		ath9k_beacon_add_noa(sc, avp, skb);
diff --git a/drivers/net/wireless/ath/ath9k/tx99.c b/drivers/net/wireless/ath/ath9k/tx99.c
index 8a69d08..40ab65e 100644
--- a/drivers/net/wireless/ath/ath9k/tx99.c
+++ b/drivers/net/wireless/ath/ath9k/tx99.c
@@ -54,6 +54,12 @@ static struct sk_buff *ath9k_build_tx99_skb(struct ath_softc *sc)
 	struct ieee80211_hdr *hdr;
 	struct ieee80211_tx_info *tx_info;
 	struct sk_buff *skb;
+	struct ath_vif *avp;
+
+	if (!sc->tx99_vif)
+		return NULL;
+
+	avp = (struct ath_vif *)sc->tx99_vif->drv_priv;
 
 	skb = alloc_skb(len, GFP_KERNEL);
 	if (!skb)
@@ -71,7 +77,7 @@ static struct sk_buff *ath9k_build_tx99_skb(struct ath_softc *sc)
 	memcpy(hdr->addr2, hw->wiphy->perm_addr, ETH_ALEN);
 	memcpy(hdr->addr3, hw->wiphy->perm_addr, ETH_ALEN);
 
-	hdr->seq_ctrl |= cpu_to_le16(sc->tx.seq_no);
+	hdr->seq_ctrl |= cpu_to_le16(avp->seq_no);
 
 	tx_info = IEEE80211_SKB_CB(skb);
 	memset(tx_info, 0, sizeof(*tx_info));
diff --git a/drivers/net/wireless/ath/ath9k/xmit.c b/drivers/net/wireless/ath/ath9k/xmit.c
index 151ae49..493a183 100644
--- a/drivers/net/wireless/ath/ath9k/xmit.c
+++ b/drivers/net/wireless/ath/ath9k/xmit.c
@@ -2139,6 +2139,28 @@ static struct ath_buf *ath_tx_setup_buffer(struct ath_softc *sc,
 	return bf;
 }
 
+void ath_assign_seq(struct ath_common *common, struct sk_buff *skb)
+{
+	struct ieee80211_hdr *hdr = (struct ieee80211_hdr *) skb->data;
+	struct ieee80211_tx_info *info = IEEE80211_SKB_CB(skb);
+	struct ieee80211_vif *vif = info->control.vif;
+	struct ath_vif *avp;
+
+	if (!(info->flags & IEEE80211_TX_CTL_ASSIGN_SEQ))
+		return;
+
+	if (!vif)
+		return;
+
+	avp = (struct ath_vif *)vif->drv_priv;
+
+	if (info->flags & IEEE80211_TX_CTL_FIRST_FRAGMENT)
+		avp->seq_no += 0x10;
+
+	hdr->seq_ctrl &= cpu_to_le16(IEEE80211_SCTL_FRAG);
+	hdr->seq_ctrl |= cpu_to_le16(avp->seq_no);
+}
+
 static int ath_tx_prepare(struct ieee80211_hw *hw, struct sk_buff *skb,
 			  struct ath_tx_control *txctl)
 {
@@ -2162,17 +2184,7 @@ static int ath_tx_prepare(struct ieee80211_hw *hw, struct sk_buff *skb,
 	if (info->control.hw_key)
 		frmlen += info->control.hw_key->icv_len;
 
-	/*
-	 * As a temporary workaround, assign seq# here; this will likely need
-	 * to be cleaned up to work better with Beacon transmission and virtual
-	 * BSSes.
-	 */
-	if (info->flags & IEEE80211_TX_CTL_ASSIGN_SEQ) {
-		if (info->flags & IEEE80211_TX_CTL_FIRST_FRAGMENT)
-			sc->tx.seq_no += 0x10;
-		hdr->seq_ctrl &= cpu_to_le16(IEEE80211_SCTL_FRAG);
-		hdr->seq_ctrl |= cpu_to_le16(sc->tx.seq_no);
-	}
+	ath_assign_seq(ath9k_hw_common(sc->sc_ah), skb);
 
 	if ((vif && vif->type != NL80211_IFTYPE_AP &&
 	            vif->type != NL80211_IFTYPE_AP_VLAN) ||
-- 
2.1.2

