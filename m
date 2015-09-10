Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pa0-f54.google.com ([209.85.220.54]:33985 "EHLO
	mail-pa0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752256AbbIJTPE (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 10 Sep 2015 15:15:04 -0400
Received: by padhy16 with SMTP id hy16so50952268pad.1
        for <linux-wireless@vger.kernel.org>; Thu, 10 Sep 2015 12:15:04 -0700 (PDT)
From: Chaehyun Lim <chaehyun.lim@gmail.com>
To: gregkh@linuxfoundation.org
Cc: johnny.kim@atmel.com, rachel.kim@atmel.com, chris.park@atmel.com,
	tony.cho@atmel.com, glen.lee@atmel.com, leo.kim@atmel.com,
	linux-wireless@vger.kernel.org, devel@driverdev.osuosl.org,
	Chaehyun Lim <chaehyun.lim@gmail.com>
Subject: [PATCH V2 08/31] staging: wilc1000: rename WILC_WFI_set_default_key
Date: Fri, 11 Sep 2015 04:14:07 +0900
Message-Id: <1441912470-3371-8-git-send-email-chaehyun.lim@gmail.com> (sfid-20150910_211507_555261_2CF5D2AC)
In-Reply-To: <1441912470-3371-1-git-send-email-chaehyun.lim@gmail.com>
References: <1441912470-3371-1-git-send-email-chaehyun.lim@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This patch replaces WILC_WFI_set_default_key with wilc_set_default_key
to avoid CamelCase.

Signed-off-by: Chaehyun Lim <chaehyun.lim@gmail.com>
---
V2: to make function name simple

 drivers/staging/wilc1000/wilc_wfi_cfgoperations.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/staging/wilc1000/wilc_wfi_cfgoperations.c b/drivers/staging/wilc1000/wilc_wfi_cfgoperations.c
index 8f90e48..ca7a36f 100644
--- a/drivers/staging/wilc1000/wilc_wfi_cfgoperations.c
+++ b/drivers/staging/wilc1000/wilc_wfi_cfgoperations.c
@@ -1566,7 +1566,7 @@ static int wilc_get_key(struct wiphy *wiphy, struct net_device *netdev, u8 key_i
 }
 
 /**
- *  @brief      WILC_WFI_set_default_key
+ *  @brief      wilc_set_default_key
  *  @details    Set the default management frame key on an interface
  *  @param[in]
  *  @return     int : Return 0 on Success.
@@ -1574,8 +1574,8 @@ static int wilc_get_key(struct wiphy *wiphy, struct net_device *netdev, u8 key_i
  *  @date	01 MAR 2012
  *  @version	1.0
  */
-static int WILC_WFI_set_default_key(struct wiphy *wiphy, struct net_device *netdev, u8 key_index,
-				    bool unicast, bool multicast)
+static int wilc_set_default_key(struct wiphy *wiphy, struct net_device *netdev, u8 key_index,
+				bool unicast, bool multicast)
 {
 	s32 s32Error = WILC_SUCCESS;
 	struct WILC_WFI_priv *priv;
@@ -3565,7 +3565,7 @@ static struct cfg80211_ops WILC_WFI_cfg80211_ops = {
 	.add_key = wilc_add_key,
 	.del_key = wilc_del_key,
 	.get_key = wilc_get_key,
-	.set_default_key = WILC_WFI_set_default_key,
+	.set_default_key = wilc_set_default_key,
 	#ifdef WILC_AP_EXTERNAL_MLME
 	.add_virtual_intf = WILC_WFI_add_virt_intf,
 	.del_virtual_intf = WILC_WFI_del_virt_intf,
-- 
2.5.1

