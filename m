Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.atheros.com ([12.36.123.2]:31075 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754793Ab0FXLJc (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 24 Jun 2010 07:09:32 -0400
Received: from mail.atheros.com ([10.10.20.108])
	by sidewinder.atheros.com
	for <linux-wireless@vger.kernel.org>; Thu, 24 Jun 2010 04:09:32 -0700
From: Vasanthakumar Thiagarajan <vasanth@atheros.com>
To: <linville@tuxdriver.com>
CC: <linux-wireless@vger.kernel.org>
Subject: [PATCH] ath9k: Wakeup the chip in an appropriate place in ath_paprd_calibrate()
Date: Thu, 24 Jun 2010 04:09:27 -0700
Message-ID: <1277377767-23788-1-git-send-email-vasanth@atheros.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Move ath9k_ps_wakeup() down just before accessing hw registers.

Signed-off-by: Vasanthakumar Thiagarajan <vasanth@atheros.com>
---
 drivers/net/wireless/ath/ath9k/main.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/main.c b/drivers/net/wireless/ath/ath9k/main.c
index 6d57877..efbf535 100644
--- a/drivers/net/wireless/ath/ath9k/main.c
+++ b/drivers/net/wireless/ath/ath9k/main.c
@@ -268,7 +268,6 @@ void ath_paprd_calibrate(struct work_struct *work)
 	int time_left;
 	int i;
 
-	ath9k_ps_wakeup(sc);
 	skb = alloc_skb(len, GFP_KERNEL);
 	if (!skb)
 		return;
@@ -289,6 +288,7 @@ void ath_paprd_calibrate(struct work_struct *work)
 	qnum = sc->tx.hwq_map[WME_AC_BE];
 	txctl.txq = &sc->tx.txq[qnum];
 
+	ath9k_ps_wakeup(sc);
 	ar9003_paprd_init_table(ah);
 	for (chain = 0; chain < AR9300_MAX_CHAINS; chain++) {
 		if (!(ah->caps.tx_chainmask & BIT(chain)))
-- 
1.7.0.4

