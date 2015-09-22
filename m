Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pa0-f47.google.com ([209.85.220.47]:36358 "EHLO
	mail-pa0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932186AbbIVJfX (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 22 Sep 2015 05:35:23 -0400
Received: by pacgz1 with SMTP id gz1so2040703pac.3
        for <linux-wireless@vger.kernel.org>; Tue, 22 Sep 2015 02:35:22 -0700 (PDT)
From: Chaehyun Lim <chaehyun.lim@gmail.com>
To: gregkh@linuxfoundation.org
Cc: johnny.kim@atmel.com, rachel.kim@atmel.com, chris.park@atmel.com,
	tony.cho@atmel.com, glen.lee@atmel.com, leo.kim@atmel.com,
	linux-wireless@vger.kernel.org, devel@driverdev.osuosl.org,
	Chaehyun Lim <chaehyun.lim@gmail.com>
Subject: [PATCH V2 06/16] staging: wilc1000: make mgmt_tx static
Date: Tue, 22 Sep 2015 18:34:51 +0900
Message-Id: <1442914501-2315-6-git-send-email-chaehyun.lim@gmail.com> (sfid-20150922_113529_479341_BAB300E0)
In-Reply-To: <1442914501-2315-1-git-send-email-chaehyun.lim@gmail.com>
References: <1442914501-2315-1-git-send-email-chaehyun.lim@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This patch makes mgmt_tx static. This function is used only at
wilc_wfi_cfgoperation.c file.

Signed-off-by: Chaehyun Lim <chaehyun.lim@gmail.com>
---
v2: rebase latest staging-testing

 drivers/staging/wilc1000/wilc_wfi_cfgoperations.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/staging/wilc1000/wilc_wfi_cfgoperations.c b/drivers/staging/wilc1000/wilc_wfi_cfgoperations.c
index 0c72c5e..0becefb 100644
--- a/drivers/staging/wilc1000/wilc_wfi_cfgoperations.c
+++ b/drivers/staging/wilc1000/wilc_wfi_cfgoperations.c
@@ -2354,10 +2354,10 @@ void WILC_WFI_add_wilcvendorspec(u8 *buff)
  */
 extern linux_wlan_t *g_linux_wlan;
 extern bool bEnablePS;
-int mgmt_tx(struct wiphy *wiphy,
-	    struct wireless_dev *wdev,
-	    struct cfg80211_mgmt_tx_params *params,
-	    u64 *cookie)
+static int mgmt_tx(struct wiphy *wiphy,
+		   struct wireless_dev *wdev,
+		   struct cfg80211_mgmt_tx_params *params,
+		   u64 *cookie)
 {
 	struct ieee80211_channel *chan = params->chan;
 	unsigned int wait = params->wait;
-- 
2.5.1

