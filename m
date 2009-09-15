Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.gmx.net ([213.165.64.20]:40968 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1750879AbZIOUUV (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 15 Sep 2009 16:20:21 -0400
Message-ID: <4AAFF706.9010806@gmx.de>
Date: Tue, 15 Sep 2009 22:20:22 +0200
From: Joerg Albert <jal2@gmx.de>
MIME-Version: 1.0
To: "John W. Linville" <linville@tuxdriver.com>
CC: Christian Lamparter <chunkeey@googlemail.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: [PATCH] ar9170: fixed coding style, moved define
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This patch fixes some coding style issues and moves MAX_RATE_POWER into hw.h

Signed-off-by: Joerg Albert <jal2@gmx.de>
---
 drivers/net/wireless/ath/ar9170/hw.h  |    2 ++
 drivers/net/wireless/ath/ar9170/phy.c |   28 +++++++++++++++-------------
 2 files changed, 17 insertions(+), 13 deletions(-)

diff --git a/drivers/net/wireless/ath/ar9170/hw.h b/drivers/net/wireless/ath/ar9170/hw.h
index 6cbfb2f..8811314 100644
--- a/drivers/net/wireless/ath/ar9170/hw.h
+++ b/drivers/net/wireless/ath/ar9170/hw.h
@@ -311,6 +311,8 @@ struct ar9170_tx_control {
 
 #define AR9170_TX_PHY_SHORT_GI			0x80000000
 
+#define AR5416_MAX_RATE_POWER                   63
+
 struct ar9170_rx_head {
 	u8 plcp[12];
 } __packed;
diff --git a/drivers/net/wireless/ath/ar9170/phy.c b/drivers/net/wireless/ath/ar9170/phy.c
index b3e5cf3..941c699 100644
--- a/drivers/net/wireless/ath/ar9170/phy.c
+++ b/drivers/net/wireless/ath/ar9170/phy.c
@@ -1241,9 +1241,6 @@ static u8 ar9170_get_max_edge_power(struct ar9170 *ar,
 				    struct ar9170_calctl_edges edges[],
 				    u32 freq)
 {
-/* TODO: move somewhere else */
-#define AR5416_MAX_RATE_POWER        63
-
 	int i;
 	u8 rc = AR5416_MAX_RATE_POWER;
 	u8 f;
@@ -1261,10 +1258,11 @@ static u8 ar9170_get_max_edge_power(struct ar9170 *ar,
 			break;
 		}
 		if (i > 0 && f < edges[i].channel) {
-			if (f > edges[i-1].channel &&
-			    edges[i-1].power_flags & AR9170_CALCTL_EDGE_FLAGS) {
+			if (f > edges[i - 1].channel &&
+			    edges[i - 1].power_flags &
+			    AR9170_CALCTL_EDGE_FLAGS) {
 				/* lower channel has the inband flag set */
-				rc = edges[i-1].power_flags &
+				rc = edges[i - 1].power_flags &
 					~AR9170_CALCTL_EDGE_FLAGS;
 			}
 			break;
@@ -1272,10 +1270,10 @@ static u8 ar9170_get_max_edge_power(struct ar9170 *ar,
 	}
 
 	if (i == AR5416_NUM_BAND_EDGES) {
-		if (f > edges[i-1].channel &&
-		    edges[i-1].power_flags & AR9170_CALCTL_EDGE_FLAGS) {
+		if (f > edges[i - 1].channel &&
+		    edges[i - 1].power_flags & AR9170_CALCTL_EDGE_FLAGS) {
 			/* lower channel has the inband flag set */
-			rc = edges[i-1].power_flags &
+			rc = edges[i - 1].power_flags &
 				~AR9170_CALCTL_EDGE_FLAGS;
 		}
 	}
@@ -1297,7 +1295,8 @@ static void ar9170_calc_ctl(struct ar9170 *ar, u32 freq, enum ar9170_bw bw)
 		int pwr_cal_len;
 	} *modes;
 
-	/* order is relevant in the mode_list_*: we fall back to the
+	/*
+	 * order is relevant in the mode_list_*: we fall back to the
 	 * lower indices if any mode is missed in the EEPROM.
 	 */
 	struct ctl_modes mode_list_2ghz[] = {
@@ -1315,7 +1314,8 @@ static void ar9170_calc_ctl(struct ar9170 *ar, u32 freq, enum ar9170_bw bw)
 
 #define EDGES(c, n) (ar->eeprom.ctl_data[c].control_edges[n])
 
-	/* TODO: investigate the differences between OTUS'
+	/*
+	 * TODO: investigate the differences between OTUS'
 	 * hpreg.c::zfHpGetRegulatoryDomain() and
 	 * ath/regd.c::ath_regd_get_band_ctl() -
 	 * e.g. for FCC3_WORLD the OTUS procedure
@@ -1362,13 +1362,15 @@ static void ar9170_calc_ctl(struct ar9170 *ar, u32 freq, enum ar9170_bw bw)
 				ar9170_get_max_edge_power(ar, EDGES(ctl_idx, 1),
 							  freq+f_off);
 
-			/* TODO: check if the regulatory max. power is
+			/*
+			 * TODO: check if the regulatory max. power is
 			 *  controlled by cfg80211 for DFS
 			 * (hpmain applies it to max_power itself for DFS freq)
 			 */
 
 		} else {
-			/* Workaround in otus driver, hpmain.c, line 3906:
+			/*
+			 * Workaround in otus driver, hpmain.c, line 3906:
 			 * if no data for 5GHT20 are found, take the
 			 * legacy 5G value.
 			 * We extend this here to fallback from any other *HT or
-- 
1.6.0.4

