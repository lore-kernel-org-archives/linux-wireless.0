Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from eusmtp01.atmel.com ([212.144.249.242]:6276 "EHLO
	eusmtp01.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750961AbbJOE1u (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 15 Oct 2015 00:27:50 -0400
From: Tony Cho <tony.cho@atmel.com>
To: <gregkh@linuxfoundation.org>
CC: <devel@driverdev.osuosl.org>, <linux-wireless@vger.kernel.org>,
	<johnny.kim@atmel.com>, <chris.park@atmel.com>,
	<rachel.kim@atmel.com>, <tony.cho@atmel.com>, <glen.lee@atmel.com>,
	<leo.kim@atmel.com>, <austin.shin@atmel.com>,
	<adel.noureldin@atmel.com>, <adham.abozaeid@atmel.com>,
	<Nicolas.FERRE@atmel.com>
Subject: [PATCH 21/40] staging: wilc1000: rename variable gs8lnkspd
Date: Thu, 15 Oct 2015 13:25:02 +0900
Message-ID: <1444883121-31757-21-git-send-email-tony.cho@atmel.com> (sfid-20151015_064656_793324_9E0D242F)
In-Reply-To: <1444883121-31757-1-git-send-email-tony.cho@atmel.com>
References: <1444883121-31757-1-git-send-email-tony.cho@atmel.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Leo Kim <leo.kim@atmel.com>

This patch renames variable gs8lnkspd to link_speed.

Signed-off-by: Leo Kim <leo.kim@atmel.com>
Signed-off-by: Tony Cho <tony.cho@atmel.com>
---
 drivers/staging/wilc1000/host_interface.c | 10 ++++------
 1 file changed, 4 insertions(+), 6 deletions(-)

diff --git a/drivers/staging/wilc1000/host_interface.c b/drivers/staging/wilc1000/host_interface.c
index 14cd253..79aaeaa 100644
--- a/drivers/staging/wilc1000/host_interface.c
+++ b/drivers/staging/wilc1000/host_interface.c
@@ -254,7 +254,7 @@ static u8 rcv_assoc_resp[MAX_ASSOC_RESP_FRAME_SIZE];
 bool scan_while_connected;
 
 static s8 rssi;
-static s8 gs8lnkspd;
+static s8 link_speed;
 static u8 gu8Chnl;
 static u8 gs8SetIP[2][4];
 static u8 gs8GetIP[2][4];
@@ -2188,11 +2188,11 @@ static void Handle_GetLinkspeed(struct host_if_drv *hif_drv)
 	s32 s32Error = 0;
 	struct wid strWID;
 
-	gs8lnkspd = 0;
+	link_speed = 0;
 
 	strWID.id = (u16)WID_LINKSPEED;
 	strWID.type = WID_CHAR;
-	strWID.val = &gs8lnkspd;
+	strWID.val = &link_speed;
 	strWID.size = sizeof(char);
 
 	PRINT_D(HOSTINF_DBG, "Getting LINKSPEED value\n");
@@ -3971,9 +3971,7 @@ s32 host_int_get_link_speed(struct host_if_drv *hif_drv, s8 *ps8lnkspd)
 		return -EFAULT;
 	}
 
-
-	*ps8lnkspd = gs8lnkspd;
-
+	*ps8lnkspd = link_speed;
 
 	return s32Error;
 }
-- 
1.9.1

