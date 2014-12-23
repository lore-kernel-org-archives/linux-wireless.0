Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine02.qualcomm.com ([199.106.114.251]:17835 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754911AbaLWHsJ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 23 Dec 2014 02:48:09 -0500
From: Vladimir Kondratiev <QCA_vkondrat@QCA.qualcomm.com>
Cc: Vladimir Kondratiev <QCA_vkondrat@QCA.qualcomm.com>,
	linux-wireless@vger.kernel.org, wil6210@qca.qualcomm.com
To: Kalle Valo <kvalo@qca.qualcomm.com>
Subject: [PATCH 09/22] wil6210: fix max. MPDU size
Date: Tue, 23 Dec 2014 09:47:11 +0200
Message-Id: <1419320844-23989-10-git-send-email-qca_vkondrat@qca.qualcomm.com> (sfid-20141223_091347_788780_6C0A7C01)
In-Reply-To: <1419320844-23989-1-git-send-email-qca_vkondrat@qca.qualcomm.com>
References: <1419320844-23989-1-git-send-email-qca_vkondrat@qca.qualcomm.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

When configuring Tx/Rx VRING's, driver need to specify max. MPDU size
It should take into account all overhead introduced by 802.3->208.11
transformation.

Signed-off-by: Vladimir Kondratiev <qca_vkondrat@qca.qualcomm.com>
---
 drivers/net/wireless/ath/wil6210/main.c    |  2 +-
 drivers/net/wireless/ath/wil6210/txrx.c    |  2 +-
 drivers/net/wireless/ath/wil6210/txrx.h    |  4 ++--
 drivers/net/wireless/ath/wil6210/wil6210.h | 12 +++++++++++-
 drivers/net/wireless/ath/wil6210/wmi.c     |  2 +-
 5 files changed, 16 insertions(+), 6 deletions(-)

diff --git a/drivers/net/wireless/ath/wil6210/main.c b/drivers/net/wireless/ath/wil6210/main.c
index 18a2eb5..0af51fc 100644
--- a/drivers/net/wireless/ath/wil6210/main.c
+++ b/drivers/net/wireless/ath/wil6210/main.c
@@ -41,7 +41,7 @@ MODULE_PARM_DESC(itr_trsh, " Interrupt moderation threshold, usecs.");
 /* We allow allocation of more than 1 page buffers to support large packets.
  * It is suboptimal behavior performance wise in case MTU above page size.
  */
-unsigned int mtu_max = TXRX_BUF_LEN_DEFAULT - ETH_HLEN;
+unsigned int mtu_max = TXRX_BUF_LEN_DEFAULT - WIL_MAX_MPDU_OVERHEAD;
 static int mtu_max_set(const char *val, const struct kernel_param *kp)
 {
 	int ret;
diff --git a/drivers/net/wireless/ath/wil6210/txrx.c b/drivers/net/wireless/ath/wil6210/txrx.c
index b7ffcfb..f33ea57 100644
--- a/drivers/net/wireless/ath/wil6210/txrx.c
+++ b/drivers/net/wireless/ath/wil6210/txrx.c
@@ -645,7 +645,7 @@ int wil_vring_init_tx(struct wil6210_priv *wil, int id, int size,
 		.vring_cfg = {
 			.tx_sw_ring = {
 				.max_mpdu_size =
-					cpu_to_le16(mtu_max + ETH_HLEN),
+					cpu_to_le16(wil_mtu2macbuf(mtu_max)),
 				.ring_size = cpu_to_le16(size),
 			},
 			.ringid = id,
diff --git a/drivers/net/wireless/ath/wil6210/txrx.h b/drivers/net/wireless/ath/wil6210/txrx.h
index 630aeb5..e7db356 100644
--- a/drivers/net/wireless/ath/wil6210/txrx.h
+++ b/drivers/net/wireless/ath/wil6210/txrx.h
@@ -20,8 +20,8 @@
 #define BUF_SW_OWNED    (1)
 #define BUF_HW_OWNED    (0)
 
-/* size of max. Tx/Rx buffers, as supported by FW */
-#define TXRX_BUF_LEN_DEFAULT (2242)
+/* default size of MAC Tx/Rx buffers */
+#define TXRX_BUF_LEN_DEFAULT (2048)
 
 /* how many bytes to reserve for rtap header? */
 #define WIL6210_RTAP_SIZE (128)
diff --git a/drivers/net/wireless/ath/wil6210/wil6210.h b/drivers/net/wireless/ath/wil6210/wil6210.h
index 1b4efd2..bedb9ed 100644
--- a/drivers/net/wireless/ath/wil6210/wil6210.h
+++ b/drivers/net/wireless/ath/wil6210/wil6210.h
@@ -62,11 +62,21 @@ static inline u32 WIL_GET_BITS(u32 x, int b0, int b1)
 #define WIL_MAX_AGG_WSIZE	(32) /* FW/HW limit */
 /* Hardware offload block adds the following:
  * 26 bytes - 3-address QoS data header
+ *  8 bytes - IV + EIV (for GCMP)
  *  8 bytes - SNAP
+ * 16 bytes - MIC (for GCMP)
  *  4 bytes - CRC
- * 24 bytes - security related (if connection is secure)
  */
 #define WIL_MAX_MPDU_OVERHEAD	(62)
+
+/* Calculate MAC buffer size for the firmware. It includes all overhead,
+ * as it will go over the air, and need to be 8 byte aligned
+ */
+static inline u32 wil_mtu2macbuf(u32 mtu)
+{
+	return ALIGN(mtu + WIL_MAX_MPDU_OVERHEAD, 8);
+}
+
 /* Max supported by wil6210 value for interrupt threshold is 5sec. */
 #define WIL6210_ITR_TRSH_MAX (5000000)
 #define WIL6210_ITR_TRSH_DEFAULT	(300) /* usec */
diff --git a/drivers/net/wireless/ath/wil6210/wmi.c b/drivers/net/wireless/ath/wil6210/wmi.c
index af2ca46..70b055c 100644
--- a/drivers/net/wireless/ath/wil6210/wmi.c
+++ b/drivers/net/wireless/ath/wil6210/wmi.c
@@ -1083,7 +1083,7 @@ int wmi_rx_chain_add(struct wil6210_priv *wil, struct vring *vring)
 	struct wmi_cfg_rx_chain_cmd cmd = {
 		.action = WMI_RX_CHAIN_ADD,
 		.rx_sw_ring = {
-			.max_mpdu_size = cpu_to_le16(mtu_max + ETH_HLEN),
+			.max_mpdu_size = cpu_to_le16(wil_mtu2macbuf(mtu_max)),
 			.ring_mem_base = cpu_to_le64(vring->pa),
 			.ring_size = cpu_to_le16(vring->size),
 		},
-- 
2.1.0

