Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from na3sys009aog104.obsmtp.com ([74.125.149.73]:57669 "EHLO
	na3sys009aog104.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756921Ab2FUONg (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 21 Jun 2012 10:13:36 -0400
Received: by lbon10 with SMTP id n10so3708592lbo.27
        for <linux-wireless@vger.kernel.org>; Thu, 21 Jun 2012 07:13:32 -0700 (PDT)
From: Luciano Coelho <coelho@ti.com>
To: linux-wireless@vger.kernel.org
Cc: coelho@ti.com, arik@wizery.com
Subject: [PATCH 11/12] wl18xx: split siso40 HT cap between 2Ghz and 5Ghz
Date: Thu, 21 Jun 2012 17:13:10 +0300
Message-Id: <1340287991-15241-12-git-send-email-coelho@ti.com> (sfid-20120621_161416_690993_57C9E92B)
In-Reply-To: <1340287991-15241-1-git-send-email-coelho@ti.com>
References: <1340287991-15241-1-git-send-email-coelho@ti.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Arik Nemtsov <arik@wizery.com>

Remove the cap IEEE80211_HT_CAP_DSSSCCK40 from the 5Ghz variant of
the siso40 HT capabilities. It is meaningless in 5Ghz.

Signed-off-by: Arik Nemtsov <arik@wizery.com>
Signed-off-by: Luciano Coelho <coelho@ti.com>
---
 drivers/net/wireless/ti/wl18xx/main.c |   24 +++++++++++++++++++-----
 1 file changed, 19 insertions(+), 5 deletions(-)

diff --git a/drivers/net/wireless/ti/wl18xx/main.c b/drivers/net/wireless/ti/wl18xx/main.c
index 485aeae..2c0f51b 100644
--- a/drivers/net/wireless/ti/wl18xx/main.c
+++ b/drivers/net/wireless/ti/wl18xx/main.c
@@ -1215,8 +1215,8 @@ static struct wlcore_ops wl18xx_ops = {
 	.pre_pkt_send	= wl18xx_pre_pkt_send,
 };
 
-/* HT cap appropriate for wide channels */
-static struct ieee80211_sta_ht_cap wl18xx_siso40_ht_cap = {
+/* HT cap appropriate for wide channels in 2Ghz */
+static struct ieee80211_sta_ht_cap wl18xx_siso40_ht_cap_2ghz = {
 	.cap = IEEE80211_HT_CAP_SGI_20 | IEEE80211_HT_CAP_SGI_40 |
 	       IEEE80211_HT_CAP_SUP_WIDTH_20_40 | IEEE80211_HT_CAP_DSSSCCK40,
 	.ht_supported = true,
@@ -1229,6 +1229,20 @@ static struct ieee80211_sta_ht_cap wl18xx_siso40_ht_cap = {
 		},
 };
 
+/* HT cap appropriate for wide channels in 5Ghz */
+static struct ieee80211_sta_ht_cap wl18xx_siso40_ht_cap_5ghz = {
+	.cap = IEEE80211_HT_CAP_SGI_20 | IEEE80211_HT_CAP_SGI_40 |
+	       IEEE80211_HT_CAP_SUP_WIDTH_20_40,
+	.ht_supported = true,
+	.ampdu_factor = IEEE80211_HT_MAX_AMPDU_16K,
+	.ampdu_density = IEEE80211_HT_MPDU_DENSITY_16,
+	.mcs = {
+		.rx_mask = { 0xff, 0, 0, 0, 0, 0, 0, 0, 0, 0, },
+		.rx_highest = cpu_to_le16(150),
+		.tx_params = IEEE80211_HT_MCS_TX_DEFINED,
+		},
+};
+
 /* HT cap appropriate for SISO 20 */
 static struct ieee80211_sta_ht_cap wl18xx_siso20_ht_cap = {
 	.cap = IEEE80211_HT_CAP_SGI_20,
@@ -1345,12 +1359,12 @@ static int __devinit wl18xx_probe(struct platform_device *pdev)
 
 		/* 5Ghz is always wide */
 		wlcore_set_ht_cap(wl, IEEE80211_BAND_5GHZ,
-				  &wl18xx_siso40_ht_cap);
+				  &wl18xx_siso40_ht_cap_5ghz);
 	} else if (!strcmp(ht_mode_param, "wide")) {
 		wlcore_set_ht_cap(wl, IEEE80211_BAND_2GHZ,
-				  &wl18xx_siso40_ht_cap);
+				  &wl18xx_siso40_ht_cap_2ghz);
 		wlcore_set_ht_cap(wl, IEEE80211_BAND_5GHZ,
-				  &wl18xx_siso40_ht_cap);
+				  &wl18xx_siso40_ht_cap_5ghz);
 	} else if (!strcmp(ht_mode_param, "siso20")) {
 		wlcore_set_ht_cap(wl, IEEE80211_BAND_2GHZ,
 				  &wl18xx_siso20_ht_cap);
-- 
1.7.10

