Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-iw0-f174.google.com ([209.85.214.174]:35840 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753068Ab1DMFwN (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 13 Apr 2011 01:52:13 -0400
Received: by mail-iw0-f174.google.com with SMTP id 34so276432iwn.19
        for <linux-wireless@vger.kernel.org>; Tue, 12 Apr 2011 22:52:13 -0700 (PDT)
From: Sujith <m.sujith@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Message-ID: <19877.15005.540581.325499@gargle.gargle.HOWL>
Date: Wed, 13 Apr 2011 11:24:37 +0530
To: linville@tuxdriver.com
CC: linux-wireless@vger.kernel.org, ath9k-devel@lists.ath9k.org
Subject: [PATCH 16/40] ath9k_htc: Sync struct ath9k_htc_target_sta with FW
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Sujith Manoharan <Sujith.Manoharan@atheros.com>

Signed-off-by: Sujith Manoharan <Sujith.Manoharan@atheros.com>
---
 drivers/net/wireless/ath/ath9k/htc.h          |   30 +++---------------------
 drivers/net/wireless/ath/ath9k/htc_drv_main.c |    6 +---
 2 files changed, 6 insertions(+), 30 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/htc.h b/drivers/net/wireless/ath/ath9k/htc.h
index 2eabfe4..e096624 100644
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
@@ -146,27 +135,16 @@ struct ath9k_htc_target_vif {
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
+	u8 pad;
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
1.7.4.4

