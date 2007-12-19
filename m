Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from pmac.infradead.org ([90.155.92.200]:40762 "EHLO
	pmac.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752630AbXLSQKB (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 19 Dec 2007 11:10:01 -0500
Subject: [PATCH 122/48] libertas: reduce explicit references to priv->cur_cmd->cmdbuf
From: David Woodhouse <dwmw2@infradead.org>
In-Reply-To: <libertas-12345@shinybook.infradead.org>
To: John Linville <linville@tuxdriver.com>
Cc: Dan Williams <dcbw@redhat.com>, libertas-dev@lists.infradead.org,
	linux-wireless@vger.kernel.org
Message-Id: <E1J50u2-00020W-IG@pmac.infradead.org> (sfid-20071219_161008_559114_3AAB71DA)
Date: Wed, 19 Dec 2007 15:32:10 +0000
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Date: Mon, 17 Dec 2007 15:12:49 -0500

We have a local variable 'resp' which we use for this. So use it,
instead of typing the whole thing.

In preparation for actually using priv->upld_buf for the responses
instead...

Signed-off-by: David Woodhouse <dwmw2@infradead.org>
---
 drivers/net/wireless/libertas/cmdresp.c |    8 ++++----
 1 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/net/wireless/libertas/cmdresp.c b/drivers/net/wireless/libertas/cmdresp.c
index 8f9eda4..d305e98 100644
--- a/drivers/net/wireless/libertas/cmdresp.c
+++ b/drivers/net/wireless/libertas/cmdresp.c
@@ -639,10 +639,10 @@ int lbs_process_rx_command(struct lbs_private *priv)
 		goto done;
 	}
 
-	curcmd = le16_to_cpu(priv->cur_cmd->cmdbuf->command);
-
 	resp = priv->cur_cmd->cmdbuf;
 
+	curcmd = le16_to_cpu(resp->command);
+
 	respcmd = le16_to_cpu(resp->command);
 	result = le16_to_cpu(resp->result);
 
@@ -650,9 +650,9 @@ int lbs_process_rx_command(struct lbs_private *priv)
 		     respcmd, le16_to_cpu(resp->seqnum), priv->upld_len, jiffies);
 	lbs_deb_hex(LBS_DEB_HOST, "CMD_RESP", (void *) resp, priv->upld_len);
 
-	if (resp->seqnum != priv->cur_cmd->cmdbuf->seqnum) {
+	if (resp->seqnum != resp->seqnum) {
 		lbs_pr_info("Received CMD_RESP with invalid sequence %d (expected %d)\n",
-			    le16_to_cpu(resp->seqnum), le16_to_cpu(priv->cur_cmd->cmdbuf->seqnum));
+			    le16_to_cpu(resp->seqnum), le16_to_cpu(resp->seqnum));
 		spin_unlock_irqrestore(&priv->driver_lock, flags);
 		ret = -1;
 		goto done;
-- 
1.5.3.4

