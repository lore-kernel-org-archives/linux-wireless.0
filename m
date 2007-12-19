Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from pmac.infradead.org ([90.155.92.200]:40760 "EHLO
	pmac.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752223AbXLSQJ6 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 19 Dec 2007 11:09:58 -0500
Subject: [PATCH 129/48] libertas: convert SLEEP_PARAMS to a direct command
From: David Woodhouse <dwmw2@infradead.org>
In-Reply-To: <libertas-12345@shinybook.infradead.org>
To: John Linville <linville@tuxdriver.com>
Cc: Dan Williams <dcbw@redhat.com>, libertas-dev@lists.infradead.org,
	linux-wireless@vger.kernel.org
Message-Id: <E1J50vC-00021e-Fm@pmac.infradead.org> (sfid-20071219_161004_009542_D60052F7)
Date: Wed, 19 Dec 2007 15:33:22 +0000
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Date: Mon, 17 Dec 2007 23:48:31 -0500

Signed-off-by: David Woodhouse <dwmw2@infradead.org>
---
 drivers/net/wireless/libertas/cmd.c     |   56 +++++++++++++++-----------
 drivers/net/wireless/libertas/cmd.h     |    2 +
 drivers/net/wireless/libertas/cmdresp.c |   26 ------------
 drivers/net/wireless/libertas/debugfs.c |   66 ++++++++++++++-----------------
 drivers/net/wireless/libertas/dev.h     |   15 +++----
 drivers/net/wireless/libertas/hostcmd.h |    7 ++-
 6 files changed, 74 insertions(+), 98 deletions(-)

diff --git a/drivers/net/wireless/libertas/cmd.c b/drivers/net/wireless/libertas/cmd.c
index 57d1707..3d9ad0e 100644
--- a/drivers/net/wireless/libertas/cmd.c
+++ b/drivers/net/wireless/libertas/cmd.c
@@ -198,33 +198,45 @@ int lbs_cmd_802_11_inactivity_timeout(struct lbs_private *priv,
 	return 0;
 }
 
-static int lbs_cmd_802_11_sleep_params(struct lbs_private *priv,
-					struct cmd_ds_command *cmd,
-					u16 cmd_action)
+int lbs_cmd_802_11_sleep_params(struct lbs_private *priv, uint16_t cmd_action,
+				struct sleep_params *sp)
 {
-	struct cmd_ds_802_11_sleep_params *sp = &cmd->params.sleep_params;
+	struct cmd_ds_802_11_sleep_params cmd;
+	int ret;
 
 	lbs_deb_enter(LBS_DEB_CMD);
 
-	cmd->size = cpu_to_le16((sizeof(struct cmd_ds_802_11_sleep_params)) +
-				S_DS_GEN);
-	cmd->command = cpu_to_le16(CMD_802_11_SLEEP_PARAMS);
-
 	if (cmd_action == CMD_ACT_GET) {
-		memset(&priv->sp, 0, sizeof(struct sleep_params));
-		memset(sp, 0, sizeof(struct cmd_ds_802_11_sleep_params));
-		sp->action = cpu_to_le16(cmd_action);
-	} else if (cmd_action == CMD_ACT_SET) {
-		sp->action = cpu_to_le16(cmd_action);
-		sp->error = cpu_to_le16(priv->sp.sp_error);
-		sp->offset = cpu_to_le16(priv->sp.sp_offset);
-		sp->stabletime = cpu_to_le16(priv->sp.sp_stabletime);
-		sp->calcontrol = (u8) priv->sp.sp_calcontrol;
-		sp->externalsleepclk = (u8) priv->sp.sp_extsleepclk;
-		sp->reserved = cpu_to_le16(priv->sp.sp_reserved);
+		memset(&cmd, 0, sizeof(cmd));
+	} else {
+		cmd.error = cpu_to_le16(sp->sp_error);
+		cmd.offset = cpu_to_le16(sp->sp_offset);
+		cmd.stabletime = cpu_to_le16(sp->sp_stabletime);
+		cmd.calcontrol = sp->sp_calcontrol;
+		cmd.externalsleepclk = sp->sp_extsleepclk;
+		cmd.reserved = cpu_to_le16(sp->sp_reserved);
 	}
+	cmd.hdr.size = cpu_to_le16(sizeof(cmd));
+	cmd.action = cpu_to_le16(cmd_action);
 
-	lbs_deb_leave(LBS_DEB_CMD);
+	ret = lbs_cmd_with_response(priv, CMD_802_11_SLEEP_PARAMS, &cmd);
+
+	if (!ret) {
+		lbs_deb_cmd("error 0x%x, offset 0x%x, stabletime 0x%x, "
+			    "calcontrol 0x%x extsleepclk 0x%x\n",
+			    le16_to_cpu(cmd.error), le16_to_cpu(cmd.offset),
+			    le16_to_cpu(cmd.stabletime), cmd.calcontrol,
+			    cmd.externalsleepclk);
+
+		sp->sp_error = le16_to_cpu(cmd.error);
+		sp->sp_offset = le16_to_cpu(cmd.offset);
+		sp->sp_stabletime = le16_to_cpu(cmd.stabletime);
+		sp->sp_calcontrol = cmd.calcontrol;
+		sp->sp_extsleepclk = cmd.externalsleepclk;
+		sp->sp_reserved = le16_to_cpu(cmd.reserved);
+	}
+
+	lbs_deb_leave_args(LBS_DEB_CMD, "ret %d", ret);
 	return 0;
 }
 
@@ -1520,10 +1532,6 @@ int lbs_prepare_and_send_command(struct lbs_private *priv,
 						   cmd_no, cmd_action);
 		break;
 
-	case CMD_802_11_SLEEP_PARAMS:
-		ret = lbs_cmd_802_11_sleep_params(priv, cmdptr, cmd_action);
-		break;
-
 	case CMD_802_11_TPC_CFG:
 		cmdptr->command = cpu_to_le16(CMD_802_11_TPC_CFG);
 		cmdptr->size =
diff --git a/drivers/net/wireless/libertas/cmd.h b/drivers/net/wireless/libertas/cmd.h
index 50821e7..ca09b18 100644
--- a/drivers/net/wireless/libertas/cmd.h
+++ b/drivers/net/wireless/libertas/cmd.h
@@ -49,5 +49,7 @@ int lbs_resume(struct lbs_private *priv);
 
 int lbs_cmd_802_11_inactivity_timeout(struct lbs_private *priv,
 				      uint16_t cmd_action, uint16_t *timeout);
+int lbs_cmd_802_11_sleep_params(struct lbs_private *priv, uint16_t cmd_action,
+				struct sleep_params *sp);
 
 #endif /* _LBS_CMD_H */
diff --git a/drivers/net/wireless/libertas/cmdresp.c b/drivers/net/wireless/libertas/cmdresp.c
index f7fb8c7..40615a8 100644
--- a/drivers/net/wireless/libertas/cmdresp.c
+++ b/drivers/net/wireless/libertas/cmdresp.c
@@ -146,29 +146,6 @@ static int lbs_ret_reg_access(struct lbs_private *priv,
 	return ret;
 }
 
-static int lbs_ret_802_11_sleep_params(struct lbs_private *priv,
-					struct cmd_ds_command *resp)
-{
-	struct cmd_ds_802_11_sleep_params *sp = &resp->params.sleep_params;
-
-	lbs_deb_enter(LBS_DEB_CMD);
-
-	lbs_deb_cmd("error 0x%x, offset 0x%x, stabletime 0x%x, calcontrol 0x%x "
-		    "extsleepclk 0x%x\n", le16_to_cpu(sp->error),
-		    le16_to_cpu(sp->offset), le16_to_cpu(sp->stabletime),
-		    sp->calcontrol, sp->externalsleepclk);
-
-	priv->sp.sp_error = le16_to_cpu(sp->error);
-	priv->sp.sp_offset = le16_to_cpu(sp->offset);
-	priv->sp.sp_stabletime = le16_to_cpu(sp->stabletime);
-	priv->sp.sp_calcontrol = sp->calcontrol;
-	priv->sp.sp_extsleepclk = sp->externalsleepclk;
-	priv->sp.sp_reserved = le16_to_cpu(sp->reserved);
-
-	lbs_deb_enter(LBS_DEB_CMD);
-	return 0;
-}
-
 static int lbs_ret_802_11_stat(struct lbs_private *priv,
 				struct cmd_ds_command *resp)
 {
@@ -551,9 +528,6 @@ static inline int handle_cmd_response(struct lbs_private *priv,
 		ret = lbs_ret_802_11d_domain_info(priv, resp);
 		break;
 
-	case CMD_RET(CMD_802_11_SLEEP_PARAMS):
-		ret = lbs_ret_802_11_sleep_params(priv, resp);
-		break;
 	case CMD_RET(CMD_802_11_TPC_CFG):
 		spin_lock_irqsave(&priv->driver_lock, flags);
 		memmove((void *)priv->cur_cmd->callback_arg, &resp->params.tpccfg,
diff --git a/drivers/net/wireless/libertas/debugfs.c b/drivers/net/wireless/libertas/debugfs.c
index 226b183..fa6c594 100644
--- a/drivers/net/wireless/libertas/debugfs.c
+++ b/drivers/net/wireless/libertas/debugfs.c
@@ -10,6 +10,7 @@
 #include "decl.h"
 #include "host.h"
 #include "debugfs.h"
+#include "cmd.h"
 
 static struct dentry *lbs_dir;
 static char *szStates[] = {
@@ -103,71 +104,64 @@ static ssize_t lbs_sleepparams_write(struct file *file,
 				loff_t *ppos)
 {
 	struct lbs_private *priv = file->private_data;
-	ssize_t buf_size, res;
+	ssize_t buf_size, ret;
+	struct sleep_params sp;
 	int p1, p2, p3, p4, p5, p6;
 	unsigned long addr = get_zeroed_page(GFP_KERNEL);
 	char *buf = (char *)addr;
 
 	buf_size = min(count, len - 1);
 	if (copy_from_user(buf, user_buf, buf_size)) {
-		res = -EFAULT;
+		ret = -EFAULT;
 		goto out_unlock;
 	}
-	res = sscanf(buf, "%d %d %d %d %d %d", &p1, &p2, &p3, &p4, &p5, &p6);
-	if (res != 6) {
-		res = -EFAULT;
+	ret = sscanf(buf, "%d %d %d %d %d %d", &p1, &p2, &p3, &p4, &p5, &p6);
+	if (ret != 6) {
+		ret = -EINVAL;
 		goto out_unlock;
 	}
-	priv->sp.sp_error = p1;
-	priv->sp.sp_offset = p2;
-	priv->sp.sp_stabletime = p3;
-	priv->sp.sp_calcontrol = p4;
-	priv->sp.sp_extsleepclk = p5;
-	priv->sp.sp_reserved = p6;
-
-	res = lbs_prepare_and_send_command(priv,
-				CMD_802_11_SLEEP_PARAMS,
-				CMD_ACT_SET,
-				CMD_OPTION_WAITFORRSP, 0, NULL);
-
-	if (!res)
-		res = count;
-	else
-		res = -EINVAL;
+	sp.sp_error = p1;
+	sp.sp_offset = p2;
+	sp.sp_stabletime = p3;
+	sp.sp_calcontrol = p4;
+	sp.sp_extsleepclk = p5;
+	sp.sp_reserved = p6;
+
+	ret = lbs_cmd_802_11_sleep_params(priv, CMD_ACT_SET, &sp);
+	if (!ret)
+		ret = count;
+	else if (ret > 0)
+		ret = -EINVAL;
 
 out_unlock:
 	free_page(addr);
-	return res;
+	return ret;
 }
 
 static ssize_t lbs_sleepparams_read(struct file *file, char __user *userbuf,
 				  size_t count, loff_t *ppos)
 {
 	struct lbs_private *priv = file->private_data;
-	ssize_t res;
+	ssize_t ret;
 	size_t pos = 0;
+	struct sleep_params sp;
 	unsigned long addr = get_zeroed_page(GFP_KERNEL);
 	char *buf = (char *)addr;
 
-	res = lbs_prepare_and_send_command(priv,
-				CMD_802_11_SLEEP_PARAMS,
-				CMD_ACT_GET,
-				CMD_OPTION_WAITFORRSP, 0, NULL);
-	if (res) {
-		res = -EFAULT;
+	ret = lbs_cmd_802_11_sleep_params(priv, CMD_ACT_GET, &sp);
+	if (ret)
 		goto out_unlock;
-	}
 
-	pos += snprintf(buf, len, "%d %d %d %d %d %d\n", priv->sp.sp_error,
-			priv->sp.sp_offset, priv->sp.sp_stabletime,
-			priv->sp.sp_calcontrol, priv->sp.sp_extsleepclk,
-			priv->sp.sp_reserved);
+	pos += snprintf(buf, len, "%d %d %d %d %d %d\n", sp.sp_error,
+			sp.sp_offset, sp.sp_stabletime,
+			sp.sp_calcontrol, sp.sp_extsleepclk,
+			sp.sp_reserved);
 
-	res = simple_read_from_buffer(userbuf, count, ppos, buf, pos);
+	ret = simple_read_from_buffer(userbuf, count, ppos, buf, pos);
 
 out_unlock:
 	free_page(addr);
-	return res;
+	return ret;
 }
 
 static ssize_t lbs_extscan(struct file *file, const char __user *userbuf,
diff --git a/drivers/net/wireless/libertas/dev.h b/drivers/net/wireless/libertas/dev.h
index 1c6ec4d..3629751 100644
--- a/drivers/net/wireless/libertas/dev.h
+++ b/drivers/net/wireless/libertas/dev.h
@@ -77,12 +77,12 @@ struct current_bss_params {
 
 /** sleep_params */
 struct sleep_params {
-	u16 sp_error;
-	u16 sp_offset;
-	u16 sp_stabletime;
-	u8 sp_calcontrol;
-	u8 sp_extsleepclk;
-	u16 sp_reserved;
+	uint16_t sp_error;
+	uint16_t sp_offset;
+	uint16_t sp_stabletime;
+	uint8_t  sp_calcontrol;
+	uint8_t  sp_extsleepclk;
+	uint16_t sp_reserved;
 };
 
 /* Mesh statistics */
@@ -300,9 +300,6 @@ struct lbs_private {
 	u8 cur_rate;
 	u8 auto_rate;
 
-	/** sleep_params */
-	struct sleep_params sp;
-
 	/** RF calibration data */
 
 #define	MAX_REGION_CHANNEL_NUM	2
diff --git a/drivers/net/wireless/libertas/hostcmd.h b/drivers/net/wireless/libertas/hostcmd.h
index 2ad32bc..855c2d0 100644
--- a/drivers/net/wireless/libertas/hostcmd.h
+++ b/drivers/net/wireless/libertas/hostcmd.h
@@ -355,6 +355,8 @@ struct cmd_ds_802_11_beacon_control {
 };
 
 struct cmd_ds_802_11_sleep_params {
+	struct cmd_header hdr;
+
 	/* ACT_GET/ACT_SET */
 	__le16 action;
 
@@ -368,10 +370,10 @@ struct cmd_ds_802_11_sleep_params {
 	__le16 stabletime;
 
 	/* control periodic calibration */
-	u8 calcontrol;
+	uint8_t calcontrol;
 
 	/* control the use of external sleep clock */
-	u8 externalsleepclk;
+	uint8_t externalsleepclk;
 
 	/* reserved field, should be set to zero */
 	__le16 reserved;
@@ -715,7 +717,6 @@ struct cmd_ds_command {
 		struct cmd_ds_802_11d_domain_info domaininfo;
 		struct cmd_ds_802_11d_domain_info domaininforesp;
 
-		struct cmd_ds_802_11_sleep_params sleep_params;
 		struct cmd_ds_802_11_tpc_cfg tpccfg;
 		struct cmd_ds_802_11_pwr_cfg pwrcfg;
 		struct cmd_ds_802_11_afc afc;
-- 
1.5.3.4

