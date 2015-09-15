Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pa0-f46.google.com ([209.85.220.46]:34054 "EHLO
	mail-pa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751531AbbIOFHS (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 15 Sep 2015 01:07:18 -0400
Received: by padhy16 with SMTP id hy16so164909717pad.1
        for <linux-wireless@vger.kernel.org>; Mon, 14 Sep 2015 22:07:17 -0700 (PDT)
From: Chaehyun Lim <chaehyun.lim@gmail.com>
To: gregkh@linuxfoundation.org
Cc: johnny.kim@atmel.com, rachel.kim@atmel.com, chris.park@atmel.com,
	tony.cho@atmel.com, glen.lee@atmel.com, leo.kim@atmel.com,
	linux-wireless@vger.kernel.org, devel@driverdev.osuosl.org,
	Chaehyun Lim <chaehyun.lim@gmail.com>
Subject: [PATCH 09/18] staging: wilc1000: use BIT macro
Date: Tue, 15 Sep 2015 14:06:19 +0900
Message-Id: <1442293588-15323-9-git-send-email-chaehyun.lim@gmail.com> (sfid-20150915_071652_678823_9089D44B)
In-Reply-To: <1442293588-15323-1-git-send-email-chaehyun.lim@gmail.com>
References: <1442293588-15323-1-git-send-email-chaehyun.lim@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This patch replaces bit shift with BIT(x) macro.

Signed-off-by: Chaehyun Lim <chaehyun.lim@gmail.com>
---
 drivers/staging/wilc1000/wilc_wfi_cfgoperations.h | 16 ++++++++--------
 1 file changed, 8 insertions(+), 8 deletions(-)

diff --git a/drivers/staging/wilc1000/wilc_wfi_cfgoperations.h b/drivers/staging/wilc1000/wilc_wfi_cfgoperations.h
index 51f9413..edf5ec0 100644
--- a/drivers/staging/wilc1000/wilc_wfi_cfgoperations.h
+++ b/drivers/staging/wilc1000/wilc_wfi_cfgoperations.h
@@ -11,14 +11,14 @@
 #include "wilc_wfi_netdevice.h"
 
 /* The following macros describe the bitfield map used by the firmware to determine its 11i mode */
-#define NO_ENCRYPT			0
-#define ENCRYPT_ENABLED	(1 << 0)
-#define WEP					(1 << 1)
-#define WEP_EXTENDED		(1 << 2)
-#define WPA					(1 << 3)
-#define WPA2				(1 << 4)
-#define AES					(1 << 5)
-#define TKIP					(1 << 6)
+#define NO_ENCRYPT		0
+#define ENCRYPT_ENABLED		BIT(0)
+#define WEP			BIT(1)
+#define WEP_EXTENDED		BIT(2)
+#define WPA			BIT(3)
+#define WPA2			BIT(4)
+#define AES			BIT(5)
+#define TKIP			BIT(6)
 
 #ifdef WILC_P2P
 /* #define	USE_SUPPLICANT_GO_INTENT */
-- 
2.5.1

