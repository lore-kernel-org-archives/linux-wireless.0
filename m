Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.atheros.com ([12.19.149.2]:59051 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S935420Ab1ETMWi (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 20 May 2011 08:22:38 -0400
Received: from mail.atheros.com ([10.234.20.107])
	by sidewinder.atheros.com
	for <linux-wireless@vger.kernel.org>; Fri, 20 May 2011 05:22:07 -0700
From: Rajkumar Manoharan <rmanoharan@atheros.com>
To: <linville@tuxdriver.com>
CC: <linux-wireless@vger.kernel.org>,
	Rajkumar Manoharan <rmanoharan@atheros.com>,
	<stable@kernel.org>
Subject: [PATCH 1/6] ath9k: Reset chip on baseband hang
Date: Fri, 20 May 2011 17:52:10 +0530
Message-ID: <1305894135-14036-1-git-send-email-rmanoharan@atheros.com> (sfid-20110520_142243_160387_0F36CA96)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Resetting hardware helps to recover from baseband
hang/panic for AR9003 based chips.

Cc: stable@kernel.org
Signed-off-by: Rajkumar Manoharan <rmanoharan@atheros.com>
---
 drivers/net/wireless/ath/ath9k/main.c |    4 +++-
 1 files changed, 3 insertions(+), 1 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/main.c b/drivers/net/wireless/ath/ath9k/main.c
index a198ee3..2ca351f 100644
--- a/drivers/net/wireless/ath/ath9k/main.c
+++ b/drivers/net/wireless/ath/ath9k/main.c
@@ -670,7 +670,8 @@ void ath9k_tasklet(unsigned long data)
 	u32 status = sc->intrstatus;
 	u32 rxmask;
 
-	if (status & ATH9K_INT_FATAL) {
+	if ((status & ATH9K_INT_FATAL) ||
+	    (status & ATH9K_INT_BB_WATCHDOG)) {
 		ath_reset(sc, true);
 		return;
 	}
@@ -737,6 +738,7 @@ irqreturn_t ath_isr(int irq, void *dev)
 {
 #define SCHED_INTR (				\
 		ATH9K_INT_FATAL |		\
+		ATH9K_INT_BB_WATCHDOG |		\
 		ATH9K_INT_RXORN |		\
 		ATH9K_INT_RXEOL |		\
 		ATH9K_INT_RX |			\
-- 
1.7.5.1

