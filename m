Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-we0-f176.google.com ([74.125.82.176]:50191 "EHLO
	mail-we0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752856Ab3LIXIm (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 9 Dec 2013 18:08:42 -0500
Received: by mail-we0-f176.google.com with SMTP id w62so4114402wes.7
        for <linux-wireless@vger.kernel.org>; Mon, 09 Dec 2013 15:08:40 -0800 (PST)
Message-ID: <1386630515.14057.12.camel@canaries64-MCP7A> (sfid-20131210_000845_838210_BF42B3FE)
Subject: [PATCH] staging: vt6656: Move double definition of MAX_RATE to
 device_cfg.h
From: Malcolm Priestley <tvboxspy@gmail.com>
To: gregkh@linuxfoundation.org
Cc: linux-wireless@vger.kernel.org
Date: Mon, 09 Dec 2013 23:08:35 +0000
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


Signed-off-by: Malcolm Priestley <tvboxspy@gmail.com>
---
 drivers/staging/vt6656/datarate.h   | 1 -
 drivers/staging/vt6656/device_cfg.h | 2 ++
 drivers/staging/vt6656/mib.h        | 1 -
 3 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/staging/vt6656/datarate.h b/drivers/staging/vt6656/datarate.h
index 43cb778..96252ad 100644
--- a/drivers/staging/vt6656/datarate.h
+++ b/drivers/staging/vt6656/datarate.h
@@ -52,7 +52,6 @@
 #define RATE_48M       10
 #define RATE_54M       11
 #define RATE_AUTO      12
-#define MAX_RATE       12
 
 void RATEvParseMaxRate(struct vnt_private *, PWLAN_IE_SUPP_RATES pItemRates,
 	PWLAN_IE_SUPP_RATES pItemExtRates, int bUpdateBasicRate,
diff --git a/drivers/staging/vt6656/device_cfg.h b/drivers/staging/vt6656/device_cfg.h
index a97f7bb..0b9d834 100644
--- a/drivers/staging/vt6656/device_cfg.h
+++ b/drivers/staging/vt6656/device_cfg.h
@@ -65,6 +65,8 @@ struct _version {
 #define DEVICE_VERSION       "1.19_12"
 #endif
 
+#define MAX_RATE	12
+
 /* config file */
 #include <linux/fs.h>
 #include <linux/fcntl.h>
diff --git a/drivers/staging/vt6656/mib.h b/drivers/staging/vt6656/mib.h
index 5616b9a..c342dad 100644
--- a/drivers/staging/vt6656/mib.h
+++ b/drivers/staging/vt6656/mib.h
@@ -222,7 +222,6 @@ typedef struct tagSTxPktInfo {
     u8    abyDestAddr[ETH_ALEN];
 } STxPktInfo, *PSTxPktInfo;
 
-#define MAX_RATE            12
 //
 // statistic counter
 //
-- 
1.8.3.2

