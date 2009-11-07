Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([18.85.46.34]:56213 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752863AbZKGUTI (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 7 Nov 2009 15:19:08 -0500
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org, devel@linuxdriverproject.org,
	mcgrof@gmail.com, "Luis R. Rodriguez" <lrodriguez@atheros.com>
Subject: [PATCH 16/29] ath9k: move qual processing into a helper
Date: Sat,  7 Nov 2009 15:18:53 -0500
Message-Id: <1257625146-17971-17-git-send-email-lrodriguez@atheros.com>
In-Reply-To: <1257625146-17971-1-git-send-email-lrodriguez@atheros.com>
References: <1257625146-17971-1-git-send-email-lrodriguez@atheros.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This moves the qual computing into a small helper,
ath9k_compute_qual()

Signed-off-by: Luis R. Rodriguez <lrodriguez@atheros.com>
---
 drivers/net/wireless/ath/ath9k/recv.c |   74 ++++++++++++++++++--------------
 1 files changed, 42 insertions(+), 32 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/recv.c b/drivers/net/wireless/ath/ath9k/recv.c
index 9eae946..d357b9a 100644
--- a/drivers/net/wireless/ath/ath9k/recv.c
+++ b/drivers/net/wireless/ath/ath9k/recv.c
@@ -190,6 +190,47 @@ static u8 ath9k_process_rate(struct ath_common *common,
 }
 
 /*
+ * Theory for reporting quality:
+ *
+ * At a hardware RSSI of 45 you will be able to use MCS 7  reliably.
+ * At a hardware RSSI of 45 you will be able to use MCS 15 reliably.
+ * At a hardware RSSI of 35 you should be able use 54 Mbps reliably.
+ *
+ * MCS 7  is the highets MCS index usable by a 1-stream device.
+ * MCS 15 is the highest MCS index usable by a 2-stream device.
+ *
+ * All ath9k devices are either 1-stream or 2-stream.
+ *
+ * How many bars you see is derived from the qual reporting.
+ *
+ * A more elaborate scheme can be used here but it requires tables
+ * of SNR/throughput for each possible mode used. For the MCS table
+ * you can refer to the wireless wiki:
+ *
+ * http://wireless.kernel.org/en/developers/Documentation/ieee80211/802.11n
+ *
+ */
+static int ath9k_compute_qual(struct ieee80211_hw *hw,
+			      struct ath_rx_status *rx_stats)
+{
+	int qual;
+
+	if (conf_is_ht(&hw->conf))
+		qual =  rx_stats->rs_rssi * 100 / 45;
+	else
+		qual =  rx_stats->rs_rssi * 100 / 35;
+
+	/*
+	 * rssi can be more than 45 though, anything above that
+	 * should be considered at 100%
+	 */
+	if (qual > 100)
+		qual = 100;
+
+	return qual;
+}
+
+/*
  * For Decrypt or Demic errors, we only mark packet status here and always push
  * up the frame up to let mac80211 handle the actual error case, be it no
  * decryption key or real decryption error. This let us keep statistics there.
@@ -247,38 +288,7 @@ static int ath_rx_prepare(struct ath_common *common,
 	rx_status->noise = common->ani.noise_floor;
 	rx_status->signal = ATH_DEFAULT_NOISE_FLOOR + rx_stats->rs_rssi;
 	rx_status->antenna = rx_stats->rs_antenna;
-
-	/*
-	 * Theory for reporting quality:
-	 *
-	 * At a hardware RSSI of 45 you will be able to use MCS 7  reliably.
-	 * At a hardware RSSI of 45 you will be able to use MCS 15 reliably.
-	 * At a hardware RSSI of 35 you should be able use 54 Mbps reliably.
-	 *
-	 * MCS 7  is the highets MCS index usable by a 1-stream device.
-	 * MCS 15 is the highest MCS index usable by a 2-stream device.
-	 *
-	 * All ath9k devices are either 1-stream or 2-stream.
-	 *
-	 * How many bars you see is derived from the qual reporting.
-	 *
-	 * A more elaborate scheme can be used here but it requires tables
-	 * of SNR/throughput for each possible mode used. For the MCS table
-	 * you can refer to the wireless wiki:
-	 *
-	 * http://wireless.kernel.org/en/developers/Documentation/ieee80211/802.11n
-	 *
-	 */
-	if (conf_is_ht(&hw->conf))
-		rx_status->qual =  rx_stats->rs_rssi * 100 / 45;
-	else
-		rx_status->qual =  rx_stats->rs_rssi * 100 / 35;
-
-	/* rssi can be more than 45 though, anything above that
-	 * should be considered at 100% */
-	if (rx_status->qual > 100)
-		rx_status->qual = 100;
-
+	rx_status->qual = ath9k_compute_qual(hw, rx_stats);
 	rx_status->flag |= RX_FLAG_TSFT;
 
 	return 1;
-- 
1.6.5.2.143.g8cc62

