Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wr0-f195.google.com ([209.85.128.195]:36252 "EHLO
        mail-wr0-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751519AbdEMQli (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Sat, 13 May 2017 12:41:38 -0400
Received: by mail-wr0-f195.google.com with SMTP id v42so10222127wrc.3
        for <linux-wireless@vger.kernel.org>; Sat, 13 May 2017 09:41:38 -0700 (PDT)
From: Malcolm Priestley <tvboxspy@gmail.com>
To: gregkh@linuxfoundation.org
Cc: linux-wireless@vger.kernel.org, devel@driverdev.osuosl.org,
        Malcolm Priestley <tvboxspy@gmail.com>
Subject: [PATCH 3/5] staging: rtl8192e: HTSetConnectBwMode message replace with debug.
Date: Sat, 13 May 2017 17:41:19 +0100
Message-Id: <20170513164121.14373-3-tvboxspy@gmail.com> (sfid-20170513_184150_663871_059DCB83)
In-Reply-To: <20170513164121.14373-1-tvboxspy@gmail.com>
References: <20170513164121.14373-1-tvboxspy@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The flag status of bCurBW40MHz is printed as info and is
only useful as debug message.

Replace with netdev_dbg in line with rest of driver.

Signed-off-by: Malcolm Priestley <tvboxspy@gmail.com>
---
 drivers/staging/rtl8192e/rtl819x_HTProc.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/staging/rtl8192e/rtl819x_HTProc.c b/drivers/staging/rtl8192e/rtl819x_HTProc.c
index 4ae1d382ac5c..f0e11726a72a 100644
--- a/drivers/staging/rtl8192e/rtl819x_HTProc.c
+++ b/drivers/staging/rtl8192e/rtl819x_HTProc.c
@@ -908,8 +908,8 @@ void HTSetConnectBwMode(struct rtllib_device *ieee,
 		pHTInfo->CurSTAExtChnlOffset = HT_EXTCHNL_OFFSET_NO_EXT;
 	}
 
-	pr_info("%s():pHTInfo->bCurBW40MHz:%x\n", __func__,
-	       pHTInfo->bCurBW40MHz);
+	netdev_dbg(ieee->dev, "%s():pHTInfo->bCurBW40MHz:%x\n", __func__,
+		   pHTInfo->bCurBW40MHz);
 
 	pHTInfo->bSwBwInProgress = true;
 
-- 
2.11.0
