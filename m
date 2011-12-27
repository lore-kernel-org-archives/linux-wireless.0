Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine01.qualcomm.com ([199.106.114.254]:39967 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751207Ab1L0JDI (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 27 Dec 2011 04:03:08 -0500
Date: Tue, 27 Dec 2011 11:02:56 +0200
From: Jouni Malinen <jouni@qca.qualcomm.com>
To: Kalle Valo <kvalo@qca.qualcomm.com>
CC: <linux-wireless@vger.kernel.org>, <ath6kl-devel@qualcomm.com>
Subject: [PATCH] ath6kl: Add del_station cfg80211_ops
Message-ID: <20111227090256.GA14371@jouni.qca.qualcomm.com> (sfid-20111227_100339_064283_B042FBC6)
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

hostapd/wpa_supplicant AP mode uses this operation to flush the station
entries. Implement this in ath6kl to avoid unnecessary warnings from
NL80211_CMD_DEL_STATION failing.

Signed-off-by: Jouni Malinen <jouni@qca.qualcomm.com>
---
 drivers/net/wireless/ath/ath6kl/cfg80211.c |   14 ++++++++++++++
 1 files changed, 14 insertions(+), 0 deletions(-)

diff --git a/drivers/net/wireless/ath/ath6kl/cfg80211.c b/drivers/net/wireless/ath/ath6kl/cfg80211.c
index d6806be..f74762e 100644
--- a/drivers/net/wireless/ath/ath6kl/cfg80211.c
+++ b/drivers/net/wireless/ath/ath6kl/cfg80211.c
@@ -2300,6 +2300,19 @@ static int ath6kl_del_beacon(struct wiphy *wiphy, struct net_device *dev)
 	return 0;
 }
 
+static const u8 bcast_addr[ETH_ALEN] = { 0xff, 0xff, 0xff, 0xff, 0xff, 0xff };
+
+static int ath6kl_del_station(struct wiphy *wiphy, struct net_device *dev,
+			      u8 *mac)
+{
+	struct ath6kl *ar = ath6kl_priv(dev);
+	struct ath6kl_vif *vif = netdev_priv(dev);
+	const u8 *addr = mac ? mac : bcast_addr;
+
+	return ath6kl_wmi_ap_set_mlme(ar->wmi, vif->fw_vif_idx, WMI_AP_DEAUTH,
+				      addr, WLAN_REASON_PREV_AUTH_NOT_VALID);
+}
+
 static int ath6kl_change_station(struct wiphy *wiphy, struct net_device *dev,
 				 u8 *mac, struct station_parameters *params)
 {
@@ -2603,6 +2616,7 @@ static struct cfg80211_ops ath6kl_cfg80211_ops = {
 	.add_beacon = ath6kl_add_beacon,
 	.set_beacon = ath6kl_set_beacon,
 	.del_beacon = ath6kl_del_beacon,
+	.del_station = ath6kl_del_station,
 	.change_station = ath6kl_change_station,
 	.remain_on_channel = ath6kl_remain_on_channel,
 	.cancel_remain_on_channel = ath6kl_cancel_remain_on_channel,
-- 
1.7.4.1


-- 
Jouni Malinen                                            PGP id EFC895FA
