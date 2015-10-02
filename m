Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pa0-f48.google.com ([209.85.220.48]:34275 "EHLO
	mail-pa0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751235AbbJBHl7 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 2 Oct 2015 03:41:59 -0400
Received: by padhy16 with SMTP id hy16so99950097pad.1
        for <linux-wireless@vger.kernel.org>; Fri, 02 Oct 2015 00:41:58 -0700 (PDT)
From: Chaehyun Lim <chaehyun.lim@gmail.com>
To: gregkh@linuxfoundation.org
Cc: johnny.kim@atmel.com, rachel.kim@atmel.com, chris.park@atmel.com,
	tony.cho@atmel.com, glen.lee@atmel.com, leo.kim@atmel.com,
	linux-wireless@vger.kernel.org, devel@driverdev.osuosl.org,
	Chaehyun Lim <chaehyun.lim@gmail.com>
Subject: [PATCH V2 10/12] staging: wilc1000: set_channel: fix data type of s32Error
Date: Fri,  2 Oct 2015 16:41:19 +0900
Message-Id: <1443771681-15540-10-git-send-email-chaehyun.lim@gmail.com> (sfid-20151002_094201_861068_43ACDD14)
In-Reply-To: <1443771681-15540-1-git-send-email-chaehyun.lim@gmail.com>
References: <1443771681-15540-1-git-send-email-chaehyun.lim@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This patch changes data type of s32Error variable from s32 to int
because return type of this function is int.

Signed-off-by: Chaehyun Lim <chaehyun.lim@gmail.com>
---
V2: resend because 08/12 patch is changed.

 drivers/staging/wilc1000/wilc_wfi_cfgoperations.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/staging/wilc1000/wilc_wfi_cfgoperations.c b/drivers/staging/wilc1000/wilc_wfi_cfgoperations.c
index f98a807..692fef5 100644
--- a/drivers/staging/wilc1000/wilc_wfi_cfgoperations.c
+++ b/drivers/staging/wilc1000/wilc_wfi_cfgoperations.c
@@ -663,7 +663,7 @@ static int set_channel(struct wiphy *wiphy,
 {
 	u32 channelnum = 0;
 	struct wilc_priv *priv;
-	s32 s32Error = 0;
+	int s32Error = 0;
 
 	priv = wiphy_priv(wiphy);
 
-- 
2.6.0

