Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([18.85.46.34]:56705 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1762695AbXLMG7Y (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 13 Dec 2007 01:59:24 -0500
Subject: [PATCH 61/48] libertas: convert GET_HW_SPEC to a direct command
From: David Woodhouse <dwmw2@infradead.org>
In-Reply-To: <libertas-12345@shinybook.infradead.org>
To: John Linville <linville@tuxdriver.com>
Cc: Dan Williams <dcbw@redhat.com>, libertas-dev@lists.infradead.org,
	linux-wireless@vger.kernel.org
Message-Id: <E1J2i2f-0005rt-Kf@shinybook.infradead.org> (sfid-20071213_065942_961173_5FFBCB3A)
Date: Thu, 13 Dec 2007 01:59:33 -0500
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Dan Williams <dcbw@redhat.com>
Date: Tue, 11 Dec 2007 12:42:16 -0500

Signed-off-by: Dan Williams <dcbw@redhat.com>
Signed-off-by: David Woodhouse <dwmw2@infradead.org>
---
 drivers/net/wireless/libertas/cmd.c     |   76 +++++++++++++++++++++++++++----
 drivers/net/wireless/libertas/cmd.h     |    2 +
 drivers/net/wireless/libertas/cmdresp.c |   67 ---------------------------
 drivers/net/wireless/libertas/hostcmd.h |    3 +-
 drivers/net/wireless/libertas/main.c    |    6 +--
 5 files changed, 73 insertions(+), 81 deletions(-)

diff --git a/drivers/net/wireless/libertas/cmd.c b/drivers/net/wireless/libertas/cmd.c
index c4b32a0..bb940cc 100644
--- a/drivers/net/wireless/libertas/cmd.c
+++ b/drivers/net/wireless/libertas/cmd.c
@@ -11,6 +11,7 @@
 #include "dev.h"
 #include "join.h"
 #include "wext.h"
+#include "cmd.h"
 
 static void cleanup_cmdnode(struct cmd_ctrl_node *ptempnode);
 struct cmd_ctrl_node *lbs_get_cmd_ctrl_node(struct lbs_private *priv);
@@ -36,18 +37,78 @@ static u8 is_command_allowed_in_ps(u16 cmd)
 	return 0;
 }
 
-static int lbs_cmd_hw_spec(struct lbs_private *priv, struct cmd_ds_command *cmd)
+/**
+ *  @brief Updates the hardware details like MAC address and regulatory region
+ *
+ *  @param priv    	A pointer to struct lbs_private structure
+ *
+ *  @return 	   	0 on success, error on failure
+ */
+int lbs_update_hw_spec(struct lbs_private *priv)
 {
-	struct cmd_ds_get_hw_spec *hwspec = &cmd->params.hwspec;
+	struct cmd_ds_get_hw_spec cmd;
+	int ret = -1;
+	u32 i;
+	DECLARE_MAC_BUF(mac);
 
 	lbs_deb_enter(LBS_DEB_CMD);
 
-	cmd->command = cpu_to_le16(CMD_GET_HW_SPEC);
-	cmd->size = cpu_to_le16(sizeof(struct cmd_ds_get_hw_spec) + S_DS_GEN);
-	memcpy(hwspec->permanentaddr, priv->current_addr, ETH_ALEN);
+	memset(&cmd, 0, sizeof(cmd));
+	cmd.hdr.size = cpu_to_le16(sizeof(cmd));
+	memcpy(cmd.permanentaddr, priv->current_addr, ETH_ALEN);
+	ret = lbs_cmd_with_response(priv, CMD_GET_HW_SPEC, cmd);
+	if (ret)
+		goto out;
+
+	priv->fwcapinfo = le32_to_cpu(cmd.fwcapinfo);
+	memcpy(priv->fwreleasenumber, cmd.fwreleasenumber, 4);
+
+	lbs_deb_cmd("GET_HW_SPEC: firmware release %u.%u.%up%u\n",
+		    priv->fwreleasenumber[2], priv->fwreleasenumber[1],
+		    priv->fwreleasenumber[0], priv->fwreleasenumber[3]);
+	lbs_deb_cmd("GET_HW_SPEC: MAC addr %s\n",
+		    print_mac(mac, cmd.permanentaddr));
+	lbs_deb_cmd("GET_HW_SPEC: hardware interface 0x%x, hardware spec 0x%04x\n",
+		    cmd.hwifversion, cmd.version);
+
+	/* Clamp region code to 8-bit since FW spec indicates that it should
+	 * only ever be 8-bit, even though the field size is 16-bit.  Some firmware
+	 * returns non-zero high 8 bits here.
+	 */
+	priv->regioncode = le16_to_cpu(cmd.regioncode) & 0xFF;
+
+	for (i = 0; i < MRVDRV_MAX_REGION_CODE; i++) {
+		/* use the region code to search for the index */
+		if (priv->regioncode == lbs_region_code_to_index[i])
+			break;
+	}
 
+	/* if it's unidentified region code, use the default (USA) */
+	if (i >= MRVDRV_MAX_REGION_CODE) {
+		priv->regioncode = 0x10;
+		lbs_pr_info("unidentified region code; using the default (USA)\n");
+	}
+
+	if (priv->current_addr[0] == 0xff)
+		memmove(priv->current_addr, cmd.permanentaddr, ETH_ALEN);
+
+	memcpy(priv->dev->dev_addr, priv->current_addr, ETH_ALEN);
+	if (priv->mesh_dev)
+		memcpy(priv->mesh_dev->dev_addr, priv->current_addr, ETH_ALEN);
+
+	if (lbs_set_regiontable(priv, priv->regioncode, 0)) {
+		ret = -1;
+		goto out;
+	}
+
+	if (lbs_set_universaltable(priv, 0)) {
+		ret = -1;
+		goto out;
+	}
+
+out:
 	lbs_deb_leave(LBS_DEB_CMD);
-	return 0;
+	return ret;
 }
 
 static int lbs_cmd_802_11_ps_mode(struct lbs_private *priv,
@@ -1223,9 +1284,6 @@ int lbs_prepare_and_send_command(struct lbs_private *priv,
 	cmdptr->result = 0;
 
 	switch (cmd_no) {
-	case CMD_GET_HW_SPEC:
-		ret = lbs_cmd_hw_spec(priv, cmdptr);
-		break;
 	case CMD_802_11_PS_MODE:
 		ret = lbs_cmd_802_11_ps_mode(priv, cmdptr, cmd_action);
 		break;
diff --git a/drivers/net/wireless/libertas/cmd.h b/drivers/net/wireless/libertas/cmd.h
index 72857a1..b8e5d21 100644
--- a/drivers/net/wireless/libertas/cmd.h
+++ b/drivers/net/wireless/libertas/cmd.h
@@ -22,4 +22,6 @@ int __lbs_cmd(struct lbs_private *priv, uint16_t command,
 int lbs_cmd_copyback(struct lbs_private *priv, unsigned long extra,
 		     struct cmd_header *resp);
 
+int lbs_update_hw_spec(struct lbs_private *priv);
+
 #endif /* _LBS_CMD_H */
diff --git a/drivers/net/wireless/libertas/cmdresp.c b/drivers/net/wireless/libertas/cmdresp.c
index 9113669..671e323 100644
--- a/drivers/net/wireless/libertas/cmdresp.c
+++ b/drivers/net/wireless/libertas/cmdresp.c
@@ -145,69 +145,6 @@ static int lbs_ret_reg_access(struct lbs_private *priv,
 	return ret;
 }
 
-static int lbs_ret_get_hw_spec(struct lbs_private *priv,
-				struct cmd_ds_command *resp)
-{
-	u32 i;
-	struct cmd_ds_get_hw_spec *hwspec = &resp->params.hwspec;
-	int ret = 0;
-	DECLARE_MAC_BUF(mac);
-
-	lbs_deb_enter(LBS_DEB_CMD);
-
-	priv->fwcapinfo = le32_to_cpu(hwspec->fwcapinfo);
-
-	memcpy(priv->fwreleasenumber, hwspec->fwreleasenumber, 4);
-
-	lbs_deb_cmd("GET_HW_SPEC: firmware release %u.%u.%up%u\n",
-		    priv->fwreleasenumber[2], priv->fwreleasenumber[1],
-		    priv->fwreleasenumber[0], priv->fwreleasenumber[3]);
-	lbs_deb_cmd("GET_HW_SPEC: MAC addr %s\n",
-		    print_mac(mac, hwspec->permanentaddr));
-	lbs_deb_cmd("GET_HW_SPEC: hardware interface 0x%x, hardware spec 0x%04x\n",
-	       hwspec->hwifversion, hwspec->version);
-
-	/* Clamp region code to 8-bit since FW spec indicates that it should
-	 * only ever be 8-bit, even though the field size is 16-bit.  Some firmware
-	 * returns non-zero high 8 bits here.
-	 */
-	priv->regioncode = le16_to_cpu(hwspec->regioncode) & 0xFF;
-
-	for (i = 0; i < MRVDRV_MAX_REGION_CODE; i++) {
-		/* use the region code to search for the index */
-		if (priv->regioncode == lbs_region_code_to_index[i]) {
-			break;
-		}
-	}
-
-	/* if it's unidentified region code, use the default (USA) */
-	if (i >= MRVDRV_MAX_REGION_CODE) {
-		priv->regioncode = 0x10;
-		lbs_pr_info("unidentified region code; using the default (USA)\n");
-	}
-
-	if (priv->current_addr[0] == 0xff)
-		memmove(priv->current_addr, hwspec->permanentaddr, ETH_ALEN);
-
-	memcpy(priv->dev->dev_addr, priv->current_addr, ETH_ALEN);
-	if (priv->mesh_dev)
-		memcpy(priv->mesh_dev->dev_addr, priv->current_addr, ETH_ALEN);
-
-	if (lbs_set_regiontable(priv, priv->regioncode, 0)) {
-		ret = -1;
-		goto done;
-	}
-
-	if (lbs_set_universaltable(priv, 0)) {
-		ret = -1;
-		goto done;
-	}
-
-done:
-	lbs_deb_enter_args(LBS_DEB_CMD, "ret %d", ret);
-	return ret;
-}
-
 static int lbs_ret_802_11_sleep_params(struct lbs_private *priv,
 					struct cmd_ds_command *resp)
 {
@@ -569,10 +506,6 @@ static inline int handle_cmd_response(struct lbs_private *priv,
 		ret = lbs_ret_reg_access(priv, respcmd, resp);
 		break;
 
-	case CMD_RET(CMD_GET_HW_SPEC):
-		ret = lbs_ret_get_hw_spec(priv, resp);
-		break;
-
 	case CMD_RET(CMD_802_11_SCAN):
 		ret = lbs_ret_80211_scan(priv, resp);
 		break;
diff --git a/drivers/net/wireless/libertas/hostcmd.h b/drivers/net/wireless/libertas/hostcmd.h
index 93ac46a..a87c217 100644
--- a/drivers/net/wireless/libertas/hostcmd.h
+++ b/drivers/net/wireless/libertas/hostcmd.h
@@ -119,6 +119,8 @@ struct cmd_ds_gen {
  * This structure defines the response for the GET_HW_SPEC command
  */
 struct cmd_ds_get_hw_spec {
+	struct cmd_header hdr;
+
 	/* HW Interface version number */
 	__le16 hwifversion;
 	/* HW version number */
@@ -637,7 +639,6 @@ struct cmd_ds_command {
 
 	/* command Body */
 	union {
-		struct cmd_ds_get_hw_spec hwspec;
 		struct cmd_ds_802_11_ps_mode psmode;
 		struct cmd_ds_802_11_scan scan;
 		struct cmd_ds_802_11_scan_rsp scanresp;
diff --git a/drivers/net/wireless/libertas/main.c b/drivers/net/wireless/libertas/main.c
index 9a23109..9f6c119 100644
--- a/drivers/net/wireless/libertas/main.c
+++ b/drivers/net/wireless/libertas/main.c
@@ -22,6 +22,7 @@
 #include "debugfs.h"
 #include "assoc.h"
 #include "join.h"
+#include "cmd.h"
 
 #define DRIVER_RELEASE_VERSION "323.p0"
 const char lbs_driver_version[] = "COMM-USB8388-" DRIVER_RELEASE_VERSION
@@ -843,10 +844,7 @@ static int lbs_setup_firmware(struct lbs_private *priv)
 	 * Read MAC address from HW
 	 */
 	memset(priv->current_addr, 0xff, ETH_ALEN);
-
-	ret = lbs_prepare_and_send_command(priv, CMD_GET_HW_SPEC,
-				    0, CMD_OPTION_WAITFORRSP, 0, NULL);
-
+	ret = lbs_update_hw_spec(priv);
 	if (ret) {
 		ret = -1;
 		goto done;
-- 
1.5.3.4

