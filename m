Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine02.qualcomm.com ([199.106.114.251]:57758 "EHLO
        wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751504AbdALNPU (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 12 Jan 2017 08:15:20 -0500
Cc: Dedy Lansky <qca_dlansky@qualcomm.com>,
        linux-wireless@vger.kernel.org, wil6210@qca.qualcomm.com,
        Maya Erez <qca_merez@qca.qualcomm.com>
From: Maya Erez <qca_merez@qca.qualcomm.com>
To: Kalle Valo <kvalo@codeaurora.org>
Subject: [PATCH v2 05/13] wil6210: support new WMI-only FW capability
Date: Thu, 12 Jan 2017 15:05:57 +0200
Message-Id: <1484226365-10433-6-git-send-email-qca_merez@qca.qualcomm.com> (sfid-20170112_141533_816743_CC007888)
In-Reply-To: <1484226365-10433-1-git-send-email-qca_merez@qca.qualcomm.com>
References: <1484226365-10433-1-git-send-email-qca_merez@qca.qualcomm.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Dedy Lansky <qca_dlansky@qca.qualcomm.com>

WMI_ONLY FW is used for testing in production. It cannot be used for
scan/connect, etc.
In case FW reports this capability, driver will not allow interface up.

Signed-off-by: Dedy Lansky <qca_dlansky@qca.qualcomm.com>
Signed-off-by: Maya Erez <qca_merez@qca.qualcomm.com>
---
 drivers/net/wireless/ath/wil6210/netdev.c   |  5 +++--
 drivers/net/wireless/ath/wil6210/pcie_bus.c | 10 +++++++---
 drivers/net/wireless/ath/wil6210/wmi.h      |  1 +
 3 files changed, 11 insertions(+), 5 deletions(-)

diff --git a/drivers/net/wireless/ath/wil6210/netdev.c b/drivers/net/wireless/ath/wil6210/netdev.c
index d5df744..1843d98 100644
--- a/drivers/net/wireless/ath/wil6210/netdev.c
+++ b/drivers/net/wireless/ath/wil6210/netdev.c
@@ -24,8 +24,9 @@ static int wil_open(struct net_device *ndev)
 
 	wil_dbg_misc(wil, "open\n");
 
-	if (debug_fw) {
-		wil_err(wil, "while in debug_fw mode\n");
+	if (debug_fw ||
+	    test_bit(WMI_FW_CAPABILITY_WMI_ONLY, wil->fw_capabilities)) {
+		wil_err(wil, "while in debug_fw or wmi_only mode\n");
 		return -EINVAL;
 	}
 
diff --git a/drivers/net/wireless/ath/wil6210/pcie_bus.c b/drivers/net/wireless/ath/wil6210/pcie_bus.c
index cd57d3e..e891068 100644
--- a/drivers/net/wireless/ath/wil6210/pcie_bus.c
+++ b/drivers/net/wireless/ath/wil6210/pcie_bus.c
@@ -99,8 +99,10 @@ static int wil_if_pcie_enable(struct wil6210_priv *wil)
 	 */
 	int msi_only = pdev->msi_enabled;
 	bool _use_msi = use_msi;
+	bool wmi_only = test_bit(WMI_FW_CAPABILITY_WMI_ONLY,
+				 wil->fw_capabilities);
 
-	wil_dbg_misc(wil, "if_pcie_enable\n");
+	wil_dbg_misc(wil, "if_pcie_enable, wmi_only %d\n", wmi_only);
 
 	pdev->msi_enabled = 0;
 
@@ -123,9 +125,11 @@ static int wil_if_pcie_enable(struct wil6210_priv *wil)
 	if (rc)
 		goto stop_master;
 
-	/* need reset here to obtain MAC */
+	/* need reset here to obtain MAC or in case of WMI-only FW, full reset
+	 * and fw loading takes place
+	 */
 	mutex_lock(&wil->mutex);
-	rc = wil_reset(wil, false);
+	rc = wil_reset(wil, wmi_only);
 	mutex_unlock(&wil->mutex);
 	if (rc)
 		goto release_irq;
diff --git a/drivers/net/wireless/ath/wil6210/wmi.h b/drivers/net/wireless/ath/wil6210/wmi.h
index 9c4a0bd..906aa72 100644
--- a/drivers/net/wireless/ath/wil6210/wmi.h
+++ b/drivers/net/wireless/ath/wil6210/wmi.h
@@ -57,6 +57,7 @@ enum wmi_fw_capability {
 	WMI_FW_CAPABILITY_RF_SECTORS		= 2,
 	WMI_FW_CAPABILITY_MGMT_RETRY_LIMIT	= 3,
 	WMI_FW_CAPABILITY_DISABLE_AP_SME	= 4,
+	WMI_FW_CAPABILITY_WMI_ONLY		= 5,
 	WMI_FW_CAPABILITY_MAX,
 };
 
-- 
1.9.1
