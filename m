Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from esa6.microchip.iphmx.com ([216.71.154.253]:24702 "EHLO
        esa6.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752103AbeAPODT (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 16 Jan 2018 09:03:19 -0500
From: Ajay Singh <ajay.kathat@microchip.com>
To: <linux-wireless@vger.kernel.org>
CC: <devel@driverdev.osuosl.org>, <gregkh@linuxfoundation.org>,
        <ganesh.krishna@microchip.com>, <venkateswara.kaja@microchip.com>,
        <aditya.shankar@microchip.com>, <claudiu.beznea@microchip.com>,
        Ajay Singh <ajay.kathat@microchip.com>
Subject: [PATCH 11/13] staging: wilc1000: rename strStaParams variable to avoid camelCase
Date: Tue, 16 Jan 2018 19:32:29 +0530
Message-ID: <1516111351-5353-12-git-send-email-ajay.kathat@microchip.com> (sfid-20180116_150325_183551_01617171)
In-Reply-To: <1516111351-5353-1-git-send-email-ajay.kathat@microchip.com>
References: <1516111351-5353-1-git-send-email-ajay.kathat@microchip.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This is a cleanup patch to rename strStaParams to sta_params to avoid
camelCase.
Changes fix "Avoid camelCase" issue reported by checkpatch.pl
script.

Signed-off-by: Ajay Singh <ajay.kathat@microchip.com>
---
 drivers/staging/wilc1000/wilc_wfi_cfgoperations.c | 44 +++++++++++------------
 1 file changed, 22 insertions(+), 22 deletions(-)

diff --git a/drivers/staging/wilc1000/wilc_wfi_cfgoperations.c b/drivers/staging/wilc1000/wilc_wfi_cfgoperations.c
index b68f46c..81f943d 100644
--- a/drivers/staging/wilc1000/wilc_wfi_cfgoperations.c
+++ b/drivers/staging/wilc1000/wilc_wfi_cfgoperations.c
@@ -1959,7 +1959,7 @@ static int add_station(struct wiphy *wiphy, struct net_device *dev,
 {
 	s32 ret = 0;
 	struct wilc_priv *priv;
-	struct add_sta_param strStaParams = { {0} };
+	struct add_sta_param sta_params = { {0} };
 	struct wilc_vif *vif;
 
 	if (!wiphy)
@@ -1969,23 +1969,23 @@ static int add_station(struct wiphy *wiphy, struct net_device *dev,
 	vif = netdev_priv(dev);
 
 	if (vif->iftype == AP_MODE || vif->iftype == GO_MODE) {
-		memcpy(strStaParams.bssid, mac, ETH_ALEN);
+		memcpy(sta_params.bssid, mac, ETH_ALEN);
 		memcpy(priv->assoc_stainfo.sta_associated_bss[params->aid], mac, ETH_ALEN);
-		strStaParams.aid = params->aid;
-		strStaParams.rates_len = params->supported_rates_len;
-		strStaParams.rates = params->supported_rates;
+		sta_params.aid = params->aid;
+		sta_params.rates_len = params->supported_rates_len;
+		sta_params.rates = params->supported_rates;
 
 		if (!params->ht_capa) {
-			strStaParams.ht_supported = false;
+			sta_params.ht_supported = false;
 		} else {
-			strStaParams.ht_supported = true;
-			strStaParams.ht_capa = *params->ht_capa;
+			sta_params.ht_supported = true;
+			sta_params.ht_capa = *params->ht_capa;
 		}
 
-		strStaParams.flags_mask = params->sta_flags_mask;
-		strStaParams.flags_set = params->sta_flags_set;
+		sta_params.flags_mask = params->sta_flags_mask;
+		sta_params.flags_set = params->sta_flags_set;
 
-		ret = wilc_add_station(vif, &strStaParams);
+		ret = wilc_add_station(vif, &sta_params);
 		if (ret)
 			netdev_err(dev, "Host add station fail\n");
 	}
@@ -2025,7 +2025,7 @@ static int change_station(struct wiphy *wiphy, struct net_device *dev,
 {
 	s32 ret = 0;
 	struct wilc_priv *priv;
-	struct add_sta_param strStaParams = { {0} };
+	struct add_sta_param sta_params = { {0} };
 	struct wilc_vif *vif;
 
 	if (!wiphy)
@@ -2035,22 +2035,22 @@ static int change_station(struct wiphy *wiphy, struct net_device *dev,
 	vif = netdev_priv(dev);
 
 	if (vif->iftype == AP_MODE || vif->iftype == GO_MODE) {
-		memcpy(strStaParams.bssid, mac, ETH_ALEN);
-		strStaParams.aid = params->aid;
-		strStaParams.rates_len = params->supported_rates_len;
-		strStaParams.rates = params->supported_rates;
+		memcpy(sta_params.bssid, mac, ETH_ALEN);
+		sta_params.aid = params->aid;
+		sta_params.rates_len = params->supported_rates_len;
+		sta_params.rates = params->supported_rates;
 
 		if (!params->ht_capa) {
-			strStaParams.ht_supported = false;
+			sta_params.ht_supported = false;
 		} else {
-			strStaParams.ht_supported = true;
-			strStaParams.ht_capa = *params->ht_capa;
+			sta_params.ht_supported = true;
+			sta_params.ht_capa = *params->ht_capa;
 		}
 
-		strStaParams.flags_mask = params->sta_flags_mask;
-		strStaParams.flags_set = params->sta_flags_set;
+		sta_params.flags_mask = params->sta_flags_mask;
+		sta_params.flags_set = params->sta_flags_set;
 
-		ret = wilc_edit_station(vif, &strStaParams);
+		ret = wilc_edit_station(vif, &sta_params);
 		if (ret)
 			netdev_err(dev, "Host edit station fail\n");
 	}
-- 
2.7.4
