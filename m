Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine01.qualcomm.com ([199.106.114.254]:25549 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753812Ab1L1NkF (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 28 Dec 2011 08:40:05 -0500
From: Mohammed Shafi Shajakhan <mohammed@qca.qualcomm.com>
To: "John W. Linville" <linville@tuxdriver.com>
CC: Jouni Malinen <jouni@qca.qualcomm.com>,
	<linux-wireless@vger.kernel.org>,
	Rodriguez Luis <rodrigue@qca.qualcomm.com>,
	Balasubramanian senthilkumar <senthilb@qca.qualcomm.com>,
	Vasanthakumar Thiagarajan <vthiagar@qca.qualcomm.com>,
	Rajkumar Manoharan <rmanohar@qca.qualcomm.com>,
	Vivek Natarajan <nataraja@qca.qualcomm.com>,
	Felix Fietkau <nbd@openwrt.org>, <ath9k-devel@lists.ath9k.org>,
	Mohammed Shafi Shajakhan <mohammed@qca.qualcomm.com>
Subject: [PATCH] ath9k: tx queue enable is read only for EDMA chipsets
Date: Wed, 28 Dec 2011 19:09:54 +0530
Message-ID: <1325079594-3212-1-git-send-email-mohammed@qca.qualcomm.com> (sfid-20111228_144015_843353_721FD2CB)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Mohammed Shafi Shajakhan <mohammed@qca.qualcomm.com>

for EDMA chip AR_Q_TXE (tx enable for each queue) is read only

Signed-off-by: Mohammed Shafi Shajakhan <mohammed@qca.qualcomm.com>
---
 drivers/net/wireless/ath/ath9k/beacon.c |    7 +++++--
 1 files changed, 5 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/beacon.c b/drivers/net/wireless/ath/ath9k/beacon.c
index dc5fd56..b8967e4 100644
--- a/drivers/net/wireless/ath/ath9k/beacon.c
+++ b/drivers/net/wireless/ath/ath9k/beacon.c
@@ -356,6 +356,7 @@ void ath_beacon_tasklet(unsigned long data)
 	struct ath_buf *bf = NULL;
 	struct ieee80211_vif *vif;
 	struct ath_tx_status ts;
+	bool edma = !!(ah->caps.hw_caps & ATH9K_HW_CAP_EDMA);
 	int slot;
 	u32 bfaddr, bc = 0;
 
@@ -456,10 +457,12 @@ void ath_beacon_tasklet(unsigned long data)
 	if (bfaddr != 0) {
 		/* NB: cabq traffic should already be queued and primed */
 		ath9k_hw_puttxbuf(ah, sc->beacon.beaconq, bfaddr);
-		ath9k_hw_txstart(ah, sc->beacon.beaconq);
+
+		if (!edma)
+			ath9k_hw_txstart(ah, sc->beacon.beaconq);
 
 		sc->beacon.ast_be_xmit += bc;     /* XXX per-vif? */
-		if (ah->caps.hw_caps & ATH9K_HW_CAP_EDMA) {
+		if (edma) {
 			spin_lock_bh(&sc->sc_pcu_lock);
 			ath9k_hw_txprocdesc(ah, bf->bf_desc, (void *)&ts);
 			spin_unlock_bh(&sc->sc_pcu_lock);
-- 
1.7.0.4

