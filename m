Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from sabertooth02.qualcomm.com ([65.197.215.38]:17616 "EHLO
	sabertooth02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753423AbaB0OVi (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 27 Feb 2014 09:21:38 -0500
From: Vladimir Kondratiev <qca_vkondrat@qca.qualcomm.com>
To: "John W . Linville" <linville@tuxdriver.com>
CC: Vladimir Kondratiev <qca_vkondrat@qca.qualcomm.com>,
	<linux-wireless@vger.kernel.org>, <wil6210@qca.qualcomm.com>
Subject: [PATCH 08/16] wil6210: fix BACK status processing
Date: Thu, 27 Feb 2014 16:20:47 +0200
Message-ID: <1393510855-17566-9-git-send-email-qca_vkondrat@qca.qualcomm.com> (sfid-20140227_152143_169963_BCD02509)
In-Reply-To: <1393510855-17566-1-git-send-email-qca_vkondrat@qca.qualcomm.com>
References: <1393510855-17566-1-git-send-email-qca_vkondrat@qca.qualcomm.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

When FW notifies about BACK status change, it provides ring ID.
Process BA status for requested connection only. As for now, FW
don't report Rx BACK status, it reports Tx one instead.
As per current algorithm used in the firmware, imply Rx BACK
state is in sync with Tx one

Signed-off-by: Vladimir Kondratiev <qca_vkondrat@qca.qualcomm.com>
---
 drivers/net/wireless/ath/wil6210/wmi.c | 47 ++++++++++++++++++++++------------
 1 file changed, 31 insertions(+), 16 deletions(-)

diff --git a/drivers/net/wireless/ath/wil6210/wmi.c b/drivers/net/wireless/ath/wil6210/wmi.c
index dfbc239..635aa32 100644
--- a/drivers/net/wireless/ath/wil6210/wmi.c
+++ b/drivers/net/wireless/ath/wil6210/wmi.c
@@ -563,27 +563,42 @@ static void wmi_evt_ba_status(struct wil6210_priv *wil, int id, void *d,
 			      int len)
 {
 	struct wmi_vring_ba_status_event *evt = d;
-	uint cid, i;
+	struct wil_sta_info *sta;
+	uint i, cid;
+
+	/* TODO: use Rx BA status, not Tx one */
 
 	wil_dbg_wmi(wil, "BACK[%d] %s {%d} timeout %d\n",
-		    evt->ringid, evt->status == WMI_BA_AGREED ? "OK" : "N/A",
+		    evt->ringid,
+		    evt->status == WMI_BA_AGREED ? "OK" : "N/A",
 		    evt->agg_wsize, __le16_to_cpu(evt->ba_timeout));
-	for (cid = 0; cid < WIL6210_MAX_CID; cid++) {
-		struct wil_sta_info *sta = &wil->sta[cid];
-
-		if (sta->status == wil_sta_unused)
-			continue;
-		wil_dbg_wmi(wil, "Init BACK for CID %d %pM\n", cid, sta->addr);
-		for (i = 0; i < WIL_STA_TID_NUM; i++) {
-			struct wil_tid_ampdu_rx *r = sta->tid_rx[i];
-			sta->tid_rx[i] = NULL;
-			wil_tid_ampdu_rx_free(wil, r);
-			if ((evt->status == WMI_BA_AGREED) && evt->agg_wsize)
-				sta->tid_rx[i] = wil_tid_ampdu_rx_alloc(wil,
-							evt->agg_wsize, 0);
-		}
+
+	if (evt->ringid >= WIL6210_MAX_TX_RINGS) {
+		wil_err(wil, "invalid ring id %d\n", evt->ringid);
+		return;
 	}
 
+	cid = wil->vring2cid_tid[evt->ringid][0];
+	if (cid >= WIL6210_MAX_CID) {
+		wil_err(wil, "invalid CID %d for vring %d\n", cid, evt->ringid);
+		return;
+	}
+
+	sta = &wil->sta[cid];
+	if (sta->status == wil_sta_unused) {
+		wil_err(wil, "CID %d unused\n", cid);
+		return;
+	}
+
+	wil_dbg_wmi(wil, "BACK for CID %d %pM\n", cid, sta->addr);
+	for (i = 0; i < WIL_STA_TID_NUM; i++) {
+		struct wil_tid_ampdu_rx *r = sta->tid_rx[i];
+		sta->tid_rx[i] = NULL;
+		wil_tid_ampdu_rx_free(wil, r);
+		if ((evt->status == WMI_BA_AGREED) && evt->agg_wsize)
+			sta->tid_rx[i] = wil_tid_ampdu_rx_alloc(wil,
+						evt->agg_wsize, 0);
+	}
 }
 
 static const struct {
-- 
1.8.3.2

