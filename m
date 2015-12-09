Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-gw1-out.broadcom.com ([216.31.210.62]:32733 "EHLO
	mail-gw1-out.broadcom.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754612AbbLIKW4 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 9 Dec 2015 05:22:56 -0500
From: Arend van Spriel <arend@broadcom.com>
To: Kalle Valo <kvalo@codeaurora.org>
CC: linux-wireless <linux-wireless@vger.kernel.org>,
	Hante Meuleman <meuleman@broadcom.com>,
	Arend van Spriel <arend@broadcom.com>
Subject: [PATCH 01/13] brcmfmac: Simplify scan timing configuration.
Date: Wed, 9 Dec 2015 11:22:40 +0100
Message-ID: <1449656572-16158-2-git-send-email-arend@broadcom.com> (sfid-20151209_112325_026043_EE29558D)
In-Reply-To: <1449656572-16158-1-git-send-email-arend@broadcom.com>
References: <1449656572-16158-1-git-send-email-arend@broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Hante Meuleman <meuleman@broadcom.com>

Reviewed-by: Arend Van Spriel <arend@broadcom.com>
Reviewed-by: Pieter-Paul Giesberts <pieterpg@broadcom.com>
Signed-off-by: Hante Meuleman <meuleman@broadcom.com>
Change-Id: Ie179527eb29f2ed8b7869dac24591e2513775393
Reviewed-on: http://hnd-swgit.sj.broadcom.com:8080/5445
Reviewed-by: brcm80211 ci <brcm80211-ci@broadcom.com>
Signed-off-by: Arend van Spriel <arend@broadcom.com>
---
 .../broadcom/brcm80211/brcmfmac/cfg80211.c         | 31 +++++++++-------------
 .../broadcom/brcm80211/brcmfmac/cfg80211.h         |  4 ---
 2 files changed, 12 insertions(+), 23 deletions(-)

diff --git a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/cfg80211.c b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/cfg80211.c
index 771c581..4aebb2a 100644
--- a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/cfg80211.c
+++ b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/cfg80211.c
@@ -91,6 +91,10 @@
 #define BRCMF_SCAN_JOIN_PASSIVE_DWELL_TIME_MS	400
 #define BRCMF_SCAN_JOIN_PROBE_INTERVAL_MS	20
 
+#define BRCMF_SCAN_CHANNEL_TIME		40
+#define BRCMF_SCAN_UNASSOC_TIME		40
+#define BRCMF_SCAN_PASSIVE_TIME		120
+
 #define BRCMF_ASSOC_PARAMS_FIXED_SIZE \
 	(sizeof(struct brcmf_assoc_params_le) - sizeof(u16))
 
@@ -5357,37 +5361,27 @@ roam_setup_done:
 }
 
 static s32
-brcmf_dongle_scantime(struct brcmf_if *ifp, s32 scan_assoc_time,
-		      s32 scan_unassoc_time, s32 scan_passive_time)
+brcmf_dongle_scantime(struct brcmf_if *ifp)
 {
 	s32 err = 0;
 
 	err = brcmf_fil_cmd_int_set(ifp, BRCMF_C_SET_SCAN_CHANNEL_TIME,
-				    scan_assoc_time);
+				    BRCMF_SCAN_CHANNEL_TIME);
 	if (err) {
-		if (err == -EOPNOTSUPP)
-			brcmf_dbg(INFO, "Scan assoc time is not supported\n");
-		else
-			brcmf_err("Scan assoc time error (%d)\n", err);
+		brcmf_err("Scan assoc time error (%d)\n", err);
 		goto dongle_scantime_out;
 	}
 	err = brcmf_fil_cmd_int_set(ifp, BRCMF_C_SET_SCAN_UNASSOC_TIME,
-				    scan_unassoc_time);
+				    BRCMF_SCAN_UNASSOC_TIME);
 	if (err) {
-		if (err == -EOPNOTSUPP)
-			brcmf_dbg(INFO, "Scan unassoc time is not supported\n");
-		else
-			brcmf_err("Scan unassoc time error (%d)\n", err);
+		brcmf_err("Scan unassoc time error (%d)\n", err);
 		goto dongle_scantime_out;
 	}
 
 	err = brcmf_fil_cmd_int_set(ifp, BRCMF_C_SET_SCAN_PASSIVE_TIME,
-				    scan_passive_time);
+				    BRCMF_SCAN_PASSIVE_TIME);
 	if (err) {
-		if (err == -EOPNOTSUPP)
-			brcmf_dbg(INFO, "Scan passive time is not supported\n");
-		else
-			brcmf_err("Scan passive time error (%d)\n", err);
+		brcmf_err("Scan passive time error (%d)\n", err);
 		goto dongle_scantime_out;
 	}
 
@@ -6089,8 +6083,7 @@ static s32 brcmf_config_dongle(struct brcmf_cfg80211_info *cfg)
 	/* make sure RF is ready for work */
 	brcmf_fil_cmd_int_set(ifp, BRCMF_C_UP, 0);
 
-	brcmf_dongle_scantime(ifp, WL_SCAN_CHANNEL_TIME,
-			      WL_SCAN_UNASSOC_TIME, WL_SCAN_PASSIVE_TIME);
+	brcmf_dongle_scantime(ifp);
 
 	power_mode = cfg->pwr_save ? PM_FAST : PM_OFF;
 	err = brcmf_fil_cmd_int_set(ifp, BRCMF_C_SET_PM, power_mode);
diff --git a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/cfg80211.h b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/cfg80211.h
index d492163..cf7a93d 100644
--- a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/cfg80211.h
+++ b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/cfg80211.h
@@ -29,10 +29,6 @@
 #define WL_ROAM_TRIGGER_LEVEL		-75
 #define WL_ROAM_DELTA			20
 
-#define WL_SCAN_CHANNEL_TIME		40
-#define WL_SCAN_UNASSOC_TIME		40
-#define WL_SCAN_PASSIVE_TIME		120
-
 #define WL_ESCAN_BUF_SIZE		(1024 * 64)
 #define WL_ESCAN_TIMER_INTERVAL_MS	10000 /* E-Scan timeout */
 
-- 
1.9.1

