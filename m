Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine02.qualcomm.com ([199.106.114.251]:22502 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S935250AbcCJJRZ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 10 Mar 2016 04:17:25 -0500
From: <akolli@qti.qualcomm.com>
To: <ath10k@lists.infradead.org>
CC: <akolli@codeaurora.org>, <stable@vger.kernel.org>,
	<linux-wireless@vger.kernel.org>,
	Anilkumar Kolli <akolli@qti.qualcomm.com>
Subject: [PATCH] ath10k: fix debugfs pktlog_filter write
Date: Thu, 10 Mar 2016 14:48:58 +0530
Message-ID: <1457601538-30751-1-git-send-email-akolli@qti.qualcomm.com> (sfid-20160310_101747_010942_E51CF19F)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Anilkumar Kolli <akolli@qti.qualcomm.com>

It is observed that, we are disabling the packet log if we write same
value to the pktlog_filter for the second time. Always enable pktlogs
on non zero filter.

Fixes: 90174455ae05 ("ath10k: add support to configure pktlog filter")
Signed-off-by: Anilkumar Kolli <akolli@qti.qualcomm.com>
---
 drivers/net/wireless/ath/ath10k/debug.c |    7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

diff --git a/drivers/net/wireless/ath/ath10k/debug.c b/drivers/net/wireless/ath/ath10k/debug.c
index 076d29b53ddf..0f834646e6a7 100644
--- a/drivers/net/wireless/ath/ath10k/debug.c
+++ b/drivers/net/wireless/ath/ath10k/debug.c
@@ -2019,7 +2019,12 @@ static ssize_t ath10k_write_pktlog_filter(struct file *file,
 		goto out;
 	}
 
-	if (filter && (filter != ar->debug.pktlog_filter)) {
+	if (filter == ar->debug.pktlog_filter) {
+		ret = count;
+		goto out;
+	}
+
+	if (filter) {
 		ret = ath10k_wmi_pdev_pktlog_enable(ar, filter);
 		if (ret) {
 			ath10k_warn(ar, "failed to enable pktlog filter %x: %d\n",
-- 
1.7.9.5

