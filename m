Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga02.intel.com ([134.134.136.20]:39292 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755719Ab2FFKHz (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 6 Jun 2012 06:07:55 -0400
From: Samuel Ortiz <sameo@linux.intel.com>
To: "John W. Linville" <linville@tuxdriver.com>
Cc: Lauro Ramos Venancio <lauro.venancio@openbossa.org>,
	Aloisio Almeida Jr <aloisio.almeida@openbossa.org>,
	Ilan Elias <ilane@ti.com>, linux-wireless@vger.kernel.org,
	linux-nfc@lists.01.org, Samuel Ortiz <sameo@linux.intel.com>
Subject: [PATCH 21/29] NFC: Add type A and type F parameters for pn533 target mode
Date: Wed,  6 Jun 2012 12:16:38 +0200
Message-Id: <1338977806-30279-22-git-send-email-sameo@linux.intel.com> (sfid-20120606_120759_353127_FE188C44)
In-Reply-To: <1338977806-30279-1-git-send-email-sameo@linux.intel.com>
References: <1338977806-30279-1-git-send-email-sameo@linux.intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Without those settings several devices will not activate pn533 as a target.

Signed-off-by: Samuel Ortiz <sameo@linux.intel.com>
---
 drivers/nfc/pn533.c |   25 ++++++++++++++++++++++++-
 1 files changed, 24 insertions(+), 1 deletions(-)

diff --git a/drivers/nfc/pn533.c b/drivers/nfc/pn533.c
index 806ab3d..6e4b228 100644
--- a/drivers/nfc/pn533.c
+++ b/drivers/nfc/pn533.c
@@ -1126,6 +1126,13 @@ static int pn533_init_target_frame(struct pn533_frame *frame,
 {
 	struct pn533_cmd_init_target *cmd;
 	size_t cmd_len;
+	u8 felica_params[18] = {0x1, 0xfe, /* DEP */
+				0x0, 0x0, 0x0, 0x0, 0x0, 0x0, /* random */
+				0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0,
+				0xff, 0xff}; /* System code */
+	u8 mifare_params[6] = {0x1, 0x1, /* SENS_RES */
+			       0x0, 0x0, 0x0,
+			       0x40}; /* SEL_RES for DEP */
 
 	cmd_len = sizeof(struct pn533_cmd_init_target) + gb_len + 1;
 	cmd = kzalloc(cmd_len, GFP_KERNEL);
@@ -1136,17 +1143,33 @@ static int pn533_init_target_frame(struct pn533_frame *frame,
 
 	/* DEP support only */
 	cmd->mode |= PN533_INIT_TARGET_DEP;
-	get_random_bytes(cmd->nfcid3, 10);
+
+	/* Felica params */
+	memcpy(cmd->felica, felica_params, 18);
+	get_random_bytes(cmd->felica + 2, 6);
+
+	/* NFCID3 */
+	memset(cmd->nfcid3, 0, 10);
+	memcpy(cmd->nfcid3, cmd->felica, 8);
+
+	/* MIFARE params */
+	memcpy(cmd->mifare, mifare_params, 6);
+
+	/* General bytes */
 	cmd->gb_len = gb_len;
 	memcpy(cmd->gb, gb, gb_len);
+
 	/* Len Tk */
 	cmd->gb[gb_len] = 0;
 
 	memcpy(PN533_FRAME_CMD_PARAMS_PTR(frame), cmd, cmd_len);
+
 	frame->datalen += cmd_len;
 
 	pn533_tx_frame_finish(frame);
 
+	kfree(cmd);
+
 	return 0;
 }
 
-- 
1.7.9.1

