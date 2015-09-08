Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pa0-f50.google.com ([209.85.220.50]:36738 "EHLO
	mail-pa0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755139AbbIHP4Y (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 8 Sep 2015 11:56:24 -0400
Received: by padhk3 with SMTP id hk3so42520851pad.3
        for <linux-wireless@vger.kernel.org>; Tue, 08 Sep 2015 08:56:24 -0700 (PDT)
From: Chaehyun Lim <chaehyun.lim@gmail.com>
To: gregkh@linuxfoundation.org
Cc: johnny.kim@atmel.com, rachel.kim@atmel.com, chris.park@atmel.com,
	linux-wireless@vger.kernel.org, devel@driverdev.osuosl.org,
	Chaehyun Lim <chaehyun.lim@gmail.com>
Subject: [PATCH 05/30] staging: wilc1000: rename WILC_WFI_del_key
Date: Wed,  9 Sep 2015 00:55:42 +0900
Message-Id: <1441727767-26026-5-git-send-email-chaehyun.lim@gmail.com> (sfid-20150908_175627_365354_259BACBA)
In-Reply-To: <1441727767-26026-1-git-send-email-chaehyun.lim@gmail.com>
References: <1441727767-26026-1-git-send-email-chaehyun.lim@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This patch replaces WILC_WFI_del_key with wilc_cfg80211_del_key to avoid
CamelCase.

Signed-off-by: Chaehyun Lim <chaehyun.lim@gmail.com>
---
 drivers/staging/wilc1000/wilc_wfi_cfgoperations.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/staging/wilc1000/wilc_wfi_cfgoperations.c b/drivers/staging/wilc1000/wilc_wfi_cfgoperations.c
index 0714034..1e08b0c 100644
--- a/drivers/staging/wilc1000/wilc_wfi_cfgoperations.c
+++ b/drivers/staging/wilc1000/wilc_wfi_cfgoperations.c
@@ -1403,7 +1403,7 @@ static int wilc_cfg80211_add_key(struct wiphy *wiphy, struct net_device *netdev,
 }
 
 /**
- *  @brief      WILC_WFI_del_key
+ *  @brief      wilc_cfg80211_del_key
  *  @details    Remove a key given the @mac_addr (%NULL for a group key)
  *                      and @key_index, return -ENOENT if the key doesn't exist.
  *  @param[in]
@@ -1412,7 +1412,7 @@ static int wilc_cfg80211_add_key(struct wiphy *wiphy, struct net_device *netdev,
  *  @date	01 MAR 2012
  *  @version	1.0
  */
-static int WILC_WFI_del_key(struct wiphy *wiphy, struct net_device *netdev,
+static int wilc_cfg80211_del_key(struct wiphy *wiphy, struct net_device *netdev,
 			    u8 key_index,
 			    bool pairwise,
 			    const u8 *mac_addr)
@@ -3608,7 +3608,7 @@ static struct cfg80211_ops WILC_WFI_cfg80211_ops = {
 	.connect = wilc_cfg80211_connect,
 	.disconnect = WILC_WFI_disconnect,
 	.add_key = wilc_cfg80211_add_key,
-	.del_key = WILC_WFI_del_key,
+	.del_key = wilc_cfg80211_del_key,
 	.get_key = WILC_WFI_get_key,
 	.set_default_key = WILC_WFI_set_default_key,
 	#ifdef WILC_AP_EXTERNAL_MLME
-- 
2.5.1

