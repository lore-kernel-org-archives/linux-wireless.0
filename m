Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine02.qualcomm.com ([199.106.114.251]:4194 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754844Ab1JKTI0 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 11 Oct 2011 15:08:26 -0400
Date: Tue, 11 Oct 2011 22:08:21 +0300
From: Jouni Malinen <jouni@qca.qualcomm.com>
To: Kalle Valo <kvalo@qca.qualcomm.com>
CC: <linux-wireless@vger.kernel.org>, Joe Perches <joe@perches.com>
Subject: [PATCH] ath6kl: Fix endpoint_stats debugfs buffer length calculation
Message-ID: <20111011190821.GA29419@jouni.qca.qualcomm.com> (sfid-20111011_210829_813644_6832D2FB)
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The previous version did not really make much sense and the theoretical
maximum length would be a bit longer. Calculate the length more
accurately. In addition, there is no need to clear the buffer, so use
kmalloc instead of kzalloc. For bonus points, add the forgotten
cred_rpt_from_other value to the file.

Reported-by: Joe Perches <joe@perches.com>
Signed-off-by: Jouni Malinen <jouni@qca.qualcomm.com>
---
 drivers/net/wireless/ath/ath6kl/debug.c |    6 ++++--
 1 files changed, 4 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/ath/ath6kl/debug.c b/drivers/net/wireless/ath/ath6kl/debug.c
index 7b1c9ae..dd37785 100644
--- a/drivers/net/wireless/ath/ath6kl/debug.c
+++ b/drivers/net/wireless/ath/ath6kl/debug.c
@@ -624,8 +624,9 @@ static ssize_t ath6kl_endpoint_stats_read(struct file *file,
 	unsigned int buf_len, len = 0;
 	ssize_t ret_cnt;
 
-	buf_len = 1000 + ENDPOINT_MAX * 100;
-	buf = kzalloc(buf_len, GFP_KERNEL);
+	buf_len = sizeof(struct htc_endpoint_stats) / sizeof(u32) *
+		(25 + ENDPOINT_MAX * 11);
+	buf = kmalloc(buf_len, GFP_KERNEL);
 	if (!buf)
 		return -ENOMEM;
 
@@ -640,6 +641,7 @@ static ssize_t ath6kl_endpoint_stats_read(struct file *file,
 	EPSTAT(tx_dropped);
 	EPSTAT(tx_cred_rpt);
 	EPSTAT(cred_rpt_from_rx);
+	EPSTAT(cred_rpt_from_other);
 	EPSTAT(cred_rpt_ep0);
 	EPSTAT(cred_from_rx);
 	EPSTAT(cred_from_other);
-- 
1.7.4.1


-- 
Jouni Malinen                                            PGP id EFC895FA
