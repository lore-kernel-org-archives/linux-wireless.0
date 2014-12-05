Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx0b-0016f401.pphosted.com ([67.231.156.173]:44186 "EHLO
	mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753097AbaLEMYc (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 5 Dec 2014 07:24:32 -0500
From: Avinash Patil <patila@marvell.com>
To: <linville@tuxdriver.com>
CC: <linux-wireless@vger.kernel.org>, <akarwar@marvell.com>,
	<cluo@marvell.com>, <yangyang@marvell.com>,
	Avinash Patil <patila@marvell.com>
Subject: [PATCH 4/4] mwifiex: do not process broadcast mac address for del_sta
Date: Fri, 5 Dec 2014 23:23:42 +0530
Message-ID: <1417802022-7364-4-git-send-email-patila@marvell.com> (sfid-20141205_132446_590949_7E7A2146)
In-Reply-To: <1417802022-7364-1-git-send-email-patila@marvell.com>
References: <1417802022-7364-1-git-send-email-patila@marvell.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Generally broadcast mac address deauth is followed by stop_ap or start_ap.
In both cases, FW already has provision to send deauth; so there is no
need to handle broadcast mac deauthentication.

Signed-off-by: Avinash Patil <patila@marvell.com>
Signed-off-by: Cathy Luo <cluo@marvell.com>
---
 drivers/net/wireless/mwifiex/cfg80211.c | 39 ++++++++++++++++-----------------
 1 file changed, 19 insertions(+), 20 deletions(-)

diff --git a/drivers/net/wireless/mwifiex/cfg80211.c b/drivers/net/wireless/mwifiex/cfg80211.c
index e111ff5..4a66a655 100644
--- a/drivers/net/wireless/mwifiex/cfg80211.c
+++ b/drivers/net/wireless/mwifiex/cfg80211.c
@@ -1296,31 +1296,30 @@ mwifiex_cfg80211_del_station(struct wiphy *wiphy, struct net_device *dev,
 {
 	struct mwifiex_private *priv = mwifiex_netdev_get_priv(dev);
 	struct mwifiex_sta_node *sta_node;
+	u8 deauth_mac[ETH_ALEN];
 	unsigned long flags;
 
 	if (list_empty(&priv->sta_list) || !priv->bss_started)
 		return 0;
 
-	if (!params->mac || is_broadcast_ether_addr(params->mac)) {
-		wiphy_dbg(wiphy, "%s: NULL/broadcast mac address\n", __func__);
-		list_for_each_entry(sta_node, &priv->sta_list, list) {
-			if (mwifiex_send_cmd(priv, HostCmd_CMD_UAP_STA_DEAUTH,
-					     HostCmd_ACT_GEN_SET, 0,
-					     sta_node->mac_addr, true))
-				return -1;
-		}
-	} else {
-		wiphy_dbg(wiphy, "%s: mac address %pM\n", __func__,
-			  params->mac);
-		spin_lock_irqsave(&priv->sta_list_spinlock, flags);
-		sta_node = mwifiex_get_sta_entry(priv, params->mac);
-		spin_unlock_irqrestore(&priv->sta_list_spinlock, flags);
-		if (sta_node) {
-			if (mwifiex_send_cmd(priv, HostCmd_CMD_UAP_STA_DEAUTH,
-					     HostCmd_ACT_GEN_SET, 0,
-					     sta_node->mac_addr, true))
-				return -1;
-		}
+	if (!params->mac || is_broadcast_ether_addr(params->mac))
+		return 0;
+
+	wiphy_dbg(wiphy, "%s: mac address %pM\n", __func__, params->mac);
+
+	memset(deauth_mac, 0, ETH_ALEN);
+
+	spin_lock_irqsave(&priv->sta_list_spinlock, flags);
+	sta_node = mwifiex_get_sta_entry(priv, params->mac);
+	if (sta_node)
+		ether_addr_copy(deauth_mac, params->mac);
+	spin_unlock_irqrestore(&priv->sta_list_spinlock, flags);
+
+	if (is_valid_ether_addr(deauth_mac)) {
+		if (mwifiex_send_cmd(priv, HostCmd_CMD_UAP_STA_DEAUTH,
+				     HostCmd_ACT_GEN_SET, 0,
+				     deauth_mac, true))
+			return -1;
 	}
 
 	return 0;
-- 
1.8.1.4

