Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine02.qualcomm.com ([199.106.114.251]:17835 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751976AbaLWHr6 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 23 Dec 2014 02:47:58 -0500
From: Vladimir Kondratiev <QCA_vkondrat@QCA.qualcomm.com>
Cc: Vladimir Kondratiev <QCA_vkondrat@QCA.qualcomm.com>,
	linux-wireless@vger.kernel.org, wil6210@qca.qualcomm.com
To: Kalle Valo <kvalo@qca.qualcomm.com>
Subject: [PATCH 04/22] wil6210: improve debugfs for reorder buffer
Date: Tue, 23 Dec 2014 09:47:06 +0200
Message-Id: <1419320844-23989-5-git-send-email-qca_vkondrat@qca.qualcomm.com> (sfid-20141223_084806_795808_1D482547)
In-Reply-To: <1419320844-23989-1-git-send-email-qca_vkondrat@qca.qualcomm.com>
References: <1419320844-23989-1-git-send-email-qca_vkondrat@qca.qualcomm.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

When printing debugfs for the reorder buffer, include BACK
parameters: window size and timeout

Signed-off-by: Vladimir Kondratiev <qca_vkondrat@qca.qualcomm.com>
---
 drivers/net/wireless/ath/wil6210/debugfs.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/net/wireless/ath/wil6210/debugfs.c b/drivers/net/wireless/ath/wil6210/debugfs.c
index 18f5b67..5117a02 100644
--- a/drivers/net/wireless/ath/wil6210/debugfs.c
+++ b/drivers/net/wireless/ath/wil6210/debugfs.c
@@ -1162,7 +1162,8 @@ static void wil_print_rxtid(struct seq_file *s, struct wil_tid_ampdu_rx *r)
 	int i;
 	u16 index = ((r->head_seq_num - r->ssn) & 0xfff) % r->buf_size;
 
-	seq_printf(s, "0x%03x [", r->head_seq_num);
+	seq_printf(s, "([%2d] %3d TU) 0x%03x [", r->buf_size, r->timeout,
+		   r->head_seq_num);
 	for (i = 0; i < r->buf_size; i++) {
 		if (i == index)
 			seq_printf(s, "%c", r->reorder_buf[i] ? 'O' : '|');
-- 
2.1.0

