Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from emh04.mail.saunalahti.fi ([62.142.5.110]:49943 "EHLO
	emh04.mail.saunalahti.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757989Ab2B2RTR (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 29 Feb 2012 12:19:17 -0500
Subject: [PATCH 05/12] ath6kl: remove multiple assignments
To: kvalo@qca.qualcomm.com
From: Kalle Valo <kvalo@qca.qualcomm.com>
Cc: ath6kl-devel@qualcomm.com, linux-wireless@vger.kernel.org
Date: Wed, 29 Feb 2012 19:19:12 +0200
Message-ID: <20120229171912.24264.21383.stgit@localhost6.localdomain6> (sfid-20120229_181921_128007_BF25462B)
In-Reply-To: <20120229171525.24264.22062.stgit@localhost6.localdomain6>
References: <20120229171525.24264.22062.stgit@localhost6.localdomain6>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Found by checkpatch:

drivers/net/wireless/ath/ath6kl/cfg80211.c:1295: CHECK: multiple assignments should be avoided
drivers/net/wireless/ath/ath6kl/cfg80211.c:3000: CHECK: multiple assignments should be avoided

Signed-off-by: Kalle Valo <kvalo@qca.qualcomm.com>
---
 drivers/net/wireless/ath/ath6kl/cfg80211.c |    8 ++++----
 1 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/net/wireless/ath/ath6kl/cfg80211.c b/drivers/net/wireless/ath/ath6kl/cfg80211.c
index c69de7b..6aa4c71 100644
--- a/drivers/net/wireless/ath/ath6kl/cfg80211.c
+++ b/drivers/net/wireless/ath/ath6kl/cfg80211.c
@@ -1275,7 +1275,6 @@ static int ath6kl_cfg80211_set_txpower(struct wiphy *wiphy,
 {
 	struct ath6kl *ar = (struct ath6kl *)wiphy_priv(wiphy);
 	struct ath6kl_vif *vif;
-	u8 ath6kl_dbm;
 	int dbm = MBM_TO_DBM(mbm);
 
 	ath6kl_dbg(ATH6KL_DBG_WLAN_CFG, "%s: type 0x%x, dbm %d\n", __func__,
@@ -1292,7 +1291,7 @@ static int ath6kl_cfg80211_set_txpower(struct wiphy *wiphy,
 	case NL80211_TX_POWER_AUTOMATIC:
 		return 0;
 	case NL80211_TX_POWER_LIMITED:
-		ar->tx_pwr = ath6kl_dbm = dbm;
+		ar->tx_pwr = dbm;
 		break;
 	default:
 		ath6kl_dbg(ATH6KL_DBG_WLAN_CFG, "%s: type 0x%x not supported\n",
@@ -1300,7 +1299,7 @@ static int ath6kl_cfg80211_set_txpower(struct wiphy *wiphy,
 		return -EOPNOTSUPP;
 	}
 
-	ath6kl_wmi_set_tx_pwr_cmd(ar->wmi, vif->fw_vif_idx, ath6kl_dbm);
+	ath6kl_wmi_set_tx_pwr_cmd(ar->wmi, vif->fw_vif_idx, dbm);
 
 	return 0;
 }
@@ -2997,7 +2996,8 @@ struct net_device *ath6kl_interface_add(struct ath6kl *ar, char *name,
 	vif->wdev.netdev = ndev;
 	vif->wdev.iftype = type;
 	vif->fw_vif_idx = fw_vif_idx;
-	vif->nw_type = vif->next_mode = nw_type;
+	vif->nw_type = nw_type;
+	vif->next_mode = nw_type;
 
 	memcpy(ndev->dev_addr, ar->mac_addr, ETH_ALEN);
 	if (fw_vif_idx != 0)

