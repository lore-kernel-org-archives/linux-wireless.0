Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.atheros.com ([12.36.123.2]:34317 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758678AbZC3KF1 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 30 Mar 2009 06:05:27 -0400
Received: from mail.atheros.com ([10.10.20.105])
	by sidewinder.atheros.com
	for <linux-wireless@vger.kernel.org>; Mon, 30 Mar 2009 03:05:26 -0700
From: Sujith <Sujith.Manoharan@atheros.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Message-ID: <18896.39016.45681.650011@gargle.gargle.HOWL> (sfid-20090330_120543_042750_13F5FE32)
Date: Mon, 30 Mar 2009 15:31:12 +0530
To: <linville@tuxdriver.com>
CC: <linux-wireless@vger.kernel.org>, <Jouni.Malinen@Atheros.com>,
	<Luis.Rodriguez@Atheros.com>
Subject: [PATCH 02/17] ath9k: Remove redundant chainmask check
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

We get the valid chainmasks on HW attach, checking
it again during reset is redundant. This patch removes the check.

Signed-off-by: Sujith <Sujith.Manoharan@atheros.com>
---
 drivers/net/wireless/ath9k/hw.c |    8 --------
 1 files changed, 0 insertions(+), 8 deletions(-)

diff --git a/drivers/net/wireless/ath9k/hw.c b/drivers/net/wireless/ath9k/hw.c
index 13d8c2a..22ef93f 100644
--- a/drivers/net/wireless/ath9k/hw.c
+++ b/drivers/net/wireless/ath9k/hw.c
@@ -2189,14 +2189,6 @@ int ath9k_hw_reset(struct ath_hw *ah, struct ath9k_channel *chan,
 	ah->txchainmask = sc->tx_chainmask;
 	ah->rxchainmask = sc->rx_chainmask;
 
-	if (AR_SREV_9285(ah)) {
-		ah->txchainmask &= 0x1;
-		ah->rxchainmask &= 0x1;
-	} else if (AR_SREV_9280(ah)) {
-		ah->txchainmask &= 0x3;
-		ah->rxchainmask &= 0x3;
-	}
-
 	if (!ath9k_hw_setpower(ah, ATH9K_PM_AWAKE))
 		return -EIO;
 
-- 
1.6.2.1

