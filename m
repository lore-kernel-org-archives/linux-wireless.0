Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine01.qualcomm.com ([199.106.114.254]:52207 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753489AbaLANfR (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 1 Dec 2014 08:35:17 -0500
From: Vladimir Kondratiev <qca_vkondrat@qca.qualcomm.com>
To: "John W . Linville" <linville@tuxdriver.com>
CC: Vladimir Kondratiev <qca_vkondrat@qca.qualcomm.com>,
	<linux-wireless@vger.kernel.org>, <wil6210@qca.qualcomm.com>
Subject: [PATCH 5/9] wil6210: configurable vring sizes
Date: Mon, 1 Dec 2014 15:35:02 +0200
Message-ID: <1417440903-27066-1-git-send-email-qca_vkondrat@qca.qualcomm.com> (sfid-20141201_143522_365111_6B7C6835)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Allow to configure VRING size for both Rx and Tx via module parameters:
rx_ring_order and tx_ring_order. Parameters are ring size orders, i.e.
ring size calculated as 1 << order.
Defaults for both Tx and Rx are order 9, i.e. size 512

Signed-off-by: Vladimir Kondratiev <qca_vkondrat@qca.qualcomm.com>
---
 drivers/net/wireless/ath/wil6210/main.c    | 34 ++++++++++++++++++++++++++++--
 drivers/net/wireless/ath/wil6210/txrx.c    |  4 ++--
 drivers/net/wireless/ath/wil6210/wil6210.h |  9 +++++---
 3 files changed, 40 insertions(+), 7 deletions(-)

diff --git a/drivers/net/wireless/ath/wil6210/main.c b/drivers/net/wireless/ath/wil6210/main.c
index 3bef153..8f257a4 100644
--- a/drivers/net/wireless/ath/wil6210/main.c
+++ b/drivers/net/wireless/ath/wil6210/main.c
@@ -67,6 +67,36 @@ static struct kernel_param_ops mtu_max_ops = {
 module_param_cb(mtu_max, &mtu_max_ops, &mtu_max, S_IRUGO);
 MODULE_PARM_DESC(mtu_max, " Max MTU value.");
 
+static uint rx_ring_order = WIL_RX_RING_SIZE_ORDER_DEFAULT;
+static uint tx_ring_order = WIL_TX_RING_SIZE_ORDER_DEFAULT;
+
+static int ring_order_set(const char *val, const struct kernel_param *kp)
+{
+	int ret;
+	uint x;
+
+	ret = kstrtouint(val, 0, &x);
+	if (ret)
+		return ret;
+
+	if ((x < WIL_RING_SIZE_ORDER_MIN) || (x > WIL_RING_SIZE_ORDER_MAX))
+		return -EINVAL;
+
+	*((uint *)kp->arg) = x;
+
+	return 0;
+}
+
+static struct kernel_param_ops ring_order_ops = {
+	.set = ring_order_set,
+	.get = param_get_uint,
+};
+
+module_param_cb(rx_ring_order, &ring_order_ops, &rx_ring_order, S_IRUGO);
+MODULE_PARM_DESC(rx_ring_order, " Rx ring order; size = 1 << order");
+module_param_cb(tx_ring_order, &ring_order_ops, &tx_ring_order, S_IRUGO);
+MODULE_PARM_DESC(tx_ring_order, " Tx ring order; size = 1 << order");
+
 #define RST_DELAY (20) /* msec, for loop in @wil_target_reset */
 #define RST_COUNT (1 + 1000/RST_DELAY) /* round up to be above 1 sec total */
 
@@ -332,7 +362,7 @@ static void wil_connect_worker(struct work_struct *work)
 
 	wil_dbg_wmi(wil, "Configure for connection CID %d\n", cid);
 
-	rc = wil_vring_init_tx(wil, ringid, WIL6210_TX_RING_SIZE, cid, 0);
+	rc = wil_vring_init_tx(wil, ringid, 1 << tx_ring_order, cid, 0);
 	wil->pending_connect_cid = -1;
 	if (rc == 0) {
 		wil->sta[cid].status = wil_sta_connected;
@@ -705,7 +735,7 @@ int __wil_up(struct wil6210_priv *wil)
 		return rc;
 
 	/* Rx VRING. After MAC and beacon */
-	rc = wil_rx_init(wil);
+	rc = wil_rx_init(wil, 1 << rx_ring_order);
 	if (rc)
 		return rc;
 
diff --git a/drivers/net/wireless/ath/wil6210/txrx.c b/drivers/net/wireless/ath/wil6210/txrx.c
index c680906..c3a5489 100644
--- a/drivers/net/wireless/ath/wil6210/txrx.c
+++ b/drivers/net/wireless/ath/wil6210/txrx.c
@@ -596,7 +596,7 @@ void wil_rx_handle(struct wil6210_priv *wil, int *quota)
 	wil_rx_refill(wil, v->size);
 }
 
-int wil_rx_init(struct wil6210_priv *wil)
+int wil_rx_init(struct wil6210_priv *wil, u16 size)
 {
 	struct vring *vring = &wil->vring_rx;
 	int rc;
@@ -608,7 +608,7 @@ int wil_rx_init(struct wil6210_priv *wil)
 		return -EINVAL;
 	}
 
-	vring->size = WIL6210_RX_RING_SIZE;
+	vring->size = size;
 	rc = wil_vring_alloc(wil, vring);
 	if (rc)
 		return rc;
diff --git a/drivers/net/wireless/ath/wil6210/wil6210.h b/drivers/net/wireless/ath/wil6210/wil6210.h
index 8c09700..c6ec5b9 100644
--- a/drivers/net/wireless/ath/wil6210/wil6210.h
+++ b/drivers/net/wireless/ath/wil6210/wil6210.h
@@ -49,8 +49,11 @@ static inline u32 WIL_GET_BITS(u32 x, int b0, int b1)
 
 #define WIL6210_MEM_SIZE (2*1024*1024UL)
 
-#define WIL6210_RX_RING_SIZE	(128)
-#define WIL6210_TX_RING_SIZE	(512)
+#define WIL_RX_RING_SIZE_ORDER_DEFAULT	(9)
+#define WIL_TX_RING_SIZE_ORDER_DEFAULT	(9)
+/* limit ring size in range [32..32k] */
+#define WIL_RING_SIZE_ORDER_MIN	(5)
+#define WIL_RING_SIZE_ORDER_MAX	(15)
 #define WIL6210_MAX_TX_RINGS	(24) /* HW limit */
 #define WIL6210_MAX_CID		(8) /* HW limit */
 #define WIL6210_NAPI_BUDGET	(16) /* arbitrary */
@@ -590,7 +593,7 @@ int wmi_pcp_stop(struct wil6210_priv *wil);
 void wil6210_disconnect(struct wil6210_priv *wil, const u8 *bssid,
 			u16 reason_code, bool from_event);
 
-int wil_rx_init(struct wil6210_priv *wil);
+int wil_rx_init(struct wil6210_priv *wil, u16 size);
 void wil_rx_fini(struct wil6210_priv *wil);
 
 /* TX API */
-- 
2.1.0

