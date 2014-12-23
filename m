Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine02.qualcomm.com ([199.106.114.251]:17835 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754753AbaLWHr4 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 23 Dec 2014 02:47:56 -0500
From: Vladimir Kondratiev <QCA_vkondrat@QCA.qualcomm.com>
Cc: Vladimir Kondratiev <QCA_vkondrat@QCA.qualcomm.com>,
	linux-wireless@vger.kernel.org, wil6210@qca.qualcomm.com
To: Kalle Valo <kvalo@qca.qualcomm.com>
Subject: [PATCH 03/22] wil6210: allow to configure ADDBA request
Date: Tue, 23 Dec 2014 09:47:05 +0200
Message-Id: <1419320844-23989-4-git-send-email-qca_vkondrat@qca.qualcomm.com> (sfid-20141223_084803_907446_85AC369E)
In-Reply-To: <1419320844-23989-1-git-send-email-qca_vkondrat@qca.qualcomm.com>
References: <1419320844-23989-1-git-send-email-qca_vkondrat@qca.qualcomm.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

For manual ADDBA configuration, allow to set desired window size or
disable automatic mechanism.

Introduce module parameter (int) agg_wsize. It can be changed on run time,
will be taken into account on the next connect. Interpretation:
- <0 - disable automatic ADDBA; intended for manual testing through debugfs
- 0 - use automatically calculated window size
- >0 - use this for window size. Clipped by maximum supported by the hardware
with current environment.

Signed-off-by: Vladimir Kondratiev <qca_vkondrat@qca.qualcomm.com>
---
 drivers/net/wireless/ath/wil6210/rx_reorder.c |  4 ++--
 drivers/net/wireless/ath/wil6210/txrx.c       |  4 ++--
 drivers/net/wireless/ath/wil6210/wil6210.h    |  3 ++-
 drivers/net/wireless/ath/wil6210/wmi.c        | 12 +++++++++---
 4 files changed, 15 insertions(+), 8 deletions(-)

diff --git a/drivers/net/wireless/ath/wil6210/rx_reorder.c b/drivers/net/wireless/ath/wil6210/rx_reorder.c
index ce1206a..0865c34 100644
--- a/drivers/net/wireless/ath/wil6210/rx_reorder.c
+++ b/drivers/net/wireless/ath/wil6210/rx_reorder.c
@@ -437,7 +437,7 @@ void wil_back_tx_flush(struct wil6210_priv *wil)
 	mutex_unlock(&wil->back_tx_mutex);
 }
 
-int wil_addba_tx_request(struct wil6210_priv *wil, u8 ringid)
+int wil_addba_tx_request(struct wil6210_priv *wil, u8 ringid, u16 wsize)
 {
 	struct wil_back_tx *req = kzalloc(sizeof(*req), GFP_KERNEL);
 
@@ -445,7 +445,7 @@ int wil_addba_tx_request(struct wil6210_priv *wil, u8 ringid)
 		return -ENOMEM;
 
 	req->ringid = ringid;
-	req->agg_wsize = wil_agg_size(wil, 0);
+	req->agg_wsize = wil_agg_size(wil, wsize);
 	req->agg_timeout = 0;
 
 	mutex_lock(&wil->back_tx_mutex);
diff --git a/drivers/net/wireless/ath/wil6210/txrx.c b/drivers/net/wireless/ath/wil6210/txrx.c
index 71eaeec..b7ffcfb 100644
--- a/drivers/net/wireless/ath/wil6210/txrx.c
+++ b/drivers/net/wireless/ath/wil6210/txrx.c
@@ -701,8 +701,8 @@ int wil_vring_init_tx(struct wil6210_priv *wil, int id, int size,
 	vring->hwtail = le32_to_cpu(reply.cmd.tx_vring_tail_ptr);
 
 	txdata->enabled = 1;
-	if (wil->sta[cid].data_port_open)
-		wil_addba_tx_request(wil, id);
+	if (wil->sta[cid].data_port_open && (agg_wsize >= 0))
+		wil_addba_tx_request(wil, id, agg_wsize);
 
 	return 0;
  out_free:
diff --git a/drivers/net/wireless/ath/wil6210/wil6210.h b/drivers/net/wireless/ath/wil6210/wil6210.h
index 9cd76da..a94d67d 100644
--- a/drivers/net/wireless/ath/wil6210/wil6210.h
+++ b/drivers/net/wireless/ath/wil6210/wil6210.h
@@ -25,6 +25,7 @@
 
 extern bool no_fw_recovery;
 extern unsigned int mtu_max;
+extern int agg_wsize;
 
 #define WIL_NAME "wil6210"
 #define WIL_FW_NAME "wil6210.fw"
@@ -613,7 +614,7 @@ int wil_addba_rx_request(struct wil6210_priv *wil, u8 cidxtid,
 			 __le16 ba_timeout, __le16 ba_seq_ctrl);
 void wil_back_rx_worker(struct work_struct *work);
 void wil_back_rx_flush(struct wil6210_priv *wil);
-int wil_addba_tx_request(struct wil6210_priv *wil, u8 ringid);
+int wil_addba_tx_request(struct wil6210_priv *wil, u8 ringid, u16 wsize);
 void wil_back_tx_worker(struct work_struct *work);
 void wil_back_tx_flush(struct wil6210_priv *wil);
 
diff --git a/drivers/net/wireless/ath/wil6210/wmi.c b/drivers/net/wireless/ath/wil6210/wmi.c
index 8a4f8b7..2538161 100644
--- a/drivers/net/wireless/ath/wil6210/wmi.c
+++ b/drivers/net/wireless/ath/wil6210/wmi.c
@@ -27,6 +27,11 @@ static uint max_assoc_sta = 1;
 module_param(max_assoc_sta, uint, S_IRUGO | S_IWUSR);
 MODULE_PARM_DESC(max_assoc_sta, " Max number of stations associated to the AP");
 
+int agg_wsize; /* = 0; */
+module_param(agg_wsize, int, S_IRUGO | S_IWUSR);
+MODULE_PARM_DESC(agg_wsize, " Window size for Tx Block Ack after connect;"
+		 " 0 - use default; < 0 - don't auto-establish");
+
 /**
  * WMI event receiving - theory of operations
  *
@@ -544,7 +549,7 @@ static void wmi_evt_eapol_rx(struct wil6210_priv *wil, int id,
 	}
 }
 
-static void wil_addba_tx_cid(struct wil6210_priv *wil, u8 cid)
+static void wil_addba_tx_cid(struct wil6210_priv *wil, u8 cid, u16 wsize)
 {
 	struct vring_tx_data *t;
 	int i;
@@ -556,7 +561,7 @@ static void wil_addba_tx_cid(struct wil6210_priv *wil, u8 cid)
 		if (!t->enabled)
 			continue;
 
-		wil_addba_tx_request(wil, i);
+		wil_addba_tx_request(wil, i, wsize);
 	}
 }
 
@@ -574,7 +579,8 @@ static void wmi_evt_linkup(struct wil6210_priv *wil, int id, void *d, int len)
 	}
 
 	wil->sta[cid].data_port_open = true;
-	wil_addba_tx_cid(wil, cid);
+	if (agg_wsize >= 0)
+		wil_addba_tx_cid(wil, cid, agg_wsize);
 	netif_carrier_on(ndev);
 }
 
-- 
2.1.0

