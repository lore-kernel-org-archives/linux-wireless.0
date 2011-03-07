Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-yx0-f174.google.com ([209.85.213.174]:47324 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755159Ab1CGCOY (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 6 Mar 2011 21:14:24 -0500
Received: by yxs7 with SMTP id 7so1452952yxs.19
        for <linux-wireless@vger.kernel.org>; Sun, 06 Mar 2011 18:14:23 -0800 (PST)
From: Sujith <m.sujith@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Message-ID: <19828.16246.623659.384085@gargle.gargle.HOWL>
Date: Mon, 7 Mar 2011 07:44:14 +0530
To: linux-wireless@vger.kernel.org
CC: ath9k-devel@lists.ath9k.org
Subject: [RFC 15/34] ath9k_htc: Sync struct ath9k_htc_target_vif with FW
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Sujith Manoharan <Sujith.Manoharan@atheros.com>

Signed-off-by: Sujith Manoharan <Sujith.Manoharan@atheros.com>
---
 drivers/net/wireless/ath/ath9k/htc.h          |   11 ++---------
 drivers/net/wireless/ath/ath9k/htc_drv_main.c |    8 ++++----
 2 files changed, 6 insertions(+), 13 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/htc.h b/drivers/net/wireless/ath/ath9k/htc.h
index 72aa04e..b134d41 100644
--- a/drivers/net/wireless/ath/ath9k/htc.h
+++ b/drivers/net/wireless/ath/ath9k/htc.h
@@ -117,17 +117,10 @@ struct ath9k_htc_cap_target {
 
 struct ath9k_htc_target_vif {
 	u8 index;
-	u8 des_bssid[ETH_ALEN];
-	__be32 opmode;
+	u8 opmode;
 	u8 myaddr[ETH_ALEN];
-	u8 bssid[ETH_ALEN];
-	u32 flags;
-	u32 flags_ext;
-	u16 ps_sta;
-	__be16 rtsthreshold;
 	u8 ath_cap;
-	u8 node;
-	s8 mcast_rate;
+	__be16 rtsthreshold;
 } __packed;
 
 #define ATH_HTC_STA_AUTH  0x0001
diff --git a/drivers/net/wireless/ath/ath9k/htc_drv_main.c b/drivers/net/wireless/ath/ath9k/htc_drv_main.c
index 9bb20f3..4002267 100644
--- a/drivers/net/wireless/ath/ath9k/htc_drv_main.c
+++ b/drivers/net/wireless/ath/ath9k/htc_drv_main.c
@@ -349,7 +349,7 @@ static int ath9k_htc_add_monitor_interface(struct ath9k_htc_priv *priv)
 	memset(&hvif, 0, sizeof(struct ath9k_htc_target_vif));
 	memcpy(&hvif.myaddr, common->macaddr, ETH_ALEN);
 
-	hvif.opmode = cpu_to_be32(HTC_M_MONITOR);
+	hvif.opmode = HTC_M_MONITOR;
 	hvif.index = ffz(priv->vif_slot);
 
 	WMI_CMD_BUF(WMI_VAP_CREATE_CMDID, &hvif);
@@ -1039,13 +1039,13 @@ static int ath9k_htc_add_interface(struct ieee80211_hw *hw,
 
 	switch (vif->type) {
 	case NL80211_IFTYPE_STATION:
-		hvif.opmode = cpu_to_be32(HTC_M_STA);
+		hvif.opmode = HTC_M_STA;
 		break;
 	case NL80211_IFTYPE_ADHOC:
-		hvif.opmode = cpu_to_be32(HTC_M_IBSS);
+		hvif.opmode = HTC_M_IBSS;
 		break;
 	case NL80211_IFTYPE_AP:
-		hvif.opmode = cpu_to_be32(HTC_M_HOSTAP);
+		hvif.opmode = HTC_M_HOSTAP;
 		break;
 	default:
 		ath_err(common,
-- 
1.7.4.1

