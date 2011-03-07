Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-yw0-f46.google.com ([209.85.213.46]:62495 "EHLO
	mail-yw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755137Ab1CGCOR (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 6 Mar 2011 21:14:17 -0500
Received: by ywj3 with SMTP id 3so1451423ywj.19
        for <linux-wireless@vger.kernel.org>; Sun, 06 Mar 2011 18:14:16 -0800 (PST)
From: Sujith <m.sujith@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Message-ID: <19828.16239.939605.712078@gargle.gargle.HOWL>
Date: Mon, 7 Mar 2011 07:44:07 +0530
To: linux-wireless@vger.kernel.org
CC: ath9k-devel@lists.ath9k.org
Subject: [RFC 14/34] ath9k_htc: Sync struct ath9k_htc_target_sta with FW
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Sujith Manoharan <Sujith.Manoharan@atheros.com>

Signed-off-by: Sujith Manoharan <Sujith.Manoharan@atheros.com>
---
 drivers/net/wireless/ath/ath9k/htc.h          |   29 ++----------------------
 drivers/net/wireless/ath/ath9k/htc_drv_main.c |    6 +---
 2 files changed, 5 insertions(+), 30 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/htc.h b/drivers/net/wireless/ath/ath9k/htc.h
index e346962..72aa04e 100644
--- a/drivers/net/wireless/ath/ath9k/htc.h
+++ b/drivers/net/wireless/ath/ath9k/htc.h
@@ -104,17 +104,6 @@ struct tx_beacon_header {
 	u16 rev;
 } __packed;
 
-struct ath9k_htc_target_hw {
-	u32 flags;
-	u32 flags_ext;
-	u32 ampdu_limit;
-	u8 ampdu_subframes;
-	u8 tx_chainmask;
-	u8 tx_chainmask_legacy;
-	u8 rtscts_ratecode;
-	u8 protmode;
-} __packed;
-
 struct ath9k_htc_cap_target {
 	u32 flags;
 	u32 flags_ext;
@@ -146,27 +135,15 @@ struct ath9k_htc_target_vif {
 #define ATH_HTC_STA_ERP   0x0004
 #define ATH_HTC_STA_HT    0x0008
 
-/* FIXME: UAPSD variables */
 struct ath9k_htc_target_sta {
-	u16 associd;
-	u16 txpower;
-	u32 ucastkey;
 	u8 macaddr[ETH_ALEN];
 	u8 bssid[ETH_ALEN];
 	u8 sta_index;
 	u8 vif_index;
-	u8 vif_sta;
-	__be16 flags; /* ATH_HTC_STA_* */
-	u16 htcap;
-	u8 valid;
-	u16 capinfo;
-	struct ath9k_htc_target_hw *hw;
-	struct ath9k_htc_target_vif *vif;
-	u16 txseqmgmt;
 	u8 is_vif_sta;
-	u16 maxampdu;
-	u16 iv16;
-	u32 iv32;
+	__be16 flags; /* ATH_HTC_STA_* */
+	__be16 htcap;
+	__be16 maxampdu;
 } __packed;
 
 struct ath9k_htc_target_aggr {
diff --git a/drivers/net/wireless/ath/ath9k/htc_drv_main.c b/drivers/net/wireless/ath/ath9k/htc_drv_main.c
index 59710e7..9bb20f3 100644
--- a/drivers/net/wireless/ath/ath9k/htc_drv_main.c
+++ b/drivers/net/wireless/ath/ath9k/htc_drv_main.c
@@ -382,7 +382,7 @@ static int ath9k_htc_add_monitor_interface(struct ath9k_htc_priv *priv)
 	tsta.is_vif_sta = 1;
 	tsta.sta_index = sta_idx;
 	tsta.vif_index = hvif.index;
-	tsta.maxampdu = 0xffff;
+	tsta.maxampdu = cpu_to_be16(0xffff);
 
 	WMI_CMD_BUF(WMI_NODE_CREATE_CMDID, &tsta);
 	if (ret) {
@@ -463,9 +463,7 @@ static int ath9k_htc_add_station(struct ath9k_htc_priv *priv,
 		ista = (struct ath9k_htc_sta *) sta->drv_priv;
 		memcpy(&tsta.macaddr, sta->addr, ETH_ALEN);
 		memcpy(&tsta.bssid, common->curbssid, ETH_ALEN);
-		tsta.associd = common->curaid;
 		tsta.is_vif_sta = 0;
-		tsta.valid = true;
 		ista->index = sta_idx;
 	} else {
 		memcpy(&tsta.macaddr, vif->addr, ETH_ALEN);
@@ -474,7 +472,7 @@ static int ath9k_htc_add_station(struct ath9k_htc_priv *priv,
 
 	tsta.sta_index = sta_idx;
 	tsta.vif_index = avp->index;
-	tsta.maxampdu = 0xffff;
+	tsta.maxampdu = cpu_to_be16(0xffff);
 	if (sta && sta->ht_cap.ht_supported)
 		tsta.flags = cpu_to_be16(ATH_HTC_STA_HT);
 
-- 
1.7.4.1

