Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from sabertooth01.qualcomm.com ([65.197.215.72]:54362 "EHLO
        sabertooth01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1755380AbdKNN0F (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 14 Nov 2017 08:26:05 -0500
Cc: Lazar Alexei <QCA_ailizaro@QCA.qualcomm.com>,
        linux-wireless@vger.kernel.org, wil6210@qca.qualcomm.com,
        Maya Erez <qca_merez@qca.qualcomm.com>
From: Maya Erez <qca_merez@qca.qualcomm.com>
To: Kalle Valo <kvalo@codeaurora.org>
Subject: [PATCH v3 10/12] wil6210: fix PCIe bus mastering in case of interface down
Date: Tue, 14 Nov 2017 15:25:42 +0200
Message-Id: <1510665944-30198-11-git-send-email-qca_merez@qca.qualcomm.com> (sfid-20171114_142617_643362_43821808)
In-Reply-To: <1510665944-30198-1-git-send-email-qca_merez@qca.qualcomm.com>
References: <1510665944-30198-1-git-send-email-qca_merez@qca.qualcomm.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Lazar Alexei <qca_ailizaro@qca.qualcomm.com>

In case of interface down, radio is turned off but PCIe mastering is
not cleared.
This can cause unexpected PCIe access to the shutdown device.
Fix this by clearing PCIe mastering also in case interface is down

Signed-off-by: Lazar Alexei <qca_ailizaro@qca.qualcomm.com>
Signed-off-by: Maya Erez <qca_merez@qca.qualcomm.com>
---
 drivers/net/wireless/ath/wil6210/pcie_bus.c | 24 +++++++++++++++---------
 drivers/net/wireless/ath/wil6210/pm.c       | 10 ++--------
 drivers/net/wireless/ath/wil6210/wil6210.h  |  4 ++--
 3 files changed, 19 insertions(+), 19 deletions(-)

diff --git a/drivers/net/wireless/ath/wil6210/pcie_bus.c b/drivers/net/wireless/ath/wil6210/pcie_bus.c
index fdab8a5..0592c73 100644
--- a/drivers/net/wireless/ath/wil6210/pcie_bus.c
+++ b/drivers/net/wireless/ath/wil6210/pcie_bus.c
@@ -379,6 +379,9 @@ static int wil6210_suspend(struct device *dev, bool is_runtime)
 	int rc = 0;
 	struct pci_dev *pdev = to_pci_dev(dev);
 	struct wil6210_priv *wil = pci_get_drvdata(pdev);
+	struct net_device *ndev = wil_to_ndev(wil);
+	bool keep_radio_on = ndev->flags & IFF_UP &&
+			     wil->keep_radio_on_during_sleep;
 
 	wil_dbg_pm(wil, "suspend: %s\n", is_runtime ? "runtime" : "system");
 
@@ -386,14 +389,14 @@ static int wil6210_suspend(struct device *dev, bool is_runtime)
 	if (rc)
 		goto out;
 
-	rc = wil_suspend(wil, is_runtime);
+	rc = wil_suspend(wil, is_runtime, keep_radio_on);
 	if (!rc) {
 		wil->suspend_stats.successful_suspends++;
 
-		/* If platform device supports keep_radio_on_during_sleep
-		 * it will control PCIe master
+		/* In case radio stays on, platform device will control
+		 * PCIe master
 		 */
-		if (!wil->keep_radio_on_during_sleep)
+		if (!keep_radio_on)
 			/* disable bus mastering */
 			pci_clear_master(pdev);
 	}
@@ -406,20 +409,23 @@ static int wil6210_resume(struct device *dev, bool is_runtime)
 	int rc = 0;
 	struct pci_dev *pdev = to_pci_dev(dev);
 	struct wil6210_priv *wil = pci_get_drvdata(pdev);
+	struct net_device *ndev = wil_to_ndev(wil);
+	bool keep_radio_on = ndev->flags & IFF_UP &&
+			     wil->keep_radio_on_during_sleep;
 
 	wil_dbg_pm(wil, "resume: %s\n", is_runtime ? "runtime" : "system");
 
-	/* If platform device supports keep_radio_on_during_sleep it will
-	 * control PCIe master
+	/* In case radio stays on, platform device will control
+	 * PCIe master
 	 */
-	if (!wil->keep_radio_on_during_sleep)
+	if (!keep_radio_on)
 		/* allow master */
 		pci_set_master(pdev);
-	rc = wil_resume(wil, is_runtime);
+	rc = wil_resume(wil, is_runtime, keep_radio_on);
 	if (rc) {
 		wil_err(wil, "device failed to resume (%d)\n", rc);
 		wil->suspend_stats.failed_resumes++;
-		if (!wil->keep_radio_on_during_sleep)
+		if (!keep_radio_on)
 			pci_clear_master(pdev);
 	} else {
 		wil->suspend_stats.successful_resumes++;
diff --git a/drivers/net/wireless/ath/wil6210/pm.c b/drivers/net/wireless/ath/wil6210/pm.c
index 43699ac..6fd5420 100644
--- a/drivers/net/wireless/ath/wil6210/pm.c
+++ b/drivers/net/wireless/ath/wil6210/pm.c
@@ -304,12 +304,9 @@ static int wil_resume_radio_off(struct wil6210_priv *wil)
 	return rc;
 }
 
-int wil_suspend(struct wil6210_priv *wil, bool is_runtime)
+int wil_suspend(struct wil6210_priv *wil, bool is_runtime, bool keep_radio_on)
 {
 	int rc = 0;
-	struct net_device *ndev = wil_to_ndev(wil);
-	bool keep_radio_on = ndev->flags & IFF_UP &&
-			     wil->keep_radio_on_during_sleep;
 
 	wil_dbg_pm(wil, "suspend: %s\n", is_runtime ? "runtime" : "system");
 
@@ -332,12 +329,9 @@ int wil_suspend(struct wil6210_priv *wil, bool is_runtime)
 	return rc;
 }
 
-int wil_resume(struct wil6210_priv *wil, bool is_runtime)
+int wil_resume(struct wil6210_priv *wil, bool is_runtime, bool keep_radio_on)
 {
 	int rc = 0;
-	struct net_device *ndev = wil_to_ndev(wil);
-	bool keep_radio_on = ndev->flags & IFF_UP &&
-			     wil->keep_radio_on_during_sleep;
 	unsigned long long suspend_time_usec = 0;
 
 	wil_dbg_pm(wil, "resume: %s\n", is_runtime ? "runtime" : "system");
diff --git a/drivers/net/wireless/ath/wil6210/wil6210.h b/drivers/net/wireless/ath/wil6210/wil6210.h
index 48802ae..7e017b1 100644
--- a/drivers/net/wireless/ath/wil6210/wil6210.h
+++ b/drivers/net/wireless/ath/wil6210/wil6210.h
@@ -1016,8 +1016,8 @@ int wil_request_firmware(struct wil6210_priv *wil, const char *name,
 void wil_pm_runtime_put(struct wil6210_priv *wil);
 
 int wil_can_suspend(struct wil6210_priv *wil, bool is_runtime);
-int wil_suspend(struct wil6210_priv *wil, bool is_runtime);
-int wil_resume(struct wil6210_priv *wil, bool is_runtime);
+int wil_suspend(struct wil6210_priv *wil, bool is_runtime, bool keep_radio_on);
+int wil_resume(struct wil6210_priv *wil, bool is_runtime, bool keep_radio_on);
 bool wil_is_wmi_idle(struct wil6210_priv *wil);
 int wmi_resume(struct wil6210_priv *wil);
 int wmi_suspend(struct wil6210_priv *wil);
-- 
1.9.1
