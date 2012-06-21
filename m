Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from na3sys009aog136.obsmtp.com ([74.125.149.85]:55092 "EHLO
	na3sys009aog136.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756866Ab2FUONf (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 21 Jun 2012 10:13:35 -0400
Received: by lbbgo11 with SMTP id go11so2939234lbb.17
        for <linux-wireless@vger.kernel.org>; Thu, 21 Jun 2012 07:13:31 -0700 (PDT)
From: Luciano Coelho <coelho@ti.com>
To: linux-wireless@vger.kernel.org
Cc: coelho@ti.com, arik@wizery.com
Subject: [PATCH 10/12] wl18xx: sane defaults for HT capabilities
Date: Thu, 21 Jun 2012 17:13:09 +0300
Message-Id: <1340287991-15241-11-git-send-email-coelho@ti.com> (sfid-20120621_161543_578673_C63B804E)
In-Reply-To: <1340287991-15241-1-git-send-email-coelho@ti.com>
References: <1340287991-15241-1-git-send-email-coelho@ti.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Arik Nemtsov <arik@wizery.com>

Introduce a default set of HT capabilities that are set according to the
number of antennas on the board. Move the HT setting code down to allow
the number of antennas to be set (and optionally overridden) before it.

Remove the "mimo" HT option, since the default mode now enables MIMO is
possible.

Use this opportunity to add a helper function for setting HT
capabilities and reduce the volume of the code a bit.

Signed-off-by: Arik Nemtsov <arik@wizery.com>
Signed-off-by: Luciano Coelho <coelho@ti.com>
---
 drivers/net/wireless/ti/wl12xx/main.c   |    6 +--
 drivers/net/wireless/ti/wl18xx/main.c   |   63 ++++++++++++++++---------------
 drivers/net/wireless/ti/wlcore/wlcore.h |    7 ++++
 3 files changed, 42 insertions(+), 34 deletions(-)

diff --git a/drivers/net/wireless/ti/wl12xx/main.c b/drivers/net/wireless/ti/wl12xx/main.c
index 7974ed5..0d2fdca 100644
--- a/drivers/net/wireless/ti/wl12xx/main.c
+++ b/drivers/net/wireless/ti/wl12xx/main.c
@@ -1449,10 +1449,8 @@ static int __devinit wl12xx_probe(struct platform_device *pdev)
 	wl->hw_min_ht_rate = WL12XX_CONF_HW_RXTX_RATE_MCS0;
 	wl->fw_status_priv_len = 0;
 	wl->stats.fw_stats_len = sizeof(struct wl12xx_acx_statistics);
-	memcpy(&wl->ht_cap[IEEE80211_BAND_2GHZ], &wl12xx_ht_cap,
-	       sizeof(wl12xx_ht_cap));
-	memcpy(&wl->ht_cap[IEEE80211_BAND_5GHZ], &wl12xx_ht_cap,
-	       sizeof(wl12xx_ht_cap));
+	wlcore_set_ht_cap(wl, IEEE80211_BAND_2GHZ, &wl12xx_ht_cap);
+	wlcore_set_ht_cap(wl, IEEE80211_BAND_5GHZ, &wl12xx_ht_cap);
 	wl12xx_conf_init(wl);
 
 	if (!fref_param) {
diff --git a/drivers/net/wireless/ti/wl18xx/main.c b/drivers/net/wireless/ti/wl18xx/main.c
index 365063b..485aeae 100644
--- a/drivers/net/wireless/ti/wl18xx/main.c
+++ b/drivers/net/wireless/ti/wl18xx/main.c
@@ -43,7 +43,7 @@
 
 #define WL18XX_RX_CHECKSUM_MASK      0x40
 
-static char *ht_mode_param = "wide";
+static char *ht_mode_param = "default";
 static char *board_type_param = "hdk";
 static bool checksum_param = false;
 static bool enable_11a_param = true;
@@ -1286,34 +1286,6 @@ static int __devinit wl18xx_probe(struct platform_device *pdev)
 	if (num_rx_desc_param != -1)
 		wl->num_rx_desc = num_rx_desc_param;
 
-	if (!strcmp(ht_mode_param, "wide")) {
-		memcpy(&wl->ht_cap[IEEE80211_BAND_2GHZ],
-		       &wl18xx_siso40_ht_cap,
-		       sizeof(wl18xx_siso40_ht_cap));
-		memcpy(&wl->ht_cap[IEEE80211_BAND_5GHZ],
-		       &wl18xx_siso40_ht_cap,
-		       sizeof(wl18xx_siso40_ht_cap));
-	} else if (!strcmp(ht_mode_param, "mimo")) {
-		memcpy(&wl->ht_cap[IEEE80211_BAND_2GHZ],
-		       &wl18xx_mimo_ht_cap_2ghz,
-		       sizeof(wl18xx_mimo_ht_cap_2ghz));
-		/* we don't support MIMO in 5Ghz */
-		memcpy(&wl->ht_cap[IEEE80211_BAND_5GHZ],
-		       &wl18xx_siso20_ht_cap,
-		       sizeof(wl18xx_siso20_ht_cap));
-	} else if (!strcmp(ht_mode_param, "siso20")) {
-		memcpy(&wl->ht_cap[IEEE80211_BAND_2GHZ],
-		       &wl18xx_siso20_ht_cap,
-		       sizeof(wl18xx_siso20_ht_cap));
-		memcpy(&wl->ht_cap[IEEE80211_BAND_5GHZ],
-		       &wl18xx_siso20_ht_cap,
-		       sizeof(wl18xx_siso20_ht_cap));
-	} else {
-		wl1271_error("invalid ht_mode '%s'", ht_mode_param);
-		ret = -EINVAL;
-		goto out_free;
-	}
-
 	ret = wl18xx_conf_init(wl, &pdev->dev);
 	if (ret < 0)
 		goto out_free;
@@ -1359,6 +1331,37 @@ static int __devinit wl18xx_probe(struct platform_device *pdev)
 	if (dc2dc_param != -1)
 		priv->conf.phy.external_pa_dc2dc = dc2dc_param;
 
+	if (!strcmp(ht_mode_param, "default")) {
+		/*
+		 * Only support mimo with multiple antennas. Fall back to
+		 * siso20.
+		 */
+		if (priv->conf.phy.number_of_assembled_ant2_4 >= 2)
+			wlcore_set_ht_cap(wl, IEEE80211_BAND_2GHZ,
+					  &wl18xx_mimo_ht_cap_2ghz);
+		else
+			wlcore_set_ht_cap(wl, IEEE80211_BAND_2GHZ,
+					  &wl18xx_siso20_ht_cap);
+
+		/* 5Ghz is always wide */
+		wlcore_set_ht_cap(wl, IEEE80211_BAND_5GHZ,
+				  &wl18xx_siso40_ht_cap);
+	} else if (!strcmp(ht_mode_param, "wide")) {
+		wlcore_set_ht_cap(wl, IEEE80211_BAND_2GHZ,
+				  &wl18xx_siso40_ht_cap);
+		wlcore_set_ht_cap(wl, IEEE80211_BAND_5GHZ,
+				  &wl18xx_siso40_ht_cap);
+	} else if (!strcmp(ht_mode_param, "siso20")) {
+		wlcore_set_ht_cap(wl, IEEE80211_BAND_2GHZ,
+				  &wl18xx_siso20_ht_cap);
+		wlcore_set_ht_cap(wl, IEEE80211_BAND_5GHZ,
+				  &wl18xx_siso20_ht_cap);
+	} else {
+		wl1271_error("invalid ht_mode '%s'", ht_mode_param);
+		ret = -EINVAL;
+		goto out_free;
+	}
+
 	if (!checksum_param) {
 		wl18xx_ops.set_rx_csum = NULL;
 		wl18xx_ops.init_vif = NULL;
@@ -1403,7 +1406,7 @@ static void __exit wl18xx_exit(void)
 module_exit(wl18xx_exit);
 
 module_param_named(ht_mode, ht_mode_param, charp, S_IRUSR);
-MODULE_PARM_DESC(ht_mode, "Force HT mode: wide (default), mimo or siso20");
+MODULE_PARM_DESC(ht_mode, "Force HT mode: wide or siso20");
 
 module_param_named(board_type, board_type_param, charp, S_IRUSR);
 MODULE_PARM_DESC(board_type, "Board type: fpga, hdk (default), evb, com8 or "
diff --git a/drivers/net/wireless/ti/wlcore/wlcore.h b/drivers/net/wireless/ti/wlcore/wlcore.h
index eae8edc..205d8ad 100644
--- a/drivers/net/wireless/ti/wlcore/wlcore.h
+++ b/drivers/net/wireless/ti/wlcore/wlcore.h
@@ -401,6 +401,13 @@ int wlcore_set_key(struct wl1271 *wl, enum set_key_cmd cmd,
 		   struct ieee80211_sta *sta,
 		   struct ieee80211_key_conf *key_conf);
 
+static inline void
+wlcore_set_ht_cap(struct wl1271 *wl, enum ieee80211_band band,
+		  struct ieee80211_sta_ht_cap *ht_cap)
+{
+	memcpy(&wl->ht_cap[band], ht_cap, sizeof(*ht_cap));
+}
+
 /* Firmware image load chunk size */
 #define CHUNK_SIZE	16384
 
-- 
1.7.10

