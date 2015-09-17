Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pa0-f46.google.com ([209.85.220.46]:36579 "EHLO
	mail-pa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753955AbbIQHtT (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 17 Sep 2015 03:49:19 -0400
Received: by padhk3 with SMTP id hk3so13298114pad.3
        for <linux-wireless@vger.kernel.org>; Thu, 17 Sep 2015 00:49:18 -0700 (PDT)
From: Chaehyun Lim <chaehyun.lim@gmail.com>
To: gregkh@linuxfoundation.org
Cc: johnny.kim@atmel.com, rachel.kim@atmel.com, chris.park@atmel.com,
	tony.cho@atmel.com, glen.lee@atmel.com, leo.kim@atmel.com,
	linux-wireless@vger.kernel.org, devel@driverdev.osuosl.org,
	Chaehyun Lim <chaehyun.lim@gmail.com>
Subject: [PATCH V2 8/8] staging: wilc1000: remove declaration of wilc_get_chipid
Date: Thu, 17 Sep 2015 16:48:49 +0900
Message-Id: <1442476129-14908-8-git-send-email-chaehyun.lim@gmail.com> (sfid-20150917_094923_832375_A6076A7F)
In-Reply-To: <1442476129-14908-1-git-send-email-chaehyun.lim@gmail.com>
References: <1442476129-14908-1-git-send-email-chaehyun.lim@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This patch removes the declaration of wilc_get_chipid function.
It is included wilc_wlan_if.h that has declaration of wilc_get_chipid.

Signed-off-by: Chaehyun Lim <chaehyun.lim@gmail.com>
---
V2 : rebase latest staging-testing

 drivers/staging/wilc1000/host_interface.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/staging/wilc1000/host_interface.c b/drivers/staging/wilc1000/host_interface.c
index c63c5ee..703712e 100644
--- a/drivers/staging/wilc1000/host_interface.c
+++ b/drivers/staging/wilc1000/host_interface.c
@@ -1,5 +1,6 @@
 #include "host_interface.h"
 #include "coreconfigurator.h"
+#include "wilc_wlan_if.h"
 
 extern u8 connecting;
 
@@ -7211,8 +7212,6 @@ s32 host_int_edit_station(tstrWILC_WFIDrv *hWFIDrv, tstrWILC_AddStaParam *pstrSt
 	return s32Error;
 }
 
-u32 wilc_get_chipid(u8);
-
 s32 host_int_set_power_mgmt(tstrWILC_WFIDrv *hWFIDrv, bool bIsEnabled, u32 u32Timeout)
 {
 	s32 s32Error = 0;
-- 
2.5.1

