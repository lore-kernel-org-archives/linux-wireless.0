Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from eusmtp01.atmel.com ([212.144.249.242]:52587 "EHLO
	eusmtp01.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753317AbbJPEkm (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 16 Oct 2015 00:40:42 -0400
From: Tony Cho <tony.cho@atmel.com>
To: <gregkh@linuxfoundation.org>
CC: <devel@driverdev.osuosl.org>, <linux-wireless@vger.kernel.org>,
	<tony.cho@atmel.com>, <glen.lee@atmel.com>, <leo.kim@atmel.com>,
	<austin.shin@atmel.com>, <adel.noureldin@atmel.com>,
	<adham.abozaeid@atmel.com>, <Nicolas.FERRE@atmel.com>
Subject: [PATCH V2 24/40] staging: wilc1000: rename variable gs8GetIP
Date: Fri, 16 Oct 2015 13:37:54 +0900
Message-ID: <1444970290-17609-24-git-send-email-tony.cho@atmel.com> (sfid-20151016_064658_921138_743BCE45)
In-Reply-To: <1444970290-17609-1-git-send-email-tony.cho@atmel.com>
References: <1444970290-17609-1-git-send-email-tony.cho@atmel.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Leo Kim <leo.kim@atmel.com>

This patch renames variable gs8GetIP to get_ip
to avoid CamelCase naming convention.

Signed-off-by: Leo Kim <leo.kim@atmel.com>
Signed-off-by: Tony Cho <tony.cho@atmel.com>
---
 drivers/staging/wilc1000/host_interface.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/staging/wilc1000/host_interface.c b/drivers/staging/wilc1000/host_interface.c
index 7e436fb..59cbf90 100644
--- a/drivers/staging/wilc1000/host_interface.c
+++ b/drivers/staging/wilc1000/host_interface.c
@@ -257,7 +257,7 @@ static s8 rssi;
 static s8 link_speed;
 static u8 ch_no;
 static u8 set_ip[2][4];
-static u8 gs8GetIP[2][4];
+static u8 get_ip[2][4];
 static u32 gu32InactiveTime;
 static u8 gu8DelBcn;
 static u32 gu32WidConnRstHack;
@@ -456,11 +456,11 @@ s32 Handle_get_IPAddress(struct host_if_drv *hif_drv, u8 *pu8IPAddr, u8 idx)
 
 	PRINT_INFO(HOSTINF_DBG, "%pI4\n", strWID.val);
 
-	memcpy(gs8GetIP[idx], strWID.val, IP_ALEN);
+	memcpy(get_ip[idx], strWID.val, IP_ALEN);
 
 	kfree(strWID.val);
 
-	if (memcmp(gs8GetIP[idx], set_ip[idx], IP_ALEN) != 0)
+	if (memcmp(get_ip[idx], set_ip[idx], IP_ALEN) != 0)
 		host_int_setup_ipaddress(hif_drv, set_ip[idx], idx);
 
 	if (s32Error != 0) {
@@ -469,7 +469,7 @@ s32 Handle_get_IPAddress(struct host_if_drv *hif_drv, u8 *pu8IPAddr, u8 idx)
 	}
 
 	PRINT_INFO(HOSTINF_DBG, "IP address retrieved:: u8IfIdx = %d\n", idx);
-	PRINT_INFO(HOSTINF_DBG, "%pI4\n", gs8GetIP[idx]);
+	PRINT_INFO(HOSTINF_DBG, "%pI4\n", get_ip[idx]);
 	PRINT_INFO(HOSTINF_DBG, "\n");
 
 	return s32Error;
-- 
1.9.1

