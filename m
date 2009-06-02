Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from host2.marvell.com ([65.219.4.2]:10089 "EHLO maili.marvell.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751211AbZFBAmV (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 1 Jun 2009 20:42:21 -0400
From: Bing Zhao <bzhao@marvell.com>
To: libertas-dev@lists.infradead.org
Cc: linux-wireless@vger.kernel.org, Bing Zhao <bzhao@marvell.com>
Subject: [PATCH] libertas: improve function init/shutdown handling for SD8688
Date: Mon,  1 Jun 2009 18:04:36 -0700
Message-Id: <1243904676-1881-1-git-send-email-bzhao@marvell.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This patch is to incorporate Dan Williams' comments for commit:
"libertas: implement function init/shutdown commands for SD8688"

1. remove fn_init_required and fn_shutdown_required variables from
lbs_private structure. If required, __lbs_cmd() will be called
directly to send function init/shutdown command for SD8688 in
if_sdio_probe() or if_sdio_remove() callback.

2. add global variable "user_rmmod" to distinguish between the module
removal case and the card removal case. This flag will be checked in
if_sdio_remove() against SD8688 card to determine whether or not the
function shutdown command needs to be sent.

3. remove "card" from if_sdio_model structure as it cannot store
card pointers for multiple cards. Besides, it's no longer needed
to store the "card" pointer with changes #1 & #2 above.

Signed-off-by: Bing Zhao <bzhao@marvell.com>
---
 drivers/net/wireless/libertas/dev.h     |    2 -
 drivers/net/wireless/libertas/if_sdio.c |   76 +++++++++++++++++++------------
 drivers/net/wireless/libertas/main.c    |   20 --------
 3 files changed, 47 insertions(+), 51 deletions(-)

diff --git a/drivers/net/wireless/libertas/dev.h b/drivers/net/wireless/libertas/dev.h
index 9e11f90..f9ec69e 100644
--- a/drivers/net/wireless/libertas/dev.h
+++ b/drivers/net/wireless/libertas/dev.h
@@ -321,8 +321,6 @@ struct lbs_private {
 
 	u32 monitormode;
 	u8 fw_ready;
-	u8 fn_init_required;
-	u8 fn_shutdown_required;
 };
 
 extern struct cmd_confirm_sleep confirm_sleep;
diff --git a/drivers/net/wireless/libertas/if_sdio.c b/drivers/net/wireless/libertas/if_sdio.c
index a7e3fc1..8cdb88c 100644
--- a/drivers/net/wireless/libertas/if_sdio.c
+++ b/drivers/net/wireless/libertas/if_sdio.c
@@ -39,8 +39,24 @@
 #include "decl.h"
 #include "defs.h"
 #include "dev.h"
+#include "cmd.h"
 #include "if_sdio.h"
 
+/* The if_sdio_remove() callback function is called when
+ * user removes this module from kernel space or ejects
+ * the card from the slot. The driver handles these 2 cases
+ * differently for SD8688 combo chip.
+ * If the user is removing the module, the FUNC_SHUTDOWN
+ * command for SD8688 is sent to the firmware.
+ * If the card is removed, there is no need to send this command.
+ *
+ * The variable 'user_rmmod' is used to distinguish these two
+ * scenarios. This flag is initialized as FALSE in case the card
+ * is removed, and will be set to TRUE for module removal when
+ * module_exit function is called.
+ */
+static u8 user_rmmod;
+
 static char *lbs_helper_name = NULL;
 module_param_named(helper_name, lbs_helper_name, charp, 0644);
 
@@ -61,7 +77,6 @@ struct if_sdio_model {
 	int model;
 	const char *helper;
 	const char *firmware;
-	struct if_sdio_card *card;
 };
 
 static struct if_sdio_model if_sdio_models[] = {
@@ -70,21 +85,18 @@ static struct if_sdio_model if_sdio_models[] = {
 		.model = IF_SDIO_MODEL_8385,
 		.helper = "sd8385_helper.bin",
 		.firmware = "sd8385.bin",
-		.card = NULL,
 	},
 	{
 		/* 8686 */
 		.model = IF_SDIO_MODEL_8686,
 		.helper = "sd8686_helper.bin",
 		.firmware = "sd8686.bin",
-		.card = NULL,
 	},
 	{
 		/* 8688 */
 		.model = IF_SDIO_MODEL_8688,
 		.helper = "sd8688_helper.bin",
 		.firmware = "sd8688.bin",
-		.card = NULL,
 	},
 };
 
@@ -927,8 +939,6 @@ static int if_sdio_probe(struct sdio_func *func,
 		goto free;
 	}
 
-	if_sdio_models[i].card = card;
-
 	card->helper = if_sdio_models[i].helper;
 	card->firmware = if_sdio_models[i].firmware;
 
@@ -1014,8 +1024,16 @@ static int if_sdio_probe(struct sdio_func *func,
 	/*
 	 * FUNC_INIT is required for SD8688 WLAN/BT multiple functions
 	 */
-	priv->fn_init_required =
-		(card->model == IF_SDIO_MODEL_8688) ? 1 : 0;
+	if (card->model == IF_SDIO_MODEL_8688) {
+		struct cmd_header cmd;
+
+		memset(&cmd, 0, sizeof(cmd));
+
+		lbs_deb_sdio("send function INIT command\n");
+		if (__lbs_cmd(priv, CMD_FUNC_INIT, &cmd, sizeof(cmd),
+				lbs_cmd_copyback, (unsigned long) &cmd))
+			lbs_pr_alert("CMD_FUNC_INIT cmd failed\n");
+	}
 
 	ret = lbs_start_card(priv);
 	if (ret)
@@ -1057,30 +1075,39 @@ static void if_sdio_remove(struct sdio_func *func)
 {
 	struct if_sdio_card *card;
 	struct if_sdio_packet *packet;
-	int ret;
 
 	lbs_deb_enter(LBS_DEB_SDIO);
 
 	card = sdio_get_drvdata(func);
 
-	lbs_stop_card(card->priv);
+	if (user_rmmod && (card->model == IF_SDIO_MODEL_8688)) {
+		/*
+		 * FUNC_SHUTDOWN is required for SD8688 WLAN/BT
+		 * multiple functions
+		 */
+		struct cmd_header cmd;
+
+		memset(&cmd, 0, sizeof(cmd));
+
+		lbs_deb_sdio("send function SHUTDOWN command\n");
+		if (__lbs_cmd(card->priv, CMD_FUNC_SHUTDOWN,
+				&cmd, sizeof(cmd), lbs_cmd_copyback,
+				(unsigned long) &cmd))
+			lbs_pr_alert("CMD_FUNC_SHUTDOWN cmd failed\n");
+	}
 
 	card->priv->surpriseremoved = 1;
 
 	lbs_deb_sdio("call remove card\n");
+	lbs_stop_card(card->priv);
 	lbs_remove_card(card->priv);
 
 	flush_workqueue(card->workqueue);
 	destroy_workqueue(card->workqueue);
 
 	sdio_claim_host(func);
-
-	/* Disable interrupts */
-	sdio_writeb(func, 0x00, IF_SDIO_H_INT_MASK, &ret);
-
 	sdio_release_irq(func);
 	sdio_disable_func(func);
-
 	sdio_release_host(func);
 
 	while (card->packets) {
@@ -1116,6 +1143,9 @@ static int __init if_sdio_init_module(void)
 
 	ret = sdio_register_driver(&if_sdio_driver);
 
+	/* Clear the flag in case user removes the card. */
+	user_rmmod = 0;
+
 	lbs_deb_leave_args(LBS_DEB_SDIO, "ret %d", ret);
 
 	return ret;
@@ -1123,22 +1153,10 @@ static int __init if_sdio_init_module(void)
 
 static void __exit if_sdio_exit_module(void)
 {
-	int i;
-	struct if_sdio_card *card;
-
 	lbs_deb_enter(LBS_DEB_SDIO);
 
-	for (i = 0; i < ARRAY_SIZE(if_sdio_models); i++) {
-		card = if_sdio_models[i].card;
-
-		/*
-		 * FUNC_SHUTDOWN is required for SD8688 WLAN/BT
-		 * multiple functions
-		 */
-		if (card && card->priv)
-			card->priv->fn_shutdown_required =
-				(card->model == IF_SDIO_MODEL_8688) ? 1 : 0;
-	}
+	/* Set the flag as user is removing this module. */
+	user_rmmod = 1;
 
 	sdio_unregister_driver(&if_sdio_driver);
 
diff --git a/drivers/net/wireless/libertas/main.c b/drivers/net/wireless/libertas/main.c
index a58a123..89575e4 100644
--- a/drivers/net/wireless/libertas/main.c
+++ b/drivers/net/wireless/libertas/main.c
@@ -1002,17 +1002,9 @@ static int lbs_setup_firmware(struct lbs_private *priv)
 {
 	int ret = -1;
 	s16 curlevel = 0, minlevel = 0, maxlevel = 0;
-	struct cmd_header cmd;
 
 	lbs_deb_enter(LBS_DEB_FW);
 
-	if (priv->fn_init_required) {
-		memset(&cmd, 0, sizeof(cmd));
-		if (__lbs_cmd(priv, CMD_FUNC_INIT, &cmd, sizeof(cmd),
-				lbs_cmd_copyback, (unsigned long) &cmd))
-			lbs_pr_alert("CMD_FUNC_INIT command failed\n");
-	}
-
 	/* Read MAC address from firmware */
 	memset(priv->current_addr, 0xff, ETH_ALEN);
 	ret = lbs_update_hw_spec(priv);
@@ -1200,9 +1192,6 @@ struct lbs_private *lbs_add_card(void *card, struct device *dmdev)
 	priv->mesh_open = 0;
 	priv->infra_open = 0;
 
-	priv->fn_init_required = 0;
-	priv->fn_shutdown_required = 0;
-
 	/* Setup the OS Interface to our functions */
  	dev->netdev_ops = &lbs_netdev_ops;
 	dev->watchdog_timeo = 5 * HZ;
@@ -1384,20 +1373,11 @@ void lbs_stop_card(struct lbs_private *priv)
 	struct net_device *dev;
 	struct cmd_ctrl_node *cmdnode;
 	unsigned long flags;
-	struct cmd_header cmd;
 
 	lbs_deb_enter(LBS_DEB_MAIN);
 
 	if (!priv)
 		goto out;
-
-	if (priv->fn_shutdown_required) {
-		memset(&cmd, 0, sizeof(cmd));
-		if (__lbs_cmd(priv, CMD_FUNC_SHUTDOWN, &cmd, sizeof(cmd),
-				lbs_cmd_copyback, (unsigned long) &cmd))
-			lbs_pr_alert("CMD_FUNC_SHUTDOWN command failed\n");
-	}
-
 	dev = priv->dev;
 
 	netif_stop_queue(dev);
-- 
1.5.3.6

