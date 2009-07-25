Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ew0-f226.google.com ([209.85.219.226]:64463 "EHLO
	mail-ew0-f226.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752627AbZGYU76 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 25 Jul 2009 16:59:58 -0400
Received: by ewy26 with SMTP id 26so2428129ewy.37
        for <linux-wireless@vger.kernel.org>; Sat, 25 Jul 2009 13:59:58 -0700 (PDT)
Message-ID: <4A6B72E8.3060500@gmail.com>
Date: Sat, 25 Jul 2009 23:02:32 +0200
From: Roel Kluin <roel.kluin@gmail.com>
MIME-Version: 1.0
To: linville@tuxdriver.com, linux-wireless@vger.kernel.org,
	Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH] airo: Buffer overflow
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

SSID_rid has space for only 3 ssids. 
txPowerLevels[i] is read before the bounds check for i

Signed-off-by: Roel Kluin <roel.kluin@gmail.com>
---
diff --git a/drivers/net/wireless/airo.c b/drivers/net/wireless/airo.c
index c70604f..8ce5e4c 100644
--- a/drivers/net/wireless/airo.c
+++ b/drivers/net/wireless/airo.c
@@ -5918,20 +5918,19 @@ static int airo_set_essid(struct net_device *dev,
 	readSsidRid(local, &SSID_rid);
 
 	/* Check if we asked for `any' */
-	if(dwrq->flags == 0) {
+	if (dwrq->flags == 0) {
 		/* Just send an empty SSID list */
 		memset(&SSID_rid, 0, sizeof(SSID_rid));
 	} else {
-		int	index = (dwrq->flags & IW_ENCODE_INDEX) - 1;
+		unsigned index = (dwrq->flags & IW_ENCODE_INDEX) - 1;
 
 		/* Check the size of the string */
-		if(dwrq->length > IW_ESSID_MAX_SIZE) {
+		if (dwrq->length > IW_ESSID_MAX_SIZE)
 			return -E2BIG ;
-		}
+
 		/* Check if index is valid */
-		if((index < 0) || (index >= 4)) {
+		if (index >= ARRAY_SIZE(SSID_rid.ssids))
 			return -EINVAL;
-		}
 
 		/* Set the SSID */
 		memset(SSID_rid.ssids[index].ssid, 0,
@@ -6819,7 +6818,7 @@ static int airo_set_txpow(struct net_device *dev,
 		return -EINVAL;
 	}
 	clear_bit (FLAG_RADIO_OFF, &local->flags);
-	for (i = 0; cap_rid.txPowerLevels[i] && (i < 8); i++)
+	for (i = 0; i < 8 && cap_rid.txPowerLevels[i]; i++)
 		if (v == cap_rid.txPowerLevels[i]) {
 			readConfigRid(local, 1);
 			local->config.txPower = v;
