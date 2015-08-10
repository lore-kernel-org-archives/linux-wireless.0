Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pa0-f42.google.com ([209.85.220.42]:36847 "EHLO
	mail-pa0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752509AbbHJCdk (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 9 Aug 2015 22:33:40 -0400
Received: by pacrr5 with SMTP id rr5so92580207pac.3
        for <linux-wireless@vger.kernel.org>; Sun, 09 Aug 2015 19:33:40 -0700 (PDT)
From: Chaehyun Lim <chaehyun.lim@gmail.com>
To: gregkh@linuxfoundation.org
Cc: johnny.kim@atmel.com, rachel.kim@atmel.com, dean.lee@atmel.com,
	chris.park@atmel.com, linux-wireless@vger.kernel.org,
	devel@driverdev.osuosl.org, Chaehyun Lim <chaehyun.lim@gmail.com>
Subject: [PATCH 04/11] staging: wilc1000: Use strncpy instead of WILC_strncpy
Date: Mon, 10 Aug 2015 11:33:15 +0900
Message-Id: <1439174002-7365-4-git-send-email-chaehyun.lim@gmail.com> (sfid-20150810_043359_099815_8B08AB7C)
In-Reply-To: <1439174002-7365-1-git-send-email-chaehyun.lim@gmail.com>
References: <1439174002-7365-1-git-send-email-chaehyun.lim@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Use strncpy instead of WILC_strncpy that is a custom function

Signed-off-by: Chaehyun Lim <chaehyun.lim@gmail.com>
---
 drivers/staging/wilc1000/coreconfigurator.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/staging/wilc1000/coreconfigurator.c b/drivers/staging/wilc1000/coreconfigurator.c
index c59d9ba..a950d40 100644
--- a/drivers/staging/wilc1000/coreconfigurator.c
+++ b/drivers/staging/wilc1000/coreconfigurator.c
@@ -1577,7 +1577,7 @@ s32 further_process_response(u8 *resp,
 	case WID_ADR:
 		create_mac_addr(cfg_str, resp + idx);
 
-		WILC_strncpy(pstrWIDresult->ps8WidVal, cfg_str, strlen(cfg_str));
+		strncpy(pstrWIDresult->ps8WidVal, cfg_str, strlen(cfg_str));
 		pstrWIDresult->ps8WidVal[strlen(cfg_str)] = '\0';
 		break;
 
-- 
1.9.1

