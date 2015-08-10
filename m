Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pd0-f170.google.com ([209.85.192.170]:33907 "EHLO
	mail-pd0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752487AbbHJCdf (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 9 Aug 2015 22:33:35 -0400
Received: by pdbfa8 with SMTP id fa8so25731251pdb.1
        for <linux-wireless@vger.kernel.org>; Sun, 09 Aug 2015 19:33:34 -0700 (PDT)
From: Chaehyun Lim <chaehyun.lim@gmail.com>
To: gregkh@linuxfoundation.org
Cc: johnny.kim@atmel.com, rachel.kim@atmel.com, dean.lee@atmel.com,
	chris.park@atmel.com, linux-wireless@vger.kernel.org,
	devel@driverdev.osuosl.org, Chaehyun Lim <chaehyun.lim@gmail.com>
Subject: [PATCH 02/11] staging: wilc1000: use strlen instead of WILC_strlen
Date: Mon, 10 Aug 2015 11:33:13 +0900
Message-Id: <1439174002-7365-2-git-send-email-chaehyun.lim@gmail.com> (sfid-20150810_043348_959456_CCEDAC94)
In-Reply-To: <1439174002-7365-1-git-send-email-chaehyun.lim@gmail.com>
References: <1439174002-7365-1-git-send-email-chaehyun.lim@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Use strlen instead of WILC_strlen that is a custom function.

Signed-off-by: Chaehyun Lim <chaehyun.lim@gmail.com>
---
 drivers/staging/wilc1000/coreconfigurator.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/staging/wilc1000/coreconfigurator.c b/drivers/staging/wilc1000/coreconfigurator.c
index a88b796..c59d9ba 100644
--- a/drivers/staging/wilc1000/coreconfigurator.c
+++ b/drivers/staging/wilc1000/coreconfigurator.c
@@ -1577,8 +1577,8 @@ s32 further_process_response(u8 *resp,
 	case WID_ADR:
 		create_mac_addr(cfg_str, resp + idx);
 
-		WILC_strncpy(pstrWIDresult->ps8WidVal, cfg_str, WILC_strlen(cfg_str));
-		pstrWIDresult->ps8WidVal[WILC_strlen(cfg_str)] = '\0';
+		WILC_strncpy(pstrWIDresult->ps8WidVal, cfg_str, strlen(cfg_str));
+		pstrWIDresult->ps8WidVal[strlen(cfg_str)] = '\0';
 		break;
 
 	case WID_IP:
-- 
1.9.1

