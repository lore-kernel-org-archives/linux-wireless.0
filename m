Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine02.qualcomm.com ([199.106.114.251]:17835 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751976AbaLWHsF (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 23 Dec 2014 02:48:05 -0500
From: Vladimir Kondratiev <QCA_vkondrat@QCA.qualcomm.com>
Cc: Vladimir Kondratiev <QCA_vkondrat@QCA.qualcomm.com>,
	linux-wireless@vger.kernel.org, wil6210@qca.qualcomm.com
To: Kalle Valo <kvalo@qca.qualcomm.com>
Subject: [PATCH 07/22] wil6210: control AMSDU on Tx side of Block Ack
Date: Tue, 23 Dec 2014 09:47:09 +0200
Message-Id: <1419320844-23989-8-git-send-email-qca_vkondrat@qca.qualcomm.com> (sfid-20141223_084811_744014_CFE5DA0C)
In-Reply-To: <1419320844-23989-1-git-send-email-qca_vkondrat@qca.qualcomm.com>
References: <1419320844-23989-1-git-send-email-qca_vkondrat@qca.qualcomm.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

When establishing Block Ack as originator (Tx), control
AMSDU flag when sending ADDBA and update status upon
establishment flow completion. To be used in AMSDU flows

Signed-off-by: Vladimir Kondratiev <qca_vkondrat@qca.qualcomm.com>
---
 drivers/net/wireless/ath/wil6210/debugfs.c |  3 ++-
 drivers/net/wireless/ath/wil6210/wil6210.h |  1 +
 drivers/net/wireless/ath/wil6210/wmi.c     |  8 ++++++--
 drivers/net/wireless/ath/wil6210/wmi.h     | 12 +++++++++++-
 4 files changed, 20 insertions(+), 4 deletions(-)

diff --git a/drivers/net/wireless/ath/wil6210/debugfs.c b/drivers/net/wireless/ath/wil6210/debugfs.c
index fedfa64..c57cc2d 100644
--- a/drivers/net/wireless/ath/wil6210/debugfs.c
+++ b/drivers/net/wireless/ath/wil6210/debugfs.c
@@ -114,9 +114,10 @@ static int wil_vring_debugfs_show(struct seq_file *s, void *data)
 			snprintf(name, sizeof(name), "tx_%2d", i);
 
 			seq_printf(s,
-				   "\n%pM CID %d TID %d BACK([%d] %d TU) [%3d|%3d] idle %3d%%\n",
+				   "\n%pM CID %d TID %d BACK([%d] %d TU A%s) [%3d|%3d] idle %3d%%\n",
 				   wil->sta[cid].addr, cid, tid,
 				   txdata->agg_wsize, txdata->agg_timeout,
+				   txdata->agg_amsdu ? "+" : "-",
 				   used, avail, (int)idle);
 
 			wil_print_vring(s, wil, name, vring, '_', 'H');
diff --git a/drivers/net/wireless/ath/wil6210/wil6210.h b/drivers/net/wireless/ath/wil6210/wil6210.h
index a94d67d..747052d 100644
--- a/drivers/net/wireless/ath/wil6210/wil6210.h
+++ b/drivers/net/wireless/ath/wil6210/wil6210.h
@@ -315,6 +315,7 @@ struct vring_tx_data {
 	cycles_t idle, last_idle, begin;
 	u8 agg_wsize; /* agreed aggregation window, 0 - no agg */
 	u16 agg_timeout;
+	u8 agg_amsdu;
 	bool addba_in_progress; /* if set, agg_xxx is for request in progress */
 };
 
diff --git a/drivers/net/wireless/ath/wil6210/wmi.c b/drivers/net/wireless/ath/wil6210/wmi.c
index 2538161..00cba4a 100644
--- a/drivers/net/wireless/ath/wil6210/wmi.c
+++ b/drivers/net/wireless/ath/wil6210/wmi.c
@@ -608,10 +608,11 @@ static void wmi_evt_ba_status(struct wil6210_priv *wil, int id, void *d,
 	struct wmi_vring_ba_status_event *evt = d;
 	struct vring_tx_data *txdata;
 
-	wil_dbg_wmi(wil, "BACK[%d] %s {%d} timeout %d\n",
+	wil_dbg_wmi(wil, "BACK[%d] %s {%d} timeout %d AMSDU%s\n",
 		    evt->ringid,
 		    evt->status == WMI_BA_AGREED ? "OK" : "N/A",
-		    evt->agg_wsize, __le16_to_cpu(evt->ba_timeout));
+		    evt->agg_wsize, __le16_to_cpu(evt->ba_timeout),
+		    evt->amsdu ? "+" : "-");
 
 	if (evt->ringid >= WIL6210_MAX_TX_RINGS) {
 		wil_err(wil, "invalid ring id %d\n", evt->ringid);
@@ -621,12 +622,14 @@ static void wmi_evt_ba_status(struct wil6210_priv *wil, int id, void *d,
 	if (evt->status != WMI_BA_AGREED) {
 		evt->ba_timeout = 0;
 		evt->agg_wsize = 0;
+		evt->amsdu = 0;
 	}
 
 	txdata = &wil->vring_tx_data[evt->ringid];
 
 	txdata->agg_timeout = le16_to_cpu(evt->ba_timeout);
 	txdata->agg_wsize = evt->agg_wsize;
+	txdata->agg_amsdu = evt->amsdu;
 	txdata->addba_in_progress = false;
 }
 
@@ -1172,6 +1175,7 @@ int wmi_addba(struct wil6210_priv *wil, u8 ringid, u8 size, u16 timeout)
 		.ringid = ringid,
 		.agg_max_wsize = size,
 		.ba_timeout = cpu_to_le16(timeout),
+		.amsdu = 0,
 	};
 
 	wil_dbg_wmi(wil, "%s(ring %d size %d timeout %d)\n", __func__,
diff --git a/drivers/net/wireless/ath/wil6210/wmi.h b/drivers/net/wireless/ath/wil6210/wmi.h
index 27b9743..b5102f0 100644
--- a/drivers/net/wireless/ath/wil6210/wmi.h
+++ b/drivers/net/wireless/ath/wil6210/wmi.h
@@ -586,6 +586,7 @@ struct wmi_vring_ba_en_cmd {
 	u8 ringid;
 	u8 agg_max_wsize;
 	__le16 ba_timeout;
+	u8 amsdu;
 } __packed;
 
 /*
@@ -1052,14 +1053,23 @@ struct wmi_scan_complete_event {
 enum wmi_vring_ba_status {
 	WMI_BA_AGREED			= 0,
 	WMI_BA_NON_AGREED		= 1,
+	/* BA_EN in middle of teardown flow */
+	WMI_BA_TD_WIP			= 2,
+	/* BA_DIS or BA_EN in middle of BA SETUP flow */
+	WMI_BA_SETUP_WIP		= 3,
+	/* BA_EN when the BA session is already active */
+	WMI_BA_SESSION_ACTIVE		= 4,
+	/* BA_DIS when the BA session is not active */
+	WMI_BA_SESSION_NOT_ACTIVE	= 5,
 };
 
 struct wmi_vring_ba_status_event {
-	__le16 status;
+	__le16 status; /* enum wmi_vring_ba_status */
 	u8 reserved[2];
 	u8 ringid;
 	u8 agg_wsize;
 	__le16 ba_timeout;
+	u8 amsdu;
 } __packed;
 
 /*
-- 
2.1.0

