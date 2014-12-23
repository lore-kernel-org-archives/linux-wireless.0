Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine02.qualcomm.com ([199.106.114.251]:21144 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755173AbaLWHse (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 23 Dec 2014 02:48:34 -0500
From: Vladimir Kondratiev <QCA_vkondrat@QCA.qualcomm.com>
Cc: Vladimir Kondratiev <QCA_vkondrat@QCA.qualcomm.com>,
	linux-wireless@vger.kernel.org, wil6210@qca.qualcomm.com
To: Kalle Valo <kvalo@qca.qualcomm.com>
Subject: [PATCH 18/22] wil6210: RX high threshold interrupt configuration
Date: Tue, 23 Dec 2014 09:47:20 +0200
Message-Id: <1419320844-23989-19-git-send-email-qca_vkondrat@qca.qualcomm.com> (sfid-20141223_091348_222621_043BF4E1)
In-Reply-To: <1419320844-23989-1-git-send-email-qca_vkondrat@qca.qualcomm.com>
References: <1419320844-23989-1-git-send-email-qca_vkondrat@qca.qualcomm.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Rx high threshold interrupt is reported by the hardware in case
when number of not utilized by the HW descriptors in the Rx ring
becomes low.
Introduce module parameter for RX high threshold.

Signed-off-by: Vladimir Kondratiev <qca_vkondrat@qca.qualcomm.com>
---
 drivers/net/wireless/ath/wil6210/main.c    | 9 +++++++++
 drivers/net/wireless/ath/wil6210/wil6210.h | 5 ++++-
 drivers/net/wireless/ath/wil6210/wmi.c     | 1 +
 3 files changed, 14 insertions(+), 1 deletion(-)

diff --git a/drivers/net/wireless/ath/wil6210/main.c b/drivers/net/wireless/ath/wil6210/main.c
index d286153..f44b640 100644
--- a/drivers/net/wireless/ath/wil6210/main.c
+++ b/drivers/net/wireless/ath/wil6210/main.c
@@ -61,6 +61,13 @@ module_param(rx_max_burst_duration, uint, S_IRUGO);
 MODULE_PARM_DESC(rx_max_burst_duration,
 		 " Interrupt moderation RX max burst duration, usecs.");
 
+/* if not set via modparam, will be set to default value of 1/8 of
+ * rx ring size during init flow
+ */
+unsigned short rx_ring_overflow_thrsh = WIL6210_RX_HIGH_TRSH_INIT;
+module_param(rx_ring_overflow_thrsh, ushort, S_IRUGO);
+MODULE_PARM_DESC(rx_ring_overflow_thrsh,
+		 " RX ring overflow threshold in descriptors.");
 
 /* We allow allocation of more than 1 page buffers to support large packets.
  * It is suboptimal behavior performance wise in case MTU above page size.
@@ -456,6 +463,8 @@ int wil_priv_init(struct wil6210_priv *wil)
 	wil->tx_max_burst_duration = tx_max_burst_duration;
 	wil->rx_max_burst_duration = rx_max_burst_duration;
 
+	if (rx_ring_overflow_thrsh == WIL6210_RX_HIGH_TRSH_INIT)
+		rx_ring_overflow_thrsh = WIL6210_RX_HIGH_TRSH_DEFAULT;
 	return 0;
 
 out_wmi_wq:
diff --git a/drivers/net/wireless/ath/wil6210/wil6210.h b/drivers/net/wireless/ath/wil6210/wil6210.h
index a6d63c1..da3fe78 100644
--- a/drivers/net/wireless/ath/wil6210/wil6210.h
+++ b/drivers/net/wireless/ath/wil6210/wil6210.h
@@ -25,6 +25,7 @@
 
 extern bool no_fw_recovery;
 extern unsigned int mtu_max;
+extern unsigned short rx_ring_overflow_thrsh;
 extern int agg_wsize;
 
 #define WIL_NAME "wil6210"
@@ -83,7 +84,9 @@ static inline u32 wil_mtu2macbuf(u32 mtu)
 #define WIL6210_FW_RECOVERY_RETRIES	(5) /* try to recover this many times */
 #define WIL6210_FW_RECOVERY_TO	msecs_to_jiffies(5000)
 #define WIL6210_SCAN_TO		msecs_to_jiffies(10000)
-
+#define WIL6210_RX_HIGH_TRSH_INIT		(0)
+#define WIL6210_RX_HIGH_TRSH_DEFAULT \
+				(1 << (WIL_RX_RING_SIZE_ORDER_DEFAULT - 3))
 /* Hardware definitions begin */
 
 /*
diff --git a/drivers/net/wireless/ath/wil6210/wmi.c b/drivers/net/wireless/ath/wil6210/wmi.c
index a4b30a4..432ec55 100644
--- a/drivers/net/wireless/ath/wil6210/wmi.c
+++ b/drivers/net/wireless/ath/wil6210/wmi.c
@@ -1090,6 +1090,7 @@ int wmi_rx_chain_add(struct wil6210_priv *wil, struct vring *vring)
 		.mid = 0, /* TODO - what is it? */
 		.decap_trans_type = WMI_DECAP_TYPE_802_3,
 		.reorder_type = WMI_RX_SW_REORDER,
+		.host_thrsh = cpu_to_le16(rx_ring_overflow_thrsh),
 	};
 	struct {
 		struct wil6210_mbox_hdr_wmi wmi;
-- 
2.1.0

