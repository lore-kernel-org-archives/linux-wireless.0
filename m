Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga11.intel.com ([192.55.52.93]:52353 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755777Ab2FFKIR (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 6 Jun 2012 06:08:17 -0400
From: Samuel Ortiz <sameo@linux.intel.com>
To: "John W. Linville" <linville@tuxdriver.com>
Cc: Lauro Ramos Venancio <lauro.venancio@openbossa.org>,
	Aloisio Almeida Jr <aloisio.almeida@openbossa.org>,
	Ilan Elias <ilane@ti.com>, linux-wireless@vger.kernel.org,
	linux-nfc@lists.01.org, Samuel Ortiz <sameo@linux.intel.com>
Subject: [PATCH 27/29] NFC: Set the proper baud rate when trying to activate pn533 targets
Date: Wed,  6 Jun 2012 12:16:44 +0200
Message-Id: <1338977806-30279-28-git-send-email-sameo@linux.intel.com> (sfid-20120606_120823_702689_ED38C827)
In-Reply-To: <1338977806-30279-1-git-send-email-sameo@linux.intel.com>
References: <1338977806-30279-1-git-send-email-sameo@linux.intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

We get the right baud rate from the last polled modulation.

Signed-off-by: Samuel Ortiz <sameo@linux.intel.com>
---
 drivers/nfc/pn533.c |   25 +++++++++++++++++++++++--
 1 files changed, 23 insertions(+), 2 deletions(-)

diff --git a/drivers/nfc/pn533.c b/drivers/nfc/pn533.c
index c9ba96c..b97e3c8 100644
--- a/drivers/nfc/pn533.c
+++ b/drivers/nfc/pn533.c
@@ -1629,6 +1629,20 @@ static int pn533_in_dep_link_up_complete(struct pn533 *dev, void *arg,
 	return 0;
 }
 
+static int pn533_mod_to_baud(struct pn533 *dev)
+{
+	switch (dev->poll_mod_curr) {
+	case PN533_POLL_MOD_106KBPS_A:
+		return 0;
+	case PN533_POLL_MOD_212KBPS_FELICA:
+		return 1;
+	case PN533_POLL_MOD_424KBPS_FELICA:
+		return 2;
+	default:
+		return -EINVAL;
+	}
+}
+
 #define PASSIVE_DATA_LEN 5
 static int pn533_dep_link_up(struct nfc_dev *nfc_dev, struct nfc_target *target,
 			     u8 comm_mode, u8* gb, size_t gb_len)
@@ -1637,7 +1651,7 @@ static int pn533_dep_link_up(struct nfc_dev *nfc_dev, struct nfc_target *target,
 	struct pn533_cmd_jump_dep *cmd;
 	u8 cmd_len, *data_ptr;
 	u8 passive_data[PASSIVE_DATA_LEN] = {0x00, 0xff, 0xff, 0x00, 0x3};
-	int rc;
+	int rc, baud;
 
 	nfc_dev_dbg(&dev->interface->dev, "%s", __func__);
 
@@ -1653,6 +1667,13 @@ static int pn533_dep_link_up(struct nfc_dev *nfc_dev, struct nfc_target *target,
 		return -EBUSY;
 	}
 
+	baud = pn533_mod_to_baud(dev);
+	if (baud < 0) {
+		nfc_dev_err(&dev->interface->dev,
+			    "Invalid curr modulation %d", dev->poll_mod_curr);
+		return baud;
+	}
+
 	cmd_len = sizeof(struct pn533_cmd_jump_dep) + gb_len;
 	if (comm_mode == NFC_COMM_PASSIVE)
 		cmd_len += PASSIVE_DATA_LEN;
@@ -1665,7 +1686,7 @@ static int pn533_dep_link_up(struct nfc_dev *nfc_dev, struct nfc_target *target,
 
 	cmd->active = !comm_mode;
 	cmd->next = 0;
-	cmd->baud = 2;
+	cmd->baud = baud;
 	data_ptr = cmd->data;
 	if (comm_mode == NFC_COMM_PASSIVE && cmd->baud > 0) {
 		memcpy(data_ptr, passive_data, PASSIVE_DATA_LEN);
-- 
1.7.9.1

