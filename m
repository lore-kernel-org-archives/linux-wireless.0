Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from sg2plsmtpa01-01.prod.sin2.secureserver.net ([182.50.145.6]:35041
	"EHLO sg2plsmtpa01-01.prod.sin2.secureserver.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752133Ab2KUMoE (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 21 Nov 2012 07:44:04 -0500
From: Sujith Manoharan <sujith@msujith.org>
To: John Linville <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org
Subject: [PATCH 5/6] ath9k: Fix rate control debugging
Date: Wed, 21 Nov 2012 18:13:14 +0530
Message-Id: <1353501795-10378-5-git-send-email-sujith@msujith.org> (sfid-20121121_134410_122774_1719D4F3)
In-Reply-To: <1353501795-10378-1-git-send-email-sujith@msujith.org>
References: <1353501795-10378-1-git-send-email-sujith@msujith.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Sujith Manoharan <c_manoha@qca.qualcomm.com>

Update the rate statistics only when debugfs has been enabled
in ath9k and mac80211 and move the stat() functions under proper
conditionals.

Signed-off-by: Sujith Manoharan <c_manoha@qca.qualcomm.com>
---
 drivers/net/wireless/ath/ath9k/rc.c | 36 ++++++++++++++++++------------------
 drivers/net/wireless/ath/ath9k/rc.h | 16 +++++++++++++++-
 2 files changed, 33 insertions(+), 19 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/rc.c b/drivers/net/wireless/ath/ath9k/rc.c
index 004f016..714558d 100644
--- a/drivers/net/wireless/ath/ath9k/rc.c
+++ b/drivers/net/wireless/ath/ath9k/rc.c
@@ -982,16 +982,6 @@ static void ath_rc_update_per(struct ath_softc *sc,
 	}
 }
 
-static void ath_debug_stat_retries(struct ath_rate_priv *rc, int rix,
-				   int xretries, int retries, u8 per)
-{
-	struct ath_rc_stats *stats = &rc->rcstats[rix];
-
-	stats->xretries += xretries;
-	stats->retries += retries;
-	stats->per = per;
-}
-
 static void ath_rc_update_ht(struct ath_softc *sc,
 			     struct ath_rate_priv *ath_rc_priv,
 			     struct ieee80211_tx_info *tx_info,
@@ -1065,14 +1055,6 @@ static void ath_rc_update_ht(struct ath_softc *sc,
 
 }
 
-static void ath_debug_stat_rc(struct ath_rate_priv *rc, int final_rate)
-{
-	struct ath_rc_stats *stats;
-
-	stats = &rc->rcstats[final_rate];
-	stats->success++;
-}
-
 static void ath_rc_tx_status(struct ath_softc *sc,
 			     struct ath_rate_priv *ath_rc_priv,
 			     struct sk_buff *skb)
@@ -1352,6 +1334,24 @@ static void ath_rate_update(void *priv, struct ieee80211_supported_band *sband,
 
 #if defined(CONFIG_MAC80211_DEBUGFS) && defined(CONFIG_ATH9K_DEBUGFS)
 
+void ath_debug_stat_rc(struct ath_rate_priv *rc, int final_rate)
+{
+	struct ath_rc_stats *stats;
+
+	stats = &rc->rcstats[final_rate];
+	stats->success++;
+}
+
+void ath_debug_stat_retries(struct ath_rate_priv *rc, int rix,
+			    int xretries, int retries, u8 per)
+{
+	struct ath_rc_stats *stats = &rc->rcstats[rix];
+
+	stats->xretries += xretries;
+	stats->retries += retries;
+	stats->per = per;
+}
+
 static ssize_t read_file_rcstat(struct file *file, char __user *user_buf,
 				size_t count, loff_t *ppos)
 {
diff --git a/drivers/net/wireless/ath/ath9k/rc.h b/drivers/net/wireless/ath/ath9k/rc.h
index 528c83c..267dbfc 100644
--- a/drivers/net/wireless/ath/ath9k/rc.h
+++ b/drivers/net/wireless/ath/ath9k/rc.h
@@ -213,10 +213,24 @@ struct ath_rate_priv {
 
 #if defined(CONFIG_MAC80211_DEBUGFS) && defined(CONFIG_ATH9K_DEBUGFS)
 	struct dentry *debugfs_rcstats;
-#endif
 	struct ath_rc_stats rcstats[RATE_TABLE_SIZE];
+#endif
 };
 
+#if defined(CONFIG_MAC80211_DEBUGFS) && defined(CONFIG_ATH9K_DEBUGFS)
+void ath_debug_stat_rc(struct ath_rate_priv *rc, int final_rate);
+void ath_debug_stat_retries(struct ath_rate_priv *rc, int rix,
+			    int xretries, int retries, u8 per);
+#else
+static inline void ath_debug_stat_rc(struct ath_rate_priv *rc, int final_rate)
+{
+}
+static inline void ath_debug_stat_retries(struct ath_rate_priv *rc, int rix,
+					  int xretries, int retries, u8 per)
+{
+}
+#endif
+
 #ifdef CONFIG_ATH9K_RATE_CONTROL
 int ath_rate_control_register(void);
 void ath_rate_control_unregister(void);
-- 
1.8.0

