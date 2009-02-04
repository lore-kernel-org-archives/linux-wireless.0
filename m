Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.atheros.com ([12.36.123.2]:19348 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752131AbZBDCoD (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 3 Feb 2009 21:44:03 -0500
Received: from mail.atheros.com ([10.10.20.108])
	by sidewinder.atheros.com
	for <linux-wireless@vger.kernel.org>; Tue, 03 Feb 2009 18:44:03 -0800
From: Sujith <Sujith.Manoharan@atheros.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Message-ID: <18825.26.863392.575020@gargle.gargle.HOWL> (sfid-20090204_034413_742399_8BEBD4A4)
Date: Wed, 4 Feb 2009 08:10:26 +0530
To: <linville@tuxdriver.com>
CC: <linux-wireless@vger.kernel.org>, <Jouni.Malinen@Atheros.com>,
	<Luis.Rodriguez@Atheros.com>
Subject: [PATCH 4/4] ath9k: Add retry counters to rate control debug file
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Signed-off-by: Sujith <Sujith.Manoharan@atheros.com>
---
 drivers/net/wireless/ath9k/core.h  |    9 +++++++++
 drivers/net/wireless/ath9k/debug.c |   23 +++++++++++++++++++----
 drivers/net/wireless/ath9k/rc.c    |    2 ++
 3 files changed, 30 insertions(+), 4 deletions(-)

diff --git a/drivers/net/wireless/ath9k/core.h b/drivers/net/wireless/ath9k/core.h
index 63d3eb6..64fc5c2 100644
--- a/drivers/net/wireless/ath9k/core.h
+++ b/drivers/net/wireless/ath9k/core.h
@@ -137,6 +137,8 @@ struct ath_legacy_rc_stats {
 
 struct ath_11n_rc_stats {
 	u32 success;
+	u32 retries;
+	u32 xretries;
 };
 
 struct ath_stats {
@@ -160,6 +162,8 @@ int ath9k_init_debug(struct ath_softc *sc);
 void ath9k_exit_debug(struct ath_softc *sc);
 void ath_debug_stat_interrupt(struct ath_softc *sc, enum ath9k_int status);
 void ath_debug_stat_rc(struct ath_softc *sc, struct sk_buff *skb);
+void ath_debug_stat_retries(struct ath_softc *sc, int rix,
+			    int xretries, int retries);
 
 #else
 
@@ -187,6 +191,11 @@ static inline void ath_debug_stat_rc(struct ath_softc *sc,
 {
 }
 
+static inline void ath_debug_stat_retries(struct ath_softc *sc, int rix,
+					  int xretries, int retries)
+{
+}
+
 #endif /* CONFIG_ATH9K_DEBUG */
 
 struct ath_config {
diff --git a/drivers/net/wireless/ath9k/debug.c b/drivers/net/wireless/ath9k/debug.c
index 6181e49..2de1b8a 100644
--- a/drivers/net/wireless/ath9k/debug.c
+++ b/drivers/net/wireless/ath9k/debug.c
@@ -258,21 +258,36 @@ void ath_debug_stat_rc(struct ath_softc *sc, struct sk_buff *skb)
 		ath_debug_stat_legacy_rc(sc, skb);
 }
 
+/* FIXME: legacy rates, later on .. */
+void ath_debug_stat_retries(struct ath_softc *sc, int rix,
+			    int xretries, int retries)
+{
+	if (conf_is_ht(&sc->hw->conf)) {
+		int idx = sc->cur_rate_table->info[rix].dot11rate;
+
+		sc->sc_debug.stats.n_rcstats[idx].xretries += xretries;
+		sc->sc_debug.stats.n_rcstats[idx].retries += retries;
+	}
+}
+
 static ssize_t ath_read_file_stat_11n_rc(struct file *file,
 					 char __user *user_buf,
 					 size_t count, loff_t *ppos)
 {
 	struct ath_softc *sc = file->private_data;
-	char buf[512];
+	char buf[1024];
 	unsigned int len = 0;
 	int i = 0;
 
-	len += sprintf(buf, "%7s %13s\n\n", "Rate", "Success");
+	len += sprintf(buf, "%7s %13s %8s %8s\n\n", "Rate", "Success",
+		       "Retries", "XRetries");
 
 	for (i = 0; i <= 15; i++) {
 		len += snprintf(buf + len, sizeof(buf) - len,
-				"%5s%3d: %8u\n", "MCS", i,
-				sc->sc_debug.stats.n_rcstats[i].success);
+				"%5s%3d: %8u %8u %8u\n", "MCS", i,
+				sc->sc_debug.stats.n_rcstats[i].success,
+				sc->sc_debug.stats.n_rcstats[i].retries,
+				sc->sc_debug.stats.n_rcstats[i].xretries);
 	}
 
 	return simple_read_from_buffer(user_buf, count, ppos, buf, len);
diff --git a/drivers/net/wireless/ath9k/rc.c b/drivers/net/wireless/ath9k/rc.c
index 704b627..69a4ca4 100644
--- a/drivers/net/wireless/ath9k/rc.c
+++ b/drivers/net/wireless/ath9k/rc.c
@@ -1267,6 +1267,8 @@ static void ath_rc_update_ht(struct ath_softc *sc,
 		ath_rc_priv->per_down_time = now_msec;
 	}
 
+	ath_debug_stat_retries(sc, tx_rate, xretries, retries);
+
 #undef CHK_RSSI
 }
 
-- 
1.6.1

