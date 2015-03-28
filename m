Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pd0-f180.google.com ([209.85.192.180]:36086 "EHLO
	mail-pd0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750917AbbC1MNL (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 28 Mar 2015 08:13:11 -0400
Received: by pdcp1 with SMTP id p1so32004525pdc.3
        for <linux-wireless@vger.kernel.org>; Sat, 28 Mar 2015 05:13:10 -0700 (PDT)
From: Taehee Yoo <ap420073@gmail.com>
To: Larry.Finger@lwfinger.net, ap420073@gmail.com
Cc: linux-wireless@vger.kernel.org
Subject: [PATCH] rtlwifi: rtl8192c: Change REG_C2HEVT_CLEAR and REG_USTIME_TSF
Date: Sat, 28 Mar 2015 21:12:50 +0900
Message-Id: <1427544770-28523-1-git-send-email-ap420073@gmail.com> (sfid-20150328_131321_984957_79880532)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

in the rtl8192ce/reg.h, REG_C2HEVT_CLEAR register's address is 0x01BF
but, vendor driver's address is 0x01AF. so i change 0x01BF to 0x01AF.
also in the rtl8192ce/reg.h, 0x0551 is REG_USTIME_TSF, but vendor driver
define REG_BCN_CTRL_1. so i change the REG_USTIME_TSF to REG_BCN_CTRL_1.

according to r8192c vendor driver, rtl8192c do not use REG_USTIME_TSF.

Signed-off-by: Taehee Yoo <ap420073@gmail.com>
---
 drivers/net/wireless/rtlwifi/rtl8192ce/reg.h | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/rtlwifi/rtl8192ce/reg.h b/drivers/net/wireless/rtlwifi/rtl8192ce/reg.h
index dc8460c..21c0fc9 100644
--- a/drivers/net/wireless/rtlwifi/rtl8192ce/reg.h
+++ b/drivers/net/wireless/rtlwifi/rtl8192ce/reg.h
@@ -117,8 +117,8 @@
 #define REG_MBIST_DONE				0x0178
 #define REG_MBIST_FAIL				0x017C
 #define REG_C2HEVT_MSG_NORMAL			0x01A0
+#define REG_C2HEVT_CLEAR			0x01AF
 #define REG_C2HEVT_MSG_TEST			0x01B8
-#define REG_C2HEVT_CLEAR			0x01BF
 #define REG_MCUTST_1				0x01c0
 #define REG_FMETHR				0x01C8
 #define REG_HMETFR				0x01CC
@@ -231,7 +231,7 @@
 #define REG_RD_NAV_NXT				0x0544
 #define REG_NAV_PROT_LEN			0x0546
 #define REG_BCN_CTRL				0x0550
-#define REG_USTIME_TSF				0x0551
+#define REG_BCN_CTRL_1				0x0551
 #define REG_MBID_NUM				0x0552
 #define REG_DUAL_TSF_RST			0x0553
 #define REG_BCN_INTERVAL			0x0554
-- 
1.9.1

