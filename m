Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.atheros.com ([12.19.149.2]:31000 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759070Ab1EMPBR (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 13 May 2011 11:01:17 -0400
Received: from mail.atheros.com ([10.10.20.108])
	by sidewinder.atheros.com
	for <linux-wireless@vger.kernel.org>; Fri, 13 May 2011 08:00:48 -0700
From: Mohammed Shafi Shajakhan <mshajakhan@atheros.com>
To: <linville@tuxdriver.com>
CC: <linux-wireless@vger.kernel.org>, <lrodriguez@atheros.com>,
	<Jouni.Malinen@Atheros.com>, <Vasanth.Thiagarajan@Atheros.com>,
	<Kent.Chuang@Atheros.com>, <Ming-Yi.Lin@Atheros.com>,
	Mohammed Shafi Shajakhan <mshajakhan@atheros.com>,
	Gabriel Tseng <Gabriel.Tseng@Atheros.com>,
	Senthilkumar Balasubramanian
	<Senthilkumar.Balasubramanian@Atheros.com>
Subject: [PATCH 7/9] ath9k: Implement an API to swap main/ALT LNA's
Date: Fri, 13 May 2011 20:31:09 +0530
Message-ID: <1305298869-3542-1-git-send-email-mshajakhan@atheros.com> (sfid-20110513_170121_468977_3EB7F123)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Mohammed Shafi Shajakhan <mshajakhan@atheros.com>

for the diversity group 2(AR9485) we swap the LNA's of main/ALT antenna
based on alternate antenna's rssi average in comparision with main
antenna's rssi, while for AR9285(antenna diversity group 0)we still
follow the older method of looking at the packet count in alternate
antenna

Cc: Gabriel Tseng <Gabriel.Tseng@Atheros.com>
Cc: Senthilkumar Balasubramanian <Senthilkumar.Balasubramanian@Atheros.com>
Signed-off-by: Mohammed Shafi Shajakhan <mshajakhan@atheros.com>
---
 drivers/net/wireless/ath/ath9k/recv.c |   31 ++++++++++++++++++++++++++++++-
 1 files changed, 30 insertions(+), 1 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/recv.c b/drivers/net/wireless/ath/ath9k/recv.c
index 85e0532..47e0fc1 100644
--- a/drivers/net/wireless/ath/ath9k/recv.c
+++ b/drivers/net/wireless/ath/ath9k/recv.c
@@ -28,6 +28,33 @@ static inline bool ath_is_alt_ant_ratio_better(int alt_ratio, int maxdelta,
 		(alt_rssi_avg > main_rssi_avg + mindelta)) && (pkt_count > 50);
 }
 
+static inline bool ath_ant_div_comb_alt_check(u8 div_group, int alt_ratio,
+					int curr_main_set, int curr_alt_set,
+					int alt_rssi_avg, int main_rssi_avg)
+{
+	bool result = false;
+	switch (div_group) {
+	case 0:
+		if (alt_ratio > ATH_ANT_DIV_COMB_ALT_ANT_RATIO)
+			result = true;
+		break;
+	case 1:
+		if ((((curr_main_set == ATH_ANT_DIV_COMB_LNA2) &&
+			(curr_alt_set == ATH_ANT_DIV_COMB_LNA1) &&
+				(alt_rssi_avg >= (main_rssi_avg - 5))) ||
+			((curr_main_set == ATH_ANT_DIV_COMB_LNA1) &&
+			(curr_alt_set == ATH_ANT_DIV_COMB_LNA2) &&
+				(alt_rssi_avg >= (main_rssi_avg - 2)))) &&
+							(alt_rssi_avg >= 4))
+			result = true;
+		else
+			result = false;
+		break;
+	}
+
+	return result;
+}
+
 static inline bool ath9k_check_auto_sleep(struct ath_softc *sc)
 {
 	return sc->ps_enabled &&
@@ -1413,7 +1440,9 @@ static void ath_ant_comb_scan(struct ath_softc *sc, struct ath_rx_status *rs)
 	}
 
 	if (!antcomb->scan) {
-		if (alt_ratio > ATH_ANT_DIV_COMB_ALT_ANT_RATIO) {
+		if (ath_ant_div_comb_alt_check(div_ant_conf.div_group,
+					alt_ratio, curr_main_set, curr_alt_set,
+					alt_rssi_avg, main_rssi_avg)) {
 			if (curr_alt_set == ATH_ANT_DIV_COMB_LNA2) {
 				/* Switch main and alt LNA */
 				div_ant_conf.main_lna_conf =
-- 
1.7.0.4

