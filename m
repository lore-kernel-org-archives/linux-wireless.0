Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine02.qualcomm.com ([199.106.114.251]:16192 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751807AbaIJNfv (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 10 Sep 2014 09:35:51 -0400
From: Vladimir Kondratiev <qca_vkondrat@qca.qualcomm.com>
To: "John W . Linville" <linville@tuxdriver.com>
CC: Vladimir Kondratiev <qca_vkondrat@qca.qualcomm.com>,
	<linux-wireless@vger.kernel.org>, <wil6210@qca.qualcomm.com>
Subject: [PATCH 21/22] wil6210: fix for oops while stopping interface
Date: Wed, 10 Sep 2014 16:34:50 +0300
Message-ID: <1410356091-19219-22-git-send-email-qca_vkondrat@qca.qualcomm.com> (sfid-20140910_153557_290274_FDB6A572)
In-Reply-To: <1410356091-19219-1-git-send-email-qca_vkondrat@qca.qualcomm.com>
References: <1410356091-19219-1-git-send-email-qca_vkondrat@qca.qualcomm.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

When interface stopped while running intensive Rx traffic, the following oops
observed:

[89846.734683] Call trace:
[89846.737117] [<ffffffc00083aa64>] dev_gro_receive+0xac/0x358
[89846.742674] [<ffffffc00083ae94>] napi_gro_receive+0x24/0xa4
[89846.748251] [<ffffffbffc1c2f88>] $x+0xec/0x1f8 [wil6210]         wil_netif_rx_any
[89846.753547] [<ffffffbffc1c4830>] $x+0x34/0x54 [wil6210]          wil_release_reorder_frame
[89846.758755] [<ffffffbffc1c48ac>] wil_release_reorder_frames+0x5c/0x78 [wil6210]
[89846.766044] [<ffffffbffc1c4bf8>] wil_tid_ampdu_rx_free+0x20/0x48 [wil6210]
[89846.772901] [<ffffffbffc1bedc8>] $x+0x190/0x1e8 [wil6210]
[89846.778285] [<ffffffbffc1c0ed4>] wmi_event_worker+0x230/0x2f8 [wil6210]
[89846.784865] [<ffffffc0000b0bc8>] process_one_work+0x278/0x3fc
[89846.790591] [<ffffffc0000b1218>] worker_thread+0x200/0x330
[89846.796060] [<ffffffc0000b6664>] kthread+0xac/0xb8
[89846.800836] Code: b940c661 f9406a62 8b010041 f9400026 (f8636882)
[89846.807008] ---[ end trace d6fdc17cd27d18f6 ]---

Reason is the following: when removing Rx vring
(wil_netdev_ops.ndo_stop -> wil_stop -> wil_down -> __wil_down -> wil_rx_fini),
Rx interrupt occurs. It trigger Rx NAPI, calling wil_rx_handle() that reaps
(already cleaned) buffer, causing skb referring to garbage memory being set into reorder buffer.
Then, network stack trying to access this buffer and fails.

Prevent Rx NAPI from being scheduled if device going to stop. Bit wil_status_napi_en reflects
NAPI enablement state, check it when triggering Rx NAPI.

Testing shows that check for wil_status_napi_en sometimes gets negative, and new error message
get printed - in this case kernel oops would be observed. Original oops is no more reproducible.

This change requires also changes in the AP flows.
Properly enable/disable NAPI for the AP. Make sure Rx VRING is disabled
when resetting target.

For this, promote __wil_up() and __wil_down() to the module scope, and use it
in the relevant flows.

Signed-off-by: Vladimir Kondratiev <qca_vkondrat@qca.qualcomm.com>
---
 drivers/net/wireless/ath/wil6210/cfg80211.c  | 19 ++++++++-----------
 drivers/net/wireless/ath/wil6210/interrupt.c |  9 +++++++--
 drivers/net/wireless/ath/wil6210/main.c      | 25 +++++++++++++------------
 drivers/net/wireless/ath/wil6210/pcie_bus.c  | 23 +++++++++++++++++++++++
 drivers/net/wireless/ath/wil6210/wil6210.h   |  4 ++++
 5 files changed, 55 insertions(+), 25 deletions(-)

diff --git a/drivers/net/wireless/ath/wil6210/cfg80211.c b/drivers/net/wireless/ath/wil6210/cfg80211.c
index 6119ecb..f3a31e8 100644
--- a/drivers/net/wireless/ath/wil6210/cfg80211.c
+++ b/drivers/net/wireless/ath/wil6210/cfg80211.c
@@ -730,12 +730,8 @@ static int wil_cfg80211_start_ap(struct wiphy *wiphy,
 
 	mutex_lock(&wil->mutex);
 
-	rc = wil_reset(wil);
-	if (rc)
-		goto out;
-
-	/* Rx VRING. */
-	rc = wil_rx_init(wil);
+	__wil_down(wil);
+	rc = __wil_up(wil);
 	if (rc)
 		goto out;
 
@@ -743,9 +739,6 @@ static int wil_cfg80211_start_ap(struct wiphy *wiphy,
 	if (rc)
 		goto out;
 
-	/* MAC address - pre-requisite for other commands */
-	wmi_set_mac_address(wil, ndev->dev_addr);
-
 	/* IE's */
 	/* bcon 'head IE's are not relevant for 60g band */
 	/*
@@ -777,7 +770,7 @@ out:
 static int wil_cfg80211_stop_ap(struct wiphy *wiphy,
 				struct net_device *ndev)
 {
-	int rc = 0;
+	int rc, rc1;
 	struct wil6210_priv *wil = wiphy_to_wil(wiphy);
 
 	wil_dbg_misc(wil, "%s()\n", __func__);
@@ -786,8 +779,12 @@ static int wil_cfg80211_stop_ap(struct wiphy *wiphy,
 
 	rc = wmi_pcp_stop(wil);
 
+	__wil_down(wil);
+	rc1 = __wil_up(wil);
+
 	mutex_unlock(&wil->mutex);
-	return rc;
+
+	return min(rc, rc1);
 }
 
 static int wil_cfg80211_del_station(struct wiphy *wiphy,
diff --git a/drivers/net/wireless/ath/wil6210/interrupt.c b/drivers/net/wireless/ath/wil6210/interrupt.c
index d265e7c..7269bac 100644
--- a/drivers/net/wireless/ath/wil6210/interrupt.c
+++ b/drivers/net/wireless/ath/wil6210/interrupt.c
@@ -196,8 +196,13 @@ static irqreturn_t wil6210_irq_rx(int irq, void *cookie)
 		wil_dbg_irq(wil, "RX done\n");
 		isr &= ~BIT_DMA_EP_RX_ICR_RX_DONE;
 		if (test_bit(wil_status_reset_done, &wil->status)) {
-			wil_dbg_txrx(wil, "NAPI(Rx) schedule\n");
-			napi_schedule(&wil->napi_rx);
+			if (test_bit(wil_status_napi_en, &wil->status)) {
+				wil_dbg_txrx(wil, "NAPI(Rx) schedule\n");
+				napi_schedule(&wil->napi_rx);
+			} else {
+				wil_err(wil, "Got Rx interrupt while "
+					"stopping interface\n");
+			}
 		} else {
 			wil_err(wil, "Got Rx interrupt while in reset\n");
 		}
diff --git a/drivers/net/wireless/ath/wil6210/main.c b/drivers/net/wireless/ath/wil6210/main.c
index 8443d82..21667e0 100644
--- a/drivers/net/wireless/ath/wil6210/main.c
+++ b/drivers/net/wireless/ath/wil6210/main.c
@@ -221,10 +221,8 @@ static void wil_fw_error_worker(struct work_struct *work)
 	case NL80211_IFTYPE_MONITOR:
 		wil_info(wil, "fw error recovery started (try %d)...\n",
 			 wil->recovery_count);
-		wil_reset(wil);
-
-		/* need to re-allocate Rx ring after reset */
-		wil_rx_init(wil);
+		__wil_down(wil);
+		__wil_up(wil);
 		break;
 	case NL80211_IFTYPE_AP:
 	case NL80211_IFTYPE_P2P_GO:
@@ -480,13 +478,12 @@ int wil_reset(struct wil6210_priv *wil)
 	wil_dbg_misc(wil, "%s()\n", __func__);
 
 	WARN_ON(!mutex_is_locked(&wil->mutex));
+	WARN_ON(test_bit(wil_status_napi_en, &wil->status));
 
 	cancel_work_sync(&wil->disconnect_worker);
 	wil6210_disconnect(wil, NULL);
 
 	wil->status = 0; /* prevent NAPI from being scheduled */
-	if (test_bit(wil_status_napi_en, &wil->status))
-		napi_synchronize(&wil->napi_rx);
 
 	if (wil->scan_request) {
 		wil_dbg_misc(wil, "Abort scan_request 0x%p\n",
@@ -575,7 +572,7 @@ void wil_link_off(struct wil6210_priv *wil)
 	netif_carrier_off(ndev);
 }
 
-static int __wil_up(struct wil6210_priv *wil)
+int __wil_up(struct wil6210_priv *wil)
 {
 	struct net_device *ndev = wil_to_ndev(wil);
 	struct wireless_dev *wdev = wil->wdev;
@@ -621,7 +618,7 @@ static int __wil_up(struct wil6210_priv *wil)
 	/* MAC address - pre-requisite for other commands */
 	wmi_set_mac_address(wil, ndev->dev_addr);
 
-
+	wil_dbg_misc(wil, "NAPI enable\n");
 	napi_enable(&wil->napi_rx);
 	napi_enable(&wil->napi_tx);
 	set_bit(wil_status_napi_en, &wil->status);
@@ -646,7 +643,7 @@ int wil_up(struct wil6210_priv *wil)
 	return rc;
 }
 
-static int __wil_down(struct wil6210_priv *wil)
+int __wil_down(struct wil6210_priv *wil)
 {
 	int iter = WAIT_FOR_DISCONNECT_TIMEOUT_MS /
 			WAIT_FOR_DISCONNECT_INTERVAL_MS;
@@ -656,9 +653,13 @@ static int __wil_down(struct wil6210_priv *wil)
 	if (wil->platform_ops.bus_request)
 		wil->platform_ops.bus_request(wil->platform_handle, 0);
 
-	clear_bit(wil_status_napi_en, &wil->status);
-	napi_disable(&wil->napi_rx);
-	napi_disable(&wil->napi_tx);
+	wil_disable_irq(wil);
+	if (test_and_clear_bit(wil_status_napi_en, &wil->status)) {
+		napi_disable(&wil->napi_rx);
+		napi_disable(&wil->napi_tx);
+		wil_dbg_misc(wil, "NAPI disable\n");
+	}
+	wil_enable_irq(wil);
 
 	if (wil->scan_request) {
 		wil_dbg_misc(wil, "Abort scan_request 0x%p\n",
diff --git a/drivers/net/wireless/ath/wil6210/pcie_bus.c b/drivers/net/wireless/ath/wil6210/pcie_bus.c
index 264c0f0..66626a8 100644
--- a/drivers/net/wireless/ath/wil6210/pcie_bus.c
+++ b/drivers/net/wireless/ath/wil6210/pcie_bus.c
@@ -17,6 +17,7 @@
 #include <linux/module.h>
 #include <linux/pci.h>
 #include <linux/moduleparam.h>
+#include <linux/interrupt.h>
 
 #include "wil6210.h"
 
@@ -30,6 +31,28 @@ static bool debug_fw; /* = false; */
 module_param(debug_fw, bool, S_IRUGO);
 MODULE_PARM_DESC(debug_fw, " load driver if FW not ready. For FW debug");
 
+void wil_disable_irq(struct wil6210_priv *wil)
+{
+	int irq = wil->pdev->irq;
+
+	disable_irq(irq);
+	if (wil->n_msi == 3) {
+		disable_irq(irq + 1);
+		disable_irq(irq + 2);
+	}
+}
+
+void wil_enable_irq(struct wil6210_priv *wil)
+{
+	int irq = wil->pdev->irq;
+
+	enable_irq(irq);
+	if (wil->n_msi == 3) {
+		enable_irq(irq + 1);
+		enable_irq(irq + 2);
+	}
+}
+
 /* Bus ops */
 static int wil_if_pcie_enable(struct wil6210_priv *wil)
 {
diff --git a/drivers/net/wireless/ath/wil6210/wil6210.h b/drivers/net/wireless/ath/wil6210/wil6210.h
index a540781..0ff0dd9 100644
--- a/drivers/net/wireless/ath/wil6210/wil6210.h
+++ b/drivers/net/wireless/ath/wil6210/wil6210.h
@@ -499,7 +499,9 @@ void wil_fw_error_recovery(struct wil6210_priv *wil);
 void wil_link_on(struct wil6210_priv *wil);
 void wil_link_off(struct wil6210_priv *wil);
 int wil_up(struct wil6210_priv *wil);
+int __wil_up(struct wil6210_priv *wil);
 int wil_down(struct wil6210_priv *wil);
+int __wil_down(struct wil6210_priv *wil);
 void wil_mbox_ring_le2cpus(struct wil6210_mbox_ring *r);
 int wil_find_cid(struct wil6210_priv *wil, const u8 *mac);
 
@@ -534,6 +536,8 @@ int wil6210_init_irq(struct wil6210_priv *wil, int irq);
 void wil6210_fini_irq(struct wil6210_priv *wil, int irq);
 void wil_mask_irq(struct wil6210_priv *wil);
 void wil_unmask_irq(struct wil6210_priv *wil);
+void wil_disable_irq(struct wil6210_priv *wil);
+void wil_enable_irq(struct wil6210_priv *wil);
 int wil_cfg80211_mgmt_tx(struct wiphy *wiphy, struct wireless_dev *wdev,
 			 struct cfg80211_mgmt_tx_params *params,
 			 u64 *cookie);
-- 
1.9.1

