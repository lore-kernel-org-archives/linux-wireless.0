Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine02.qualcomm.com ([199.106.114.251]:16132 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751282AbaIJNf2 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 10 Sep 2014 09:35:28 -0400
Cc: Dedy Lansky <qca_dlansky@qualcomm.com>,
	<linux-wireless@vger.kernel.org>, <wil6210@qca.qualcomm.com>,
	"Vladimir Kondratiev" <qca_vkondrat@qca.qualcomm.com>
From: Vladimir Kondratiev <qca_vkondrat@qca.qualcomm.com>
To: "John W . Linville" <linville@tuxdriver.com>
Subject: [PATCH 09/22] wil6210: fix for memory corruption upon rmmod
Date: Wed, 10 Sep 2014 16:34:38 +0300
Message-ID: <1410356091-19219-10-git-send-email-qca_vkondrat@qca.qualcomm.com> (sfid-20140910_153559_304685_FAAC615E)
In-Reply-To: <1410356091-19219-1-git-send-email-qca_vkondrat@qca.qualcomm.com>
References: <1410356091-19219-1-git-send-email-qca_vkondrat@qca.qualcomm.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Dedy Lansky <qca_dlansky@qca.qualcomm.com>

Driver disabled PCI master before making sure HW is idle.
This caused memory corruption in case HW access system memory after
PCI master got disabled.
The fix is to change uninit sequence. Make sure FW/HW is idle before
disabling PCI

Signed-off-by: Dedy Lansky <qca_dlansky@qca.qualcomm.com>
Signed-off-by: Vladimir Kondratiev <qca_vkondrat@qca.qualcomm.com>
---
 drivers/net/wireless/ath/wil6210/main.c     | 26 +++++++++++++++++++++++++-
 drivers/net/wireless/ath/wil6210/pcie_bus.c |  2 +-
 2 files changed, 26 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/ath/wil6210/main.c b/drivers/net/wireless/ath/wil6210/main.c
index 696be3e..22e9b8a 100644
--- a/drivers/net/wireless/ath/wil6210/main.c
+++ b/drivers/net/wireless/ath/wil6210/main.c
@@ -20,6 +20,10 @@
 
 #include "wil6210.h"
 #include "txrx.h"
+#include "wmi.h"
+
+#define WAIT_FOR_DISCONNECT_TIMEOUT_MS 2000
+#define WAIT_FOR_DISCONNECT_INTERVAL_MS 10
 
 static bool no_fw_recovery;
 module_param(no_fw_recovery, bool, S_IRUGO | S_IWUSR);
@@ -631,6 +635,9 @@ int wil_up(struct wil6210_priv *wil)
 
 static int __wil_down(struct wil6210_priv *wil)
 {
+	int iter = WAIT_FOR_DISCONNECT_TIMEOUT_MS /
+			WAIT_FOR_DISCONNECT_INTERVAL_MS;
+
 	WARN_ON(!mutex_is_locked(&wil->mutex));
 
 	if (wil->platform_ops.bus_request)
@@ -648,7 +655,24 @@ static int __wil_down(struct wil6210_priv *wil)
 		wil->scan_request = NULL;
 	}
 
-	wil6210_disconnect(wil, NULL);
+	if (test_bit(wil_status_fwconnected, &wil->status) ||
+	    test_bit(wil_status_fwconnecting, &wil->status))
+		wmi_send(wil, WMI_DISCONNECT_CMDID, NULL, 0);
+
+	/* make sure wil is idle (not connected) */
+	mutex_unlock(&wil->mutex);
+	while (iter--) {
+		int idle = !test_bit(wil_status_fwconnected, &wil->status) &&
+			   !test_bit(wil_status_fwconnecting, &wil->status);
+		if (idle)
+			break;
+		msleep(WAIT_FOR_DISCONNECT_INTERVAL_MS);
+	}
+	mutex_lock(&wil->mutex);
+
+	if (!iter)
+		wil_err(wil, "timeout waiting for idle FW/HW\n");
+
 	wil_rx_fini(wil);
 
 	return 0;
diff --git a/drivers/net/wireless/ath/wil6210/pcie_bus.c b/drivers/net/wireless/ath/wil6210/pcie_bus.c
index d2a1ca2..264c0f0 100644
--- a/drivers/net/wireless/ath/wil6210/pcie_bus.c
+++ b/drivers/net/wireless/ath/wil6210/pcie_bus.c
@@ -233,8 +233,8 @@ static void wil_pcie_remove(struct pci_dev *pdev)
 	wil_dbg_misc(wil, "%s()\n", __func__);
 
 	wil6210_debugfs_remove(wil);
-	wil_if_pcie_disable(wil);
 	wil_if_remove(wil);
+	wil_if_pcie_disable(wil);
 	if (wil->platform_ops.uninit)
 		wil->platform_ops.uninit(wil->platform_handle);
 	wil_if_free(wil);
-- 
1.9.1

