Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from server19320154104.serverpool.info ([193.201.54.104]:38187 "EHLO
	hauke-m.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752655Ab0KLTVg (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 12 Nov 2010 14:21:36 -0500
From: Hauke Mehrtens <hauke@hauke-m.de>
To: lrodriguez@atheros.com
Cc: linux-wireless@vger.kernel.org, mcgrof@infradead.org,
	Hauke Mehrtens <hauke@hauke-m.de>
Subject: [PATCH 1/2] compat-wireless: make patches apply again
Date: Fri, 12 Nov 2010 20:21:24 +0100
Message-Id: <1289589685-16372-1-git-send-email-hauke@hauke-m.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


Signed-off-by: Hauke Mehrtens <hauke@hauke-m.de>
---
 crap/0002-ath9k-Add-pktlog-support.patch |   37 +++++++++++++++--------------
 patches/08-rename-iwl4965-config.patch   |    4 +-
 2 files changed, 21 insertions(+), 20 deletions(-)

diff --git a/crap/0002-ath9k-Add-pktlog-support.patch b/crap/0002-ath9k-Add-pktlog-support.patch
index a5ae88f..89b0074 100644
--- a/crap/0002-ath9k-Add-pktlog-support.patch
+++ b/crap/0002-ath9k-Add-pktlog-support.patch
@@ -105,7 +105,7 @@ Signed-off-by: Vasanthakumar Thiagarajan <vasanth@atheros.com>
  
  /*
   * Header for the ath9k.ko driver core *only* -- hw code nor any other driver
-@@ -561,6 +562,7 @@ struct ath_ant_comb {
+@@ -559,6 +560,7 @@ struct ath_ant_comb {
  #define SC_OP_BT_PRIORITY_DETECTED   BIT(12)
  #define SC_OP_BT_SCAN		     BIT(13)
  #define SC_OP_ANI_RUN		     BIT(14)
@@ -113,7 +113,7 @@ Signed-off-by: Vasanthakumar Thiagarajan <vasanth@atheros.com>
  
  /* Powersave flags */
  #define PS_WAIT_FOR_BEACON        BIT(0)
-@@ -637,6 +639,10 @@ struct ath_softc {
+@@ -635,6 +637,10 @@ struct ath_softc {
  #ifdef CONFIG_ATH9K_DEBUGFS
  	struct ath9k_debug debug;
  #endif
@@ -126,7 +126,7 @@ Signed-off-by: Vasanthakumar Thiagarajan <vasanth@atheros.com>
  	struct ath_btcoex btcoex;
 --- a/drivers/net/wireless/ath/ath9k/debug.c
 +++ b/drivers/net/wireless/ath/ath9k/debug.c
-@@ -984,6 +984,9 @@ int ath9k_init_debug(struct ath_hw *ah)
+@@ -986,6 +986,9 @@ int ath9k_init_debug(struct ath_hw *ah)
  			sc, &fops_regdump))
  		goto err;
  
@@ -136,7 +136,7 @@ Signed-off-by: Vasanthakumar Thiagarajan <vasanth@atheros.com>
  	return 0;
  err:
  	ath9k_exit_debug(ah);
-@@ -995,6 +998,7 @@ void ath9k_exit_debug(struct ath_hw *ah)
+@@ -997,6 +1000,7 @@ void ath9k_exit_debug(struct ath_hw *ah)
  	struct ath_common *common = ath9k_hw_common(ah);
  	struct ath_softc *sc = (struct ath_softc *) common->priv;
  
@@ -172,7 +172,7 @@ Signed-off-by: Vasanthakumar Thiagarajan <vasanth@atheros.com>
  		REG_WRITE(ah, AR_RXCFG,
 --- a/drivers/net/wireless/ath/ath9k/hw.h
 +++ b/drivers/net/wireless/ath/ath9k/hw.h
-@@ -573,7 +573,7 @@ struct ath_hw_ops {
+@@ -580,7 +580,7 @@ struct ath_hw_ops {
  			    const void *ds0, dma_addr_t buf_addr,
  			    unsigned int qcu);
  	int (*proc_txdesc)(struct ath_hw *ah, void *ds,
@@ -181,7 +181,7 @@ Signed-off-by: Vasanthakumar Thiagarajan <vasanth@atheros.com>
  	void (*set11n_txdesc)(struct ath_hw *ah, void *ds,
  			      u32 pktLen, enum ath9k_pkt_type type,
  			      u32 txPower, u32 keyIx,
-@@ -797,6 +797,8 @@ struct ath_hw {
+@@ -804,6 +804,8 @@ struct ath_hw {
  	 * this register when in sleep states.
  	 */
  	u32 WARegVal;
@@ -1355,7 +1355,7 @@ Signed-off-by: Vasanthakumar Thiagarajan <vasanth@atheros.com>
  		if (!txpending || (tid->state & AGGR_CLEANUP)) {
  			/*
  			 * complete the acked-ones/xretried ones; update
-@@ -2082,7 +2084,7 @@ static void ath_tx_processq(struct ath_s
+@@ -2069,7 +2071,7 @@ static void ath_tx_processq(struct ath_s
  		ds = lastbf->bf_desc;
  
  		memset(&ts, 0, sizeof(ts));
@@ -1364,9 +1364,9 @@ Signed-off-by: Vasanthakumar Thiagarajan <vasanth@atheros.com>
  		if (status == -EINPROGRESS) {
  			spin_unlock_bh(&txq->axq_lock);
  			break;
-@@ -2119,10 +2121,14 @@ static void ath_tx_processq(struct ath_s
- 			ath_tx_rc_status(bf, &ts, txok ? 0 : 1, txok, true);
- 		}
+@@ -2108,10 +2110,14 @@ static void ath_tx_processq(struct ath_s
+ 
+ 		qnum = skb_get_queue_mapping(bf->bf_mpdu);
  
 -		if (bf_isampdu(bf))
 +		if (bf_isampdu(bf)) {
@@ -1379,12 +1379,12 @@ Signed-off-by: Vasanthakumar Thiagarajan <vasanth@atheros.com>
 +
 +		ath_pktlog_txstatus(sc, lastbf->bf_desc);
  
- 		ath_wake_mac80211_queue(sc, txq);
- 
-@@ -2194,9 +2200,11 @@ void ath_tx_edma_tasklet(struct ath_soft
- 	struct list_head bf_head;
+ 		if (txq == sc->tx.txq_map[qnum])
+ 			ath_wake_mac80211_queue(sc, qnum);
+@@ -2185,9 +2191,11 @@ void ath_tx_edma_tasklet(struct ath_soft
  	int status;
  	int txok;
+ 	int qnum;
 +	u32 txs_desc[9];
  
  	for (;;) {
@@ -1394,9 +1394,9 @@ Signed-off-by: Vasanthakumar Thiagarajan <vasanth@atheros.com>
  		if (status == -EINPROGRESS)
  			break;
  		if (status == -EIO) {
-@@ -2237,14 +2245,18 @@ void ath_tx_edma_tasklet(struct ath_soft
- 			ath_tx_rc_status(bf, &txs, txok ? 0 : 1, txok, true);
- 		}
+@@ -2230,15 +2238,19 @@ void ath_tx_edma_tasklet(struct ath_soft
+ 
+ 		qnum = skb_get_queue_mapping(bf->bf_mpdu);
  
 -		if (bf_isampdu(bf))
 +		if (bf_isampdu(bf)) {
@@ -1408,7 +1408,8 @@ Signed-off-by: Vasanthakumar Thiagarajan <vasanth@atheros.com>
  					    &txs, txok, 0);
 +		}
  
- 		ath_wake_mac80211_queue(sc, txq);
+ 		if (txq == sc->tx.txq_map[qnum])
+ 			ath_wake_mac80211_queue(sc, qnum);
  
 +		ath_pktlog_txstatus(sc, txs_desc);
 +
diff --git a/patches/08-rename-iwl4965-config.patch b/patches/08-rename-iwl4965-config.patch
index a2354e9..32b7f59 100644
--- a/patches/08-rename-iwl4965-config.patch
+++ b/patches/08-rename-iwl4965-config.patch
@@ -34,12 +34,12 @@ CONFIG_IWL4965 has to be set to y, to build correctly.
  
 -iwlagn-$(CONFIG_IWL4965) += iwl-4965.o
 +iwlagn-$(CONFIG_COMPAT_IWL4965) += iwl-4965.o
- iwlagn-$(CONFIG_IWL5000) += iwl-agn-rxon.o
+ iwlagn-$(CONFIG_IWL5000) += iwl-agn-rxon.o iwl-agn-hcmd.o iwl-agn-ict.o
  iwlagn-$(CONFIG_IWL5000) += iwl-5000.o
  iwlagn-$(CONFIG_IWL5000) += iwl-6000.o
 --- a/drivers/net/wireless/iwlwifi/iwl-agn.c
 +++ b/drivers/net/wireless/iwlwifi/iwl-agn.c
-@@ -4357,10 +4357,10 @@ static void __devexit iwl_pci_remove(str
+@@ -4337,10 +4337,10 @@ static void __devexit iwl_pci_remove(str
  
  /* Hardware specific file defines the PCI IDs table for that hardware module */
  static DEFINE_PCI_DEVICE_TABLE(iwl_hw_card_ids) = {
-- 
1.7.1

