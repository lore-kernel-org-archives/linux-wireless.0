Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pa0-f46.google.com ([209.85.220.46]:57517 "EHLO
	mail-pa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751462Ab2KTVyZ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 20 Nov 2012 16:54:25 -0500
Received: by mail-pa0-f46.google.com with SMTP id bh2so1562991pad.19
        for <linux-wireless@vger.kernel.org>; Tue, 20 Nov 2012 13:54:25 -0800 (PST)
From: Stanislav Yakovlev <stas.yakovlev@gmail.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	Stanislav Yakovlev <stas.yakovlev@gmail.com>
Subject: [PATCH] net/wireless: ipw2200: introduce ipw_set_geo function
Date: Tue, 20 Nov 2012 23:54:20 +0000
Message-Id: <1353455660-534-1-git-send-email-stas.yakovlev@gmail.com> (sfid-20121120_225429_528597_60B212D8)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Move regulatory domain initialization code to a separate function.

Signed-off-by: Stanislav Yakovlev <stas.yakovlev@gmail.com>
---
 drivers/net/wireless/ipw2x00/ipw2200.c | 37 +++++++++++++++++++++-------------
 1 file changed, 23 insertions(+), 14 deletions(-)

diff --git a/drivers/net/wireless/ipw2x00/ipw2200.c b/drivers/net/wireless/ipw2x00/ipw2200.c
index fea96b5..482f505 100644
--- a/drivers/net/wireless/ipw2x00/ipw2200.c
+++ b/drivers/net/wireless/ipw2x00/ipw2200.c
@@ -11269,10 +11269,31 @@ static const struct libipw_geo ipw_geos[] = {
 	 }
 };
 
+static void ipw_set_geo(struct ipw_priv *priv)
+{
+	int j;
+
+	for (j = 0; j < ARRAY_SIZE(ipw_geos); j++) {
+		if (!memcmp(&priv->eeprom[EEPROM_COUNTRY_CODE],
+			    ipw_geos[j].name, 3))
+			break;
+	}
+
+	if (j == ARRAY_SIZE(ipw_geos)) {
+		IPW_WARNING("SKU [%c%c%c] not recognized.\n",
+			    priv->eeprom[EEPROM_COUNTRY_CODE + 0],
+			    priv->eeprom[EEPROM_COUNTRY_CODE + 1],
+			    priv->eeprom[EEPROM_COUNTRY_CODE + 2]);
+		j = 0;
+	}
+
+	libipw_set_geo(priv->ieee, &ipw_geos[j]);
+}
+
 #define MAX_HW_RESTARTS 5
 static int ipw_up(struct ipw_priv *priv)
 {
-	int rc, i, j;
+	int rc, i;
 
 	/* Age scan list entries found before suspend */
 	if (priv->suspend_time) {
@@ -11310,19 +11331,7 @@ static int ipw_up(struct ipw_priv *priv)
 		memcpy(priv->net_dev->dev_addr, priv->mac_addr, ETH_ALEN);
 		memcpy(priv->net_dev->perm_addr, priv->mac_addr, ETH_ALEN);
 
-		for (j = 0; j < ARRAY_SIZE(ipw_geos); j++) {
-			if (!memcmp(&priv->eeprom[EEPROM_COUNTRY_CODE],
-				    ipw_geos[j].name, 3))
-				break;
-		}
-		if (j == ARRAY_SIZE(ipw_geos)) {
-			IPW_WARNING("SKU [%c%c%c] not recognized.\n",
-				    priv->eeprom[EEPROM_COUNTRY_CODE + 0],
-				    priv->eeprom[EEPROM_COUNTRY_CODE + 1],
-				    priv->eeprom[EEPROM_COUNTRY_CODE + 2]);
-			j = 0;
-		}
-		libipw_set_geo(priv->ieee, &ipw_geos[j]);
+		ipw_set_geo(priv);
 
 		if (priv->status & STATUS_RF_KILL_SW) {
 			IPW_WARNING("Radio disabled by module parameter.\n");
-- 
1.7.11.7

