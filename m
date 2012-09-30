Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine01.qualcomm.com ([199.106.114.254]:52842 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752140Ab2I3DdK (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 29 Sep 2012 23:33:10 -0400
From: Sujith Manoharan <c_manoha@qti.qualcomm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Message-ID: <20583.48512.616654.53958@gargle.gargle.HOWL> (sfid-20120930_053352_637386_2C816769)
Date: Sun, 30 Sep 2012 09:03:20 +0530
To: <linville@tuxdriver.com>
CC: <linux-wireless@vger.kernel.org>
Subject: [PATCH 1/2] ath9k: Use a helper routine for MCI/FTP tuning
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Signed-off-by: Sujith Manoharan <c_manoha@qca.qualcomm.com>
---
 drivers/net/wireless/ath/ath9k/gpio.c | 33 +++++++++++++++++++++------------
 1 file changed, 21 insertions(+), 12 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/gpio.c b/drivers/net/wireless/ath/ath9k/gpio.c
index d9ed141..334c98d 100644
--- a/drivers/net/wireless/ath/ath9k/gpio.c
+++ b/drivers/net/wireless/ath/ath9k/gpio.c
@@ -187,6 +187,25 @@ static void ath9k_gen_timer_stop(struct ath_hw *ah, struct ath_gen_timer *timer)
 	}
 }
 
+static void ath_mci_ftp_adjust(struct ath_softc *sc)
+{
+	struct ath_btcoex *btcoex = &sc->btcoex;
+	struct ath_mci_profile *mci = &btcoex->mci;
+	struct ath_hw *ah = sc->sc_ah;
+
+	btcoex->bt_wait_time += btcoex->btcoex_period;
+	if (btcoex->bt_wait_time > ATH_BTCOEX_RX_WAIT_TIME) {
+		if (ar9003_mci_state(ah, MCI_STATE_NEED_FTP_STOMP) &&
+		    (mci->num_pan || mci->num_other_acl))
+			ah->btcoex_hw.mci.stomp_ftp =
+				(sc->rx.num_pkts < ATH_BTCOEX_STOMP_FTP_THRESH);
+		else
+			ah->btcoex_hw.mci.stomp_ftp = false;
+		btcoex->bt_wait_time = 0;
+		sc->rx.num_pkts = 0;
+	}
+}
+
 /*
  * This is the master bt coex timer which runs for every
  * 45ms, bt traffic will be given priority during 55% of this
@@ -197,7 +216,6 @@ static void ath_btcoex_period_timer(unsigned long data)
 	struct ath_softc *sc = (struct ath_softc *) data;
 	struct ath_hw *ah = sc->sc_ah;
 	struct ath_btcoex *btcoex = &sc->btcoex;
-	struct ath_mci_profile *mci = &btcoex->mci;
 	u32 timer_period;
 	bool is_btscan;
 	unsigned long flags;
@@ -214,17 +232,8 @@ static void ath_btcoex_period_timer(unsigned long data)
 		ath_detect_bt_priority(sc);
 	is_btscan = test_bit(BT_OP_SCAN, &btcoex->op_flags);
 
-	btcoex->bt_wait_time += btcoex->btcoex_period;
-	if (btcoex->bt_wait_time > ATH_BTCOEX_RX_WAIT_TIME) {
-		if (ar9003_mci_state(ah, MCI_STATE_NEED_FTP_STOMP) &&
-		    (mci->num_pan || mci->num_other_acl))
-			ah->btcoex_hw.mci.stomp_ftp =
-				(sc->rx.num_pkts < ATH_BTCOEX_STOMP_FTP_THRESH);
-		else
-			ah->btcoex_hw.mci.stomp_ftp = false;
-		btcoex->bt_wait_time = 0;
-		sc->rx.num_pkts = 0;
-	}
+	if (ah->caps.hw_caps & ATH9K_HW_CAP_MCI)
+		ath_mci_ftp_adjust(sc);
 
 	spin_lock_bh(&btcoex->btcoex_lock);
 
-- 
1.7.12.1

