Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine02.qualcomm.com ([199.106.114.251]:48633 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752763Ab1H2MaJ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 29 Aug 2011 08:30:09 -0400
From: Jouni Malinen <jouni@qca.qualcomm.com>
To: <kvalo@qca.qualcomm.com>
CC: <linux-wireless@vger.kernel.org>,
	Jouni Malinen <jouni@qca.qualcomm.com>
Subject: [PATCH 16/20] ath6kl: Add support for new P2P iftypes in mode changes
Date: Mon, 29 Aug 2011 15:23:57 +0300
Message-ID: <1314620641-24257-17-git-send-email-jouni@qca.qualcomm.com> (sfid-20110829_143014_175044_D6B3D934)
In-Reply-To: <1314620641-24257-1-git-send-email-jouni@qca.qualcomm.com>
References: <1314620641-24257-1-git-send-email-jouni@qca.qualcomm.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Signed-off-by: Jouni Malinen <jouni@qca.qualcomm.com>
---
 drivers/net/wireless/ath/ath6kl/cfg80211.c |   12 ++++++++++--
 1 files changed, 10 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/ath/ath6kl/cfg80211.c b/drivers/net/wireless/ath/ath6kl/cfg80211.c
index 2c35fd2..19b6da8 100644
--- a/drivers/net/wireless/ath/ath6kl/cfg80211.c
+++ b/drivers/net/wireless/ath/ath6kl/cfg80211.c
@@ -451,7 +451,8 @@ void ath6kl_cfg80211_connect_event(struct ath6kl *ar, u16 channel,
 	}
 
 	if (nw_type & INFRA_NETWORK) {
-		if (ar->wdev->iftype != NL80211_IFTYPE_STATION) {
+		if (ar->wdev->iftype != NL80211_IFTYPE_STATION &&
+		    ar->wdev->iftype != NL80211_IFTYPE_P2P_CLIENT) {
 			ath6kl_dbg(ATH6KL_DBG_WLAN_CFG,
 				   "%s: ath6k not in station mode\n", __func__);
 			return;
@@ -612,7 +613,8 @@ void ath6kl_cfg80211_disconnect_event(struct ath6kl *ar, u8 reason,
 	}
 
 	if (ar->nw_type & INFRA_NETWORK) {
-		if (ar->wdev->iftype != NL80211_IFTYPE_STATION) {
+		if (ar->wdev->iftype != NL80211_IFTYPE_STATION &&
+		    ar->wdev->iftype != NL80211_IFTYPE_P2P_CLIENT) {
 			ath6kl_dbg(ATH6KL_DBG_WLAN_CFG,
 				   "%s: ath6k not in station mode\n", __func__);
 			return;
@@ -1206,6 +1208,12 @@ static int ath6kl_cfg80211_change_iface(struct wiphy *wiphy,
 	case NL80211_IFTYPE_ADHOC:
 		ar->next_mode = ADHOC_NETWORK;
 		break;
+	case NL80211_IFTYPE_P2P_CLIENT:
+		ar->next_mode = INFRA_NETWORK;
+		break;
+	case NL80211_IFTYPE_P2P_GO:
+		ar->next_mode = AP_NETWORK;
+		break;
 	default:
 		ath6kl_err("invalid interface type %u\n", type);
 		return -EOPNOTSUPP;
-- 
1.7.4.1

