Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pf0-f170.google.com ([209.85.192.170]:35595 "EHLO
	mail-pf0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752301AbcBEJ5E (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 5 Feb 2016 04:57:04 -0500
From: Sudip Mukherjee <sudipm.mukherjee@gmail.com>
To: Johnny Kim <johnny.kim@atmel.com>,
	Austin Shin <austin.shin@atmel.com>,
	Chris Park <chris.park@atmel.com>,
	Tony Cho <tony.cho@atmel.com>, Glen Lee <glen.lee@atmel.com>,
	Leo Kim <leo.kim@atmel.com>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: linux-kernel@vger.kernel.org, kernel-testers@vger.kernel.org,
	linux-wireless@vger.kernel.org, devel@driverdev.osuosl.org,
	Sudip Mukherjee <sudipm.mukherjee@gmail.com>
Subject: [PATCH] staging: wilc1000: fix build failure
Date: Fri,  5 Feb 2016 15:26:54 +0530
Message-Id: <1454666214-7825-1-git-send-email-sudipm.mukherjee@gmail.com> (sfid-20160205_105733_737152_D50449DB)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

allmodconfig build of alpha, m68k, m32r, tilepro has failed with the
error:
drivers/staging/wilc1000/wilc_wfi_cfgoperations.c: In function 'wilc_create_wiphy':
drivers/staging/wilc1000/wilc_wfi_cfgoperations.c:2632:13:
	error: 'struct wiphy' has no member named 'wowlan'

Looking at other drivers wowlan can be only used when CONFIG_PM is
defined.

Fixes: 73584a40d748 ("staging: wilc1000: add ops resuem/suspend/wakeup in cfg80211")
Cc: Glen Lee <glen.lee@atmel.com>
Signed-off-by: Sudip Mukherjee <sudip@vectorindia.org>
---

builds of next-20160205.

I think I have seen the same report from 0day also when this commit was
in staging-testing.

 drivers/staging/wilc1000/wilc_wfi_cfgoperations.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/staging/wilc1000/wilc_wfi_cfgoperations.c b/drivers/staging/wilc1000/wilc_wfi_cfgoperations.c
index 4eede2b..08c28b7 100644
--- a/drivers/staging/wilc1000/wilc_wfi_cfgoperations.c
+++ b/drivers/staging/wilc1000/wilc_wfi_cfgoperations.c
@@ -2629,7 +2629,9 @@ struct wireless_dev *wilc_create_wiphy(struct net_device *net, struct device *de
 	sema_init(&(priv->SemHandleUpdateStats), 1);
 	priv->wdev = wdev;
 	wdev->wiphy->max_scan_ssids = MAX_NUM_PROBED_SSID;
+#ifdef CONFIG_PM
 	wdev->wiphy->wowlan = &wowlan_support;
+#endif
 	wdev->wiphy->max_num_pmkids = WILC_MAX_NUM_PMKIDS;
 	PRINT_INFO(CFG80211_DBG, "Max number of PMKIDs = %d\n", wdev->wiphy->max_num_pmkids);
 
-- 
1.9.1

