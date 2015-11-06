Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from eusmtp01.atmel.com ([212.144.249.242]:37643 "EHLO
	eusmtp01.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1031044AbbKFCR2 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 5 Nov 2015 21:17:28 -0500
From: Glen Lee <glen.lee@atmel.com>
To: <gregkh@linuxfoundation.org>
CC: <devel@driverdev.osuosl.org>, <linux-wireless@vger.kernel.org>,
	<tony.cho@atmel.com>, <glen.lee@atmel.com>, <leo.kim@atmel.com>,
	<austin.shin@atmel.com>, <adel.noureldin@atmel.com>,
	<adham.abozaeid@atmel.com>, <Nicolas.FERRE@atmel.com>
Subject: [PATCH 54/73] staging: wilc1000: fixes possible unnecessary 'out of memory' message
Date: Fri, 6 Nov 2015 11:19:53 +0900
Message-ID: <1446776412-30670-5-git-send-email-glen.lee@atmel.com> (sfid-20151106_031750_635916_BC13A7D1)
In-Reply-To: <1446776412-30670-1-git-send-email-glen.lee@atmel.com>
References: <1446776412-30670-1-git-send-email-glen.lee@atmel.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Leo Kim <leo.kim@atmel.com>

This patch fixes the warning reported by checkpatch.pl
for possible unnecessary 'out of memory' message

Signed-off-by: Leo Kim <leo.kim@atmel.com>
Signed-off-by: Glen Lee <glen.lee@atmel.com>
---
 drivers/staging/wilc1000/wilc_wlan.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/drivers/staging/wilc1000/wilc_wlan.c b/drivers/staging/wilc1000/wilc_wlan.c
index ba50605..70d794b 100644
--- a/drivers/staging/wilc1000/wilc_wlan.c
+++ b/drivers/staging/wilc1000/wilc_wlan.c
@@ -1111,7 +1111,6 @@ static void wilc_wlan_handle_isr_ext(struct wilc *wilc, u32 int_status)
 #else
 		buffer = kmalloc(size, GFP_KERNEL);
 		if (!buffer) {
-			wilc_debug(N_ERR, "[wilc isr]: fail alloc host memory...drop the packets (%d)\n", size);
 			usleep_range(100 * 1000, 100 * 1000);
 			goto _end_;
 		}
-- 
1.9.1

