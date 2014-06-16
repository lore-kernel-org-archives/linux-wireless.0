Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine01.qualcomm.com ([199.106.114.254]:63181 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755294AbaFPQio (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 16 Jun 2014 12:38:44 -0400
From: Vladimir Kondratiev <qca_vkondrat@qca.qualcomm.com>
To: "John W . Linville" <linville@tuxdriver.com>
CC: Vladimir Kondratiev <qca_vkondrat@qca.qualcomm.com>,
	<linux-wireless@vger.kernel.org>, <wil6210@qca.qualcomm.com>
Subject: [PATCH 18/25] wil6210: fix disconnect handling for AP
Date: Mon, 16 Jun 2014 19:37:16 +0300
Message-ID: <1402936643-31819-19-git-send-email-qca_vkondrat@qca.qualcomm.com> (sfid-20140616_190457_995762_18A060D0)
In-Reply-To: <1402936643-31819-1-git-send-email-qca_vkondrat@qca.qualcomm.com>
References: <1402936643-31819-1-git-send-email-qca_vkondrat@qca.qualcomm.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

For the AP-like interface, if "disconnect all" requested,
every station should be deleted with cfg80211_del_sta().
Implement this behavior.

Signed-off-by: Vladimir Kondratiev <qca_vkondrat@qca.qualcomm.com>
---
 drivers/net/wireless/ath/wil6210/main.c | 18 +++++++++++++-----
 1 file changed, 13 insertions(+), 5 deletions(-)

diff --git a/drivers/net/wireless/ath/wil6210/main.c b/drivers/net/wireless/ath/wil6210/main.c
index 33b89d1..6cc4791 100644
--- a/drivers/net/wireless/ath/wil6210/main.c
+++ b/drivers/net/wireless/ath/wil6210/main.c
@@ -61,11 +61,24 @@ void wil_memcpy_toio_32(volatile void __iomem *dst, const void *src,
 static void wil_disconnect_cid(struct wil6210_priv *wil, int cid)
 {
 	uint i;
+	struct net_device *ndev = wil_to_ndev(wil);
+	struct wireless_dev *wdev = wil->wdev;
 	struct wil_sta_info *sta = &wil->sta[cid];
+	wil_dbg_misc(wil, "%s(CID %d, status %d)\n", __func__, cid,
+		     sta->status);
 
 	sta->data_port_open = false;
 	if (sta->status != wil_sta_unused) {
 		wmi_disconnect_sta(wil, sta->addr, WLAN_REASON_DEAUTH_LEAVING);
+		switch (wdev->iftype) {
+		case NL80211_IFTYPE_AP:
+		case NL80211_IFTYPE_P2P_GO:
+			/* AP-like interface */
+			cfg80211_del_sta(ndev, sta->addr, GFP_KERNEL);
+			break;
+		default:
+			break;
+		}
 		sta->status = wil_sta_unused;
 	}
 
@@ -119,11 +132,6 @@ static void _wil6210_disconnect(struct wil6210_priv *wil, const u8 *bssid)
 		clear_bit(wil_status_fwconnecting, &wil->status);
 		break;
 	default:
-		/* AP-like interface and monitor:
-		 * never scan, always connected
-		 */
-		if (bssid)
-			cfg80211_del_sta(ndev, bssid, GFP_KERNEL);
 		break;
 	}
 }
-- 
1.9.1

