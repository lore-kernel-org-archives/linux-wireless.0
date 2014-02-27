Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from sabertooth02.qualcomm.com ([65.197.215.38]:17631 "EHLO
	sabertooth02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753439AbaB0OVn (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 27 Feb 2014 09:21:43 -0500
From: Vladimir Kondratiev <qca_vkondrat@qca.qualcomm.com>
To: "John W . Linville" <linville@tuxdriver.com>
CC: Vladimir Kondratiev <qca_vkondrat@qca.qualcomm.com>,
	<linux-wireless@vger.kernel.org>, <wil6210@qca.qualcomm.com>
Subject: [PATCH 11/16] wil6210: disconnect only requested peer
Date: Thu, 27 Feb 2014 16:20:50 +0200
Message-ID: <1393510855-17566-12-git-send-email-qca_vkondrat@qca.qualcomm.com> (sfid-20140227_152151_676171_82C05760)
In-Reply-To: <1393510855-17566-1-git-send-email-qca_vkondrat@qca.qualcomm.com>
References: <1393510855-17566-1-git-send-email-qca_vkondrat@qca.qualcomm.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Disconnect event reported by the FW, should lead to disconnection
of only requested peer. Find for the appropriate CID and disconnect
only it

For AP-like interface, notify cfg80211 with del_sta(),
for the client type interface, disconnect and turn link off.

Signed-off-by: Vladimir Kondratiev <qca_vkondrat@qca.qualcomm.com>
---
 drivers/net/wireless/ath/wil6210/main.c | 81 +++++++++++++++++++++++----------
 1 file changed, 56 insertions(+), 25 deletions(-)

diff --git a/drivers/net/wireless/ath/wil6210/main.c b/drivers/net/wireless/ath/wil6210/main.c
index 5079e49..361c693 100644
--- a/drivers/net/wireless/ath/wil6210/main.c
+++ b/drivers/net/wireless/ath/wil6210/main.c
@@ -53,38 +53,69 @@ void wil_memcpy_toio_32(volatile void __iomem *dst, const void *src,
 		__raw_writel(*s++, d++);
 }
 
+static void wil_disconnect_cid(struct wil6210_priv *wil, int cid)
+{
+	uint i;
+	struct wil_sta_info *sta = &wil->sta[cid];
+	for (i = 0; i < WIL_STA_TID_NUM; i++) {
+		struct wil_tid_ampdu_rx *r = sta->tid_rx[i];
+		sta->tid_rx[i] = NULL;
+		wil_tid_ampdu_rx_free(wil, r);
+	}
+	for (i = 0; i < ARRAY_SIZE(wil->vring_tx); i++) {
+		if (wil->vring2cid_tid[i][0] == cid)
+			wil_vring_fini_tx(wil, i);
+	}
+	memset(&sta->stats, 0, sizeof(sta->stats));
+}
+
 static void _wil6210_disconnect(struct wil6210_priv *wil, void *bssid)
 {
-	uint i, cid;
+	int cid = -ENOENT;
 	struct net_device *ndev = wil_to_ndev(wil);
+	struct wireless_dev *wdev = wil->wdev;
 
-	wil_dbg_misc(wil, "%s()\n", __func__);
-
-	for (cid = 0; cid < WIL6210_MAX_CID; cid++) {
-		struct wil_sta_info *sta = &wil->sta[cid];
-		for (i = 0; i < WIL_STA_TID_NUM; i++) {
-			struct wil_tid_ampdu_rx *r = sta->tid_rx[i];
-			sta->tid_rx[i] = NULL;
-			wil_tid_ampdu_rx_free(wil, r);
-		}
+	might_sleep();
+	if (bssid) {
+		cid = wil_find_cid(wil, bssid);
+		wil_dbg_misc(wil, "%s(%pM, CID %d)\n", __func__, bssid, cid);
+	} else {
+		wil_dbg_misc(wil, "%s(all)\n", __func__);
 	}
 
-	wil_link_off(wil);
-	if (test_bit(wil_status_fwconnected, &wil->status)) {
-		clear_bit(wil_status_fwconnected, &wil->status);
-		cfg80211_disconnected(ndev,
-				      WLAN_STATUS_UNSPECIFIED_FAILURE,
-				      NULL, 0, GFP_KERNEL);
-	} else if (test_bit(wil_status_fwconnecting, &wil->status)) {
-		cfg80211_connect_result(ndev, bssid, NULL, 0, NULL, 0,
-					WLAN_STATUS_UNSPECIFIED_FAILURE,
-					GFP_KERNEL);
-	}
-	clear_bit(wil_status_fwconnecting, &wil->status);
-	for (i = 0; i < ARRAY_SIZE(wil->vring_tx); i++)
-		wil_vring_fini_tx(wil, i);
+	if (cid >= 0) /* disconnect 1 peer */
+		wil_disconnect_cid(wil, cid);
+	else /* disconnect all */
+		for (cid = 0; cid < WIL6210_MAX_CID; cid++)
+			wil_disconnect_cid(wil, cid);
 
-	clear_bit(wil_status_dontscan, &wil->status);
+	/* link state */
+	switch (wdev->iftype) {
+	case NL80211_IFTYPE_STATION:
+	case NL80211_IFTYPE_P2P_CLIENT:
+		wil_link_off(wil);
+		if (test_bit(wil_status_fwconnected, &wil->status)) {
+			clear_bit(wil_status_fwconnected, &wil->status);
+			cfg80211_disconnected(ndev,
+					      WLAN_STATUS_UNSPECIFIED_FAILURE,
+					      NULL, 0, GFP_KERNEL);
+		} else if (test_bit(wil_status_fwconnecting, &wil->status)) {
+			cfg80211_connect_result(ndev, bssid, NULL, 0, NULL, 0,
+						WLAN_STATUS_UNSPECIFIED_FAILURE,
+						GFP_KERNEL);
+		}
+		clear_bit(wil_status_fwconnecting, &wil->status);
+		wil_dbg_misc(wil, "clear_bit(wil_status_dontscan)\n");
+		clear_bit(wil_status_dontscan, &wil->status);
+		break;
+	default:
+		/* AP-like interface and monitor:
+		 * never scan, always connected
+		 */
+		if (bssid)
+			cfg80211_del_sta(ndev, bssid, GFP_KERNEL);
+		break;
+	}
 }
 
 static void wil_disconnect_worker(struct work_struct *work)
-- 
1.8.3.2

