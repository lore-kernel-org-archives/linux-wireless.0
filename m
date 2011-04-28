Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.atheros.com ([12.19.149.2]:64860 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760527Ab1D1OYG (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 28 Apr 2011 10:24:06 -0400
Received: from mail.atheros.com ([10.10.20.108])
	by sidewinder.atheros.com
	for <linux-wireless@vger.kernel.org>; Thu, 28 Apr 2011 07:23:39 -0700
From: Mohammed Shafi Shajakhan <mshajakhan@atheros.com>
To: <linux-wireless@vger.kernel.org>
CC: <linville@tuxdriver.com>, <lrodriguez@atheros.com>,
	<Senthilkumar.Balasubramanian@Atheros.com>,
	Mohammed Shafi Shajakhan <mshajakhan@atheros.com>
Subject: [RFC/RFT 9/9] ath9k: make sure main_rssi is positive
Date: Thu, 28 Apr 2011 19:52:59 +0530
Message-ID: <1304000579-5784-10-git-send-email-mshajakhan@atheros.com> (sfid-20110428_162412_583901_6EB9D18B)
In-Reply-To: <1304000579-5784-1-git-send-email-mshajakhan@atheros.com>
References: <1304000579-5784-1-git-send-email-mshajakhan@atheros.com>
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

Signed-off-by: Mohammed Shafi Shajakhan <mshajakhan@atheros.com>
---
 drivers/net/wireless/ath/ath9k/recv.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/recv.c b/drivers/net/wireless/ath/ath9k/recv.c
index 4710830..2441085 100644
--- a/drivers/net/wireless/ath/ath9k/recv.c
+++ b/drivers/net/wireless/ath/ath9k/recv.c
@@ -1466,8 +1466,8 @@ static void ath_ant_comb_scan(struct ath_softc *sc, struct ath_rx_status *rs)
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

