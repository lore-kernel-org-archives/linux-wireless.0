Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from alexa-out-ams-01.qualcomm.com ([185.23.61.162]:13372 "EHLO
        alexa-out-ams-01.qualcomm.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1732101AbeHWPQp (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 23 Aug 2018 11:16:45 -0400
From: Maya Erez <merez@codeaurora.org>
To: Kalle Valo <kvalo@codeaurora.org>
Cc: Dedy Lansky <dlansky@codeaurora.org>,
        linux-wireless@vger.kernel.org, wil6210@qti.qualcomm.com,
        Maya Erez <merez@codeaurora.org>
Subject: [PATCH 9/9] wil6210: fix invalid memory access for rx_buff_mgmt debugfs
Date: Thu, 23 Aug 2018 14:47:13 +0300
Message-Id: <1535024833-15178-10-git-send-email-merez@codeaurora.org> (sfid-20180823_134729_987130_0F563711)
In-Reply-To: <1535024833-15178-1-git-send-email-merez@codeaurora.org>
References: <1535024833-15178-1-git-send-email-merez@codeaurora.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Dedy Lansky <dlansky@codeaurora.org>

Check rx_buff_mgmt is allocated before accessing its internal fields.

Signed-off-by: Dedy Lansky <dlansky@codeaurora.org>
Signed-off-by: Maya Erez <merez@codeaurora.org>
---
 drivers/net/wireless/ath/wil6210/debugfs.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/net/wireless/ath/wil6210/debugfs.c b/drivers/net/wireless/ath/wil6210/debugfs.c
index 6973333..965c61b 100644
--- a/drivers/net/wireless/ath/wil6210/debugfs.c
+++ b/drivers/net/wireless/ath/wil6210/debugfs.c
@@ -1237,6 +1237,9 @@ static int wil_rx_buff_mgmt_debugfs_show(struct seq_file *s, void *data)
 	int num_active;
 	int num_free;
 
+	if (!rbm->buff_arr)
+		return -EINVAL;
+
 	seq_printf(s, "  size = %zu\n", rbm->size);
 	seq_printf(s, "  free_list_empty_cnt = %lu\n",
 		   rbm->free_list_empty_cnt);
-- 
1.9.1
