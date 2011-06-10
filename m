Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.123]:51187 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758045Ab1FJUL5 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 10 Jun 2011 16:11:57 -0400
Date: Fri, 10 Jun 2011 15:11:55 -0500
From: Larry Finger <Larry.Finger@lwfinger.net>
To: John W Linville <linville@tuxdriver.com>
Cc: chaoming_li@realsil.com.cn, linux-wireless@vger.kernel.org
Subject: [PATCH 12/13] rtlwifi: Fix build problems introduced by merging
 rtl8192de
Message-ID: <4df27a8b.YldKf4dbdMxD7qWs%Larry.Finger@lwfinger.net> (sfid-20110610_221200_098363_37BAAC6D)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

These patches allow compilation of rtlwifi, rtl8192c_common,
rtl8192ce, rtl8192cu and rtl8192se to compile after rtl8192de
was added.

Signed-off-by: Larry Finger <Larry.Finger@lwfinger.net>
---

Index: wireless-testing-new/drivers/net/wireless/rtlwifi/wifi.h
===================================================================
--- wireless-testing-new.orig/drivers/net/wireless/rtlwifi/wifi.h
+++ wireless-testing-new/drivers/net/wireless/rtlwifi/wifi.h
@@ -303,9 +303,6 @@ enum hw_variables {
 	HW_VAR_DATA_FILTER,
 };
 
-#define HWSET_MAX_SIZE				128
-#define EFUSE_MAX_SECTION			16
-
 enum _RT_MEDIA_STATUS {
 	RT_MEDIA_DISCONNECT = 0,
 	RT_MEDIA_CONNECT = 1
Index: wireless-testing-new/drivers/net/wireless/rtlwifi/rtl8192ce/reg.h
===================================================================
--- wireless-testing-new.orig/drivers/net/wireless/rtlwifi/rtl8192ce/reg.h
+++ wireless-testing-new/drivers/net/wireless/rtlwifi/rtl8192ce/reg.h
@@ -1203,7 +1203,9 @@
 #define EPROM_CMD_CONFIG			0x3
 #define EPROM_CMD_LOAD				1
 
+#define HWSET_MAX_SIZE				128
 #define	HWSET_MAX_SIZE_92S			HWSET_MAX_SIZE
+#define EFUSE_MAX_SECTION			16
 
 #define	WL_HWPDN_EN				BIT(0)
 
