Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine01.qualcomm.com ([199.106.114.254]:21895 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752552Ab1K2PAo (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 29 Nov 2011 10:00:44 -0500
Cc: Jouni Malinen <jouni@qca.qualcomm.com>,
	<linux-wireless@vger.kernel.org>,
	Rodriguez Luis <rodrigue@qca.qualcomm.com>,
	Balasubramanian senthilkumar <senthilb@qca.qualcomm.com>,
	Vasanthakumar Thiagarajan <vthiagar@qca.qualcomm.com>,
	Rajkumar Manoharan <rmanohar@qca.qualcomm.com>,
	Vivek Natarajan <nataraja@qualcomm.com>,
	<ath9k-devel@lists.ath9k.org>,
	Mohammed Shafi Shajakhan <mohammed@qca.qualcomm.com>
From: Mohammed Shafi Shajakhan <mohammed@qca.qualcomm.com>
To: "John W. Linville" <linville@tuxdriver.com>
Subject: [PATCH] ath9k: change the default antenna settings based on diversity
Date: Tue, 29 Nov 2011 20:30:35 +0530
Message-ID: <1322578835-19344-1-git-send-email-mohammed@qca.qualcomm.com> (sfid-20111129_160047_971966_499C34AA)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Mohammed Shafi Shajakhan <mohammed@qca.qualcomm.com>

change the AR_DEF_ANTENNA register settings i.e setting default antenna
setting only for antenna diversity enabled chipsets. no point in
doing this for MIMO chipsets

Signed-off-by: Mohammed Shafi Shajakhan <mohammed@qca.qualcomm.com>
---
 drivers/net/wireless/ath/ath9k/recv.c |   23 ++++++++++++++---------
 1 files changed, 14 insertions(+), 9 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/recv.c b/drivers/net/wireless/ath/ath9k/recv.c
index 4c8e296..b1b0ec7 100644
--- a/drivers/net/wireless/ath/ath9k/recv.c
+++ b/drivers/net/wireless/ath/ath9k/recv.c
@@ -1923,15 +1923,20 @@ int ath_rx_tasklet(struct ath_softc *sc, int flush, bool hp)
 			skb = hdr_skb;
 		}
 
-		/*
-		 * change the default rx antenna if rx diversity chooses the
-		 * other antenna 3 times in a row.
-		 */
-		if (sc->rx.defant != rs.rs_antenna) {
-			if (++sc->rx.rxotherant >= 3)
-				ath_setdefantenna(sc, rs.rs_antenna);
-		} else {
-			sc->rx.rxotherant = 0;
+
+		if (ah->caps.hw_caps & ATH9K_HW_CAP_ANT_DIV_COMB) {
+
+			/*
+			 * change the default rx antenna if rx diversity
+			 * chooses the other antenna 3 times in a row.
+			 */
+			if (sc->rx.defant != rs.rs_antenna) {
+				if (++sc->rx.rxotherant >= 3)
+					ath_setdefantenna(sc, rs.rs_antenna);
+			} else {
+				sc->rx.rxotherant = 0;
+			}
+
 		}
 
 		if (rxs->flag & RX_FLAG_MMIC_STRIPPED)
-- 
1.7.0.4

