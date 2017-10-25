Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from alexa-out.qualcomm.com ([129.46.98.28]:35612 "EHLO
        alexa-out.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751477AbdJYNOg (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 25 Oct 2017 09:14:36 -0400
Cc: Lazar Alexei <QCA_ailizaro@QCA.qualcomm.com>,
        linux-wireless@vger.kernel.org, wil6210@qca.qualcomm.com,
        Maya Erez <qca_merez@qca.qualcomm.com>
From: Maya Erez <qca_merez@qca.qualcomm.com>
To: Kalle Valo <kvalo@codeaurora.org>
Subject: [PATCH 12/12] wil6210: update statistics for suspend
Date: Wed, 25 Oct 2017 16:14:07 +0300
Message-Id: <1508937247-11890-13-git-send-email-qca_merez@qca.qualcomm.com> (sfid-20171025_151439_230717_6F203E9B)
In-Reply-To: <1508937247-11890-1-git-send-email-qca_merez@qca.qualcomm.com>
References: <1508937247-11890-1-git-send-email-qca_merez@qca.qualcomm.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Lazar Alexei <qca_ailizaro@qca.qualcomm.com>

Currently the statistics show how many successful/failed
suspend/resume operations the system had.
Update the statistics by splitting each successful/failed
suspend/resume operations to radio on/off.

Signed-off-by: Lazar Alexei <qca_ailizaro@qca.qualcomm.com>
Signed-off-by: Maya Erez <qca_merez@qca.qualcomm.com>
---
 drivers/net/wireless/ath/wil6210/debugfs.c  | 27 ++++++++++++++++++---------
 drivers/net/wireless/ath/wil6210/pcie_bus.c | 20 ++++++++++++++------
 drivers/net/wireless/ath/wil6210/pm.c       |  8 +++++---
 drivers/net/wireless/ath/wil6210/wil6210.h  | 11 ++++++++---
 4 files changed, 45 insertions(+), 21 deletions(-)

diff --git a/drivers/net/wireless/ath/wil6210/debugfs.c b/drivers/net/wireless/ath/wil6210/debugfs.c
index 03d17ea..9164855 100644
--- a/drivers/net/wireless/ath/wil6210/debugfs.c
+++ b/drivers/net/wireless/ath/wil6210/debugfs.c
@@ -1685,20 +1685,29 @@ static ssize_t wil_read_suspend_stats(struct file *file,
 				      size_t count, loff_t *ppos)
 {
 	struct wil6210_priv *wil = file->private_data;
-	static char text[400];
+	static char text[500];
 	int n;
 
 	n = snprintf(text, sizeof(text),
-		     "Suspend statistics:\n"
+		     "Radio on suspend statistics:\n"
+		     "successful suspends:%ld failed suspends:%ld\n"
+		     "successful resumes:%ld failed resumes:%ld\n"
+		     "rejected by device:%ld\n"
+		     "Radio off suspend statistics:\n"
 		     "successful suspends:%ld failed suspends:%ld\n"
 		     "successful resumes:%ld failed resumes:%ld\n"
-		     "rejected by host:%ld rejected by device:%ld\n",
-		     wil->suspend_stats.successful_suspends,
-		     wil->suspend_stats.failed_suspends,
-		     wil->suspend_stats.successful_resumes,
-		     wil->suspend_stats.failed_resumes,
-		     wil->suspend_stats.rejected_by_host,
-		     wil->suspend_stats.rejected_by_device);
+		     "General statistics:\n"
+		     "rejected by host:%ld\n",
+		     wil->suspend_stats.r_on.successful_suspends,
+		     wil->suspend_stats.r_on.failed_suspends,
+		     wil->suspend_stats.r_on.successful_resumes,
+		     wil->suspend_stats.r_on.failed_resumes,
+		     wil->suspend_stats.rejected_by_device,
+		     wil->suspend_stats.r_off.successful_suspends,
+		     wil->suspend_stats.r_off.failed_suspends,
+		     wil->suspend_stats.r_off.successful_resumes,
+		     wil->suspend_stats.r_off.failed_resumes,
+		     wil->suspend_stats.rejected_by_host);
 
 	n = min_t(int, n, sizeof(text));
 
diff --git a/drivers/net/wireless/ath/wil6210/pcie_bus.c b/drivers/net/wireless/ath/wil6210/pcie_bus.c
index 07a44d3..9f11fdc 100644
--- a/drivers/net/wireless/ath/wil6210/pcie_bus.c
+++ b/drivers/net/wireless/ath/wil6210/pcie_bus.c
@@ -398,14 +398,16 @@ static int wil6210_suspend(struct device *dev, bool is_runtime)
 
 	rc = wil_suspend(wil, is_runtime, keep_radio_on);
 	if (!rc) {
-		wil->suspend_stats.successful_suspends++;
-
 		/* In case radio stays on, platform device will control
 		 * PCIe master
 		 */
-		if (!keep_radio_on)
+		if (!keep_radio_on) {
 			/* disable bus mastering */
 			pci_clear_master(pdev);
+			wil->suspend_stats.r_off.successful_suspends++;
+		} else {
+			wil->suspend_stats.r_on.successful_suspends++;
+		}
 	}
 out:
 	return rc;
@@ -431,11 +433,17 @@ static int wil6210_resume(struct device *dev, bool is_runtime)
 	rc = wil_resume(wil, is_runtime, keep_radio_on);
 	if (rc) {
 		wil_err(wil, "device failed to resume (%d)\n", rc);
-		wil->suspend_stats.failed_resumes++;
-		if (!keep_radio_on)
+		if (!keep_radio_on) {
 			pci_clear_master(pdev);
+			wil->suspend_stats.r_off.failed_resumes++;
+		} else {
+			wil->suspend_stats.r_on.failed_resumes++;
+		}
 	} else {
-		wil->suspend_stats.successful_resumes++;
+		if (keep_radio_on)
+			wil->suspend_stats.r_on.successful_resumes++;
+		else
+			wil->suspend_stats.r_off.successful_resumes++;
 	}
 
 	return rc;
diff --git a/drivers/net/wireless/ath/wil6210/pm.c b/drivers/net/wireless/ath/wil6210/pm.c
index 48ec186..ec39ac7 100644
--- a/drivers/net/wireless/ath/wil6210/pm.c
+++ b/drivers/net/wireless/ath/wil6210/pm.c
@@ -179,7 +179,7 @@ static int wil_suspend_keep_radio_on(struct wil6210_priv *wil)
 					break;
 				wil_err(wil,
 					"TO waiting for idle RX, suspend failed\n");
-				wil->suspend_stats.failed_suspends++;
+				wil->suspend_stats.r_on.failed_suspends++;
 				goto resume_after_fail;
 			}
 			wil_dbg_ratelimited(wil, "rx vring is not empty -> NAPI\n");
@@ -195,7 +195,7 @@ static int wil_suspend_keep_radio_on(struct wil6210_priv *wil)
 	 */
 	if (!wil_is_wmi_idle(wil)) {
 		wil_err(wil, "suspend failed due to pending WMI events\n");
-		wil->suspend_stats.failed_suspends++;
+		wil->suspend_stats.r_on.failed_suspends++;
 		goto resume_after_fail;
 	}
 
@@ -209,7 +209,7 @@ static int wil_suspend_keep_radio_on(struct wil6210_priv *wil)
 		if (rc) {
 			wil_err(wil, "platform device failed to suspend (%d)\n",
 				rc);
-			wil->suspend_stats.failed_suspends++;
+			wil->suspend_stats.r_on.failed_suspends++;
 			wil_c(wil, RGF_USER_CLKS_CTL_0, BIT_USER_CLKS_RST_PWGD);
 			wil_unmask_irq(wil);
 			goto resume_after_fail;
@@ -256,6 +256,7 @@ static int wil_suspend_radio_off(struct wil6210_priv *wil)
 		rc = wil_down(wil);
 		if (rc) {
 			wil_err(wil, "wil_down : %d\n", rc);
+			wil->suspend_stats.r_off.failed_suspends++;
 			goto out;
 		}
 	}
@@ -268,6 +269,7 @@ static int wil_suspend_radio_off(struct wil6210_priv *wil)
 		rc = wil->platform_ops.suspend(wil->platform_handle, false);
 		if (rc) {
 			wil_enable_irq(wil);
+			wil->suspend_stats.r_off.failed_suspends++;
 			goto out;
 		}
 	}
diff --git a/drivers/net/wireless/ath/wil6210/wil6210.h b/drivers/net/wireless/ath/wil6210/wil6210.h
index 0d8457e..52c477f 100644
--- a/drivers/net/wireless/ath/wil6210/wil6210.h
+++ b/drivers/net/wireless/ath/wil6210/wil6210.h
@@ -82,12 +82,17 @@ static inline u32 WIL_GET_BITS(u32 x, int b0, int b1)
  */
 #define WIL_MAX_MPDU_OVERHEAD	(62)
 
-struct wil_suspend_stats {
+struct wil_suspend_count_stats {
 	unsigned long successful_suspends;
-	unsigned long failed_suspends;
 	unsigned long successful_resumes;
+	unsigned long failed_suspends;
 	unsigned long failed_resumes;
-	unsigned long rejected_by_device;
+};
+
+struct wil_suspend_stats {
+	struct wil_suspend_count_stats r_off;
+	struct wil_suspend_count_stats r_on;
+	unsigned long rejected_by_device; /* only radio on */
 	unsigned long rejected_by_host;
 };
 
-- 
1.9.1
