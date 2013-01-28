Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from sabertooth02.qualcomm.com ([65.197.215.38]:28421 "EHLO
	sabertooth02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753444Ab3A1QiX (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 28 Jan 2013 11:38:23 -0500
Cc: Vladimir Kondratiev <qca_vkondrat@qca.qualcomm.com>,
	<linux-wireless@vger.kernel.org>,
	"Luis R . Rodriguez" <rodrigue@qca.qualcomm.com>
From: Vladimir Kondratiev <qca_vkondrat@qca.qualcomm.com>
To: "John W . Linville" <linville@tuxdriver.com>
Subject: [PATCH 03/14] wil6210: remove raw wil_dbg() calls
Date: Mon, 28 Jan 2013 18:30:58 +0200
Message-ID: <1359390669-9310-4-git-send-email-qca_vkondrat@qca.qualcomm.com> (sfid-20130128_173826_436357_C56EBF0A)
In-Reply-To: <1359390669-9310-1-git-send-email-qca_vkondrat@qca.qualcomm.com>
References: <1359390669-9310-1-git-send-email-qca_vkondrat@qca.qualcomm.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Introduce debug category "MISC", convert all raw wil_dbg() to this category.
This improves dynamic debug manageability

Signed-off-by: Vladimir Kondratiev <qca_vkondrat@qca.qualcomm.com>
---
 drivers/net/wireless/ath/wil6210/cfg80211.c |    8 ++++----
 drivers/net/wireless/ath/wil6210/main.c     |   28 +++++++++++++--------------
 drivers/net/wireless/ath/wil6210/pcie_bus.c |    4 ++--
 drivers/net/wireless/ath/wil6210/txrx.c     |    8 ++++----
 drivers/net/wireless/ath/wil6210/wil6210.h  |    1 +
 5 files changed, 25 insertions(+), 24 deletions(-)

diff --git a/drivers/net/wireless/ath/wil6210/cfg80211.c b/drivers/net/wireless/ath/wil6210/cfg80211.c
index 116f4e8..56f39b6 100644
--- a/drivers/net/wireless/ath/wil6210/cfg80211.c
+++ b/drivers/net/wireless/ath/wil6210/cfg80211.c
@@ -228,8 +228,8 @@ static int wil_cfg80211_scan(struct wiphy *wiphy,
 		}
 		/* 0-based channel indexes */
 		cmd.cmd.channel_list[cmd.cmd.num_channels++].channel = ch - 1;
-		wil_dbg(wil, "Scan for ch %d  : %d MHz\n", ch,
-			request->channels[i]->center_freq);
+		wil_dbg_MISC(wil, "Scan for ch %d  : %d MHz\n", ch,
+			     request->channels[i]->center_freq);
 	}
 
 	return wmi_send(wil, WMI_START_SCAN_CMDID, &cmd, sizeof(cmd.cmd) +
@@ -425,8 +425,8 @@ static int wil_cfg80211_start_ap(struct wiphy *wiphy,
 		return -EINVAL;
 	}
 
-	wil_dbg(wil, "AP on Channel %d %d MHz, %s\n", channel->hw_value,
-		channel->center_freq, info->privacy ? "secure" : "open");
+	wil_dbg_MISC(wil, "AP on Channel %d %d MHz, %s\n", channel->hw_value,
+		     channel->center_freq, info->privacy ? "secure" : "open");
 	print_hex_dump_bytes("SSID ", DUMP_PREFIX_OFFSET,
 			     info->ssid, info->ssid_len);
 
diff --git a/drivers/net/wireless/ath/wil6210/main.c b/drivers/net/wireless/ath/wil6210/main.c
index 95fcd36..90786df 100644
--- a/drivers/net/wireless/ath/wil6210/main.c
+++ b/drivers/net/wireless/ath/wil6210/main.c
@@ -64,7 +64,7 @@ static void _wil6210_disconnect(struct wil6210_priv *wil, void *bssid)
 	struct net_device *ndev = wil_to_ndev(wil);
 	struct wireless_dev *wdev = wil->wdev;
 
-	wil_dbg(wil, "%s()\n", __func__);
+	wil_dbg_MISC(wil, "%s()\n", __func__);
 
 	wil_link_off(wil);
 	clear_bit(wil_status_fwconnected, &wil->status);
@@ -99,7 +99,7 @@ static void wil_connect_timer_fn(ulong x)
 {
 	struct wil6210_priv *wil = (void *)x;
 
-	wil_dbg(wil, "Connect timeout\n");
+	wil_dbg_MISC(wil, "Connect timeout\n");
 
 	/* reschedule to thread context - disconnect won't
 	 * run from atomic context
@@ -109,7 +109,7 @@ static void wil_connect_timer_fn(ulong x)
 
 int wil_priv_init(struct wil6210_priv *wil)
 {
-	wil_dbg(wil, "%s()\n", __func__);
+	wil_dbg_MISC(wil, "%s()\n", __func__);
 
 	mutex_init(&wil->mutex);
 	mutex_init(&wil->wmi_mutex);
@@ -162,7 +162,7 @@ void wil_priv_deinit(struct wil6210_priv *wil)
 
 static void wil_target_reset(struct wil6210_priv *wil)
 {
-	wil_dbg(wil, "Resetting...\n");
+	wil_dbg_MISC(wil, "Resetting...\n");
 
 	/* register write */
 #define W(a, v) iowrite32(v, wil->csr + HOSTADDR(a))
@@ -202,7 +202,7 @@ static void wil_target_reset(struct wil6210_priv *wil)
 
 	msleep(2000);
 
-	wil_dbg(wil, "Reset completed\n");
+	wil_dbg_MISC(wil, "Reset completed\n");
 
 #undef W
 #undef S
@@ -225,8 +225,8 @@ static int wil_wait_for_fw_ready(struct wil6210_priv *wil)
 		wil_err(wil, "Firmware not ready\n");
 		return -ETIME;
 	} else {
-		wil_dbg(wil, "FW ready after %d ms\n",
-			jiffies_to_msecs(to-left));
+		wil_dbg_MISC(wil, "FW ready after %d ms\n",
+			     jiffies_to_msecs(to-left));
 	}
 	return 0;
 }
@@ -278,7 +278,7 @@ void wil_link_on(struct wil6210_priv *wil)
 {
 	struct net_device *ndev = wil_to_ndev(wil);
 
-	wil_dbg(wil, "%s()\n", __func__);
+	wil_dbg_MISC(wil, "%s()\n", __func__);
 
 	netif_carrier_on(ndev);
 	netif_tx_wake_all_queues(ndev);
@@ -288,7 +288,7 @@ void wil_link_off(struct wil6210_priv *wil)
 {
 	struct net_device *ndev = wil_to_ndev(wil);
 
-	wil_dbg(wil, "%s()\n", __func__);
+	wil_dbg_MISC(wil, "%s()\n", __func__);
 
 	netif_tx_stop_all_queues(ndev);
 	netif_carrier_off(ndev);
@@ -311,27 +311,27 @@ static int __wil_up(struct wil6210_priv *wil)
 	wmi_nettype = wil_iftype_nl2wmi(NL80211_IFTYPE_ADHOC);
 	switch (wdev->iftype) {
 	case NL80211_IFTYPE_STATION:
-		wil_dbg(wil, "type: STATION\n");
+		wil_dbg_MISC(wil, "type: STATION\n");
 		bi = 0;
 		ndev->type = ARPHRD_ETHER;
 		break;
 	case NL80211_IFTYPE_AP:
-		wil_dbg(wil, "type: AP\n");
+		wil_dbg_MISC(wil, "type: AP\n");
 		bi = 100;
 		ndev->type = ARPHRD_ETHER;
 		break;
 	case NL80211_IFTYPE_P2P_CLIENT:
-		wil_dbg(wil, "type: P2P_CLIENT\n");
+		wil_dbg_MISC(wil, "type: P2P_CLIENT\n");
 		bi = 0;
 		ndev->type = ARPHRD_ETHER;
 		break;
 	case NL80211_IFTYPE_P2P_GO:
-		wil_dbg(wil, "type: P2P_GO\n");
+		wil_dbg_MISC(wil, "type: P2P_GO\n");
 		bi = 100;
 		ndev->type = ARPHRD_ETHER;
 		break;
 	case NL80211_IFTYPE_MONITOR:
-		wil_dbg(wil, "type: Monitor\n");
+		wil_dbg_MISC(wil, "type: Monitor\n");
 		bi = 0;
 		ndev->type = ARPHRD_IEEE80211_RADIOTAP;
 		/* ARPHRD_IEEE80211 or ARPHRD_IEEE80211_RADIOTAP ? */
diff --git a/drivers/net/wireless/ath/wil6210/pcie_bus.c b/drivers/net/wireless/ath/wil6210/pcie_bus.c
index 0fc83ed..ab1cade 100644
--- a/drivers/net/wireless/ath/wil6210/pcie_bus.c
+++ b/drivers/net/wireless/ath/wil6210/pcie_bus.c
@@ -53,7 +53,7 @@ static int wil_if_pcie_enable(struct wil6210_priv *wil)
 	}
 	wil->n_msi = use_msi;
 	if (wil->n_msi) {
-		wil_dbg(wil, "Setup %d MSI interrupts\n", use_msi);
+		wil_dbg_MISC(wil, "Setup %d MSI interrupts\n", use_msi);
 		rc = pci_enable_msi_block(pdev, wil->n_msi);
 		if (rc && (wil->n_msi == 3)) {
 			wil_err(wil, "3 MSI mode failed, try 1 MSI\n");
@@ -65,7 +65,7 @@ static int wil_if_pcie_enable(struct wil6210_priv *wil)
 			wil->n_msi = 0;
 		}
 	} else {
-		wil_dbg(wil, "MSI interrupts disabled, use INTx\n");
+		wil_dbg_MISC(wil, "MSI interrupts disabled, use INTx\n");
 	}
 
 	rc = wil6210_init_irq(wil, pdev->irq);
diff --git a/drivers/net/wireless/ath/wil6210/txrx.c b/drivers/net/wireless/ath/wil6210/txrx.c
index f29c294..241dd0e 100644
--- a/drivers/net/wireless/ath/wil6210/txrx.c
+++ b/drivers/net/wireless/ath/wil6210/txrx.c
@@ -100,8 +100,8 @@ static int wil_vring_alloc(struct wil6210_priv *wil, struct vring *vring)
 		d->dma.status = TX_DMA_STATUS_DU;
 	}
 
-	wil_dbg(wil, "vring[%d] 0x%p:0x%016llx 0x%p\n", vring->size,
-		vring->va, (unsigned long long)vring->pa, vring->ctx);
+	wil_dbg_MISC(wil, "vring[%d] 0x%p:0x%016llx 0x%p\n", vring->size,
+		     vring->va, (unsigned long long)vring->pa, vring->ctx);
 
 	return 0;
 }
@@ -528,8 +528,8 @@ int wil_rx_init(struct wil6210_priv *wil)
 
 	vring->hwtail = le32_to_cpu(evt.evt.rx_ring_tail_ptr);
 
-	wil_dbg(wil, "Rx init: status %d tail 0x%08x\n",
-		le32_to_cpu(evt.evt.status), vring->hwtail);
+	wil_dbg_MISC(wil, "Rx init: status %d tail 0x%08x\n",
+		     le32_to_cpu(evt.evt.status), vring->hwtail);
 
 	rc = wil_rx_refill(wil, vring->size);
 	if (rc)
diff --git a/drivers/net/wireless/ath/wil6210/wil6210.h b/drivers/net/wireless/ath/wil6210/wil6210.h
index 3bd2447..a9b6f70 100644
--- a/drivers/net/wireless/ath/wil6210/wil6210.h
+++ b/drivers/net/wireless/ath/wil6210/wil6210.h
@@ -275,6 +275,7 @@ struct wil6210_priv {
 #define wil_dbg_IRQ(wil, fmt, arg...) wil_dbg(wil, "DBG[ IRQ]" fmt, ##arg)
 #define wil_dbg_TXRX(wil, fmt, arg...) wil_dbg(wil, "DBG[TXRX]" fmt, ##arg)
 #define wil_dbg_WMI(wil, fmt, arg...) wil_dbg(wil, "DBG[ WMI]" fmt, ##arg)
+#define wil_dbg_MISC(wil, fmt, arg...) wil_dbg(wil, "DBG[MISC]" fmt, ##arg)
 
 #define wil_hex_dump_TXRX(prefix_str, prefix_type, rowsize,	\
 			  groupsize, buf, len, ascii)		\
-- 
1.7.10.4

