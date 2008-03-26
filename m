Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s131.mittwaldmedien.de ([62.216.178.31]:22822 "EHLO
	s131.mittwaldmedien.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750937AbYCZJGq (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 26 Mar 2008 05:06:46 -0400
From: Holger Schurig <hs4233@mail.mn-solutions.de>
To: libertas-dev@lists.infradead.org
Subject: [PATCH] libertas: convert CMD_802_11_EEPROM_ACCESS to a direct command
Date: Wed, 26 Mar 2008 10:03:48 +0100
Cc: Dan Williams <dcbw@redhat.com>, linux-wireless@vger.kernel.org,
	"John W. Linville" <linville@tuxdriver.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Message-Id: <200803261003.48250.hs4233@mail.mn-solutions.de> (sfid-20080326_090649_216382_F117E559)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Signed-off-by: Holger Schurig <hs4233@mail.mn-solutions.de>

---

Side note: on http://wiki.laptop.org/go/88W8388#Gross_EEPROM_map is
a little shell script that uses "ethtool" to get the dump. I used
this script before and after the patch to check it's sanity. While
I was doing this, I noticed that our new "direct command" thingy
is way faster than it used to be:

Before this patch:

# time lbs_eeprom >a

real    0m11.635s
user    0m0.540s
sys     0m11.053s


After this patch:

# time lbs_eeprom >b

real    0m1.478s
user    0m0.476s
sys     0m0.912s

Thats a nice, unexpected side effect :-)


--- wireless-testing.orig/drivers/net/wireless/libertas/cmd.c
+++ wireless-testing/drivers/net/wireless/libertas/cmd.c
@@ -970,27 +970,6 @@
 	return 0;
 }
 
-static int lbs_cmd_802_11_eeprom_access(struct cmd_ds_command *cmd,
-					void *pdata_buf)
-{
-	struct lbs_ioctl_regrdwr *ea = pdata_buf;
-
-	lbs_deb_enter(LBS_DEB_CMD);
-
-	cmd->command = cpu_to_le16(CMD_802_11_EEPROM_ACCESS);
-	cmd->size = cpu_to_le16(sizeof(struct cmd_ds_802_11_eeprom_access) +
-				S_DS_GEN);
-	cmd->result = 0;
-
-	cmd->params.rdeeprom.action = cpu_to_le16(ea->action);
-	cmd->params.rdeeprom.offset = cpu_to_le16(ea->offset);
-	cmd->params.rdeeprom.bytecount = cpu_to_le16(ea->NOB);
-	cmd->params.rdeeprom.value = 0;
-
-	lbs_deb_leave(LBS_DEB_CMD);
-	return 0;
-}
-
 static int lbs_cmd_bt_access(struct cmd_ds_command *cmd,
 			       u16 cmd_action, void *pdata_buf)
 {
@@ -1421,10 +1400,6 @@
 		ret = lbs_cmd_80211_ad_hoc_stop(cmdptr);
 		break;
 
-	case CMD_802_11_EEPROM_ACCESS:
-		ret = lbs_cmd_802_11_eeprom_access(cmdptr, pdata_buf);
-		break;
-
 	case CMD_802_11_SET_AFC:
 	case CMD_802_11_GET_AFC:
 
--- wireless-testing.orig/drivers/net/wireless/libertas/cmdresp.c
+++ wireless-testing/drivers/net/wireless/libertas/cmdresp.c
@@ -210,31 +210,6 @@
 	return 0;
 }
 
-static int lbs_ret_802_11_eeprom_access(struct lbs_private *priv,
-				  struct cmd_ds_command *resp)
-{
-	struct lbs_ioctl_regrdwr *pbuf;
-	pbuf = (struct lbs_ioctl_regrdwr *) priv->prdeeprom;
-
-	lbs_deb_enter_args(LBS_DEB_CMD, "len %d",
-	       le16_to_cpu(resp->params.rdeeprom.bytecount));
-	if (pbuf->NOB < le16_to_cpu(resp->params.rdeeprom.bytecount)) {
-		pbuf->NOB = 0;
-		lbs_deb_cmd("EEPROM read length too big\n");
-		return -1;
-	}
-	pbuf->NOB = le16_to_cpu(resp->params.rdeeprom.bytecount);
-	if (pbuf->NOB > 0) {
-
-		memcpy(&pbuf->value, (u8 *) & resp->params.rdeeprom.value,
-		       le16_to_cpu(resp->params.rdeeprom.bytecount));
-		lbs_deb_hex(LBS_DEB_CMD, "EEPROM", (char *)&pbuf->value,
-			le16_to_cpu(resp->params.rdeeprom.bytecount));
-	}
-	lbs_deb_leave(LBS_DEB_CMD);
-	return 0;
-}
-
 static int lbs_ret_802_11_bcn_ctrl(struct lbs_private * priv,
 					struct cmd_ds_command *resp)
 {
@@ -320,10 +295,6 @@
 		ret = lbs_ret_80211_ad_hoc_stop(priv);
 		break;
 
-	case CMD_RET(CMD_802_11_EEPROM_ACCESS):
-		ret = lbs_ret_802_11_eeprom_access(priv, resp);
-		break;
-
 	case CMD_RET(CMD_802_11D_DOMAIN_INFO):
 		ret = lbs_ret_802_11d_domain_info(resp);
 		break;
--- wireless-testing.orig/drivers/net/wireless/libertas/ethtool.c
+++ wireless-testing/drivers/net/wireless/libertas/ethtool.c
@@ -48,61 +48,28 @@
                                   struct ethtool_eeprom *eeprom, u8 * bytes)
 {
 	struct lbs_private *priv = (struct lbs_private *) dev->priv;
-	struct lbs_ioctl_regrdwr regctrl;
-	char *ptr;
+	struct cmd_ds_802_11_eeprom_access cmd;
 	int ret;
 
-	regctrl.action = 0;
-	regctrl.offset = eeprom->offset;
-	regctrl.NOB = eeprom->len;
-
-	if (eeprom->offset + eeprom->len > LBS_EEPROM_LEN)
-		return -EINVAL;
-
-//      mutex_lock(&priv->mutex);
-
-	priv->prdeeprom = kmalloc(eeprom->len+sizeof(regctrl), GFP_KERNEL);
-	if (!priv->prdeeprom)
-		return -ENOMEM;
-	memcpy(priv->prdeeprom, &regctrl, sizeof(regctrl));
-
-	/* +14 is for action, offset, and NOB in
-	 * response */
-	lbs_deb_ethtool("action:%d offset: %x NOB: %02x\n",
-	       regctrl.action, regctrl.offset, regctrl.NOB);
-
-	ret = lbs_prepare_and_send_command(priv,
-				    CMD_802_11_EEPROM_ACCESS,
-				    regctrl.action,
-				    CMD_OPTION_WAITFORRSP, 0,
-				    &regctrl);
+	lbs_deb_enter(LBS_DEB_ETHTOOL);
 
-	if (ret) {
-		if (priv->prdeeprom)
-			kfree(priv->prdeeprom);
-		goto done;
+	if (eeprom->offset + eeprom->len > LBS_EEPROM_LEN ||
+	    eeprom->len > LBS_EEPROM_READ_LEN) {
+		ret = -EINVAL;
+		goto out;
 	}
 
-	mdelay(10);
-
-	ptr = (char *)priv->prdeeprom;
-
-	/* skip the command header, but include the "value" u32 variable */
-	ptr = ptr + sizeof(struct lbs_ioctl_regrdwr) - 4;
-
-	/*
-	 * Return the result back to the user
-	 */
-	memcpy(bytes, ptr, eeprom->len);
-
-	if (priv->prdeeprom)
-		kfree(priv->prdeeprom);
-//	mutex_unlock(&priv->mutex);
-
-	ret = 0;
+	cmd.hdr.size = cpu_to_le16(sizeof(struct cmd_ds_802_11_eeprom_access) -
+		LBS_EEPROM_READ_LEN + eeprom->len);
+	cmd.action = cpu_to_le16(CMD_ACT_GET);
+	cmd.offset = cpu_to_le16(eeprom->offset);
+	cmd.len    = cpu_to_le16(eeprom->len);
+	ret = lbs_cmd_with_response(priv, CMD_802_11_EEPROM_ACCESS, &cmd);
+	if (!ret)
+		memcpy(bytes, cmd.value, eeprom->len);
 
-done:
-	lbs_deb_enter_args(LBS_DEB_ETHTOOL, "ret %d", ret);
+out:
+	lbs_deb_leave_args(LBS_DEB_ETHTOOL, "ret %d", ret);
         return ret;
 }
 
--- wireless-testing.orig/drivers/net/wireless/libertas/hostcmd.h
+++ wireless-testing/drivers/net/wireless/libertas/hostcmd.h
@@ -592,12 +592,13 @@
 } __attribute__ ((packed));
 
 struct cmd_ds_802_11_eeprom_access {
+	struct cmd_header hdr;
 	__le16 action;
-
-	/* multiple 4 */
 	__le16 offset;
-	__le16 bytecount;
-	u8 value;
+	__le16 len;
+	/* firmware says it returns a maximum of 20 bytes */
+#define LBS_EEPROM_READ_LEN 20
+	u8 value[LBS_EEPROM_READ_LEN];
 } __attribute__ ((packed));
 
 struct cmd_ds_802_11_tpc_cfg {
@@ -722,7 +723,6 @@
 		struct cmd_ds_mac_reg_access macreg;
 		struct cmd_ds_bbp_reg_access bbpreg;
 		struct cmd_ds_rf_reg_access rfreg;
-		struct cmd_ds_802_11_eeprom_access rdeeprom;
 
 		struct cmd_ds_802_11d_domain_info domaininfo;
 		struct cmd_ds_802_11d_domain_info domaininforesp;
--- wireless-testing.orig/drivers/net/wireless/libertas/wext.h
+++ wireless-testing/drivers/net/wireless/libertas/wext.h
@@ -4,17 +4,6 @@
 #ifndef	_LBS_WEXT_H_
 #define	_LBS_WEXT_H_
 
-/** lbs_ioctl_regrdwr */
-struct lbs_ioctl_regrdwr {
-	/** Which register to access */
-	u16 whichreg;
-	/** Read or Write */
-	u16 action;
-	u32 offset;
-	u16 NOB;
-	u32 value;
-};
-
 extern struct iw_handler_def lbs_handler_def;
 extern struct iw_handler_def mesh_handler_def;
 
--- wireless-testing.orig/drivers/net/wireless/libertas/dev.h
+++ wireless-testing/drivers/net/wireless/libertas/dev.h
@@ -310,7 +310,6 @@
 	u32 enable11d;
 
 	/**	MISCELLANEOUS */
-	u8 *prdeeprom;
 	struct lbs_offset_value offsetvalue;
 
 	u32 monitormode;
