Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-qg0-f68.google.com ([209.85.192.68]:33703 "EHLO
	mail-qg0-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752361AbbLCQYL (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 3 Dec 2015 11:24:11 -0500
Received: by qgae107 with SMTP id e107so6569749qga.0
        for <linux-wireless@vger.kernel.org>; Thu, 03 Dec 2015 08:24:10 -0800 (PST)
From: "Mario J. Rugiero" <mrugiero@gmail.com>
To: devel@driverdev.osuosl.org
Cc: mrugiero@gmail.com, gregkh@linuxfoundation.org,
	linux-wireless@vger.kernel.org, johnny.kim@atmel.com,
	austin.shin@atmel.com, chris.park@atmel.com, tony.cho@atmel.com,
	glen.lee@atmel.com, leo.kim@atmel.com
Subject: [PATCH v3] staging: wilc1000: replace 'ptr > 0' check by 'ptr' check.
Date: Thu,  3 Dec 2015 13:24:05 -0300
Message-Id: <1449159845-31751-1-git-send-email-mrugiero@gmail.com> (sfid-20151203_172419_358427_EB98594C)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This silences a sparse warning about incompatible comparisons, while making the
intent of the check a bit clearer.

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
2.6.3

