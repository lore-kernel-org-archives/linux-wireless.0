Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from sabertooth01.qualcomm.com ([65.197.215.72]:9677 "EHLO
	sabertooth01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753066AbaCQNen (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 17 Mar 2014 09:34:43 -0400
From: Vladimir Kondratiev <qca_vkondrat@qca.qualcomm.com>
To: "John W . Linville" <linville@tuxdriver.com>
CC: Vladimir Kondratiev <qca_vkondrat@qca.qualcomm.com>,
	<linux-wireless@vger.kernel.org>, <wil6210@qca.qualcomm.com>
Subject: [PATCH 02/21] wil6210: Block data till "data port open" reported
Date: Mon, 17 Mar 2014 15:34:06 +0200
Message-ID: <1395063265-6522-3-git-send-email-qca_vkondrat@qca.qualcomm.com> (sfid-20140317_143451_502598_7D86554F)
In-Reply-To: <1395063265-6522-1-git-send-email-qca_vkondrat@qca.qualcomm.com>
References: <1395063265-6522-1-git-send-email-qca_vkondrat@qca.qualcomm.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

When connection established, as reported by WMI_CONNECT_EVENTID,
4-way handshaking required for the secure connection is not done
yet. It is indicated by another WMI event. Wait for it and only then
allow data traffic. In case of non-secure connection, FW reports
"data port open" immediately after connection.

Signed-off-by: Vladimir Kondratiev <qca_vkondrat@qca.qualcomm.com>
---
 drivers/net/wireless/ath/wil6210/debugfs.c |  3 ++-
 drivers/net/wireless/ath/wil6210/main.c    |  1 +
 drivers/net/wireless/ath/wil6210/txrx.c    | 21 ++++++++++++++++++---
 drivers/net/wireless/ath/wil6210/wil6210.h |  1 +
 drivers/net/wireless/ath/wil6210/wmi.c     | 18 ++++++++++++++++--
 5 files changed, 38 insertions(+), 6 deletions(-)

diff --git a/drivers/net/wireless/ath/wil6210/debugfs.c b/drivers/net/wireless/ath/wil6210/debugfs.c
index 1d09a4b..ea868be 100644
--- a/drivers/net/wireless/ath/wil6210/debugfs.c
+++ b/drivers/net/wireless/ath/wil6210/debugfs.c
@@ -631,7 +631,8 @@ static int wil_sta_debugfs_show(struct seq_file *s, void *data)
 			status = "connected";
 			break;
 		}
-		seq_printf(s, "[%d] %pM %s\n", i, p->addr, status);
+		seq_printf(s, "[%d] %pM %s%s\n", i, p->addr, status,
+			   (p->data_port_open ? " data_port_open" : ""));
 
 		if (p->status == wil_sta_connected) {
 			for (tid = 0; tid < WIL_STA_TID_NUM; tid++) {
diff --git a/drivers/net/wireless/ath/wil6210/main.c b/drivers/net/wireless/ath/wil6210/main.c
index 41c362d..f10a0b2 100644
--- a/drivers/net/wireless/ath/wil6210/main.c
+++ b/drivers/net/wireless/ath/wil6210/main.c
@@ -59,6 +59,7 @@ static void wil_disconnect_cid(struct wil6210_priv *wil, int cid)
 	uint i;
 	struct wil_sta_info *sta = &wil->sta[cid];
 
+	sta->data_port_open = false;
 	if (sta->status != wil_sta_unused) {
 		wmi_disconnect_sta(wil, sta->addr, WLAN_REASON_DEAUTH_LEAVING);
 		sta->status = wil_sta_unused;
diff --git a/drivers/net/wireless/ath/wil6210/txrx.c b/drivers/net/wireless/ath/wil6210/txrx.c
index 7afaa5e..29f13e0 100644
--- a/drivers/net/wireless/ath/wil6210/txrx.c
+++ b/drivers/net/wireless/ath/wil6210/txrx.c
@@ -662,6 +662,10 @@ static struct vring *wil_find_tx_vring(struct wil6210_priv *wil,
 	if (cid < 0)
 		return NULL;
 
+	if (!wil->sta[cid].data_port_open &&
+	    (skb->protocol != cpu_to_be16(ETH_P_PAE)))
+		return NULL;
+
 	/* TODO: fix for multiple TID */
 	for (i = 0; i < ARRAY_SIZE(wil->vring2cid_tid); i++) {
 		if (wil->vring2cid_tid[i][0] == cid) {
@@ -700,12 +704,19 @@ static struct vring *wil_tx_bcast(struct wil6210_priv *wil,
 	struct vring *v, *v2;
 	struct sk_buff *skb2;
 	int i;
+	u8 cid;
 
-	/* find 1-st vring */
+	/* find 1-st vring eligible for data */
 	for (i = 0; i < WIL6210_MAX_TX_RINGS; i++) {
 		v = &wil->vring_tx[i];
-		if (v->va)
-			goto found;
+		if (!v->va)
+			continue;
+
+		cid = wil->vring2cid_tid[i][0];
+		if (!wil->sta[cid].data_port_open)
+			continue;
+
+		goto found;
 	}
 
 	wil_err(wil, "Tx while no vrings active?\n");
@@ -721,6 +732,10 @@ found:
 		v2 = &wil->vring_tx[i];
 		if (!v2->va)
 			continue;
+		cid = wil->vring2cid_tid[i][0];
+		if (!wil->sta[cid].data_port_open)
+			continue;
+
 		skb2 = skb_copy(skb, GFP_ATOMIC);
 		if (skb2) {
 			wil_dbg_txrx(wil, "BCAST DUP -> ring %d\n", i);
diff --git a/drivers/net/wireless/ath/wil6210/wil6210.h b/drivers/net/wireless/ath/wil6210/wil6210.h
index 273d00f..f06f717 100644
--- a/drivers/net/wireless/ath/wil6210/wil6210.h
+++ b/drivers/net/wireless/ath/wil6210/wil6210.h
@@ -321,6 +321,7 @@ struct wil_sta_info {
 	u8 addr[ETH_ALEN];
 	enum wil_sta_status status;
 	struct wil_net_stats stats;
+	bool data_port_open; /* can send any data, not only EAPOL */
 	/* Rx BACK */
 	struct wil_tid_ampdu_rx *tid_rx[WIL_STA_TID_NUM];
 	unsigned long tid_rx_timer_expired[BITS_TO_LONGS(WIL_STA_TID_NUM)];
diff --git a/drivers/net/wireless/ath/wil6210/wmi.c b/drivers/net/wireless/ath/wil6210/wmi.c
index 24eed09..58c3afc 100644
--- a/drivers/net/wireless/ath/wil6210/wmi.c
+++ b/drivers/net/wireless/ath/wil6210/wmi.c
@@ -550,9 +550,16 @@ static void wmi_evt_linkup(struct wil6210_priv *wil, int id, void *d, int len)
 {
 	struct net_device *ndev = wil_to_ndev(wil);
 	struct wmi_data_port_open_event *evt = d;
+	u8 cid = evt->cid;
 
-	wil_dbg_wmi(wil, "Link UP for CID %d\n", evt->cid);
+	wil_dbg_wmi(wil, "Link UP for CID %d\n", cid);
 
+	if (cid >= ARRAY_SIZE(wil->sta)) {
+		wil_err(wil, "Link UP for invalid CID %d\n", cid);
+		return;
+	}
+
+	wil->sta[cid].data_port_open = true;
 	netif_carrier_on(ndev);
 }
 
@@ -560,10 +567,17 @@ static void wmi_evt_linkdown(struct wil6210_priv *wil, int id, void *d, int len)
 {
 	struct net_device *ndev = wil_to_ndev(wil);
 	struct wmi_wbe_link_down_event *evt = d;
+	u8 cid = evt->cid;
 
 	wil_dbg_wmi(wil, "Link DOWN for CID %d, reason %d\n",
-		    evt->cid, le32_to_cpu(evt->reason));
+		    cid, le32_to_cpu(evt->reason));
+
+	if (cid >= ARRAY_SIZE(wil->sta)) {
+		wil_err(wil, "Link DOWN for invalid CID %d\n", cid);
+		return;
+	}
 
+	wil->sta[cid].data_port_open = false;
 	netif_carrier_off(ndev);
 }
 
-- 
1.8.3.2

