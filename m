Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine01.qualcomm.com ([199.106.114.254]:3625 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752901AbbC3I3S (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 30 Mar 2015 04:29:18 -0400
From: Vladimir Kondratiev <QCA_vkondrat@QCA.qualcomm.com>
Cc: Vladimir Kondratiev <QCA_vkondrat@QCA.qualcomm.com>,
	linux-wireless@vger.kernel.org, wil6210@qca.qualcomm.com
To: Kalle Valo <kvalo@codeaurora.org>
Subject: [PATCH 1/5] wil6210: fw debug mode
Date: Mon, 30 Mar 2015 11:28:50 +0300
Message-Id: <1427704134-30699-2-git-send-email-qca_vkondrat@qca.qualcomm.com> (sfid-20150330_102922_614014_5A0FF240)
In-Reply-To: <1427704134-30699-1-git-send-email-qca_vkondrat@qca.qualcomm.com>
References: <1427704134-30699-1-git-send-email-qca_vkondrat@qca.qualcomm.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

refactor module parameter debug_fw to act as "fw debug mode",
where driver do nothing but allow card memory access.

Signed-off-by: Vladimir Kondratiev <qca_vkondrat@qca.qualcomm.com>
---
 drivers/net/wireless/ath/wil6210/main.c     | 15 +++++++++++++++
 drivers/net/wireless/ath/wil6210/netdev.c   |  5 +++++
 drivers/net/wireless/ath/wil6210/pcie_bus.c |  6 ------
 drivers/net/wireless/ath/wil6210/wil6210.h  |  1 +
 4 files changed, 21 insertions(+), 6 deletions(-)

diff --git a/drivers/net/wireless/ath/wil6210/main.c b/drivers/net/wireless/ath/wil6210/main.c
index c2a2384..0623d8c 100644
--- a/drivers/net/wireless/ath/wil6210/main.c
+++ b/drivers/net/wireless/ath/wil6210/main.c
@@ -25,6 +25,10 @@
 #define WAIT_FOR_DISCONNECT_TIMEOUT_MS 2000
 #define WAIT_FOR_DISCONNECT_INTERVAL_MS 10
 
+bool debug_fw; /* = false; */
+module_param(debug_fw, bool, S_IRUGO);
+MODULE_PARM_DESC(debug_fw, " do not perform card reset. For FW debug");
+
 bool no_fw_recovery;
 module_param(no_fw_recovery, bool, S_IRUGO | S_IWUSR);
 MODULE_PARM_DESC(no_fw_recovery, " disable automatic FW error recovery");
@@ -686,6 +690,17 @@ int wil_reset(struct wil6210_priv *wil, bool load_fw)
 	WARN_ON(!mutex_is_locked(&wil->mutex));
 	WARN_ON(test_bit(wil_status_napi_en, wil->status));
 
+	if (debug_fw) {
+		static const u8 mac[ETH_ALEN] = {
+			0x00, 0xde, 0xad, 0x12, 0x34, 0x56,
+		};
+		struct net_device *ndev = wil_to_ndev(wil);
+
+		ether_addr_copy(ndev->perm_addr, mac);
+		ether_addr_copy(ndev->dev_addr, ndev->perm_addr);
+		return 0;
+	}
+
 	cancel_work_sync(&wil->disconnect_worker);
 	wil6210_disconnect(wil, NULL, WLAN_REASON_DEAUTH_LEAVING, false);
 	wil_bcast_fini(wil);
diff --git a/drivers/net/wireless/ath/wil6210/netdev.c b/drivers/net/wireless/ath/wil6210/netdev.c
index f2f7ea2..6042f61 100644
--- a/drivers/net/wireless/ath/wil6210/netdev.c
+++ b/drivers/net/wireless/ath/wil6210/netdev.c
@@ -24,6 +24,11 @@ static int wil_open(struct net_device *ndev)
 
 	wil_dbg_misc(wil, "%s()\n", __func__);
 
+	if (debug_fw) {
+		wil_err(wil, "%s() while in debug_fw mode\n", __func__);
+		return -EINVAL;
+	}
+
 	return wil_up(wil);
 }
 
diff --git a/drivers/net/wireless/ath/wil6210/pcie_bus.c b/drivers/net/wireless/ath/wil6210/pcie_bus.c
index 1099861..58c7916 100644
--- a/drivers/net/wireless/ath/wil6210/pcie_bus.c
+++ b/drivers/net/wireless/ath/wil6210/pcie_bus.c
@@ -27,10 +27,6 @@ MODULE_PARM_DESC(use_msi,
 		 " Use MSI interrupt: "
 		 "0 - don't, 1 - (default) - single, or 3");
 
-static bool debug_fw; /* = false; */
-module_param(debug_fw, bool, S_IRUGO);
-MODULE_PARM_DESC(debug_fw, " load driver if FW not ready. For FW debug");
-
 static
 void wil_set_capabilities(struct wil6210_priv *wil)
 {
@@ -133,8 +129,6 @@ static int wil_if_pcie_enable(struct wil6210_priv *wil)
 	mutex_lock(&wil->mutex);
 	rc = wil_reset(wil, false);
 	mutex_unlock(&wil->mutex);
-	if (debug_fw)
-		rc = 0;
 	if (rc)
 		goto release_irq;
 
diff --git a/drivers/net/wireless/ath/wil6210/wil6210.h b/drivers/net/wireless/ath/wil6210/wil6210.h
index 4310972..f4681e3 100644
--- a/drivers/net/wireless/ath/wil6210/wil6210.h
+++ b/drivers/net/wireless/ath/wil6210/wil6210.h
@@ -29,6 +29,7 @@ extern unsigned short rx_ring_overflow_thrsh;
 extern int agg_wsize;
 extern u32 vring_idle_trsh;
 extern bool rx_align_2;
+extern bool debug_fw;
 
 #define WIL_NAME "wil6210"
 #define WIL_FW_NAME "wil6210.fw" /* code */
-- 
2.1.0

