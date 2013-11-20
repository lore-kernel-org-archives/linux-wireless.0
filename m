Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pd0-f180.google.com ([209.85.192.180]:40653 "EHLO
	mail-pd0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752932Ab3KTJ5Z (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 20 Nov 2013 04:57:25 -0500
Received: by mail-pd0-f180.google.com with SMTP id q10so4185007pdj.25
        for <linux-wireless@vger.kernel.org>; Wed, 20 Nov 2013 01:57:22 -0800 (PST)
From: Chun-Yeow Yeoh <yeohchunyeow@gmail.com>
To: linux-wireless@vger.kernel.org
Cc: k.eugene.e@gmail.com, linville@tuxdriver.com,
	wcn36xx@lists.infradead.org,
	Chun-Yeow Yeoh <yeohchunyeow@gmail.com>
Subject: [PATCH v2] wcn36xx: set self STA default HT parameters
Date: Wed, 20 Nov 2013 17:57:01 +0800
Message-Id: <1384941421-8786-1-git-send-email-yeohchunyeow@gmail.com> (sfid-20131120_105739_983209_D51F2989)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

These default HT parameters are required for self STA entry.
In example, set the HT capable of self STA entry for bss
configuration in mesh allows the MCS rate to be used. Otherwise,
only legacy rate will be used.

Signed-off-by: Chun-Yeow Yeoh <yeohchunyeow@gmail.com>
---
v2: set all the default self STA HT parameters (Eugene Krasnikov)

 drivers/net/wireless/ath/wcn36xx/smd.c |   17 +++++++++++++++++
 1 file changed, 17 insertions(+)

diff --git a/drivers/net/wireless/ath/wcn36xx/smd.c b/drivers/net/wireless/ath/wcn36xx/smd.c
index 19f43de..2f58a7d 100644
--- a/drivers/net/wireless/ath/wcn36xx/smd.c
+++ b/drivers/net/wireless/ath/wcn36xx/smd.c
@@ -115,6 +115,22 @@ static void wcn36xx_smd_set_sta_ht_params(struct ieee80211_sta *sta,
 	}
 }
 
+static void wcn36xx_smd_set_sta_default_ht_params(
+		struct wcn36xx_hal_config_sta_params *sta_params)
+{
+	sta_params->ht_capable = 1;
+	sta_params->tx_channel_width_set = 1;
+	sta_params->lsig_txop_protection = 1;
+	sta_params->max_ampdu_size = 3;
+	sta_params->max_ampdu_density = 5;
+	sta_params->max_amsdu_size = 0;
+	sta_params->sgi_20Mhz = 1;
+	sta_params->sgi_40mhz = 1;
+	sta_params->green_field_capable = 1;
+	sta_params->delayed_ba_support = 0;
+	sta_params->dsss_cck_mode_40mhz = 1;
+}
+
 static void wcn36xx_smd_set_sta_params(struct wcn36xx *wcn,
 		struct ieee80211_vif *vif,
 		struct ieee80211_sta *sta,
@@ -172,6 +188,7 @@ static void wcn36xx_smd_set_sta_params(struct wcn36xx *wcn,
 			sizeof(priv_sta->supported_rates));
 	} else {
 		wcn36xx_set_default_rates(&sta_params->supported_rates);
+		wcn36xx_smd_set_sta_default_ht_params(sta_params);
 	}
 }
 
-- 
1.7.9.5

