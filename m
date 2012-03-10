Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nbd.name ([46.4.11.11]:38575 "EHLO nbd.name"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753235Ab2CJM5R (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sat, 10 Mar 2012 07:57:17 -0500
From: Felix Fietkau <nbd@openwrt.org>
To: linux-wireless@vger.kernel.org
Cc: linville@tuxdriver.com, mcgrof@qca.qualcomm.com,
	c_manoha@qca.qualcomm.com
Subject: [PATCH 3.4] ath9k: fix going to full-sleep on PS idle
Date: Sat, 10 Mar 2012 13:57:04 +0100
Message-Id: <1331384224-61867-1-git-send-email-nbd@openwrt.org> (sfid-20120310_135748_014890_A92D8247)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The check for PS_WAIT_FOR_TX_ACK was inverted, the hardware should only go
to full sleep if no tx is pending.

Reported-by: Sujith Manoharan <c_manoha@qca.qualcomm.com>
Signed-off-by: Felix Fietkau <nbd@openwrt.org>
Cc: stable@vger.kernel.org
---
 drivers/net/wireless/ath/ath9k/main.c |    8 +++++---
 1 files changed, 5 insertions(+), 3 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/main.c b/drivers/net/wireless/ath/ath9k/main.c
index cc2535c..ca25f50 100644
--- a/drivers/net/wireless/ath/ath9k/main.c
+++ b/drivers/net/wireless/ath/ath9k/main.c
@@ -118,13 +118,15 @@ void ath9k_ps_restore(struct ath_softc *sc)
 	if (--sc->ps_usecount != 0)
 		goto unlock;
 
-	if (sc->ps_idle && (sc->ps_flags & PS_WAIT_FOR_TX_ACK))
+	if (sc->ps_flags & PS_WAIT_FOR_TX_ACK)
+		goto unlock;
+
+	if (sc->ps_idle)
 		mode = ATH9K_PM_FULL_SLEEP;
 	else if (sc->ps_enabled &&
 		 !(sc->ps_flags & (PS_WAIT_FOR_BEACON |
 			      PS_WAIT_FOR_CAB |
-			      PS_WAIT_FOR_PSPOLL_DATA |
-			      PS_WAIT_FOR_TX_ACK)))
+			      PS_WAIT_FOR_PSPOLL_DATA)))
 		mode = ATH9K_PM_NETWORK_SLEEP;
 	else
 		goto unlock;
-- 
1.7.3.2

