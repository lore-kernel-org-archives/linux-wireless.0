Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nbd.name ([46.4.11.11]:39932 "EHLO nbd.name"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752412Ab3ATRwJ (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sun, 20 Jan 2013 12:52:09 -0500
From: Felix Fietkau <nbd@openwrt.org>
To: linux-wireless@vger.kernel.org
Cc: linville@tuxdriver.com, mcgrof@qca.qualcomm.com
Subject: [PATCH 1/8] ath9k: stop rx after tx
Date: Sun, 20 Jan 2013 18:51:52 +0100
Message-Id: <1358704319-81749-1-git-send-email-nbd@openwrt.org> (sfid-20130120_185214_147036_713E2ED9)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Completing frame transmission can fail if the rx engine is stopped
prematurely, as the hw might be waiting for an ACK from the other side.
Shutting down tx before rx might make the DMA shutdown more reliable.

Signed-off-by: Felix Fietkau <nbd@openwrt.org>
---
 drivers/net/wireless/ath/ath9k/main.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/main.c b/drivers/net/wireless/ath/ath9k/main.c
index 0fb53d6..4b96cde 100644
--- a/drivers/net/wireless/ath/ath9k/main.c
+++ b/drivers/net/wireless/ath/ath9k/main.c
@@ -196,10 +196,10 @@ static bool ath_prepare_reset(struct ath_softc *sc, bool retry_tx)
 	ath9k_debug_samp_bb_mac(sc);
 	ath9k_hw_disable_interrupts(ah);
 
-	if (!ath_stoprecv(sc))
+	if (!ath_drain_all_txq(sc, retry_tx))
 		ret = false;
 
-	if (!ath_drain_all_txq(sc, retry_tx))
+	if (!ath_stoprecv(sc))
 		ret = false;
 
 	return ret;
-- 
1.8.0.2

