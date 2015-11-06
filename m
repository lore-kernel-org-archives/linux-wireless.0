Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from eusmtp01.atmel.com ([212.144.249.242]:37197 "EHLO
	eusmtp01.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1031371AbbKFCOq (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 5 Nov 2015 21:14:46 -0500
From: Glen Lee <glen.lee@atmel.com>
To: <gregkh@linuxfoundation.org>
CC: <devel@driverdev.osuosl.org>, <linux-wireless@vger.kernel.org>,
	<tony.cho@atmel.com>, <glen.lee@atmel.com>, <leo.kim@atmel.com>,
	<austin.shin@atmel.com>, <adel.noureldin@atmel.com>,
	<adham.abozaeid@atmel.com>, <Nicolas.FERRE@atmel.com>
Subject: [PATCH 43/73] staging: wilc1000: fixes a struct allocation to match coding standards
Date: Fri, 6 Nov 2015 11:13:04 +0900
Message-ID: <1446776014-28094-43-git-send-email-glen.lee@atmel.com> (sfid-20151106_033806_399243_58DFCDA0)
In-Reply-To: <1446776014-28094-1-git-send-email-glen.lee@atmel.com>
References: <1446776014-28094-1-git-send-email-glen.lee@atmel.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Leo Kim <leo.kim@atmel.com>

This patch fixes the checks reported by checkpatch.pl
for prefer kmalloc(sizeof(*rqe)...) over kmalloc(sizeof(struct rxq_entry_t)...)

Signed-off-by: Leo Kim <leo.kim@atmel.com>
Signed-off-by: Glen Lee <glen.lee@atmel.com>
---
 drivers/staging/wilc1000/wilc_wlan.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/staging/wilc1000/wilc_wlan.c b/drivers/staging/wilc1000/wilc_wlan.c
index f1bb8af..c4118fe 100644
--- a/drivers/staging/wilc1000/wilc_wlan.c
+++ b/drivers/staging/wilc1000/wilc_wlan.c
@@ -1132,7 +1132,7 @@ _end_:
 			offset += size;
 			p->rx_buffer_offset = offset;
 #endif
-			rqe = kmalloc(sizeof(struct rxq_entry_t), GFP_KERNEL);
+			rqe = kmalloc(sizeof(*rqe), GFP_KERNEL);
 			if (rqe) {
 				rqe->buffer = buffer;
 				rqe->buffer_size = size;
-- 
1.9.1

