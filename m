Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.bugwerft.de ([46.23.86.59]:57186 "EHLO mail.bugwerft.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2388407AbeGXLFs (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 24 Jul 2018 07:05:48 -0400
From: Daniel Mack <daniel@zonque.org>
To: sameo@linux.intel.com
Cc: linux-wireless@vger.kernel.org, colin.king@canonical.com,
        shikha.singh@st.com, Daniel Mack <daniel@zonque.org>
Subject: [PATCH v3 09/11] NFC: st95hf: unify sync/async flags
Date: Tue, 24 Jul 2018 11:59:39 +0200
Message-Id: <20180724095941.25777-10-daniel@zonque.org> (sfid-20180724_120141_663911_3926265B)
In-Reply-To: <20180724095941.25777-1-daniel@zonque.org>
References: <20180724095941.25777-1-daniel@zonque.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Keep the information whether a command is asynchronous in a boolean flag
like it is done elsewhere in the code. This way, the enum can go away.
No function change intended.

Signed-off-by: Daniel Mack <daniel@zonque.org>
---
 drivers/nfc/st95hf/core.c | 38 ++++++++++++++++----------------------
 drivers/nfc/st95hf/spi.c  | 12 +++++-------
 drivers/nfc/st95hf/spi.h  |  8 +-------
 3 files changed, 22 insertions(+), 36 deletions(-)

diff --git a/drivers/nfc/st95hf/core.c b/drivers/nfc/st95hf/core.c
index 53447394666b..10321dba15dc 100644
--- a/drivers/nfc/st95hf/core.c
+++ b/drivers/nfc/st95hf/core.c
@@ -101,7 +101,7 @@ struct cmd {
 	unsigned char cmd_id;
 	unsigned char no_cmd_params;
 	unsigned char cmd_params[MAX_CMD_PARAMS];
-	enum req_type req;
+	bool is_sync;
 };
 
 struct param_list {
@@ -134,63 +134,62 @@ static const struct cmd cmd_array[] = {
 		.cmd_len = 0x2,
 		.cmd_id = ECHO_CMD,
 		.no_cmd_params = 0,
-		.req = SYNC,
+		.is_sync = true,
 	},
 	[CMD_ISO14443A_CONFIG] = {
 		.cmd_len = 0x7,
 		.cmd_id = WRITE_REGISTER_CMD,
 		.no_cmd_params = 0x4,
 		.cmd_params = {0x3A, 0x00, 0x5A, 0x04},
-		.req = SYNC,
+		.is_sync = true,
 	},
 	[CMD_ISO14443A_DEMOGAIN] = {
 		.cmd_len = 0x7,
 		.cmd_id = WRITE_REGISTER_CMD,
 		.no_cmd_params = 0x4,
 		.cmd_params = {0x68, 0x01, 0x01, 0xDF},
-		.req = SYNC,
+		.is_sync = true,
 	},
 	[CMD_ISO14443B_DEMOGAIN] = {
 		.cmd_len = 0x7,
 		.cmd_id = WRITE_REGISTER_CMD,
 		.no_cmd_params = 0x4,
 		.cmd_params = {0x68, 0x01, 0x01, 0x51},
-		.req = SYNC,
+		.is_sync = true,
 	},
 	[CMD_ISO14443A_PROTOCOL_SELECT] = {
 		.cmd_len = 0x7,
 		.cmd_id = PROTOCOL_SELECT_CMD,
 		.no_cmd_params = 0x4,
 		.cmd_params = {ISO14443A_PROTOCOL_CODE, 0x00, 0x01, 0xA0},
-		.req = SYNC,
+		.is_sync = true,
 	},
 	[CMD_ISO14443B_PROTOCOL_SELECT] = {
 		.cmd_len = 0x7,
 		.cmd_id = PROTOCOL_SELECT_CMD,
 		.no_cmd_params = 0x4,
 		.cmd_params = {ISO14443B_PROTOCOL_CODE, 0x01, 0x03, 0xFF},
-		.req = SYNC,
+		.is_sync = true,
 	},
 	[CMD_WTX_RESPONSE] = {
 		.cmd_len = 0x6,
 		.cmd_id = SEND_RECEIVE_CMD,
 		.no_cmd_params = 0x3,
 		.cmd_params = {0xF2, 0x00, TRFLAG_NFCA_STD_FRAME_CRC},
-		.req = ASYNC,
 	},
 	[CMD_FIELD_OFF] = {
 		.cmd_len = 0x5,
 		.cmd_id = PROTOCOL_SELECT_CMD,
 		.no_cmd_params = 0x2,
 		.cmd_params = {0x0, 0x0},
-		.req = SYNC,
+		.is_sync = true,
 	},
 	[CMD_ISO15693_PROTOCOL_SELECT] = {
 		.cmd_len = 0x5,
 		.cmd_id = PROTOCOL_SELECT_CMD,
 		.no_cmd_params = 0x2,
 		.cmd_params = {ISO15693_PROTOCOL_CODE, 0x0D},
-		.req = SYNC,
+		.is_sync = true,
 	},
 };
 
@@ -279,13 +278,13 @@ static int st95hf_send_recv_cmd(struct st95hf_context *st95context,
 	ret = st95hf_spi_send(&st95context->spicontext,
 			      spi_cmd_buffer,
 			      cmd_array[cmd].cmd_len,
-			      cmd_array[cmd].req);
+			      cmd_array[cmd].is_sync);
 	if (ret) {
 		dev_err(dev, "st95hf_spi_send failed with error %d\n", ret);
 		return ret;
 	}
 
-	if (cmd_array[cmd].req == SYNC && recv_res) {
+	if (cmd_array[cmd].is_sync && recv_res) {
 		unsigned char st95hf_response_arr[2];
 
 		ret = st95hf_spi_recv_response(&st95context->spicontext,
@@ -480,10 +479,8 @@ static int st95hf_send_spi_reset_sequence(struct st95hf_context *st95context)
 	int result = 0;
 	unsigned char reset_cmd = ST95HF_COMMAND_RESET;
 
-	result = st95hf_spi_send(&st95context->spicontext,
-				 &reset_cmd,
-				 ST95HF_RESET_CMD_LEN,
-				 ASYNC);
+	result = st95hf_spi_send(&st95context->spicontext, &reset_cmd,
+				 ST95HF_RESET_CMD_LEN, false);
 	if (result) {
 		dev_err(&st95context->spicontext.spidev->dev,
 			"spi reset sequence cmd error = %d", result);
@@ -947,8 +944,7 @@ static int st95hf_in_send_cmd(struct nfc_digital_dev *ddev,
 		stcontext->complete_cb_arg.rats = true;
 
 	rc = st95hf_spi_send(&stcontext->spicontext, skb->data,
-			     skb->len,
-			     ASYNC);
+			     skb->len, false);
 	if (rc) {
 		dev_err(&stcontext->nfcdev->dev,
 			"Error %d trying to perform data_exchange", rc);
@@ -1183,10 +1179,8 @@ static int st95hf_remove(struct spi_device *nfc_spi_dev)
 	mutex_unlock(&stcontext->rm_lock);
 
 	/* next reset the ST95HF controller */
-	result = st95hf_spi_send(&stcontext->spicontext,
-				 &reset_cmd,
-				 ST95HF_RESET_CMD_LEN,
-				 ASYNC);
+	result = st95hf_spi_send(&stcontext->spicontext, &reset_cmd,
+				 ST95HF_RESET_CMD_LEN, false);
 	if (result) {
 		dev_err(&spictx->spidev->dev,
 			"ST95HF reset failed in remove() err = %d\n", result);
diff --git a/drivers/nfc/st95hf/spi.c b/drivers/nfc/st95hf/spi.c
index d5894d4546b1..ef12ed67343f 100644
--- a/drivers/nfc/st95hf/spi.c
+++ b/drivers/nfc/st95hf/spi.c
@@ -23,7 +23,7 @@
 int st95hf_spi_send(struct st95hf_spi_context *spicontext,
 		    unsigned char *buffertx,
 		    int datalen,
-		    enum req_type reqtype)
+		    bool is_sync)
 {
 	struct spi_message m;
 	int result = 0;
@@ -35,12 +35,10 @@ int st95hf_spi_send(struct st95hf_spi_context *spicontext,
 
 	mutex_lock(&spicontext->spi_lock);
 
-	if (reqtype == SYNC) {
-		spicontext->req_issync = true;
+	spicontext->req_issync = is_sync;
+
+	if (is_sync)
 		reinit_completion(&spicontext->done);
-	} else {
-		spicontext->req_issync = false;
-	}
 
 	spi_message_init(&m);
 	spi_message_add_tail(&tx_transfer, &m);
@@ -52,7 +50,7 @@ int st95hf_spi_send(struct st95hf_spi_context *spicontext,
 	}
 
 	/* return for asynchronous or no-wait case */
-	if (reqtype == ASYNC) {
+	if (!is_sync) {
 		mutex_unlock(&spicontext->spi_lock);
 		return 0;
 	}
diff --git a/drivers/nfc/st95hf/spi.h b/drivers/nfc/st95hf/spi.h
index 552d220747cd..ede17eef6ab1 100644
--- a/drivers/nfc/st95hf/spi.h
+++ b/drivers/nfc/st95hf/spi.h
@@ -44,16 +44,10 @@ struct st95hf_spi_context {
 	struct mutex spi_lock;
 };
 
-/* flag to differentiate synchronous & asynchronous spi request */
-enum req_type {
-	SYNC,
-	ASYNC,
-};
-
 int st95hf_spi_send(struct st95hf_spi_context *spicontext,
 		    unsigned char *buffertx,
 		    int datalen,
-		    enum req_type reqtype);
+		    bool is_sync);
 
 int st95hf_spi_recv_response(struct st95hf_spi_context *spicontext,
 			     unsigned char *receivebuff);
-- 
2.17.1
