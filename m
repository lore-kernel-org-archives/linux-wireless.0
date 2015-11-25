Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from eusmtp01.atmel.com ([212.144.249.242]:10271 "EHLO
	eusmtp01.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932277AbbKYC5U (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 24 Nov 2015 21:57:20 -0500
From: Glen Lee <glen.lee@atmel.com>
To: <gregkh@linuxfoundation.org>
CC: <devel@driverdev.osuosl.org>, <linux-wireless@vger.kernel.org>,
	<tony.cho@atmel.com>, <glen.lee@atmel.com>, <leo.kim@atmel.com>,
	<austin.shin@atmel.com>, <adel.noureldin@atmel.com>,
	<adham.abozaeid@atmel.com>, <Nicolas.FERRE@atmel.com>
Subject: [PATCH 10/10] staging: wilc1000: Handle_SetMulticastFilter(): fixes right shifting more than type allows
Date: Wed, 25 Nov 2015 11:59:49 +0900
Message-ID: <1448420389-4192-10-git-send-email-glen.lee@atmel.com> (sfid-20151125_035724_699961_1037ACB0)
In-Reply-To: <1448420389-4192-1-git-send-email-glen.lee@atmel.com>
References: <1448420389-4192-1-git-send-email-glen.lee@atmel.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Leo Kim <leo.kim@atmel.com>

This patch fixes the warning reported by smatch.
 - Handle_SetMulticastFilter() warn: right shifting more than type allows

That is unnecessary action of boolean type. just assign 0.

Signed-off-by: Leo Kim <leo.kim@atmel.com>
Signed-off-by: Glen Lee <glen.lee@atmel.com>
---
 drivers/staging/wilc1000/host_interface.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/staging/wilc1000/host_interface.c b/drivers/staging/wilc1000/host_interface.c
index c309deb..3b986cb 100644
--- a/drivers/staging/wilc1000/host_interface.c
+++ b/drivers/staging/wilc1000/host_interface.c
@@ -2713,9 +2713,9 @@ static void Handle_SetMulticastFilter(struct host_if_drv *hif_drv,
 
 	pu8CurrByte = wid.val;
 	*pu8CurrByte++ = (strHostIfSetMulti->enabled & 0xFF);
-	*pu8CurrByte++ = ((strHostIfSetMulti->enabled >> 8) & 0xFF);
-	*pu8CurrByte++ = ((strHostIfSetMulti->enabled >> 16) & 0xFF);
-	*pu8CurrByte++ = ((strHostIfSetMulti->enabled >> 24) & 0xFF);
+	*pu8CurrByte++ = 0;
+	*pu8CurrByte++ = 0;
+	*pu8CurrByte++ = 0;
 
 	*pu8CurrByte++ = (strHostIfSetMulti->cnt & 0xFF);
 	*pu8CurrByte++ = ((strHostIfSetMulti->cnt >> 8) & 0xFF);
-- 
1.9.1

