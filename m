Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pd0-f174.google.com ([209.85.192.174]:39835 "EHLO
	mail-pd0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751914Ab3KSONz (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 19 Nov 2013 09:13:55 -0500
Received: by mail-pd0-f174.google.com with SMTP id y13so1991433pdi.33
        for <linux-wireless@vger.kernel.org>; Tue, 19 Nov 2013 06:13:55 -0800 (PST)
From: Chun-Yeow Yeoh <yeohchunyeow@gmail.com>
To: linux-wireless@vger.kernel.org
Cc: k.eugene.e@gmail.com, linville@tuxdriver.com,
	wcn36xx@lists.infradead.org,
	Chun-Yeow Yeoh <yeohchunyeow@gmail.com>
Subject: [PATCH] wcn36xx: set self sta entry as HT capable
Date: Tue, 19 Nov 2013 22:13:33 +0800
Message-Id: <1384870413-5569-1-git-send-email-yeohchunyeow@gmail.com> (sfid-20131119_151359_451102_C2A1562E)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Set the HT capable for self STA entry for bss configuration. Otherwise,
only legacy rate will be used for transmitting, especially for mesh
mode.

Signed-off-by: Chun-Yeow Yeoh <yeohchunyeow@gmail.com>
---
 drivers/net/wireless/ath/wcn36xx/smd.c |    9 ++++++++-
 1 file changed, 8 insertions(+), 1 deletion(-)

diff --git a/drivers/net/wireless/ath/wcn36xx/smd.c b/drivers/net/wireless/ath/wcn36xx/smd.c
index 19f43de..5160b04 100644
--- a/drivers/net/wireless/ath/wcn36xx/smd.c
+++ b/drivers/net/wireless/ath/wcn36xx/smd.c
@@ -115,6 +115,13 @@ static void wcn36xx_smd_set_sta_ht_params(struct ieee80211_sta *sta,
 	}
 }
 
+static void wcn36xx_smd_set_sta_default_ht_params(
+		struct wcn36xx_hal_config_sta_params *sta_params)
+{
+	wcn36xx_set_default_rates(&sta_params->supported_rates);
+	sta_params->ht_capable = 1;
+}
+
 static void wcn36xx_smd_set_sta_params(struct wcn36xx *wcn,
 		struct ieee80211_vif *vif,
 		struct ieee80211_sta *sta,
@@ -171,7 +178,7 @@ static void wcn36xx_smd_set_sta_params(struct wcn36xx *wcn,
 		memcpy(&sta_params->supported_rates, &priv_sta->supported_rates,
 			sizeof(priv_sta->supported_rates));
 	} else {
-		wcn36xx_set_default_rates(&sta_params->supported_rates);
+		wcn36xx_smd_set_sta_default_ht_params(sta_params);
 	}
 }
 
-- 
1.7.9.5

