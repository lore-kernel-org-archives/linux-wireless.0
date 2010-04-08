Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([18.85.46.34]:46996 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933298Ab0DHT1s (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 8 Apr 2010 15:27:48 -0400
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	"Luis R. Rodriguez" <lrodriguez@atheros.com>
Subject: [PATCH 088/102] ath9k: add RXLP and RXHP to debugfs counters
Date: Thu,  8 Apr 2010 15:27:24 -0400
Message-Id: <1270754858-26266-89-git-send-email-lrodriguez@atheros.com>
In-Reply-To: <1270754858-26266-1-git-send-email-lrodriguez@atheros.com>
References: <1270754858-26266-1-git-send-email-lrodriguez@atheros.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Signed-off-by: Luis R. Rodriguez <lrodriguez@atheros.com>
---
 drivers/net/wireless/ath/ath9k/debug.c |    8 ++++++++
 drivers/net/wireless/ath/ath9k/debug.h |    4 ++++
 2 files changed, 12 insertions(+), 0 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/debug.c b/drivers/net/wireless/ath/ath9k/debug.c
index c7e8959..d82a77f 100644
--- a/drivers/net/wireless/ath/ath9k/debug.c
+++ b/drivers/net/wireless/ath/ath9k/debug.c
@@ -181,6 +181,10 @@ void ath_debug_stat_interrupt(struct ath_softc *sc, enum ath9k_int status)
 		sc->debug.stats.istats.total++;
 	if (status & ATH9K_INT_RX)
 		sc->debug.stats.istats.rxok++;
+	if (status & ATH9K_INT_RXLP)
+		sc->debug.stats.istats.rxlp++;
+	if (status & ATH9K_INT_RXHP)
+		sc->debug.stats.istats.rxhp++;
 	if (status & ATH9K_INT_RXEOL)
 		sc->debug.stats.istats.rxeol++;
 	if (status & ATH9K_INT_RXORN)
@@ -225,6 +229,10 @@ static ssize_t read_file_interrupt(struct file *file, char __user *user_buf,
 	len += snprintf(buf + len, sizeof(buf) - len,
 		"%8s: %10u\n", "RX", sc->debug.stats.istats.rxok);
 	len += snprintf(buf + len, sizeof(buf) - len,
+		"%8s: %10u\n", "RXLP", sc->debug.stats.istats.rxlp);
+	len += snprintf(buf + len, sizeof(buf) - len,
+		"%8s: %10u\n", "RXHP", sc->debug.stats.istats.rxhp);
+	len += snprintf(buf + len, sizeof(buf) - len,
 		"%8s: %10u\n", "RXEOL", sc->debug.stats.istats.rxeol);
 	len += snprintf(buf + len, sizeof(buf) - len,
 		"%8s: %10u\n", "RXORN", sc->debug.stats.istats.rxorn);
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

