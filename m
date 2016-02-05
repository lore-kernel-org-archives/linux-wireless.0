Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mout.kundenserver.de ([212.227.17.24]:65255 "EHLO
	mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751762AbcBEPWu (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 5 Feb 2016 10:22:50 -0500
From: Arnd Bergmann <arnd@arndb.de>
To: Glen Lee <glen.lee@atmel.com>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: linux-arm-kernel@lists.infradead.org,
	Arnd Bergmann <arnd@arndb.de>,
	Johnny Kim <johnny.kim@atmel.com>,
	Austin Shin <austin.shin@atmel.com>,
	Chris Park <chris.park@atmel.com>,
	Tony Cho <tony.cho@atmel.com>, Leo Kim <leo.kim@atmel.com>,
	linux-wireless@vger.kernel.org, devel@driverdev.osuosl.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH] staging: wilc1000: fix compilation without CONFIG_PM
Date: Fri,  5 Feb 2016 16:21:50 +0100
Message-Id: <1454685729-3663377-1-git-send-email-arnd@arndb.de> (sfid-20160205_162309_430361_67E55CCD)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

After the addition of the wakeup code in wilc1000, it no longer
builds when CONFIG_PM is disabled:

drivers/staging/wilc1000/wilc_wfi_cfgoperations.c: In function 'wilc_create_wiphy':
drivers/staging/wilc1000/wilc_wfi_cfgoperations.c:2632:13: error: 'struct wiphy' has no member named 'wowlan'
  wdev->wiphy->wowlan = &wowlan_support;

This marks the wowlan_support variable as __maybe_unused and hides
the reference when CONFIG_PM is disabled to avoid the build error.

Signed-off-by: Arnd Bergmann <arnd@arndb.de>
Fixes: 73584a40d748 ("staging: wilc1000: add ops resuem/suspend/wakeup in cfg80211")
---
 drivers/staging/wilc1000/wilc_wfi_cfgoperations.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/staging/wilc1000/wilc_wfi_cfgoperations.c b/drivers/staging/wilc1000/wilc_wfi_cfgoperations.c
index 4eede2b4e661..7e6262026070 100644
--- a/drivers/staging/wilc1000/wilc_wfi_cfgoperations.c
+++ b/drivers/staging/wilc1000/wilc_wfi_cfgoperations.c
@@ -74,7 +74,7 @@ static const struct ieee80211_txrx_stypes
 	}
 };
 
-static const struct wiphy_wowlan_support wowlan_support = {
+static const struct wiphy_wowlan_support wowlan_support __maybe_unused = {
 	.flags = WIPHY_WOWLAN_ANY
 };
 
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
2.7.0

