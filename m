Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-la0-f49.google.com ([209.85.215.49]:32808 "EHLO
	mail-la0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752615AbbI0TsZ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 27 Sep 2015 15:48:25 -0400
From: Mateusz Kulikowski <mateusz.kulikowski@gmail.com>
To: Larry.Finger@lwfinger.net, Jes.Sorensen@redhat.com
Cc: Mateusz Kulikowski <mateusz.kulikowski@gmail.com>,
	gregkh@linuxfoundation.org, linux-wireless@vger.kernel.org,
	devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
Subject: [PATCH v2] staging: rtl8723au: Fix resource leak
Date: Sun, 27 Sep 2015 21:48:19 +0200
Message-Id: <1443383299-2634-1-git-send-email-mateusz.kulikowski@gmail.com> (sfid-20150927_214841_409638_A0A3F01D)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Firmware was not released properly if kmemdup fails.

Addresses-Coverity-Id: 1269118
Signed-off-by: Mateusz Kulikowski <mateusz.kulikowski@gmail.com>
---
 drivers/staging/rtl8723au/hal/rtl8723a_hal_init.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/staging/rtl8723au/hal/rtl8723a_hal_init.c b/drivers/staging/rtl8723au/hal/rtl8723a_hal_init.c
index cd014f7..ecf54ee 100644
--- a/drivers/staging/rtl8723au/hal/rtl8723a_hal_init.c
+++ b/drivers/staging/rtl8723au/hal/rtl8723a_hal_init.c
@@ -249,13 +249,13 @@ int rtl8723a_FirmwareDownload(struct rtw_adapter *padapter)
 		goto Exit;
 	}
 	firmware_buf = kmemdup(fw->data, fw->size, GFP_KERNEL);
+	fw_size = fw->size;
+	release_firmware(fw);
 	if (!firmware_buf) {
 		rtStatus = _FAIL;
 		goto Exit;
 	}
 	buf = firmware_buf;
-	fw_size = fw->size;
-	release_firmware(fw);
 
 	/*  To Check Fw header. Added by tynli. 2009.12.04. */
 	pFwHdr = (struct rt_8723a_firmware_hdr *)firmware_buf;
-- 
2.1.4

