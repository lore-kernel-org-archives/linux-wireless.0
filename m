Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from eusmtp01.atmel.com ([212.144.249.243]:44575 "EHLO
	eusmtp01.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751272AbbGaHlf (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 31 Jul 2015 03:41:35 -0400
From: Tony Cho <tony.cho@atmel.com>
To: <gregkh@linuxfoundation.org>
CC: <devel@driverdev.osuosl.org>, <linux-wireless@vger.kernel.org>,
	<johnny.kim@atmel.com>, <chris.park@atmel.com>,
	<rachel.kim@atmel.com>, <austin.shin@atmel.com>,
	<tony.cho@atmel.com>, <glen.lee@atmel.com>, <leo.kim@atmel.com>,
	<jude.lee@atmel.com>, <robin.hwang@atmel.com>,
	<Nicolas.FERRE@atmel.com>
Subject: [PATCH 24/28] staging: wilc1000: fix cast from pointer to integer warning
Date: Fri, 31 Jul 2015 16:38:32 +0900
Message-ID: <1438328316-30197-25-git-send-email-tony.cho@atmel.com> (sfid-20150731_100716_292345_4FD148D0)
In-Reply-To: <1438328316-30197-1-git-send-email-tony.cho@atmel.com>
References: <1438328316-30197-1-git-send-email-tony.cho@atmel.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: glen lee <glen.lee@atmel.com>

To use a pointer as as integer in arithmetic operation, cast type to uintptr_t
as the data type.
This patch changes casting (unsigned int) with (uintptr_t) to do arithmetic operation

Here is build warning.
drivers/staging/wilc1000/linux_wlan.c:2385:20: warning: cast from pointer to
integer of different size [-Wpointer-to-int-cast]
   skb_reserve(skb, (unsigned int)skb->data & 0x3);

Signed-off-by: glen lee <glen.lee@atmel.com>
Signed-off-by: Tony Cho <tony.cho@atmel.com>
---
 drivers/staging/wilc1000/linux_wlan.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/staging/wilc1000/linux_wlan.c b/drivers/staging/wilc1000/linux_wlan.c
index 5dcb30c..ec80849 100644
--- a/drivers/staging/wilc1000/linux_wlan.c
+++ b/drivers/staging/wilc1000/linux_wlan.c
@@ -2382,7 +2382,7 @@ void frmw_to_linux(uint8_t *buff, uint32_t size, uint32_t pkt_offset)
 			return;
 		}
 
-		skb_reserve(skb, (unsigned int)skb->data & 0x3);
+		skb_reserve(skb, (uintptr_t)skb->data & 0x3);
 
 		if (g_linux_wlan == NULL || wilc_netdev == NULL)
 			PRINT_ER("wilc_netdev in g_linux_wlan is NULL");
-- 
1.9.1

