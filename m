Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine01.qualcomm.com ([199.106.114.254]:62784 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754462AbaJJSEh (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 10 Oct 2014 14:04:37 -0400
Date: Fri, 10 Oct 2014 21:04:25 +0300
From: Jouni Malinen <jouni@qca.qualcomm.com>
To: Kalle Valo <kvalo@qca.qualcomm.com>
CC: <linux-wireless@vger.kernel.org>
Subject: [RFC] ath6kl: Use new del_station parameters
Message-ID: <20141010180425.GA2836@jouni.qca.qualcomm.com> (sfid-20141010_200441_437108_F7975293)
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This allows user space (mainly, hostapd or wpa_supplicant in AP mode) to
specify whether to use Deauthentication or Disassociation frame and
which reason code to use in that frame when removing the station.

Signed-off-by: Jouni Malinen <jouni@qca.qualcomm.com>
---
 drivers/net/wireless/ath/ath6kl/cfg80211.c | 12 +++++++++---
 1 file changed, 9 insertions(+), 3 deletions(-)

This uses the proposed del_station() changes that I just posted on
linux-wireless. Once those are accepted into cfg80211, the following
changes in ath6kl could be used to take the extensions into use. This is
sent as an RFC since I have not had any chance of testing this yet.


diff --git a/drivers/net/wireless/ath/ath6kl/cfg80211.c b/drivers/net/wireless/ath/ath6kl/cfg80211.c
index 7a53378..f787bc7 100644
--- a/drivers/net/wireless/ath/ath6kl/cfg80211.c
+++ b/drivers/net/wireless/ath/ath6kl/cfg80211.c
@@ -2981,9 +2981,15 @@ static int ath6kl_del_station(struct wiphy *wiphy, struct net_device *dev,
 	struct ath6kl *ar = ath6kl_priv(dev);
 	struct ath6kl_vif *vif = netdev_priv(dev);
 	const u8 *addr = params->mac ? params->mac : bcast_addr;
-
-	return ath6kl_wmi_ap_set_mlme(ar->wmi, vif->fw_vif_idx, WMI_AP_DEAUTH,
-				      addr, WLAN_REASON_PREV_AUTH_NOT_VALID);
+	u8 cmd = WMI_AP_DEAUTH;
+	u16 reason = WLAN_REASON_PREV_AUTH_NOT_VALID;
+
+	if (params->subtype == IEEE80211_STYPE_DISASSOC >> 4)
+		cmd = WMI_AP_DISASSOC;
+	if (params->reason_code)
+		reason = params->reason_code;
+	return ath6kl_wmi_ap_set_mlme(ar->wmi, vif->fw_vif_idx, cmd, addr,
+				      reason);
 }
 
 static int ath6kl_change_station(struct wiphy *wiphy, struct net_device *dev,
-- 
1.9.1


-- 
Jouni Malinen                                            PGP id EFC895FA
