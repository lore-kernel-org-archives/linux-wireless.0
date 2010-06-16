Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail30s.wh2.ocn.ne.jp ([125.206.180.198]:34863 "HELO
	mail30s.wh2.ocn.ne.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1758641Ab0FPKMV (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 16 Jun 2010 06:12:21 -0400
Received: from vs3000.wh2.ocn.ne.jp (125.206.180.163)
	by mail30s.wh2.ocn.ne.jp (RS ver 1.0.95vs) with SMTP id 2-0858413140
	for <linux-wireless@vger.kernel.org>; Wed, 16 Jun 2010 19:12:20 +0900 (JST)
Subject: [PATCH 10/17] ath5k: use direct function calls for descriptors when
	possible
To: linville@tuxdriver.com
From: Bruno Randolf <br1@einfach.org>
Cc: ath5k-devel@lists.ath5k.org, linux-wireless@vger.kernel.org
Date: Wed, 16 Jun 2010 19:12:01 +0900
Message-ID: <20100616101201.10067.35557.stgit@tt-desk>
In-Reply-To: <20100616100809.10067.34787.stgit@tt-desk>
References: <20100616100809.10067.34787.stgit@tt-desk>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Use direct function calls for ath5k_hw_setup_rx_desc() and
ath5k_hw_setup_mrr_tx_desc() instead of a function pointer which always pointed
to the same function in the case of ath5k_hw_setup_rx_desc() and which is
easily unified in the case of ath5k_hw_setup_mrr_tx_desc().

Also simplify the initialization function for the remaining function pointers.

Signed-off-by: Bruno Randolf <br1@einfach.org>
---
 drivers/net/wireless/ath/ath5k/ath5k.h |   10 ++++----
 drivers/net/wireless/ath/ath5k/base.c  |    7 +++--
 drivers/net/wireless/ath/ath5k/desc.c  |   41 +++++++++-----------------------
 3 files changed, 20 insertions(+), 38 deletions(-)

diff --git a/drivers/net/wireless/ath/ath5k/ath5k.h b/drivers/net/wireless/ath/ath5k/ath5k.h
index 387c120..ea6362a 100644
--- a/drivers/net/wireless/ath/ath5k/ath5k.h
+++ b/drivers/net/wireless/ath/ath5k/ath5k.h
@@ -1127,15 +1127,10 @@ struct ath5k_hw {
 	/*
 	 * Function pointers
 	 */
-	int (*ah_setup_rx_desc)(struct ath5k_hw *ah, struct ath5k_desc *desc,
-				u32 size, unsigned int flags);
 	int (*ah_setup_tx_desc)(struct ath5k_hw *, struct ath5k_desc *,
 		unsigned int, unsigned int, int, enum ath5k_pkt_type,
 		unsigned int, unsigned int, unsigned int, unsigned int,
 		unsigned int, unsigned int, unsigned int, unsigned int);
-	int (*ah_setup_mrr_tx_desc)(struct ath5k_hw *, struct ath5k_desc *,
-		unsigned int, unsigned int, unsigned int, unsigned int,
-		unsigned int, unsigned int);
 	int (*ah_proc_tx_desc)(struct ath5k_hw *, struct ath5k_desc *,
 		struct ath5k_tx_status *);
 	int (*ah_proc_rx_desc)(struct ath5k_hw *, struct ath5k_desc *,
@@ -1236,6 +1231,11 @@ int ath5k_hw_set_slot_time(struct ath5k_hw *ah, unsigned int slot_time);
 
 /* Hardware Descriptor Functions */
 int ath5k_hw_init_desc_functions(struct ath5k_hw *ah);
+int ath5k_hw_setup_rx_desc(struct ath5k_hw *ah, struct ath5k_desc *desc,
+			   u32 size, unsigned int flags);
+int ath5k_hw_setup_mrr_tx_desc(struct ath5k_hw *ah, struct ath5k_desc *desc,
+	unsigned int tx_rate1, u_int tx_tries1, u_int tx_rate2,
+	u_int tx_tries2, unsigned int tx_rate3, u_int tx_tries3);
 
 /* GPIO Functions */
 void ath5k_hw_set_ledstate(struct ath5k_hw *ah, unsigned int state);
diff --git a/drivers/net/wireless/ath/ath5k/base.c b/drivers/net/wireless/ath/ath5k/base.c
index a4482b5..20328bd 100644
--- a/drivers/net/wireless/ath/ath5k/base.c
+++ b/drivers/net/wireless/ath/ath5k/base.c
@@ -769,7 +769,8 @@ ath5k_attach(struct pci_dev *pdev, struct ieee80211_hw *hw)
 	 * return false w/o doing anything.  MAC's that do
 	 * support it will return true w/o doing anything.
 	 */
-	ret = ah->ah_setup_mrr_tx_desc(ah, NULL, 0, 0, 0, 0, 0, 0);
+	ret = ath5k_hw_setup_mrr_tx_desc(ah, NULL, 0, 0, 0, 0, 0, 0);
+
 	if (ret < 0)
 		goto err;
 	if (ret > 0)
@@ -1245,7 +1246,7 @@ ath5k_rxbuf_setup(struct ath5k_softc *sc, struct ath5k_buf *bf)
 	ds = bf->desc;
 	ds->ds_link = bf->daddr;	/* link to self */
 	ds->ds_data = bf->skbaddr;
-	ret = ah->ah_setup_rx_desc(ah, ds, ah->common.rx_bufsize, 0);
+	ret = ath5k_hw_setup_rx_desc(ah, ds, ah->common.rx_bufsize, 0);
 	if (ret) {
 		ATH5K_ERR(sc, "%s: could not setup RX desc\n", __func__);
 		return ret;
@@ -1354,7 +1355,7 @@ ath5k_txbuf_setup(struct ath5k_softc *sc, struct ath5k_buf *bf,
 		mrr_tries[i] = info->control.rates[i + 1].count;
 	}
 
-	ah->ah_setup_mrr_tx_desc(ah, ds,
+	ath5k_hw_setup_mrr_tx_desc(ah, ds,
 		mrr_rate[0], mrr_tries[0],
 		mrr_rate[1], mrr_tries[1],
 		mrr_rate[2], mrr_tries[2]);
diff --git a/drivers/net/wireless/ath/ath5k/desc.c b/drivers/net/wireless/ath/ath5k/desc.c
index da5dbb6..b5a5d45 100644
--- a/drivers/net/wireless/ath/ath5k/desc.c
+++ b/drivers/net/wireless/ath/ath5k/desc.c
@@ -277,13 +277,17 @@ static int ath5k_hw_setup_4word_tx_desc(struct ath5k_hw *ah,
 /*
  * Initialize a 4-word multi rate retry tx control descriptor on 5212
  */
-static int
+int
 ath5k_hw_setup_mrr_tx_desc(struct ath5k_hw *ah, struct ath5k_desc *desc,
 	unsigned int tx_rate1, u_int tx_tries1, u_int tx_rate2,
 	u_int tx_tries2, unsigned int tx_rate3, u_int tx_tries3)
 {
 	struct ath5k_hw_4w_tx_ctl *tx_ctl;
 
+	/* no mrr support for cards older than 5212 */
+	if (ah->ah_version < AR5K_AR5212)
+		return 0;
+
 	/*
 	 * Rates can be 0 as long as the retry count is 0 too.
 	 * A zero rate and nonzero retry count will put the HW into a mode where
@@ -323,15 +327,6 @@ ath5k_hw_setup_mrr_tx_desc(struct ath5k_hw *ah, struct ath5k_desc *desc,
 	return 0;
 }
 
-/* no mrr support for cards older than 5212 */
-static int
-ath5k_hw_setup_no_mrr(struct ath5k_hw *ah, struct ath5k_desc *desc,
-	unsigned int tx_rate1, u_int tx_tries1, u_int tx_rate2,
-	u_int tx_tries2, unsigned int tx_rate3, u_int tx_tries3)
-{
-	return 0;
-}
-
 /*
  * Proccess the tx status descriptor on 5210/5211
  */
@@ -480,8 +475,8 @@ static int ath5k_hw_proc_4word_tx_status(struct ath5k_hw *ah,
 /*
  * Initialize an rx control descriptor
  */
-static int ath5k_hw_setup_rx_desc(struct ath5k_hw *ah, struct ath5k_desc *desc,
-			u32 size, unsigned int flags)
+int ath5k_hw_setup_rx_desc(struct ath5k_hw *ah, struct ath5k_desc *desc,
+			   u32 size, unsigned int flags)
 {
 	struct ath5k_hw_rx_ctl *rx_ctl;
 
@@ -658,29 +653,15 @@ static int ath5k_hw_proc_5212_rx_status(struct ath5k_hw *ah,
  */
 int ath5k_hw_init_desc_functions(struct ath5k_hw *ah)
 {
-
-	if (ah->ah_version != AR5K_AR5210 &&
-		ah->ah_version != AR5K_AR5211 &&
-		ah->ah_version != AR5K_AR5212)
-			return -ENOTSUPP;
-
 	if (ah->ah_version == AR5K_AR5212) {
-		ah->ah_setup_rx_desc = ath5k_hw_setup_rx_desc;
 		ah->ah_setup_tx_desc = ath5k_hw_setup_4word_tx_desc;
-		ah->ah_setup_mrr_tx_desc = ath5k_hw_setup_mrr_tx_desc;
 		ah->ah_proc_tx_desc = ath5k_hw_proc_4word_tx_status;
-	} else {
-		ah->ah_setup_rx_desc = ath5k_hw_setup_rx_desc;
+		ah->ah_proc_rx_desc = ath5k_hw_proc_5212_rx_status;
+	} else if (ah->ah_version <= AR5K_AR5211) {
 		ah->ah_setup_tx_desc = ath5k_hw_setup_2word_tx_desc;
-		ah->ah_setup_mrr_tx_desc = ath5k_hw_setup_no_mrr;
 		ah->ah_proc_tx_desc = ath5k_hw_proc_2word_tx_status;
-	}
-
-	if (ah->ah_version == AR5K_AR5212)
-		ah->ah_proc_rx_desc = ath5k_hw_proc_5212_rx_status;
-	else if (ah->ah_version <= AR5K_AR5211)
 		ah->ah_proc_rx_desc = ath5k_hw_proc_5210_rx_status;
-
+	} else
+		return -ENOTSUPP;
 	return 0;
 }
-

