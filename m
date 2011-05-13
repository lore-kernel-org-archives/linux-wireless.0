Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.atheros.com ([12.19.149.2]:31037 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759399Ab1EMPBt (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 13 May 2011 11:01:49 -0400
Received: from mail.atheros.com ([10.10.20.108])
	by sidewinder.atheros.com
	for <linux-wireless@vger.kernel.org>; Fri, 13 May 2011 08:01:20 -0700
From: Mohammed Shafi Shajakhan <mshajakhan@atheros.com>
To: <linville@tuxdriver.com>
CC: <linux-wireless@vger.kernel.org>, <lrodriguez@atheros.com>,
	<Jouni.Malinen@Atheros.com>, <Vasanth.Thiagarajan@Atheros.com>,
	<Kent.Chuang@Atheros.com>, <Ming-Yi.Lin@Atheros.com>,
	Mohammed Shafi Shajakhan <mshajakhan@atheros.com>,
	Gabriel Tseng <Gabriel.Tseng@Atheros.com>,
	Senthilkumar Balasubramanian
	<Senthilkumar.Balasubramanian@Atheros.com>
Subject: [PATCH 9/9] ath9k: make sure main_rssi is positive
Date: Fri, 13 May 2011 20:31:40 +0530
Message-ID: <1305298900-3620-1-git-send-email-mshajakhan@atheros.com> (sfid-20110513_170153_413778_164CAF0A)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Mohammed Shafi Shajakhan <mshajakhan@atheros.com>

some times the rssi control descriptor for the main antenna may be
negative like that of alternate antenna, hence before  incrementing
packet counts/rssi of main/alternate antenna make sure both main_rssi
and alt_rssi are positive only. this avoids wrong selection of antenna
due to diversity

Cc: Gabriel Tseng <Gabriel.Tseng@Atheros.com>
Cc: Senthilkumar Balasubramanian <Senthilkumar.Balasubramanian@Atheros.com>
Signed-off-by: Mohammed Shafi Shajakhan <mshajakhan@atheros.com>
---
 drivers/net/wireless/ath/ath9k/recv.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/recv.c b/drivers/net/wireless/ath/ath9k/recv.c
index 2fecfcb..4f52e04 100644
--- a/drivers/net/wireless/ath/ath9k/recv.c
+++ b/drivers/net/wireless/ath/ath9k/recv.c
@@ -1468,8 +1468,8 @@ static void ath_ant_comb_scan(struct ath_softc *sc, struct ath_rx_status *rs)
 	main_ant_conf = (rs->rs_rssi_ctl2 >> ATH_ANT_RX_MAIN_SHIFT) &
 			 ATH_ANT_RX_MASK;
 
-	/* Record packet only when alt_rssi is positive */
-	if (alt_rssi > 0) {
+	/* Record packet only when both main_rssi and  alt_rssi is positive */
+	if (main_rssi > 0 && alt_rssi > 0) {
 		antcomb->total_pkt_count++;
 		antcomb->main_total_rssi += main_rssi;
 		antcomb->alt_total_rssi  += alt_rssi;
-- 
1.7.0.4

