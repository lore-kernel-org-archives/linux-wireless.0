Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wi0-f181.google.com ([209.85.212.181]:41535 "EHLO
	mail-wi0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932323AbaFYUVz (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 25 Jun 2014 16:21:55 -0400
Received: by mail-wi0-f181.google.com with SMTP id n3so3232057wiv.2
        for <linux-wireless@vger.kernel.org>; Wed, 25 Jun 2014 13:21:53 -0700 (PDT)
From: Malcolm Priestley <tvboxspy@gmail.com>
To: gregkh@linuxfoundation.org
Cc: linux-wireless@vger.kernel.org,
	Malcolm Priestley <tvboxspy@gmail.com>
Subject: [PATCH 29/34] staging: vt6656: remove old channel tables
Date: Wed, 25 Jun 2014 21:20:06 +0100
Message-Id: <1403727611-6825-30-git-send-email-tvboxspy@gmail.com> (sfid-20140625_222953_784515_073E8D53)
In-Reply-To: <1403727611-6825-1-git-send-email-tvboxspy@gmail.com>
References: <1403727611-6825-1-git-send-email-tvboxspy@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Signed-off-by: Malcolm Priestley <tvboxspy@gmail.com>
---
 drivers/staging/vt6656/channel.c  | 137 --------------------------------------
 drivers/staging/vt6656/channel.h  |   9 ---
 drivers/staging/vt6656/main_usb.c |   2 -
 3 files changed, 148 deletions(-)

diff --git a/drivers/staging/vt6656/channel.c b/drivers/staging/vt6656/channel.c
index db1451e..5202633 100644
--- a/drivers/staging/vt6656/channel.c
+++ b/drivers/staging/vt6656/channel.c
@@ -34,147 +34,10 @@
  *
  */
 
-#include <linux/kernel.h>
 #include "device.h"
 #include "channel.h"
 #include "rf.h"
 
-static SChannelTblElement sChannelTbl[CB_MAX_CHANNEL+1] =
-{
-  {0,   0,    false},
-  {1,   2412, true},
-  {2,   2417, true},
-  {3,   2422, true},
-  {4,   2427, true},
-  {5,   2432, true},
-  {6,   2437, true},
-  {7,   2442, true},
-  {8,   2447, true},
-  {9,   2452, true},
-  {10,  2457, true},
-  {11,  2462, true},
-  {12,  2467, true},
-  {13,  2472, true},
-  {14,  2484, true},
-  {183, 4915, true}, //15
-  {184, 4920, true}, //16
-  {185, 4925, true}, //17
-  {187, 4935, true}, //18
-  {188, 4940, true}, //19
-  {189, 4945, true}, //20
-  {192, 4960, true}, //21
-  {196, 4980, true}, //22
-  {7,   5035, true}, //23
-  {8,   5040, true}, //24
-  {9,   5045, true}, //25
-  {11,  5055, true}, //26
-  {12,  5060, true}, //27
-  {16,  5080, true}, //28
-  {34,  5170, true}, //29
-  {36,  5180, true}, //30
-  {38,  5190, true}, //31
-  {40,  5200, true}, //32
-  {42,  5210, true}, //33
-  {44,  5220, true}, //34
-  {46,  5230, true}, //35
-  {48,  5240, true}, //36
-  {52,  5260, true}, //37
-  {56,  5280, true}, //38
-  {60,  5300, true}, //39
-  {64,  5320, true}, //40
-  {100, 5500, true}, //41
-  {104, 5520, true}, //42
-  {108, 5540, true}, //43
-  {112, 5560, true}, //44
-  {116, 5580, true}, //45
-  {120, 5600, true}, //46
-  {124, 5620, true}, //47
-  {128, 5640, true}, //48
-  {132, 5660, true}, //49
-  {136, 5680, true}, //50
-  {140, 5700, true}, //51
-  {149, 5745, true}, //52
-  {153, 5765, true}, //53
-  {157, 5785, true}, //54
-  {161, 5805, true}, //55
-  {165, 5825, true}  //56
-};
-
-
-/************************************************************************
- * Country Channel Valid
- *  Input:  CountryCode, ChannelNum
- *          ChanneIndex is defined as VT3253 MAC channel:
- *              1   = 2.4G channel 1
- *              2   = 2.4G channel 2
- *              ...
- *              14  = 2.4G channel 14
- *              15  = 4.9G channel 183
- *              16  = 4.9G channel 184
- *              .....
- *  Output: true if the specified 5GHz band is allowed to be used.
-            False otherwise.
-// 4.9G => Ch 183, 184, 185, 187, 188, 189, 192, 196 (Value:15 ~ 22)
-
-// 5G => Ch 7, 8, 9, 11, 12, 16, 34, 36, 38, 40, 42, 44, 46, 48, 52, 56, 60, 64,
-// 100, 104, 108, 112, 116, 120, 124, 128, 132, 136, 140, 149, 153, 157, 161, 165 (Value 23 ~ 56)
- ************************************************************************/
-bool
-ChannelValid(unsigned int CountryCode, unsigned int ChannelIndex)
-{
-    bool    bValid;
-
-    bValid = false;
-    /*
-     * If Channel Index is invalid, return invalid
-     */
-    if ((ChannelIndex > CB_MAX_CHANNEL) ||
-        (ChannelIndex == 0))
-    {
-        bValid = false;
-        goto exit;
-    }
-
-    bValid = sChannelTbl[ChannelIndex].bValid;
-
-exit:
-    return (bValid);
-
-} /* end ChannelValid */
-
-void CHvInitChannelTable(struct vnt_private *pDevice)
-{
-	bool bMultiBand = false;
-	int ii;
-
-    for (ii = 1; ii <= CB_MAX_CHANNEL; ii++)
-	sChannelTbl[ii].bValid = false;
-
-    switch (pDevice->byRFType) {
-        case RF_AL2230:
-        case RF_AL2230S:
-        case RF_VT3226:
-        case RF_VT3226D0:
-            bMultiBand = false;
-            break;
-        case RF_AIROHA7230:
-        case RF_VT3342A0:
-        default :
-            bMultiBand = true;
-            break;
-    }
-
-        if (bMultiBand == true) {
-		for (ii = 0; ii < CB_MAX_CHANNEL; ii++) {
-			sChannelTbl[ii+1].bValid = true;
-		}
-        } else {
-		for (ii = 0; ii < CB_MAX_CHANNEL_24G; ii++) {
-			sChannelTbl[ii+1].bValid = true;
-		}
-        }
-}
-
 static struct ieee80211_rate vnt_rates_bg[] = {
 	{ .bitrate = 10,  .hw_value = RATE_1M },
 	{ .bitrate = 20,  .hw_value = RATE_2M },
diff --git a/drivers/staging/vt6656/channel.h b/drivers/staging/vt6656/channel.h
index 0d52225..21c0808 100644
--- a/drivers/staging/vt6656/channel.h
+++ b/drivers/staging/vt6656/channel.h
@@ -32,15 +32,6 @@
 
 #include "device.h"
 
-typedef struct tagSChannelTblElement {
-    u8    byChannelNumber;
-    unsigned int    uFrequency;
-    bool    bValid;
-} SChannelTblElement, *PSChannelTblElement;
-
-bool    ChannelValid(unsigned int CountryCode, unsigned int ChannelNum);
-void    CHvInitChannelTable(struct vnt_private *pDevice);
-
 void vnt_init_bands(struct vnt_private *);
 
 #endif  /* _CHANNEL_H_ */
diff --git a/drivers/staging/vt6656/main_usb.c b/drivers/staging/vt6656/main_usb.c
index fecdf77..5ce0caa 100644
--- a/drivers/staging/vt6656/main_usb.c
+++ b/drivers/staging/vt6656/main_usb.c
@@ -323,8 +323,6 @@ static int device_init_registers(struct vnt_private *pDevice)
 			pDevice->wCurrentRate = RATE_54M;
 	}
 
-	CHvInitChannelTable(pDevice);
-
 	pDevice->byTopOFDMBasicRate = RATE_24M;
 	pDevice->byTopCCKBasicRate = RATE_1M;
 
-- 
1.9.1

