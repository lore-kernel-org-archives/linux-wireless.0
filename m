Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from dakia2.marvell.com ([65.219.4.35]:46340 "EHLO
	dakia2.marvell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752339Ab1ANTfE (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 14 Jan 2011 14:35:04 -0500
From: Bing Zhao <bzhao@marvell.com>
To: linux-wireless@vger.kernel.org
Cc: "John W. Linville" <linville@tuxdriver.com>,
	Johannes Berg <johannes@sipsolutions.net>,
	Amitkumar Karwar <akarwar@marvell.com>,
	Kiran Divekar <dkiran@marvell.com>,
	Frank Huang <frankh@marvell.com>, Bing Zhao <bzhao@marvell.com>
Subject: [PATCH] mwifiex: remove duplicated NULL checks
Date: Fri, 14 Jan 2011 11:36:00 -0800
Message-Id: <1295033760-31108-1-git-send-email-bzhao@marvell.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Amitkumar Karwar <akarwar@marvell.com>

Some functions have unnecessory NULL check for an input parameter
because the caller to those functions is already checking the parameter
for NULL before calling them.

Signed-off-by: Amitkumar Karwar <akarwar@marvell.com>
---
 drivers/net/wireless/mwifiex/cmdevt.c    |   25 -------------------------
 drivers/net/wireless/mwifiex/scan.c      |    5 +----
 drivers/net/wireless/mwifiex/sta_ioctl.c |    6 ------
 drivers/net/wireless/mwifiex/util.c      |    2 --
 4 files changed, 1 insertions(+), 37 deletions(-)

diff --git a/drivers/net/wireless/mwifiex/cmdevt.c b/drivers/net/wireless/mwifiex/cmdevt.c
index 60aeea4..5c512d5 100644
--- a/drivers/net/wireless/mwifiex/cmdevt.c
+++ b/drivers/net/wireless/mwifiex/cmdevt.c
@@ -41,11 +41,6 @@ mwifiex_init_cmd_node(struct mwifiex_private *priv,
 {
 	ENTER();
 
-	if (cmd_node == NULL) {
-		LEAVE();
-		return;
-	}
-
 	cmd_node->priv = priv;
 	cmd_node->cmd_oid = cmd_oid;
 	cmd_node->ioctl_buf = ioctl_buf;
@@ -74,11 +69,6 @@ mwifiex_get_cmd_node(struct mwifiex_adapter *adapter)
 
 	ENTER();
 
-	if (adapter == NULL) {
-		LEAVE();
-		return NULL;
-	}
-
 	spin_lock_irqsave(&adapter->cmd_free_q_lock, flags);
 	if (list_empty(&adapter->cmd_free_q)) {
 		PRINTM(MERROR,
@@ -112,10 +102,6 @@ mwifiex_clean_cmd_node(struct mwifiex_adapter *adapter,
 {
 	ENTER();
 
-	if (cmd_node == NULL) {
-		LEAVE();
-		return;
-	}
 	cmd_node->cmd_oid = 0;
 	cmd_node->cmd_flag = 0;
 	cmd_node->ioctl_buf = NULL;
@@ -720,11 +706,6 @@ mwifiex_insert_cmd_to_pending_q(struct mwifiex_adapter *adapter,
 
 	ENTER();
 
-	if (cmd_node == NULL) {
-		PRINTM(MERROR, "QUEUE_CMD: cmd_node is NULL\n");
-		goto done;
-	}
-
 	host_cmd = (struct host_cmd_ds_command *) (cmd_node->cmd_buf->buffer +
 					       cmd_node->cmd_buf->data_offset);
 	if (host_cmd == NULL) {
@@ -782,12 +763,6 @@ mwifiex_exec_next_cmd(struct mwifiex_adapter *adapter)
 
 	ENTER();
 
-	/* Sanity test */
-	if (adapter == NULL) {
-		PRINTM(MERROR, "EXEC_NEXT_CMD: adapter is NULL\n");
-		ret = MWIFIEX_STATUS_FAILURE;
-		goto done;
-	}
 	/* Check if already in processing */
 	if (adapter->curr_cmd) {
 		PRINTM(MERROR,
diff --git a/drivers/net/wireless/mwifiex/scan.c b/drivers/net/wireless/mwifiex/scan.c
index df4a77c..6da0612 100644
--- a/drivers/net/wireless/mwifiex/scan.c
+++ b/drivers/net/wireless/mwifiex/scan.c
@@ -3162,13 +3162,10 @@ mwifiex_queue_scan_cmd(struct mwifiex_private *priv,
 
 	ENTER();
 
-	if (cmd_node == NULL)
-		goto done;
-
 	spin_lock_irqsave(&adapter->scan_pending_q_lock, flags);
 	list_add_tail(&cmd_node->list, &adapter->scan_pending_q);
 	spin_unlock_irqrestore(&adapter->scan_pending_q_lock, flags);
-done:
+
 	LEAVE();
 }
 
diff --git a/drivers/net/wireless/mwifiex/sta_ioctl.c b/drivers/net/wireless/mwifiex/sta_ioctl.c
index 04a6154..f4fcb74 100644
--- a/drivers/net/wireless/mwifiex/sta_ioctl.c
+++ b/drivers/net/wireless/mwifiex/sta_ioctl.c
@@ -42,12 +42,6 @@ mwifiex_ioctl(struct mwifiex_adapter *adapter,
 
 	ENTER();
 
-	if (ioctl_req == NULL) {
-		PRINTM(MERROR, "%s: IOCTL request buffer is NULL\n", __func__);
-		ret = MWIFIEX_STATUS_FAILURE;
-		goto exit;
-	}
-
 	if (ioctl_req->action == MWIFIEX_ACT_CANCEL) {
 		mwifiex_cancel_pending_ioctl(adapter, ioctl_req);
 		ret = MWIFIEX_STATUS_SUCCESS;
diff --git a/drivers/net/wireless/mwifiex/util.c b/drivers/net/wireless/mwifiex/util.c
index 7e1bc9b..c16f5f5 100644
--- a/drivers/net/wireless/mwifiex/util.c
+++ b/drivers/net/wireless/mwifiex/util.c
@@ -546,8 +546,6 @@ mwifiex_process_ioctl_resp(struct mwifiex_private *priv,
 {
 	ENTER();
 
-	if (priv == NULL)
-		return;
 	switch (req->req_id) {
 	case MWIFIEX_IOCTL_GET_INFO:
 		mwifiex_ioctl_get_info_resp(priv,
-- 
1.7.0.2

