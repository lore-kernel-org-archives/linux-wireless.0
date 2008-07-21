Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wf-out-1314.google.com ([209.85.200.171]:4491 "EHLO
	wf-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752067AbYGUSr6 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 21 Jul 2008 14:47:58 -0400
Received: by wf-out-1314.google.com with SMTP id 27so1733329wfd.4
        for <linux-wireless@vger.kernel.org>; Mon, 21 Jul 2008 11:47:57 -0700 (PDT)
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org, libertas-dev@lists.infradead.org
From: Brian Cavagnolo <brian@cozybit.com>
Date: Mon, 21 Jul 2008 11:02:46 -0700
Subject: [PATCH 1/3 RESEND] libertas: support boot commands to write persistent firmware and bootloader
Message-ID: <4884d9dc.1e078e0a.4736.4124@mx.google.com> (sfid-20080721_204800_936954_5F22C4B9)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Add locking and non-locking versions of if_usb_prog_firmware to support
programming firmware after and before driver bring-up respectively.  Add more
suitable error codes for firmware programming process.  Add capability checks
for persistent features before attempting to use them.

Based on patches from Brajesh Dave and Priyank Singh.

Signed-off-by: Brian Cavagnolo <brian@cozybit.com>
---
 drivers/net/wireless/libertas/cmd.c    |   21 +++++-
 drivers/net/wireless/libertas/defs.h   |    6 ++-
 drivers/net/wireless/libertas/if_usb.c |  112 ++++++++++++++++++++++++++------
 drivers/net/wireless/libertas/if_usb.h |    5 ++
 4 files changed, 119 insertions(+), 25 deletions(-)

diff --git a/drivers/net/wireless/libertas/cmd.c b/drivers/net/wireless/libertas/cmd.c
index 75427e6..af5fd70 100644
--- a/drivers/net/wireless/libertas/cmd.c
+++ b/drivers/net/wireless/libertas/cmd.c
@@ -1033,9 +1033,9 @@ int lbs_mesh_access(struct lbs_private *priv, uint16_t cmd_action,
 	return ret;
 }
 
-int lbs_mesh_config_send(struct lbs_private *priv,
-			 struct cmd_ds_mesh_config *cmd,
-			 uint16_t action, uint16_t type)
+static int __lbs_mesh_config_send(struct lbs_private *priv,
+				  struct cmd_ds_mesh_config *cmd,
+				  uint16_t action, uint16_t type)
 {
 	int ret;
 
@@ -1054,6 +1054,19 @@ int lbs_mesh_config_send(struct lbs_private *priv,
 	return ret;
 }
 
+int lbs_mesh_config_send(struct lbs_private *priv,
+			 struct cmd_ds_mesh_config *cmd,
+			 uint16_t action, uint16_t type)
+{
+	int ret;
+
+	if (!(priv->fwcapinfo & FW_CAPINFO_PERSISTENT_CONFIG))
+		return -EOPNOTSUPP;
+
+	ret = __lbs_mesh_config_send(priv, cmd, action, type);
+	return ret;
+}
+
 /* This function is the CMD_MESH_CONFIG legacy function.  It only handles the
  * START and STOP actions.  The extended actions supported by CMD_MESH_CONFIG
  * are all handled by preparing a struct cmd_ds_mesh_config and passing it to
@@ -1095,7 +1108,7 @@ int lbs_mesh_config(struct lbs_private *priv, uint16_t action, uint16_t chan)
 		    action, priv->mesh_tlv, chan,
 		    escape_essid(priv->mesh_ssid, priv->mesh_ssid_len));
 
-	return lbs_mesh_config_send(priv, &cmd, action, priv->mesh_tlv);
+	return __lbs_mesh_config_send(priv, &cmd, action, priv->mesh_tlv);
 }
 
 static int lbs_cmd_bcn_ctrl(struct lbs_private * priv,
diff --git a/drivers/net/wireless/libertas/defs.h b/drivers/net/wireless/libertas/defs.h
index 12e6875..4b2428a 100644
--- a/drivers/net/wireless/libertas/defs.h
+++ b/drivers/net/wireless/libertas/defs.h
@@ -243,6 +243,9 @@ static inline void lbs_deb_hex(unsigned int grp, const char *prompt, u8 *buf, in
 
 #define	CMD_F_HOSTCMD		(1 << 0)
 #define FW_CAPINFO_WPA  	(1 << 0)
+#define FW_CAPINFO_FIRMWARE_UPGRADE	(1 << 13)
+#define FW_CAPINFO_BOOT2_UPGRADE	(1<<14)
+#define FW_CAPINFO_PERSISTENT_CONFIG	(1<<15)
 
 #define KEY_LEN_WPA_AES			16
 #define KEY_LEN_WPA_TKIP		32
@@ -316,7 +319,8 @@ enum PS_STATE {
 enum DNLD_STATE {
 	DNLD_RES_RECEIVED,
 	DNLD_DATA_SENT,
-	DNLD_CMD_SENT
+	DNLD_CMD_SENT,
+	DNLD_BOOTCMD_SENT,
 };
 
 /** LBS_MEDIA_STATE */
diff --git a/drivers/net/wireless/libertas/if_usb.c b/drivers/net/wireless/libertas/if_usb.c
index a8b4abc..764b285 100644
--- a/drivers/net/wireless/libertas/if_usb.c
+++ b/drivers/net/wireless/libertas/if_usb.c
@@ -39,7 +39,10 @@ MODULE_DEVICE_TABLE(usb, if_usb_table);
 
 static void if_usb_receive(struct urb *urb);
 static void if_usb_receive_fwload(struct urb *urb);
-static int if_usb_prog_firmware(struct if_usb_card *cardp);
+static int __if_usb_prog_firmware(struct if_usb_card *cardp,
+					const char *fwname, int cmd);
+static int if_usb_prog_firmware(struct if_usb_card *cardp,
+					const char *fwname, int cmd);
 static int if_usb_host_to_card(struct lbs_private *priv, uint8_t type,
 			       uint8_t *payload, uint16_t nb);
 static int usb_tx_block(struct if_usb_card *cardp, uint8_t *payload,
@@ -66,10 +69,10 @@ static void if_usb_write_bulk_callback(struct urb *urb)
 		lbs_deb_usb2(&urb->dev->dev, "Actual length transmitted %d\n",
 			     urb->actual_length);
 
-		/* Used for both firmware TX and regular TX.  priv isn't
-		 * valid at firmware load time.
+		/* Boot commands such as UPDATE_FW and UPDATE_BOOT2 are not
+		 * passed up to the lbs level.
 		 */
-		if (priv)
+		if (priv && priv->dnld_sent != DNLD_BOOTCMD_SENT)
 			lbs_host_to_card_done(priv);
 	} else {
 		/* print the failure status number for debug */
@@ -231,7 +234,7 @@ static int if_usb_probe(struct usb_interface *intf,
 	}
 
 	/* Upload firmware */
-	if (if_usb_prog_firmware(cardp)) {
+	if (__if_usb_prog_firmware(cardp, lbs_fw_name, BOOT_CMD_FW_BY_USB)) {
 		lbs_deb_usbd(&udev->dev, "FW upload failed\n");
 		goto err_prog_firmware;
 	}
@@ -510,7 +513,7 @@ static void if_usb_receive_fwload(struct urb *urb)
 		if (le16_to_cpu(cardp->udev->descriptor.bcdDevice) < 0x3106) {
 			kfree_skb(skb);
 			if_usb_submit_rx_urb_fwload(cardp);
-			cardp->bootcmdresp = 1;
+			cardp->bootcmdresp = BOOT_CMD_RESP_OK;
 			lbs_deb_usbd(&cardp->udev->dev,
 				     "Received valid boot command response\n");
 			return;
@@ -526,7 +529,9 @@ static void if_usb_receive_fwload(struct urb *urb)
 				lbs_pr_info("boot cmd response wrong magic number (0x%x)\n",
 					    le32_to_cpu(bootcmdresp.magic));
 			}
-		} else if (bootcmdresp.cmd != BOOT_CMD_FW_BY_USB) {
+		} else if ((bootcmdresp.cmd != BOOT_CMD_FW_BY_USB) &&
+			   (bootcmdresp.cmd != BOOT_CMD_UPDATE_FW) &&
+			   (bootcmdresp.cmd != BOOT_CMD_UPDATE_BOOT2)) {
 			lbs_pr_info("boot cmd response cmd_tag error (%d)\n",
 				    bootcmdresp.cmd);
 		} else if (bootcmdresp.result != BOOT_CMD_RESP_OK) {
@@ -564,8 +569,8 @@ static void if_usb_receive_fwload(struct urb *urb)
 
 	kfree_skb(skb);
 
-	/* reschedule timer for 200ms hence */
-	mod_timer(&cardp->fw_timeout, jiffies + (HZ/5));
+	/* Give device 5s to either write firmware to its RAM or eeprom */
+	mod_timer(&cardp->fw_timeout, jiffies + (HZ*5));
 
 	if (cardp->fwfinalblk) {
 		cardp->fwdnldover = 1;
@@ -809,7 +814,54 @@ static int check_fwfile_format(uint8_t *data, uint32_t totlen)
 }
 
 
-static int if_usb_prog_firmware(struct if_usb_card *cardp)
+/**
+*  @brief This function programs the firmware subject to cmd
+*
+*  @param cardp             the if_usb_card descriptor
+*         fwname            firmware or boot2 image file name
+*         cmd               either BOOT_CMD_FW_BY_USB, BOOT_CMD_UPDATE_FW,
+*                           or BOOT_CMD_UPDATE_BOOT2.
+*  @return     0 or error code
+*/
+static int if_usb_prog_firmware(struct if_usb_card *cardp,
+				const char *fwname, int cmd)
+{
+	struct lbs_private *priv = cardp->priv;
+	unsigned long flags, caps;
+	int ret;
+
+	caps = priv->fwcapinfo;
+	if (((cmd == BOOT_CMD_UPDATE_FW) && !(caps & FW_CAPINFO_FIRMWARE_UPGRADE)) ||
+	    ((cmd == BOOT_CMD_UPDATE_BOOT2) && !(caps & FW_CAPINFO_BOOT2_UPGRADE)))
+		return -EOPNOTSUPP;
+
+	/* Ensure main thread is idle. */
+	spin_lock_irqsave(&priv->driver_lock, flags);
+	while (priv->cur_cmd != NULL || priv->dnld_sent != DNLD_RES_RECEIVED) {
+		spin_unlock_irqrestore(&priv->driver_lock, flags);
+		if (wait_event_interruptible(priv->waitq,
+				(priv->cur_cmd == NULL &&
+				priv->dnld_sent == DNLD_RES_RECEIVED))) {
+			return -ERESTARTSYS;
+		}
+		spin_lock_irqsave(&priv->driver_lock, flags);
+	}
+	priv->dnld_sent = DNLD_BOOTCMD_SENT;
+	spin_unlock_irqrestore(&priv->driver_lock, flags);
+
+	ret = __if_usb_prog_firmware(cardp, fwname, cmd);
+
+	spin_lock_irqsave(&priv->driver_lock, flags);
+	priv->dnld_sent = DNLD_RES_RECEIVED;
+	spin_unlock_irqrestore(&priv->driver_lock, flags);
+
+	wake_up_interruptible(&priv->waitq);
+
+	return ret;
+}
+
+static int __if_usb_prog_firmware(struct if_usb_card *cardp,
+					const char *fwname, int cmd)
 {
 	int i = 0;
 	static int reset_count = 10;
@@ -817,20 +869,32 @@ static int if_usb_prog_firmware(struct if_usb_card *cardp)
 
 	lbs_deb_enter(LBS_DEB_USB);
 
-	if ((ret = request_firmware(&cardp->fw, lbs_fw_name,
-				    &cardp->udev->dev)) < 0) {
+	ret = request_firmware(&cardp->fw, fwname, &cardp->udev->dev);
+	if (ret < 0) {
 		lbs_pr_err("request_firmware() failed with %#x\n", ret);
-		lbs_pr_err("firmware %s not found\n", lbs_fw_name);
+		lbs_pr_err("firmware %s not found\n", fwname);
 		goto done;
 	}
 
-	if (check_fwfile_format(cardp->fw->data, cardp->fw->size))
+	if (check_fwfile_format(cardp->fw->data, cardp->fw->size)) {
+		ret = -EINVAL;
 		goto release_fw;
+	}
+
+	/* Cancel any pending usb business */
+	usb_kill_urb(cardp->rx_urb);
+	usb_kill_urb(cardp->tx_urb);
+
+	cardp->fwlastblksent = 0;
+	cardp->fwdnldover = 0;
+	cardp->totalbytes = 0;
+	cardp->fwfinalblk = 0;
+	cardp->bootcmdresp = 0;
 
 restart:
 	if (if_usb_submit_rx_urb_fwload(cardp) < 0) {
 		lbs_deb_usbd(&cardp->udev->dev, "URB submission is failed\n");
-		ret = -1;
+		ret = -EIO;
 		goto release_fw;
 	}
 
@@ -838,8 +902,7 @@ restart:
 	do {
 		int j = 0;
 		i++;
-		/* Issue Boot command = 1, Boot from Download-FW */
-		if_usb_issue_boot_command(cardp, BOOT_CMD_FW_BY_USB);
+		if_usb_issue_boot_command(cardp, cmd);
 		/* wait for command response */
 		do {
 			j++;
@@ -847,12 +910,21 @@ restart:
 		} while (cardp->bootcmdresp == 0 && j < 10);
 	} while (cardp->bootcmdresp == 0 && i < 5);
 
-	if (cardp->bootcmdresp <= 0) {
+	if (cardp->bootcmdresp == BOOT_CMD_RESP_NOT_SUPPORTED) {
+		/* Return to normal operation */
+		ret = -EOPNOTSUPP;
+		usb_kill_urb(cardp->rx_urb);
+		usb_kill_urb(cardp->tx_urb);
+		if (if_usb_submit_rx_urb(cardp) < 0)
+			ret = -EIO;
+		goto release_fw;
+	} else if (cardp->bootcmdresp <= 0) {
 		if (--reset_count >= 0) {
 			if_usb_reset_device(cardp);
 			goto restart;
 		}
-		return -1;
+		ret = -EIO;
+		goto release_fw;
 	}
 
 	i = 0;
@@ -882,7 +954,7 @@ restart:
 		}
 
 		lbs_pr_info("FW download failure, time = %d ms\n", i * 100);
-		ret = -1;
+		ret = -EIO;
 		goto release_fw;
 	}
 
diff --git a/drivers/net/wireless/libertas/if_usb.h b/drivers/net/wireless/libertas/if_usb.h
index 5771a83..5ba0aee 100644
--- a/drivers/net/wireless/libertas/if_usb.h
+++ b/drivers/net/wireless/libertas/if_usb.h
@@ -30,6 +30,7 @@ struct bootcmd
 
 #define BOOT_CMD_RESP_OK		0x0001
 #define BOOT_CMD_RESP_FAIL		0x0000
+#define BOOT_CMD_RESP_NOT_SUPPORTED	0x0002
 
 struct bootcmdresp
 {
@@ -50,6 +51,10 @@ struct if_usb_card {
 	uint8_t ep_in;
 	uint8_t ep_out;
 
+	/* bootcmdresp == 0 means command is pending
+	 * bootcmdresp < 0 means error
+	 * bootcmdresp > 0 is a BOOT_CMD_RESP_* from firmware
+	 */
 	int8_t bootcmdresp;
 
 	int ep_in_size;
-- 
1.5.5.3



