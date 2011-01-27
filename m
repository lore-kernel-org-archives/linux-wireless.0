Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.atheros.com ([12.19.149.2]:10255 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753363Ab1A0JPb (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 27 Jan 2011 04:15:31 -0500
Received: from mail.atheros.com ([10.10.20.108])
	by sidewinder.atheros.com
	for <linux-wireless@vger.kernel.org>; Thu, 27 Jan 2011 01:15:11 -0800
From: Vivek Natarajan <vnatarajan@atheros.com>
To: <linville@tuxdriver.com>
CC: <linux-wireless@vger.kernel.org>,
	Vivek Natarajan <vnatarajan@atheros.com>
Subject: [PATCH 2/5] ath9k: Fix a PLL hang issue observed with AR9485.
Date: Thu, 27 Jan 2011 14:45:08 +0530
Message-ID: <1296119711-4024-2-git-send-email-vnatarajan@atheros.com>
In-Reply-To: <1296119711-4024-1-git-send-email-vnatarajan@atheros.com>
References: <1296119711-4024-1-git-send-email-vnatarajan@atheros.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

When this PLL hang issue is seen, both Rx and Tx fail to work.
The sqsum_dvc needs to be below 2000 for a good chip. During
this issue the sqsum_dvc value is beyond 80000 and only a
full reset can solve this problem.

Signed-off-by: Vivek Natarajan <vnatarajan@atheros.com>
---
 drivers/net/wireless/ath/ath9k/ath9k.h |    1 +
 drivers/net/wireless/ath/ath9k/main.c  |    3 +++
 drivers/net/wireless/ath/ath9k/xmit.c  |   23 +++++++++++++++++++++++
 3 files changed, 27 insertions(+), 0 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/ath9k.h b/drivers/net/wireless/ath/ath9k/ath9k.h
index 6636f3c..72a1c0d 100644
--- a/drivers/net/wireless/ath/ath9k/ath9k.h
+++ b/drivers/net/wireless/ath/ath9k/ath9k.h
@@ -652,6 +652,7 @@ struct ath_softc {
 #endif
 	struct ath_beacon_config cur_beacon_conf;
 	struct delayed_work tx_complete_work;
+	struct delayed_work hw_pll_work;
 	struct ath_btcoex btcoex;
 
 	struct ath_descdma txsdma;
diff --git a/drivers/net/wireless/ath/ath9k/main.c b/drivers/net/wireless/ath/ath9k/main.c
index facff10..2029665 100644
--- a/drivers/net/wireless/ath/ath9k/main.c
+++ b/drivers/net/wireless/ath/ath9k/main.c
@@ -231,6 +231,7 @@ int ath_set_channel(struct ath_softc *sc, struct ieee80211_hw *hw,
 	cancel_work_sync(&sc->paprd_work);
 	cancel_work_sync(&sc->hw_check_work);
 	cancel_delayed_work_sync(&sc->tx_complete_work);
+	cancel_delayed_work_sync(&sc->hw_pll_work);
 
 	ath9k_ps_wakeup(sc);
 
@@ -291,6 +292,7 @@ int ath_set_channel(struct ath_softc *sc, struct ieee80211_hw *hw,
 		if (sc->sc_flags & SC_OP_BEACONS)
 			ath_beacon_config(sc, NULL);
 		ieee80211_queue_delayed_work(sc->hw, &sc->tx_complete_work, 0);
+		ieee80211_queue_delayed_work(sc->hw, &sc->hw_pll_work, HZ/2);
 		ath_start_ani(common);
 	}
 
@@ -1298,6 +1300,7 @@ static void ath9k_stop(struct ieee80211_hw *hw)
 		cancel_delayed_work_sync(&sc->ath_led_blink_work);
 
 	cancel_delayed_work_sync(&sc->tx_complete_work);
+	cancel_delayed_work_sync(&sc->hw_pll_work);
 	cancel_work_sync(&sc->paprd_work);
 	cancel_work_sync(&sc->hw_check_work);
 
diff --git a/drivers/net/wireless/ath/ath9k/xmit.c b/drivers/net/wireless/ath/ath9k/xmit.c
index dcac811..c73452d 100644
--- a/drivers/net/wireless/ath/ath9k/xmit.c
+++ b/drivers/net/wireless/ath/ath9k/xmit.c
@@ -2106,6 +2106,28 @@ static void ath_tx_processq(struct ath_softc *sc, struct ath_txq *txq)
 	}
 }
 
+static void ath_hw_pll_work(struct work_struct *work)
+{
+	struct ath_softc *sc = container_of(work, struct ath_softc,
+					    hw_pll_work.work);
+	static int count;
+
+	if (AR_SREV_9485(sc->sc_ah)) {
+		if (ar9003_get_pll_sqsum_dvc(sc->sc_ah) >= 0x40000) {
+			count++;
+
+			if (count == 3) {
+				/* Rx is hung for more than 500ms. Reset it */
+				ath_reset(sc, true);
+				count = 0;
+			}
+		} else
+			count = 0;
+
+		ieee80211_queue_delayed_work(sc->hw, &sc->hw_pll_work, HZ/5);
+	}
+}
+
 static void ath_tx_complete_poll_work(struct work_struct *work)
 {
 	struct ath_softc *sc = container_of(work, struct ath_softc,
@@ -2330,6 +2352,7 @@ int ath_tx_init(struct ath_softc *sc, int nbufs)
 	}
 
 	INIT_DELAYED_WORK(&sc->tx_complete_work, ath_tx_complete_poll_work);
+	INIT_DELAYED_WORK(&sc->hw_pll_work, ath_hw_pll_work);
 
 	if (sc->sc_ah->caps.hw_caps & ATH9K_HW_CAP_EDMA) {
 		error = ath_tx_edma_init(sc);
-- 
1.6.3.3

