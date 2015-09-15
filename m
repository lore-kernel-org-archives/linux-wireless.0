Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pa0-f51.google.com ([209.85.220.51]:33497 "EHLO
	mail-pa0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752181AbbIOFHm (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 15 Sep 2015 01:07:42 -0400
Received: by pacex6 with SMTP id ex6so165329454pac.0
        for <linux-wireless@vger.kernel.org>; Mon, 14 Sep 2015 22:07:42 -0700 (PDT)
From: Chaehyun Lim <chaehyun.lim@gmail.com>
To: gregkh@linuxfoundation.org
Cc: johnny.kim@atmel.com, rachel.kim@atmel.com, chris.park@atmel.com,
	tony.cho@atmel.com, glen.lee@atmel.com, leo.kim@atmel.com,
	linux-wireless@vger.kernel.org, devel@driverdev.osuosl.org,
	Chaehyun Lim <chaehyun.lim@gmail.com>
Subject: [PATCH 17/18] staging: wilc1000: remove if defined codes of FORCE_P2P_CLIENT
Date: Tue, 15 Sep 2015 14:06:27 +0900
Message-Id: <1442293588-15323-17-git-send-email-chaehyun.lim@gmail.com> (sfid-20150915_071652_432857_7E3F8712)
In-Reply-To: <1442293588-15323-1-git-send-email-chaehyun.lim@gmail.com>
References: <1442293588-15323-1-git-send-email-chaehyun.lim@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This patch removes if defined codes of FORCE_P2P_CLIENT.
This macro is deleted because it it commented out.

Signed-off-by: Chaehyun Lim <chaehyun.lim@gmail.com>
---
 drivers/staging/wilc1000/wilc_wfi_cfgoperations.c | 8 --------
 1 file changed, 8 deletions(-)

diff --git a/drivers/staging/wilc1000/wilc_wfi_cfgoperations.c b/drivers/staging/wilc1000/wilc_wfi_cfgoperations.c
index c3e0892..3ecf5b1 100644
--- a/drivers/staging/wilc1000/wilc_wfi_cfgoperations.c
+++ b/drivers/staging/wilc1000/wilc_wfi_cfgoperations.c
@@ -2028,11 +2028,7 @@ void WILC_WFI_CfgParseRxAction(u8 *buf, u32 len)
 
 	while (index < len) {
 		if (buf[index] == GO_INTENT_ATTR_ID) {
-			#ifdef FORCE_P2P_CLIENT
-			buf[index + 3] = (buf[index + 3]  & 0x01) | (0x0f << 1);
-			#else
 			buf[index + 3] = (buf[index + 3]  & 0x01) | (0x00 << 1);
-			#endif
 		}
 
 		if (buf[index] ==  CHANLIST_ATTR_ID)
@@ -2085,11 +2081,7 @@ void WILC_WFI_CfgParseTxAction(u8 *buf, u32 len, bool bOperChan, u8 iftype)
 
 	while (index < len) {
 		if (buf[index] == GO_INTENT_ATTR_ID) {
-			#ifdef FORCE_P2P_CLIENT
-			buf[index + 3] = (buf[index + 3]  & 0x01) | (0x00 << 1);
-			#else
 			buf[index + 3] = (buf[index + 3]  & 0x01) | (0x0f << 1);
-			#endif
 
 			break;
 		}
-- 
2.5.1

