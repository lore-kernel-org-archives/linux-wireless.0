Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from sg2plsmtpa01-01.prod.sin2.secureserver.net ([182.50.145.6]:45307
	"EHLO sg2plsmtpa01-01.prod.sin2.secureserver.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751379Ab2LJBxW (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sun, 9 Dec 2012 20:53:22 -0500
From: Sujith Manoharan <sujith@msujith.org>
To: John Linville <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org
Subject: [PATCH 3/8] ath9k: Add a few debug messages for PAPRD
Date: Mon, 10 Dec 2012 07:22:33 +0530
Message-Id: <1355104358-30062-3-git-send-email-sujith@msujith.org> (sfid-20121210_025339_667895_B23BB45C)
In-Reply-To: <1355104358-30062-1-git-send-email-sujith@msujith.org>
References: <1355104358-30062-1-git-send-email-sujith@msujith.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Sujith Manoharan <c_manoha@qca.qualcomm.com>

Signed-off-by: Sujith Manoharan <c_manoha@qca.qualcomm.com>
---
 drivers/net/wireless/ath/ath9k/ar9003_paprd.c |  3 +++
 drivers/net/wireless/ath/ath9k/link.c         | 10 ++++++++--
 2 files changed, 11 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/ar9003_paprd.c b/drivers/net/wireless/ath/ath9k/ar9003_paprd.c
index df9158f..4945fdf 100644
--- a/drivers/net/wireless/ath/ath9k/ar9003_paprd.c
+++ b/drivers/net/wireless/ath/ath9k/ar9003_paprd.c
@@ -169,6 +169,9 @@ static int ar9003_paprd_setup_single_table(struct ath_hw *ah)
 	REG_RMW_FIELD(ah, AR_PHY_PAPRD_HT40, AR_PHY_PAPRD_HT40_MASK,
 		      ah->paprd_ratemask_ht40);
 
+	ath_dbg(common, CALIBRATE, "PAPRD HT20 mask: 0x%x, HT40 mask: 0x%x\n",
+		ah->paprd_ratemask, ah->paprd_ratemask_ht40);
+
 	for (i = 0; i < ah->caps.max_txchains; i++) {
 		REG_RMW_FIELD(ah, ctrl0[i],
 			      AR_PHY_PAPRD_CTRL0_USE_SINGLE_TABLE_MASK, 1);
diff --git a/drivers/net/wireless/ath/ath9k/link.c b/drivers/net/wireless/ath/ath9k/link.c
index fc6b075..3c996ff 100644
--- a/drivers/net/wireless/ath/ath9k/link.c
+++ b/drivers/net/wireless/ath/ath9k/link.c
@@ -179,11 +179,14 @@ void ath_rx_poll(unsigned long data)
 static void ath_paprd_activate(struct ath_softc *sc)
 {
 	struct ath_hw *ah = sc->sc_ah;
+	struct ath_common *common = ath9k_hw_common(ah);
 	struct ath9k_hw_cal_data *caldata = ah->caldata;
 	int chain;
 
-	if (!caldata || !caldata->paprd_done)
+	if (!caldata || !caldata->paprd_done) {
+		ath_dbg(common, CALIBRATE, "Failed to activate PAPRD\n");
 		return;
+	}
 
 	ath9k_ps_wakeup(sc);
 	ar9003_paprd_enable(ah, false);
@@ -194,6 +197,7 @@ static void ath_paprd_activate(struct ath_softc *sc)
 		ar9003_paprd_populate_single_table(ah, caldata, chain);
 	}
 
+	ath_dbg(common, CALIBRATE, "Activating PAPRD\n");
 	ar9003_paprd_enable(ah, true);
 	ath9k_ps_restore(sc);
 }
@@ -253,8 +257,10 @@ void ath_paprd_calibrate(struct work_struct *work)
 	int len = 1800;
 	int ret;
 
-	if (!caldata || !caldata->paprd_packet_sent || caldata->paprd_done)
+	if (!caldata || !caldata->paprd_packet_sent || caldata->paprd_done) {
+		ath_dbg(common, CALIBRATE, "Skipping PAPRD calibration\n");
 		return;
+	}
 
 	ath9k_ps_wakeup(sc);
 
-- 
1.8.0.1

