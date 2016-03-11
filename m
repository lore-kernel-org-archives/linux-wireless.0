Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine02.qualcomm.com ([199.106.114.251]:58054 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751030AbcCKGOn (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 11 Mar 2016 01:14:43 -0500
From: <akolli@qti.qualcomm.com>
To: <ath10k@lists.infradead.org>
CC: <akolli@codeaurora.org>, <linux-wireless@vger.kernel.org>,
	Anilkumar Kolli <akolli@qti.qualcomm.com>,
	<stable@vger.kernel.org>
Subject: [PATCH v2] ath10k: fix debugfs pktlog_filter write
Date: Fri, 11 Mar 2016 11:46:39 +0530
Message-ID: <1457676999-32678-1-git-send-email-akolli@qti.qualcomm.com> (sfid-20160311_071448_722546_C963A071)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Anilkumar Kolli <akolli@qti.qualcomm.com>

It is observed that, we are disabling the packet log if we write same
value to the pktlog_filter for the second time. Always enable pktlogs
on non zero filter.

Fixes: 90174455ae05 ("ath10k: add support to configure pktlog filter")
Cc: stable@vger.kernel.org
Signed-off-by: Anilkumar Kolli <akolli@qti.qualcomm.com>
---
v2:
 * added stable@vger.kernel.org

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

