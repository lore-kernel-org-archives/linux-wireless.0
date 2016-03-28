Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pf0-f194.google.com ([209.85.192.194]:34073 "EHLO
	mail-pf0-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751643AbcC1E4S (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 28 Mar 2016 00:56:18 -0400
Received: by mail-pf0-f194.google.com with SMTP id n5so19126568pfn.1
        for <linux-wireless@vger.kernel.org>; Sun, 27 Mar 2016 21:56:18 -0700 (PDT)
From: Chaehyun Lim <chaehyun.lim@gmail.com>
To: gregkh@linuxfoundation.org
Cc: johnny.kim@atmel.com, austin.shin@atmel.com, chris.park@atmel.com,
	tony.cho@atmel.com, glen.lee@atmel.com, leo.kim@atmel.com,
	linux-wireless@vger.kernel.org, devel@driverdev.osuosl.org,
	Chaehyun Lim <chaehyun.lim@gmail.com>
Subject: [PATCH 4/5] staging: wilc1000: remove unused struct semaphore SemHandleUpdateStats
Date: Mon, 28 Mar 2016 13:55:59 +0900
Message-Id: <1459140960-10645-4-git-send-email-chaehyun.lim@gmail.com> (sfid-20160328_065621_537241_8CCC10E0)
In-Reply-To: <1459140960-10645-1-git-send-email-chaehyun.lim@gmail.com>
References: <1459140960-10645-1-git-send-email-chaehyun.lim@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

struct semaphore SemHandleUpdateStats is defined but never used in this
driver, so just remove it.

Signed-off-by: Chaehyun Lim <chaehyun.lim@gmail.com>
---
 drivers/staging/wilc1000/wilc_wfi_cfgoperations.c | 1 -
 drivers/staging/wilc1000/wilc_wfi_netdevice.h     | 1 -
 2 files changed, 2 deletions(-)

diff --git a/drivers/staging/wilc1000/wilc_wfi_cfgoperations.c b/drivers/staging/wilc1000/wilc_wfi_cfgoperations.c
index 5785dda..f6aec47 100644
--- a/drivers/staging/wilc1000/wilc_wfi_cfgoperations.c
+++ b/drivers/staging/wilc1000/wilc_wfi_cfgoperations.c
@@ -2262,7 +2262,6 @@ struct wireless_dev *wilc_create_wiphy(struct net_device *net, struct device *de
 	}
 
 	priv = wdev_priv(wdev);
-	sema_init(&(priv->SemHandleUpdateStats), 1);
 	priv->wdev = wdev;
 	wdev->wiphy->max_scan_ssids = MAX_NUM_PROBED_SSID;
 #ifdef CONFIG_PM
diff --git a/drivers/staging/wilc1000/wilc_wfi_netdevice.h b/drivers/staging/wilc1000/wilc_wfi_netdevice.h
index debb139..94a41b4 100644
--- a/drivers/staging/wilc1000/wilc_wfi_netdevice.h
+++ b/drivers/staging/wilc1000/wilc_wfi_netdevice.h
@@ -130,7 +130,6 @@ struct wilc_priv {
 	struct wilc_wfi_key *wilc_ptk[MAX_NUM_STA];
 	u8 wilc_groupkey;
 	/* semaphores */
-	struct semaphore SemHandleUpdateStats;
 	struct semaphore hSemScanReq;
 	/*  */
 	bool gbAutoRateAdjusted;
-- 
2.7.4

