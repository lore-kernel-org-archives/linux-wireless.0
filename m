Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from sabertooth01.qualcomm.com ([65.197.215.72]:1264 "EHLO
	sabertooth01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1031997AbbKFKut (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 6 Nov 2015 05:50:49 -0500
Cc: Vladimir Kondratiev <QCA_vkondrat@QCA.qualcomm.com>,
	linux-wireless@vger.kernel.org, wil6210@qca.qualcomm.com,
	Maya Erez <qca_merez@qca.qualcomm.com>
From: Maya Erez <qca_merez@qca.qualcomm.com>
To: Kalle Valo <kvalo@codeaurora.org>
Subject: [PATCH v1] wil6210: hold wil->mutex while managing vrings
Date: Fri,  6 Nov 2015 12:50:44 +0200
Message-Id: <1446807044-19341-1-git-send-email-qca_merez@qca.qualcomm.com> (sfid-20151106_115053_835158_80D4845B)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Vladimir Kondratiev <qca_vkondrat@qca.qualcomm.com>

To prevent race when connect flow may run in parallel with
the disconnect event.

Scenario leading to the bug is: while running connect flow on the AP,
STA sends disconnect. log follows.

<7>[  668.736269] wil6210 0000:01:00.0: wlan0: DBG[ WMI]Configure for connection CID 1
<7>[  668.736269] wil6210 0000:01:00.0: wlan0: DBG[MISC]wil_vring_init_tx() max_mpdu_size 2048
<7>[  668.736301] wil6210 0000:01:00.0: wlan0: DBG[MISC]wil_vring_alloc()
<7>[  668.736363] wil6210 0000:01:00.0: wlan0: DBG[MISC]vring[1024] 0xffbe8000:d962ce08 0xdb244000
<7>[  668.736394] wil6210 0000:01:00.0: wlan0: DBG[ WMI]Head 0x00880300 -> 0x00880308
<7>[  668.736394] wil6210 0000:01:00.0: wlan0: DBG[ WMI]WMI command 0x0821 [28]
<7>[  668.736426] DBG[ WMI]Cmd 00000000: 20 00 24 00 00 00 00 00 00 00 21 08 00 00 00 00   .$.......!.....
<7>[  668.736426] DBG[ WMI]cmd 00000000: 00 00 00 00 00 00 5f 5c 00 00 00 00 00 04 00 08  ......_\........
<7>[  668.736457] DBG[ WMI]cmd 00000010: 01 01 00 00 00 00 00 00 00 00 ff 0f              ............
<7>[  668.736488] wil6210 0000:01:00.0: wlan0: DBG[ IRQ]Pseudo IRQ 0x00000004
<7>[  668.736519] wil6210 0000:01:00.0: wlan0: DBG[ WMI]Handle WMI 0x1824 (reply_id 0x1821)
<7>[  668.736519] wil6210 0000:01:00.0: wlan0: DBG[ IRQ]wil6210_mask_irq_pseudo()
<7>[  668.736519] wil6210 0000:01:00.0: wlan0: DBG[ IRQ]ISR MISC 0x20000000
<7>[  668.736551] wil6210 0000:01:00.0: wlan0: DBG[ WMI]Handle WMI 0x1003 (reply_id 0x1821)
<7>[  668.736551] wil6210 0000:01:00.0: wlan0: DBG[ WMI]Disconnect 04:ce:14:00:07:70 reason [proto 3 wmi 4]
<7>[  668.736582] wil6210 0000:01:00.0: wlan0: DBG[MISC]wil6210_disconnect()
<7>[  668.736613] wil6210 0000:01:00.0: wlan0: DBG[ IRQ]Thread IRQ
<7>[  668.736613] wil6210 0000:01:00.0: wlan0: DBG[ IRQ]Thread ISR MISC 0x20000000
<7>[  668.736644] wil6210 0000:01:00.0: wlan0: DBG[ IRQ]MBOX event
<7>[  668.736644] wil6210 0000:01:00.0: wlan0: DBG[ WMI]Mbox head 00880330 tail 00880328
<7>[  668.736676] wil6210 0000:01:00.0: wlan0: DBG[ WMI]Mbox evt 001a 0010 0000 00
<7>[  668.736676] wil6210 0000:01:00.0: wlan0: DBG[ WMI]WMI event 0x1821 MID 0 @3255145 msec
<7>[  668.736707] DBG[ WMI]evt 00000000: 1a 00 10 00 00 00 00 10 00 00 21 18 69 ab 31 00  ..........!.i.1.
<7>[  668.736707] DBG[ WMI]evt 00000010: 01 01 00 00 00 00 00 00                          ........
<7>[  668.736738] wil6210 0000:01:00.0: wlan0: DBG[ WMI]queue_work -> 0
<7>[  668.736738] wil6210 0000:01:00.0: wlan0: DBG[ WMI]wmi_recv_cmd -> 1 events queued
<7>[  668.736769] wil6210 0000:01:00.0: wlan0: DBG[ IRQ]wil6210_unmask_irq_pseudo()
<7>[  668.736832] wil6210 0000:01:00.0: wlan0: DBG[MISC]Disconnect 04:ce:14:00:07:70, CID=1, reason=3
<7>[  668.736832] wil6210 0000:01:00.0: wlan0: DBG[MISC]wil_disconnect_cid(CID 1, status 1)
<7>[  668.736894] wil6210 0000:01:00.0: wlan0: DBG[MISC]wil_vring_fini_tx() id=1
<7>[  668.736894] wil6210 0000:01:00.0: wlan0: DBG[MISC]free Tx vring 1 [1024] 0xffbe8000:d962ce08 0xdb244000
<7>[  668.736957] wil6210 0000:01:00.0: wlan0: DBG[ WMI]Handle WMI 0x1821 (reply_id 0x1821)
<7>[  668.736988] wil6210 0000:01:00.0: wlan0: DBG[ WMI]Complete WMI 0x1821
<7>[  668.737019] wil6210 0000:01:00.0: wlan0: DBG[ WMI]wmi_call(0x0821->0x1821) completed in 0 msec
<3>[  668.737019] wil6210 0000:01:00.0: wlan0: Tx config failed, status 0x01
<7>[  668.739518] wil6210 0000:01:00.0: wlan0: DBG[MISC]wil_cfg80211_del_station(04:ce:14:00:07:70, reason=2)
<7>[  668.739550] wil6210 0000:01:00.0: wlan0: DBG[MISC]wil6210_disconnect()
<7>[  668.739550] wil6210 0000:01:00.0: wlan0: DBG[MISC]_wil6210_disconnect(bssid=04:ce:14:00:07:70, reason=2, ev-)
<7>[  668.739581] wil6210 0000:01:00.0: wlan0: DBG[MISC]Disconnect 04:ce:14:00:07:70, CID=-2, reason=2
<7>[  668.742705] wil6210 0000:01:00.0: wlan0: DBG[MISC]free Tx vring 1 [1024] 0x  (null):d962ce08 0x  (null)
<3>[  668.742736] __dma_free_remap: trying to free invalid coherent area:   (null)

Signed-off-by: Vladimir Kondratiev <qca_vkondrat@qca.qualcomm.com>
Signed-off-by: Maya Erez <qca_merez@qca.qualcomm.com>
---
 drivers/net/wireless/ath/wil6210/main.c | 18 +++++++++++++-----
 drivers/net/wireless/ath/wil6210/txrx.c |  5 ++++-
 2 files changed, 17 insertions(+), 6 deletions(-)

diff --git a/drivers/net/wireless/ath/wil6210/main.c b/drivers/net/wireless/ath/wil6210/main.c
index bb69a59..48687f1 100644
--- a/drivers/net/wireless/ath/wil6210/main.c
+++ b/drivers/net/wireless/ath/wil6210/main.c
@@ -401,20 +401,26 @@ void wil_bcast_fini(struct wil6210_priv *wil)
 
 static void wil_connect_worker(struct work_struct *work)
 {
-	int rc;
+	int rc, cid, ringid;
 	struct wil6210_priv *wil = container_of(work, struct wil6210_priv,
 						connect_worker);
 	struct net_device *ndev = wil_to_ndev(wil);
 
-	int cid = wil->pending_connect_cid;
-	int ringid = wil_find_free_vring(wil);
+	mutex_lock(&wil->mutex);
 
+	cid = wil->pending_connect_cid;
 	if (cid < 0) {
 		wil_err(wil, "No connection pending\n");
-		return;
+		goto out;
+	}
+	ringid = wil_find_free_vring(wil);
+	if (ringid < 0) {
+		wil_err(wil, "No free vring found\n");
+		goto out;
 	}
 
-	wil_dbg_wmi(wil, "Configure for connection CID %d\n", cid);
+	wil_dbg_wmi(wil, "Configure for connection CID %d vring %d\n",
+		    cid, ringid);
 
 	rc = wil_vring_init_tx(wil, ringid, 1 << tx_ring_order, cid, 0);
 	wil->pending_connect_cid = -1;
@@ -424,6 +430,8 @@ static void wil_connect_worker(struct work_struct *work)
 	} else {
 		wil_disconnect_cid(wil, cid, WLAN_REASON_UNSPECIFIED, true);
 	}
+out:
+	mutex_unlock(&wil->mutex);
 }
 
 int wil_priv_init(struct wil6210_priv *wil)
diff --git a/drivers/net/wireless/ath/wil6210/txrx.c b/drivers/net/wireless/ath/wil6210/txrx.c
index 3bc9bc0..7887e6c 100644
--- a/drivers/net/wireless/ath/wil6210/txrx.c
+++ b/drivers/net/wireless/ath/wil6210/txrx.c
@@ -160,6 +160,7 @@ static void wil_vring_free(struct wil6210_priv *wil, struct vring *vring,
 	struct device *dev = wil_to_dev(wil);
 	size_t sz = vring->size * sizeof(vring->va[0]);
 
+	lockdep_assert_held(&wil->mutex);
 	if (tx) {
 		int vring_index = vring - wil->vring_tx;
 
@@ -749,6 +750,7 @@ int wil_vring_init_tx(struct wil6210_priv *wil, int id, int size,
 
 	wil_dbg_misc(wil, "%s() max_mpdu_size %d\n", __func__,
 		     cmd.vring_cfg.tx_sw_ring.max_mpdu_size);
+	lockdep_assert_held(&wil->mutex);
 
 	if (vring->va) {
 		wil_err(wil, "Tx ring [%d] already allocated\n", id);
@@ -821,6 +823,7 @@ int wil_vring_init_bcast(struct wil6210_priv *wil, int id, int size)
 
 	wil_dbg_misc(wil, "%s() max_mpdu_size %d\n", __func__,
 		     cmd.vring_cfg.tx_sw_ring.max_mpdu_size);
+	lockdep_assert_held(&wil->mutex);
 
 	if (vring->va) {
 		wil_err(wil, "Tx ring [%d] already allocated\n", id);
@@ -872,7 +875,7 @@ void wil_vring_fini_tx(struct wil6210_priv *wil, int id)
 	struct vring *vring = &wil->vring_tx[id];
 	struct vring_tx_data *txdata = &wil->vring_tx_data[id];
 
-	WARN_ON(!mutex_is_locked(&wil->mutex));
+	lockdep_assert_held(&wil->mutex);
 
 	if (!vring->va)
 		return;
-- 
1.8.5.2

