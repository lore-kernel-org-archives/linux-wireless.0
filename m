Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine01.qualcomm.com ([199.106.114.254]:49778 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751587Ab2ILPs4 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 12 Sep 2012 11:48:56 -0400
From: Mohammed Shafi Shajakhan <mohammed@qca.qualcomm.com>
To: "John W. Linville" <linville@tuxdriver.com>
CC: <linux-wireless@vger.kernel.org>,
	Rodriguez Luis <rodrigue@qca.qualcomm.com>,
	<ath9k-devel@lists.ath9k.org>,
	Mohammed Shafi Shajakhan <mohammed@qca.qualcomm.com>
Subject: [RFC] ath9k: Ensure we set FTP_STOMP_LOW weight when WLAN is idle
Date: Wed, 12 Sep 2012 21:18:30 +0530
Message-ID: <1347464910-9536-1-git-send-email-mohammed@qca.qualcomm.com> (sfid-20120912_174900_501170_58FF7DF7)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Mohammed Shafi Shajakhan <mohammed@qca.qualcomm.com>

We WLAN is idle we can some better bandwidth to FTP by
setting STOMP_LOW_FTP where stomping the FTP BT is pretty
much reduced when compared to setting STOMP_LOW weight.
we calculate WLAN is idle by taking into account of the
rx data packets, so ensure that we take into account
of data packets(ignore beacons).

Also update bt_wait_time even if the chip is NETWORK SLEEP
mode. This should help BT throughput when WLAN is idle,
when everything else is fine :)

Signed-off-by: Mohammed Shafi Shajakhan <mohammed@qca.qualcomm.com>
---
 drivers/net/wireless/ath/ath9k/gpio.c |    2 +-
 drivers/net/wireless/ath/ath9k/recv.c |    5 ++++-
 2 files changed, 5 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/gpio.c b/drivers/net/wireless/ath/ath9k/gpio.c
index 45f2422..09d517e 100644
--- a/drivers/net/wireless/ath/ath9k/gpio.c
+++ b/drivers/net/wireless/ath/ath9k/gpio.c
@@ -198,6 +198,7 @@ static void ath_btcoex_period_timer(unsigned long data)
 
 	spin_lock_irqsave(&sc->sc_pm_lock, flags);
 	if (sc->sc_ah->power_mode == ATH9K_PM_NETWORK_SLEEP) {
+		btcoex->bt_wait_time += btcoex->btcoex_period;
 		spin_unlock_irqrestore(&sc->sc_pm_lock, flags);
 		goto skip_hw_wakeup;
 	}
@@ -208,7 +209,6 @@ static void ath_btcoex_period_timer(unsigned long data)
 		ath_detect_bt_priority(sc);
 	is_btscan = test_bit(BT_OP_SCAN, &btcoex->op_flags);
 
-	btcoex->bt_wait_time += btcoex->btcoex_period;
 	if (btcoex->bt_wait_time > ATH_BTCOEX_RX_WAIT_TIME) {
 		if (ar9003_mci_state(ah, MCI_STATE_NEED_FTP_STOMP) &&
 		    (mci->num_pan || mci->num_other_acl))
diff --git a/drivers/net/wireless/ath/ath9k/recv.c b/drivers/net/wireless/ath/ath9k/recv.c
index 4480c0c..9b2a8cc 100644
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

