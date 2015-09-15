Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pa0-f51.google.com ([209.85.220.51]:33095 "EHLO
	mail-pa0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751565AbbIOFHV (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 15 Sep 2015 01:07:21 -0400
Received: by pacex6 with SMTP id ex6so165319949pac.0
        for <linux-wireless@vger.kernel.org>; Mon, 14 Sep 2015 22:07:20 -0700 (PDT)
From: Chaehyun Lim <chaehyun.lim@gmail.com>
To: gregkh@linuxfoundation.org
Cc: johnny.kim@atmel.com, rachel.kim@atmel.com, chris.park@atmel.com,
	tony.cho@atmel.com, glen.lee@atmel.com, leo.kim@atmel.com,
	linux-wireless@vger.kernel.org, devel@driverdev.osuosl.org,
	Chaehyun Lim <chaehyun.lim@gmail.com>
Subject: [PATCH 10/18] staging: wilc1000: remove bit shift macro that is custom defined
Date: Tue, 15 Sep 2015 14:06:20 +0900
Message-Id: <1442293588-15323-10-git-send-email-chaehyun.lim@gmail.com> (sfid-20150915_070734_061089_929167BA)
In-Reply-To: <1442293588-15323-1-git-send-email-chaehyun.lim@gmail.com>
References: <1442293588-15323-1-git-send-email-chaehyun.lim@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This patch remove bit shift macro that is custom defined, then it is
replaced BIT(x) macro.

Signed-off-by: Chaehyun Lim <chaehyun.lim@gmail.com>
---
 drivers/staging/wilc1000/host_interface.h | 10 +++-------
 1 file changed, 3 insertions(+), 7 deletions(-)

diff --git a/drivers/staging/wilc1000/host_interface.h b/drivers/staging/wilc1000/host_interface.h
index dfc210a..a4321a4 100644
--- a/drivers/staging/wilc1000/host_interface.h
+++ b/drivers/staging/wilc1000/host_interface.h
@@ -19,10 +19,6 @@
 
 #define IP_ALEN  4
 
-#define BIT2                    ((u32)(1 << 2))
-#define BIT1                    ((u32)(1 << 1))
-#define BIT0                    ((u32)(1 << 0))
-
 #define IDLE_MODE	0x00
 #define AP_MODE		0x01
 #define STATION_MODE	0x02
@@ -36,9 +32,9 @@
 #define MIN_SCAN_TIME				10
 #define MAX_SCAN_TIME				1200
 #define DEFAULT_SCAN				0
-#define USER_SCAN					BIT0
-#define OBSS_PERIODIC_SCAN			BIT1
-#define OBSS_ONETIME_SCAN			BIT2
+#define USER_SCAN				BIT(0)
+#define OBSS_PERIODIC_SCAN			BIT(1)
+#define OBSS_ONETIME_SCAN			BIT(2)
 #define GTK_RX_KEY_BUFF_LEN			24
 #define ADDKEY						0x1
 #define REMOVEKEY					0x2
-- 
2.5.1

