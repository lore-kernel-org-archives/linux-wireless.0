Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from ebb06.tieto.com ([131.207.168.38]:44235 "EHLO ebb06.tieto.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1030506Ab3HIINr (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 9 Aug 2013 04:13:47 -0400
From: Michal Kazior <michal.kazior@tieto.com>
To: <ath10k@lists.infradead.org>
CC: <linux-wireless@vger.kernel.org>,
	Michal Kazior <michal.kazior@tieto.com>
Subject: [PATCH 3/3] ath10k: add support for HTT 3.0
Date: Fri, 9 Aug 2013 10:13:34 +0200
Message-ID: <1376036014-29707-4-git-send-email-michal.kazior@tieto.com> (sfid-20130809_101354_921193_5F460A74)
In-Reply-To: <1376036014-29707-1-git-send-email-michal.kazior@tieto.com>
References: <1375949298-7159-1-git-send-email-michal.kazior@tieto.com>
 <1376036014-29707-1-git-send-email-michal.kazior@tieto.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

New firmware comes with new HTT protocol version.
In 3.0 the separate mgmt tx command has been
removed. All traffic is to be pushed through data
tx (tx_frm) command with a twist - FW seems to not
be able (yet?) to access tx fragment table so for
manamgement frames frame pointer is passed
directly.

Signed-off-by: Michal Kazior <michal.kazior@tieto.com>
---
patch:
 * use ath10k_info for htt version prompt (Kalle)
 * more verbose error message on htt failure (Kalle)
 * conditions tweaked and broken on 80 column (Kalle)
 * use brackets {}

 drivers/net/wireless/ath/ath10k/htt.c    |   19 +++-----
 drivers/net/wireless/ath/ath10k/htt.h    |    6 +--
 drivers/net/wireless/ath/ath10k/htt_tx.c |   74 +++++++++++++++++++++---------
 drivers/net/wireless/ath/ath10k/hw.h     |    3 ++
 drivers/net/wireless/ath/ath10k/mac.c    |   13 +++++-
 5 files changed, 76 insertions(+), 39 deletions(-)

diff --git a/drivers/net/wireless/ath/ath10k/htt.c b/drivers/net/wireless/ath/ath10k/htt.c
index 39342c5..5f7eeeb 100644
--- a/drivers/net/wireless/ath/ath10k/htt.c
+++ b/drivers/net/wireless/ath/ath10k/htt.c
@@ -104,21 +104,16 @@ err_htc_attach:
 
 static int ath10k_htt_verify_version(struct ath10k_htt *htt)
 {
-	ath10k_dbg(ATH10K_DBG_HTT,
-		   "htt target version %d.%d; host version %d.%d\n",
-		    htt->target_version_major,
-		    htt->target_version_minor,
-		    HTT_CURRENT_VERSION_MAJOR,
-		    HTT_CURRENT_VERSION_MINOR);
-
-	if (htt->target_version_major != HTT_CURRENT_VERSION_MAJOR) {
-		ath10k_err("htt major versions are incompatible!\n");
+	ath10k_info("htt target version %d.%d\n",
+		    htt->target_version_major, htt->target_version_minor);
+
+	if (htt->target_version_major != 2 &&
+	    htt->target_version_major != 3) {
+		ath10k_err("unsupported htt major version %d. supported versions are 2 and 3\n",
+			   htt->target_version_major);
 		return -ENOTSUPP;
 	}
 
-	if (htt->target_version_minor != HTT_CURRENT_VERSION_MINOR)
-		ath10k_warn("htt minor version differ but still compatible\n");
-
 	return 0;
 }
 
diff --git a/drivers/net/wireless/ath/ath10k/htt.h b/drivers/net/wireless/ath/ath10k/htt.h
index de45d02..2488623 100644
--- a/drivers/net/wireless/ath/ath10k/htt.h
+++ b/drivers/net/wireless/ath/ath10k/htt.h
@@ -23,9 +23,6 @@
 #include "htc.h"
 #include "rx_desc.h"
 
-#define HTT_CURRENT_VERSION_MAJOR	2
-#define HTT_CURRENT_VERSION_MINOR	1
-
 enum htt_dbg_stats_type {
 	HTT_DBG_STATS_WAL_PDEV_TXRX = 1 << 0,
 	HTT_DBG_STATS_RX_REORDER    = 1 << 1,
@@ -45,6 +42,9 @@ enum htt_h2t_msg_type { /* host-to-target */
 	HTT_H2T_MSG_TYPE_SYNC               = 4,
 	HTT_H2T_MSG_TYPE_AGGR_CFG           = 5,
 	HTT_H2T_MSG_TYPE_FRAG_DESC_BANK_CFG = 6,
+
+	/* This command is used for sending management frames in HTT < 3.0.
+	 * HTT >= 3.0 uses TX_FRM for everything. */
 	HTT_H2T_MSG_TYPE_MGMT_TX            = 7,
 
 	HTT_H2T_NUM_MSGS /* keep this last */
diff --git a/drivers/net/wireless/ath/ath10k/htt_tx.c b/drivers/net/wireless/ath/ath10k/htt_tx.c
index 656c254..d4fb387 100644
--- a/drivers/net/wireless/ath/ath10k/htt_tx.c
+++ b/drivers/net/wireless/ath/ath10k/htt_tx.c
@@ -401,10 +401,16 @@ int ath10k_htt_tx(struct ath10k_htt *htt, struct sk_buff *msdu)
 		goto err;
 	}
 
-	txfrag = dev_alloc_skb(frag_len);
-	if (!txfrag) {
-		res = -ENOMEM;
-		goto err;
+	/* Since HTT 3.0 there is no separate mgmt tx command. However in case
+	 * of mgmt tx using TX_FRM there is not tx fragment list. Instead of tx
+	 * fragment list host driver specifies directly frame pointer. */
+	if (htt->target_version_major < 3 ||
+	    !ieee80211_is_mgmt(hdr->frame_control)) {
+		txfrag = dev_alloc_skb(frag_len);
+		if (!txfrag) {
+			res = -ENOMEM;
+			goto err;
+		}
 	}
 
 	if (!IS_ALIGNED((unsigned long)txdesc->data, 4)) {
@@ -427,23 +433,31 @@ int ath10k_htt_tx(struct ath10k_htt *htt, struct sk_buff *msdu)
 	if (res)
 		goto err;
 
-	/* tx fragment list must be terminated with zero-entry */
-	skb_put(txfrag, frag_len);
-	tx_frags = (struct htt_data_tx_desc_frag *)txfrag->data;
-	tx_frags[0].paddr = __cpu_to_le32(ATH10K_SKB_CB(msdu)->paddr);
-	tx_frags[0].len   = __cpu_to_le32(msdu->len);
-	tx_frags[1].paddr = __cpu_to_le32(0);
-	tx_frags[1].len   = __cpu_to_le32(0);
-
-	res = ath10k_skb_map(dev, txfrag);
-	if (res)
-		goto err;
+	/* Since HTT 3.0 there is no separate mgmt tx command. However in case
+	 * of mgmt tx using TX_FRM there is not tx fragment list. Instead of tx
+	 * fragment list host driver specifies directly frame pointer. */
+	if (htt->target_version_major < 3 ||
+	    !ieee80211_is_mgmt(hdr->frame_control)) {
+		/* tx fragment list must be terminated with zero-entry */
+		skb_put(txfrag, frag_len);
+		tx_frags = (struct htt_data_tx_desc_frag *)txfrag->data;
+		tx_frags[0].paddr = __cpu_to_le32(ATH10K_SKB_CB(msdu)->paddr);
+		tx_frags[0].len   = __cpu_to_le32(msdu->len);
+		tx_frags[1].paddr = __cpu_to_le32(0);
+		tx_frags[1].len   = __cpu_to_le32(0);
+
+		res = ath10k_skb_map(dev, txfrag);
+		if (res)
+			goto err;
+
+		ath10k_dbg(ATH10K_DBG_HTT, "txfrag 0x%llx\n",
+			   (unsigned long long) ATH10K_SKB_CB(txfrag)->paddr);
+		ath10k_dbg_dump(ATH10K_DBG_HTT_DUMP, NULL, "txfrag: ",
+				txfrag->data, frag_len);
+	}
 
-	ath10k_dbg(ATH10K_DBG_HTT, "txfrag 0x%llx msdu 0x%llx\n",
-		   (unsigned long long) ATH10K_SKB_CB(txfrag)->paddr,
+	ath10k_dbg(ATH10K_DBG_HTT, "msdu 0x%llx\n",
 		   (unsigned long long) ATH10K_SKB_CB(msdu)->paddr);
-	ath10k_dbg_dump(ATH10K_DBG_HTT_DUMP, NULL, "txfrag: ",
-			txfrag->data, frag_len);
 	ath10k_dbg_dump(ATH10K_DBG_HTT_DUMP, NULL, "msdu: ",
 			msdu->data, msdu->len);
 
@@ -459,8 +473,17 @@ int ath10k_htt_tx(struct ath10k_htt *htt, struct sk_buff *msdu)
 	if (!ieee80211_has_protected(hdr->frame_control))
 		flags0 |= HTT_DATA_TX_DESC_FLAGS0_NO_ENCRYPT;
 	flags0 |= HTT_DATA_TX_DESC_FLAGS0_MAC_HDR_PRESENT;
-	flags0 |= SM(ATH10K_HW_TXRX_NATIVE_WIFI,
-		     HTT_DATA_TX_DESC_FLAGS0_PKT_TYPE);
+
+	/* Since HTT 3.0 there is no separate mgmt tx command. However in case
+	 * of mgmt tx using TX_FRM there is not tx fragment list. Instead of tx
+	 * fragment list host driver specifies directly frame pointer. */
+	if (htt->target_version_major >= 3 &&
+	    ieee80211_is_mgmt(hdr->frame_control))
+		flags0 |= SM(ATH10K_HW_TXRX_MGMT,
+			     HTT_DATA_TX_DESC_FLAGS0_PKT_TYPE);
+	else
+		flags0 |= SM(ATH10K_HW_TXRX_NATIVE_WIFI,
+			     HTT_DATA_TX_DESC_FLAGS0_PKT_TYPE);
 
 	flags1  = 0;
 	flags1 |= SM((u16)vdev_id, HTT_DATA_TX_DESC_FLAGS1_VDEV_ID);
@@ -468,7 +491,14 @@ int ath10k_htt_tx(struct ath10k_htt *htt, struct sk_buff *msdu)
 	flags1 |= HTT_DATA_TX_DESC_FLAGS1_CKSUM_L3_OFFLOAD;
 	flags1 |= HTT_DATA_TX_DESC_FLAGS1_CKSUM_L4_OFFLOAD;
 
-	frags_paddr = ATH10K_SKB_CB(txfrag)->paddr;
+	/* Since HTT 3.0 there is no separate mgmt tx command. However in case
+	 * of mgmt tx using TX_FRM there is not tx fragment list. Instead of tx
+	 * fragment list host driver specifies directly frame pointer. */
+	if (htt->target_version_major >= 3 &&
+	    ieee80211_is_mgmt(hdr->frame_control))
+		frags_paddr = ATH10K_SKB_CB(msdu)->paddr;
+	else
+		frags_paddr = ATH10K_SKB_CB(txfrag)->paddr;
 
 	cmd->hdr.msg_type        = HTT_H2T_MSG_TYPE_TX_FRM;
 	cmd->data_tx.flags0      = flags0;
diff --git a/drivers/net/wireless/ath/ath10k/hw.h b/drivers/net/wireless/ath/ath10k/hw.h
index 44ed5af..9c5d6fc 100644
--- a/drivers/net/wireless/ath/ath10k/hw.h
+++ b/drivers/net/wireless/ath/ath10k/hw.h
@@ -53,6 +53,9 @@ enum ath10k_hw_txrx_mode {
 	ATH10K_HW_TXRX_RAW = 0,
 	ATH10K_HW_TXRX_NATIVE_WIFI = 1,
 	ATH10K_HW_TXRX_ETHERNET = 2,
+
+	/* Valid for HTT >= 3.0. Used for management frames in TX_FRM. */
+	ATH10K_HW_TXRX_MGMT = 3,
 };
 
 enum ath10k_mcast2ucast_mode {
diff --git a/drivers/net/wireless/ath/ath10k/mac.c b/drivers/net/wireless/ath/ath10k/mac.c
index cc6ad7a..3598b48 100644
--- a/drivers/net/wireless/ath/ath10k/mac.c
+++ b/drivers/net/wireless/ath/ath10k/mac.c
@@ -1480,6 +1480,12 @@ static void ath10k_tx_htt(struct ath10k *ar, struct sk_buff *skb)
 	struct ieee80211_hdr *hdr = (struct ieee80211_hdr *)skb->data;
 	int ret;
 
+	if (ar->htt.target_version_major >= 3) {
+		/* Since HTT 3.0 there is no separate mgmt tx command */
+		ret = ath10k_htt_tx(&ar->htt, skb);
+		goto exit;
+	}
+
 	if (ieee80211_is_mgmt(hdr->frame_control))
 		ret = ath10k_htt_mgmt_tx(&ar->htt, skb);
 	else if (ieee80211_is_nullfunc(hdr->frame_control))
@@ -1491,6 +1497,7 @@ static void ath10k_tx_htt(struct ath10k *ar, struct sk_buff *skb)
 	else
 		ret = ath10k_htt_tx(&ar->htt, skb);
 
+exit:
 	if (ret) {
 		ath10k_warn("tx failed (%d). dropping packet.\n", ret);
 		ieee80211_free_txskb(ar->hw, skb);
@@ -1726,8 +1733,10 @@ static void ath10k_tx(struct ieee80211_hw *hw,
 
 	/* we must calculate tid before we apply qos workaround
 	 * as we'd lose the qos control field */
-	if (ieee80211_is_data_qos(hdr->frame_control) &&
-	    is_unicast_ether_addr(ieee80211_get_DA(hdr))) {
+	if (ieee80211_is_mgmt(hdr->frame_control)) {
+		tid = HTT_DATA_TX_EXT_TID_MGMT;
+	} else if (ieee80211_is_data_qos(hdr->frame_control) &&
+		   is_unicast_ether_addr(ieee80211_get_DA(hdr))) {
 		u8 *qc = ieee80211_get_qos_ctl(hdr);
 		tid = qc[0] & IEEE80211_QOS_CTL_TID_MASK;
 	} else if (is_unicast_ether_addr(ieee80211_get_DA(hdr))) {
-- 
1.7.9.5

