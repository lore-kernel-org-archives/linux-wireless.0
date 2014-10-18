Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from static.88-198-24-112.clients.your-server.de ([88.198.24.112]:49143
	"EHLO nbd.name" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751465AbaJRRCR (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 18 Oct 2014 13:02:17 -0400
From: Felix Fietkau <nbd@openwrt.org>
To: linux-wireless@vger.kernel.org
Cc: linville@tuxdriver.com
Subject: [PATCH 03/10] ath9k: fix processing RXORN interrupts
Date: Sat, 18 Oct 2014 19:02:05 +0200
Message-Id: <1413651732-69783-3-git-send-email-nbd@openwrt.org> (sfid-20141018_190239_029797_60484996)
In-Reply-To: <1413651732-69783-1-git-send-email-nbd@openwrt.org>
References: <1413651732-69783-1-git-send-email-nbd@openwrt.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The "goto chip_reset" is a bit misleading, because it does not actually
issue a chip reset. Instead it is bypassing processing of other
interrupts and assumes that the tasklet will issue a chip reset.

In the case of RXORN this does not happen, so bypassing processing of
other interrupts will simply allow them to fire again. Even if RXORN
was triggering a reset, it is not critical enough to need the bypass
here.

Signed-off-by: Felix Fietkau <nbd@openwrt.org>
---
 drivers/net/wireless/ath/ath9k/main.c | 7 +++----
 1 file changed, 3 insertions(+), 4 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/main.c b/drivers/net/wireless/ath/ath9k/main.c
index 6f6a974..e7d4833 100644
--- a/drivers/net/wireless/ath/ath9k/main.c
+++ b/drivers/net/wireless/ath/ath9k/main.c
@@ -539,11 +539,10 @@ irqreturn_t ath_isr(int irq, void *dev)
 		sched = true;
 
 	/*
-	 * If a FATAL or RXORN interrupt is received, we have to reset the
-	 * chip immediately.
+	 * If a FATAL interrupt is received, we have to reset the chip
+	 * immediately.
 	 */
-	if ((status & ATH9K_INT_FATAL) || ((status & ATH9K_INT_RXORN) &&
-	    !(ah->caps.hw_caps & ATH9K_HW_CAP_EDMA)))
+	if (status & ATH9K_INT_FATAL)
 		goto chip_reset;
 
 	if ((ah->config.hw_hang_checks & HW_BB_WATCHDOG) &&
-- 
2.0.4

