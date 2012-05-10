Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wi0-f172.google.com ([209.85.212.172]:51169 "EHLO
	mail-wi0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758173Ab2EJJPj (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 10 May 2012 05:15:39 -0400
Received: by mail-wi0-f172.google.com with SMTP id hr2so244170wib.1
        for <linux-wireless@vger.kernel.org>; Thu, 10 May 2012 02:15:39 -0700 (PDT)
From: Arik Nemtsov <arik@wizery.com>
To: <linux-wireless@vger.kernel.org>
Cc: Luciano Coelho <coelho@ti.com>, Arik Nemtsov <arik@wizery.com>
Subject: [PATCH 32/78] wl18xx: add board type module argument
Date: Thu, 10 May 2012 12:13:37 +0300
Message-Id: <1336641263-5761-33-git-send-email-arik@wizery.com> (sfid-20120510_111554_883937_DADC1E1F)
In-Reply-To: <1336641263-5761-1-git-send-email-arik@wizery.com>
References: <1336641263-5761-1-git-send-email-arik@wizery.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Luciano Coelho <coelho@ti.com>

Different board types (ie. FPGA, HDK and DVP/EVB) require slightly
different init configuration options.  Since we cannot probe the type
of board from the actual hardware, we need to pass it as an option
during module load.

This patch adds a module parameters that accepts the 3 different board
types, with DVP/EVB as the default, and uses this value where needed.

Signed-off-by: Luciano Coelho <coelho@ti.com>
Signed-off-by: Arik Nemtsov <arik@wizery.com>
---
 drivers/net/wireless/ti/wl18xx/main.c   |   26 ++++++++++++++++++++++++--
 drivers/net/wireless/ti/wl18xx/wl18xx.h |    2 ++
 2 files changed, 26 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/ti/wl18xx/main.c b/drivers/net/wireless/ti/wl18xx/main.c
index 17792e2..e5ebf4a 100644
--- a/drivers/net/wireless/ti/wl18xx/main.c
+++ b/drivers/net/wireless/ti/wl18xx/main.c
@@ -42,6 +42,7 @@
 #define WL18XX_RX_CHECKSUM_MASK      0x40
 
 static char *ht_mode_param;
+static char *board_type_param;
 
 static const u8 wl18xx_rate_to_idx_2ghz[] = {
 	/* MCS rates are used only with 11n */
@@ -680,8 +681,7 @@ static void wl18xx_set_mac_and_phy(struct wl1271 *wl)
 	params.secondary_clock_setting_time =
 		phy->secondary_clock_setting_time;
 
-	/* TODO: hardcoded for now */
-	params.board_type = BOARD_TYPE_DVP_EVB_18XX;
+	params.board_type = priv->board_type;
 
 	wlcore_set_partition(wl, &wl->ptable[PART_PHY_INIT]);
 	wl1271_write(wl, WL18XX_PHY_INIT_MEM_ADDR, (u8 *)&params,
@@ -964,6 +964,7 @@ int __devinit wl18xx_probe(struct platform_device *pdev)
 	}
 
 	wl = hw->priv;
+	priv = wl->priv;
 	wl->ops = &wl18xx_ops;
 	wl->ptable = wl18xx_ptable;
 	wl->rtable = wl18xx_rtable;
@@ -979,6 +980,24 @@ int __devinit wl18xx_probe(struct platform_device *pdev)
 		memcpy(&wl->ht_cap, &wl18xx_mimo_ht_cap,
 		       sizeof(wl18xx_mimo_ht_cap));
 
+	if (!board_type_param) {
+		board_type_param = kstrdup("dvp_evb", GFP_KERNEL);
+		priv->board_type = BOARD_TYPE_DVP_EVB_18XX;
+	} else {
+		if (!strcmp(board_type_param, "fpga"))
+			priv->board_type = BOARD_TYPE_FPGA_18XX;
+		else if (!strcmp(board_type_param, "hdk"))
+			priv->board_type = BOARD_TYPE_HDK_18XX;
+		else if (!strcmp(board_type_param, "dvp_evb"))
+			priv->board_type = BOARD_TYPE_DVP_EVB_18XX;
+		else {
+			wl1271_error("invalid board type '%s'",
+				     board_type_param);
+			wlcore_free_hw(wl);
+			return -EINVAL;
+		}
+	}
+
 	wl18xx_conf_init(wl);
 
 	return wlcore_probe(wl, pdev);
@@ -1015,6 +1034,9 @@ module_exit(wl18xx_exit);
 module_param_named(ht_mode, ht_mode_param, charp, S_IRUSR);
 MODULE_PARM_DESC(ht_mode, "Force HT mode: wide or mimo");
 
+module_param_named(board_type, board_type_param, charp, S_IRUSR);
+MODULE_PARM_DESC(board_type, "Board type: fpga, hdk or dvp_evb (default)");
+
 MODULE_LICENSE("GPL v2");
 MODULE_AUTHOR("Luciano Coelho <coelho@ti.com>");
 MODULE_FIRMWARE(WL18XX_FW_NAME);
diff --git a/drivers/net/wireless/ti/wl18xx/wl18xx.h b/drivers/net/wireless/ti/wl18xx/wl18xx.h
index c9bf5c6..5bcc7f0 100644
--- a/drivers/net/wireless/ti/wl18xx/wl18xx.h
+++ b/drivers/net/wireless/ti/wl18xx/wl18xx.h
@@ -34,6 +34,8 @@ struct wl18xx_priv {
 
 	/* Index of last released Tx desc in FW */
 	u8 last_fw_rls_idx;
+
+	u8 board_type;
 };
 
 #define WL18XX_FW_MAX_TX_STATUS_DESC 33
-- 
1.7.9.5

