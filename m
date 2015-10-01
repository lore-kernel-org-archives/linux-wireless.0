Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pa0-f42.google.com ([209.85.220.42]:33305 "EHLO
	mail-pa0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933013AbbJANoj (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 1 Oct 2015 09:44:39 -0400
Received: by pacex6 with SMTP id ex6so75453544pac.0
        for <linux-wireless@vger.kernel.org>; Thu, 01 Oct 2015 06:44:39 -0700 (PDT)
From: Chaehyun Lim <chaehyun.lim@gmail.com>
To: gregkh@linuxfoundation.org
Cc: johnny.kim@atmel.com, rachel.kim@atmel.com, chris.park@atmel.com,
	tony.cho@atmel.com, glen.lee@atmel.com, leo.kim@atmel.com,
	linux-wireless@vger.kernel.org, devel@driverdev.osuosl.org,
	Chaehyun Lim <chaehyun.lim@gmail.com>
Subject: [PATCH 10/12] staging: wilc1000: set_channel: fix data type of s32Error
Date: Thu,  1 Oct 2015 22:43:57 +0900
Message-Id: <1443707039-18433-10-git-send-email-chaehyun.lim@gmail.com> (sfid-20151001_154443_094368_CDBAE3AA)
In-Reply-To: <1443707039-18433-1-git-send-email-chaehyun.lim@gmail.com>
References: <1443707039-18433-1-git-send-email-chaehyun.lim@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This patch changes data type of s32Error variable from s32 to int
because return type of this function is int.

Signed-off-by: Chaehyun Lim <chaehyun.lim@gmail.com>
---
 drivers/staging/wilc1000/wilc_wfi_cfgoperations.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/staging/wilc1000/wilc_wfi_cfgoperations.c b/drivers/staging/wilc1000/wilc_wfi_cfgoperations.c
index 732d631..3b32a6c 100644
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

