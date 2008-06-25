Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from rgminet01.oracle.com ([148.87.113.118]:50207 "EHLO
	rgminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752667AbYFYEEw (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 25 Jun 2008 00:04:52 -0400
Date: Tue, 24 Jun 2008 21:02:46 -0700
From: Randy Dunlap <randy.dunlap@oracle.com>
To: linux-wireless@vger.kernel.org, yi.zhu@intel.com
Cc: linux-next@vger.kernel.org, akpm <akpm@linux-foundation.org>,
	linville@tuxdriver.com
Subject: [PATCH -next] iwlwifi: fix build for CONFIG_INPUT=n
Message-Id: <20080624210246.0fe18e2c.randy.dunlap@oracle.com> (sfid-20080625_060501_962645_7998AB4F)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Randy Dunlap <randy.dunlap@oracle.com>

Fix iwlwifi so that it builds cleanly with CONFIG_INPUT=n.
Also free the input device on exit.

drivers/built-in.o: In function `iwl_rfkill_unregister':
(.text+0xbf430): undefined reference to `input_unregister_device'
drivers/built-in.o: In function `iwl_rfkill_init':
(.text+0xbf51c): undefined reference to `input_allocate_device'
drivers/built-in.o: In function `iwl_rfkill_init':
(.text+0xbf5bf): undefined reference to `input_register_device'
drivers/built-in.o: In function `iwl_rfkill_init':
(.text+0xbf5e9): undefined reference to `input_free_device'
net/built-in.o: In function `rfkill_disconnect':
rfkill-input.c:(.text+0xe71e1): undefined reference to `input_close_device'
rfkill-input.c:(.text+0xe71e9): undefined reference to `input_unregister_handle'
net/built-in.o: In function `rfkill_connect':
rfkill-input.c:(.text+0xe723e): undefined reference to `input_register_handle'
rfkill-input.c:(.text+0xe724d): undefined reference to `input_open_device'
rfkill-input.c:(.text+0xe725c): undefined reference to `input_unregister_handle'
net/built-in.o: In function `rfkill_handler_init':
rfkill-input.c:(.init.text+0x36ec): undefined reference to `input_register_handler'
net/built-in.o: In function `rfkill_handler_exit':
rfkill-input.c:(.exit.text+0x112c): undefined reference to `input_unregister_handler'
make[1]: *** [.tmp_vmlinux1] Error 1

Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
---
 drivers/net/wireless/iwlwifi/Kconfig      |    2 +-
 drivers/net/wireless/iwlwifi/iwl-rfkill.c |   11 ++++++++++-
 2 files changed, 11 insertions(+), 2 deletions(-)

--- linux-next-20080624.orig/drivers/net/wireless/iwlwifi/Kconfig
+++ linux-next-20080624/drivers/net/wireless/iwlwifi/Kconfig
@@ -8,7 +8,7 @@ config IWLCORE
 	select MAC80211_LEDS if IWLWIFI_LEDS
 	select LEDS_CLASS if IWLWIFI_LEDS
 	select RFKILL if IWLWIFI_RFKILL
-	select RFKILL_INPUT if IWLWIFI_RFKILL
+	select RFKILL_INPUT if (IWLWIFI_RFKILL && INPUT)
 
 config IWLWIFI_LEDS
 	bool
--- linux-next-20080624.orig/drivers/net/wireless/iwlwifi/iwl-rfkill.c
+++ linux-next-20080624/drivers/net/wireless/iwlwifi/iwl-rfkill.c
@@ -95,6 +95,7 @@ int iwl_rfkill_init(struct iwl_priv *pri
 	priv->rfkill_mngr.rfkill->dev.class->suspend = NULL;
 	priv->rfkill_mngr.rfkill->dev.class->resume = NULL;
 
+#if defined(CONFIG_RFKILL_INPUT) || defined(CONFIG_RFKILL_INPUT_MODULE)
 	priv->rfkill_mngr.input_dev = input_allocate_device();
 	if (!priv->rfkill_mngr.input_dev) {
 		IWL_ERROR("Unable to allocate rfkill input device.\n");
@@ -109,6 +110,7 @@ int iwl_rfkill_init(struct iwl_priv *pri
 	priv->rfkill_mngr.input_dev->dev.parent = device;
 	priv->rfkill_mngr.input_dev->evbit[0] = BIT(EV_KEY);
 	set_bit(KEY_WLAN, priv->rfkill_mngr.input_dev->keybit);
+#endif
 
 	ret = rfkill_register(priv->rfkill_mngr.rfkill);
 	if (ret) {
@@ -116,11 +118,13 @@ int iwl_rfkill_init(struct iwl_priv *pri
 		goto free_input_dev;
 	}
 
+#if defined(CONFIG_RFKILL_INPUT) || defined(CONFIG_RFKILL_INPUT_MODULE)
 	ret = input_register_device(priv->rfkill_mngr.input_dev);
 	if (ret) {
 		IWL_ERROR("Unable to register rfkill input device: %d\n", ret);
 		goto unregister_rfkill;
 	}
+#endif
 
 	IWL_DEBUG_RF_KILL("RFKILL initialization complete.\n");
 	return ret;
@@ -130,8 +134,10 @@ unregister_rfkill:
 	priv->rfkill_mngr.rfkill = NULL;
 
 free_input_dev:
+#if defined(CONFIG_RFKILL_INPUT) || defined(CONFIG_RFKILL_INPUT_MODULE)
 	input_free_device(priv->rfkill_mngr.input_dev);
 	priv->rfkill_mngr.input_dev = NULL;
+#endif
 
 freed_rfkill:
 	if (priv->rfkill_mngr.rfkill != NULL)
@@ -147,13 +153,16 @@ EXPORT_SYMBOL(iwl_rfkill_init);
 void iwl_rfkill_unregister(struct iwl_priv *priv)
 {
 
+#if defined(CONFIG_RFKILL_INPUT) || defined(CONFIG_RFKILL_INPUT_MODULE)
 	if (priv->rfkill_mngr.input_dev)
 		input_unregister_device(priv->rfkill_mngr.input_dev);
+	input_free_device(priv->rfkill_mngr.input_dev);
+	priv->rfkill_mngr.input_dev = NULL;
+#endif
 
 	if (priv->rfkill_mngr.rfkill)
 		rfkill_unregister(priv->rfkill_mngr.rfkill);
 
-	priv->rfkill_mngr.input_dev = NULL;
 	priv->rfkill_mngr.rfkill = NULL;
 }
 EXPORT_SYMBOL(iwl_rfkill_unregister);


---
~Randy
Linux Plumbers Conference, 17-19 September 2008, Portland, Oregon USA
http://linuxplumbersconf.org/
