Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine02.qualcomm.com ([199.106.114.251]:35587 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754324AbaJ1OwC (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 28 Oct 2014 10:52:02 -0400
From: Vladimir Kondratiev <qca_vkondrat@qca.qualcomm.com>
To: "John W . Linville" <linville@tuxdriver.com>
CC: Vladimir Kondratiev <qca_vkondrat@qca.qualcomm.com>,
	<linux-wireless@vger.kernel.org>, <wil6210@qca.qualcomm.com>
Subject: [PATCH 5/5] wil6210: Add support for large packets
Date: Tue, 28 Oct 2014 16:51:27 +0200
Message-ID: <1414507887-23226-1-git-send-email-qca_vkondrat@qca.qualcomm.com> (sfid-20141028_155212_806892_28B7DCF8)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

It is possible to configure driver using mtu_max module parameter
by setting it to value in range of 68..7920 inclusive.
This is sub-optimal performance-wise in case packet is larger than 1 page.
mtu_max default value is 2228.

Signed-off-by: Vladimir Kondratiev <qca_vkondrat@qca.qualcomm.com>
---
 drivers/net/wireless/ath/wil6210/main.c    | 29 +++++++++++++++++++++++++++++
 drivers/net/wireless/ath/wil6210/netdev.c  |  2 +-
 drivers/net/wireless/ath/wil6210/txrx.c    |  7 ++++---
 drivers/net/wireless/ath/wil6210/txrx.h    |  4 ++--
 drivers/net/wireless/ath/wil6210/wil6210.h |  1 +
 drivers/net/wireless/ath/wil6210/wmi.c     |  2 +-
 6 files changed, 38 insertions(+), 7 deletions(-)

diff --git a/drivers/net/wireless/ath/wil6210/main.c b/drivers/net/wireless/ath/wil6210/main.c
index 92705c0..6212983 100644
--- a/drivers/net/wireless/ath/wil6210/main.c
+++ b/drivers/net/wireless/ath/wil6210/main.c
@@ -38,6 +38,35 @@ static unsigned int itr_trsh = WIL6210_ITR_TRSH_DEFAULT;
 module_param(itr_trsh, uint, S_IRUGO);
 MODULE_PARM_DESC(itr_trsh, " Interrupt moderation threshold, usecs.");
 
+/* We allow allocation of more than 1 page buffers to support large packets.
+ * It is suboptimal behavior performance wise in case MTU above page size.
+ */
+unsigned int mtu_max = TXRX_BUF_LEN_DEFAULT - ETH_HLEN;
+static int mtu_max_set(const char *val, const struct kernel_param *kp)
+{
+	int ret;
+
+	/* sets mtu_max directly. no need to restore it in case of
+	 * illegal value since we assume this will fail insmod
+	 */
+	ret = param_set_uint(val, kp);
+	if (ret)
+		return ret;
+
+	if (mtu_max < 68 || mtu_max > IEEE80211_MAX_DATA_LEN_DMG)
+		ret = -EINVAL;
+
+	return ret;
+}
+
+static struct kernel_param_ops mtu_max_ops = {
+	.set = mtu_max_set,
+	.get = param_get_uint,
+};
+
+module_param_cb(mtu_max, &mtu_max_ops, &mtu_max, S_IRUGO);
+MODULE_PARM_DESC(mtu_max, " Max MTU value.");
+
 #define RST_DELAY (20) /* msec, for loop in @wil_target_reset */
 #define RST_COUNT (1 + 1000/RST_DELAY) /* round up to be above 1 sec total */
 
diff --git a/drivers/net/wireless/ath/wil6210/netdev.c b/drivers/net/wireless/ath/wil6210/netdev.c
index 2399651..e81703c 100644
--- a/drivers/net/wireless/ath/wil6210/netdev.c
+++ b/drivers/net/wireless/ath/wil6210/netdev.c
@@ -41,7 +41,7 @@ static int wil_change_mtu(struct net_device *ndev, int new_mtu)
 {
 	struct wil6210_priv *wil = ndev_to_wil(ndev);
 
-	if (new_mtu < 68 || new_mtu > (TX_BUF_LEN - ETH_HLEN)) {
+	if (new_mtu < 68 || new_mtu > mtu_max) {
 		wil_err(wil, "invalid MTU %d\n", new_mtu);
 		return -EINVAL;
 	}
diff --git a/drivers/net/wireless/ath/wil6210/txrx.c b/drivers/net/wireless/ath/wil6210/txrx.c
index 2936ef0..c680906 100644
--- a/drivers/net/wireless/ath/wil6210/txrx.c
+++ b/drivers/net/wireless/ath/wil6210/txrx.c
@@ -206,7 +206,7 @@ static int wil_vring_alloc_skb(struct wil6210_priv *wil, struct vring *vring,
 			       u32 i, int headroom)
 {
 	struct device *dev = wil_to_dev(wil);
-	unsigned int sz = RX_BUF_LEN;
+	unsigned int sz = mtu_max + ETH_HLEN;
 	struct vring_rx_desc dd, *d = &dd;
 	volatile struct vring_rx_desc *_d = &vring->va[i].rx;
 	dma_addr_t pa;
@@ -385,7 +385,7 @@ static struct sk_buff *wil_vring_reap_rx(struct wil6210_priv *wil,
 	struct vring_rx_desc *d;
 	struct sk_buff *skb;
 	dma_addr_t pa;
-	unsigned int sz = RX_BUF_LEN;
+	unsigned int sz = mtu_max + ETH_HLEN;
 	u16 dmalen;
 	u8 ftype;
 	u8 ds_bits;
@@ -646,7 +646,8 @@ int wil_vring_init_tx(struct wil6210_priv *wil, int id, int size,
 		.action = cpu_to_le32(WMI_VRING_CMD_ADD),
 		.vring_cfg = {
 			.tx_sw_ring = {
-				.max_mpdu_size = cpu_to_le16(TX_BUF_LEN),
+				.max_mpdu_size =
+					cpu_to_le16(mtu_max + ETH_HLEN),
 				.ring_size = cpu_to_le16(size),
 			},
 			.ringid = id,
diff --git a/drivers/net/wireless/ath/wil6210/txrx.h b/drivers/net/wireless/ath/wil6210/txrx.h
index de04671..630aeb5 100644
--- a/drivers/net/wireless/ath/wil6210/txrx.h
+++ b/drivers/net/wireless/ath/wil6210/txrx.h
@@ -21,8 +21,8 @@
 #define BUF_HW_OWNED    (0)
 
 /* size of max. Tx/Rx buffers, as supported by FW */
-#define RX_BUF_LEN      (2242)
-#define TX_BUF_LEN      (2242)
+#define TXRX_BUF_LEN_DEFAULT (2242)
+
 /* how many bytes to reserve for rtap header? */
 #define WIL6210_RTAP_SIZE (128)
 
diff --git a/drivers/net/wireless/ath/wil6210/wil6210.h b/drivers/net/wireless/ath/wil6210/wil6210.h
index 3674e27..95d3a06 100644
--- a/drivers/net/wireless/ath/wil6210/wil6210.h
+++ b/drivers/net/wireless/ath/wil6210/wil6210.h
@@ -24,6 +24,7 @@
 #include "wil_platform.h"
 
 extern bool no_fw_recovery;
+extern unsigned int mtu_max;
 
 #define WIL_NAME "wil6210"
 #define WIL_FW_NAME "wil6210.fw"
diff --git a/drivers/net/wireless/ath/wil6210/wmi.c b/drivers/net/wireless/ath/wil6210/wmi.c
index 9661fa1..bb1e066 100644
--- a/drivers/net/wireless/ath/wil6210/wmi.c
+++ b/drivers/net/wireless/ath/wil6210/wmi.c
@@ -1025,7 +1025,7 @@ int wmi_rx_chain_add(struct wil6210_priv *wil, struct vring *vring)
 	struct wmi_cfg_rx_chain_cmd cmd = {
 		.action = WMI_RX_CHAIN_ADD,
 		.rx_sw_ring = {
-			.max_mpdu_size = cpu_to_le16(RX_BUF_LEN),
+			.max_mpdu_size = cpu_to_le16(mtu_max + ETH_HLEN),
 			.ring_mem_base = cpu_to_le64(vring->pa),
 			.ring_size = cpu_to_le16(vring->size),
 		},
-- 
2.1.0

