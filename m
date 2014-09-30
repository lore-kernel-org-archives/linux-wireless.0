Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from static.88-198-24-112.clients.your-server.de ([88.198.24.112]:46001
	"EHLO nbd.name" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753403AbaI3JEC (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 30 Sep 2014 05:04:02 -0400
From: Felix Fietkau <nbd@openwrt.org>
To: linux-wireless@vger.kernel.org
Cc: linville@tuxdriver.com, lorenzo.bianconi83@gmail.com
Subject: [PATCH] ath9k: fix getting tx duration for dynack
Date: Tue, 30 Sep 2014 11:03:53 +0200
Message-Id: <1412067833-90150-1-git-send-email-nbd@openwrt.org> (sfid-20140930_110435_664249_13ADCF01)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On AR9003, tx control and tx status are in separate descriptor rings.
Tx duration is extracted from the tx control descriptor data, which
ar9003_hw_proc_txdesc cannot access.

Fix getting the duration by adding a separate callback for it.

Acked-by: Lorenzo Bianconi <lorenzo.bianconi83@gmail.com>
Signed-off-by: Felix Fietkau <nbd@openwrt.org>
---
 drivers/net/wireless/ath/ath9k/ar9002_mac.c | 26 +++++++++++++++++++-------
 drivers/net/wireless/ath/ath9k/ar9003_mac.c | 28 +++++++++++++++++++---------
 drivers/net/wireless/ath/ath9k/dynack.c     |  2 +-
 drivers/net/wireless/ath/ath9k/hw-ops.h     |  6 ++++++
 drivers/net/wireless/ath/ath9k/hw.h         |  1 +
 drivers/net/wireless/ath/ath9k/mac.h        |  2 +-
 6 files changed, 47 insertions(+), 18 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/ar9002_mac.c b/drivers/net/wireless/ath/ath9k/ar9002_mac.c
index 669cb37..2a93519 100644
--- a/drivers/net/wireless/ath/ath9k/ar9002_mac.c
+++ b/drivers/net/wireless/ath/ath9k/ar9002_mac.c
@@ -381,16 +381,27 @@ static int ar9002_hw_proc_txdesc(struct ath_hw *ah, void *ds,
 	ts->evm1 = ads->AR_TxEVM1;
 	ts->evm2 = ads->AR_TxEVM2;
 
-	status = ACCESS_ONCE(ads->ds_ctl4);
-	ts->duration[0] = MS(status, AR_PacketDur0);
-	ts->duration[1] = MS(status, AR_PacketDur1);
-	status = ACCESS_ONCE(ads->ds_ctl5);
-	ts->duration[2] = MS(status, AR_PacketDur2);
-	ts->duration[3] = MS(status, AR_PacketDur3);
-
 	return 0;
 }
 
+static int ar9002_hw_get_duration(struct ath_hw *ah, const void *ds, int index)
+{
+	struct ar5416_desc *ads = AR5416DESC(ds);
+
+	switch (index) {
+	case 0:
+		return MS(ACCESS_ONCE(ads->ds_ctl4), AR_PacketDur0);
+	case 1:
+		return MS(ACCESS_ONCE(ads->ds_ctl4), AR_PacketDur1);
+	case 2:
+		return MS(ACCESS_ONCE(ads->ds_ctl5), AR_PacketDur2);
+	case 3:
+		return MS(ACCESS_ONCE(ads->ds_ctl5), AR_PacketDur3);
+	default:
+		return -1;
+	}
+}
+
 void ath9k_hw_setuprxdesc(struct ath_hw *ah, struct ath_desc *ds,
 			  u32 size, u32 flags)
 {
@@ -413,4 +424,5 @@ void ar9002_hw_attach_mac_ops(struct ath_hw *ah)
 	ops->get_isr = ar9002_hw_get_isr;
 	ops->set_txdesc = ar9002_set_txdesc;
 	ops->proc_txdesc = ar9002_hw_proc_txdesc;
+	ops->get_duration = ar9002_hw_get_duration;
 }
diff --git a/drivers/net/wireless/ath/ath9k/ar9003_mac.c b/drivers/net/wireless/ath/ath9k/ar9003_mac.c
index e5f7c11..057b165 100644
--- a/drivers/net/wireless/ath/ath9k/ar9003_mac.c
+++ b/drivers/net/wireless/ath/ath9k/ar9003_mac.c
@@ -355,11 +355,9 @@ static int ar9003_hw_proc_txdesc(struct ath_hw *ah, void *ds,
 				 struct ath_tx_status *ts)
 {
 	struct ar9003_txs *ads;
-	struct ar9003_txc *adc;
 	u32 status;
 
 	ads = &ah->ts_ring[ah->ts_tail];
-	adc = (struct ar9003_txc *)ads;
 
 	status = ACCESS_ONCE(ads->status8);
 	if ((status & AR_TxDone) == 0)
@@ -428,18 +426,29 @@ static int ar9003_hw_proc_txdesc(struct ath_hw *ah, void *ds,
 	ts->ts_rssi_ext1 = MS(status, AR_TxRSSIAnt11);
 	ts->ts_rssi_ext2 = MS(status, AR_TxRSSIAnt12);
 
-	status = ACCESS_ONCE(adc->ctl15);
-	ts->duration[0] = MS(status, AR_PacketDur0);
-	ts->duration[1] = MS(status, AR_PacketDur1);
-	status = ACCESS_ONCE(adc->ctl16);
-	ts->duration[2] = MS(status, AR_PacketDur2);
-	ts->duration[3] = MS(status, AR_PacketDur3);
-
 	memset(ads, 0, sizeof(*ads));
 
 	return 0;
 }
 
+static int ar9003_hw_get_duration(struct ath_hw *ah, const void *ds, int index)
+{
+	const struct ar9003_txc *adc = ds;
+
+	switch (index) {
+	case 0:
+		return MS(ACCESS_ONCE(adc->ctl15), AR_PacketDur0);
+	case 1:
+		return MS(ACCESS_ONCE(adc->ctl15), AR_PacketDur1);
+	case 2:
+		return MS(ACCESS_ONCE(adc->ctl16), AR_PacketDur2);
+	case 3:
+		return MS(ACCESS_ONCE(adc->ctl16), AR_PacketDur3);
+	default:
+		return 0;
+	}
+}
+
 void ar9003_hw_attach_mac_ops(struct ath_hw *hw)
 {
 	struct ath_hw_ops *ops = ath9k_hw_ops(hw);
@@ -449,6 +458,7 @@ void ar9003_hw_attach_mac_ops(struct ath_hw *hw)
 	ops->get_isr = ar9003_hw_get_isr;
 	ops->set_txdesc = ar9003_set_txdesc;
 	ops->proc_txdesc = ar9003_hw_proc_txdesc;
+	ops->get_duration = ar9003_hw_get_duration;
 }
 
 void ath9k_hw_set_rx_bufsize(struct ath_hw *ah, u16 buf_size)
diff --git a/drivers/net/wireless/ath/ath9k/dynack.c b/drivers/net/wireless/ath/ath9k/dynack.c
index 6ae8e0b..22b3cc4 100644
--- a/drivers/net/wireless/ath/ath9k/dynack.c
+++ b/drivers/net/wireless/ath/ath9k/dynack.c
@@ -202,7 +202,7 @@ void ath_dynack_sample_tx_ts(struct ath_hw *ah, struct sk_buff *skb,
 	ridx = ts->ts_rateindex;
 
 	da->st_rbf.ts[da->st_rbf.t_rb].tstamp = ts->ts_tstamp;
-	da->st_rbf.ts[da->st_rbf.t_rb].dur = ts->duration[ts->ts_rateindex];
+	da->st_rbf.ts[da->st_rbf.t_rb].dur = ts->duration;
 	ether_addr_copy(da->st_rbf.addr[da->st_rbf.t_rb].h_dest, hdr->addr1);
 	ether_addr_copy(da->st_rbf.addr[da->st_rbf.t_rb].h_src, hdr->addr2);
 
diff --git a/drivers/net/wireless/ath/ath9k/hw-ops.h b/drivers/net/wireless/ath/ath9k/hw-ops.h
index a47ea84..8e85efe 100644
--- a/drivers/net/wireless/ath/ath9k/hw-ops.h
+++ b/drivers/net/wireless/ath/ath9k/hw-ops.h
@@ -67,6 +67,12 @@ static inline int ath9k_hw_txprocdesc(struct ath_hw *ah, void *ds,
 	return ath9k_hw_ops(ah)->proc_txdesc(ah, ds, ts);
 }
 
+static inline int ath9k_hw_get_duration(struct ath_hw *ah, const void *ds,
+					int index)
+{
+	return ath9k_hw_ops(ah)->get_duration(ah, ds, index);
+}
+
 static inline void ath9k_hw_antdiv_comb_conf_get(struct ath_hw *ah,
 		struct ath_hw_antcomb_conf *antconf)
 {
diff --git a/drivers/net/wireless/ath/ath9k/hw.h b/drivers/net/wireless/ath/ath9k/hw.h
index b9eef33..975074f 100644
--- a/drivers/net/wireless/ath/ath9k/hw.h
+++ b/drivers/net/wireless/ath/ath9k/hw.h
@@ -691,6 +691,7 @@ struct ath_hw_ops {
 			   struct ath_tx_info *i);
 	int (*proc_txdesc)(struct ath_hw *ah, void *ds,
 			   struct ath_tx_status *ts);
+	int (*get_duration)(struct ath_hw *ah, const void *ds, int index);
 	void (*antdiv_comb_conf_get)(struct ath_hw *ah,
 			struct ath_hw_antcomb_conf *antconf);
 	void (*antdiv_comb_conf_set)(struct ath_hw *ah,
diff --git a/drivers/net/wireless/ath/ath9k/mac.h b/drivers/net/wireless/ath/ath9k/mac.h
index cd05a77..aa69cea 100644
--- a/drivers/net/wireless/ath/ath9k/mac.h
+++ b/drivers/net/wireless/ath/ath9k/mac.h
@@ -121,7 +121,7 @@ struct ath_tx_status {
 	u32 evm0;
 	u32 evm1;
 	u32 evm2;
-	u32 duration[4];
+	u32 duration;
 };
 
 struct ath_rx_status {
-- 
2.0.4

