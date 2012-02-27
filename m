Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nbd.name ([46.4.11.11]:36042 "EHLO nbd.name"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754811Ab2B0S6v (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 27 Feb 2012 13:58:51 -0500
From: Felix Fietkau <nbd@openwrt.org>
To: linux-wireless@vger.kernel.org
Cc: linville@tuxdriver.com, mcgrof@qca.qualcomm.com,
	rmanohar@qca.qualcomm.com
Subject: [PATCH 3.3 4/4] ath9k: fix drv_tx_last_beacon on AR9003 by processing beacon tx status
Date: Mon, 27 Feb 2012 19:58:42 +0100
Message-Id: <1330369122-60220-4-git-send-email-nbd@openwrt.org> (sfid-20120227_195855_490804_4263B696)
In-Reply-To: <1330369122-60220-3-git-send-email-nbd@openwrt.org>
References: <1330369122-60220-1-git-send-email-nbd@openwrt.org>
 <1330369122-60220-2-git-send-email-nbd@openwrt.org>
 <1330369122-60220-3-git-send-email-nbd@openwrt.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Signed-off-by: Felix Fietkau <nbd@openwrt.org>
---
 drivers/net/wireless/ath/ath9k/beacon.c |    2 +-
 drivers/net/wireless/ath/ath9k/xmit.c   |    7 +++++--
 2 files changed, 6 insertions(+), 3 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/beacon.c b/drivers/net/wireless/ath/ath9k/beacon.c
index 6d1e465..43882f9 100644
--- a/drivers/net/wireless/ath/ath9k/beacon.c
+++ b/drivers/net/wireless/ath/ath9k/beacon.c
@@ -91,7 +91,7 @@ static void ath_beacon_setup(struct ath_softc *sc, struct ath_vif *avp,
 	info.txpower = MAX_RATE_POWER;
 	info.keyix = ATH9K_TXKEYIX_INVALID;
 	info.keytype = ATH9K_KEY_TYPE_CLEAR;
-	info.flags = ATH9K_TXDESC_NOACK;
+	info.flags = ATH9K_TXDESC_NOACK | ATH9K_TXDESC_INTREQ;
 
 	info.buf_addr[0] = bf->bf_buf_addr;
 	info.buf_len[0] = roundup(skb->len, 4);
diff --git a/drivers/net/wireless/ath/ath9k/xmit.c b/drivers/net/wireless/ath/ath9k/xmit.c
index 3182408..cf5a267 100644
--- a/drivers/net/wireless/ath/ath9k/xmit.c
+++ b/drivers/net/wireless/ath/ath9k/xmit.c
@@ -2297,9 +2297,12 @@ void ath_tx_edma_tasklet(struct ath_softc *sc)
 			break;
 		}
 
-		/* Skip beacon completions */
-		if (ts.qid == sc->beacon.beaconq)
+		/* Process beacon completions separately */
+		if (ts.qid == sc->beacon.beaconq) {
+			sc->beacon.tx_processed = true;
+			sc->beacon.tx_last = !(ts.ts_status & ATH9K_TXERR_MASK);
 			continue;
+		}
 
 		txq = &sc->tx.txq[ts.qid];
 
-- 
1.7.3.2

