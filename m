Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:9214 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756520AbaCEMLE (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 5 Mar 2014 07:11:04 -0500
From: Stanislaw Gruszka <sgruszka@redhat.com>
To: linux-wireless@vger.kernel.org
Cc: Pedro Francisco <pedrogfrancisco@gmail.com>
Subject: [RFC/RFT 3/9] iwlegacy: use CMD_COPY_PKT on il_send_scan_abort
Date: Wed,  5 Mar 2014 13:13:28 +0100
Message-Id: <1394021614-11514-4-git-send-email-sgruszka@redhat.com> (sfid-20140305_131108_311779_218BFADD)
In-Reply-To: <1394021614-11514-1-git-send-email-sgruszka@redhat.com>
References: <1394021614-11514-1-git-send-email-sgruszka@redhat.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Signed-off-by: Stanislaw Gruszka <sgruszka@redhat.com>
---
 drivers/net/wireless/iwlegacy/common.c | 15 ++++++++++-----
 1 file changed, 10 insertions(+), 5 deletions(-)

diff --git a/drivers/net/wireless/iwlegacy/common.c b/drivers/net/wireless/iwlegacy/common.c
index 31b9623..0661a5b 100644
--- a/drivers/net/wireless/iwlegacy/common.c
+++ b/drivers/net/wireless/iwlegacy/common.c
@@ -1271,9 +1271,14 @@ il_send_scan_abort(struct il_priv *il)
 	struct il_rx_pkt *pkt;
 	struct il_host_cmd cmd = {
 		.id = C_SCAN_ABORT,
-		.flags = CMD_WANT_SKB,
+		.flags = CMD_COPY_PKT,
 	};
 
+	pkt = kmalloc(sizeof(*pkt), GFP_KERNEL);
+	if (!pkt)
+		return -ENOMEM;
+	cmd.pkt_ptr = pkt;
+
 	/* Exit instantly with error when device is not ready
 	 * to receive scan abort command or it does not perform
 	 * hardware scan currently */
@@ -1282,13 +1287,12 @@ il_send_scan_abort(struct il_priv *il)
 	    !test_bit(S_SCAN_HW, &il->status) ||
 	    test_bit(S_FW_ERROR, &il->status) ||
 	    test_bit(S_EXIT_PENDING, &il->status))
-		return -EIO;
+		goto out;
 
 	ret = il_send_cmd_sync(il, &cmd);
 	if (ret)
-		return ret;
+		goto out;
 
-	pkt = (struct il_rx_pkt *)cmd.reply_page;
 	if (pkt->u.status != CAN_ABORT_STATUS) {
 		/* The scan abort will return 1 for success or
 		 * 2 for "failure".  A failure condition can be
@@ -1300,7 +1304,8 @@ il_send_scan_abort(struct il_priv *il)
 		ret = -EIO;
 	}
 
-	il_free_pages(il, cmd.reply_page);
+out:
+	kfree(pkt);
 	return ret;
 }
 
-- 
1.7.11.7

