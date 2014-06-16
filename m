Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from sabertooth02.qualcomm.com ([65.197.215.38]:4183 "EHLO
	sabertooth02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755607AbaFPQi1 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 16 Jun 2014 12:38:27 -0400
From: Vladimir Kondratiev <qca_vkondrat@qca.qualcomm.com>
To: "John W . Linville" <linville@tuxdriver.com>
CC: Vladimir Kondratiev <qca_vkondrat@qca.qualcomm.com>,
	<linux-wireless@vger.kernel.org>, <wil6210@qca.qualcomm.com>
Subject: [PATCH 09/25] wil6210: BACK: track last dropped SSN
Date: Mon, 16 Jun 2014 19:37:07 +0300
Message-ID: <1402936643-31819-10-git-send-email-qca_vkondrat@qca.qualcomm.com> (sfid-20140616_190457_221210_BD4D48D0)
In-Reply-To: <1402936643-31819-1-git-send-email-qca_vkondrat@qca.qualcomm.com>
References: <1402936643-31819-1-git-send-email-qca_vkondrat@qca.qualcomm.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Track and print on debugfs

Signed-off-by: Vladimir Kondratiev <qca_vkondrat@qca.qualcomm.com>
---
 drivers/net/wireless/ath/wil6210/debugfs.c    | 2 +-
 drivers/net/wireless/ath/wil6210/rx_reorder.c | 1 +
 drivers/net/wireless/ath/wil6210/wil6210.h    | 1 +
 3 files changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/net/wireless/ath/wil6210/debugfs.c b/drivers/net/wireless/ath/wil6210/debugfs.c
index 9c11023..3c3abb6 100644
--- a/drivers/net/wireless/ath/wil6210/debugfs.c
+++ b/drivers/net/wireless/ath/wil6210/debugfs.c
@@ -745,7 +745,7 @@ static void wil_print_rxtid(struct seq_file *s, struct wil_tid_ampdu_rx *r)
 		else
 			seq_printf(s, "%c", r->reorder_buf[i] ? '*' : '_');
 	}
-	seq_puts(s, "]\n");
+	seq_printf(s, "] last drop 0x%03x\n", r->ssn_last_drop);
 }
 
 static int wil_sta_debugfs_show(struct seq_file *s, void *data)
diff --git a/drivers/net/wireless/ath/wil6210/rx_reorder.c b/drivers/net/wireless/ath/wil6210/rx_reorder.c
index 747ae12..180ca47 100644
--- a/drivers/net/wireless/ath/wil6210/rx_reorder.c
+++ b/drivers/net/wireless/ath/wil6210/rx_reorder.c
@@ -116,6 +116,7 @@ void wil_rx_reorder(struct wil6210_priv *wil, struct sk_buff *skb)
 
 	/* frame with out of date sequence number */
 	if (seq_less(seq, r->head_seq_num)) {
+		r->ssn_last_drop = seq;
 		dev_kfree_skb(skb);
 		goto out;
 	}
diff --git a/drivers/net/wireless/ath/wil6210/wil6210.h b/drivers/net/wireless/ath/wil6210/wil6210.h
index ede4c9f..4cbb8ce 100644
--- a/drivers/net/wireless/ath/wil6210/wil6210.h
+++ b/drivers/net/wireless/ath/wil6210/wil6210.h
@@ -304,6 +304,7 @@ struct wil_tid_ampdu_rx {
 	u16 ssn;
 	u16 buf_size;
 	u16 timeout;
+	u16 ssn_last_drop;
 	u8 dialog_token;
 	bool first_time; /* is it 1-st time this buffer used? */
 };
-- 
1.9.1

