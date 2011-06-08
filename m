Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from dakia2.marvell.com ([65.219.4.35]:35515 "EHLO
	dakia2.marvell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756269Ab1FHPQL (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 8 Jun 2011 11:16:11 -0400
Date: Wed, 8 Jun 2011 20:39:20 +0530
From: Amitkumar Karwar <akarwar@marvell.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org, yogeshp@marvell.com,
	bzhao@marvell.com, dkiran@marvell.com
Subject: [PATCH] mwifiex: get rid of global adapter pointer
Message-ID: <20110608150910.GA28375@pe-lt343.marvell.com> (sfid-20110608_171616_178563_601122AA)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

1) Avoid global adapter pointer usage
   a) in sdio.c by moving some code from mwifiex_cleanup_module() to
      mwifiex_sdio_remove().
   b) in main.c by passing an extra parameter to few functions.
2) Add new variable "user_rmmod" to identify if mwifiex_sdio_remove()
   callback function is called in card removal or rmmod context. These
   code changes are adapted from Libertas driver.
3) Remove unnecessary NULL pointer check for "func" pointer in
   mwifiex_sdio_remove().

Signed-off-by: Amitkumar Karwar <akarwar@marvell.com>
Signed-off-by: Yogesh Ashok Powar <yogeshp@marvell.com>
Signed-off-by: Bing Zhao <bzhao@marvell.com>
---
 main.c |   16 ++++--------
 main.h |    1 -
 sdio.c |   81 +++++++++++++++++++++++++++++++++++++++------------------------
 3 files changed, 56 insertions(+), 42 deletions(-)

diff --git a/main.c b/main.c
index 4f43443..054a5c3 100644
--- a/main.c
+++ b/main.c
@@ -26,9 +26,6 @@
 
 const char driver_version[] = "mwifiex " VERSION " (%s) ";
 
-struct mwifiex_adapter *g_adapter;
-EXPORT_SYMBOL_GPL(g_adapter);
-
 static struct mwifiex_bss_attr mwifiex_bss_sta[] = {
 	{MWIFIEX_BSS_TYPE_STA, MWIFIEX_DATA_FRAME_TYPE_ETH_II, true, 0, 0},
 };
@@ -60,7 +57,8 @@ static struct mwifiex_drv_mode mwifiex_drv_mode_tbl[] = {
  * proper cleanup before exiting.
  */
 static int mwifiex_register(void *card, struct mwifiex_if_ops *if_ops,
-			    struct mwifiex_drv_mode *drv_mode_ptr)
+			    struct mwifiex_drv_mode *drv_mode_ptr,
+			    void **padapter)
 {
 	struct mwifiex_adapter *adapter;
 	int i;
@@ -69,7 +67,7 @@ static int mwifiex_register(void *card, struct mwifiex_if_ops *if_ops,
 	if (!adapter)
 		return -ENOMEM;
 
-	g_adapter = adapter;
+	*padapter = adapter;
 	adapter->card = card;
 
 	/* Save interface specific operations in adapter */
@@ -324,7 +322,7 @@ exit_main_proc:
  * and initializing the private structures.
  */
 static int
-mwifiex_init_sw(void *card, struct mwifiex_if_ops *if_ops)
+mwifiex_init_sw(void *card, struct mwifiex_if_ops *if_ops, void **padapter)
 {
 	int i;
 	struct mwifiex_drv_mode *drv_mode_ptr;
@@ -343,7 +341,7 @@ mwifiex_init_sw(void *card, struct mwifiex_if_ops *if_ops)
 		return -1;
 	}
 
-	if (mwifiex_register(card, if_ops, drv_mode_ptr))
+	if (mwifiex_register(card, if_ops, drv_mode_ptr, padapter))
 		return -1;
 
 	return 0;
@@ -855,13 +853,11 @@ mwifiex_add_card(void *card, struct semaphore *sem,
 	if (down_interruptible(sem))
 		goto exit_sem_err;
 
-	if (mwifiex_init_sw(card, if_ops)) {
+	if (mwifiex_init_sw(card, if_ops, (void **)&adapter)) {
 		pr_err("%s: software init failed\n", __func__);
 		goto err_init_sw;
 	}
 
-	adapter = g_adapter;
-
 	adapter->hw_status = MWIFIEX_HW_STATUS_INITIALIZING;
 	adapter->surprise_removed = false;
 	init_waitqueue_head(&adapter->init_wait_q);
diff --git a/main.h b/main.h
index 57b183a..db201cc 100644
--- a/main.h
+++ b/main.h
@@ -39,7 +39,6 @@
 #include "fw.h"
 
 extern const char driver_version[];
-extern struct mwifiex_adapter *g_adapter;
 
 enum {
 	MWIFIEX_ASYNC_CMD,
diff --git a/sdio.c b/sdio.c
index 4327b6d..711fa68 100644
--- a/sdio.c
+++ b/sdio.c
@@ -31,10 +31,27 @@
 
 #define SDIO_VERSION	"1.0"
 
+/* The mwifiex_sdio_remove() callback function is called when
+ * user removes this module from kernel space or ejects
+ * the card from the slot. The driver handles these 2 cases
+ * differently.
+ * If the user is removing the module, the few commands (FUNC_SHUTDOWN,
+ * HS_CANCEL etc.) are sent to the firmware.
+ * If the card is removed, there is no need to send these command.
+ *
+ * The variable 'user_rmmod' is used to distinguish these two
+ * scenarios. This flag is initialized as FALSE in case the card
+ * is removed, and will be set to TRUE for module removal when
+ * module_exit function is called.
+ */
+static u8 user_rmmod;
+
 static struct mwifiex_if_ops sdio_ops;
 
 static struct semaphore add_remove_card_sem;
 
+static int mwifiex_sdio_resume(struct device *dev);
+
 /*
  * SDIO probe.
  *
@@ -93,17 +110,36 @@ static void
 mwifiex_sdio_remove(struct sdio_func *func)
 {
 	struct sdio_mmc_card *card;
+	struct mwifiex_adapter *adapter;
+	int i;
 
 	pr_debug("info: SDIO func num=%d\n", func->num);
 
-	if (func) {
-		card = sdio_get_drvdata(func);
-		if (card) {
-			mwifiex_remove_card(card->adapter,
-					&add_remove_card_sem);
-			kfree(card);
-		}
+	card = sdio_get_drvdata(func);
+	if (!card)
+		return;
+
+	adapter = card->adapter;
+	if (!adapter || !adapter->priv_num)
+		return;
+
+	if (user_rmmod) {
+		if (adapter->is_suspended)
+			mwifiex_sdio_resume(adapter->dev);
+
+		for (i = 0; i < adapter->priv_num; i++)
+			if ((GET_BSS_ROLE(adapter->priv[i]) ==
+						MWIFIEX_BSS_ROLE_STA) &&
+					adapter->priv[i]->media_connected)
+				mwifiex_deauthenticate(adapter->priv[i], NULL);
+
+		mwifiex_init_shutdown_fw(mwifiex_get_priv(adapter,
+						MWIFIEX_BSS_ROLE_ANY),
+					 MWIFIEX_FUNC_SHUTDOWN);
 	}
+
+	mwifiex_remove_card(card->adapter, &add_remove_card_sem);
+	kfree(card);
 }
 
 /*
@@ -1696,6 +1732,9 @@ mwifiex_sdio_init_module(void)
 {
 	sema_init(&add_remove_card_sem, 1);
 
+	/* Clear the flag in case user removes the card. */
+	user_rmmod = 0;
+
 	return sdio_register_driver(&mwifiex_sdio);
 }
 
@@ -1711,32 +1750,12 @@ mwifiex_sdio_init_module(void)
 static void
 mwifiex_sdio_cleanup_module(void)
 {
-	struct mwifiex_adapter *adapter = g_adapter;
-	int i;
-
-	if (down_interruptible(&add_remove_card_sem))
-		goto exit_sem_err;
-
-	if (!adapter || !adapter->priv_num)
-		goto exit;
-
-	if (adapter->is_suspended)
-		mwifiex_sdio_resume(adapter->dev);
-
-	for (i = 0; i < adapter->priv_num; i++)
-		if ((GET_BSS_ROLE(adapter->priv[i]) == MWIFIEX_BSS_ROLE_STA) &&
-		    adapter->priv[i]->media_connected)
-			mwifiex_deauthenticate(adapter->priv[i], NULL);
-
-	if (!adapter->surprise_removed)
-		mwifiex_init_shutdown_fw(mwifiex_get_priv(adapter,
-							  MWIFIEX_BSS_ROLE_ANY),
-					 MWIFIEX_FUNC_SHUTDOWN);
+	if (!down_interruptible(&add_remove_card_sem))
+		up(&add_remove_card_sem);
 
-exit:
-	up(&add_remove_card_sem);
+	/* Set the flag as user is removing this module. */
+	user_rmmod = 1;
 
-exit_sem_err:
 	sdio_unregister_driver(&mwifiex_sdio);
 }
 
-- 
1.5.3.4

