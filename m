Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([18.85.46.34]:57228 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S964835AbZLGRig (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 7 Dec 2009 12:38:36 -0500
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	"Luis R. Rodriguez" <lrodriguez@atheros.com>
Subject: [PATCH] ath9k: add MCS rate index back to debufs rcstat
Date: Mon,  7 Dec 2009 12:38:41 -0500
Message-Id: <1260207521-11537-1-git-send-email-lrodriguez@atheros.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Speaking of 802.11n rates in terms of Mbps doesn't really developers
and is just useful for users. To aid debugging add the MCS index back
and an HT20/HT40 mode.

New screenshot:

    HT    MCS   Rate    Success    Retries   XRetries        PER
                6.0:          0          0          0          0
                9.0:          0          0          0          0
               12.0:         26        260          0         49
               18.0:         80        804          2         58
               24.0:          0          0          0          0
               36.0:          0          0          0          0
               48.0:          0          0          0          0
               54.0:          0          0          0          0
  HT20      0   6.5:       1368      13660          0         48
  HT20      1  13.0:          0          0          0          0
  HT20      2  19.5:          0          0          0          0
  HT20      3  26.0:          0          0          0          0
  HT20      4  39.0:          0          0          0          0
  HT20      5  52.0:         55        578         14         43
  HT20      6  58.5:         29        306          8         69
  HT20      7  65.0:         21        210          0         67
  HT20      8  13.0:         21        210          0         56
  HT20      9  26.0:          0          0          0          0
  HT20     10  39.0:          0          0          0          0
  HT20     11  52.0:          0          0          0          0
  HT20     12  78.0:          0          0          0          0
  HT20     13 104.0:          0          0          0          0
  HT20     14 117.0:          0          0          0          0
  HT20     15 130.0:         27        290         10         55
  HT40      0  13.5:         79        687         16         17
  HT40      1  27.5:         60        409         10         17
  HT40      2  40.5:         56        381         21         25
  HT40      3  54.0:         44        302         21         18
  HT40      4  81.5:         19        171          2         14
  HT40      5 108.0:          0          0          0          0
  HT40      6 121.5:          0          0          0          0
  HT40      7 135.0:          0          0          0          0
  HT40      7 150.0:          0          0          0          0
  HT40      8  27.0:          0          0          0          0
  HT40      9  54.0:          0          0          0          0
  HT40     10  81.0:          0          0          0          0
  HT40     11 108.0:         11        100          0         18
  HT40     12 162.0:         23        200          0         22
  HT40     13 216.0:         61        580          0         35
  HT40     14 243.0:         37        271          0         66
  HT40     15 270.0:         65        217          2         73
  HT40     15 300.0:          0          0          0          0

Signed-off-by: Luis R. Rodriguez <lrodriguez@atheros.com>
---
 drivers/net/wireless/ath/ath9k/debug.c |   38 ++++++++++++++++++++++++++-----
 drivers/net/wireless/ath/ath9k/rc.h    |    4 +++
 2 files changed, 36 insertions(+), 6 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/debug.c b/drivers/net/wireless/ath/ath9k/debug.c
index b66f72d..592f1b7 100644
--- a/drivers/net/wireless/ath/ath9k/debug.c
+++ b/drivers/net/wireless/ath/ath9k/debug.c
@@ -289,23 +289,49 @@ static ssize_t read_file_rcstat(struct file *file, char __user *user_buf,
 	if (sc->cur_rate_table == NULL)
 		return 0;
 
-	max = 80 + sc->cur_rate_table->rate_cnt * 64;
+	max = 80 + sc->cur_rate_table->rate_cnt * 1024;
 	buf = kmalloc(max + 1, GFP_KERNEL);
 	if (buf == NULL)
 		return 0;
 	buf[max] = 0;
 
-	len += sprintf(buf, "%5s %15s %8s %9s %3s\n\n", "Rate", "Success",
-		       "Retries", "XRetries", "PER");
+	len += sprintf(buf, "%6s %6s %6s "
+		       "%10s %10s %10s %10s\n",
+		       "HT", "MCS", "Rate",
+		       "Success", "Retries", "XRetries", "PER");
 
 	for (i = 0; i < sc->cur_rate_table->rate_cnt; i++) {
 		u32 ratekbps = sc->cur_rate_table->info[i].ratekbps;
 		struct ath_rc_stats *stats = &sc->debug.stats.rcstats[i];
+		char mcs[5];
+		char htmode[5];
+		int used_mcs = 0, used_htmode = 0;
+
+		if (WLAN_RC_PHY_HT(sc->cur_rate_table->info[i].phy)) {
+			used_mcs = snprintf(mcs, 5, "%d",
+				sc->cur_rate_table->info[i].ratecode);
+
+			if (WLAN_RC_PHY_40(sc->cur_rate_table->info[i].phy))
+				used_htmode = snprintf(htmode, 5, "HT40");
+			else if (WLAN_RC_PHY_20(sc->cur_rate_table->info[i].phy))
+				used_htmode = snprintf(htmode, 5, "HT20");
+			else
+				used_htmode = snprintf(htmode, 5, "????");
+		}
+
+		mcs[used_mcs] = '\0';
+		htmode[used_htmode] = '\0';
 
 		len += snprintf(buf + len, max - len,
-			"%3u.%d: %8u %8u %8u %8u\n", ratekbps / 1000,
-			(ratekbps % 1000) / 100, stats->success,
-			stats->retries, stats->xretries,
+			"%6s %6s %3u.%d: "
+			"%10u %10u %10u %10u\n",
+			htmode,
+			mcs,
+			ratekbps / 1000,
+			(ratekbps % 1000) / 100,
+			stats->success,
+			stats->retries,
+			stats->xretries,
 			stats->per);
 	}
 
diff --git a/drivers/net/wireless/ath/ath9k/rc.h b/drivers/net/wireless/ath/ath9k/rc.h
index 9eb96f5..4f6d6fd 100644
--- a/drivers/net/wireless/ath/ath9k/rc.h
+++ b/drivers/net/wireless/ath/ath9k/rc.h
@@ -57,6 +57,10 @@ enum {
 				|| (_phy == WLAN_RC_PHY_HT_40_DS)	\
 				|| (_phy == WLAN_RC_PHY_HT_20_DS_HGI)	\
 				|| (_phy == WLAN_RC_PHY_HT_40_DS_HGI))
+#define WLAN_RC_PHY_20(_phy)   ((_phy == WLAN_RC_PHY_HT_20_SS)		\
+				|| (_phy == WLAN_RC_PHY_HT_20_DS)	\
+				|| (_phy == WLAN_RC_PHY_HT_20_SS_HGI)	\
+				|| (_phy == WLAN_RC_PHY_HT_20_DS_HGI))
 #define WLAN_RC_PHY_40(_phy)   ((_phy == WLAN_RC_PHY_HT_40_SS)		\
 				|| (_phy == WLAN_RC_PHY_HT_40_DS)	\
 				|| (_phy == WLAN_RC_PHY_HT_40_SS_HGI)	\
-- 
1.6.3.3

