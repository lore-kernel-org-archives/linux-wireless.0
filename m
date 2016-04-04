Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pa0-f67.google.com ([209.85.220.67]:34130 "EHLO
	mail-pa0-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753829AbcDDLFO (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 4 Apr 2016 07:05:14 -0400
Received: by mail-pa0-f67.google.com with SMTP id hb4so4686013pac.1
        for <linux-wireless@vger.kernel.org>; Mon, 04 Apr 2016 04:05:14 -0700 (PDT)
From: Chaehyun Lim <chaehyun.lim@gmail.com>
To: gregkh@linuxfoundation.org
Cc: johnny.kim@atmel.com, austin.shin@atmel.com, chris.park@atmel.com,
	tony.cho@atmel.com, glen.lee@atmel.com, leo.kim@atmel.com,
	linux-wireless@vger.kernel.org, devel@driverdev.osuosl.org,
	Chaehyun Lim <chaehyun.lim@gmail.com>
Subject: [PATCH 4/8] staging: wilc1000: rename Handle_Scan
Date: Mon,  4 Apr 2016 20:04:46 +0900
Message-Id: <1459767890-9709-4-git-send-email-chaehyun.lim@gmail.com> (sfid-20160404_130521_870616_4F901FFA)
In-Reply-To: <1459767890-9709-1-git-send-email-chaehyun.lim@gmail.com>
References: <1459767890-9709-1-git-send-email-chaehyun.lim@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This patch renames Handle_Scan to handle_scan to avoid camelcase.

Signed-off-by: Chaehyun Lim <chaehyun.lim@gmail.com>
---
 drivers/staging/wilc1000/host_interface.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/staging/wilc1000/host_interface.c b/drivers/staging/wilc1000/host_interface.c
index e978208..053e6f1 100644
--- a/drivers/staging/wilc1000/host_interface.c
+++ b/drivers/staging/wilc1000/host_interface.c
@@ -731,7 +731,7 @@ unlock:
 	return result;
 }
 
-static s32 Handle_Scan(struct wilc_vif *vif,
+static s32 handle_scan(struct wilc_vif *vif,
 		       struct scan_attr *pstrHostIFscanAttr)
 {
 	s32 result = 0;
@@ -2515,7 +2515,7 @@ static int hostIFthread(void *pvArg)
 
 		switch (msg.id) {
 		case HOST_IF_MSG_SCAN:
-			Handle_Scan(msg.vif, &msg.body.scan_info);
+			handle_scan(msg.vif, &msg.body.scan_info);
 			break;
 
 		case HOST_IF_MSG_CONNECT:
-- 
2.8.0

