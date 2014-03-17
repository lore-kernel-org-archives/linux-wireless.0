Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine02.qualcomm.com ([199.106.114.251]:45364 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932834AbaCQNfM (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 17 Mar 2014 09:35:12 -0400
From: Vladimir Kondratiev <qca_vkondrat@qca.qualcomm.com>
To: "John W . Linville" <linville@tuxdriver.com>
CC: Vladimir Kondratiev <qca_vkondrat@qca.qualcomm.com>,
	<linux-wireless@vger.kernel.org>, <wil6210@qca.qualcomm.com>
Subject: [PATCH 17/21] wil6210: serialize fw_recovery and start_ap
Date: Mon, 17 Mar 2014 15:34:21 +0200
Message-ID: <1395063265-6522-18-git-send-email-qca_vkondrat@qca.qualcomm.com> (sfid-20140317_145649_497303_29056559)
In-Reply-To: <1395063265-6522-1-git-send-email-qca_vkondrat@qca.qualcomm.com>
References: <1395063265-6522-1-git-send-email-qca_vkondrat@qca.qualcomm.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

These methods can change device state, serialize with others
similar ones like up/down

Signed-off-by: Vladimir Kondratiev <qca_vkondrat@qca.qualcomm.com>
---
 drivers/net/wireless/ath/wil6210/cfg80211.c | 15 +++++++++++----
 drivers/net/wireless/ath/wil6210/main.c     |  2 ++
 2 files changed, 13 insertions(+), 4 deletions(-)

diff --git a/drivers/net/wireless/ath/wil6210/cfg80211.c b/drivers/net/wireless/ath/wil6210/cfg80211.c
index 597540a..ed5a7e1 100644
--- a/drivers/net/wireless/ath/wil6210/cfg80211.c
+++ b/drivers/net/wireless/ath/wil6210/cfg80211.c
@@ -609,18 +609,20 @@ static int wil_cfg80211_start_ap(struct wiphy *wiphy,
 	if (wil_fix_bcon(wil, bcon))
 		wil_dbg_misc(wil, "Fixed bcon\n");
 
+	mutex_lock(&wil->mutex);
+
 	rc = wil_reset(wil);
 	if (rc)
-		return rc;
+		goto out;
 
 	/* Rx VRING. */
 	rc = wil_rx_init(wil);
 	if (rc)
-		return rc;
+		goto out;
 
 	rc = wmi_set_ssid(wil, info->ssid_len, info->ssid);
 	if (rc)
-		return rc;
+		goto out;
 
 	/* MAC address - pre-requisite for other commands */
 	wmi_set_mac_address(wil, ndev->dev_addr);
@@ -644,11 +646,13 @@ static int wil_cfg80211_start_ap(struct wiphy *wiphy,
 	rc = wmi_pcp_start(wil, info->beacon_interval, wmi_nettype,
 			   channel->hw_value);
 	if (rc)
-		return rc;
+		goto out;
 
 
 	netif_carrier_on(ndev);
 
+out:
+	mutex_unlock(&wil->mutex);
 	return rc;
 }
 
@@ -658,8 +662,11 @@ static int wil_cfg80211_stop_ap(struct wiphy *wiphy,
 	int rc = 0;
 	struct wil6210_priv *wil = wiphy_to_wil(wiphy);
 
+	mutex_lock(&wil->mutex);
+
 	rc = wmi_pcp_stop(wil);
 
+	mutex_unlock(&wil->mutex);
 	return rc;
 }
 
diff --git a/drivers/net/wireless/ath/wil6210/main.c b/drivers/net/wireless/ath/wil6210/main.c
index 32ac1b9..351925b 100644
--- a/drivers/net/wireless/ath/wil6210/main.c
+++ b/drivers/net/wireless/ath/wil6210/main.c
@@ -159,6 +159,7 @@ static void wil_fw_error_worker(struct work_struct *work)
 	if (no_fw_recovery)
 		return;
 
+	mutex_lock(&wil->mutex);
 	switch (wdev->iftype) {
 	case NL80211_IFTYPE_STATION:
 	case NL80211_IFTYPE_P2P_CLIENT:
@@ -176,6 +177,7 @@ static void wil_fw_error_worker(struct work_struct *work)
 	default:
 		break;
 	}
+	mutex_unlock(&wil->mutex);
 }
 
 static int wil_find_free_vring(struct wil6210_priv *wil)
-- 
1.8.3.2

