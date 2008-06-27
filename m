Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga09.intel.com ([134.134.136.24]:29771 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752028AbYF0JXD (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 27 Jun 2008 05:23:03 -0400
Subject: Re: [PATCH v2] iwl3945: fix up rfkill kconfig and input
From: Zhu Yi <yi.zhu@intel.com>
To: Randy Dunlap <randy.dunlap@oracle.com>
Cc: drago01 <drago01@gmail.com>, Ivo van Doorn <ivdoorn@gmail.com>,
	Abhijeet Kolekar <abhijeet.kolekar@intel.com>,
	"John W. Linville" <linville@tuxdriver.com>,
	Linux Wireless <linux-wireless@vger.kernel.org>
In-Reply-To: <4666621.1214520962096.JavaMail.oracle@acsmt301.oracle.com>
References: <f6ca9fed0806261455j17848d17pa011ae47246a32@mail.gmail.com>
	 <200806270015.00301.IvDoorn@gmail.com>
	 <f6ca9fed0806261527q75df34d4scbe36e2f63cec275@mail.gmail.com>
	 <200806270045.50169.IvDoorn@gmail.com>
	 <4666621.1214520962096.JavaMail.oracle@acsmt301.oracle.com>
Content-Type: multipart/mixed; boundary="=-3++uBbqEkqjHiYzelh38"
Date: Fri, 27 Jun 2008 17:21:53 +0800
Message-Id: <1214558514.14590.380.camel@debian.sh.intel.com> (sfid-20080627_112402_216117_116F060D)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-3++uBbqEkqjHiYzelh38
Content-Type: text/plain
Content-Transfer-Encoding: 7bit

On Thu, 2008-06-26 at 17:56 -0500, Randy Dunlap wrote:
> and in general select is OK on smallish library-like functions and
> should not be used on entire subsystems.  To me that means that it
> should not be used in CONFIG_INPUT....

Please see this patch.

John, please don't apply this one. I'll submit it inside a patch series
later.

Thanks,
-yi

>From 58c5dc44f8f615113d21b3545df2e193bf22cf75 Mon Sep 17 00:00:00 2001
From: Randy Dunlap <randy.dunlap@oracle.com>
Date: Fri, 27 Jun 2008 16:21:19 +0800
Subject: [PATCH] iwlwifi: fix build for CONFIG_INPUT=n

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
rfkill-input.c:(.text+0xe71e1): undefined reference to
`input_close_device'
rfkill-input.c:(.text+0xe71e9): undefined reference to
`input_unregister_handle'
net/built-in.o: In function `rfkill_connect':
rfkill-input.c:(.text+0xe723e): undefined reference to
`input_register_handle'
rfkill-input.c:(.text+0xe724d): undefined reference to
`input_open_device'
rfkill-input.c:(.text+0xe725c): undefined reference to
`input_unregister_handle'
net/built-in.o: In function `rfkill_handler_init':
rfkill-input.c:(.init.text+0x36ec): undefined reference to
`input_register_handler'
net/built-in.o: In function `rfkill_handler_exit':
rfkill-input.c:(.exit.text+0x112c): undefined reference to
`input_unregister_handler'
make[1]: *** [.tmp_vmlinux1] Error 1

The iwl3945 portion is done by Adel Gadllah <adel.gadllah@gmail.com>.
The patch fixes the RFKILL_INPUT dependency bug pointed by
Ivo van Doorn <ivdoorn@gmail.com>.

Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
Signed-off-by: Adel Gadllah <adel.gadllah@gmail.com>
Signed-off-by: Zhu Yi <yi.zhu@intel.com>
---
 drivers/net/wireless/iwlwifi/Kconfig        |    6 +++-
 drivers/net/wireless/iwlwifi/iwl-3945.h     |    4 +-
 drivers/net/wireless/iwlwifi/iwl-rfkill.c   |   34
+++++++++++++++----------
 drivers/net/wireless/iwlwifi/iwl3945-base.c |   36
+++++++++++++++-----------
 4 files changed, 48 insertions(+), 32 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/Kconfig
b/drivers/net/wireless/iwlwifi/Kconfig
index a382c00..82b66a3 100644
--- a/drivers/net/wireless/iwlwifi/Kconfig
+++ b/drivers/net/wireless/iwlwifi/Kconfig
@@ -8,7 +8,6 @@ config IWLCORE
 	select MAC80211_LEDS if IWLWIFI_LEDS
 	select LEDS_CLASS if IWLWIFI_LEDS
 	select RFKILL if IWLWIFI_RFKILL
-	select RFKILL_INPUT if IWLWIFI_RFKILL
 
 config IWLWIFI_LEDS
 	bool
@@ -105,6 +104,7 @@ config IWL3945
 	select IWLWIFI
 	select MAC80211_LEDS if IWL3945_LEDS
 	select LEDS_CLASS if IWL3945_LEDS
+	select RFKILL if IWL3945_RFKILL
 	---help---
 	  Select to build the driver supporting the:
 
@@ -127,6 +127,10 @@ config IWL3945
 	  say M here and read <file:Documentation/kbuild/modules.txt>.  The
 	  module will be called iwl3945.ko.
 
+config IWL3945_RFKILL
+	bool "Enable RF kill support in iwl3945 drivers"
+	depends on IWL3945
+
 config IWL3945_SPECTRUM_MEASUREMENT
 	bool "Enable Spectrum Measurement in iwl3945 drivers"
 	depends on IWL3945
diff --git a/drivers/net/wireless/iwlwifi/iwl-3945.h
b/drivers/net/wireless/iwlwifi/iwl-3945.h
index a774978..4df42ad 100644
--- a/drivers/net/wireless/iwlwifi/iwl-3945.h
+++ b/drivers/net/wireless/iwlwifi/iwl-3945.h
@@ -690,7 +690,7 @@ enum {
 
 #endif
 
-#ifdef CONFIG_IWLWIFI_RFKILL
+#ifdef CONFIG_IWL3945_RFKILL
 struct iwl3945_priv;
 
 struct iwl3945_rfkill_mngr {
@@ -800,7 +800,7 @@ struct iwl3945_priv {
 	struct iwl3945_init_alive_resp card_alive_init;
 	struct iwl3945_alive_resp card_alive;
 
-#ifdef CONFIG_IWLWIFI_RFKILL
+#ifdef CONFIG_IWL3945_RFKILL
 	struct iwl3945_rfkill_mngr rfkill_mngr;
 #endif
 
diff --git a/drivers/net/wireless/iwlwifi/iwl-rfkill.c
b/drivers/net/wireless/iwlwifi/iwl-rfkill.c
index 5f09874..feb3477 100644
--- a/drivers/net/wireless/iwlwifi/iwl-rfkill.c
+++ b/drivers/net/wireless/iwlwifi/iwl-rfkill.c
@@ -95,11 +95,18 @@ int iwl_rfkill_init(struct iwl_priv *priv)
 	priv->rfkill_mngr.rfkill->dev.class->suspend = NULL;
 	priv->rfkill_mngr.rfkill->dev.class->resume = NULL;
 
+	ret = rfkill_register(priv->rfkill_mngr.rfkill);
+	if (ret) {
+		IWL_ERROR("Unable to register rfkill: %d\n", ret);
+		goto freed_rfkill;
+	}
+
+#if defined(CONFIG_INPUT) || defined(CONFIG_INPUT_MODULE)
 	priv->rfkill_mngr.input_dev = input_allocate_device();
 	if (!priv->rfkill_mngr.input_dev) {
 		IWL_ERROR("Unable to allocate rfkill input device.\n");
 		ret = -ENOMEM;
-		goto freed_rfkill;
+		goto unregister_rfkill;
 	}
 
 	priv->rfkill_mngr.input_dev->name = priv->cfg->name;
@@ -110,29 +117,26 @@ int iwl_rfkill_init(struct iwl_priv *priv)
 	priv->rfkill_mngr.input_dev->evbit[0] = BIT(EV_KEY);
 	set_bit(KEY_WLAN, priv->rfkill_mngr.input_dev->keybit);
 
-	ret = rfkill_register(priv->rfkill_mngr.rfkill);
-	if (ret) {
-		IWL_ERROR("Unable to register rfkill: %d\n", ret);
-		goto free_input_dev;
-	}
-
 	ret = input_register_device(priv->rfkill_mngr.input_dev);
 	if (ret) {
 		IWL_ERROR("Unable to register rfkill input device: %d\n", ret);
-		goto unregister_rfkill;
+		goto free_input_dev;
 	}
+#endif
 
 	IWL_DEBUG_RF_KILL("RFKILL initialization complete.\n");
 	return ret;
 
-unregister_rfkill:
-	rfkill_unregister(priv->rfkill_mngr.rfkill);
-	priv->rfkill_mngr.rfkill = NULL;
-
+#if defined(CONFIG_INPUT) || defined(CONFIG_INPUT_MODULE)
 free_input_dev:
 	input_free_device(priv->rfkill_mngr.input_dev);
 	priv->rfkill_mngr.input_dev = NULL;
 
+unregister_rfkill:
+	rfkill_unregister(priv->rfkill_mngr.rfkill);
+	priv->rfkill_mngr.rfkill = NULL;
+#endif
+
 freed_rfkill:
 	if (priv->rfkill_mngr.rfkill != NULL)
 		rfkill_free(priv->rfkill_mngr.rfkill);
@@ -146,14 +150,16 @@ EXPORT_SYMBOL(iwl_rfkill_init);
 
 void iwl_rfkill_unregister(struct iwl_priv *priv)
 {
-
+#if defined(CONFIG_INPUT) || defined(CONFIG_INPUT_MODULE)
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
diff --git a/drivers/net/wireless/iwlwifi/iwl3945-base.c
b/drivers/net/wireless/iwlwifi/iwl3945-base.c
index 73942a4..df74ca5 100644
--- a/drivers/net/wireless/iwlwifi/iwl3945-base.c
+++ b/drivers/net/wireless/iwlwifi/iwl3945-base.c
@@ -8270,7 +8270,7 @@ static int iwl3945_pci_resume(struct pci_dev
*pdev)
 #endif /* CONFIG_PM */
 
 /*************** RFKILL FUNCTIONS **********/
-#ifdef CONFIG_IWLWIFI_RFKILL
+#ifdef CONFIG_IWL3945_RFKILL
 /* software rf-kill from user */
 static int iwl3945_rfkill_soft_rf_kill(void *data, enum rfkill_state
state)
 {
@@ -8328,11 +8328,18 @@ int iwl3945_rfkill_init(struct iwl3945_priv
*priv)
 	priv->rfkill_mngr.rfkill->dev.class->suspend = NULL;
 	priv->rfkill_mngr.rfkill->dev.class->resume = NULL;
 
+	ret = rfkill_register(priv->rfkill_mngr.rfkill);
+	if (ret) {
+		IWL_ERROR("Unable to register rfkill: %d\n", ret);
+		goto freed_rfkill;
+	}
+
+#if defined(CONFIG_INPUT) || defined(CONFIG_INPUT_MODULE)
 	priv->rfkill_mngr.input_dev = input_allocate_device();
 	if (!priv->rfkill_mngr.input_dev) {
 		IWL_ERROR("Unable to allocate rfkill input device.\n");
 		ret = -ENOMEM;
-		goto freed_rfkill;
+		goto unregister_rfkill;
 	}
 
 	priv->rfkill_mngr.input_dev->name = priv->cfg->name;
@@ -8343,29 +8350,26 @@ int iwl3945_rfkill_init(struct iwl3945_priv
*priv)
 	priv->rfkill_mngr.input_dev->evbit[0] = BIT(EV_KEY);
 	set_bit(KEY_WLAN, priv->rfkill_mngr.input_dev->keybit);
 
-	ret = rfkill_register(priv->rfkill_mngr.rfkill);
-	if (ret) {
-		IWL_ERROR("Unable to register rfkill: %d\n", ret);
-		goto free_input_dev;
-	}
-
 	ret = input_register_device(priv->rfkill_mngr.input_dev);
 	if (ret) {
 		IWL_ERROR("Unable to register rfkill input device: %d\n", ret);
-		goto unregister_rfkill;
+		goto free_input_dev;
 	}
+#endif
 
 	IWL_DEBUG_RF_KILL("RFKILL initialization complete.\n");
 	return ret;
 
-unregister_rfkill:
-	rfkill_unregister(priv->rfkill_mngr.rfkill);
-	priv->rfkill_mngr.rfkill = NULL;
-
+#if defined(CONFIG_INPUT) || defined(CONFIG_INPUT_MODULE)
 free_input_dev:
 	input_free_device(priv->rfkill_mngr.input_dev);
 	priv->rfkill_mngr.input_dev = NULL;
 
+unregister_rfkill:
+	rfkill_unregister(priv->rfkill_mngr.rfkill);
+	priv->rfkill_mngr.rfkill = NULL;
+#endif
+
 freed_rfkill:
 	if (priv->rfkill_mngr.rfkill != NULL)
 		rfkill_free(priv->rfkill_mngr.rfkill);
@@ -8378,14 +8382,16 @@ error:
 
 void iwl3945_rfkill_unregister(struct iwl3945_priv *priv)
 {
-
+#if defined(CONFIG_INPUT) || defined(CONFIG_INPUT_MODULE)
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
 
-- 
1.5.3.6



--=-3++uBbqEkqjHiYzelh38
Content-Disposition: attachment; filename=0001-iwlwifi-fix-build-for-CONFIG_INPUT-n.patch
Content-Type: application/mbox; name=0001-iwlwifi-fix-build-for-CONFIG_INPUT-n.patch
Content-Transfer-Encoding: 7bit

>From 58c5dc44f8f615113d21b3545df2e193bf22cf75 Mon Sep 17 00:00:00 2001
From: Randy Dunlap <randy.dunlap@oracle.com>
Date: Fri, 27 Jun 2008 16:21:19 +0800
Subject: [PATCH] iwlwifi: fix build for CONFIG_INPUT=n

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

The iwl3945 portion is done by Adel Gadllah <adel.gadllah@gmail.com>.
The patch fixes the RFKILL_INPUT dependency bug pointed by
Ivo van Doorn <ivdoorn@gmail.com>.

Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
Signed-off-by: Adel Gadllah <adel.gadllah@gmail.com>
Signed-off-by: Zhu Yi <yi.zhu@intel.com>
---
 drivers/net/wireless/iwlwifi/Kconfig        |    6 +++-
 drivers/net/wireless/iwlwifi/iwl-3945.h     |    4 +-
 drivers/net/wireless/iwlwifi/iwl-rfkill.c   |   34 +++++++++++++++----------
 drivers/net/wireless/iwlwifi/iwl3945-base.c |   36 +++++++++++++++-----------
 4 files changed, 48 insertions(+), 32 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/Kconfig b/drivers/net/wireless/iwlwifi/Kconfig
index a382c00..82b66a3 100644
--- a/drivers/net/wireless/iwlwifi/Kconfig
+++ b/drivers/net/wireless/iwlwifi/Kconfig
@@ -8,7 +8,6 @@ config IWLCORE
 	select MAC80211_LEDS if IWLWIFI_LEDS
 	select LEDS_CLASS if IWLWIFI_LEDS
 	select RFKILL if IWLWIFI_RFKILL
-	select RFKILL_INPUT if IWLWIFI_RFKILL
 
 config IWLWIFI_LEDS
 	bool
@@ -105,6 +104,7 @@ config IWL3945
 	select IWLWIFI
 	select MAC80211_LEDS if IWL3945_LEDS
 	select LEDS_CLASS if IWL3945_LEDS
+	select RFKILL if IWL3945_RFKILL
 	---help---
 	  Select to build the driver supporting the:
 
@@ -127,6 +127,10 @@ config IWL3945
 	  say M here and read <file:Documentation/kbuild/modules.txt>.  The
 	  module will be called iwl3945.ko.
 
+config IWL3945_RFKILL
+	bool "Enable RF kill support in iwl3945 drivers"
+	depends on IWL3945
+
 config IWL3945_SPECTRUM_MEASUREMENT
 	bool "Enable Spectrum Measurement in iwl3945 drivers"
 	depends on IWL3945
diff --git a/drivers/net/wireless/iwlwifi/iwl-3945.h b/drivers/net/wireless/iwlwifi/iwl-3945.h
index a774978..4df42ad 100644
--- a/drivers/net/wireless/iwlwifi/iwl-3945.h
+++ b/drivers/net/wireless/iwlwifi/iwl-3945.h
@@ -690,7 +690,7 @@ enum {
 
 #endif
 
-#ifdef CONFIG_IWLWIFI_RFKILL
+#ifdef CONFIG_IWL3945_RFKILL
 struct iwl3945_priv;
 
 struct iwl3945_rfkill_mngr {
@@ -800,7 +800,7 @@ struct iwl3945_priv {
 	struct iwl3945_init_alive_resp card_alive_init;
 	struct iwl3945_alive_resp card_alive;
 
-#ifdef CONFIG_IWLWIFI_RFKILL
+#ifdef CONFIG_IWL3945_RFKILL
 	struct iwl3945_rfkill_mngr rfkill_mngr;
 #endif
 
diff --git a/drivers/net/wireless/iwlwifi/iwl-rfkill.c b/drivers/net/wireless/iwlwifi/iwl-rfkill.c
index 5f09874..feb3477 100644
--- a/drivers/net/wireless/iwlwifi/iwl-rfkill.c
+++ b/drivers/net/wireless/iwlwifi/iwl-rfkill.c
@@ -95,11 +95,18 @@ int iwl_rfkill_init(struct iwl_priv *priv)
 	priv->rfkill_mngr.rfkill->dev.class->suspend = NULL;
 	priv->rfkill_mngr.rfkill->dev.class->resume = NULL;
 
+	ret = rfkill_register(priv->rfkill_mngr.rfkill);
+	if (ret) {
+		IWL_ERROR("Unable to register rfkill: %d\n", ret);
+		goto freed_rfkill;
+	}
+
+#if defined(CONFIG_INPUT) || defined(CONFIG_INPUT_MODULE)
 	priv->rfkill_mngr.input_dev = input_allocate_device();
 	if (!priv->rfkill_mngr.input_dev) {
 		IWL_ERROR("Unable to allocate rfkill input device.\n");
 		ret = -ENOMEM;
-		goto freed_rfkill;
+		goto unregister_rfkill;
 	}
 
 	priv->rfkill_mngr.input_dev->name = priv->cfg->name;
@@ -110,29 +117,26 @@ int iwl_rfkill_init(struct iwl_priv *priv)
 	priv->rfkill_mngr.input_dev->evbit[0] = BIT(EV_KEY);
 	set_bit(KEY_WLAN, priv->rfkill_mngr.input_dev->keybit);
 
-	ret = rfkill_register(priv->rfkill_mngr.rfkill);
-	if (ret) {
-		IWL_ERROR("Unable to register rfkill: %d\n", ret);
-		goto free_input_dev;
-	}
-
 	ret = input_register_device(priv->rfkill_mngr.input_dev);
 	if (ret) {
 		IWL_ERROR("Unable to register rfkill input device: %d\n", ret);
-		goto unregister_rfkill;
+		goto free_input_dev;
 	}
+#endif
 
 	IWL_DEBUG_RF_KILL("RFKILL initialization complete.\n");
 	return ret;
 
-unregister_rfkill:
-	rfkill_unregister(priv->rfkill_mngr.rfkill);
-	priv->rfkill_mngr.rfkill = NULL;
-
+#if defined(CONFIG_INPUT) || defined(CONFIG_INPUT_MODULE)
 free_input_dev:
 	input_free_device(priv->rfkill_mngr.input_dev);
 	priv->rfkill_mngr.input_dev = NULL;
 
+unregister_rfkill:
+	rfkill_unregister(priv->rfkill_mngr.rfkill);
+	priv->rfkill_mngr.rfkill = NULL;
+#endif
+
 freed_rfkill:
 	if (priv->rfkill_mngr.rfkill != NULL)
 		rfkill_free(priv->rfkill_mngr.rfkill);
@@ -146,14 +150,16 @@ EXPORT_SYMBOL(iwl_rfkill_init);
 
 void iwl_rfkill_unregister(struct iwl_priv *priv)
 {
-
+#if defined(CONFIG_INPUT) || defined(CONFIG_INPUT_MODULE)
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
diff --git a/drivers/net/wireless/iwlwifi/iwl3945-base.c b/drivers/net/wireless/iwlwifi/iwl3945-base.c
index 73942a4..df74ca5 100644
--- a/drivers/net/wireless/iwlwifi/iwl3945-base.c
+++ b/drivers/net/wireless/iwlwifi/iwl3945-base.c
@@ -8270,7 +8270,7 @@ static int iwl3945_pci_resume(struct pci_dev *pdev)
 #endif /* CONFIG_PM */
 
 /*************** RFKILL FUNCTIONS **********/
-#ifdef CONFIG_IWLWIFI_RFKILL
+#ifdef CONFIG_IWL3945_RFKILL
 /* software rf-kill from user */
 static int iwl3945_rfkill_soft_rf_kill(void *data, enum rfkill_state state)
 {
@@ -8328,11 +8328,18 @@ int iwl3945_rfkill_init(struct iwl3945_priv *priv)
 	priv->rfkill_mngr.rfkill->dev.class->suspend = NULL;
 	priv->rfkill_mngr.rfkill->dev.class->resume = NULL;
 
+	ret = rfkill_register(priv->rfkill_mngr.rfkill);
+	if (ret) {
+		IWL_ERROR("Unable to register rfkill: %d\n", ret);
+		goto freed_rfkill;
+	}
+
+#if defined(CONFIG_INPUT) || defined(CONFIG_INPUT_MODULE)
 	priv->rfkill_mngr.input_dev = input_allocate_device();
 	if (!priv->rfkill_mngr.input_dev) {
 		IWL_ERROR("Unable to allocate rfkill input device.\n");
 		ret = -ENOMEM;
-		goto freed_rfkill;
+		goto unregister_rfkill;
 	}
 
 	priv->rfkill_mngr.input_dev->name = priv->cfg->name;
@@ -8343,29 +8350,26 @@ int iwl3945_rfkill_init(struct iwl3945_priv *priv)
 	priv->rfkill_mngr.input_dev->evbit[0] = BIT(EV_KEY);
 	set_bit(KEY_WLAN, priv->rfkill_mngr.input_dev->keybit);
 
-	ret = rfkill_register(priv->rfkill_mngr.rfkill);
-	if (ret) {
-		IWL_ERROR("Unable to register rfkill: %d\n", ret);
-		goto free_input_dev;
-	}
-
 	ret = input_register_device(priv->rfkill_mngr.input_dev);
 	if (ret) {
 		IWL_ERROR("Unable to register rfkill input device: %d\n", ret);
-		goto unregister_rfkill;
+		goto free_input_dev;
 	}
+#endif
 
 	IWL_DEBUG_RF_KILL("RFKILL initialization complete.\n");
 	return ret;
 
-unregister_rfkill:
-	rfkill_unregister(priv->rfkill_mngr.rfkill);
-	priv->rfkill_mngr.rfkill = NULL;
-
+#if defined(CONFIG_INPUT) || defined(CONFIG_INPUT_MODULE)
 free_input_dev:
 	input_free_device(priv->rfkill_mngr.input_dev);
 	priv->rfkill_mngr.input_dev = NULL;
 
+unregister_rfkill:
+	rfkill_unregister(priv->rfkill_mngr.rfkill);
+	priv->rfkill_mngr.rfkill = NULL;
+#endif
+
 freed_rfkill:
 	if (priv->rfkill_mngr.rfkill != NULL)
 		rfkill_free(priv->rfkill_mngr.rfkill);
@@ -8378,14 +8382,16 @@ error:
 
 void iwl3945_rfkill_unregister(struct iwl3945_priv *priv)
 {
-
+#if defined(CONFIG_INPUT) || defined(CONFIG_INPUT_MODULE)
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
 
-- 
1.5.3.6


--=-3++uBbqEkqjHiYzelh38--

