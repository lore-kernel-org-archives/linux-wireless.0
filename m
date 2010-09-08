Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pw0-f46.google.com ([209.85.160.46]:60962 "EHLO
	mail-pw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756655Ab0IHX26 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 8 Sep 2010 19:28:58 -0400
Received: by pwi3 with SMTP id 3so277086pwi.19
        for <linux-wireless@vger.kernel.org>; Wed, 08 Sep 2010 16:28:58 -0700 (PDT)
From: Steve deRosier <steve@cozybit.com>
To: linux-wireless@vger.kernel.org, linville@tuxdriver.com
Cc: johannes@sipsolutions.net, javier@cozybit.com,
	Steve deRosier <steve@cozybit.com>
Subject: [PATCH] libertas_tf_usb: fix libertas_tf_usb to match structural changes in libertas_tf
Date: Wed,  8 Sep 2010 16:28:39 -0700
Message-Id: <1283988519-44671-1-git-send-email-steve@cozybit.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The development of the libertas_tf_sdio driver introduced structural
changes in libertas_tf.  Most notably, firmware loading and starting
was needed in the probe stage due to the requirement that mac80211
have the MAC address set before the starting of mac80211 in add_card.
This patch fixes libertas_tf_usb to match these structural changes
as needed.

Signed-off-by: Steve deRosier <steve@cozybit.com>
---
 drivers/net/wireless/libertas_tf/if_usb.c |  279 ++++++++++++++++++++++++++---
 drivers/net/wireless/libertas_tf/if_usb.h |    5 +
 2 files changed, 262 insertions(+), 22 deletions(-)

diff --git a/drivers/net/wireless/libertas_tf/if_usb.c b/drivers/net/wireless/libertas_tf/if_usb.c
index ba7d965..c29279f 100644
--- a/drivers/net/wireless/libertas_tf/if_usb.c
+++ b/drivers/net/wireless/libertas_tf/if_usb.c
@@ -43,6 +43,8 @@ MODULE_DEVICE_TABLE(usb, if_usb_table);
 static void if_usb_receive(struct urb *urb);
 static void if_usb_receive_fwload(struct urb *urb);
 static int if_usb_prog_firmware(struct if_usb_card *cardp);
+static int _if_usb_host_to_card(struct if_usb_card *cardp, uint8_t type,
+			       uint8_t *payload, uint16_t nb);
 static int if_usb_host_to_card(struct lbtf_private *priv, uint8_t type,
 			       uint8_t *payload, uint16_t nb);
 static int usb_tx_block(struct if_usb_card *cardp, uint8_t *payload,
@@ -50,6 +52,8 @@ static int usb_tx_block(struct if_usb_card *cardp, uint8_t *payload,
 static void if_usb_free(struct if_usb_card *cardp);
 static int if_usb_submit_rx_urb(struct if_usb_card *cardp);
 static int if_usb_reset_device(struct if_usb_card *cardp);
+static int __if_usb_submit_rx_urb(struct if_usb_card *cardp,
+				  void (*callbackfn)(struct urb *urb));
 
 /**
  *  if_usb_wrike_bulk_callback -  call back to handle URB status
@@ -97,22 +101,143 @@ static void if_usb_free(struct if_usb_card *cardp)
 	lbtf_deb_leave(LBTF_DEB_USB);
 }
 
-static void if_usb_setup_firmware(struct lbtf_private *priv)
+/**
+ *  if_usb_receive_hw_spec - read data received from the device.
+ *
+ *  @urb		pointer to struct urb
+ */
+static void if_usb_receive_cmd_response(struct urb *urb)
+{
+	struct if_usb_card *cardp = urb->context;
+	struct sk_buff *skb = cardp->rx_skb;
+	int recvlength = urb->actual_length;
+	uint8_t *recvbuff = NULL;
+	uint32_t recvtype = 0;
+	__le32 *pkt = (__le32 *)(skb->data);
+	struct cmd_ds_get_hw_spec *cmd;
+
+	lbtf_deb_enter(LBTF_DEB_USB);
+
+	if (recvlength>0) {
+		if (urb->status) {
+			lbtf_deb_usbd(&cardp->udev->dev, "RX URB failed: %d\n",
+				     urb->status);
+			kfree_skb(skb);
+			goto setup_for_next;
+		}
+
+		recvbuff = skb->data;
+		recvtype = le32_to_cpu(pkt[0]);
+		lbtf_deb_usb("Recv length = 0x%x, Recv type = 0x%X",
+					  recvlength, recvtype);
+
+		lbtf_deb_hex(LBTF_DEB_CMD, "CMD Data ", recvbuff, min_t(unsigned int, recvlength, 100));
+
+	} else if (urb->status) {
+		kfree_skb(skb);
+		lbtf_deb_leave(LBTF_DEB_USB);
+		return;
+	}
+
+	if (CMD_TYPE_REQUEST == recvtype) {
+		if (recvlength > LBS_CMD_BUFFER_SIZE) {
+			lbtf_deb_usbd(&cardp->udev->dev,
+					 "The receive buffer is too large\n");
+			kfree_skb(skb);
+			goto setup_for_next;
+		}
+
+		BUG_ON(!in_interrupt());
+
+		cmd = (struct cmd_ds_get_hw_spec *)(recvbuff + MESSAGE_HEADER_LEN);
+
+		switch (le16_to_cpu(cmd->hdr.command)) {
+			case (CMD_GET_HW_SPEC | 0x8000):
+				lbtf_deb_usb("received hw spec reponse");
+
+				/* Process cmd return */
+				cardp->fwcapinfo = le32_to_cpu(cmd->fwcapinfo);
+
+				/* The firmware release is in an interesting format: the patch
+				 * level is in the most significant nibble ... so fix that: */
+				cardp->fwrelease = le32_to_cpu(cmd->fwrelease);
+				cardp->fwrelease = (cardp->fwrelease << 8) |
+					(cardp->fwrelease >> 24 & 0xff);
+
+				printk(KERN_INFO "libertas_tf_usb: %pM, fw %u.%u.%up%u, cap 0x%08x\n",
+					cmd->permanentaddr,
+					cardp->fwrelease >> 24 & 0xff,
+					cardp->fwrelease >> 16 & 0xff,
+					cardp->fwrelease >>  8 & 0xff,
+					cardp->fwrelease       & 0xff,
+					cardp->fwcapinfo);
+				lbtf_deb_usb("GET_HW_SPEC: hardware interface 0x%x, hardware spec 0x%04x\n",
+						cmd->hwifversion, cmd->version);
+
+				memmove(cardp->hw_addr, cmd->permanentaddr, ETH_ALEN);
+
+				cardp->cmdresp = 1;
+				wake_up(&cardp->fw_wq);
+				break;
+
+			case (CMD_SET_BOOT2_VER | 0x8000):
+				lbtf_deb_usb("received boot2 ver reponse");
+				cardp->cmdresp = 1;
+				wake_up(&cardp->fw_wq);
+				break;
+
+			default:
+				lbtf_deb_usb("received unhandled cmd reponse 0x%x",
+				             le16_to_cpu(cmd->hdr.command));
+				break;
+		}
+
+		kfree_skb(skb);
+	} else {
+		lbtf_deb_usbd(&cardp->udev->dev,
+		         "libertastf: unknown command type 0x%X\n", recvtype);
+		kfree_skb(skb);
+	}
+
+
+setup_for_next:
+	if (!cardp->cmdresp)
+		__if_usb_submit_rx_urb(cardp, &if_usb_receive_cmd_response);
+	lbtf_deb_leave(LBTF_DEB_USB);
+}
+
+/**
+ *  if_usb_setup_firmware - Setup firmware by sending boot2 ver command
+ *
+ *  Returns: 0
+ */
+static void if_usb_setup_firmware(struct if_usb_card *cardp)
 {
-	struct if_usb_card *cardp = priv->card;
 	struct cmd_ds_set_boot2_ver b2_cmd;
 
 	lbtf_deb_enter(LBTF_DEB_USB);
 
-	if_usb_submit_rx_urb(cardp);
-	b2_cmd.hdr.size = cpu_to_le16(sizeof(b2_cmd));
+	if (__if_usb_submit_rx_urb(cardp, &if_usb_receive_cmd_response) < 0) {
+		lbtf_deb_usbd(&cardp->udev->dev, "URB submission is failed\n");
+	}
+
+	memset(&b2_cmd, 0, sizeof(struct cmd_ds_set_boot2_ver));
+
+	b2_cmd.hdr.command = cpu_to_le16(CMD_SET_BOOT2_VER);
+	b2_cmd.hdr.size = cpu_to_le16(sizeof(struct cmd_ds_set_boot2_ver));
 	b2_cmd.action = 0;
 	b2_cmd.version = cardp->boot2_version;
 
-	if (lbtf_cmd_with_response(priv, CMD_SET_BOOT2_VER, &b2_cmd))
-		lbtf_deb_usb("Setting boot2 version failed\n");
+	cardp->cmdresp = 0;
+
+	_if_usb_host_to_card(cardp, MVMS_CMD, (uint8_t *)&b2_cmd, sizeof(b2_cmd));
+
+	wait_event_interruptible_timeout(cardp->fw_wq, cardp->cmdresp, 5 * (HZ));
+
+	usb_kill_urb(cardp->rx_urb);
 
 	lbtf_deb_leave(LBTF_DEB_USB);
+	return;
 }
 
 static void if_usb_fw_timeo(unsigned long priv)
@@ -132,6 +257,69 @@ static void if_usb_fw_timeo(unsigned long priv)
 }
 
 /**
+ *  if_usb_issue_hw_spec_command - Issue hw spec command.
+ *
+ *  Returns: 0
+ */
+static int if_usb_issue_hw_spec_command(struct if_usb_card *cardp)
+{
+	struct cmd_ds_get_hw_spec cmd;
+	lbtf_deb_enter(LBTF_DEB_USB);
+
+	memset(&cmd, 0, sizeof(struct cmd_ds_get_hw_spec));
+	cmd.hdr.command = cpu_to_le16(CMD_GET_HW_SPEC);
+	cmd.hdr.size = cpu_to_le16(sizeof(struct cmd_ds_get_hw_spec));
+	memcpy(cmd.permanentaddr, cardp->hw_addr, ETH_ALEN);
+
+	_if_usb_host_to_card(cardp, MVMS_CMD, (uint8_t *)&cmd, sizeof(cmd));
+
+	lbtf_deb_leave(LBTF_DEB_USB);
+	return 0;
+}
+
+/**
+ *  if_usb_update_hw_spec: Updates the hardware details.
+ *
+ *  @card    	A pointer to card structure
+ *
+ *  Returns: 0 on success, error on failure
+ */
+int if_usb_update_hw_spec(struct if_usb_card *cardp)
+{
+	int ret = -1;
+
+	lbtf_deb_enter(LBTF_DEB_USB);
+
+	if (__if_usb_submit_rx_urb(cardp, &if_usb_receive_cmd_response) < 0) {
+		lbtf_deb_usbd(&cardp->udev->dev, "URB submission is failed\n");
+	}
+
+	/* Send and wait for the response */
+	cardp->cmdresp = 0;
+
+	/* Issue hw spec command */
+	if_usb_issue_hw_spec_command(cardp);
+
+	/* wait for command response */
+	wait_event_interruptible_timeout(cardp->fw_wq, cardp->cmdresp, 5 * (HZ));
+
+	/* Process response */
+	if (cardp->cmdresp) {
+		lbtf_deb_usb("Getting hw spec succeded\n");
+		ret = 0;
+	} else {
+		lbtf_deb_usb("Getting hw spec failed\n");
+		ret = 1;
+	}
+
+	usb_kill_urb(cardp->rx_urb);
+
+	lbtf_deb_leave(LBTF_DEB_USB);
+	return ret;
+}
+
+
+/**
  *  if_usb_probe - sets the configuration values
  *
  *  @ifnum	interface number
@@ -148,6 +336,7 @@ static int if_usb_probe(struct usb_interface *intf,
 	struct lbtf_private *priv;
 	struct if_usb_card *cardp;
 	int i;
+	int ret = 0;
 
 	lbtf_deb_enter(LBTF_DEB_USB);
 	udev = interface_to_usbdev(intf);
@@ -224,7 +413,33 @@ static int if_usb_probe(struct usb_interface *intf,
 		goto dealloc;
 	}
 
-	priv = lbtf_add_card(cardp, &udev->dev);
+	cardp->boot2_version = udev->descriptor.bcdDevice;
+
+	usb_get_dev(udev);
+	usb_set_intfdata(intf, cardp);
+
+	/* Upload firmware */
+	lbtf_deb_usbd(&udev->dev, "Going to upload fw...");
+	if (if_usb_prog_firmware(cardp))
+		goto dealloc;
+
+	if_usb_setup_firmware(cardp);
+
+	/*
+	 * We need to get the hw spec here because we must have the
+	 * MAC address before we call lbtf_add_card
+	 *
+	 * Read priv address from HW
+	 */
+	memset(cardp->hw_addr, 0xff, ETH_ALEN);
+
+	ret = if_usb_update_hw_spec(cardp);
+	if (ret) {
+		ret = -1;
+		pr_err("Error fetching MAC address from hardware.");
+	}
+
+	priv = lbtf_add_card(cardp, &udev->dev, cardp->hw_addr);
 	if (!priv)
 		goto dealloc;
 
@@ -233,10 +448,11 @@ static int if_usb_probe(struct usb_interface *intf,
 	priv->hw_host_to_card = if_usb_host_to_card;
 	priv->hw_prog_firmware = if_usb_prog_firmware;
 	priv->hw_reset_device = if_usb_reset_device;
-	cardp->boot2_version = udev->descriptor.bcdDevice;
 
-	usb_get_dev(udev);
-	usb_set_intfdata(intf, cardp);
+	cardp->priv->fw_ready = 1;
+
+	/* "turn on" rx */
+	if_usb_submit_rx_urb(cardp);
 
 	return 0;
 
@@ -387,9 +603,11 @@ static int usb_tx_block(struct if_usb_card *cardp, uint8_t *payload,
 
 	lbtf_deb_enter(LBTF_DEB_USB);
 	/* check if device is removed */
-	if (cardp->priv->surpriseremoved) {
-		lbtf_deb_usbd(&cardp->udev->dev, "Device removed\n");
-		goto tx_ret;
+	if (cardp->priv) {
+		if (cardp->priv->surpriseremoved) {
+			lbtf_deb_usbd(&cardp->udev->dev, "Device removed\n");
+			goto tx_ret;
+		}
 	}
 
 	if (data)
@@ -713,19 +931,18 @@ setup_for_next:
 }
 
 /**
- *  if_usb_host_to_card -  Download data to the device
+ *  _if_usb_host_to_card -  Download data to the device
  *
- *  @priv		pointer to struct lbtf_private structure
+ *  @cardp		pointer to struct if_usb_card structure
  *  @type		type of data
  *  @buf		pointer to data buffer
  *  @len		number of bytes
  *
  *  Returns: 0 on success, nonzero otherwise
  */
-static int if_usb_host_to_card(struct lbtf_private *priv, uint8_t type,
+static int _if_usb_host_to_card(struct if_usb_card *cardp, uint8_t type,
 			       uint8_t *payload, uint16_t nb)
 {
-	struct if_usb_card *cardp = priv->card;
 	u8 data = 0;
 
 	lbtf_deb_usbd(&cardp->udev->dev, "*** type = %u\n", type);
@@ -745,6 +962,22 @@ static int if_usb_host_to_card(struct lbtf_private *priv, uint8_t type,
 }
 
 /**
+ *  if_usb_host_to_card -  Download data to the device
+ *
+ *  @priv		pointer to struct lbtf_private structure
+ *  @type		type of data
+ *  @buf		pointer to data buffer
+ *  @len		number of bytes
+ *
+ *  Returns: 0 on success, nonzero otherwise
+ */
+static int if_usb_host_to_card(struct lbtf_private *priv, uint8_t type,
+			       uint8_t *payload, uint16_t nb)
+{
+	return _if_usb_host_to_card(priv->card, type, payload, nb);
+}
+
+/**
  *  if_usb_issue_boot_command - Issue boot command to Boot2.
  *
  *  @ivalue   1 boots from FW by USB-Download, 2 boots from FW in EEPROM.
@@ -879,8 +1112,11 @@ restart:
 	if_usb_send_fw_pkt(cardp);
 
 	/* ... and wait for the process to complete */
-	wait_event_interruptible(cardp->fw_wq, cardp->priv->surpriseremoved ||
-					       cardp->fwdnldover);
+	if (cardp->priv)
+		wait_event_interruptible(cardp->fw_wq, cardp->priv->surpriseremoved ||
+							   cardp->fwdnldover);
+	else
+		wait_event_interruptible(cardp->fw_wq, cardp->fwdnldover);
 
 	del_timer_sync(&cardp->fw_timeout);
 	usb_kill_urb(cardp->rx_urb);
@@ -897,14 +1133,13 @@ restart:
 		goto release_fw;
 	}
 
-	cardp->priv->fw_ready = 1;
+	if (cardp->priv)
+		cardp->priv->fw_ready = 1;
 
  release_fw:
 	release_firmware(cardp->fw);
 	cardp->fw = NULL;
 
-	if_usb_setup_firmware(cardp->priv);
-
  done:
 	lbtf_deb_leave_args(LBTF_DEB_USB, "ret %d", ret);
 	return ret;
diff --git a/drivers/net/wireless/libertas_tf/if_usb.h b/drivers/net/wireless/libertas_tf/if_usb.h
index 6fa5b3f..ea44a0e 100644
--- a/drivers/net/wireless/libertas_tf/if_usb.h
+++ b/drivers/net/wireless/libertas_tf/if_usb.h
@@ -70,6 +70,11 @@ struct if_usb_card {
 	uint8_t fwfinalblk;
 
 	__le16 boot2_version;
+
+	int cmdresp;
+	u8 hw_addr[ETH_ALEN];
+	u32 fwrelease;
+	u32 fwcapinfo;
 };
 
 /** fwheader */
-- 
1.7.0

