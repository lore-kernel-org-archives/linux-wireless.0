Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-we0-f182.google.com ([74.125.82.182]:42769 "EHLO
	mail-we0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751849AbaFXTwq (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 24 Jun 2014 15:52:46 -0400
Received: by mail-we0-f182.google.com with SMTP id q59so912710wes.27
        for <linux-wireless@vger.kernel.org>; Tue, 24 Jun 2014 12:52:45 -0700 (PDT)
From: Emmanuel Grumbach <egrumbach@gmail.com>
To: linux-wireless@vger.kernel.org
Cc: Andy Lutomirski <luto@amacapital.net>,
	Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Subject: [PATCH 12/27] iwlwifi: pcie: improve debugfs queue info
Date: Tue, 24 Jun 2014 22:52:06 +0300
Message-Id: <1403639541-4621-12-git-send-email-egrumbach@gmail.com> (sfid-20140624_215250_696757_DCBC101E)
In-Reply-To: <53A9D6CF.9040100@gmail.com>
References: <53A9D6CF.9040100@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Andy Lutomirski <luto@amacapital.net>

This adds need_update and write_actual to rx_queue and need_update
and an HCMD indicator to tx_queue.

On my card, rx_queue now looks like:

read: 181
write: 180
write_actual: 176
need_update: 0
free_count: 40
closed_rb_num: 181

tx_queue now looks like:

hwq 00: read=29 write=30 use=1 stop=0 need_update=0
hwq 01: read=0 write=0 use=1 stop=0 need_update=0
hwq 02: read=128 write=128 use=1 stop=0 need_update=0
hwq 03: read=0 write=0 use=1 stop=0 need_update=0
hwq 04: read=94 write=94 use=1 stop=0 need_update=0 HCMD
hwq 05: read=0 write=0 use=0 stop=0 need_update=0
hwq 06: read=0 write=0 use=0 stop=0 need_update=0
hwq 07: read=0 write=0 use=0 stop=0 need_update=0
hwq 08: read=0 write=0 use=0 stop=0 need_update=0
hwq 09: read=0 write=0 use=0 stop=0 need_update=0
hwq 10: read=0 write=0 use=0 stop=0 need_update=0
hwq 11: read=0 write=0 use=0 stop=0 need_update=0
hwq 12: read=0 write=0 use=0 stop=0 need_update=0
hwq 13: read=0 write=0 use=0 stop=0 need_update=0
hwq 14: read=0 write=0 use=0 stop=0 need_update=0
hwq 15: read=0 write=0 use=0 stop=0 need_update=0
hwq 16: read=0 write=0 use=0 stop=0 need_update=0
hwq 17: read=0 write=0 use=0 stop=0 need_update=0
hwq 18: read=0 write=0 use=0 stop=0 need_update=0
hwq 19: read=0 write=0 use=0 stop=0 need_update=0

This may help with debugging queue stalls.

Signed-off-by: Andy Lutomirski <luto@amacapital.net>
Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
---
 drivers/net/wireless/iwlwifi/pcie/trans.c | 10 ++++++++--
 1 file changed, 8 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/pcie/trans.c b/drivers/net/wireless/iwlwifi/pcie/trans.c
index 3ffac48..0480857 100644
--- a/drivers/net/wireless/iwlwifi/pcie/trans.c
+++ b/drivers/net/wireless/iwlwifi/pcie/trans.c
@@ -1573,10 +1573,12 @@ static ssize_t iwl_dbgfs_tx_queue_read(struct file *file,
 		txq = &trans_pcie->txq[cnt];
 		q = &txq->q;
 		pos += scnprintf(buf + pos, bufsz - pos,
-				"hwq %.2d: read=%u write=%u use=%d stop=%d\n",
+				"hwq %.2d: read=%u write=%u use=%d stop=%d need_update=%d%s\n",
 				cnt, q->read_ptr, q->write_ptr,
 				!!test_bit(cnt, trans_pcie->queue_used),
-				!!test_bit(cnt, trans_pcie->queue_stopped));
+				 !!test_bit(cnt, trans_pcie->queue_stopped),
+				 txq->need_update,
+				 (cnt == trans_pcie->cmd_queue ? " HCMD" : ""));
 	}
 	ret = simple_read_from_buffer(user_buf, count, ppos, buf, pos);
 	kfree(buf);
@@ -1598,6 +1600,10 @@ static ssize_t iwl_dbgfs_rx_queue_read(struct file *file,
 						rxq->read);
 	pos += scnprintf(buf + pos, bufsz - pos, "write: %u\n",
 						rxq->write);
+	pos += scnprintf(buf + pos, bufsz - pos, "write_actual: %u\n",
+						rxq->write_actual);
+	pos += scnprintf(buf + pos, bufsz - pos, "need_update: %d\n",
+						rxq->need_update);
 	pos += scnprintf(buf + pos, bufsz - pos, "free_count: %u\n",
 						rxq->free_count);
 	if (rxq->rb_stts) {
-- 
1.8.3.2

