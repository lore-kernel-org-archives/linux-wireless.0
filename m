Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mout.gmx.net ([212.227.15.19]:56020 "EHLO mout.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753296AbaCAUQw (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sat, 1 Mar 2014 15:16:52 -0500
From: Oleksij Rempel <linux@rempel-privat.de>
To: linux-wireless@vger.kernel.org, sujith@msujith.org,
	linville@tuxdriver.com
Cc: Oleksij Rempel <linux@rempel-privat.de>
Subject: [PATCH 07/23] ath9k_htc: add ATH_OP_PRIM_STA_VIF
Date: Sat,  1 Mar 2014 21:15:50 +0100
Message-Id: <1393704966-13985-8-git-send-email-linux@rempel-privat.de> (sfid-20140301_211655_140147_5484F08C)
In-Reply-To: <1393704966-13985-1-git-send-email-linux@rempel-privat.de>
References: <1393704966-13985-1-git-send-email-linux@rempel-privat.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

we will need it to make common-beacon code work.

Signed-off-by: Oleksij Rempel <linux@rempel-privat.de>
---
 drivers/net/wireless/ath/ath9k/htc_drv_main.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/drivers/net/wireless/ath/ath9k/htc_drv_main.c b/drivers/net/wireless/ath/ath9k/htc_drv_main.c
index 6e17c08..b82a7c4 100644
--- a/drivers/net/wireless/ath/ath9k/htc_drv_main.c
+++ b/drivers/net/wireless/ath/ath9k/htc_drv_main.c
@@ -1478,6 +1478,7 @@ static void ath9k_htc_bss_iter(void *data, u8 *mac, struct ieee80211_vif *vif)
 		common->curaid = bss_conf->aid;
 		common->last_rssi = ATH_RSSI_DUMMY_MARKER;
 		memcpy(common->curbssid, bss_conf->bssid, ETH_ALEN);
+		set_bit(ATH_OP_PRIM_STA_VIF, &common->op_flags);
 	}
 }
 
@@ -1510,6 +1511,9 @@ static void ath9k_htc_bss_info_changed(struct ieee80211_hw *hw,
 		bss_conf->assoc ?
 			priv->num_sta_assoc_vif++ : priv->num_sta_assoc_vif--;
 
+		if (!bss_conf->assoc)
+			clear_bit(ATH_OP_PRIM_STA_VIF, &common->op_flags);
+
 		if (priv->ah->opmode == NL80211_IFTYPE_STATION) {
 			ath9k_htc_choose_set_bssid(priv);
 			if (bss_conf->assoc && (priv->num_sta_assoc_vif == 1))
-- 
1.9.0

