Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga09.intel.com ([134.134.136.24]:63460 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755710Ab2FFKHu (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 6 Jun 2012 06:07:50 -0400
From: Samuel Ortiz <sameo@linux.intel.com>
To: "John W. Linville" <linville@tuxdriver.com>
Cc: Lauro Ramos Venancio <lauro.venancio@openbossa.org>,
	Aloisio Almeida Jr <aloisio.almeida@openbossa.org>,
	Ilan Elias <ilane@ti.com>, linux-wireless@vger.kernel.org,
	linux-nfc@lists.01.org, Samuel Ortiz <sameo@linux.intel.com>
Subject: [PATCH 20/29] NFC: Add passive initiator data for pn533
Date: Wed,  6 Jun 2012 12:16:37 +0200
Message-Id: <1338977806-30279-21-git-send-email-sameo@linux.intel.com> (sfid-20120606_120753_903012_B84C2303)
In-Reply-To: <1338977806-30279-1-git-send-email-sameo@linux.intel.com>
References: <1338977806-30279-1-git-send-email-sameo@linux.intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

When trying to enable a DEP link as a passive initiator, pn533 needs to
provide the polling request command payload.

Signed-off-by: Samuel Ortiz <sameo@linux.intel.com>
---
 drivers/nfc/pn533.c |   23 ++++++++++++++++++-----
 1 files changed, 18 insertions(+), 5 deletions(-)

diff --git a/drivers/nfc/pn533.c b/drivers/nfc/pn533.c
index d976344..806ab3d 100644
--- a/drivers/nfc/pn533.c
+++ b/drivers/nfc/pn533.c
@@ -256,7 +256,7 @@ struct pn533_cmd_jump_dep {
 	u8 active;
 	u8 baud;
 	u8 next;
-	u8 gt[];
+	u8 data[];
 } __packed;
 
 struct pn533_cmd_jump_dep_response {
@@ -1582,12 +1582,14 @@ static int pn533_in_dep_link_up_complete(struct pn533 *dev, void *arg,
 	return 0;
 }
 
+#define PASSIVE_DATA_LEN 5
 static int pn533_dep_link_up(struct nfc_dev *nfc_dev, struct nfc_target *target,
 			     u8 comm_mode, u8* gb, size_t gb_len)
 {
 	struct pn533 *dev = nfc_get_drvdata(nfc_dev);
 	struct pn533_cmd_jump_dep *cmd;
-	u8 cmd_len;
+	u8 cmd_len, *data_ptr;
+	u8 passive_data[PASSIVE_DATA_LEN] = {0x00, 0xff, 0xff, 0x00, 0x3};
 	int rc;
 
 	nfc_dev_dbg(&dev->interface->dev, "%s", __func__);
@@ -1605,6 +1607,9 @@ static int pn533_dep_link_up(struct nfc_dev *nfc_dev, struct nfc_target *target,
 	}
 
 	cmd_len = sizeof(struct pn533_cmd_jump_dep) + gb_len;
+	if (comm_mode == NFC_COMM_PASSIVE)
+		cmd_len += PASSIVE_DATA_LEN;
+
 	cmd = kzalloc(cmd_len, GFP_KERNEL);
 	if (cmd == NULL)
 		return -ENOMEM;
@@ -1612,10 +1617,18 @@ static int pn533_dep_link_up(struct nfc_dev *nfc_dev, struct nfc_target *target,
 	pn533_tx_frame_init(dev->out_frame, PN533_CMD_IN_JUMP_FOR_DEP);
 
 	cmd->active = !comm_mode;
-	cmd->baud = 0;
+	cmd->next = 0;
+	cmd->baud = 2;
+	data_ptr = cmd->data;
+	if (comm_mode == NFC_COMM_PASSIVE && cmd->baud > 0) {
+		memcpy(data_ptr, passive_data, PASSIVE_DATA_LEN);
+		cmd->next |= 1;
+		data_ptr += PASSIVE_DATA_LEN;
+	}
+
 	if (gb != NULL && gb_len > 0) {
-		cmd->next = 4; /* We have some Gi */
-		memcpy(cmd->gt, gb, gb_len);
+		cmd->next |= 4; /* We have some Gi */
+		memcpy(data_ptr, gb, gb_len);
 	} else {
 		cmd->next = 0;
 	}
-- 
1.7.9.1

