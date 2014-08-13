Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-vc0-f179.google.com ([209.85.220.179]:36187 "EHLO
	mail-vc0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753868AbaHMCas (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 12 Aug 2014 22:30:48 -0400
Received: by mail-vc0-f179.google.com with SMTP id hq11so14096837vcb.24
        for <linux-wireless@vger.kernel.org>; Tue, 12 Aug 2014 19:30:47 -0700 (PDT)
From: Raphael Silva <rapphil@gmail.com>
To: Larry.Finger@lwfinger.net
Cc: Jes.Sorensen@redhat.com, linux-wireless@vger.kernel.org,
	Raphael Silva <rapphil@gmail.com>
Subject: [PATCH] rtl8723au:type casting corrections
Date: Tue, 12 Aug 2014 23:30:34 -0300
Message-Id: <1407897034-28134-1-git-send-email-rapphil@gmail.com> (sfid-20140813_043114_448368_C22F5FAA)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

 Type casting corrections in order to solve warnings of the sparce static analyser.

Signed-off-by: Raphael Silva <rapphil@gmail.com>
---
 drivers/staging/rtl8723au/hal/usb_halinit.c       | 4 ++--
 drivers/staging/rtl8723au/os_dep/ioctl_cfg80211.c | 2 +-
 2 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/staging/rtl8723au/hal/usb_halinit.c b/drivers/staging/rtl8723au/hal/usb_halinit.c
index b49bf33..969e4f3 100644
--- a/drivers/staging/rtl8723au/hal/usb_halinit.c
+++ b/drivers/staging/rtl8723au/hal/usb_halinit.c
@@ -1228,9 +1228,9 @@ static void Hal_EfuseParsePIDVID_8723AU(struct rtw_adapter *pAdapter,
 	} else {
 		/*  VID, PID */
 		pHalData->EEPROMVID =
-			le16_to_cpu(*(u16 *)&hwinfo[EEPROM_VID_8723AU]);
+			le16_to_cpu(*(__le16 *)&hwinfo[EEPROM_VID_8723AU]);
 		pHalData->EEPROMPID =
-			le16_to_cpu(*(u16 *)&hwinfo[EEPROM_PID_8723AU]);
+			le16_to_cpu(*(__le16 *)&hwinfo[EEPROM_PID_8723AU]);
 	}
 
 	MSG_8723A("EEPROM VID = 0x%4x\n", pHalData->EEPROMVID);
