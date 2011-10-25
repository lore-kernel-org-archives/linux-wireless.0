Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine02.qualcomm.com ([199.106.114.251]:4659 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933607Ab1JYOIn (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 25 Oct 2011 10:08:43 -0400
From: Vasanthakumar Thiagarajan <vthiagar@qca.qualcomm.com>
To: <kvalo@qca.qualcomm.com>
CC: <linux-wireless@vger.kernel.org>
Subject: [PATCH V2 31/31] ath6kl: Use appropriate wdev from vif
Date: Tue, 25 Oct 2011 19:34:26 +0530
Message-ID: <1319551466-29070-32-git-send-email-vthiagar@qca.qualcomm.com> (sfid-20111025_160848_102888_B376593C)
In-Reply-To: <1319551466-29070-1-git-send-email-vthiagar@qca.qualcomm.com>
References: <1319551466-29070-1-git-send-email-vthiagar@qca.qualcomm.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Remove the wdev reference in struct ath6kl.

Signed-off-by: Vasanthakumar Thiagarajan <vthiagar@qca.qualcomm.com>
---
 drivers/net/wireless/ath/ath6kl/cfg80211.c |   17 +++++++----------
 drivers/net/wireless/ath/ath6kl/core.h     |    1 -
 2 files changed, 7 insertions(+), 11 deletions(-)

diff --git a/drivers/net/wireless/ath/ath6kl/cfg80211.c b/drivers/net/wireless/ath/ath6kl/cfg80211.c
index ae58d9a..007b638 100644
--- a/drivers/net/wireless/ath/ath6kl/cfg80211.c
+++ b/drivers/net/wireless/ath/ath6kl/cfg80211.c
@@ -622,7 +622,7 @@ void ath6kl_cfg80211_connect_event(struct ath6kl_vif *vif, u16 channel,
 	clear_bit(DTIM_PERIOD_AVAIL, &vif->flags);
 
 	if (nw_type & ADHOC_NETWORK) {
-		if (ar->wdev->iftype != NL80211_IFTYPE_ADHOC) {
+		if (vif->wdev.iftype != NL80211_IFTYPE_ADHOC) {
 			ath6kl_dbg(ATH6KL_DBG_WLAN_CFG,
 				   "%s: ath6k not in ibss mode\n", __func__);
 			return;
@@ -630,8 +630,8 @@ void ath6kl_cfg80211_connect_event(struct ath6kl_vif *vif, u16 channel,
 	}
 
 	if (nw_type & INFRA_NETWORK) {
-		if (ar->wdev->iftype != NL80211_IFTYPE_STATION &&
-		    ar->wdev->iftype != NL80211_IFTYPE_P2P_CLIENT) {
+		if (vif->wdev.iftype != NL80211_IFTYPE_STATION &&
+		    vif->wdev.iftype != NL80211_IFTYPE_P2P_CLIENT) {
 			ath6kl_dbg(ATH6KL_DBG_WLAN_CFG,
 				   "%s: ath6k not in station mode\n", __func__);
 			return;
@@ -717,7 +717,7 @@ void ath6kl_cfg80211_disconnect_event(struct ath6kl_vif *vif, u8 reason,
 	}
 
 	if (vif->nw_type & ADHOC_NETWORK) {
-		if (ar->wdev->iftype != NL80211_IFTYPE_ADHOC) {
+		if (vif->wdev.iftype != NL80211_IFTYPE_ADHOC) {
 			ath6kl_dbg(ATH6KL_DBG_WLAN_CFG,
 				   "%s: ath6k not in ibss mode\n", __func__);
 			return;
@@ -728,8 +728,8 @@ void ath6kl_cfg80211_disconnect_event(struct ath6kl_vif *vif, u8 reason,
 	}
 
 	if (vif->nw_type & INFRA_NETWORK) {
-		if (ar->wdev->iftype != NL80211_IFTYPE_STATION &&
-		    ar->wdev->iftype != NL80211_IFTYPE_P2P_CLIENT) {
+		if (vif->wdev.iftype != NL80211_IFTYPE_STATION &&
+		    vif->wdev.iftype != NL80211_IFTYPE_P2P_CLIENT) {
 			ath6kl_dbg(ATH6KL_DBG_WLAN_CFG,
 				   "%s: ath6k not in station mode\n", __func__);
 			return;
@@ -1320,8 +1320,6 @@ static int ath6kl_cfg80211_change_iface(struct wiphy *wiphy,
 					enum nl80211_iftype type, u32 *flags,
 					struct vif_params *params)
 {
-	struct ath6kl *ar = ath6kl_priv(ndev);
-	struct wireless_dev *wdev = ar->wdev;
 	struct ath6kl_vif *vif = netdev_priv(ndev);
 
 	ath6kl_dbg(ATH6KL_DBG_WLAN_CFG, "%s: type %u\n", __func__, type);
@@ -1350,7 +1348,7 @@ static int ath6kl_cfg80211_change_iface(struct wiphy *wiphy,
 		return -EOPNOTSUPP;
 	}
 
-	wdev->iftype = type;
+	vif->wdev.iftype = type;
 
 	return 0;
 }
@@ -2251,7 +2249,6 @@ struct net_device *ath6kl_interface_add(struct ath6kl *ar, char *name,
 	vif->wdev.iftype = type;
 	vif->fw_vif_idx = fw_vif_idx;
 	vif->nw_type = vif->next_mode = nw_type;
-	ar->wdev = &vif->wdev;
 
 	memcpy(ndev->dev_addr, ar->mac_addr, ETH_ALEN);
 	if (fw_vif_idx != 0)
diff --git a/drivers/net/wireless/ath/ath6kl/core.h b/drivers/net/wireless/ath/ath6kl/core.h
index 427db08..0d0f80a 100644
--- a/drivers/net/wireless/ath/ath6kl/core.h
+++ b/drivers/net/wireless/ath/ath6kl/core.h
@@ -498,7 +498,6 @@ struct ath6kl {
 	u8 ap_country_code[3];
 	struct list_head amsdu_rx_buffer_queue;
 	u8 rx_meta_ver;
-	struct wireless_dev *wdev;
 	enum wlan_low_pwr_state wlan_pwr_state;
 	struct wmi_scan_params_cmd sc_params;
 	u8 mac_addr[ETH_ALEN];
-- 
1.7.0.4

