Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from sabertooth02.qualcomm.com ([65.197.215.38]:16392 "EHLO
	sabertooth02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752710Ab2KTNAa (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 20 Nov 2012 08:00:30 -0500
From: Rajkumar Manoharan <rmanohar@qca.qualcomm.com>
To: <linville@tuxdriver.com>
CC: <linux-wireless@vger.kernel.org>,
	Rajkumar Manoharan <rmanohar@qca.qualcomm.com>
Subject: [PATCH 3/3] ath9k: stomp audio profiles on weak signal strength
Date: Tue, 20 Nov 2012 18:30:01 +0530
Message-ID: <1353416401-5328-3-git-send-email-rmanohar@qca.qualcomm.com> (sfid-20121120_140038_033683_6B9D0B4A)
In-Reply-To: <1353416401-5328-1-git-send-email-rmanohar@qca.qualcomm.com>
References: <1353416401-5328-1-git-send-email-rmanohar@qca.qualcomm.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On lower WLAN signal strength, WLAN downlink traffic might suffer
from retransmissions. At the mean time, playing SCO/A2DP profiles
is affecting WLAN stability. In such scenario, by stomping SCO/A2DP
BT traffic completely for a BTCOEX period, gives WLAN traffic an
oppertunity to recover PHY rate. It also improves WLAN stability at
lower RSSI without sacificing BT traffic.

Signed-off-by: Rajkumar Manoharan <rmanohar@qca.qualcomm.com>
---
 drivers/net/wireless/ath/ath9k/ath9k.h  |  1 +
 drivers/net/wireless/ath/ath9k/btcoex.c |  1 +
 drivers/net/wireless/ath/ath9k/btcoex.h |  1 +
 drivers/net/wireless/ath/ath9k/gpio.c   |  5 ++++-
 drivers/net/wireless/ath/ath9k/mci.c    | 18 ++++++++++++++++++
 5 files changed, 25 insertions(+), 1 deletion(-)

diff --git a/drivers/net/wireless/ath/ath9k/ath9k.h b/drivers/net/wireless/ath/ath9k/ath9k.h
index 9a93d2b..04fa5f3 100644
--- a/drivers/net/wireless/ath/ath9k/ath9k.h
+++ b/drivers/net/wireless/ath/ath9k/ath9k.h
@@ -488,6 +488,7 @@ struct ath_btcoex {
 	int rssi_count;
 	struct ath_gen_timer *no_stomp_timer; /* Timer for no BT stomping */
 	struct ath_mci_profile mci;
+	u8 stomp_audio;
 };
 
 #ifdef CONFIG_ATH9K_BTCOEX_SUPPORT
diff --git a/drivers/net/wireless/ath/ath9k/btcoex.c b/drivers/net/wireless/ath/ath9k/btcoex.c
index c90e9bc..9963b0b 100644
--- a/drivers/net/wireless/ath/ath9k/btcoex.c
+++ b/drivers/net/wireless/ath/ath9k/btcoex.c
@@ -49,6 +49,7 @@ static const u32 mci_wlan_weights[ATH_BTCOEX_STOMP_MAX]
 	{ 0x01017d01, 0x3b3b3b01, 0x3b3b3b01, 0x3b3b3b3b }, /* STOMP_LOW */
 	{ 0x01017d01, 0x01010101, 0x01010101, 0x01010101 }, /* STOMP_NONE */
 	{ 0x01017d01, 0x013b0101, 0x3b3b0101, 0x3b3b013b }, /* STOMP_LOW_FTP */
+	{ 0xffffff01, 0xffffffff, 0xffffff01, 0xffffffff }, /* STOMP_AUDIO */
 };
 
 void ath9k_hw_init_btcoex_hw(struct ath_hw *ah, int qnum)
diff --git a/drivers/net/wireless/ath/ath9k/btcoex.h b/drivers/net/wireless/ath/ath9k/btcoex.h
index 2f84ab2..6de26ea 100644
--- a/drivers/net/wireless/ath/ath9k/btcoex.h
+++ b/drivers/net/wireless/ath/ath9k/btcoex.h
@@ -50,6 +50,7 @@ enum ath_stomp_type {
 	ATH_BTCOEX_STOMP_LOW,
 	ATH_BTCOEX_STOMP_NONE,
 	ATH_BTCOEX_STOMP_LOW_FTP,
+	ATH_BTCOEX_STOMP_AUDIO,
 	ATH_BTCOEX_STOMP_MAX
 };
 
diff --git a/drivers/net/wireless/ath/ath9k/gpio.c b/drivers/net/wireless/ath/ath9k/gpio.c
index 4236df8..7b39cc1 100644
--- a/drivers/net/wireless/ath/ath9k/gpio.c
+++ b/drivers/net/wireless/ath/ath9k/gpio.c
@@ -247,6 +247,9 @@ static void ath_btcoex_period_timer(unsigned long data)
 			stomp_type = ATH_BTCOEX_STOMP_ALL;
 			timer_period = btcoex->btscan_no_stomp;
 		}
+	} else if (btcoex->stomp_audio >= 5) {
+		stomp_type = ATH_BTCOEX_STOMP_AUDIO;
+		btcoex->stomp_audio = 0;
 	}
 
 	ath9k_hw_btcoex_bt_stomp(ah, stomp_type);
@@ -295,7 +298,7 @@ static void ath_btcoex_no_stomp_timer(void *arg)
 	    (!(ah->caps.hw_caps & ATH9K_HW_CAP_MCI) &&
 	     test_bit(BT_OP_SCAN, &btcoex->op_flags)))
 		ath9k_hw_btcoex_bt_stomp(ah, ATH_BTCOEX_STOMP_NONE);
-	 else if (btcoex->bt_stomp_type == ATH_BTCOEX_STOMP_ALL)
+	else if (btcoex->bt_stomp_type == ATH_BTCOEX_STOMP_ALL)
 		ath9k_hw_btcoex_bt_stomp(ah, ATH_BTCOEX_STOMP_LOW);
 
 	ath9k_hw_btcoex_enable(ah);
diff --git a/drivers/net/wireless/ath/ath9k/mci.c b/drivers/net/wireless/ath/ath9k/mci.c
index ece192d..706378e 100644
--- a/drivers/net/wireless/ath/ath9k/mci.c
+++ b/drivers/net/wireless/ath/ath9k/mci.c
@@ -729,12 +729,30 @@ void ath9k_mci_set_txpower(struct ath_softc *sc, bool setchannel,
 		ath9k_hw_set_txpowerlimit(ah, sc->config.txpowlimit, false);
 }
 
+static void ath9k_mci_stomp_audio(struct ath_softc *sc)
+{
+	struct ath_hw *ah = sc->sc_ah;
+	struct ath_btcoex *btcoex = &sc->btcoex;
+	struct ath_mci_profile *mci = &btcoex->mci;
+
+	if (!mci->num_sco && !mci->num_a2dp)
+		return;
+
+	if (ah->stats.avgbrssi > 25) {
+		btcoex->stomp_audio = 0;
+		return;
+	}
+
+	btcoex->stomp_audio++;
+}
 void ath9k_mci_update_rssi(struct ath_softc *sc)
 {
 	struct ath_hw *ah = sc->sc_ah;
 	struct ath_btcoex *btcoex = &sc->btcoex;
 	struct ath9k_hw_mci *mci_hw = &sc->sc_ah->btcoex_hw.mci;
 
+	ath9k_mci_stomp_audio(sc);
+
 	if (!(mci_hw->config & ATH_MCI_CONFIG_CONCUR_TX))
 		return;
 
-- 
1.8.0

