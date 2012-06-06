Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga09.intel.com ([134.134.136.24]:16003 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755486Ab2FFKHD (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 6 Jun 2012 06:07:03 -0400
From: Samuel Ortiz <sameo@linux.intel.com>
To: "John W. Linville" <linville@tuxdriver.com>
Cc: Lauro Ramos Venancio <lauro.venancio@openbossa.org>,
	Aloisio Almeida Jr <aloisio.almeida@openbossa.org>,
	Ilan Elias <ilane@ti.com>, linux-wireless@vger.kernel.org,
	linux-nfc@lists.01.org, Samuel Ortiz <sameo@linux.intel.com>
Subject: [PATCH 08/29] NFC: Implement pn533 target mode polling loop
Date: Wed,  6 Jun 2012 12:16:25 +0200
Message-Id: <1338977806-30279-9-git-send-email-sameo@linux.intel.com> (sfid-20120606_120712_731095_4DE74FF2)
In-Reply-To: <1338977806-30279-1-git-send-email-sameo@linux.intel.com>
References: <1338977806-30279-1-git-send-email-sameo@linux.intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

We only want to support p2p target mode for now, no host card emulation.

Signed-off-by: Samuel Ortiz <sameo@linux.intel.com>
---
 drivers/nfc/pn533.c |  109 ++++++++++++++++++++++++++++++++++++++++++++++++--
 1 files changed, 104 insertions(+), 5 deletions(-)

diff --git a/drivers/nfc/pn533.c b/drivers/nfc/pn533.c
index 38a523c..605a08a 100644
--- a/drivers/nfc/pn533.c
+++ b/drivers/nfc/pn533.c
@@ -74,6 +74,8 @@ MODULE_DEVICE_TABLE(usb, pn533_table);
 #define PN533_CMD_IN_RELEASE 0x52
 #define PN533_CMD_IN_JUMP_FOR_DEP 0x56
 
+#define PN533_CMD_TG_INIT_AS_TARGET 0x8c
+
 #define PN533_CMD_RESPONSE(cmd) (cmd + 1)
 
 /* PN533 Return codes */
@@ -253,6 +255,25 @@ struct pn533_cmd_jump_dep_response {
 	u8 gt[];
 } __packed;
 
+
+/* PN533_TG_INIT_AS_TARGET */
+#define PN533_INIT_TARGET_PASSIVE 0x1
+#define PN533_INIT_TARGET_DEP 0x2
+
+struct pn533_cmd_init_target {
+	u8 mode;
+	u8 mifare[6];
+	u8 felica[18];
+	u8 nfcid3[10];
+	u8 gb_len;
+	u8 gb[];
+} __packed;
+
+struct pn533_cmd_init_target_response {
+	u8 mode;
+	u8 cmd[];
+} __packed;
+
 struct pn533 {
 	struct usb_device *udev;
 	struct usb_interface *interface;
@@ -1078,11 +1099,88 @@ stop_poll:
 	return 0;
 }
 
-static int pn533_init_target(struct nfc_dev *nfc_dev, u32 protocols)
+static int pn533_init_target_frame(struct pn533_frame *frame,
+				   u8 *gb, size_t gb_len)
 {
+	struct pn533_cmd_init_target *cmd;
+	size_t cmd_len;
+
+	cmd_len = sizeof(struct pn533_cmd_init_target) + gb_len + 1;
+	cmd = kzalloc(cmd_len, GFP_KERNEL);
+	if (cmd == NULL)
+		return -ENOMEM;
+
+	pn533_tx_frame_init(frame, PN533_CMD_TG_INIT_AS_TARGET);
+
+	/* DEP support only */
+	cmd->mode |= PN533_INIT_TARGET_DEP;
+	get_random_bytes(cmd->nfcid3, 10);
+	cmd->gb_len = gb_len;
+	memcpy(cmd->gb, gb, gb_len);
+	/* Len Tk */
+	cmd->gb[gb_len] = 0;
+
+	memcpy(PN533_FRAME_CMD_PARAMS_PTR(frame), cmd, cmd_len);
+	frame->datalen += cmd_len;
+
+	pn533_tx_frame_finish(frame);
+
 	return 0;
 }
 
+static int pn533_init_target_complete(struct pn533 *dev, void *arg,
+				      u8 *params, int params_len)
+{
+	struct pn533_cmd_init_target_response *resp;
+
+	nfc_dev_dbg(&dev->interface->dev, "%s", __func__);
+
+	if (params_len < 0) {
+		nfc_dev_err(&dev->interface->dev,
+			    "Error %d when starting as a target",
+			    params_len);
+
+		return params_len;
+	}
+
+	resp = (struct pn533_cmd_init_target_response *) params;
+
+	nfc_dev_dbg(&dev->interface->dev, "Target mode 0x%x\n", resp->mode);
+
+	return 0;
+}
+
+static int pn533_init_target(struct nfc_dev *nfc_dev, u32 protocols)
+{
+	struct pn533 *dev = nfc_get_drvdata(nfc_dev);
+	u8 *gb;
+	size_t gb_len;
+	int rc;
+
+	pn533_poll_reset_mod_list(dev);
+
+	gb = nfc_get_local_general_bytes(nfc_dev, &gb_len);
+	if (gb == NULL)
+		return -ENOMEM;
+
+	rc = pn533_init_target_frame(dev->out_frame, gb, gb_len);
+	if (rc < 0)
+		return rc;
+
+	rc = pn533_send_cmd_frame_async(dev, dev->out_frame, dev->in_frame,
+					dev->in_maxlen,
+					pn533_init_target_complete,
+					NULL, GFP_KERNEL);
+
+	if (rc)
+		nfc_dev_err(&dev->interface->dev,
+			    "Error %d when trying to initiate as a target", rc);
+
+	dev->poll_mod_count++;
+
+	return rc;
+}
+
 static int pn533_start_im_poll(struct nfc_dev *nfc_dev, u32 protocols)
 {
 	struct pn533 *dev = nfc_get_drvdata(nfc_dev);
@@ -1146,12 +1244,13 @@ static int pn533_start_poll(struct nfc_dev *nfc_dev,
 		return -EBUSY;
 	}
 
-	if (!tm_protocols)
+	if (im_protocols)
 		return pn533_start_im_poll(nfc_dev, im_protocols);
-	else if (!im_protocols)
+
+	if (tm_protocols)
 		return pn533_init_target(nfc_dev, tm_protocols);
-	else
-		return -EINVAL;
+
+	return -EINVAL;
 }
 
 static void pn533_stop_poll(struct nfc_dev *nfc_dev)
-- 
1.7.9.1

