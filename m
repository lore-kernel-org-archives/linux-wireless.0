Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wi0-f173.google.com ([209.85.212.173]:33875 "EHLO
	mail-wi0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751940AbbFZPeV (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 26 Jun 2015 11:34:21 -0400
Date: Fri, 26 Jun 2015 17:40:25 +0200
From: Luis de Bethencourt <luis@debethencourt.com>
To: linux-kernel@vger.kernel.org
Cc: Joe Perches <joe@perches.com>, Johnny Kim <johnny.kim@atmel.com>,
	Rachel Kim <rachel.kim@atmel.com>,
	Dean Lee <dean.lee@atmel.com>,
	Chris Park <chris.park@atmel.com>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	linux-wireless@vger.kernel.org, devel@driverdev.osuosl.org
Subject: [PATCH 5/4] staging: wilc1000: switch printks to vsprintf IPv4
 extension
Message-ID: <20150626154022.GA32529@goodgumbo.baconseed.org> (sfid-20150626_173425_254429_C6D89F01)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Switch printks with IP addresses to use vsprintf extension %pI4.

Suggested-by: Joe Perches <joe@perches.com>
Signed-off-by: Luis de Bethencourt <luis@debethencourt.com>
---
 drivers/staging/wilc1000/host_interface.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/staging/wilc1000/host_interface.c b/drivers/staging/wilc1000/host_interface.c
index 1915fc6..483926f 100644
--- a/drivers/staging/wilc1000/host_interface.c
+++ b/drivers/staging/wilc1000/host_interface.c
@@ -740,7 +740,7 @@ s32 Handle_set_IPAddress(void *drvHandler, u8 *pu8IPAddr, u8 idx)
 	if (pu8IPAddr[0] < 192)
 		pu8IPAddr[0] = 0;
 
-	PRINT_INFO(HOSTINF_DBG, "Indx = %d, Handling set  IP = %d.%d.%d.%d\n", idx, pu8IPAddr[0], pu8IPAddr[1], pu8IPAddr[2], pu8IPAddr[3]);
+	PRINT_INFO(HOSTINF_DBG, "Indx = %d, Handling set  IP = %pI4\n", idx, pu8IPAddr);
 
 	WILC_memcpy(gs8SetIP[idx], pu8IPAddr, IP_ALEN);
 
@@ -796,7 +796,7 @@ s32 Handle_get_IPAddress(void *drvHandler, u8 *pu8IPAddr, u8 idx)
 
 	s32Error = SendConfigPkt(GET_CFG, &strWID, 1, true, (u32)pstrWFIDrv);
 
-	PRINT_INFO(HOSTINF_DBG, "%d.%d.%d.%d\n", (u8)(strWID.ps8WidVal[0]), (u8)(strWID.ps8WidVal[1]), (u8)(strWID.ps8WidVal[2]), (u8)(strWID.ps8WidVal[3]));
+	PRINT_INFO(HOSTINF_DBG, "%pI4\n", strWID.ps8WidVal);
 
 	WILC_memcpy(gs8GetIP[idx], strWID.ps8WidVal, IP_ALEN);
 
@@ -811,7 +811,7 @@ s32 Handle_get_IPAddress(void *drvHandler, u8 *pu8IPAddr, u8 idx)
 		WILC_ERRORREPORT(s32Error, WILC_INVALID_STATE);
 	} else {
 		PRINT_INFO(HOSTINF_DBG, "IP address retrieved:: u8IfIdx = %d\n", idx);
-		PRINT_INFO(HOSTINF_DBG, "%d.%d.%d.%d\n", gs8GetIP[idx][0], gs8GetIP[idx][1], gs8GetIP[idx][2], gs8GetIP[idx][3]);
+		PRINT_INFO(HOSTINF_DBG, "%pI4\n", gs8GetIP[idx]);
 		PRINT_INFO(HOSTINF_DBG, "\n");
 	}
 
-- 
2.1.4

This patch is 5/4 because it is a suggestion made by Joe Perches. Based on top
of the previous 4 wilc1000 patches.
https://lkml.org/lkml/2015/6/26/392

Thank you Joe :)
