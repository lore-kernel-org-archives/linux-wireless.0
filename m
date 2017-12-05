Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from alexa-out.qualcomm.com ([129.46.98.28]:27626 "EHLO
        alexa-out.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752858AbdLENbQ (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 5 Dec 2017 08:31:16 -0500
From: <akolli@qti.qualcomm.com>
To: <ath10k@lists.infradead.org>
CC: <linux-wireless@vger.kernel.org>, <akolli@codeaurora.org>,
        Anilkumar Kolli <akolli@qti.qualcomm.com>
Subject: [PATCHv2 2/3] ath10k: move pktlog_filter out of ath10k_debug
Date: Tue, 5 Dec 2017 19:01:24 +0530
Message-ID: <1512480685-28471-3-git-send-email-akolli@qti.qualcomm.com> (sfid-20171205_143122_699292_FC322EB6)
In-Reply-To: <1512480685-28471-1-git-send-email-akolli@qti.qualcomm.com>
References: <1512480685-28471-1-git-send-email-akolli@qti.qualcomm.com>
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
index 15e386d091a4..eac9737ee407 100644
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
