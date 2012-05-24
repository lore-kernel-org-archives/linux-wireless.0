Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine01.qualcomm.com ([199.106.114.254]:34438 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753645Ab2EXDz7 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 23 May 2012 23:55:59 -0400
From: Sujith Manoharan <c_manoha@qca.qualcomm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Message-ID: <20413.45327.332721.859654@gargle.gargle.HOWL> (sfid-20120524_055601_913133_08F76FDD)
Date: Thu, 24 May 2012 09:24:55 +0530
To: <linville@tuxdriver.com>
CC: <linux-wireless@vger.kernel.org>
Subject: [PATCH 22/22] ath9k: improve BT FTP/PAN performance
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

When BT FTP/PAN transmits while WLAN is idle, the one of 9462 chain
often picks up BT's tx signal and starts receiving. If the current
weight is set to be higher than BT tx, BT tx will be aborted and this
also degrades BT performance. Hence lower WLAN rx priority in this
case only when there are no WLAN traffic.

Signed-off-by: Rajkumar Manoharan <rmanohar@qca.qualcomm.com>
---
 drivers/net/wireless/ath/ath9k/ath9k.h  |    2 ++
 drivers/net/wireless/ath/ath9k/btcoex.c |   10 ++++++++--
 drivers/net/wireless/ath/ath9k/btcoex.h |    4 ++++
 drivers/net/wireless/ath/ath9k/gpio.c   |   13 +++++++++++++
 drivers/net/wireless/ath/ath9k/recv.c   |    1 +
 5 files changed, 28 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/ath9k.h b/drivers/net/wireless/ath/ath9k/ath9k.h
index 9c54d4c..29248e5 100644
--- a/drivers/net/wireless/ath/ath9k/ath9k.h
+++ b/drivers/net/wireless/ath/ath9k/ath9k.h
@@ -307,6 +307,7 @@ struct ath_rx {
 	u8 defant;
 	u8 rxotherant;
 	u32 *rxlink;
+	u32 num_pkts;
 	unsigned int rxfilter;
 	spinlock_t rxbuflock;
 	struct list_head rxbuf;
@@ -456,6 +457,7 @@ struct ath_btcoex {
 	u32 btcoex_period; /* in usec */
 	u32 btscan_no_stomp; /* in usec */
 	u32 duty_cycle;
+	u32 bt_wait_time;
 	struct ath_gen_timer *no_stomp_timer; /* Timer for no BT stomping */
 	struct ath_mci_profile mci;
 };
diff --git a/drivers/net/wireless/ath/ath9k/btcoex.c b/drivers/net/wireless/ath/ath9k/btcoex.c
index 1ca6da8..acd4373 100644
--- a/drivers/net/wireless/ath/ath9k/btcoex.c
+++ b/drivers/net/wireless/ath/ath9k/btcoex.c
@@ -336,10 +336,16 @@ static void ar9003_btcoex_bt_stomp(struct ath_hw *ah,
 			 enum ath_stomp_type stomp_type)
 {
 	struct ath_btcoex_hw *btcoex = &ah->btcoex_hw;
-	const u32 *weight = AR_SREV_9462(ah) ? ar9003_wlan_weights[stomp_type] :
-					       ar9462_wlan_weights[stomp_type];
+	const u32 *weight = ar9003_wlan_weights[stomp_type];
 	int i;
 
+	if (AR_SREV_9462(ah)) {
+		if ((stomp_type == ATH_BTCOEX_STOMP_LOW) &&
+		    btcoex->mci.stomp_ftp)
+			stomp_type = ATH_BTCOEX_STOMP_LOW_FTP;
+		weight = ar9462_wlan_weights[stomp_type];
+	}
+
 	for (i = 0; i < AR9300_NUM_WLAN_WEIGHTS; i++) {
 		btcoex->bt_weight[i] = AR9300_BT_WGHT;
 		btcoex->wlan_weight[i] = weight[i];
diff --git a/drivers/net/wireless/ath/ath9k/btcoex.h b/drivers/net/wireless/ath/ath9k/btcoex.h
index 3a1e1cf..20092f9 100644
--- a/drivers/net/wireless/ath/ath9k/btcoex.h
+++ b/drivers/net/wireless/ath/ath9k/btcoex.h
@@ -36,6 +36,9 @@
 #define ATH_BT_CNT_THRESHOLD	       3
 #define ATH_BT_CNT_SCAN_THRESHOLD      15
 
+#define ATH_BTCOEX_RX_WAIT_TIME       100
+#define ATH_BTCOEX_STOMP_FTP_THRESH   5
+
 #define AR9300_NUM_BT_WEIGHTS   4
 #define AR9300_NUM_WLAN_WEIGHTS 4
 /* Defines the BT AR_BT_COEX_WGHT used */
@@ -80,6 +83,7 @@ struct ath9k_hw_mci {
 	u8 bt_ver_major;
 	u8 bt_ver_minor;
 	u8 bt_state;
+	u8 stomp_ftp;
 };
 
 struct ath_btcoex_hw {
diff --git a/drivers/net/wireless/ath/ath9k/gpio.c b/drivers/net/wireless/ath/ath9k/gpio.c
index ab805be..ae31a96 100644
--- a/drivers/net/wireless/ath/ath9k/gpio.c
+++ b/drivers/net/wireless/ath/ath9k/gpio.c
@@ -190,6 +190,7 @@ static void ath_btcoex_period_timer(unsigned long data)
 	struct ath_softc *sc = (struct ath_softc *) data;
 	struct ath_hw *ah = sc->sc_ah;
 	struct ath_btcoex *btcoex = &sc->btcoex;
+	struct ath_mci_profile *mci = &btcoex->mci;
 	u32 timer_period;
 	bool is_btscan;
 
@@ -198,6 +199,18 @@ static void ath_btcoex_period_timer(unsigned long data)
 		ath_detect_bt_priority(sc);
 	is_btscan = !!(btcoex->op_flags & BT_OP_SCAN);
 
+	btcoex->bt_wait_time += btcoex->btcoex_period;
+	if (btcoex->bt_wait_time > ATH_BTCOEX_RX_WAIT_TIME) {
+		if (ar9003_mci_state(ah, MCI_STATE_NEED_FTP_STOMP, NULL) &&
+		    (mci->num_pan || mci->num_other_acl))
+			ah->btcoex_hw.mci.stomp_ftp =
+				(sc->rx.num_pkts < ATH_BTCOEX_STOMP_FTP_THRESH);
+		else
+			ah->btcoex_hw.mci.stomp_ftp = false;
+		btcoex->bt_wait_time = 0;
+		sc->rx.num_pkts = 0;
+	}
+
 	spin_lock_bh(&btcoex->btcoex_lock);
 
 	ath9k_hw_btcoex_bt_stomp(ah, is_btscan ? ATH_BTCOEX_STOMP_ALL :
diff --git a/drivers/net/wireless/ath/ath9k/recv.c b/drivers/net/wireless/ath/ath9k/recv.c
index 7fa1e01..2c5a214 100644
--- a/drivers/net/wireless/ath/ath9k/recv.c
+++ b/drivers/net/wireless/ath/ath9k/recv.c
@@ -1841,6 +1841,7 @@ int ath_rx_tasklet(struct ath_softc *sc, int flush, bool hp)
 		else
 			rs.is_mybeacon = false;
 
+		sc->rx.num_pkts++;
 		ath_debug_stat_rx(sc, &rs);
 
 		/*
-- 
1.7.10.2

