Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from eusmtp01.atmel.com ([212.144.249.242]:21393 "EHLO
	eusmtp01.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753406AbbIHIHt (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 8 Sep 2015 04:07:49 -0400
From: Tony Cho <tony.cho@atmel.com>
To: <gregkh@linuxfoundation.org>
CC: <devel@driverdev.osuosl.org>, <linux-wireless@vger.kernel.org>,
	<johnny.kim@atmel.com>, <chris.park@atmel.com>,
	<rachel.kim@atmel.com>, <tony.cho@atmel.com>, <glen.lee@atmel.com>,
	<leo.kim@atmel.com>, <austin.shin@atmel.com>,
	<adel.noureldin@atmel.com>, <adham.abozaeid@atmel.com>,
	<Nicolas.FERRE@atmel.com>
Subject: [PATCH 2/5] staging: wilc1000: remove meaningless line
Date: Tue, 8 Sep 2015 17:08:00 +0900
Message-ID: <1441699683-31463-2-git-send-email-tony.cho@atmel.com> (sfid-20150908_100753_295144_BBD19565)
In-Reply-To: <1441699683-31463-1-git-send-email-tony.cho@atmel.com>
References: <1441699683-31463-1-git-send-email-tony.cho@atmel.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johnny Kim <johnny.kim@atmel.com>

The current driver is calling skb_reserve function to align memory in
frmw_to_linux function. However, the wrong value is used as the input argument.
Besides, the process is not necessary because the address already is algined
in dev_alloc_skb function. So, this patch removes the line for dummy headroom.

Signed-off-by: Johnny Kim <johnny.kim@atmel.com>
Signed-off-by: Tony Cho <tony.cho@atmel.com>
---
 drivers/staging/wilc1000/linux_wlan.c | 2 --
 1 file changed, 2 deletions(-)

diff --git a/drivers/staging/wilc1000/linux_wlan.c b/drivers/staging/wilc1000/linux_wlan.c
index 59c9b44..dc297fc 100644
--- a/drivers/staging/wilc1000/linux_wlan.c
+++ b/drivers/staging/wilc1000/linux_wlan.c
@@ -2161,8 +2161,6 @@ void frmw_to_linux(uint8_t *buff, uint32_t size, uint32_t pkt_offset)
 			return;
 		}
 
-		skb_reserve(skb, (unsigned int)skb->data & 0x3);
-
 		if (g_linux_wlan == NULL || wilc_netdev == NULL)
 			PRINT_ER("wilc_netdev in g_linux_wlan is NULL");
 		skb->dev = wilc_netdev;
-- 
1.9.1

