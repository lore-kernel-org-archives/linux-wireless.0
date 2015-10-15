Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from eusmtp01.atmel.com ([212.144.249.242]:6313 "EHLO
	eusmtp01.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750900AbbJOE2D (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 15 Oct 2015 00:28:03 -0400
From: Tony Cho <tony.cho@atmel.com>
To: <gregkh@linuxfoundation.org>
CC: <devel@driverdev.osuosl.org>, <linux-wireless@vger.kernel.org>,
	<johnny.kim@atmel.com>, <chris.park@atmel.com>,
	<rachel.kim@atmel.com>, <tony.cho@atmel.com>, <glen.lee@atmel.com>,
	<leo.kim@atmel.com>, <austin.shin@atmel.com>,
	<adel.noureldin@atmel.com>, <adham.abozaeid@atmel.com>,
	<Nicolas.FERRE@atmel.com>
Subject: [PATCH 23/40] staging: wilc1000: rename variable gs8SetIP
Date: Thu, 15 Oct 2015 13:25:04 +0900
Message-ID: <1444883121-31757-23-git-send-email-tony.cho@atmel.com> (sfid-20151015_064658_077382_5DC87C32)
In-Reply-To: <1444883121-31757-1-git-send-email-tony.cho@atmel.com>
References: <1444883121-31757-1-git-send-email-tony.cho@atmel.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Leo Kim <leo.kim@atmel.com>

This patch renames variable gs8SetIP to set_ip
to avoid CamelCase naming convention.

Signed-off-by: Leo Kim <leo.kim@atmel.com>
Signed-off-by: Tony Cho <tony.cho@atmel.com>
---
 drivers/staging/wilc1000/host_interface.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/staging/wilc1000/host_interface.c b/drivers/staging/wilc1000/host_interface.c
index 386267c..ce94859 100644
--- a/drivers/staging/wilc1000/host_interface.c
+++ b/drivers/staging/wilc1000/host_interface.c
@@ -256,7 +256,7 @@ bool scan_while_connected;
 static s8 rssi;
 static s8 link_speed;
 static u8 ch_no;
-static u8 gs8SetIP[2][4];
+static u8 set_ip[2][4];
 static u8 gs8GetIP[2][4];
 static u32 gu32InactiveTime;
 static u8 gu8DelBcn;
@@ -417,7 +417,7 @@ s32 Handle_set_IPAddress(struct host_if_drv *hif_drv, u8 *pu8IPAddr, u8 idx)
 
 	PRINT_INFO(HOSTINF_DBG, "Indx = %d, Handling set  IP = %pI4\n", idx, pu8IPAddr);
 
-	memcpy(gs8SetIP[idx], pu8IPAddr, IP_ALEN);
+	memcpy(set_ip[idx], pu8IPAddr, IP_ALEN);
 
 	strWID.id = (u16)WID_IP_ADDRESS;
 	strWID.type = WID_STR;
@@ -460,8 +460,8 @@ s32 Handle_get_IPAddress(struct host_if_drv *hif_drv, u8 *pu8IPAddr, u8 idx)
 
 	kfree(strWID.val);
 
-	if (memcmp(gs8GetIP[idx], gs8SetIP[idx], IP_ALEN) != 0)
-		host_int_setup_ipaddress(hif_drv, gs8SetIP[idx], idx);
+	if (memcmp(gs8GetIP[idx], set_ip[idx], IP_ALEN) != 0)
+		host_int_setup_ipaddress(hif_drv, set_ip[idx], idx);
 
 	if (s32Error != 0) {
 		PRINT_ER("Failed to get IP address\n");
-- 
1.9.1

