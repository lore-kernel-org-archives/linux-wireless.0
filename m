Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from host2.marvell.com ([65.219.4.2]:23222 "EHLO maili.marvell.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1754285AbZE0WlT (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 27 May 2009 18:41:19 -0400
From: Bing Zhao <bzhao@marvell.com>
To: libertas-dev@lists.infradead.org
Cc: linux-wireless@vger.kernel.org, Bing Zhao <bzhao@marvell.com>
Subject: [PATCH 3/4 v2] libertas: implement function init/shutdown commands for SD8688
Date: Wed, 27 May 2009 16:03:33 -0700
Message-Id: <1243465413-4997-1-git-send-email-bzhao@marvell.com>
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
 drivers/net/wireless/libertas/host.h    |    2 +
 drivers/net/wireless/libertas/if_sdio.c |   43 +++++++++++++++++++++++++++++-
 2 files changed, 43 insertions(+), 2 deletions(-)

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
index e998c12..84fef6b 100644
--- a/drivers/net/wireless/libertas/if_sdio.c
+++ b/drivers/net/wireless/libertas/if_sdio.c
@@ -39,8 +39,12 @@
 #include "decl.h"
 #include "defs.h"
 #include "dev.h"
+#include "cmd.h"
 #include "if_sdio.h"
 
+/* set this flag in if_sdio_exit_module() if user removes this module */
+static u8 user_rmmod;
+
 static char *lbs_helper_name = NULL;
 module_param_named(helper_name, lbs_helper_name, charp, 0644);
 
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
@@ -985,6 +990,20 @@ static int if_sdio_probe(struct sdio_func *func,
 	if (ret)
 		goto reclaim;
 
+	/*
+	 * FUNC_INIT is required for SD8688 WLAN/BT multiple functions
+	 */
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
+
 	ret = lbs_start_card(priv);
 	if (ret)
 		goto err_activate_card;
@@ -1030,6 +1049,22 @@ static void if_sdio_remove(struct sdio_func *func)
 
 	card = sdio_get_drvdata(func);
 
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
+
 	card->priv->surpriseremoved = 1;
 
 	lbs_deb_sdio("call remove card\n");
@@ -1077,6 +1112,8 @@ static int __init if_sdio_init_module(void)
 
 	ret = sdio_register_driver(&if_sdio_driver);
 
+	user_rmmod = 0;
+
 	lbs_deb_leave_args(LBS_DEB_SDIO, "ret %d", ret);
 
 	return ret;
@@ -1086,6 +1123,8 @@ static void __exit if_sdio_exit_module(void)
 {
 	lbs_deb_enter(LBS_DEB_SDIO);
 
+	user_rmmod = 1;
+
 	sdio_unregister_driver(&if_sdio_driver);
 
 	lbs_deb_leave(LBS_DEB_SDIO);
-- 
1.5.3.6

