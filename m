Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from sabertooth01.qualcomm.com ([65.197.215.72]:63794 "EHLO
        sabertooth01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752891AbdK3M6I (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 30 Nov 2017 07:58:08 -0500
From: <akolli@qti.qualcomm.com>
To: <ath10k@lists.infradead.org>
CC: <linux-wireless@vger.kernel.org>, <akolli@codeaurora.org>,
        Anilkumar Kolli <akolli@qti.qualcomm.com>
Subject: [PATCH 1/2] ath10k: move pktlog_filter out of ath10k_debug
Date: Thu, 30 Nov 2017 18:28:20 +0530
Message-ID: <1512046701-14435-2-git-send-email-akolli@qti.qualcomm.com> (sfid-20171130_135823_930980_ECD174E3)
In-Reply-To: <1512046701-14435-1-git-send-email-akolli@qti.qualcomm.com>
References: <1512046701-14435-1-git-send-email-akolli@qti.qualcomm.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Anilkumar Kolli <akolli@qti.qualcomm.com>

Move pktlog_filter from struct ath10k_debug to struct ath10k
so that pktlog can be enabled even when debugfs is not
enabled, needed to enable peer tx stats for 10.2.4.

No changes in functionality.

Signed-off-by: Anilkumar Kolli <akolli@qti.qualcomm.com>
---
 drivers/net/wireless/ath/ath10k/core.h  |    2 +-
 drivers/net/wireless/ath/ath10k/debug.c |   16 ++++++++--------
 2 files changed, 9 insertions(+), 9 deletions(-)

diff --git a/drivers/net/wireless/ath/ath10k/core.h b/drivers/net/wireless/ath/ath10k/core.h
index 643041ef3271..75dbfffe677a 100644
--- a/drivers/net/wireless/ath/ath10k/core.h
+++ b/drivers/net/wireless/ath/ath10k/core.h
@@ -488,7 +488,6 @@ struct ath10k_debug {
 	/* protected by conf_mutex */
 	u64 fw_dbglog_mask;
 	u32 fw_dbglog_level;
-	u32 pktlog_filter;
 	u32 reg_addr;
 	u32 nf_cal_period;
 	void *cal_data;
@@ -963,6 +962,7 @@ struct ath10k {
 	} spectral;
 #endif
 
+	u32 pktlog_filter;
 	struct {
 		/* protected by conf_mutex */
 		struct ath10k_fw_components utf_mode_fw;
diff --git a/drivers/net/wireless/ath/ath10k/debug.c b/drivers/net/wireless/ath/ath10k/debug.c
index df514507d3f1..e278300b4f14 100644
--- a/drivers/net/wireless/ath/ath10k/debug.c
+++ b/drivers/net/wireless/ath/ath10k/debug.c
@@ -1950,14 +1950,14 @@ int ath10k_debug_start(struct ath10k *ar)
 				    ret);
 	}
 
-	if (ar->debug.pktlog_filter) {
+	if (ar->pktlog_filter) {
 		ret = ath10k_wmi_pdev_pktlog_enable(ar,
-						    ar->debug.pktlog_filter);
+						    ar->pktlog_filter);
 		if (ret)
 			/* not serious */
 			ath10k_warn(ar,
 				    "failed to enable pktlog filter %x: %d\n",
-				    ar->debug.pktlog_filter, ret);
+				    ar->pktlog_filter, ret);
 	} else {
 		ret = ath10k_wmi_pdev_pktlog_disable(ar);
 		if (ret)
@@ -2097,12 +2097,12 @@ static ssize_t ath10k_write_pktlog_filter(struct file *file,
 	mutex_lock(&ar->conf_mutex);
 
 	if (ar->state != ATH10K_STATE_ON) {
-		ar->debug.pktlog_filter = filter;
+		ar->pktlog_filter = filter;
 		ret = count;
 		goto out;
 	}
 
-	if (filter == ar->debug.pktlog_filter) {
+	if (filter == ar->pktlog_filter) {
 		ret = count;
 		goto out;
 	}
@@ -2111,7 +2111,7 @@ static ssize_t ath10k_write_pktlog_filter(struct file *file,
 		ret = ath10k_wmi_pdev_pktlog_enable(ar, filter);
 		if (ret) {
 			ath10k_warn(ar, "failed to enable pktlog filter %x: %d\n",
-				    ar->debug.pktlog_filter, ret);
+				    ar->pktlog_filter, ret);
 			goto out;
 		}
 	} else {
@@ -2122,7 +2122,7 @@ static ssize_t ath10k_write_pktlog_filter(struct file *file,
 		}
 	}
 
-	ar->debug.pktlog_filter = filter;
+	ar->pktlog_filter = filter;
 	ret = count;
 
 out:
@@ -2139,7 +2139,7 @@ static ssize_t ath10k_read_pktlog_filter(struct file *file, char __user *ubuf,
 
 	mutex_lock(&ar->conf_mutex);
 	len = scnprintf(buf, sizeof(buf) - len, "%08x\n",
-			ar->debug.pktlog_filter);
+			ar->pktlog_filter);
 	mutex_unlock(&ar->conf_mutex);
 
 	return simple_read_from_buffer(ubuf, count, ppos, buf, len);
-- 
1.7.9.5
