Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.atheros.com ([12.36.123.2]:16419 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753165AbZBTJrK (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 20 Feb 2009 04:47:10 -0500
Received: from mail.atheros.com ([10.10.20.86])
	by sidewinder.atheros.com
	for <linux-wireless@vger.kernel.org>; Fri, 20 Feb 2009 01:47:10 -0800
From: Sujith <Sujith.Manoharan@atheros.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Message-ID: <18846.31544.511129.753988@gargle.gargle.HOWL> (sfid-20090220_104715_234439_6888C582)
Date: Fri, 20 Feb 2009 15:13:20 +0530
To: <linville@tuxdriver.com>
CC: <linux-wireless@vger.kernel.org>, <Jouni.Malinen@Atheros.com>,
	<Luis.Rodriguez@Atheros.com>
Subject: [PATCH 2/5] ath9k: Add PER to RC debug statistics
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Signed-off-by: Sujith <Sujith.Manoharan@atheros.com>
---
 drivers/net/wireless/ath9k/debug.c |   12 +++++++-----
 drivers/net/wireless/ath9k/debug.h |    9 +++++----
 drivers/net/wireless/ath9k/rc.c    |    3 ++-
 3 files changed, 14 insertions(+), 10 deletions(-)

diff --git a/drivers/net/wireless/ath9k/debug.c b/drivers/net/wireless/ath9k/debug.c
index 800ad59..0c422c5 100644
--- a/drivers/net/wireless/ath9k/debug.c
+++ b/drivers/net/wireless/ath9k/debug.c
@@ -258,13 +258,14 @@ void ath_debug_stat_rc(struct ath_softc *sc, struct sk_buff *skb)
 
 /* FIXME: legacy rates, later on .. */
 void ath_debug_stat_retries(struct ath_softc *sc, int rix,
-			    int xretries, int retries)
+			    int xretries, int retries, u8 per)
 {
 	if (conf_is_ht(&sc->hw->conf)) {
 		int idx = sc->cur_rate_table->info[rix].dot11rate;
 
 		sc->debug.stats.n_rcstats[idx].xretries += xretries;
 		sc->debug.stats.n_rcstats[idx].retries += retries;
+		sc->debug.stats.n_rcstats[idx].per = per;
 	}
 }
 
@@ -277,15 +278,16 @@ static ssize_t ath_read_file_stat_11n_rc(struct file *file,
 	unsigned int len = 0;
 	int i = 0;
 
-	len += sprintf(buf, "%7s %13s %8s %8s\n\n", "Rate", "Success",
-		       "Retries", "XRetries");
+	len += sprintf(buf, "%7s %13s %8s %8s %6s\n\n", "Rate", "Success",
+		       "Retries", "XRetries", "PER");
 
 	for (i = 0; i <= 15; i++) {
 		len += snprintf(buf + len, sizeof(buf) - len,
-				"%5s%3d: %8u %8u %8u\n", "MCS", i,
+				"%5s%3d: %8u %8u %8u %8u\n", "MCS", i,
 				sc->debug.stats.n_rcstats[i].success,
 				sc->debug.stats.n_rcstats[i].retries,
-				sc->debug.stats.n_rcstats[i].xretries);
+				sc->debug.stats.n_rcstats[i].xretries,
+				sc->debug.stats.n_rcstats[i].per);
 	}
 
 	return simple_read_from_buffer(user_buf, count, ppos, buf, len);
diff --git a/drivers/net/wireless/ath9k/debug.h b/drivers/net/wireless/ath9k/debug.h
index 61e9698..d9970c7 100644
--- a/drivers/net/wireless/ath9k/debug.h
+++ b/drivers/net/wireless/ath9k/debug.h
@@ -91,12 +91,13 @@ struct ath_11n_rc_stats {
 	u32 success;
 	u32 retries;
 	u32 xretries;
+	u8 per;
 };
 
 struct ath_stats {
 	struct ath_interrupt_stats istats;
-	struct ath_legacy_rc_stats legacy_rcstats[12]; /* max(11a,11b,11g) */
-	struct ath_11n_rc_stats n_rcstats[16]; /* 0..15 MCS rates */
+	struct ath_legacy_rc_stats legacy_rcstats[12];	/* max(11a,11b,11g) */
+	struct ath_11n_rc_stats n_rcstats[16];		/* 0..15 MCS rates */
 };
 
 struct ath9k_debug {
@@ -115,7 +116,7 @@ void ath9k_exit_debug(struct ath_softc *sc);
 void ath_debug_stat_interrupt(struct ath_softc *sc, enum ath9k_int status);
 void ath_debug_stat_rc(struct ath_softc *sc, struct sk_buff *skb);
 void ath_debug_stat_retries(struct ath_softc *sc, int rix,
-			    int xretries, int retries);
+			    int xretries, int retries, u8 per);
 
 #else
 
@@ -144,7 +145,7 @@ static inline void ath_debug_stat_rc(struct ath_softc *sc,
 }
 
 static inline void ath_debug_stat_retries(struct ath_softc *sc, int rix,
-					  int xretries, int retries)
+					  int xretries, int retries, u8 per);
 {
 }
 
diff --git a/drivers/net/wireless/ath9k/rc.c b/drivers/net/wireless/ath9k/rc.c
index 0e3e2b7..cf0559f 100644
--- a/drivers/net/wireless/ath9k/rc.c
+++ b/drivers/net/wireless/ath9k/rc.c
@@ -1267,7 +1267,8 @@ static void ath_rc_update_ht(struct ath_softc *sc,
 		ath_rc_priv->per_down_time = now_msec;
 	}
 
-	ath_debug_stat_retries(sc, tx_rate, xretries, retries);
+	ath_debug_stat_retries(sc, tx_rate, xretries, retries,
+			       ath_rc_priv->state[tx_rate].per);
 
 #undef CHK_RSSI
 }
-- 
1.6.1

