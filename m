Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga11.intel.com ([192.55.52.93]:3685 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757091Ab1LNPiq (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 14 Dec 2011 10:38:46 -0500
From: Samuel Ortiz <sameo@linux.intel.com>
To: "John W. Linville" <linville@tuxdriver.com>
Cc: Lauro Ramos Venancio <lauro.venancio@openbossa.org>,
	Aloisio Almeida Jr <aloisio.almeida@openbossa.org>,
	linux-wireless@vger.kernel.org,
	Samuel Ortiz <sameo@linux.intel.com>
Subject: [PATCH 7/8] NFC: DEP link hook implementation for pn533
Date: Wed, 14 Dec 2011 16:43:11 +0100
Message-Id: <1323877392-20567-8-git-send-email-sameo@linux.intel.com> (sfid-20111214_163848_509770_0DDB7879)
In-Reply-To: <1323877392-20567-1-git-send-email-sameo@linux.intel.com>
References: <1323877392-20567-1-git-send-email-sameo@linux.intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Signed-off-by: Samuel Ortiz <sameo@linux.intel.com>
---
 drivers/nfc/pn533.c |  159 +++++++++++++++++++++++++++++++++++++++++++++++++++
 1 files changed, 159 insertions(+), 0 deletions(-)

diff --git a/drivers/nfc/pn533.c b/drivers/nfc/pn533.c
index dccd965..b8b6c2a 100644
--- a/drivers/nfc/pn533.c
+++ b/drivers/nfc/pn533.c
@@ -72,6 +72,7 @@ MODULE_DEVICE_TABLE(usb, pn533_table);
 #define PN533_CMD_IN_LIST_PASSIVE_TARGET 0x4A
 #define PN533_CMD_IN_ATR 0x50
 #define PN533_CMD_IN_RELEASE 0x52
+#define PN533_CMD_IN_JUMP_FOR_DEP 0x56
 
 #define PN533_CMD_RESPONSE(cmd) (cmd + 1)
 
@@ -231,6 +232,26 @@ struct pn533_cmd_activate_response {
 	u8 gt[];
 } __packed;
 
+/* PN533_CMD_IN_JUMP_FOR_DEP */
+struct pn533_cmd_jump_dep {
+	u8 active;
+	u8 baud;
+	u8 next;
+	u8 gt[];
+} __packed;
+
+struct pn533_cmd_jump_dep_response {
+	u8 status;
+	u8 tg;
+	u8 nfcid3t[10];
+	u8 didt;
+	u8 bst;
+	u8 brt;
+	u8 to;
+	u8 ppt;
+	/* optional */
+	u8 gt[];
+} __packed;
 
 struct pn533 {
 	struct usb_device *udev;
@@ -1244,6 +1265,142 @@ static void pn533_deactivate_target(struct nfc_dev *nfc_dev, u32 target_idx)
 	return;
 }
 
+
+static int pn533_in_dep_link_up_complete(struct pn533 *dev, void *arg,
+						u8 *params, int params_len)
+{
+	struct pn533_cmd_jump_dep *cmd;
+	struct pn533_cmd_jump_dep_response *resp;
+	struct nfc_target nfc_target;
+	u8 target_gt_len;
+	int rc;
+
+	if (params_len == -ENOENT) {
+		nfc_dev_dbg(&dev->interface->dev, "");
+		return 0;
+	}
+
+	if (params_len < 0) {
+		nfc_dev_err(&dev->interface->dev,
+				"Error %d when bringing DEP link up",
+								params_len);
+		return 0;
+	}
+
+	if (dev->tgt_available_prots &&
+	    !(dev->tgt_available_prots & (1 << NFC_PROTO_NFC_DEP))) {
+		nfc_dev_err(&dev->interface->dev,
+			"The target does not support DEP");
+		return -EINVAL;
+	}
+
+	resp = (struct pn533_cmd_jump_dep_response *) params;
+	cmd = (struct pn533_cmd_jump_dep *) arg;
+	rc = resp->status & PN533_CMD_RET_MASK;
+	if (rc != PN533_CMD_RET_SUCCESS) {
+		nfc_dev_err(&dev->interface->dev,
+				"Bringing DEP link up failed %d", rc);
+		return 0;
+	}
+
+	if (!dev->tgt_available_prots) {
+		nfc_dev_dbg(&dev->interface->dev, "Creating new target");
+
+		nfc_target.supported_protocols = NFC_PROTO_NFC_DEP_MASK;
+		rc = nfc_targets_found(dev->nfc_dev, &nfc_target, 1);
+		if (rc)
+			return 0;
+
+		dev->tgt_available_prots = 0;
+	}
+
+	dev->tgt_active_prot = NFC_PROTO_NFC_DEP;
+
+	/* ATR_RES general bytes are located at offset 17 */
+	target_gt_len = PN533_FRAME_CMD_PARAMS_LEN(dev->in_frame) - 17;
+	rc = nfc_set_remote_general_bytes(dev->nfc_dev,
+						resp->gt, target_gt_len);
+	if (rc == 0)
+		rc = nfc_dep_link_is_up(dev->nfc_dev,
+						dev->nfc_dev->targets[0].idx,
+						!cmd->active, NFC_RF_INITIATOR);
+
+	return 0;
+}
+
+static int pn533_dep_link_up(struct nfc_dev *nfc_dev, int target_idx,
+						u8 comm_mode, u8 rf_mode)
+{
+	struct pn533 *dev = nfc_get_drvdata(nfc_dev);
+	struct pn533_cmd_jump_dep *cmd;
+	u8 cmd_len, local_gt_len, *local_gt;
+	int rc;
+
+	nfc_dev_dbg(&dev->interface->dev, "%s", __func__);
+
+	if (rf_mode == NFC_RF_TARGET) {
+		nfc_dev_err(&dev->interface->dev, "Target mode not supported");
+		return -EOPNOTSUPP;
+	}
+
+
+	if (dev->poll_mod_count) {
+		nfc_dev_err(&dev->interface->dev,
+				"Cannot bring the DEP link up while polling");
+		return -EBUSY;
+	}
+
+	if (dev->tgt_active_prot) {
+		nfc_dev_err(&dev->interface->dev,
+				"There is already an active target");
+		return -EBUSY;
+	}
+
+	local_gt = nfc_get_local_general_bytes(dev->nfc_dev, &local_gt_len);
+	if (local_gt_len > NFC_MAX_GT_LEN)
+		return -EINVAL;
+
+	cmd_len = sizeof(struct pn533_cmd_jump_dep) + local_gt_len;
+	cmd = kzalloc(cmd_len, GFP_KERNEL);
+	if (cmd == NULL)
+		return -ENOMEM;
+
+	pn533_tx_frame_init(dev->out_frame, PN533_CMD_IN_JUMP_FOR_DEP);
+
+	cmd->active = !comm_mode;
+	cmd->baud = 0;
+	if (local_gt != NULL) {
+		cmd->next = 4; /* We have some Gi */
+		memcpy(cmd->gt, local_gt, local_gt_len);
+	} else {
+		cmd->next = 0;
+	}
+
+	memcpy(PN533_FRAME_CMD_PARAMS_PTR(dev->out_frame), cmd, cmd_len);
+	dev->out_frame->datalen += cmd_len;
+
+	pn533_tx_frame_finish(dev->out_frame);
+
+	rc = pn533_send_cmd_frame_async(dev, dev->out_frame, dev->in_frame,
+				dev->in_maxlen,	pn533_in_dep_link_up_complete,
+				cmd, GFP_KERNEL);
+	if (rc)
+		goto out;
+
+
+out:
+	kfree(cmd);
+
+	return rc;
+}
+
+static int pn533_dep_link_down(struct nfc_dev *nfc_dev)
+{
+	pn533_deactivate_target(nfc_dev, 0);
+
+	return 0;
+}
+
 #define PN533_CMD_DATAEXCH_HEAD_LEN (sizeof(struct pn533_frame) + 3)
 #define PN533_CMD_DATAEXCH_DATA_MAXLEN 262
 
@@ -1439,6 +1596,8 @@ static int pn533_set_configuration(struct pn533 *dev, u8 cfgitem, u8 *cfgdata,
 struct nfc_ops pn533_nfc_ops = {
 	.dev_up = NULL,
 	.dev_down = NULL,
+	.dep_link_up = pn533_dep_link_up,
+	.dep_link_down = pn533_dep_link_down,
 	.start_poll = pn533_start_poll,
 	.stop_poll = pn533_stop_poll,
 	.activate_target = pn533_activate_target,
-- 
1.7.7.3

