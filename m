Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-qg0-f67.google.com ([209.85.192.67]:35959 "EHLO
	mail-qg0-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754418AbbLAAJJ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 30 Nov 2015 19:09:09 -0500
Received: by qgcc31 with SMTP id c31so15227889qgc.3
        for <linux-wireless@vger.kernel.org>; Mon, 30 Nov 2015 16:09:09 -0800 (PST)
From: "Mario J. Rugiero" <mrugiero@gmail.com>
To: devel@driverdev.osuosl.org
Cc: mrugiero@gmail.com, gregkh@linuxfoundation.org,
	linux-wireless@vger.kernel.org, johnny.kim@atmel.com,
	austin.shin@atmel.com, chris.park@atmel.com, tony.cho@atmel.com,
	glen.lee@atmel.com, leo.kim@atmel.com
Subject: [PATCH 1/1] staging: cleanup: Fix incompatible type comparison in wilc1000/host_interface.c
Date: Mon, 30 Nov 2015 21:09:04 -0300
Message-Id: <1448928544-3534-1-git-send-email-mrugiero@gmail.com> (sfid-20151201_010914_426611_27E8F8C9)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This patch replaces an "if (ptr > 0)" comparison that seems to be a
confusing way to check for null by a simpler "if (ptr)" check.

Signed-off-by: Mario J. Rugiero <mrugiero@gmail.com>
---
 drivers/staging/wilc1000/host_interface.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/staging/wilc1000/host_interface.c b/drivers/staging/wilc1000/host_interface.c
index d5b7725..0c87f6c 100644
--- a/drivers/staging/wilc1000/host_interface.c
+++ b/drivers/staging/wilc1000/host_interface.c
@@ -2270,7 +2270,7 @@ static void Handle_AddBeacon(struct host_if_drv *hif_drv,
 	*pu8CurrByte++ = ((pstrSetBeaconParam->tail_len >> 16) & 0xFF);
 	*pu8CurrByte++ = ((pstrSetBeaconParam->tail_len >> 24) & 0xFF);
 
-	if (pstrSetBeaconParam->tail > 0)
+	if (pstrSetBeaconParam->tail)
 		memcpy(pu8CurrByte, pstrSetBeaconParam->tail, pstrSetBeaconParam->tail_len);
 	pu8CurrByte += pstrSetBeaconParam->tail_len;
 
-- 
2.6.2

