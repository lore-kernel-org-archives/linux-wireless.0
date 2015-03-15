Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from sabertooth02.qualcomm.com ([65.197.215.38]:64722 "EHLO
	sabertooth02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752545AbbCOOAr (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 15 Mar 2015 10:00:47 -0400
From: Vladimir Kondratiev <QCA_vkondrat@QCA.qualcomm.com>
Cc: Vladimir Kondratiev <QCA_vkondrat@QCA.qualcomm.com>,
	linux-wireless@vger.kernel.org, wil6210@qca.qualcomm.com
To: Kalle Valo <kvalo@qca.qualcomm.com>
Subject: [PATCH 2/7] wil6210: fix check for FW responsiveness
Date: Sun, 15 Mar 2015 16:00:17 +0200
Message-Id: <1426428024-4538-4-git-send-email-qca_vkondrat@qca.qualcomm.com> (sfid-20150315_150054_472181_7C440067)
In-Reply-To: <1426428024-4538-1-git-send-email-qca_vkondrat@qca.qualcomm.com>
References: <1426428024-4538-1-git-send-email-qca_vkondrat@qca.qualcomm.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

"echo" used to be called when no firmware loaded to the NIC,
this causes error output.

Probe firmware with "echo" only after it returned "ready" event.

Signed-off-by: Vladimir Kondratiev <qca_vkondrat@qca.qualcomm.com>
---
 drivers/net/wireless/ath/wil6210/main.c     | 2 ++
 drivers/net/wireless/ath/wil6210/pcie_bus.c | 2 --
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/ath/wil6210/main.c b/drivers/net/wireless/ath/wil6210/main.c
index afff8d3..a5fd605 100644
--- a/drivers/net/wireless/ath/wil6210/main.c
+++ b/drivers/net/wireless/ath/wil6210/main.c
@@ -724,6 +724,8 @@ int wil_reset(struct wil6210_priv *wil, bool load_fw)
 
 		/* we just started MAC, wait for FW ready */
 		rc = wil_wait_for_fw_ready(wil);
+		if (rc == 0) /* check FW is responsive */
+			rc = wmi_echo(wil);
 	}
 
 	return rc;
diff --git a/drivers/net/wireless/ath/wil6210/pcie_bus.c b/drivers/net/wireless/ath/wil6210/pcie_bus.c
index 25343cf..1099861 100644
--- a/drivers/net/wireless/ath/wil6210/pcie_bus.c
+++ b/drivers/net/wireless/ath/wil6210/pcie_bus.c
@@ -246,8 +246,6 @@ static int wil_pcie_probe(struct pci_dev *pdev, const struct pci_device_id *id)
 
 	wil6210_debugfs_init(wil);
 
-	/* check FW is alive */
-	wmi_echo(wil);
 
 	return 0;
 
-- 
2.1.0

