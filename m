Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx0b-0016f401.pphosted.com ([67.231.156.173]:44399 "EHLO
	mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755153AbaLWIO6 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 23 Dec 2014 03:14:58 -0500
Received: from pps.filterd (m0045851.ppops.net [127.0.0.1])
	by mx0b-0016f401.pphosted.com (8.14.5/8.14.5) with SMTP id sBN8Eans010300
	for <linux-wireless@vger.kernel.org>; Tue, 23 Dec 2014 00:14:58 -0800
Received: from sc-owa.marvell.com ([199.233.58.135])
	by mx0b-0016f401.pphosted.com with ESMTP id 1rd602ptbc-1
	(version=TLSv1/SSLv3 cipher=AES128-SHA bits=128 verify=NOT)
	for <linux-wireless@vger.kernel.org>; Tue, 23 Dec 2014 00:14:58 -0800
From: Avinash Patil <patila@marvell.com>
To: <linux-wireless@vger.kernel.org>
CC: <akarwar@marvell.com>, <cluo@marvell.com>, <yangyang@marvell.com>,
	<huxm@marvell.com>, Avinash Patil <patila@marvell.com>
Subject: [PATCH 6/8] mwifiex: save driver information to file when firmware dump
Date: Tue, 23 Dec 2014 19:14:10 +0530
Message-ID: <1419342252-2702-7-git-send-email-patila@marvell.com> (sfid-20141223_091514_337616_EE74F0EB)
In-Reply-To: <1419342252-2702-1-git-send-email-patila@marvell.com>
References: <1419342252-2702-1-git-send-email-patila@marvell.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Xinming Hu <huxm@marvell.com>

This patch adds support to dump driver information to a file
when firmware dump happens. This information can be used to
root casue FW crash.

Signed-off-by: Xinming Hu <huxm@marvell.com>
Signed-off-by: Cathy Luo <cluo@marvell.com>
Signed-off-by: Avinash Patil <patila@marvell.com>
---
 drivers/net/wireless/mwifiex/ethtool.c |  16 +++++-
 drivers/net/wireless/mwifiex/init.c    |   5 ++
 drivers/net/wireless/mwifiex/main.c    | 102 +++++++++++++++++++++++++++++++++
 drivers/net/wireless/mwifiex/main.h    |   9 +++
 drivers/net/wireless/mwifiex/sdio.c    |   2 +
 5 files changed, 133 insertions(+), 1 deletion(-)

diff --git a/drivers/net/wireless/mwifiex/ethtool.c b/drivers/net/wireless/mwifiex/ethtool.c
index 04e56b5..65d8d6d 100644
--- a/drivers/net/wireless/mwifiex/ethtool.c
+++ b/drivers/net/wireless/mwifiex/ethtool.c
@@ -76,7 +76,9 @@ mwifiex_get_dump_flag(struct net_device *dev, struct ethtool_dump *dump)
 
 	dump->flag = adapter->curr_mem_idx;
 	dump->version = 1;
-	if (adapter->curr_mem_idx != MWIFIEX_FW_DUMP_IDX) {
+	if (adapter->curr_mem_idx == MWIFIEX_DRV_INFO_IDX) {
+		dump->len = adapter->drv_info_size;
+	} else if (adapter->curr_mem_idx != MWIFIEX_FW_DUMP_IDX) {
 		entry = &adapter->mem_type_mapping_tbl[adapter->curr_mem_idx];
 		dump->len = entry->mem_size;
 	} else {
@@ -98,6 +100,13 @@ mwifiex_get_dump_data(struct net_device *dev, struct ethtool_dump *dump,
 	if (!adapter->if_ops.fw_dump)
 		return -ENOTSUPP;
 
+	if (adapter->curr_mem_idx == MWIFIEX_DRV_INFO_IDX) {
+		if (!adapter->drv_info_dump)
+			return -EFAULT;
+		memcpy(p, adapter->drv_info_dump, adapter->drv_info_size);
+		return 0;
+	}
+
 	if (adapter->curr_mem_idx == MWIFIEX_FW_DUMP_IDX) {
 		dev_err(adapter->dev, "firmware dump in progress!!\n");
 		return -EBUSY;
@@ -125,6 +134,11 @@ static int mwifiex_set_dump(struct net_device *dev, struct ethtool_dump *val)
 	if (!adapter->if_ops.fw_dump)
 		return -ENOTSUPP;
 
+	if (val->flag == MWIFIEX_DRV_INFO_IDX) {
+		adapter->curr_mem_idx = MWIFIEX_DRV_INFO_IDX;
+		return 0;
+	}
+
 	if (adapter->curr_mem_idx == MWIFIEX_FW_DUMP_IDX) {
 		dev_err(adapter->dev, "firmware dump in progress!!\n");
 		return -EBUSY;
diff --git a/drivers/net/wireless/mwifiex/init.c b/drivers/net/wireless/mwifiex/init.c
index 520ad4a..a3dd601 100644
--- a/drivers/net/wireless/mwifiex/init.c
+++ b/drivers/net/wireless/mwifiex/init.c
@@ -411,6 +411,11 @@ mwifiex_adapter_cleanup(struct mwifiex_adapter *adapter)
 		entry->mem_size = 0;
 	}
 
+	if (adapter->drv_info_dump) {
+		vfree(adapter->drv_info_dump);
+		adapter->drv_info_size = 0;
+	}
+
 	if (adapter->sleep_cfm)
 		dev_kfree_skb_any(adapter->sleep_cfm);
 }
diff --git a/drivers/net/wireless/mwifiex/main.c b/drivers/net/wireless/mwifiex/main.c
index 0c44c5ee..4edaaf4 100644
--- a/drivers/net/wireless/mwifiex/main.c
+++ b/drivers/net/wireless/mwifiex/main.c
@@ -801,6 +801,108 @@ mwifiex_tx_timeout(struct net_device *dev)
 	}
 }
 
+void mwifiex_dump_drv_info(struct mwifiex_adapter *adapter)
+{
+	void *p;
+	char drv_version[64];
+	struct usb_card_rec *cardp;
+	struct sdio_mmc_card *sdio_card;
+	struct mwifiex_private *priv;
+	int i, idx;
+	struct netdev_queue *txq;
+	struct mwifiex_debug_info *debug_info;
+
+	if (adapter->drv_info_dump) {
+		vfree(adapter->drv_info_dump);
+		adapter->drv_info_size = 0;
+	}
+
+	dev_info(adapter->dev, "=== DRIVER INFO DUMP START===\n");
+
+	adapter->drv_info_dump = vzalloc(MWIFIEX_DRV_INFO_SIZE_MAX);
+
+	if (!adapter->drv_info_dump)
+		return;
+
+	p = (char *)(adapter->drv_info_dump);
+	p += sprintf(p, "driver_name = " "\"mwifiex\"\n");
+
+	mwifiex_drv_get_driver_version(adapter, drv_version,
+				       sizeof(drv_version) - 1);
+	p += sprintf(p, "driver_version = %s\n", drv_version);
+
+	if (adapter->iface_type == MWIFIEX_USB) {
+		cardp = (struct usb_card_rec *)adapter->card;
+		p += sprintf(p, "tx_cmd_urb_pending = %d\n",
+			     atomic_read(&cardp->tx_cmd_urb_pending));
+		p += sprintf(p, "tx_data_urb_pending = %d\n",
+			     atomic_read(&cardp->tx_data_urb_pending));
+		p += sprintf(p, "rx_cmd_urb_pending = %d\n",
+			     atomic_read(&cardp->rx_cmd_urb_pending));
+		p += sprintf(p, "rx_data_urb_pending = %d\n",
+			     atomic_read(&cardp->rx_data_urb_pending));
+	}
+
+	p += sprintf(p, "tx_pending = %d\n",
+		     atomic_read(&adapter->tx_pending));
+	p += sprintf(p, "rx_pending = %d\n",
+		     atomic_read(&adapter->rx_pending));
+
+	if (adapter->iface_type == MWIFIEX_SDIO) {
+		sdio_card = (struct sdio_mmc_card *)adapter->card;
+		p += sprintf(p, "\nmp_rd_bitmap=0x%x curr_rd_port=0x%x\n",
+			     sdio_card->mp_rd_bitmap, sdio_card->curr_rd_port);
+		p += sprintf(p, "mp_wr_bitmap=0x%x curr_wr_port=0x%x\n",
+			     sdio_card->mp_wr_bitmap, sdio_card->curr_wr_port);
+	}
+
+	for (i = 0; i < adapter->priv_num; i++) {
+		if (!adapter->priv[i] || !adapter->priv[i]->netdev)
+			continue;
+		priv = adapter->priv[i];
+		p += sprintf(p, "\n[interface  : \"%s\"]\n",
+			     priv->netdev->name);
+		p += sprintf(p, "wmm_tx_pending[0] = %d\n",
+			     atomic_read(&priv->wmm_tx_pending[0]));
+		p += sprintf(p, "wmm_tx_pending[1] = %d\n",
+			     atomic_read(&priv->wmm_tx_pending[1]));
+		p += sprintf(p, "wmm_tx_pending[2] = %d\n",
+			     atomic_read(&priv->wmm_tx_pending[2]));
+		p += sprintf(p, "wmm_tx_pending[3] = %d\n",
+			     atomic_read(&priv->wmm_tx_pending[3]));
+		p += sprintf(p, "media_state=\"%s\"\n", !priv->media_connected ?
+			     "Disconnected" : "Connected");
+		p += sprintf(p, "carrier %s\n", (netif_carrier_ok(priv->netdev)
+			     ? "on" : "off"));
+		for (idx = 0; idx < priv->netdev->num_tx_queues; idx++) {
+			txq = netdev_get_tx_queue(priv->netdev, idx);
+			p += sprintf(p, "tx queue %d:%s  ", idx,
+				     netif_tx_queue_stopped(txq) ?
+				     "stopped" : "started");
+		}
+		p += sprintf(p, "\n%s: num_tx_timeout = %d\n",
+			     priv->netdev->name, priv->num_tx_timeout);
+	}
+
+	p += sprintf(p, "\n=== MORE DEBUG INFORMATION\n");
+	debug_info = kzalloc(sizeof(*debug_info), GFP_KERNEL);
+	if (debug_info) {
+		for (i = 0; i < adapter->priv_num; i++) {
+			if (!adapter->priv[i] || !adapter->priv[i]->netdev)
+				continue;
+			priv = adapter->priv[i];
+			mwifiex_get_debug_info(priv, debug_info);
+			p += mwifiex_debug_info_to_buffer(priv, p, debug_info);
+			break;
+		}
+		kfree(debug_info);
+	}
+
+	adapter->drv_info_size = p - adapter->drv_info_dump;
+	dev_info(adapter->dev, "=== DRIVER INFO DUMP END===\n");
+}
+EXPORT_SYMBOL_GPL(mwifiex_dump_drv_info);
+
 /*
  * CFG802.11 network device handler for statistics retrieval.
  */
diff --git a/drivers/net/wireless/mwifiex/main.h b/drivers/net/wireless/mwifiex/main.h
index 6f7e060..2f085de 100644
--- a/drivers/net/wireless/mwifiex/main.h
+++ b/drivers/net/wireless/mwifiex/main.h
@@ -41,6 +41,8 @@
 #include "util.h"
 #include "fw.h"
 #include "pcie.h"
+#include "usb.h"
+#include "sdio.h"
 
 extern const char driver_version[];
 
@@ -136,6 +138,8 @@ enum {
 /* Threshold for tx_timeout_cnt before we trigger a card reset */
 #define TX_TIMEOUT_THRESHOLD	6
 
+#define MWIFIEX_DRV_INFO_SIZE_MAX 0x40000
+
 struct mwifiex_dbg {
 	u32 num_cmd_host_to_card_failure;
 	u32 num_cmd_sleep_cfm_host_to_card_failure;
@@ -413,6 +417,7 @@ struct mwifiex_roc_cfg {
 };
 
 #define MWIFIEX_FW_DUMP_IDX		0xff
+#define MWIFIEX_DRV_INFO_IDX		20
 #define FW_DUMP_MAX_NAME_LEN		8
 #define FW_DUMP_HOST_READY		0xEE
 #define FW_DUMP_DONE			0xFF
@@ -867,6 +872,8 @@ struct mwifiex_adapter {
 	struct memory_type_mapping *mem_type_mapping_tbl;
 	u8 num_mem_types;
 	u8 curr_mem_idx;
+	void *drv_info_dump;
+	u32 drv_info_size;
 	bool scan_chan_gap_enabled;
 	struct sk_buff_head rx_data_q;
 	struct mwifiex_chan_stats *chan_stats;
@@ -1360,6 +1367,8 @@ void mwifiex_hist_data_add(struct mwifiex_private *priv,
 u8 mwifiex_adjust_data_rate(struct mwifiex_private *priv,
 			    u8 rx_rate, u8 ht_info);
 
+void mwifiex_dump_drv_info(struct mwifiex_adapter *adapter);
+
 #ifdef CONFIG_DEBUG_FS
 void mwifiex_debugfs_init(void);
 void mwifiex_debugfs_remove(void);
diff --git a/drivers/net/wireless/mwifiex/sdio.c b/drivers/net/wireless/mwifiex/sdio.c
index 933dae1..6bdfe67 100644
--- a/drivers/net/wireless/mwifiex/sdio.c
+++ b/drivers/net/wireless/mwifiex/sdio.c
@@ -2023,6 +2023,8 @@ static void mwifiex_sdio_fw_dump_work(struct work_struct *work)
 	u32 memory_size;
 	static char *env[] = { "DRIVER=mwifiex_sdio", "EVENT=fw_dump", NULL };
 
+	mwifiex_dump_drv_info(adapter);
+
 	if (!card->supports_fw_dump)
 		return;
 
-- 
1.8.1.4

