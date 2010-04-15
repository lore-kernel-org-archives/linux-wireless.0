Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([18.85.46.34]:33004 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757423Ab0DOVjq (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 15 Apr 2010 17:39:46 -0400
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	"Luis R. Rodriguez" <lrodriguez@atheros.com>,
	Felix Fietkau <nbd@openwrt.org>
Subject: [PATCH v3 85/97] ath9k: add RXLP and RXHP to debugfs counters
Date: Thu, 15 Apr 2010 17:39:30 -0400
Message-Id: <1271367582-992-86-git-send-email-lrodriguez@atheros.com>
In-Reply-To: <1271367582-992-1-git-send-email-lrodriguez@atheros.com>
References: <1271367582-992-1-git-send-email-lrodriguez@atheros.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Signed-off-by: Luis R. Rodriguez <lrodriguez@atheros.com>
Signed-off-by: Felix Fietkau <nbd@openwrt.org>
---
 drivers/net/wireless/ath/ath9k/debug.c |   22 ++++++++++++++++++----
 drivers/net/wireless/ath/ath9k/debug.h |    4 ++++
 2 files changed, 22 insertions(+), 4 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/debug.c b/drivers/net/wireless/ath/ath9k/debug.c
index 9a8e419..64e30cd 100644
--- a/drivers/net/wireless/ath/ath9k/debug.c
+++ b/drivers/net/wireless/ath/ath9k/debug.c
@@ -180,8 +180,15 @@ void ath_debug_stat_interrupt(struct ath_softc *sc, enum ath9k_int status)
 {
 	if (status)
 		sc->debug.stats.istats.total++;
-	if (status & ATH9K_INT_RX)
-		sc->debug.stats.istats.rxok++;
+	if (sc->sc_ah->caps.hw_caps & ATH9K_HW_CAP_EDMA) {
+		if (status & ATH9K_INT_RXLP)
+			sc->debug.stats.istats.rxlp++;
+		if (status & ATH9K_INT_RXHP)
+			sc->debug.stats.istats.rxhp++;
+	} else {
+		if (status & ATH9K_INT_RX)
+			sc->debug.stats.istats.rxok++;
+	}
 	if (status & ATH9K_INT_RXEOL)
 		sc->debug.stats.istats.rxeol++;
 	if (status & ATH9K_INT_RXORN)
@@ -223,8 +230,15 @@ static ssize_t read_file_interrupt(struct file *file, char __user *user_buf,
 	char buf[512];
 	unsigned int len = 0;
 
-	len += snprintf(buf + len, sizeof(buf) - len,
-		"%8s: %10u\n", "RX", sc->debug.stats.istats.rxok);
+	if (sc->sc_ah->caps.hw_caps & ATH9K_HW_CAP_EDMA) {
+		len += snprintf(buf + len, sizeof(buf) - len,
+			"%8s: %10u\n", "RXLP", sc->debug.stats.istats.rxlp);
+		len += snprintf(buf + len, sizeof(buf) - len,
+			"%8s: %10u\n", "RXHP", sc->debug.stats.istats.rxhp);
+	} else {
+		len += snprintf(buf + len, sizeof(buf) - len,
+			"%8s: %10u\n", "RX", sc->debug.stats.istats.rxok);
+	}
 	len += snprintf(buf + len, sizeof(buf) - len,
 		"%8s: %10u\n", "RXEOL", sc->debug.stats.istats.rxeol);
 	len += snprintf(buf + len, sizeof(buf) - len,
diff --git a/drivers/net/wireless/ath/ath9k/debug.h b/drivers/net/wireless/ath/ath9k/debug.h
index b2af9de..c545960 100644
--- a/drivers/net/wireless/ath/ath9k/debug.h
+++ b/drivers/net/wireless/ath/ath9k/debug.h
@@ -35,6 +35,8 @@ struct ath_buf;
  * struct ath_interrupt_stats - Contains statistics about interrupts
  * @total: Total no. of interrupts generated so far
  * @rxok: RX with no errors
+ * @rxlp: RX with low priority RX
+ * @rxhp: RX with high priority, uapsd only
  * @rxeol: RX with no more RXDESC available
  * @rxorn: RX FIFO overrun
  * @txok: TX completed at the requested rate
@@ -55,6 +57,8 @@ struct ath_buf;
 struct ath_interrupt_stats {
 	u32 total;
 	u32 rxok;
+	u32 rxlp;
+	u32 rxhp;
 	u32 rxeol;
 	u32 rxorn;
 	u32 txok;
-- 
1.6.3.3

