Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from eusmtp01.atmel.com ([212.144.249.242]:41873 "EHLO
	eusmtp01.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932387AbcCOJvj (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 15 Mar 2016 05:51:39 -0400
From: Leo Kim <leo.kim@atmel.com>
To: <gregkh@linuxfoundation.org>
CC: <devel@driverdev.osuosl.org>, <linux-wireless@vger.kernel.org>,
	<tony.cho@atmel.com>, <glen.lee@atmel.com>, <leo.kim@atmel.com>,
	<austin.shin@atmel.com>, <Chris.Park@atmel.com>,
	<adham.abozaeid@atmel.com>, <Nicolas.FERRE@atmel.com>
Subject: [PATCH 7/7] staging: wilc1000: removes an unnecessary if-condition
Date: Tue, 15 Mar 2016 18:48:14 +0900
Message-ID: <1458035294-13001-7-git-send-email-leo.kim@atmel.com> (sfid-20160315_105142_039135_83A40536)
In-Reply-To: <1458035294-13001-1-git-send-email-leo.kim@atmel.com>
References: <1458035294-13001-1-git-send-email-leo.kim@atmel.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This patch removes an unnecessary if-condition.
Regardless of an if-condition is performed unconditionally '_end_' statement.

Signed-off-by: Leo Kim <leo.kim@atmel.com>
---
 drivers/staging/wilc1000/wilc_wlan.c | 2 --
 1 file changed, 2 deletions(-)

diff --git a/drivers/staging/wilc1000/wilc_wlan.c b/drivers/staging/wilc1000/wilc_wlan.c
index ea671a9..08937fe 100644
--- a/drivers/staging/wilc1000/wilc_wlan.c
+++ b/drivers/staging/wilc1000/wilc_wlan.c
@@ -895,8 +895,6 @@ static void wilc_wlan_handle_isr_ext(struct wilc *wilc, u32 int_status)
 					      DATA_INT_CLR | ENABLE_RX_VMM);
 		ret = wilc->hif_func->hif_block_rx_ext(wilc, 0, buffer, size);
 
-		if (!ret)
-			goto _end_;
 _end_:
 		if (ret) {
 			offset += size;
-- 
1.9.1

