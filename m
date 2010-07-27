Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:49535 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751959Ab0G0R7l (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 27 Jul 2010 13:59:41 -0400
Subject: [wt PATCH 8/16] libertas: convert register access to direct
 commands
From: Dan Williams <dcbw@redhat.com>
To: "John W. Linville" <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org
In-Reply-To: <1280260357.19686.13.camel@dcbw.foobar.com>
References: <1280260357.19686.13.camel@dcbw.foobar.com>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 27 Jul 2010 13:01:07 -0700
Message-ID: <1280260867.19686.23.camel@dcbw.foobar.com>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Signed-off-by: Dan Williams <dcbw@redhat.com>
---
 drivers/net/wireless/libertas/cmd.c     |  130 ++++++++++++++++---------------
 drivers/net/wireless/libertas/cmd.h     |    4 +
 drivers/net/wireless/libertas/cmdresp.c |   48 -----------
 drivers/net/wireless/libertas/debugfs.c |   67 ++++------------
 drivers/net/wireless/libertas/dev.h     |    1 -
 drivers/net/wireless/libertas/host.h    |   24 ++----
 6 files changed, 94 insertions(+), 180 deletions(-)

diff --git a/drivers/net/wireless/libertas/cmd.c b/drivers/net/wireless/libertas/cmd.c
index a09ee6b..b8df1fd 100644
--- a/drivers/net/wireless/libertas/cmd.c
+++ b/drivers/net/wireless/libertas/cmd.c
@@ -848,78 +848,86 @@ int lbs_set_11d_domain_info(struct lbs_private *priv,
 	return ret;
 }
 
-static int lbs_cmd_reg_access(struct cmd_ds_command *cmdptr,
-			       u8 cmd_action, void *pdata_buf)
+/**
+ *  @brief Read a MAC, Baseband, or RF register
+ *
+ *  @param priv		pointer to struct lbs_private
+ *  @param cmd		register command, one of CMD_MAC_REG_ACCESS,
+ *                        CMD_BBP_REG_ACCESS, or CMD_RF_REG_ACCESS
+ *  @param offset       byte offset of the register to get
+ *  @param value        on success, the value of the register at 'offset'
+ *
+ *  @return		0 on success, error code on failure
+*/
+int lbs_get_reg(struct lbs_private *priv, u16 reg, u16 offset, u32 *value)
 {
-	struct lbs_offset_value *offval;
+	struct cmd_ds_reg_access cmd;
+	int ret = 0;
 
 	lbs_deb_enter(LBS_DEB_CMD);
 
-	offval = (struct lbs_offset_value *)pdata_buf;
-
-	switch (le16_to_cpu(cmdptr->command)) {
-	case CMD_MAC_REG_ACCESS:
-		{
-			struct cmd_ds_mac_reg_access *macreg;
-
-			cmdptr->size =
-			    cpu_to_le16(sizeof (struct cmd_ds_mac_reg_access)
-					+ sizeof(struct cmd_header));
-			macreg =
-			    (struct cmd_ds_mac_reg_access *)&cmdptr->params.
-			    macreg;
-
-			macreg->action = cpu_to_le16(cmd_action);
-			macreg->offset = cpu_to_le16((u16) offval->offset);
-			macreg->value = cpu_to_le32(offval->value);
-
-			break;
-		}
-
-	case CMD_BBP_REG_ACCESS:
-		{
-			struct cmd_ds_bbp_reg_access *bbpreg;
+	BUG_ON(value == NULL);
 
-			cmdptr->size =
-			    cpu_to_le16(sizeof
-					     (struct cmd_ds_bbp_reg_access)
-					     + sizeof(struct cmd_header));
-			bbpreg =
-			    (struct cmd_ds_bbp_reg_access *)&cmdptr->params.
-			    bbpreg;
+	memset(&cmd, 0, sizeof(cmd));
+	cmd.hdr.size = cpu_to_le16(sizeof(cmd));
+	cmd.action = cpu_to_le16(CMD_ACT_GET);
 
-			bbpreg->action = cpu_to_le16(cmd_action);
-			bbpreg->offset = cpu_to_le16((u16) offval->offset);
-			bbpreg->value = (u8) offval->value;
+	if (reg != CMD_MAC_REG_ACCESS &&
+	    reg != CMD_BBP_REG_ACCESS &&
+	    reg != CMD_RF_REG_ACCESS) {
+		ret = -EINVAL;
+		goto out;
+	}
 
-			break;
-		}
+	ret = lbs_cmd_with_response(priv, reg, &cmd);
+	if (ret) {
+		if (reg == CMD_BBP_REG_ACCESS || reg == CMD_RF_REG_ACCESS)
+			*value = cmd.value.bbp_rf;
+		else if (reg == CMD_MAC_REG_ACCESS)
+			*value = le32_to_cpu(cmd.value.mac);
+	}
 
-	case CMD_RF_REG_ACCESS:
-		{
-			struct cmd_ds_rf_reg_access *rfreg;
+out:
+	lbs_deb_leave_args(LBS_DEB_CMD, "ret %d", ret);
+	return ret;
+}
 
-			cmdptr->size =
-			    cpu_to_le16(sizeof
-					     (struct cmd_ds_rf_reg_access) +
-					     sizeof(struct cmd_header));
-			rfreg =
-			    (struct cmd_ds_rf_reg_access *)&cmdptr->params.
-			    rfreg;
+/**
+ *  @brief Write a MAC, Baseband, or RF register
+ *
+ *  @param priv		pointer to struct lbs_private
+ *  @param cmd		register command, one of CMD_MAC_REG_ACCESS,
+ *                        CMD_BBP_REG_ACCESS, or CMD_RF_REG_ACCESS
+ *  @param offset       byte offset of the register to set
+ *  @param value        the value to write to the register at 'offset'
+ *
+ *  @return		0 on success, error code on failure
+*/
+int lbs_set_reg(struct lbs_private *priv, u16 reg, u16 offset, u32 value)
+{
+	struct cmd_ds_reg_access cmd;
+	int ret = 0;
 
-			rfreg->action = cpu_to_le16(cmd_action);
-			rfreg->offset = cpu_to_le16((u16) offval->offset);
-			rfreg->value = (u8) offval->value;
+	lbs_deb_enter(LBS_DEB_CMD);
 
-			break;
-		}
+	memset(&cmd, 0, sizeof(cmd));
+	cmd.hdr.size = cpu_to_le16(sizeof(cmd));
+	cmd.action = cpu_to_le16(CMD_ACT_SET);
 
-	default:
-		break;
+	if (reg == CMD_BBP_REG_ACCESS || reg == CMD_RF_REG_ACCESS)
+		cmd.value.bbp_rf = (u8) (value & 0xFF);
+	else if (reg == CMD_MAC_REG_ACCESS)
+		cmd.value.mac = cpu_to_le32(value);
+	else {
+		ret = -EINVAL;
+		goto out;
 	}
 
-	lbs_deb_leave(LBS_DEB_CMD);
-	return 0;
+	ret = lbs_cmd_with_response(priv, reg, &cmd);
+
+out:
+	lbs_deb_leave_args(LBS_DEB_CMD, "ret %d", ret);
+	return ret;
 }
 
 static void lbs_queue_cmd(struct lbs_private *priv,
@@ -1198,12 +1206,6 @@ int lbs_prepare_and_send_command(struct lbs_private *priv,
 		ret = lbs_cmd_802_11_ps_mode(cmdptr, cmd_action);
 		break;
 
-	case CMD_MAC_REG_ACCESS:
-	case CMD_BBP_REG_ACCESS:
-	case CMD_RF_REG_ACCESS:
-		ret = lbs_cmd_reg_access(cmdptr, cmd_action, pdata_buf);
-		break;
-
 #ifdef CONFIG_LIBERTAS_MESH
 
 	case CMD_BT_ACCESS:
diff --git a/drivers/net/wireless/libertas/cmd.h b/drivers/net/wireless/libertas/cmd.h
index 2c24c19..bfb3690 100644
--- a/drivers/net/wireless/libertas/cmd.h
+++ b/drivers/net/wireless/libertas/cmd.h
@@ -139,4 +139,8 @@ int lbs_set_11d_domain_info(struct lbs_private *priv,
 			    struct regulatory_request *request,
 			    struct ieee80211_supported_band **bands);
 
+int lbs_get_reg(struct lbs_private *priv, u16 reg, u16 offset, u32 *value);
+
+int lbs_set_reg(struct lbs_private *priv, u16 reg, u16 offset, u32 value);
+
 #endif /* _LBS_CMD_H */
diff --git a/drivers/net/wireless/libertas/cmdresp.c b/drivers/net/wireless/libertas/cmdresp.c
index 6196e54..810d758 100644
--- a/drivers/net/wireless/libertas/cmdresp.c
+++ b/drivers/net/wireless/libertas/cmdresp.c
@@ -54,48 +54,6 @@ void lbs_mac_event_disconnected(struct lbs_private *priv)
 	lbs_deb_leave(LBS_DEB_ASSOC);
 }
 
-static int lbs_ret_reg_access(struct lbs_private *priv,
-			       u16 type, struct cmd_ds_command *resp)
-{
-	int ret = 0;
-
-	lbs_deb_enter(LBS_DEB_CMD);
-
-	switch (type) {
-	case CMD_RET(CMD_MAC_REG_ACCESS):
-		{
-			struct cmd_ds_mac_reg_access *reg = &resp->params.macreg;
-
-			priv->offsetvalue.offset = (u32)le16_to_cpu(reg->offset);
-			priv->offsetvalue.value = le32_to_cpu(reg->value);
-			break;
-		}
-
-	case CMD_RET(CMD_BBP_REG_ACCESS):
-		{
-			struct cmd_ds_bbp_reg_access *reg = &resp->params.bbpreg;
-
-			priv->offsetvalue.offset = (u32)le16_to_cpu(reg->offset);
-			priv->offsetvalue.value = reg->value;
-			break;
-		}
-
-	case CMD_RET(CMD_RF_REG_ACCESS):
-		{
-			struct cmd_ds_rf_reg_access *reg = &resp->params.rfreg;
-
-			priv->offsetvalue.offset = (u32)le16_to_cpu(reg->offset);
-			priv->offsetvalue.value = reg->value;
-			break;
-		}
-
-	default:
-		ret = -1;
-	}
-
-	lbs_deb_leave_args(LBS_DEB_CMD, "ret %d", ret);
-	return ret;
-}
 static inline int handle_cmd_response(struct lbs_private *priv,
 				      struct cmd_header *cmd_response)
 {
@@ -107,12 +65,6 @@ static inline int handle_cmd_response(struct lbs_private *priv,
 	lbs_deb_enter(LBS_DEB_HOST);
 
 	switch (respcmd) {
-	case CMD_RET(CMD_MAC_REG_ACCESS):
-	case CMD_RET(CMD_BBP_REG_ACCESS):
-	case CMD_RET(CMD_RF_REG_ACCESS):
-		ret = lbs_ret_reg_access(priv, respcmd, resp);
-		break;
-
 	case CMD_RET(CMD_802_11_BEACON_STOP):
 		break;
 
diff --git a/drivers/net/wireless/libertas/debugfs.c b/drivers/net/wireless/libertas/debugfs.c
index 3db621b..651a79c 100644
--- a/drivers/net/wireless/libertas/debugfs.c
+++ b/drivers/net/wireless/libertas/debugfs.c
@@ -446,30 +446,24 @@ static ssize_t lbs_bcnmiss_write(struct file *file, const char __user *userbuf,
 }
 
 
-
 static ssize_t lbs_rdmac_read(struct file *file, char __user *userbuf,
 				  size_t count, loff_t *ppos)
 {
 	struct lbs_private *priv = file->private_data;
-	struct lbs_offset_value offval;
 	ssize_t pos = 0;
 	int ret;
 	unsigned long addr = get_zeroed_page(GFP_KERNEL);
 	char *buf = (char *)addr;
+	u32 val = 0;
+
 	if (!buf)
 		return -ENOMEM;
 
-	offval.offset = priv->mac_offset;
-	offval.value = 0;
-
-	ret = lbs_prepare_and_send_command(priv,
-				CMD_MAC_REG_ACCESS, 0,
-				CMD_OPTION_WAITFORRSP, 0, &offval);
+	ret = lbs_get_reg(priv, CMD_MAC_REG_ACCESS, priv->mac_offset, &val);
 	mdelay(10);
 	if (!ret) {
-		pos += snprintf(buf+pos, len-pos, "MAC[0x%x] = 0x%08x\n",
-				priv->mac_offset, priv->offsetvalue.value);
-
+		pos = snprintf(buf, len, "MAC[0x%x] = 0x%08x\n",
+				priv->mac_offset, val);
 		ret = simple_read_from_buffer(userbuf, count, ppos, buf, pos);
 	}
 	free_page(addr);
@@ -507,7 +501,6 @@ static ssize_t lbs_wrmac_write(struct file *file,
 	struct lbs_private *priv = file->private_data;
 	ssize_t res, buf_size;
 	u32 offset, value;
-	struct lbs_offset_value offval;
 	unsigned long addr = get_zeroed_page(GFP_KERNEL);
 	char *buf = (char *)addr;
 	if (!buf)
@@ -524,11 +517,7 @@ static ssize_t lbs_wrmac_write(struct file *file,
 		goto out_unlock;
 	}
 
-	offval.offset = offset;
-	offval.value = value;
-	res = lbs_prepare_and_send_command(priv,
-				CMD_MAC_REG_ACCESS, 1,
-				CMD_OPTION_WAITFORRSP, 0, &offval);
+	res = lbs_set_reg(priv, CMD_MAC_REG_ACCESS, offset, value);
 	mdelay(10);
 
 	if (!res)
@@ -542,25 +531,20 @@ static ssize_t lbs_rdbbp_read(struct file *file, char __user *userbuf,
 				  size_t count, loff_t *ppos)
 {
 	struct lbs_private *priv = file->private_data;
-	struct lbs_offset_value offval;
 	ssize_t pos = 0;
 	int ret;
 	unsigned long addr = get_zeroed_page(GFP_KERNEL);
 	char *buf = (char *)addr;
+	u32 val;
+
 	if (!buf)
 		return -ENOMEM;
 
-	offval.offset = priv->bbp_offset;
-	offval.value = 0;
-
-	ret = lbs_prepare_and_send_command(priv,
-				CMD_BBP_REG_ACCESS, 0,
-				CMD_OPTION_WAITFORRSP, 0, &offval);
+	ret = lbs_get_reg(priv, CMD_BBP_REG_ACCESS, priv->bbp_offset, &val);
 	mdelay(10);
 	if (!ret) {
-		pos += snprintf(buf+pos, len-pos, "BBP[0x%x] = 0x%08x\n",
-				priv->bbp_offset, priv->offsetvalue.value);
-
+		pos = snprintf(buf, len, "BBP[0x%x] = 0x%08x\n",
+				priv->bbp_offset, val);
 		ret = simple_read_from_buffer(userbuf, count, ppos, buf, pos);
 	}
 	free_page(addr);
@@ -599,7 +583,6 @@ static ssize_t lbs_wrbbp_write(struct file *file,
 	struct lbs_private *priv = file->private_data;
 	ssize_t res, buf_size;
 	u32 offset, value;
-	struct lbs_offset_value offval;
 	unsigned long addr = get_zeroed_page(GFP_KERNEL);
 	char *buf = (char *)addr;
 	if (!buf)
@@ -616,11 +599,7 @@ static ssize_t lbs_wrbbp_write(struct file *file,
 		goto out_unlock;
 	}
 
-	offval.offset = offset;
-	offval.value = value;
-	res = lbs_prepare_and_send_command(priv,
-				CMD_BBP_REG_ACCESS, 1,
-				CMD_OPTION_WAITFORRSP, 0, &offval);
+	res = lbs_set_reg(priv, CMD_BBP_REG_ACCESS, offset, value);
 	mdelay(10);
 
 	if (!res)
@@ -634,25 +613,20 @@ static ssize_t lbs_rdrf_read(struct file *file, char __user *userbuf,
 				  size_t count, loff_t *ppos)
 {
 	struct lbs_private *priv = file->private_data;
-	struct lbs_offset_value offval;
 	ssize_t pos = 0;
 	int ret;
 	unsigned long addr = get_zeroed_page(GFP_KERNEL);
 	char *buf = (char *)addr;
+	u32 val;
+
 	if (!buf)
 		return -ENOMEM;
 
-	offval.offset = priv->rf_offset;
-	offval.value = 0;
-
-	ret = lbs_prepare_and_send_command(priv,
-				CMD_RF_REG_ACCESS, 0,
-				CMD_OPTION_WAITFORRSP, 0, &offval);
+	ret = lbs_get_reg(priv, CMD_RF_REG_ACCESS, priv->rf_offset, &val);
 	mdelay(10);
 	if (!ret) {
-		pos += snprintf(buf+pos, len-pos, "RF[0x%x] = 0x%08x\n",
-				priv->rf_offset, priv->offsetvalue.value);
-
+		pos = snprintf(buf, len, "RF[0x%x] = 0x%08x\n",
+				priv->rf_offset, val);
 		ret = simple_read_from_buffer(userbuf, count, ppos, buf, pos);
 	}
 	free_page(addr);
@@ -691,7 +665,6 @@ static ssize_t lbs_wrrf_write(struct file *file,
 	struct lbs_private *priv = file->private_data;
 	ssize_t res, buf_size;
 	u32 offset, value;
-	struct lbs_offset_value offval;
 	unsigned long addr = get_zeroed_page(GFP_KERNEL);
 	char *buf = (char *)addr;
 	if (!buf)
@@ -708,11 +681,7 @@ static ssize_t lbs_wrrf_write(struct file *file,
 		goto out_unlock;
 	}
 
-	offval.offset = offset;
-	offval.value = value;
-	res = lbs_prepare_and_send_command(priv,
-				CMD_RF_REG_ACCESS, 1,
-				CMD_OPTION_WAITFORRSP, 0, &offval);
+	res = lbs_set_reg(priv, CMD_RF_REG_ACCESS, offset, value);
 	mdelay(10);
 
 	if (!res)
diff --git a/drivers/net/wireless/libertas/dev.h b/drivers/net/wireless/libertas/dev.h
index be263ac..556a9c3 100644
--- a/drivers/net/wireless/libertas/dev.h
+++ b/drivers/net/wireless/libertas/dev.h
@@ -64,7 +64,6 @@ struct lbs_private {
 	u32 mac_offset;
 	u32 bbp_offset;
 	u32 rf_offset;
-	struct lbs_offset_value offsetvalue;
 
 	/* Power management */
 	u16 psmode;
diff --git a/drivers/net/wireless/libertas/host.h b/drivers/net/wireless/libertas/host.h
index 7f512ed..bd86d65 100644
--- a/drivers/net/wireless/libertas/host.h
+++ b/drivers/net/wireless/libertas/host.h
@@ -567,24 +567,15 @@ struct cmd_ds_802_11_snmp_mib {
 	u8 value[128];
 } __attribute__ ((packed));
 
-struct cmd_ds_mac_reg_access {
-	__le16 action;
-	__le16 offset;
-	__le32 value;
-} __attribute__ ((packed));
-
-struct cmd_ds_bbp_reg_access {
-	__le16 action;
-	__le16 offset;
-	u8 value;
-	u8 reserved[3];
-} __attribute__ ((packed));
+struct cmd_ds_reg_access {
+	struct cmd_header hdr;
 
-struct cmd_ds_rf_reg_access {
 	__le16 action;
 	__le16 offset;
-	u8 value;
-	u8 reserved[3];
+	union {
+		u8 bbp_rf;  /* for BBP and RF registers */
+		__le32 mac; /* for MAC registers */
+	} value;
 } __attribute__ ((packed));
 
 struct cmd_ds_802_11_radio_control {
@@ -968,9 +959,6 @@ struct cmd_ds_command {
 	/* command Body */
 	union {
 		struct cmd_ds_802_11_ps_mode psmode;
-		struct cmd_ds_mac_reg_access macreg;
-		struct cmd_ds_bbp_reg_access bbpreg;
-		struct cmd_ds_rf_reg_access rfreg;
 		struct cmd_ds_bt_access bt;
 		struct cmd_ds_fwt_access fwt;
 	} params;
-- 
1.7.1.1


