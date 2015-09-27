Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-la0-f43.google.com ([209.85.215.43]:35338 "EHLO
	mail-la0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752771AbbI0TbB (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 27 Sep 2015 15:31:01 -0400
From: Mateusz Kulikowski <mateusz.kulikowski@gmail.com>
To: Larry.Finger@lwfinger.net, Jes.Sorensen@redhat.com
Cc: Mateusz Kulikowski <mateusz.kulikowski@gmail.com>,
	gregkh@linuxfoundation.org, linux-wireless@vger.kernel.org,
	devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
Subject: [PATCH] staging: rtl8723au: Fix resource leak
Date: Sun, 27 Sep 2015 21:30:54 +0200
Message-Id: <1443382254-7358-1-git-send-email-mateusz.kulikowski@gmail.com> (sfid-20150927_213123_502995_3645B277)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Firmware was not released properly if kmemdup fails.

Addresses-Coverity-Id: 1269118
Signed-off-by: Mateusz Kulikowski <mateusz.kulikowski@gmail.com>
---
 drivers/staging/rtl8723au/hal/rtl8723a_hal_init.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/staging/rtl8723au/hal/rtl8723a_hal_init.c b/drivers/staging/rtl8723au/hal/rtl8723a_hal_init.c
index cd014f7..87bb87f 100644
--- a/drivers/staging/rtl8723au/hal/rtl8723a_hal_init.c
+++ b/drivers/staging/rtl8723au/hal/rtl8723a_hal_init.c
@@ -249,13 +249,13 @@ int rtl8723a_FirmwareDownload(struct rtw_adapter *padapter)
 		goto Exit;
 	}
 	firmware_buf = kmemdup(fw->data, fw->size, GFP_KERNEL);
+	release_firmware(fw);
 	if (!firmware_buf) {
 		rtStatus = _FAIL;
 		goto Exit;
 	}
 	buf = firmware_buf;
 	fw_size = fw->size;
-	release_firmware(fw);
 
 	/*  To Check Fw header. Added by tynli. 2009.12.04. */
 	pFwHdr = (struct rt_8723a_firmware_hdr *)firmware_buf;
-- 
2.1.4

