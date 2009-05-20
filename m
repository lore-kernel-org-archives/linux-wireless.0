Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from host2.marvell.com ([65.219.4.2]:25919 "EHLO maili.marvell.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1750879AbZETC0L (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 19 May 2009 22:26:11 -0400
From: Bing Zhao <bzhao@marvell.com>
To: libertas-dev@lists.infradead.org
Cc: linux-wireless@vger.kernel.org, Bing Zhao <bzhao@marvell.com>
Subject: [PATCH 3/4] libertas: implement function init/shutdown commands for SD8688
Date: Tue, 19 May 2009 19:48:20 -0700
Message-Id: <1242787701-10685-3-git-send-email-bzhao@marvell.com>
In-Reply-To: <1242787701-10685-1-git-send-email-bzhao@marvell.com>
References: <1242787701-10685-1-git-send-email-bzhao@marvell.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

SD8688 is a WLAN/Bluetooth combo chip and both functions are supported
in a single firmware image. FUNC_INIT and FUNC_SHUTDOWN commands are
implemented to utilize the multiple function feature.

When SD8688 card is inserted, the firmware image should be downloaded
only once through either WLAN function (Libertas driver) or Bluetooth
function (Bluetooth driver).

This patch adds function init/shutdown for SD8688 WLAN function only.

Signed-off-by: Bing Zhao <bzhao@marvell.com>
---
 drivers/net/wireless/libertas/dev.h     |    2 +
 drivers/net/wireless/libertas/host.h    |    2 +
 drivers/net/wireless/libertas/if_sdio.c |   41 ++++++++++++++++++++++++++++--
 drivers/net/wireless/libertas/main.c    |   20 +++++++++++++++
 4 files changed, 62 insertions(+), 3 deletions(-)

diff --git a/drivers/net/wireless/libertas/dev.h b/drivers/net/wireless/libertas/dev.h
index cbaafa6..a4455ec 100644
--- a/drivers/net/wireless/libertas/dev.h
+++ b/drivers/net/wireless/libertas/dev.h
@@ -321,6 +321,8 @@ struct lbs_private {
 
 	u32 monitormode;
 	u8 fw_ready;
+	u8 fn_init_required;
+	u8 fn_shutdown_required;
 };
 
 extern struct cmd_confirm_sleep confirm_sleep;
diff --git a/drivers/net/wireless/libertas/host.h b/drivers/net/wireless/libertas/host.h
index 8ff8ac9..fe8f0cb 100644
--- a/drivers/net/wireless/libertas/host.h
+++ b/drivers/net/wireless/libertas/host.h
@@ -86,6 +86,8 @@
 #define CMD_MESH_CONFIG_OLD			0x00a3
 #define CMD_MESH_CONFIG				0x00ac
 #define	CMD_SET_BOOT2_VER			0x00a5
+#define	CMD_FUNC_INIT				0x00a9
+#define	CMD_FUNC_SHUTDOWN			0x00aa
 #define CMD_802_11_BEACON_CTRL			0x00b0
 
 /* For the IEEE Power Save */
diff --git a/drivers/net/wireless/libertas/if_sdio.c b/drivers/net/wireless/libertas/if_sdio.c
index e998c12..478d766 100644
--- a/drivers/net/wireless/libertas/if_sdio.c
+++ b/drivers/net/wireless/libertas/if_sdio.c
@@ -61,6 +61,7 @@ struct if_sdio_model {
 	int model;
 	const char *helper;
 	const char *firmware;
+	struct if_sdio_card *card;
 };
 
 static struct if_sdio_model if_sdio_models[] = {
@@ -69,18 +70,21 @@ static struct if_sdio_model if_sdio_models[] = {
 		.model = IF_SDIO_MODEL_8385,
 		.helper = "sd8385_helper.bin",
 		.firmware = "sd8385.bin",
+		.card = NULL,
 	},
 	{
 		/* 8686 */
 		.model = IF_SDIO_MODEL_8686,
 		.helper = "sd8686_helper.bin",
 		.firmware = "sd8686.bin",
+		.card = NULL,
 	},
 	{
 		/* 8688 */
 		.model = IF_SDIO_MODEL_8688,
 		.helper = "sd8688_helper.bin",
 		.firmware = "sd8688.bin",
+		.card = NULL,
 	},
 };
 
@@ -539,7 +543,6 @@ static int if_sdio_prog_helper(struct if_sdio_card *card)
 	ret = 0;
 
 release:
-	sdio_set_block_size(card->func, IF_SDIO_BLOCK_SIZE);
 	sdio_release_host(card->func);
 	kfree(chunk_buffer);
 release_fw:
@@ -675,7 +678,6 @@ static int if_sdio_prog_real(struct if_sdio_card *card)
 	ret = 0;
 
 release:
-	sdio_set_block_size(card->func, IF_SDIO_BLOCK_SIZE);
 	sdio_release_host(card->func);
 	kfree(chunk_buffer);
 release_fw:
@@ -718,6 +720,9 @@ static int if_sdio_prog_firmware(struct if_sdio_card *card)
 		goto out;
 
 success:
+	sdio_claim_host(card->func);
+	sdio_set_block_size(card->func, IF_SDIO_BLOCK_SIZE);
+	sdio_release_host(card->func);
 	ret = 0;
 
 out:
@@ -903,6 +908,8 @@ static int if_sdio_probe(struct sdio_func *func,
 		goto free;
 	}
 
+	if_sdio_models[i].card = card;
+
 	card->helper = if_sdio_models[i].helper;
 	card->firmware = if_sdio_models[i].firmware;
 
@@ -985,6 +992,12 @@ static int if_sdio_probe(struct sdio_func *func,
 	if (ret)
 		goto reclaim;
 
+	/*
+	 * FUNC_INIT is required for SD8688 WLAN/BT multiple functions
+	 */
+	priv->fn_init_required =
+		(card->model == IF_SDIO_MODEL_8688) ? 1 : 0;
+
 	ret = lbs_start_card(priv);
 	if (ret)
 		goto err_activate_card;
@@ -1025,23 +1038,30 @@ static void if_sdio_remove(struct sdio_func *func)
 {
 	struct if_sdio_card *card;
 	struct if_sdio_packet *packet;
+	int ret;
 
 	lbs_deb_enter(LBS_DEB_SDIO);
 
 	card = sdio_get_drvdata(func);
 
+	lbs_stop_card(card->priv);
+
 	card->priv->surpriseremoved = 1;
 
 	lbs_deb_sdio("call remove card\n");
-	lbs_stop_card(card->priv);
 	lbs_remove_card(card->priv);
 
 	flush_workqueue(card->workqueue);
 	destroy_workqueue(card->workqueue);
 
 	sdio_claim_host(func);
+
+	/* Disable interrupts */
+	sdio_writeb(func, 0x00, IF_SDIO_H_INT_MASK, &ret);
+
 	sdio_release_irq(func);
 	sdio_disable_func(func);
+
 	sdio_release_host(func);
 
 	while (card->packets) {
@@ -1084,8 +1104,23 @@ static int __init if_sdio_init_module(void)
 
 static void __exit if_sdio_exit_module(void)
 {
+	int i;
+	struct if_sdio_card *card;
+
 	lbs_deb_enter(LBS_DEB_SDIO);
 
+	for (i = 0; i < ARRAY_SIZE(if_sdio_models); i++) {
+		card = if_sdio_models[i].card;
+
+		/*
+		 * FUNC_SHUTDOWN is required for SD8688 WLAN/BT
+		 * multiple functions
+		 */
+		if (card && card->priv)
+			card->priv->fn_shutdown_required =
+				(card->model == IF_SDIO_MODEL_8688) ? 1 : 0;
+	}
+
 	sdio_unregister_driver(&if_sdio_driver);
 
 	lbs_deb_leave(LBS_DEB_SDIO);
diff --git a/drivers/net/wireless/libertas/main.c b/drivers/net/wireless/libertas/main.c
index 89575e4..a58a123 100644
--- a/drivers/net/wireless/libertas/main.c
+++ b/drivers/net/wireless/libertas/main.c
@@ -1002,9 +1002,17 @@ static int lbs_setup_firmware(struct lbs_private *priv)
 {
 	int ret = -1;
 	s16 curlevel = 0, minlevel = 0, maxlevel = 0;
+	struct cmd_header cmd;
 
 	lbs_deb_enter(LBS_DEB_FW);
 
+	if (priv->fn_init_required) {
+		memset(&cmd, 0, sizeof(cmd));
+		if (__lbs_cmd(priv, CMD_FUNC_INIT, &cmd, sizeof(cmd),
+				lbs_cmd_copyback, (unsigned long) &cmd))
+			lbs_pr_alert("CMD_FUNC_INIT command failed\n");
+	}
+
 	/* Read MAC address from firmware */
 	memset(priv->current_addr, 0xff, ETH_ALEN);
 	ret = lbs_update_hw_spec(priv);
@@ -1192,6 +1200,9 @@ struct lbs_private *lbs_add_card(void *card, struct device *dmdev)
 	priv->mesh_open = 0;
 	priv->infra_open = 0;
 
+	priv->fn_init_required = 0;
+	priv->fn_shutdown_required = 0;
+
 	/* Setup the OS Interface to our functions */
  	dev->netdev_ops = &lbs_netdev_ops;
 	dev->watchdog_timeo = 5 * HZ;
@@ -1373,11 +1384,20 @@ void lbs_stop_card(struct lbs_private *priv)
 	struct net_device *dev;
 	struct cmd_ctrl_node *cmdnode;
 	unsigned long flags;
+	struct cmd_header cmd;
 
 	lbs_deb_enter(LBS_DEB_MAIN);
 
 	if (!priv)
 		goto out;
+
+	if (priv->fn_shutdown_required) {
+		memset(&cmd, 0, sizeof(cmd));
+		if (__lbs_cmd(priv, CMD_FUNC_SHUTDOWN, &cmd, sizeof(cmd),
+				lbs_cmd_copyback, (unsigned long) &cmd))
+			lbs_pr_alert("CMD_FUNC_SHUTDOWN command failed\n");
+	}
+
 	dev = priv->dev;
 
 	netif_stop_queue(dev);
-- 
1.5.3.6

