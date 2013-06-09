Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from sabertooth02.qualcomm.com ([65.197.215.38]:33800 "EHLO
	sabertooth02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753546Ab3FIOfq (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 9 Jun 2013 10:35:46 -0400
Cc: Kirshenbaum Erez <erezk@wilocity.com>,
	Johannes Berg <johannes@sipsolutions.net>,
	<linux-wireless@vger.kernel.org>,
	"Luis R . Rodriguez" <rodrigue@qca.qualcomm.com>,
	Vladimir Kondratiev <qca_vkondrat@qca.qualcomm.com>
From: Vladimir Kondratiev <qca_vkondrat@qca.qualcomm.com>
To: "John W . Linville" <linville@tuxdriver.com>
Subject: [PATCH v3] wil6210: Fix AP/PCP start flow
Date: Sun, 9 Jun 2013 17:35:28 +0300
Message-ID: <1370788528-16095-1-git-send-email-qca_vkondrat@qca.qualcomm.com> (sfid-20130609_163548_805826_FC82B7AA)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Kirshenbaum Erez <erezk@wilocity.com>

WMI PCP Start flow should not be handled through:
net_device_ops->ndo_open()->wil_up()->__wil_up()
because it missing mandatory FW parameters (SSID,Channel,IEs, Security...).

Prior to AP starting __wil_up() may be called with iftype set
cfg80211_ops->change_virtual_intf(NL80211_IFTYPE_AP or STATION)
depend on the application hostapd/wpa_supplicant/iw.
there should not be an attempt to start an AP flow,
AP/PCP start flow will be started latter by cfg80211_ops->start_ap().

Signed-off-by: Kirshenbaum Erez <erezk@wilocity.com>
Signed-off-by: Vladimir Kondratiev <qca_vkondrat@qca.qualcomm.com>
---
 drivers/net/wireless/ath/wil6210/main.c | 34 ---------------------------------
 1 file changed, 34 deletions(-)

diff --git a/drivers/net/wireless/ath/wil6210/main.c b/drivers/net/wireless/ath/wil6210/main.c
index 8cafa45..0a2844c 100644
--- a/drivers/net/wireless/ath/wil6210/main.c
+++ b/drivers/net/wireless/ath/wil6210/main.c
@@ -286,10 +286,7 @@ static int __wil_up(struct wil6210_priv *wil)
 {
 	struct net_device *ndev = wil_to_ndev(wil);
 	struct wireless_dev *wdev = wil->wdev;
-	struct ieee80211_channel *channel = wdev->preset_chandef.chan;
 	int rc;
-	int bi;
-	u16 wmi_nettype = wil_iftype_nl2wmi(wdev->iftype);
 
 	rc = wil_reset(wil);
 	if (rc)
@@ -300,32 +297,25 @@ static int __wil_up(struct wil6210_priv *wil)
 	if (rc)
 		return rc;
 
-	/* FIXME Firmware works now in PBSS mode(ToDS=0, FromDS=0) */
-	wmi_nettype = wil_iftype_nl2wmi(NL80211_IFTYPE_ADHOC);
 	switch (wdev->iftype) {
 	case NL80211_IFTYPE_STATION:
 		wil_dbg_misc(wil, "type: STATION\n");
-		bi = 0;
 		ndev->type = ARPHRD_ETHER;
 		break;
 	case NL80211_IFTYPE_AP:
 		wil_dbg_misc(wil, "type: AP\n");
-		bi = 100;
 		ndev->type = ARPHRD_ETHER;
 		break;
 	case NL80211_IFTYPE_P2P_CLIENT:
 		wil_dbg_misc(wil, "type: P2P_CLIENT\n");
-		bi = 0;
 		ndev->type = ARPHRD_ETHER;
 		break;
 	case NL80211_IFTYPE_P2P_GO:
 		wil_dbg_misc(wil, "type: P2P_GO\n");
-		bi = 100;
 		ndev->type = ARPHRD_ETHER;
 		break;
 	case NL80211_IFTYPE_MONITOR:
 		wil_dbg_misc(wil, "type: Monitor\n");
-		bi = 0;
 		ndev->type = ARPHRD_IEEE80211_RADIOTAP;
 		/* ARPHRD_IEEE80211 or ARPHRD_IEEE80211_RADIOTAP ? */
 		break;
@@ -333,33 +323,9 @@ static int __wil_up(struct wil6210_priv *wil)
 		return -EOPNOTSUPP;
 	}
 
-	/* Apply profile in the following order: */
-	/* SSID and channel for the AP */
-	switch (wdev->iftype) {
-	case NL80211_IFTYPE_AP:
-	case NL80211_IFTYPE_P2P_GO:
-		if (wdev->ssid_len == 0) {
-			wil_err(wil, "SSID not set\n");
-			return -EINVAL;
-		}
-		rc = wmi_set_ssid(wil, wdev->ssid_len, wdev->ssid);
-		if (rc)
-			return rc;
-		break;
-	default:
-		break;
-	}
-
 	/* MAC address - pre-requisite for other commands */
 	wmi_set_mac_address(wil, ndev->dev_addr);
 
-	/* Set up beaconing if required. */
-	if (bi > 0) {
-		rc = wmi_pcp_start(wil, bi, wmi_nettype,
-				   (channel ? channel->hw_value : 0));
-		if (rc)
-			return rc;
-	}
 
 	napi_enable(&wil->napi_rx);
 	napi_enable(&wil->napi_tx);
-- 
1.8.1.2

