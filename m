Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine01.qualcomm.com ([199.106.114.254]:13234 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753327Ab2E2KaG (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 29 May 2012 06:30:06 -0400
From: Vivek Natarajan <nataraja@qca.qualcomm.com>
To: <linville@tuxdriver.com>
CC: <linux-wireless@vger.kernel.org>
Subject: [PATCH] ath9k: Ensure a fair beacon distribution in IBSS mode
Date: Tue, 29 May 2012 15:59:55 +0530
Message-ID: <1338287395-19695-1-git-send-email-nataraja@qca.qualcomm.com> (sfid-20120529_123031_152203_0CF2BD66)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Configure CWmin based on slot time for IBSS mode. This helps
in increasing the beacon distribution of ath9k to accepted
levels in 11a mode.

Signed-off-by: Vivek Natarajan <nataraja@qca.qualcomm.com>
---
 drivers/net/wireless/ath/ath9k/beacon.c |    5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/drivers/net/wireless/ath/ath9k/beacon.c b/drivers/net/wireless/ath/ath9k/beacon.c
index 11bc55e..70b8025 100644
--- a/drivers/net/wireless/ath/ath9k/beacon.c
+++ b/drivers/net/wireless/ath/ath9k/beacon.c
@@ -48,7 +48,10 @@ int ath_beaconq_config(struct ath_softc *sc)
 		txq = sc->tx.txq_map[WME_AC_BE];
 		ath9k_hw_get_txq_props(ah, txq->axq_qnum, &qi_be);
 		qi.tqi_aifs = qi_be.tqi_aifs;
-		qi.tqi_cwmin = 4*qi_be.tqi_cwmin;
+		if (ah->slottime == ATH9K_SLOT_TIME_20)
+			qi.tqi_cwmin = 2*qi_be.tqi_cwmin;
+		else
+			qi.tqi_cwmin = 4*qi_be.tqi_cwmin;
 		qi.tqi_cwmax = qi_be.tqi_cwmax;
 	}
 
-- 
1.7.10

