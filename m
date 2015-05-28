Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx0b-0016f401.pphosted.com ([67.231.156.173]:31489 "EHLO
	mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754106AbbE1NAM (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 28 May 2015 09:00:12 -0400
Received: from pps.filterd (m0045851.ppops.net [127.0.0.1])
	by mx0b-0016f401.pphosted.com (8.14.5/8.14.5) with SMTP id t4SCxbgS014874
	for <linux-wireless@vger.kernel.org>; Thu, 28 May 2015 06:00:11 -0700
Received: from sc-owa04.marvell.com ([199.233.58.150])
	by mx0b-0016f401.pphosted.com with ESMTP id 1unvy5rwvp-1
	(version=TLSv1/SSLv3 cipher=AES128-SHA bits=128 verify=NOT)
	for <linux-wireless@vger.kernel.org>; Thu, 28 May 2015 06:00:11 -0700
From: Avinash Patil <patila@marvell.com>
To: <linux-wireless@vger.kernel.org>
CC: <akarwar@marvell.com>, <cluo@marvell.com>, <huxm@marvell.com>,
	Avinash Patil <patila@marvell.com>
Subject: [PATCH 10/17] mwifiex: dump station support in uap mode
Date: Thu, 28 May 2015 23:59:00 +0530
Message-ID: <1432837747-2075-11-git-send-email-patila@marvell.com> (sfid-20150528_150016_850101_1CCF9A5D)
In-Reply-To: <1432837747-2075-1-git-send-email-patila@marvell.com>
References: <1432837747-2075-1-git-send-email-patila@marvell.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Xinming Hu <huxm@marvell.com>

This patch extend cfg80211 dump_station handler, support for
dump stations associated to mwifiex micro AP.

Signed-off-by: Xinming Hu <huxm@marvell.com>
Signed-off-by: Avinash Patil <patila@marvell.com>
Signed-off-by: Cathy Luo <cluo@marvell.com>
---
 drivers/net/wireless/mwifiex/cfg80211.c | 51 +++++++++++++++++++++++++++++----
 1 file changed, 46 insertions(+), 5 deletions(-)

diff --git a/drivers/net/wireless/mwifiex/cfg80211.c b/drivers/net/wireless/mwifiex/cfg80211.c
index ddeb919..16528c1 100644
--- a/drivers/net/wireless/mwifiex/cfg80211.c
+++ b/drivers/net/wireless/mwifiex/cfg80211.c
@@ -1229,6 +1229,7 @@ mwifiex_parse_htinfo(struct mwifiex_private *priv, u8 tx_htinfo,
  */
 static int
 mwifiex_dump_station_info(struct mwifiex_private *priv,
+			  struct mwifiex_sta_node *node,
 			  struct station_info *sinfo)
 {
 	u32 rate;
@@ -1238,6 +1239,30 @@ mwifiex_dump_station_info(struct mwifiex_private *priv,
 			BIT(NL80211_STA_INFO_TX_BITRATE) |
 			BIT(NL80211_STA_INFO_SIGNAL) | BIT(NL80211_STA_INFO_SIGNAL_AVG);
 
+	if (GET_BSS_ROLE(priv) == MWIFIEX_BSS_ROLE_UAP) {
+		if (!node)
+			return -ENOENT;
+
+		sinfo->filled |= BIT(NL80211_STA_INFO_INACTIVE_TIME) |
+				BIT(NL80211_STA_INFO_TX_FAILED);
+		sinfo->inactive_time =
+			jiffies_to_msecs(jiffies - node->stats.last_rx);
+
+		sinfo->signal = node->stats.rssi;
+		sinfo->signal_avg = node->stats.rssi;
+		sinfo->rx_bytes = node->stats.rx_bytes;
+		sinfo->tx_bytes = node->stats.tx_bytes;
+		sinfo->rx_packets = node->stats.rx_packets;
+		sinfo->tx_packets = node->stats.tx_packets;
+		sinfo->tx_failed = node->stats.tx_failed;
+
+		mwifiex_parse_htinfo(priv, node->stats.last_tx_htinfo,
+				     &sinfo->txrate);
+		sinfo->txrate.legacy = node->stats.last_tx_rate * 5;
+
+		return 0;
+	}
+
 	/* Get signal information from the firmware */
 	if (mwifiex_send_cmd(priv, HostCmd_CMD_RSSI_INFO,
 			     HostCmd_ACT_GEN_GET, 0, NULL, true)) {
@@ -1304,7 +1329,7 @@ mwifiex_cfg80211_get_station(struct wiphy *wiphy, struct net_device *dev,
 	if (memcmp(mac, priv->cfg_bssid, ETH_ALEN))
 		return -ENOENT;
 
-	return mwifiex_dump_station_info(priv, sinfo);
+	return mwifiex_dump_station_info(priv, NULL, sinfo);
 }
 
 /*
@@ -1315,13 +1340,29 @@ mwifiex_cfg80211_dump_station(struct wiphy *wiphy, struct net_device *dev,
 			      int idx, u8 *mac, struct station_info *sinfo)
 {
 	struct mwifiex_private *priv = mwifiex_netdev_get_priv(dev);
+	static struct mwifiex_sta_node *node;
 
-	if (!priv->media_connected || idx)
-		return -ENOENT;
+	if ((GET_BSS_ROLE(priv) == MWIFIEX_BSS_ROLE_STA) &&
+	    priv->media_connected && idx == 0) {
+		ether_addr_copy(mac, priv->cfg_bssid);
+		return mwifiex_dump_station_info(priv, NULL, sinfo);
+	} else if (GET_BSS_ROLE(priv) == MWIFIEX_BSS_ROLE_UAP) {
+		mwifiex_send_cmd(priv, HOSTCMD_CMD_UAP_STA_LIST,
+				 HostCmd_ACT_GEN_GET, 0, NULL, true);
+
+		if (node && (&node->list == &priv->sta_list)) {
+			node = NULL;
+			return -ENOENT;
+		}
 
-	memcpy(mac, priv->cfg_bssid, ETH_ALEN);
+		node = list_prepare_entry(node, &priv->sta_list, list);
+		list_for_each_entry_continue(node, &priv->sta_list, list) {
+			ether_addr_copy(mac, node->mac_addr);
+			return mwifiex_dump_station_info(priv, node, sinfo);
+		}
+	}
 
-	return mwifiex_dump_station_info(priv, sinfo);
+	return -ENOENT;
 }
 
 static int
-- 
1.8.1.4

