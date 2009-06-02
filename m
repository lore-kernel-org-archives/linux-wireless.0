Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:40234 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759204AbZFBLNB (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 2 Jun 2009 07:13:01 -0400
Message-Id: <20090602110150.955739036@sipsolutions.net>
References: <20090602110136.631660156@sipsolutions.net>
Date: Tue, 02 Jun 2009 13:01:42 +0200
From: Johannes Berg <johannes@sipsolutions.net>
To: John Linville <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org
Subject: [PATCH 6/6 v2] iwm: port to new cfg80211 rfkill
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Which means removing all rfkill code since it only does
soft-kill which cfg80211 will now handle in exactly the
same way the driver did.

Signed-off-by: Johannes Berg <johannes@sipsolutions.net>
---
 drivers/net/wireless/iwmc3200wifi/Kconfig  |    1 
 drivers/net/wireless/iwmc3200wifi/Makefile |    2 
 drivers/net/wireless/iwmc3200wifi/iwm.h    |    4 -
 drivers/net/wireless/iwmc3200wifi/netdev.c |   10 ---
 drivers/net/wireless/iwmc3200wifi/rfkill.c |   83 -----------------------------
 5 files changed, 1 insertion(+), 99 deletions(-)

--- wireless-testing.orig/drivers/net/wireless/iwmc3200wifi/Makefile	2009-06-02 12:53:46.000000000 +0200
+++ wireless-testing/drivers/net/wireless/iwmc3200wifi/Makefile	2009-06-02 12:55:23.000000000 +0200
@@ -1,5 +1,5 @@
 obj-$(CONFIG_IWM) := iwmc3200wifi.o
 iwmc3200wifi-objs += main.o netdev.o rx.o tx.o sdio.o hal.o fw.o
-iwmc3200wifi-objs += commands.o wext.o cfg80211.o eeprom.o rfkill.o
+iwmc3200wifi-objs += commands.o wext.o cfg80211.o eeprom.o
 
 iwmc3200wifi-$(CONFIG_IWM_DEBUG) += debugfs.o
--- wireless-testing.orig/drivers/net/wireless/iwmc3200wifi/rfkill.c	2009-06-02 12:53:46.000000000 +0200
+++ /dev/null	1970-01-01 00:00:00.000000000 +0000
@@ -1,83 +0,0 @@
-/*
- * Intel Wireless Multicomm 3200 WiFi driver
- *
- * Copyright (C) 2009 Intel Corporation <ilw@linux.intel.com>
- * Samuel Ortiz <samuel.ortiz@intel.com>
- * Zhu Yi <yi.zhu@intel.com>
- *
- * This program is free software; you can redistribute it and/or
- * modify it under the terms of the GNU General Public License version
- * 2 as published by the Free Software Foundation.
- *
- * This program is distributed in the hope that it will be useful,
- * but WITHOUT ANY WARRANTY; without even the implied warranty of
- * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
- * GNU General Public License for more details.
- *
- * You should have received a copy of the GNU General Public License
- * along with this program; if not, write to the Free Software
- * Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston, MA
- * 02110-1301, USA.
- *
- */
-
-#include <linux/rfkill.h>
-
-#include "iwm.h"
-
-static int iwm_rfkill_set_block(void *data, bool blocked)
-{
-	struct iwm_priv *iwm = data;
-
-	if (!blocked) {
-		if (test_bit(IWM_RADIO_RFKILL_HW, &iwm->radio))
-			return -EBUSY;
-
-		if (test_and_clear_bit(IWM_RADIO_RFKILL_SW, &iwm->radio) &&
-		    (iwm_to_ndev(iwm)->flags & IFF_UP))
-			return iwm_up(iwm);
-	} else {
-		if (!test_and_set_bit(IWM_RADIO_RFKILL_SW, &iwm->radio))
-			return iwm_down(iwm);
-	}
-
-	return 0;
-}
-
-static const struct rfkill_ops iwm_rfkill_ops = {
-	.set_block = iwm_rfkill_set_block,
-};
-
-int iwm_rfkill_init(struct iwm_priv *iwm)
-{
-	int ret;
-
-	iwm->rfkill = rfkill_alloc(KBUILD_MODNAME,
-				   iwm_to_dev(iwm),
-				   RFKILL_TYPE_WLAN,
-				   &iwm_rfkill_ops, iwm);
-	if (!iwm->rfkill) {
-		IWM_ERR(iwm, "Unable to allocate rfkill device\n");
-		return -ENOMEM;
-	}
-
-	ret = rfkill_register(iwm->rfkill);
-	if (ret) {
-		IWM_ERR(iwm, "Failed to register rfkill device\n");
-		goto fail;
-	}
-
-	return 0;
- fail:
-	rfkill_destroy(iwm->rfkill);
-	return ret;
-}
-
-void iwm_rfkill_exit(struct iwm_priv *iwm)
-{
-	if (iwm->rfkill) {
-		rfkill_unregister(iwm->rfkill);
-		rfkill_destroy(iwm->rfkill);
-	}
-	iwm->rfkill = NULL;
-}
--- wireless-testing.orig/drivers/net/wireless/iwmc3200wifi/iwm.h	2009-06-02 12:53:46.000000000 +0200
+++ wireless-testing/drivers/net/wireless/iwmc3200wifi/iwm.h	2009-06-02 12:55:23.000000000 +0200
@@ -343,8 +343,4 @@ int iwm_rx_handle_resp(struct iwm_priv *
 		       struct iwm_wifi_cmd *cmd);
 void iwm_rx_free(struct iwm_priv *iwm);
 
-/* RF Kill API */
-int iwm_rfkill_init(struct iwm_priv *iwm);
-void iwm_rfkill_exit(struct iwm_priv *iwm);
-
 #endif
--- wireless-testing.orig/drivers/net/wireless/iwmc3200wifi/netdev.c	2009-06-02 12:53:46.000000000 +0200
+++ wireless-testing/drivers/net/wireless/iwmc3200wifi/netdev.c	2009-06-02 12:55:23.000000000 +0200
@@ -136,17 +136,8 @@ void *iwm_if_alloc(int sizeof_bus, struc
 
 	wdev->netdev = ndev;
 
-	ret = iwm_rfkill_init(iwm);
-	if (ret) {
-		dev_err(dev, "Failed to init rfkill\n");
-		goto out_rfkill;
-	}
-
 	return iwm;
 
- out_rfkill:
-	unregister_netdev(ndev);
-
  out_ndev:
 	free_netdev(ndev);
 
@@ -162,7 +153,6 @@ void iwm_if_free(struct iwm_priv *iwm)
 	if (!iwm_to_ndev(iwm))
 		return;
 
-	iwm_rfkill_exit(iwm);
 	unregister_netdev(iwm_to_ndev(iwm));
 	free_netdev(iwm_to_ndev(iwm));
 	iwm_wdev_free(iwm);
--- wireless-testing.orig/drivers/net/wireless/iwmc3200wifi/Kconfig	2009-06-02 12:53:46.000000000 +0200
+++ wireless-testing/drivers/net/wireless/iwmc3200wifi/Kconfig	2009-06-02 12:55:23.000000000 +0200
@@ -3,7 +3,6 @@ config IWM
 	depends on MMC && WLAN_80211 && EXPERIMENTAL
 	select LIB80211
 	select FW_LOADER
-	select RFKILL
 
 config IWM_DEBUG
 	bool "Enable full debugging output in iwmc3200wifi"

-- 

