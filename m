Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:38712 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755539AbaCEMLJ (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 5 Mar 2014 07:11:09 -0500
From: Stanislaw Gruszka <sgruszka@redhat.com>
To: linux-wireless@vger.kernel.org
Cc: Pedro Francisco <pedrogfrancisco@gmail.com>
Subject: [RFC/RFT 5/9] iwlegacy: use CMD_COPY_PKT on il_send_remove_station
Date: Wed,  5 Mar 2014 13:13:30 +0100
Message-Id: <1394021614-11514-6-git-send-email-sgruszka@redhat.com> (sfid-20140305_131114_757953_B7DB7779)
In-Reply-To: <1394021614-11514-1-git-send-email-sgruszka@redhat.com>
References: <1394021614-11514-1-git-send-email-sgruszka@redhat.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Signed-off-by: Stanislaw Gruszka <sgruszka@redhat.com>
---
 drivers/net/wireless/iwlegacy/common.c | 17 +++++++++--------
 1 file changed, 9 insertions(+), 8 deletions(-)

diff --git a/drivers/net/wireless/iwlegacy/common.c b/drivers/net/wireless/iwlegacy/common.c
index 2778bdf..92979e0 100644
--- a/drivers/net/wireless/iwlegacy/common.c
+++ b/drivers/net/wireless/iwlegacy/common.c
@@ -2107,29 +2107,29 @@ il_send_remove_station(struct il_priv *il, const u8 * addr, int sta_id,
 {
 	struct il_rx_pkt *pkt;
 	int ret;
-
 	unsigned long flags_spin;
 	struct il_rem_sta_cmd rm_sta_cmd;
 
 	struct il_host_cmd cmd = {
 		.id = C_REM_STA,
 		.len = sizeof(struct il_rem_sta_cmd),
-		.flags = CMD_SYNC,
+		.flags = CMD_SYNC | CMD_COPY_PKT,
 		.data = &rm_sta_cmd,
 	};
 
+	pkt = kmalloc(sizeof(*pkt), GFP_KERNEL);
+	if (!pkt)
+		return -ENOMEM;
+	cmd.pkt_ptr = pkt;
+
 	memset(&rm_sta_cmd, 0, sizeof(rm_sta_cmd));
 	rm_sta_cmd.num_sta = 1;
 	memcpy(&rm_sta_cmd.addr, addr, ETH_ALEN);
 
-	cmd.flags |= CMD_WANT_SKB;
-
 	ret = il_send_cmd(il, &cmd);
-
 	if (ret)
-		return ret;
+		goto out;
 
-	pkt = (struct il_rx_pkt *)cmd.reply_page;
 	if (pkt->hdr.flags & IL_CMD_FAILED_MSK) {
 		IL_ERR("Bad return from C_REM_STA (0x%08X)\n", pkt->hdr.flags);
 		ret = -EIO;
@@ -2152,8 +2152,9 @@ il_send_remove_station(struct il_priv *il, const u8 * addr, int sta_id,
 			break;
 		}
 	}
-	il_free_pages(il, cmd.reply_page);
 
+out:
+	kfree(pkt);
 	return ret;
 }
 
-- 
1.7.11.7

