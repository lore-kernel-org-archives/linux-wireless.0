Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pa0-f46.google.com ([209.85.220.46]:33350 "EHLO
	mail-pa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933013AbbJANom (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 1 Oct 2015 09:44:42 -0400
Received: by pacex6 with SMTP id ex6so75454711pac.0
        for <linux-wireless@vger.kernel.org>; Thu, 01 Oct 2015 06:44:42 -0700 (PDT)
From: Chaehyun Lim <chaehyun.lim@gmail.com>
To: gregkh@linuxfoundation.org
Cc: johnny.kim@atmel.com, rachel.kim@atmel.com, chris.park@atmel.com,
	tony.cho@atmel.com, glen.lee@atmel.com, leo.kim@atmel.com,
	linux-wireless@vger.kernel.org, devel@driverdev.osuosl.org,
	Chaehyun Lim <chaehyun.lim@gmail.com>
Subject: [PATCH 11/12] staging: wilc1000: set_channel: rename s32Error
Date: Thu,  1 Oct 2015 22:43:58 +0900
Message-Id: <1443707039-18433-11-git-send-email-chaehyun.lim@gmail.com> (sfid-20151001_154654_017350_4A741AA2)
In-Reply-To: <1443707039-18433-1-git-send-email-chaehyun.lim@gmail.com>
References: <1443707039-18433-1-git-send-email-chaehyun.lim@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This patch replaces s32Error with result to avoid camelcase.

Signed-off-by: Chaehyun Lim <chaehyun.lim@gmail.com>
---
 drivers/staging/wilc1000/wilc_wfi_cfgoperations.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/staging/wilc1000/wilc_wfi_cfgoperations.c b/drivers/staging/wilc1000/wilc_wfi_cfgoperations.c
index 3b32a6c..6db1325 100644
--- a/drivers/staging/wilc1000/wilc_wfi_cfgoperations.c
+++ b/drivers/staging/wilc1000/wilc_wfi_cfgoperations.c
@@ -663,7 +663,7 @@ static int set_channel(struct wiphy *wiphy,
 {
 	u32 channelnum = 0;
 	struct wilc_priv *priv;
-	int s32Error = 0;
+	int result = 0;
 
 	priv = wiphy_priv(wiphy);
 
@@ -671,12 +671,12 @@ static int set_channel(struct wiphy *wiphy,
 	PRINT_D(CFG80211_DBG, "Setting channel %d with frequency %d\n", channelnum, chandef->chan->center_freq);
 
 	u8CurrChannel = channelnum;
-	s32Error   = host_int_set_mac_chnl_num(priv->hWILCWFIDrv, channelnum);
+	result = host_int_set_mac_chnl_num(priv->hWILCWFIDrv, channelnum);
 
-	if (s32Error != 0)
+	if (result != 0)
 		PRINT_ER("Error in setting channel %d\n", channelnum);
 
-	return s32Error;
+	return result;
 }
 
 /**
-- 
2.6.0

