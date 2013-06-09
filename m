Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mxout1.netvision.net.il ([194.90.9.20]:54026 "EHLO
	mxout1.netvision.net.il" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752165Ab3FIICB (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 9 Jun 2013 04:02:01 -0400
Received: from localhost.localdomain ([82.166.196.250])
 by mxout1.netvision.net.il
 (Oracle Communications Messaging Server 7u4-24.01(7.0.4.24.0) 64bit (built Nov
 17 2011)) with ESMTPA id <0MO400M098Z7VY60@mxout1.netvision.net.il> for
 linux-wireless@vger.kernel.org; Sun, 09 Jun 2013 11:01:58 +0300 (IDT)
From: Kirshenbaum Erez <erezk@wilocity.com>
To: qca_vkondrat@qca.qualcomm.com
Cc: linux-wireless@vger.kernel.org,
	Kirshenbaum Erez <erezk@wilocity.com>
Subject: [PATCH v2] wil6210: Fix AP/PCP start flow
Date: Sun, 09 Jun 2013 10:01:32 +0300
Message-id: <1370761292-13585-1-git-send-email-erezk@wilocity.com> (sfid-20130609_100205_557591_E35E1E62)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Proper flow for starting AP is by the wil_cfg80211_start_ap call (.start_ap)
Hostapd flow for AP mode will call first to __wil_up (.ndo_open)
and wil_cfg80211_start_ap.
All required parameters for AP mode are carry in the info structure of 
.start_ap (SSID,Channel,BI,IEs, security ...) and missing in __wil_up.

Signed-off-by: Kirshenbaum Erez <erezk@wilocity.com>
---
 drivers/net/wireless/ath/wil6210/main.c | 35 ---------------------------------
 1 file changed, 35 deletions(-)

diff --git a/drivers/net/wireless/ath/wil6210/main.c b/drivers/net/wireless/ath/wil6210/main.c
index c97b864..271ee22 100644
--- a/drivers/net/wireless/ath/wil6210/main.c
+++ b/drivers/net/wireless/ath/wil6210/main.c
@@ -286,41 +286,31 @@ static int __wil_up(struct wil6210_priv *wil)
 {
 	struct net_device *ndev = wil_to_ndev(wil);
 	struct wireless_dev *wdev = wil->wdev;
-	struct ieee80211_channel *channel = wdev->preset_chandef.chan;
 	int rc;
-	int bi;
-	u16 wmi_nettype = wil_iftype_nl2wmi(wdev->iftype);
 
 	rc = wil_reset(wil);
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
@@ -328,34 +318,9 @@ static int __wil_up(struct wil6210_priv *wil)
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
-
 	/* Rx VRING. After MAC and beacon */
 	wil_rx_init(wil);
 
-- 
1.7.11.7

