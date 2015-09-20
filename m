Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pa0-f50.google.com ([209.85.220.50]:36316 "EHLO
	mail-pa0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751624AbbITGvn (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 20 Sep 2015 02:51:43 -0400
Received: by padhk3 with SMTP id hk3so87318268pad.3
        for <linux-wireless@vger.kernel.org>; Sat, 19 Sep 2015 23:51:42 -0700 (PDT)
From: Chaehyun Lim <chaehyun.lim@gmail.com>
To: gregkh@linuxfoundation.org
Cc: johnny.kim@atmel.com, rachel.kim@atmel.com, chris.park@atmel.com,
	tony.cho@atmel.com, glen.lee@atmel.com, leo.kim@atmel.com,
	linux-wireless@vger.kernel.org, devel@driverdev.osuosl.org,
	Chaehyun Lim <chaehyun.lim@gmail.com>
Subject: [PATCH 02/18] staging: wilc1000: rename WILC_WFI_WiphyRegister
Date: Sun, 20 Sep 2015 15:51:09 +0900
Message-Id: <1442731885-4344-2-git-send-email-chaehyun.lim@gmail.com> (sfid-20150920_085206_375638_02C7549C)
In-Reply-To: <1442731885-4344-1-git-send-email-chaehyun.lim@gmail.com>
References: <1442731885-4344-1-git-send-email-chaehyun.lim@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This patch replaces WILC_WFI_WiphyRegister with wilc_create_wiphy to
avoid CamelCase.

Signed-off-by: Chaehyun Lim <chaehyun.lim@gmail.com>
---
 drivers/staging/wilc1000/linux_wlan.c             | 2 +-
 drivers/staging/wilc1000/wilc_wfi_cfgoperations.c | 4 ++--
 drivers/staging/wilc1000/wilc_wfi_cfgoperations.h | 2 +-
 3 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/staging/wilc1000/linux_wlan.c b/drivers/staging/wilc1000/linux_wlan.c
index ed6044e..4534fb9 100644
--- a/drivers/staging/wilc1000/linux_wlan.c
+++ b/drivers/staging/wilc1000/linux_wlan.c
@@ -1883,7 +1883,7 @@ int wilc_netdev_init(void)
 		{
 			struct wireless_dev *wdev;
 			/*Register WiFi*/
-			wdev = WILC_WFI_WiphyRegister(ndev);
+			wdev = wilc_create_wiphy(ndev);
 
 			#ifdef WILC_SDIO
 			/* set netdev, tony */
diff --git a/drivers/staging/wilc1000/wilc_wfi_cfgoperations.c b/drivers/staging/wilc1000/wilc_wfi_cfgoperations.c
index 239d0fc..e51745e 100644
--- a/drivers/staging/wilc1000/wilc_wfi_cfgoperations.c
+++ b/drivers/staging/wilc1000/wilc_wfi_cfgoperations.c
@@ -3519,7 +3519,7 @@ _fail_:
 
 }
 /**
- *  @brief      WILC_WFI_WiphyRegister
+ *  @brief      wilc_create_wiphy
  *  @details    Registering of the wiphy structure and interface modes
  *  @param[in]   NONE
  *  @return     NONE
@@ -3527,7 +3527,7 @@ _fail_:
  *  @date	01 MAR 2012
  *  @version	1.0
  */
-struct wireless_dev *WILC_WFI_WiphyRegister(struct net_device *net)
+struct wireless_dev *wilc_create_wiphy(struct net_device *net)
 {
 	struct wilc_priv *priv;
 	struct wireless_dev *wdev;
diff --git a/drivers/staging/wilc1000/wilc_wfi_cfgoperations.h b/drivers/staging/wilc1000/wilc_wfi_cfgoperations.h
index 67b8de3..579bf2b 100644
--- a/drivers/staging/wilc1000/wilc_wfi_cfgoperations.h
+++ b/drivers/staging/wilc1000/wilc_wfi_cfgoperations.h
@@ -92,7 +92,7 @@ static const struct ieee80211_txrx_stypes
 #define WILC_WFI_DWELL_ACTIVE  40
 
 struct wireless_dev *WILC_WFI_CfgAlloc(void);
-struct wireless_dev *WILC_WFI_WiphyRegister(struct net_device *net);
+struct wireless_dev *wilc_create_wiphy(struct net_device *net);
 void wilc_free_wiphy(struct net_device *net);
 int WILC_WFI_update_stats(struct wiphy *wiphy, u32 pktlen, u8 changed);
 int WILC_WFI_DeInitHostInt(struct net_device *net);
-- 
2.5.1

