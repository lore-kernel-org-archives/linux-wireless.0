Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine01.qualcomm.com ([199.106.114.254]:65503 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751200Ab2JHQBG (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 8 Oct 2012 12:01:06 -0400
From: Mohammed Shafi Shajakhan <mohammed@qca.qualcomm.com>
To: "John W. Linville" <linville@tuxdriver.com>
CC: <linux-wireless@vger.kernel.org>,
	Rodriguez Luis <rodrigue@qca.qualcomm.com>,
	<ath9k-devel@lists.ath9k.org>,
	Mohammed Shafi Shajakhan <mohammed@qca.qualcomm.com>
Subject: [PATCH 1/4] ath9k: Ensure we set FTP_STOMP_LOW weight when WLAN is idle
Date: Mon, 8 Oct 2012 21:30:51 +0530
Message-ID: <1349712054-3963-1-git-send-email-mohammed@qca.qualcomm.com> (sfid-20121008_180111_576614_60C629D6)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Mohammed Shafi Shajakhan <mohammed@qca.qualcomm.com>

When WLAN is idle ensure we downgrade to FTP_STOMP_LOW weight
(from STOMP_LOW) to provide more bandwidth for BT FTP profile.
WLAN's idleness can be estimated by taking into account of the
rx data packets and just ignore beacons, qos nullfunc etc.

Also update bt_wait_time even if the chip is in NETWORK SLEEP
mode. This should help BT throughput when WLAN is idle.

Signed-off-by: Mohammed Shafi Shajakhan <mohammed@qca.qualcomm.com>
---
 drivers/net/wireless/ath/ath9k/gpio.c |    2 +-
 drivers/net/wireless/ath/ath9k/recv.c |    5 ++++-
 2 files changed, 5 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/gpio.c b/drivers/net/wireless/ath/ath9k/gpio.c
index d9ed141..c722ded 100644
--- a/drivers/net/wireless/ath/ath9k/gpio.c
+++ b/drivers/net/wireless/ath/ath9k/gpio.c
@@ -204,6 +204,7 @@ static void ath_btcoex_period_timer(unsigned long data)
 
 	spin_lock_irqsave(&sc->sc_pm_lock, flags);
 	if (sc->sc_ah->power_mode == ATH9K_PM_NETWORK_SLEEP) {
+		btcoex->bt_wait_time += btcoex->btcoex_period;
 		spin_unlock_irqrestore(&sc->sc_pm_lock, flags);
 		goto skip_hw_wakeup;
 	}
@@ -214,7 +215,6 @@ static void ath_btcoex_period_timer(unsigned long data)
 		ath_detect_bt_priority(sc);
 	is_btscan = test_bit(BT_OP_SCAN, &btcoex->op_flags);
 
-	btcoex->bt_wait_time += btcoex->btcoex_period;
 	if (btcoex->bt_wait_time > ATH_BTCOEX_RX_WAIT_TIME) {
 		if (ar9003_mci_state(ah, MCI_STATE_NEED_FTP_STOMP) &&
 		    (mci->num_pan || mci->num_other_acl))
diff --git a/drivers/net/wireless/ath/ath9k/recv.c b/drivers/net/wireless/ath/ath9k/recv.c
index 83d16e7..a04028b 100644
--- a/drivers/net/wireless/ath/ath9k/recv.c
+++ b/drivers/net/wireless/ath/ath9k/recv.c
@@ -1105,7 +1105,10 @@ int ath_rx_tasklet(struct ath_softc *sc, int flush, bool hp)
 		else
 			rs.is_mybeacon = false;
 
-		sc->rx.num_pkts++;
+		if (ieee80211_is_data_present(hdr->frame_control) &&
+		    !ieee80211_is_qos_nullfunc(hdr->frame_control))
+			sc->rx.num_pkts++;
+
 		ath_debug_stat_rx(sc, &rs);
 
 		/*
-- 
1.7.0.4

