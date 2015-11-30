Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-qg0-f65.google.com ([209.85.192.65]:35159 "EHLO
	mail-qg0-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755355AbbK3XkO (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 30 Nov 2015 18:40:14 -0500
Received: by qgea14 with SMTP id a14so15193453qge.2
        for <linux-wireless@vger.kernel.org>; Mon, 30 Nov 2015 15:40:14 -0800 (PST)
From: "Mario J. Rugiero" <mrugiero@gmail.com>
To: devel@driverdev.osuosl.org
Cc: mrugiero@gmail.com, gregkh@linuxfoundation.org,
	linux-wireless@vger.kernel.org, johnny.kim@atmel.com,
	austin.shin@atmel.com, chris.park@atmel.com, tony.cho@atmel.com,
	glen.lee@atmel.com, leo.kim@atmel.com
Subject: [PATCH] [sparse-cleanup] Fix incompatible type comparison in wilc1000/host_interface.c
Date: Mon, 30 Nov 2015 20:40:06 -0300
Message-Id: <1448926806-2979-1-git-send-email-mrugiero@gmail.com> (sfid-20151201_004027_706760_FA3B0775)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Signed-off-by: Mario J. Rugiero <mrugiero@gmail.com>
---
 drivers/staging/wilc1000/host_interface.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/staging/wilc1000/host_interface.c b/drivers/staging/wilc1000/host_interface.c
index d5b7725..9ce1d22 100644
--- a/drivers/staging/wilc1000/host_interface.c
+++ b/drivers/staging/wilc1000/host_interface.c
@@ -2270,7 +2270,7 @@ static void Handle_AddBeacon(struct host_if_drv *hif_drv,
 	*pu8CurrByte++ = ((pstrSetBeaconParam->tail_len >> 16) & 0xFF);
 	*pu8CurrByte++ = ((pstrSetBeaconParam->tail_len >> 24) & 0xFF);
 
-	if (pstrSetBeaconParam->tail > 0)
+	if (pstrSetBeaconParam->tail != NULL)
 		memcpy(pu8CurrByte, pstrSetBeaconParam->tail, pstrSetBeaconParam->tail_len);
 	pu8CurrByte += pstrSetBeaconParam->tail_len;
 
-- 
2.6.2

