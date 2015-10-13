Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from eusmtp01.atmel.com ([212.144.249.242]:3317 "EHLO
	eusmtp01.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752485AbbJMKyv (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 13 Oct 2015 06:54:51 -0400
From: Tony Cho <tony.cho@atmel.com>
To: <gregkh@linuxfoundation.org>
CC: <devel@driverdev.osuosl.org>, <linux-wireless@vger.kernel.org>,
	<johnny.kim@atmel.com>, <chris.park@atmel.com>,
	<rachel.kim@atmel.com>, <tony.cho@atmel.com>, <glen.lee@atmel.com>,
	<leo.kim@atmel.com>, <austin.shin@atmel.com>,
	<adel.noureldin@atmel.com>, <adham.abozaeid@atmel.com>,
	<Nicolas.FERRE@atmel.com>
Subject: [PATCH 39/54] staging: wilc1000: rename u32DTIMPeriod of struct beacon_attr
Date: Tue, 13 Oct 2015 19:50:04 +0900
Message-ID: <1444733419-17679-39-git-send-email-tony.cho@atmel.com> (sfid-20151013_125453_739034_06EC989B)
In-Reply-To: <1444733419-17679-1-git-send-email-tony.cho@atmel.com>
References: <1444733419-17679-1-git-send-email-tony.cho@atmel.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Leo Kim <leo.kim@atmel.com>

This patch renames u32DTIMPeriod of struct beacon_attr to dtim_period to
avoid CamelCase naming convention.

Signed-off-by: Leo Kim <leo.kim@atmel.com>
Signed-off-by: Tony Cho <tony.cho@atmel.com>
---
 drivers/staging/wilc1000/host_interface.c | 12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

diff --git a/drivers/staging/wilc1000/host_interface.c b/drivers/staging/wilc1000/host_interface.c
index e6490ef..03ce060 100644
--- a/drivers/staging/wilc1000/host_interface.c
+++ b/drivers/staging/wilc1000/host_interface.c
@@ -132,7 +132,7 @@ struct channel_attr {
 
 struct beacon_attr {
 	u32 interval;
-	u32 u32DTIMPeriod;
+	u32 dtim_period;
 	u32 u32HeadLen;
 	u8 *pu8Head;
 	u32 u32TailLen;
@@ -2349,10 +2349,10 @@ static void Handle_AddBeacon(struct host_if_drv *hif_drv,
 	*pu8CurrByte++ = ((pstrSetBeaconParam->interval >> 16) & 0xFF);
 	*pu8CurrByte++ = ((pstrSetBeaconParam->interval >> 24) & 0xFF);
 
-	*pu8CurrByte++ = (pstrSetBeaconParam->u32DTIMPeriod & 0xFF);
-	*pu8CurrByte++ = ((pstrSetBeaconParam->u32DTIMPeriod >> 8) & 0xFF);
-	*pu8CurrByte++ = ((pstrSetBeaconParam->u32DTIMPeriod >> 16) & 0xFF);
-	*pu8CurrByte++ = ((pstrSetBeaconParam->u32DTIMPeriod >> 24) & 0xFF);
+	*pu8CurrByte++ = (pstrSetBeaconParam->dtim_period & 0xFF);
+	*pu8CurrByte++ = ((pstrSetBeaconParam->dtim_period >> 8) & 0xFF);
+	*pu8CurrByte++ = ((pstrSetBeaconParam->dtim_period >> 16) & 0xFF);
+	*pu8CurrByte++ = ((pstrSetBeaconParam->dtim_period >> 24) & 0xFF);
 
 	*pu8CurrByte++ = (pstrSetBeaconParam->u32HeadLen & 0xFF);
 	*pu8CurrByte++ = ((pstrSetBeaconParam->u32HeadLen >> 8) & 0xFF);
@@ -4642,7 +4642,7 @@ s32 host_int_add_beacon(struct host_if_drv *hif_drv, u32 u32Interval,
 	msg.id = HOST_IF_MSG_ADD_BEACON;
 	msg.drv = hif_drv;
 	pstrSetBeaconParam->interval = u32Interval;
-	pstrSetBeaconParam->u32DTIMPeriod = u32DTIMPeriod;
+	pstrSetBeaconParam->dtim_period = u32DTIMPeriod;
 	pstrSetBeaconParam->u32HeadLen = u32HeadLen;
 	pstrSetBeaconParam->pu8Head = kmalloc(u32HeadLen, GFP_KERNEL);
 	if (pstrSetBeaconParam->pu8Head == NULL) {
-- 
1.9.1

