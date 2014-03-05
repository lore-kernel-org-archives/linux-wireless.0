Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:41353 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755539AbaCEMLI (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 5 Mar 2014 07:11:08 -0500
From: Stanislaw Gruszka <sgruszka@redhat.com>
To: linux-wireless@vger.kernel.org
Cc: Pedro Francisco <pedrogfrancisco@gmail.com>
Subject: [RFC/RFT 4/9] iwlegacy: use CMD_COPY_PKT on il_send_add_sta
Date: Wed,  5 Mar 2014 13:13:29 +0100
Message-Id: <1394021614-11514-5-git-send-email-sgruszka@redhat.com> (sfid-20140305_131111_575589_0DDD4F51)
In-Reply-To: <1394021614-11514-1-git-send-email-sgruszka@redhat.com>
References: <1394021614-11514-1-git-send-email-sgruszka@redhat.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Signed-off-by: Stanislaw Gruszka <sgruszka@redhat.com>
---
 drivers/net/wireless/iwlegacy/common.c | 25 +++++++++++++------------
 1 file changed, 13 insertions(+), 12 deletions(-)

diff --git a/drivers/net/wireless/iwlegacy/common.c b/drivers/net/wireless/iwlegacy/common.c
index 0661a5b..2778bdf 100644
--- a/drivers/net/wireless/iwlegacy/common.c
+++ b/drivers/net/wireless/iwlegacy/common.c
@@ -1847,8 +1847,8 @@ il_add_sta_callback(struct il_priv *il, struct il_device_cmd *cmd,
 int
 il_send_add_sta(struct il_priv *il, struct il_addsta_cmd *sta, u8 flags)
 {
-	struct il_rx_pkt *pkt = NULL;
-	int ret = 0;
+	struct il_rx_pkt *pkt;
+	int ret;
 	u8 data[sizeof(*sta)];
 	struct il_host_cmd cmd = {
 		.id = C_ADD_STA,
@@ -1860,25 +1860,26 @@ il_send_add_sta(struct il_priv *il, struct il_addsta_cmd *sta, u8 flags)
 	D_INFO("Adding sta %u (%pM) %ssynchronously\n", sta_id, sta->sta.addr,
 	       flags & CMD_ASYNC ? "a" : "");
 
-	if (flags & CMD_ASYNC)
+	if (flags & CMD_ASYNC) {
 		cmd.callback = il_add_sta_callback;
-	else {
-		cmd.flags |= CMD_WANT_SKB;
-		might_sleep();
+	} else {
+		/* SYNC command mean we allow to sleep */
+		pkt = kmalloc(sizeof(*pkt), GFP_KERNEL);
+		if (!pkt)
+			return -ENOMEM;
+		cmd.pkt_ptr = pkt;
+		cmd.flags |= CMD_COPY_PKT;
 	}
 
 	cmd.len = il->ops->build_addsta_hcmd(sta, data);
 	ret = il_send_cmd(il, &cmd);
 
-	if (ret || (flags & CMD_ASYNC))
+	if (flags & CMD_ASYNC)
 		return ret;
 
-	if (ret == 0) {
-		pkt = (struct il_rx_pkt *)cmd.reply_page;
+	if (ret == 0)
 		ret = il_process_add_sta_resp(il, sta, pkt, true);
-	}
-	il_free_pages(il, cmd.reply_page);
-
+	kfree(pkt);
 	return ret;
 }
 EXPORT_SYMBOL(il_send_add_sta);
-- 
1.7.11.7

