Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.dev.rtsoft.ru ([213.79.90.226]:54156 "EHLO
        mail.dev.rtsoft.ru" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751628AbcL1RmI (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 28 Dec 2016 12:42:08 -0500
From: Andrey Rusalin <arusalin@dev.rtsoft.ru>
To: lauro.venancio@openbossa.org, aloisio.almeida@openbossa.org,
        sameo@linux.intel.com, michael.thalmeier@hale.at,
        linux-wireless@vger.kernel.org, linux-nfc@lists.01.org
Cc: Andrey Rusalin <arusalin@dev.rtsoft.ru>
Subject: [PATCH 2/3] NFC: pn533: improve cmd queue handling
Date: Wed, 28 Dec 2016 20:10:58 +0300
Message-Id: <1482945059-12249-3-git-send-email-arusalin@dev.rtsoft.ru> (sfid-20161228_184212_027937_E0D5DBBF)
In-Reply-To: <1482945059-12249-1-git-send-email-arusalin@dev.rtsoft.ru>
References: <1482945059-12249-1-git-send-email-arusalin@dev.rtsoft.ru>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Make sure cmd is set before a frame is passed to the transport layer for
sending. In addition pn533_send_async_complete checks if cmd is set before
accessing its members.

Signed-off-by: Michael Thalmeier <michael.thalmeier@hale.at>

Rework a little bit changes in pn532_send_async_complete.

Signed-off-by: Andrey Rusalin <arusalin@dev.rtsoft.ru>
---
 drivers/nfc/pn533/pn533.c | 40 +++++++++++++++++++++++++++-------------
 1 file changed, 27 insertions(+), 13 deletions(-)

diff --git a/drivers/nfc/pn533/pn533.c b/drivers/nfc/pn533/pn533.c
index 2f817b3..c67150f 100644
--- a/drivers/nfc/pn533/pn533.c
+++ b/drivers/nfc/pn533/pn533.c
@@ -383,14 +383,18 @@ static void pn533_build_cmd_frame(struct pn533 *dev, u8 cmd_code,
 static int pn533_send_async_complete(struct pn533 *dev)
 {
 	struct pn533_cmd *cmd = dev->cmd;
-	int status = cmd->status;
+	struct sk_buff *resp;
+	int status, rc = 0;
 
-	struct sk_buff *req = cmd->req;
-	struct sk_buff *resp = cmd->resp;
+	if (!cmd) {
+		dev_dbg(dev->dev, "%s: cmd not set\n", __func__);
+		goto done;
+	}
 
-	int rc;
+	dev_kfree_skb(cmd->req);
 
-	dev_kfree_skb(req);
+	status = cmd->status;
+	resp = cmd->resp;
 
 	if (status < 0) {
 		rc = cmd->complete_cb(dev, cmd->complete_cb_context,
@@ -399,8 +403,14 @@ static int pn533_send_async_complete(struct pn533 *dev)
 		goto done;
 	}
 
-	skb_pull(resp, dev->ops->rx_header_len);
-	skb_trim(resp, resp->len - dev->ops->rx_tail_len);
+	/* when no response is set we got interrupted */
+	if (!resp)
+		resp = ERR_PTR(-EINTR);
+
+	if (!IS_ERR(resp)) {
+		skb_pull(resp, dev->ops->rx_header_len);
+		skb_trim(resp, resp->len - dev->ops->rx_tail_len);
+	}
 
 	rc = cmd->complete_cb(dev, cmd->complete_cb_context, resp);
 
@@ -434,12 +444,14 @@ static int __pn533_send_async(struct pn533 *dev, u8 cmd_code,
 	mutex_lock(&dev->cmd_lock);
 
 	if (!dev->cmd_pending) {
+		dev->cmd = cmd;
 		rc = dev->phy_ops->send_frame(dev, req);
-		if (rc)
+		if (rc) {
+			dev->cmd = NULL;
 			goto error;
+		}
 
 		dev->cmd_pending = 1;
-		dev->cmd = cmd;
 		goto unlock;
 	}
 
@@ -511,11 +523,12 @@ static int pn533_send_cmd_direct_async(struct pn533 *dev, u8 cmd_code,
 
 	pn533_build_cmd_frame(dev, cmd_code, req);
 
+	dev->cmd = cmd;
 	rc = dev->phy_ops->send_frame(dev, req);
-	if (rc < 0)
+	if (rc < 0) {
+		dev->cmd = NULL;
 		kfree(cmd);
-	else
-		dev->cmd = cmd;
+	}
 
 	return rc;
 }
@@ -550,14 +563,15 @@ static void pn533_wq_cmd(struct work_struct *work)
 
 	mutex_unlock(&dev->cmd_lock);
 
+	dev->cmd = cmd;
 	rc = dev->phy_ops->send_frame(dev, cmd->req);
 	if (rc < 0) {
+		dev->cmd = NULL;
 		dev_kfree_skb(cmd->req);
 		kfree(cmd);
 		return;
 	}
 
-	dev->cmd = cmd;
 }
 
 struct pn533_sync_cmd_response {
-- 
2.7.4
