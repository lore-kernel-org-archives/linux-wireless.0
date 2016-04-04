Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pf0-f195.google.com ([209.85.192.195]:33714 "EHLO
	mail-pf0-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753374AbcDDLFI (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 4 Apr 2016 07:05:08 -0400
Received: by mail-pf0-f195.google.com with SMTP id e190so4749547pfe.0
        for <linux-wireless@vger.kernel.org>; Mon, 04 Apr 2016 04:05:08 -0700 (PDT)
From: Chaehyun Lim <chaehyun.lim@gmail.com>
To: gregkh@linuxfoundation.org
Cc: johnny.kim@atmel.com, austin.shin@atmel.com, chris.park@atmel.com,
	tony.cho@atmel.com, glen.lee@atmel.com, leo.kim@atmel.com,
	linux-wireless@vger.kernel.org, devel@driverdev.osuosl.org,
	Chaehyun Lim <chaehyun.lim@gmail.com>
Subject: [PATCH 2/8] staging: wilc1000: move Handle_ScanDone function declaration
Date: Mon,  4 Apr 2016 20:04:44 +0900
Message-Id: <1459767890-9709-2-git-send-email-chaehyun.lim@gmail.com> (sfid-20160404_130514_917308_D5A4243E)
In-Reply-To: <1459767890-9709-1-git-send-email-chaehyun.lim@gmail.com>
References: <1459767890-9709-1-git-send-email-chaehyun.lim@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Handle_ScanDone function declaration is moved to front of
host_interface.c file.

Signed-off-by: Chaehyun Lim <chaehyun.lim@gmail.com>
---
 drivers/staging/wilc1000/host_interface.c | 4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff --git a/drivers/staging/wilc1000/host_interface.c b/drivers/staging/wilc1000/host_interface.c
index b8dae09..aa95eda 100644
--- a/drivers/staging/wilc1000/host_interface.c
+++ b/drivers/staging/wilc1000/host_interface.c
@@ -263,6 +263,7 @@ static struct wilc_vif *join_req_vif;
 
 static void *host_int_ParseJoinBssParam(struct network_info *ptstrNetworkInfo);
 static int host_int_get_ipaddress(struct wilc_vif *vif, u8 *ip_addr, u8 idx);
+static s32 Handle_ScanDone(struct wilc_vif *vif, enum scan_event enuEvent);
 
 /* The u8IfIdx starts from 0 to NUM_CONCURRENT_IFC -1, but 0 index used as
  * special purpose in wilc device, so we add 1 to the index to starts from 1.
@@ -730,9 +731,6 @@ unlock:
 	return result;
 }
 
-static s32 Handle_ScanDone(struct wilc_vif *vif,
-			   enum scan_event enuEvent);
-
 static s32 Handle_Scan(struct wilc_vif *vif,
 		       struct scan_attr *pstrHostIFscanAttr)
 {
-- 
2.8.0

