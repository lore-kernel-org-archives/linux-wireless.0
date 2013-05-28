Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from sabertooth02.qualcomm.com ([65.197.215.38]:53811 "EHLO
	sabertooth02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933792Ab3E1MSK (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 28 May 2013 08:18:10 -0400
Cc: Vladimir Kondratiev <qca_vkondrat@qca.qualcomm.com>,
	Johannes Berg <johannes@sipsolutions.net>,
	<linux-wireless@vger.kernel.org>,
	"Luis R . Rodriguez" <rodrigue@qca.qualcomm.com>
From: Vladimir Kondratiev <qca_vkondrat@qca.qualcomm.com>
To: "John W . Linville" <linville@tuxdriver.com>
Subject: [PATCH 2/2] wil6210: Don't use wdev->sme_state
Date: Tue, 28 May 2013 15:17:53 +0300
Message-ID: <1369743473-7243-3-git-send-email-qca_vkondrat@qca.qualcomm.com> (sfid-20130528_141815_740089_2A35F07F)
In-Reply-To: <1369743473-7243-1-git-send-email-qca_vkondrat@qca.qualcomm.com>
References: <1369743473-7243-1-git-send-email-qca_vkondrat@qca.qualcomm.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

sme_state is private wdev's variable.
Track connection state internally

Signed-off-by: Vladimir Kondratiev <qca_vkondrat@qca.qualcomm.com>
---
 drivers/net/wireless/ath/wil6210/cfg80211.c |  4 ++++
 drivers/net/wireless/ath/wil6210/main.c     | 17 ++++++-----------
 drivers/net/wireless/ath/wil6210/wil6210.h  |  1 +
 drivers/net/wireless/ath/wil6210/wmi.c      |  3 ++-
 4 files changed, 13 insertions(+), 12 deletions(-)

diff --git a/drivers/net/wireless/ath/wil6210/cfg80211.c b/drivers/net/wireless/ath/wil6210/cfg80211.c
index c5d4a87..4eb05d0 100644
--- a/drivers/net/wireless/ath/wil6210/cfg80211.c
+++ b/drivers/net/wireless/ath/wil6210/cfg80211.c
@@ -322,12 +322,16 @@ static int wil_cfg80211_connect(struct wiphy *wiphy,
 	 * FW don't support scan after connection attempt
 	 */
 	set_bit(wil_status_dontscan, &wil->status);
+	set_bit(wil_status_fwconnecting, &wil->status);
 
 	rc = wmi_send(wil, WMI_CONNECT_CMDID, &conn, sizeof(conn));
 	if (rc == 0) {
 		/* Connect can take lots of time */
 		mod_timer(&wil->connect_timer,
 			  jiffies + msecs_to_jiffies(2000));
+	} else {
+		clear_bit(wil_status_dontscan, &wil->status);
+		clear_bit(wil_status_fwconnecting, &wil->status);
 	}
 
  out:
diff --git a/drivers/net/wireless/ath/wil6210/main.c b/drivers/net/wireless/ath/wil6210/main.c
index ea49c8a..1d99c0e 100644
--- a/drivers/net/wireless/ath/wil6210/main.c
+++ b/drivers/net/wireless/ath/wil6210/main.c
@@ -61,22 +61,17 @@ static void _wil6210_disconnect(struct wil6210_priv *wil, void *bssid)
 	wil_dbg_misc(wil, "%s()\n", __func__);
 
 	wil_link_off(wil);
-	clear_bit(wil_status_fwconnected, &wil->status);
-
-	switch (wdev->sme_state) {
-	case CFG80211_SME_CONNECTED:
-		cfg80211_disconnected(ndev, WLAN_STATUS_UNSPECIFIED_FAILURE,
+	if (test_bit(wil_status_fwconnected, &wil->status)) {
+		clear_bit(wil_status_fwconnected, &wil->status);
+		cfg80211_disconnected(ndev,
+				      WLAN_STATUS_UNSPECIFIED_FAILURE,
 				      NULL, 0, GFP_KERNEL);
-		break;
-	case CFG80211_SME_CONNECTING:
+	} else if (test_bit(wil_status_fwconnecting, &wil->status)) {
 		cfg80211_connect_result(ndev, bssid, NULL, 0, NULL, 0,
 					WLAN_STATUS_UNSPECIFIED_FAILURE,
 					GFP_KERNEL);
-		break;
-	default:
-		break;
 	}
-
+	clear_bit(wil_status_fwconnecting, &wil->status);
 	for (i = 0; i < ARRAY_SIZE(wil->vring_tx); i++)
 		wil_vring_fini_tx(wil, i);
 
diff --git a/drivers/net/wireless/ath/wil6210/wil6210.h b/drivers/net/wireless/ath/wil6210/wil6210.h
index 2e3c26e..373cf65 100644
--- a/drivers/net/wireless/ath/wil6210/wil6210.h
+++ b/drivers/net/wireless/ath/wil6210/wil6210.h
@@ -186,6 +186,7 @@ struct vring {
 
 enum { /* for wil6210_priv.status */
 	wil_status_fwready = 0,
+	wil_status_fwconnecting,
 	wil_status_fwconnected,
 	wil_status_dontscan,
 	wil_status_reset_done,
diff --git a/drivers/net/wireless/ath/wil6210/wmi.c b/drivers/net/wireless/ath/wil6210/wmi.c
index a091eb1..527ffb5 100644
--- a/drivers/net/wireless/ath/wil6210/wmi.c
+++ b/drivers/net/wireless/ath/wil6210/wmi.c
@@ -409,7 +409,7 @@ static void wmi_evt_connect(struct wil6210_priv *wil, int id, void *d, int len)
 
 	if ((wdev->iftype == NL80211_IFTYPE_STATION) ||
 	    (wdev->iftype == NL80211_IFTYPE_P2P_CLIENT)) {
-		if (wdev->sme_state != CFG80211_SME_CONNECTING) {
+		if (!test_bit(wil_status_fwconnecting, &wil->status)) {
 			wil_err(wil, "Not in connecting state\n");
 			return;
 		}
@@ -433,6 +433,7 @@ static void wmi_evt_connect(struct wil6210_priv *wil, int id, void *d, int len)
 
 		cfg80211_new_sta(ndev, evt->bssid, &sinfo, GFP_KERNEL);
 	}
+	clear_bit(wil_status_fwconnecting, &wil->status);
 	set_bit(wil_status_fwconnected, &wil->status);
 
 	/* FIXME FW can transmit only ucast frames to peer */
-- 
1.8.1.2

