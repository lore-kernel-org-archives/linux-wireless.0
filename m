Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pa0-f45.google.com ([209.85.220.45]:36712 "EHLO
	mail-pa0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752890AbbINDZA (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 13 Sep 2015 23:25:00 -0400
Received: by padhk3 with SMTP id hk3so129782723pad.3
        for <linux-wireless@vger.kernel.org>; Sun, 13 Sep 2015 20:25:00 -0700 (PDT)
From: Chaehyun Lim <chaehyun.lim@gmail.com>
To: gregkh@linuxfoundation.org
Cc: johnny.kim@atmel.com, rachel.kim@atmel.com, chris.park@atmel.com,
	tony.cho@atmel.com, glen.lee@atmel.com, leo.kim@atmel.com,
	linux-wireless@vger.kernel.org, devel@driverdev.osuosl.org,
	Chaehyun Lim <chaehyun.lim@gmail.com>
Subject: [PATCH V3 08/31] staging: wilc1000: rename WILC_WFI_set_default_key
Date: Mon, 14 Sep 2015 12:24:08 +0900
Message-Id: <1442201071-16155-8-git-send-email-chaehyun.lim@gmail.com> (sfid-20150914_052504_975333_3006E80B)
In-Reply-To: <1442201071-16155-1-git-send-email-chaehyun.lim@gmail.com>
References: <1442201071-16155-1-git-send-email-chaehyun.lim@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This patch replaces WILC_WFI_set_default_key with set_default_key to
avoid CamelCase.

Signed-off-by: Chaehyun Lim <chaehyun.lim@gmail.com>
---
V3: remove "wilc_" prefix

 drivers/staging/wilc1000/wilc_wfi_cfgoperations.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/staging/wilc1000/wilc_wfi_cfgoperations.c b/drivers/staging/wilc1000/wilc_wfi_cfgoperations.c
index 5794db3..f0065cb 100644
--- a/drivers/staging/wilc1000/wilc_wfi_cfgoperations.c
+++ b/drivers/staging/wilc1000/wilc_wfi_cfgoperations.c
@@ -1566,7 +1566,7 @@ static int get_key(struct wiphy *wiphy, struct net_device *netdev, u8 key_index,
 }
 
 /**
- *  @brief      WILC_WFI_set_default_key
+ *  @brief      set_default_key
  *  @details    Set the default management frame key on an interface
  *  @param[in]
  *  @return     int : Return 0 on Success.
@@ -1574,8 +1574,8 @@ static int get_key(struct wiphy *wiphy, struct net_device *netdev, u8 key_index,
  *  @date	01 MAR 2012
  *  @version	1.0
  */
-static int WILC_WFI_set_default_key(struct wiphy *wiphy, struct net_device *netdev, u8 key_index,
-				    bool unicast, bool multicast)
+static int set_default_key(struct wiphy *wiphy, struct net_device *netdev, u8 key_index,
+			   bool unicast, bool multicast)
 {
 	s32 s32Error = WILC_SUCCESS;
 	struct WILC_WFI_priv *priv;
@@ -3565,7 +3565,7 @@ static struct cfg80211_ops WILC_WFI_cfg80211_ops = {
 	.add_key = add_key,
 	.del_key = del_key,
 	.get_key = get_key,
-	.set_default_key = WILC_WFI_set_default_key,
+	.set_default_key = set_default_key,
 	#ifdef WILC_AP_EXTERNAL_MLME
 	.add_virtual_intf = WILC_WFI_add_virt_intf,
 	.del_virtual_intf = WILC_WFI_del_virt_intf,
-- 
2.5.1

