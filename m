Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine01.qualcomm.com ([199.106.114.254]:21743 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752827Ab2DJG44 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 10 Apr 2012 02:56:56 -0400
From: Sujith Manoharan <c_manoha@qca.qualcomm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Message-ID: <20355.55691.874038.636662@gargle.gargle.HOWL> (sfid-20120410_085700_576680_06B3E9C3)
Date: Tue, 10 Apr 2012 12:26:11 +0530
To: <linville@tuxdriver.com>
CC: <linux-wireless@vger.kernel.org>
Subject: [PATCH] Revert "ath9k: fix going to full-sleep on PS idle"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This reverts commit c1afdaff90538ef085b756454f12b29575411214.

Users have reported connection failures in 3.3.1 and suspend/resume
failures in 3.4-rcX. Revert this commit for now - PS IDLE can be
fixed in a clean manner later on.

Cc: stable@vger.kernel.org
Signed-off-by: Sujith Manoharan <c_manoha@qca.qualcomm.com>
---
 drivers/net/wireless/ath/ath9k/main.c |    8 +++-----
 1 file changed, 3 insertions(+), 5 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/main.c b/drivers/net/wireless/ath/ath9k/main.c
index 5697dee..ba5af8e 100644
--- a/drivers/net/wireless/ath/ath9k/main.c
+++ b/drivers/net/wireless/ath/ath9k/main.c
@@ -118,15 +118,13 @@ void ath9k_ps_restore(struct ath_softc *sc)
 	if (--sc->ps_usecount != 0)
 		goto unlock;
 
-	if (sc->ps_flags & PS_WAIT_FOR_TX_ACK)
-		goto unlock;
-
-	if (sc->ps_idle)
+	if (sc->ps_idle && (sc->ps_flags & PS_WAIT_FOR_TX_ACK))
 		mode = ATH9K_PM_FULL_SLEEP;
 	else if (sc->ps_enabled &&
 		 !(sc->ps_flags & (PS_WAIT_FOR_BEACON |
 			      PS_WAIT_FOR_CAB |
-			      PS_WAIT_FOR_PSPOLL_DATA)))
+			      PS_WAIT_FOR_PSPOLL_DATA |
+			      PS_WAIT_FOR_TX_ACK)))
 		mode = ATH9K_PM_NETWORK_SLEEP;
 	else
 		goto unlock;
-- 
1.7.10

