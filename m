Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-we0-f177.google.com ([74.125.82.177]:64699 "EHLO
	mail-we0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752341AbaBLTFF (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 12 Feb 2014 14:05:05 -0500
Received: by mail-we0-f177.google.com with SMTP id t61so6455149wes.36
        for <linux-wireless@vger.kernel.org>; Wed, 12 Feb 2014 11:05:04 -0800 (PST)
From: Eugene Krasnikov <k.eugene.e@gmail.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	Pontus Fuchs <pontus.fuchs@gmail.com>
Subject: [PATCH 5/9] wcn36xx: Print FW capabilities
Date: Wed, 12 Feb 2014 19:04:44 +0000
Message-Id: <1392231888-2191-5-git-send-email-k.eugene.e@gmail.com> (sfid-20140212_200517_359499_F12343DE)
In-Reply-To: <1392231888-2191-1-git-send-email-k.eugene.e@gmail.com>
References: <1392231888-2191-1-git-send-email-k.eugene.e@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Pontus Fuchs <pontus.fuchs@gmail.com>

After fw caps exchange, print the FW's capabilities.

Signed-off-by: Pontus Fuchs <pontus.fuchs@gmail.com>
---
 drivers/net/wireless/ath/wcn36xx/main.c | 45 +++++++++++++++++++++++++++++++++
 drivers/net/wireless/ath/wcn36xx/smd.c  |  9 +++----
 drivers/net/wireless/ath/wcn36xx/smd.h  |  3 +++
 3 files changed, 51 insertions(+), 6 deletions(-)

diff --git a/drivers/net/wireless/ath/wcn36xx/main.c b/drivers/net/wireless/ath/wcn36xx/main.c
index a801aaa..95fd5c6 100644
--- a/drivers/net/wireless/ath/wcn36xx/main.c
+++ b/drivers/net/wireless/ath/wcn36xx/main.c
@@ -178,6 +178,49 @@ static inline u8 get_sta_index(struct ieee80211_vif *vif,
 	       sta_priv->sta_index;
 }
 
+static const char * const wcn36xx_caps_names[] = {
+	"MCC",				/* 0 */
+	"P2P",				/* 1 */
+	"DOT11AC",			/* 2 */
+	"SLM_SESSIONIZATION",		/* 3 */
+	"DOT11AC_OPMODE",		/* 4 */
+	"SAP32STA",			/* 5 */
+	"TDLS",				/* 6 */
+	"P2P_GO_NOA_DECOUPLE_INIT_SCAN",/* 7 */
+	"WLANACTIVE_OFFLOAD",		/* 8 */
+	"BEACON_OFFLOAD",		/* 9 */
+	"SCAN_OFFLOAD",			/* 10 */
+	"ROAM_OFFLOAD",			/* 11 */
+	"BCN_MISS_OFFLOAD",		/* 12 */
+	"STA_POWERSAVE",		/* 13 */
+	"STA_ADVANCED_PWRSAVE",		/* 14 */
+	"AP_UAPSD",			/* 15 */
+	"AP_DFS",			/* 16 */
+	"BLOCKACK",			/* 17 */
+	"PHY_ERR",			/* 18 */
+	"BCN_FILTER",			/* 19 */
+	"RTT",				/* 20 */
+	"RATECTRL",			/* 21 */
+	"WOW"				/* 22 */
+};
+
+static const char *wcn36xx_get_cap_name(enum place_holder_in_cap_bitmap x)
+{
+	if (x >= ARRAY_SIZE(wcn36xx_caps_names))
+		return "UNKNOWN";
+	return wcn36xx_caps_names[x];
+}
+
+static void wcn36xx_feat_caps_info(struct wcn36xx *wcn)
+{
+	int i;
+
+	for (i = 0; i < MAX_FEATURE_SUPPORTED; i++) {
+		if (get_feat_caps(wcn->fw_feat_caps, i))
+			wcn36xx_info("FW Cap %s\n", wcn36xx_get_cap_name(i));
+	}
+}
+
 static int wcn36xx_start(struct ieee80211_hw *hw)
 {
 	struct wcn36xx *wcn = hw->priv;
@@ -237,6 +280,8 @@ static int wcn36xx_start(struct ieee80211_hw *hw)
 		ret = wcn36xx_smd_feature_caps_exchange(wcn);
 		if (ret)
 			wcn36xx_warn("Exchange feature caps failed\n");
+		else
+			wcn36xx_feat_caps_info(wcn);
 	}
 	INIT_LIST_HEAD(&wcn->vif_list);
 	return 0;
diff --git a/drivers/net/wireless/ath/wcn36xx/smd.c b/drivers/net/wireless/ath/wcn36xx/smd.c
index d5e90c4..ae36409 100644
--- a/drivers/net/wireless/ath/wcn36xx/smd.c
+++ b/drivers/net/wireless/ath/wcn36xx/smd.c
@@ -1685,8 +1685,7 @@ out:
 	return ret;
 }
 
-static inline void set_feat_caps(u32 *bitmap,
-				 enum place_holder_in_cap_bitmap cap)
+void set_feat_caps(u32 *bitmap, enum place_holder_in_cap_bitmap cap)
 {
 	int arr_idx, bit_idx;
 
@@ -1700,8 +1699,7 @@ static inline void set_feat_caps(u32 *bitmap,
 	bitmap[arr_idx] |= (1 << bit_idx);
 }
 
-static inline int get_feat_caps(u32 *bitmap,
-				enum place_holder_in_cap_bitmap cap)
+int get_feat_caps(u32 *bitmap, enum place_holder_in_cap_bitmap cap)
 {
 	int arr_idx, bit_idx;
 	int ret = 0;
@@ -1717,8 +1715,7 @@ static inline int get_feat_caps(u32 *bitmap,
 	return ret;
 }
 
-static inline void clear_feat_caps(u32 *bitmap,
-				enum place_holder_in_cap_bitmap cap)
+void clear_feat_caps(u32 *bitmap, enum place_holder_in_cap_bitmap cap)
 {
 	int arr_idx, bit_idx;
 
diff --git a/drivers/net/wireless/ath/wcn36xx/smd.h b/drivers/net/wireless/ath/wcn36xx/smd.h
index c46246f..008d034 100644
--- a/drivers/net/wireless/ath/wcn36xx/smd.h
+++ b/drivers/net/wireless/ath/wcn36xx/smd.h
@@ -112,6 +112,9 @@ int wcn36xx_smd_keep_alive_req(struct wcn36xx *wcn,
 int wcn36xx_smd_dump_cmd_req(struct wcn36xx *wcn, u32 arg1, u32 arg2,
 			     u32 arg3, u32 arg4, u32 arg5);
 int wcn36xx_smd_feature_caps_exchange(struct wcn36xx *wcn);
+void set_feat_caps(u32 *bitmap, enum place_holder_in_cap_bitmap cap);
+int get_feat_caps(u32 *bitmap, enum place_holder_in_cap_bitmap cap);
+void clear_feat_caps(u32 *bitmap, enum place_holder_in_cap_bitmap cap);
 
 int wcn36xx_smd_add_ba_session(struct wcn36xx *wcn,
 		struct ieee80211_sta *sta,
-- 
1.8.3.2

