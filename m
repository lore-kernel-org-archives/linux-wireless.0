Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from esa6.microchip.iphmx.com ([216.71.154.253]:30119 "EHLO
        esa6.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751071AbeAPODZ (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 16 Jan 2018 09:03:25 -0500
From: Ajay Singh <ajay.kathat@microchip.com>
To: <linux-wireless@vger.kernel.org>
CC: <devel@driverdev.osuosl.org>, <gregkh@linuxfoundation.org>,
        <ganesh.krishna@microchip.com>, <venkateswara.kaja@microchip.com>,
        <aditya.shankar@microchip.com>, <claudiu.beznea@microchip.com>,
        Ajay Singh <ajay.kathat@microchip.com>
Subject: [PATCH 13/13] staging: wilc1000: rename strStatistics & tenuAuth_type to avoid camelCase
Date: Tue, 16 Jan 2018 19:32:31 +0530
Message-ID: <1516111351-5353-14-git-send-email-ajay.kathat@microchip.com> (sfid-20180116_150331_176361_991938CA)
In-Reply-To: <1516111351-5353-1-git-send-email-ajay.kathat@microchip.com>
References: <1516111351-5353-1-git-send-email-ajay.kathat@microchip.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This is a cleanup patch to avoid using camelCase for variable names.
Changes fix "Avoid camelCase" issue reported by checkpatch.pl script.

Signed-off-by: Ajay Singh <ajay.kathat@microchip.com>
---
 drivers/staging/wilc1000/wilc_wfi_cfgoperations.c | 30 +++++++++++------------
 1 file changed, 15 insertions(+), 15 deletions(-)

diff --git a/drivers/staging/wilc1000/wilc_wfi_cfgoperations.c b/drivers/staging/wilc1000/wilc_wfi_cfgoperations.c
index 0570b2d..47c7e2e 100644
--- a/drivers/staging/wilc1000/wilc_wfi_cfgoperations.c
+++ b/drivers/staging/wilc1000/wilc_wfi_cfgoperations.c
@@ -653,7 +653,7 @@ static int connect(struct wiphy *wiphy, struct net_device *dev,
 	u32 i;
 	u32 sel_bssi_idx = UINT_MAX;
 	u8 u8security = NO_ENCRYPT;
-	enum AUTHTYPE tenuAuth_type = ANY;
+	enum AUTHTYPE auth_type = ANY;
 
 	struct wilc_priv *priv;
 	struct host_if_drv *wfi_drv;
@@ -763,11 +763,11 @@ static int connect(struct wiphy *wiphy, struct net_device *dev,
 
 	switch (sme->auth_type)	{
 	case NL80211_AUTHTYPE_OPEN_SYSTEM:
-		tenuAuth_type = OPEN_SYSTEM;
+		auth_type = OPEN_SYSTEM;
 		break;
 
 	case NL80211_AUTHTYPE_SHARED_KEY:
-		tenuAuth_type = SHARED_KEY;
+		auth_type = SHARED_KEY;
 		break;
 
 	default:
@@ -777,7 +777,7 @@ static int connect(struct wiphy *wiphy, struct net_device *dev,
 	if (sme->crypto.n_akm_suites) {
 		switch (sme->crypto.akm_suites[0]) {
 		case WLAN_AKM_SUITE_8021X:
-			tenuAuth_type = IEEE8021;
+			auth_type = IEEE8021;
 			break;
 
 		default:
@@ -795,7 +795,7 @@ static int connect(struct wiphy *wiphy, struct net_device *dev,
 	ret = wilc_set_join_req(vif, pstrNetworkInfo->bssid, sme->ssid,
 				     sme->ssid_len, sme->ie, sme->ie_len,
 				     cfg_connect_result, (void *)priv,
-				     u8security, tenuAuth_type,
+				     u8security, auth_type,
 				     pstrNetworkInfo->ch,
 				     pstrNetworkInfo->join_params);
 	if (ret != 0) {
@@ -1200,9 +1200,9 @@ static int get_station(struct wiphy *wiphy, struct net_device *dev,
 	}
 
 	if (vif->iftype == STATION_MODE) {
-		struct rf_info strStatistics;
+		struct rf_info stats;
 
-		wilc_get_statistics(vif, &strStatistics);
+		wilc_get_statistics(vif, &stats);
 
 		sinfo->filled |= BIT(NL80211_STA_INFO_SIGNAL) |
 						BIT(NL80211_STA_INFO_RX_PACKETS) |
@@ -1210,16 +1210,16 @@ static int get_station(struct wiphy *wiphy, struct net_device *dev,
 						BIT(NL80211_STA_INFO_TX_FAILED) |
 						BIT(NL80211_STA_INFO_TX_BITRATE);
 
-		sinfo->signal = strStatistics.rssi;
-		sinfo->rx_packets = strStatistics.rx_cnt;
-		sinfo->tx_packets = strStatistics.tx_cnt + strStatistics.tx_fail_cnt;
-		sinfo->tx_failed = strStatistics.tx_fail_cnt;
-		sinfo->txrate.legacy = strStatistics.link_speed * 10;
+		sinfo->signal = stats.rssi;
+		sinfo->rx_packets = stats.rx_cnt;
+		sinfo->tx_packets = stats.tx_cnt + stats.tx_fail_cnt;
+		sinfo->tx_failed = stats.tx_fail_cnt;
+		sinfo->txrate.legacy = stats.link_speed * 10;
 
-		if ((strStatistics.link_speed > TCP_ACK_FILTER_LINK_SPEED_THRESH) &&
-		    (strStatistics.link_speed != DEFAULT_LINK_SPEED))
+		if ((stats.link_speed > TCP_ACK_FILTER_LINK_SPEED_THRESH) &&
+		    (stats.link_speed != DEFAULT_LINK_SPEED))
 			wilc_enable_tcp_ack_filter(true);
-		else if (strStatistics.link_speed != DEFAULT_LINK_SPEED)
+		else if (stats.link_speed != DEFAULT_LINK_SPEED)
 			wilc_enable_tcp_ack_filter(false);
 	}
 	return 0;
-- 
2.7.4
