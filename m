Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from eusmtp01.atmel.com ([212.144.249.242]:52635 "EHLO
	eusmtp01.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751252AbbJPEky (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 16 Oct 2015 00:40:54 -0400
From: Tony Cho <tony.cho@atmel.com>
To: <gregkh@linuxfoundation.org>
CC: <devel@driverdev.osuosl.org>, <linux-wireless@vger.kernel.org>,
	<tony.cho@atmel.com>, <glen.lee@atmel.com>, <leo.kim@atmel.com>,
	<austin.shin@atmel.com>, <adel.noureldin@atmel.com>,
	<adham.abozaeid@atmel.com>, <Nicolas.FERRE@atmel.com>
Subject: [PATCH V2 26/40] staging: wilc1000: rename variable gu8DelBcn
Date: Fri, 16 Oct 2015 13:37:56 +0900
Message-ID: <1444970290-17609-26-git-send-email-tony.cho@atmel.com> (sfid-20151016_064657_017625_2F429326)
In-Reply-To: <1444970290-17609-1-git-send-email-tony.cho@atmel.com>
References: <1444970290-17609-1-git-send-email-tony.cho@atmel.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Leo Kim <leo.kim@atmel.com>

This patch renames variable gu8DelBcn to del_beacon
to avoid CamelCase naming convention.

Signed-off-by: Leo Kim <leo.kim@atmel.com>
Signed-off-by: Tony Cho <tony.cho@atmel.com>
---
 drivers/staging/wilc1000/host_interface.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/staging/wilc1000/host_interface.c b/drivers/staging/wilc1000/host_interface.c
index ea3c011..9f5db14 100644
--- a/drivers/staging/wilc1000/host_interface.c
+++ b/drivers/staging/wilc1000/host_interface.c
@@ -259,7 +259,7 @@ static u8 ch_no;
 static u8 set_ip[2][4];
 static u8 get_ip[2][4];
 static u32 inactive_time;
-static u8 gu8DelBcn;
+static u8 del_beacon;
 static u32 gu32WidConnRstHack;
 
 u8 *gu8FlushedJoinReq;
@@ -2373,7 +2373,7 @@ static void Handle_DelBeacon(struct host_if_drv *hif_drv)
 	strWID.id = (u16)WID_DEL_BEACON;
 	strWID.type = WID_CHAR;
 	strWID.size = sizeof(char);
-	strWID.val = &gu8DelBcn;
+	strWID.val = &del_beacon;
 
 	if (strWID.val == NULL)
 		return;
-- 
1.9.1

