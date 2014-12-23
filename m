Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine02.qualcomm.com ([199.106.114.251]:21144 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754823AbaLWHsd (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 23 Dec 2014 02:48:33 -0500
From: Vladimir Kondratiev <QCA_vkondrat@QCA.qualcomm.com>
Cc: Vladimir Kondratiev <QCA_vkondrat@QCA.qualcomm.com>,
	linux-wireless@vger.kernel.org, wil6210@qca.qualcomm.com
To: Kalle Valo <kvalo@qca.qualcomm.com>
Subject: [PATCH 12/22] wil6210: use bitmap API for "status"
Date: Tue, 23 Dec 2014 09:47:14 +0200
Message-Id: <1419320844-23989-13-git-send-email-qca_vkondrat@qca.qualcomm.com> (sfid-20141223_091349_264261_2991574A)
In-Reply-To: <1419320844-23989-1-git-send-email-qca_vkondrat@qca.qualcomm.com>
References: <1419320844-23989-1-git-send-email-qca_vkondrat@qca.qualcomm.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

wil->status used as bitmap; use DECLARE_BITMAP for it.

Signed-off-by: Vladimir Kondratiev <qca_vkondrat@qca.qualcomm.com>
---
 drivers/net/wireless/ath/wil6210/cfg80211.c  | 12 ++++++------
 drivers/net/wireless/ath/wil6210/debugfs.c   |  2 +-
 drivers/net/wireless/ath/wil6210/interrupt.c | 16 ++++++++--------
 drivers/net/wireless/ath/wil6210/main.c      | 27 ++++++++++++++-------------
 drivers/net/wireless/ath/wil6210/txrx.c      |  6 +++---
 drivers/net/wireless/ath/wil6210/wil6210.h   |  3 ++-
 drivers/net/wireless/ath/wil6210/wmi.c       | 12 ++++++------
 7 files changed, 40 insertions(+), 38 deletions(-)

diff --git a/drivers/net/wireless/ath/wil6210/cfg80211.c b/drivers/net/wireless/ath/wil6210/cfg80211.c
index 38332a6..5c79f1d 100644
--- a/drivers/net/wireless/ath/wil6210/cfg80211.c
+++ b/drivers/net/wireless/ath/wil6210/cfg80211.c
@@ -162,7 +162,7 @@ int wil_cid_fill_sinfo(struct wil6210_priv *wil, int cid,
 	sinfo->tx_packets = stats->tx_packets;
 	sinfo->tx_failed = stats->tx_errors;
 
-	if (test_bit(wil_status_fwconnected, &wil->status)) {
+	if (test_bit(wil_status_fwconnected, wil->status)) {
 		sinfo->filled |= STATION_INFO_SIGNAL;
 		sinfo->signal = reply.evt.sqi;
 	}
@@ -282,7 +282,7 @@ static int wil_cfg80211_scan(struct wiphy *wiphy,
 	}
 
 	/* FW don't support scan after connection attempt */
-	if (test_bit(wil_status_dontscan, &wil->status)) {
+	if (test_bit(wil_status_dontscan, wil->status)) {
 		wil_err(wil, "Can't scan now\n");
 		return -EBUSY;
 	}
@@ -362,8 +362,8 @@ static int wil_cfg80211_connect(struct wiphy *wiphy,
 	int ch;
 	int rc = 0;
 
-	if (test_bit(wil_status_fwconnecting, &wil->status) ||
-	    test_bit(wil_status_fwconnected, &wil->status))
+	if (test_bit(wil_status_fwconnecting, wil->status) ||
+	    test_bit(wil_status_fwconnected, wil->status))
 		return -EALREADY;
 
 	wil_print_connect_params(wil, sme);
@@ -450,7 +450,7 @@ static int wil_cfg80211_connect(struct wiphy *wiphy,
 	memcpy(conn.bssid, bss->bssid, ETH_ALEN);
 	memcpy(conn.dst_mac, bss->bssid, ETH_ALEN);
 
-	set_bit(wil_status_fwconnecting, &wil->status);
+	set_bit(wil_status_fwconnecting, wil->status);
 
 	rc = wmi_send(wil, WMI_CONNECT_CMDID, &conn, sizeof(conn));
 	if (rc == 0) {
@@ -458,7 +458,7 @@ static int wil_cfg80211_connect(struct wiphy *wiphy,
 		mod_timer(&wil->connect_timer,
 			  jiffies + msecs_to_jiffies(2000));
 	} else {
-		clear_bit(wil_status_fwconnecting, &wil->status);
+		clear_bit(wil_status_fwconnecting, wil->status);
 	}
 
  out:
diff --git a/drivers/net/wireless/ath/wil6210/debugfs.c b/drivers/net/wireless/ath/wil6210/debugfs.c
index 316c7c1..338a811 100644
--- a/drivers/net/wireless/ath/wil6210/debugfs.c
+++ b/drivers/net/wireless/ath/wil6210/debugfs.c
@@ -1313,7 +1313,7 @@ static void wil6210_debugfs_init_isr(struct wil6210_priv *wil,
 /* fields in struct wil6210_priv */
 static const struct dbg_off dbg_wil_off[] = {
 	WIL_FIELD(secure_pcp,	S_IRUGO | S_IWUSR,	doff_u32),
-	WIL_FIELD(status,	S_IRUGO | S_IWUSR,	doff_ulong),
+	WIL_FIELD(status[0],	S_IRUGO | S_IWUSR,	doff_ulong),
 	WIL_FIELD(fw_version,	S_IRUGO,		doff_u32),
 	WIL_FIELD(hw_version,	S_IRUGO,		doff_x32),
 	WIL_FIELD(recovery_count, S_IRUGO,		doff_u32),
diff --git a/drivers/net/wireless/ath/wil6210/interrupt.c b/drivers/net/wireless/ath/wil6210/interrupt.c
index 4bcbd62..5a0ea72 100644
--- a/drivers/net/wireless/ath/wil6210/interrupt.c
+++ b/drivers/net/wireless/ath/wil6210/interrupt.c
@@ -102,7 +102,7 @@ static void wil6210_mask_irq_pseudo(struct wil6210_priv *wil)
 	iowrite32(WIL6210_IRQ_DISABLE, wil->csr +
 		  HOSTADDR(RGF_DMA_PSEUDO_CAUSE_MASK_SW));
 
-	clear_bit(wil_status_irqen, &wil->status);
+	clear_bit(wil_status_irqen, wil->status);
 }
 
 void wil6210_unmask_irq_tx(struct wil6210_priv *wil)
@@ -130,7 +130,7 @@ static void wil6210_unmask_irq_pseudo(struct wil6210_priv *wil)
 {
 	wil_dbg_irq(wil, "%s()\n", __func__);
 
-	set_bit(wil_status_irqen, &wil->status);
+	set_bit(wil_status_irqen, wil->status);
 
 	iowrite32(WIL6210_IRQ_PSEUDO_MASK, wil->csr +
 		  HOSTADDR(RGF_DMA_PSEUDO_CAUSE_MASK_SW));
@@ -198,8 +198,8 @@ static irqreturn_t wil6210_irq_rx(int irq, void *cookie)
 				"of overflow\" interrupt\n");
 
 		isr &= ~(BIT_DMA_EP_RX_ICR_RX_DONE | BIT_DMA_EP_RX_ICR_RX_HTRSH);
-		if (test_bit(wil_status_reset_done, &wil->status)) {
-			if (test_bit(wil_status_napi_en, &wil->status)) {
+		if (test_bit(wil_status_reset_done, wil->status)) {
+			if (test_bit(wil_status_napi_en, wil->status)) {
 				wil_dbg_txrx(wil, "NAPI(Rx) schedule\n");
 				need_unmask = false;
 				napi_schedule(&wil->napi_rx);
@@ -248,7 +248,7 @@ static irqreturn_t wil6210_irq_tx(int irq, void *cookie)
 		isr &= ~BIT_DMA_EP_TX_ICR_TX_DONE;
 		/* clear also all VRING interrupts */
 		isr &= ~(BIT(25) - 1UL);
-		if (test_bit(wil_status_reset_done, &wil->status)) {
+		if (test_bit(wil_status_reset_done, wil->status)) {
 			wil_dbg_txrx(wil, "NAPI(Tx) schedule\n");
 			need_unmask = false;
 			napi_schedule(&wil->napi_tx);
@@ -310,7 +310,7 @@ static irqreturn_t wil6210_irq_misc(int irq, void *cookie)
 
 	if (isr & ISR_MISC_FW_ERROR) {
 		wil_err(wil, "Firmware error detected\n");
-		clear_bit(wil_status_fwready, &wil->status);
+		clear_bit(wil_status_fwready, wil->status);
 		/*
 		 * do not clear @isr here - we do 2-nd part in thread
 		 * there, user space get notified, and it should be done
@@ -321,7 +321,7 @@ static irqreturn_t wil6210_irq_misc(int irq, void *cookie)
 	if (isr & ISR_MISC_FW_READY) {
 		wil_dbg_irq(wil, "IRQ: FW ready\n");
 		wil_cache_mbox_regs(wil);
-		set_bit(wil_status_reset_done, &wil->status);
+		set_bit(wil_status_reset_done, wil->status);
 		/**
 		 * Actual FW ready indicated by the
 		 * WMI_FW_READY_EVENTID
@@ -394,7 +394,7 @@ static irqreturn_t wil6210_thread_irq(int irq, void *cookie)
  */
 static int wil6210_debug_irq_mask(struct wil6210_priv *wil, u32 pseudo_cause)
 {
-	if (!test_bit(wil_status_irqen, &wil->status)) {
+	if (!test_bit(wil_status_irqen, wil->status)) {
 		u32 icm_rx = wil_ioread32_and_clear(wil->csr +
 				HOSTADDR(RGF_DMA_EP_RX_ICR) +
 				offsetof(struct RGF_ICR, ICM));
diff --git a/drivers/net/wireless/ath/wil6210/main.c b/drivers/net/wireless/ath/wil6210/main.c
index 71ebbc1..a17278f 100644
--- a/drivers/net/wireless/ath/wil6210/main.c
+++ b/drivers/net/wireless/ath/wil6210/main.c
@@ -217,16 +217,16 @@ static void _wil6210_disconnect(struct wil6210_priv *wil, const u8 *bssid,
 	case NL80211_IFTYPE_STATION:
 	case NL80211_IFTYPE_P2P_CLIENT:
 		wil_link_off(wil);
-		if (test_bit(wil_status_fwconnected, &wil->status)) {
-			clear_bit(wil_status_fwconnected, &wil->status);
+		if (test_bit(wil_status_fwconnected, wil->status)) {
+			clear_bit(wil_status_fwconnected, wil->status);
 			cfg80211_disconnected(ndev, reason_code,
 					      NULL, 0, GFP_KERNEL);
-		} else if (test_bit(wil_status_fwconnecting, &wil->status)) {
+		} else if (test_bit(wil_status_fwconnecting, wil->status)) {
 			cfg80211_connect_result(ndev, bssid, NULL, 0, NULL, 0,
 						WLAN_STATUS_UNSPECIFIED_FAILURE,
 						GFP_KERNEL);
 		}
-		clear_bit(wil_status_fwconnecting, &wil->status);
+		clear_bit(wil_status_fwconnecting, wil->status);
 		break;
 	default:
 		break;
@@ -259,7 +259,7 @@ static void wil_scan_timer_fn(ulong x)
 {
 	struct wil6210_priv *wil = (void *)x;
 
-	clear_bit(wil_status_fwready, &wil->status);
+	clear_bit(wil_status_fwready, wil->status);
 	wil_err(wil, "Scan timeout detected, start fw error recovery\n");
 	wil->recovery_state = fw_recovery_pending;
 	schedule_work(&wil->fw_error_worker);
@@ -654,12 +654,13 @@ int wil_reset(struct wil6210_priv *wil)
 	wil_dbg_misc(wil, "%s()\n", __func__);
 
 	WARN_ON(!mutex_is_locked(&wil->mutex));
-	WARN_ON(test_bit(wil_status_napi_en, &wil->status));
+	WARN_ON(test_bit(wil_status_napi_en, wil->status));
 
 	cancel_work_sync(&wil->disconnect_worker);
 	wil6210_disconnect(wil, NULL, WLAN_REASON_DEAUTH_LEAVING, false);
 
-	wil->status = 0; /* prevent NAPI from being scheduled */
+	/* prevent NAPI from being scheduled */
+	bitmap_zero(wil->status, wil_status_last);
 
 	if (wil->scan_request) {
 		wil_dbg_misc(wil, "Abort scan_request 0x%p\n",
@@ -798,7 +799,7 @@ int __wil_up(struct wil6210_priv *wil)
 	wil_dbg_misc(wil, "NAPI enable\n");
 	napi_enable(&wil->napi_rx);
 	napi_enable(&wil->napi_tx);
-	set_bit(wil_status_napi_en, &wil->status);
+	set_bit(wil_status_napi_en, wil->status);
 
 	if (wil->platform_ops.bus_request)
 		wil->platform_ops.bus_request(wil->platform_handle,
@@ -831,7 +832,7 @@ int __wil_down(struct wil6210_priv *wil)
 		wil->platform_ops.bus_request(wil->platform_handle, 0);
 
 	wil_disable_irq(wil);
-	if (test_and_clear_bit(wil_status_napi_en, &wil->status)) {
+	if (test_and_clear_bit(wil_status_napi_en, wil->status)) {
 		napi_disable(&wil->napi_rx);
 		napi_disable(&wil->napi_tx);
 		wil_dbg_misc(wil, "NAPI disable\n");
@@ -846,15 +847,15 @@ int __wil_down(struct wil6210_priv *wil)
 		wil->scan_request = NULL;
 	}
 
-	if (test_bit(wil_status_fwconnected, &wil->status) ||
-	    test_bit(wil_status_fwconnecting, &wil->status))
+	if (test_bit(wil_status_fwconnected, wil->status) ||
+	    test_bit(wil_status_fwconnecting, wil->status))
 		wmi_send(wil, WMI_DISCONNECT_CMDID, NULL, 0);
 
 	/* make sure wil is idle (not connected) */
 	mutex_unlock(&wil->mutex);
 	while (iter--) {
-		int idle = !test_bit(wil_status_fwconnected, &wil->status) &&
-			   !test_bit(wil_status_fwconnecting, &wil->status);
+		int idle = !test_bit(wil_status_fwconnected, wil->status) &&
+			   !test_bit(wil_status_fwconnecting, wil->status);
 		if (idle)
 			break;
 		msleep(WAIT_FOR_DISCONNECT_INTERVAL_MS);
diff --git a/drivers/net/wireless/ath/wil6210/txrx.c b/drivers/net/wireless/ath/wil6210/txrx.c
index f33ea57..33961ca 100644
--- a/drivers/net/wireless/ath/wil6210/txrx.c
+++ b/drivers/net/wireless/ath/wil6210/txrx.c
@@ -726,7 +726,7 @@ void wil_vring_fini_tx(struct wil6210_priv *wil, int id)
 
 	/* make sure NAPI won't touch this vring */
 	wil->vring_tx_data[id].enabled = 0;
-	if (test_bit(wil_status_napi_en, &wil->status))
+	if (test_bit(wil_status_napi_en, wil->status))
 		napi_synchronize(&wil->napi_tx);
 
 	wil_vring_free(wil, vring, 1);
@@ -1038,14 +1038,14 @@ netdev_tx_t wil_start_xmit(struct sk_buff *skb, struct net_device *ndev)
 	int rc;
 
 	wil_dbg_txrx(wil, "%s()\n", __func__);
-	if (!test_bit(wil_status_fwready, &wil->status)) {
+	if (!test_bit(wil_status_fwready, wil->status)) {
 		if (!pr_once_fw) {
 			wil_err(wil, "FW not ready\n");
 			pr_once_fw = true;
 		}
 		goto drop;
 	}
-	if (!test_bit(wil_status_fwconnected, &wil->status)) {
+	if (!test_bit(wil_status_fwconnected, wil->status)) {
 		wil_err(wil, "FW not connected\n");
 		goto drop;
 	}
diff --git a/drivers/net/wireless/ath/wil6210/wil6210.h b/drivers/net/wireless/ath/wil6210/wil6210.h
index 81309dc..64a6d49 100644
--- a/drivers/net/wireless/ath/wil6210/wil6210.h
+++ b/drivers/net/wireless/ath/wil6210/wil6210.h
@@ -341,6 +341,7 @@ enum { /* for wil6210_priv.status */
 	wil_status_reset_done,
 	wil_status_irqen, /* FIXME: interrupts enabled - for debug */
 	wil_status_napi_en, /* NAPI enabled protected by wil->mutex */
+	wil_status_last /* keep last */
 };
 
 struct pci_dev;
@@ -448,7 +449,7 @@ struct wil6210_priv {
 	int n_msi;
 	struct wireless_dev *wdev;
 	void __iomem *csr;
-	ulong status;
+	DECLARE_BITMAP(status, wil_status_last);
 	u32 fw_version;
 	u32 hw_version;
 	struct wil_board *board;
diff --git a/drivers/net/wireless/ath/wil6210/wmi.c b/drivers/net/wireless/ath/wil6210/wmi.c
index 245215a..a4b30a4 100644
--- a/drivers/net/wireless/ath/wil6210/wmi.c
+++ b/drivers/net/wireless/ath/wil6210/wmi.c
@@ -202,7 +202,7 @@ static int __wmi_send(struct wil6210_priv *wil, u16 cmdid, void *buf, u16 len)
 
 	might_sleep();
 
-	if (!test_bit(wil_status_fwready, &wil->status)) {
+	if (!test_bit(wil_status_fwready, wil->status)) {
 		wil_err(wil, "WMI: cannot send command while FW not ready\n");
 		return -EAGAIN;
 	}
@@ -305,7 +305,7 @@ static void wmi_evt_fw_ready(struct wil6210_priv *wil, int id, void *d,
 	wil_dbg_wmi(wil, "WMI: got FW ready event\n");
 
 	wil_set_recovery_state(wil, fw_recovery_idle);
-	set_bit(wil_status_fwready, &wil->status);
+	set_bit(wil_status_fwready, wil->status);
 	/* let the reset sequence continue */
 	complete(&wil->wmi_ready);
 }
@@ -443,7 +443,7 @@ static void wmi_evt_connect(struct wil6210_priv *wil, int id, void *d, int len)
 
 	if ((wdev->iftype == NL80211_IFTYPE_STATION) ||
 	    (wdev->iftype == NL80211_IFTYPE_P2P_CLIENT)) {
-		if (!test_bit(wil_status_fwconnecting, &wil->status)) {
+		if (!test_bit(wil_status_fwconnecting, wil->status)) {
 			wil_err(wil, "Not in connecting state\n");
 			return;
 		}
@@ -467,8 +467,8 @@ static void wmi_evt_connect(struct wil6210_priv *wil, int id, void *d, int len)
 
 		cfg80211_new_sta(ndev, evt->bssid, &sinfo, GFP_KERNEL);
 	}
-	clear_bit(wil_status_fwconnecting, &wil->status);
-	set_bit(wil_status_fwconnected, &wil->status);
+	clear_bit(wil_status_fwconnecting, wil->status);
+	set_bit(wil_status_fwconnected, wil->status);
 
 	/* FIXME FW can transmit only ucast frames to peer */
 	/* FIXME real ring_id instead of hard coded 0 */
@@ -726,7 +726,7 @@ void wmi_recv_cmd(struct wil6210_priv *wil)
 	ulong flags;
 	unsigned n;
 
-	if (!test_bit(wil_status_reset_done, &wil->status)) {
+	if (!test_bit(wil_status_reset_done, wil->status)) {
 		wil_err(wil, "Reset in progress. Cannot handle WMI event\n");
 		return;
 	}
-- 
2.1.0

