Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine01.qualcomm.com ([199.106.114.254]:61194 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756070AbcHBLnx (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 2 Aug 2016 07:43:53 -0400
From: Maya Erez <qca_merez@qca.qualcomm.com>
To: Kalle Valo <kvalo@codeaurora.org>
Cc: Maya Erez <qca_merez@qca.qualcomm.com>,
	linux-wireless@vger.kernel.org, wil6210@qca.qualcomm.com
Subject: [PATCH 3/8] wil6210: support rx key setting for all TIDs
Date: Tue,  2 Aug 2016 14:42:07 +0300
Message-Id: <1470138132-18071-4-git-send-email-qca_merez@qca.qualcomm.com> (sfid-20160802_134405_148494_D4A9538A)
In-Reply-To: <1470138132-18071-1-git-send-email-qca_merez@qca.qualcomm.com>
References: <1470138132-18071-1-git-send-email-qca_merez@qca.qualcomm.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

According to the spec the PN should be calculated per TID.
In the current implementation, the PN and key_set were set
only for TID 0, therefore only traffic for TID 0 was supported.
In order to support all TIDs, the key_set and PN should be set
for all the TIDs.

Signed-off-by: Maya Erez <qca_merez@qca.qualcomm.com>
---
 drivers/net/wireless/ath/wil6210/cfg80211.c | 116 +++++++++++++++++++---------
 1 file changed, 81 insertions(+), 35 deletions(-)

diff --git a/drivers/net/wireless/ath/wil6210/cfg80211.c b/drivers/net/wireless/ath/wil6210/cfg80211.c
index f0e1175..110098e 100644
--- a/drivers/net/wireless/ath/wil6210/cfg80211.c
+++ b/drivers/net/wireless/ath/wil6210/cfg80211.c
@@ -760,14 +760,11 @@ static enum wmi_key_usage wil_detect_key_usage(struct wil6210_priv *wil,
 	return rc;
 }
 
-static struct wil_tid_crypto_rx_single *
-wil_find_crypto_ctx(struct wil6210_priv *wil, u8 key_index,
-		    enum wmi_key_usage key_usage, const u8 *mac_addr)
+static struct wil_sta_info *
+wil_find_sta_by_key_usage(struct wil6210_priv *wil,
+			  enum wmi_key_usage key_usage, const u8 *mac_addr)
 {
 	int cid = -EINVAL;
-	int tid = 0;
-	struct wil_sta_info *s;
-	struct wil_tid_crypto_rx *c;
 
 	if (key_usage == WMI_KEY_USE_TX_GROUP)
 		return NULL; /* not needed */
@@ -778,18 +775,72 @@ wil_find_crypto_ctx(struct wil6210_priv *wil, u8 key_index,
 	else if (key_usage == WMI_KEY_USE_RX_GROUP)
 		cid = wil_find_cid_by_idx(wil, 0);
 	if (cid < 0) {
-		wil_err(wil, "No CID for %pM %s[%d]\n", mac_addr,
-			key_usage_str[key_usage], key_index);
+		wil_err(wil, "No CID for %pM %s\n", mac_addr,
+			key_usage_str[key_usage]);
 		return ERR_PTR(cid);
 	}
 
-	s = &wil->sta[cid];
-	if (key_usage == WMI_KEY_USE_PAIRWISE)
-		c = &s->tid_crypto_rx[tid];
-	else
-		c = &s->group_crypto_rx;
+	return &wil->sta[cid];
+}
+
+static void wil_set_crypto_rx(u8 key_index, enum wmi_key_usage key_usage,
+			      struct wil_sta_info *cs,
+			      struct key_params *params)
+{
+	struct wil_tid_crypto_rx_single *cc;
+	int tid;
+
+	if (!cs)
+		return;
 
-	return &c->key_id[key_index];
+	switch (key_usage) {
+	case WMI_KEY_USE_PAIRWISE:
+		for (tid = 0; tid < WIL_STA_TID_NUM; tid++) {
+			cc = &cs->tid_crypto_rx[tid].key_id[key_index];
+			if (params->seq)
+				memcpy(cc->pn, params->seq,
+				       IEEE80211_GCMP_PN_LEN);
+			else
+				memset(cc->pn, 0, IEEE80211_GCMP_PN_LEN);
+			cc->key_set = true;
+		}
+		break;
+	case WMI_KEY_USE_RX_GROUP:
+		cc = &cs->group_crypto_rx.key_id[key_index];
+		if (params->seq)
+			memcpy(cc->pn, params->seq, IEEE80211_GCMP_PN_LEN);
+		else
+			memset(cc->pn, 0, IEEE80211_GCMP_PN_LEN);
+		cc->key_set = true;
+		break;
+	default:
+		break;
+	}
+}
+
+static void wil_del_rx_key(u8 key_index, enum wmi_key_usage key_usage,
+			   struct wil_sta_info *cs)
+{
+	struct wil_tid_crypto_rx_single *cc;
+	int tid;
+
+	if (!cs)
+		return;
+
+	switch (key_usage) {
+	case WMI_KEY_USE_PAIRWISE:
+		for (tid = 0; tid < WIL_STA_TID_NUM; tid++) {
+			cc = &cs->tid_crypto_rx[tid].key_id[key_index];
+			cc->key_set = false;
+		}
+		break;
+	case WMI_KEY_USE_RX_GROUP:
+		cc = &cs->group_crypto_rx.key_id[key_index];
+		cc->key_set = false;
+		break;
+	default:
+		break;
+	}
 }
 
 static int wil_cfg80211_add_key(struct wiphy *wiphy,
@@ -801,24 +852,26 @@ static int wil_cfg80211_add_key(struct wiphy *wiphy,
 	int rc;
 	struct wil6210_priv *wil = wiphy_to_wil(wiphy);
 	enum wmi_key_usage key_usage = wil_detect_key_usage(wil, pairwise);
-	struct wil_tid_crypto_rx_single *cc = wil_find_crypto_ctx(wil,
-								  key_index,
-								  key_usage,
-								  mac_addr);
+	struct wil_sta_info *cs = wil_find_sta_by_key_usage(wil, key_usage,
+							    mac_addr);
+
+	if (!params) {
+		wil_err(wil, "NULL params\n");
+		return -EINVAL;
+	}
 
 	wil_dbg_misc(wil, "%s(%pM %s[%d] PN %*phN)\n", __func__,
 		     mac_addr, key_usage_str[key_usage], key_index,
 		     params->seq_len, params->seq);
 
-	if (IS_ERR(cc)) {
+	if (IS_ERR(cs)) {
 		wil_err(wil, "Not connected, %s(%pM %s[%d] PN %*phN)\n",
 			__func__, mac_addr, key_usage_str[key_usage], key_index,
 			params->seq_len, params->seq);
 		return -EINVAL;
 	}
 
-	if (cc)
-		cc->key_set = false;
+	wil_del_rx_key(key_index, key_usage, cs);
 
 	if (params->seq && params->seq_len != IEEE80211_GCMP_PN_LEN) {
 		wil_err(wil,
@@ -831,13 +884,8 @@ static int wil_cfg80211_add_key(struct wiphy *wiphy,
 
 	rc = wmi_add_cipher_key(wil, key_index, mac_addr, params->key_len,
 				params->key, key_usage);
-	if ((rc == 0) && cc) {
-		if (params->seq)
-			memcpy(cc->pn, params->seq, IEEE80211_GCMP_PN_LEN);
-		else
-			memset(cc->pn, 0, IEEE80211_GCMP_PN_LEN);
-		cc->key_set = true;
-	}
+	if (!rc)
+		wil_set_crypto_rx(key_index, key_usage, cs, params);
 
 	return rc;
 }
@@ -849,20 +897,18 @@ static int wil_cfg80211_del_key(struct wiphy *wiphy,
 {
 	struct wil6210_priv *wil = wiphy_to_wil(wiphy);
 	enum wmi_key_usage key_usage = wil_detect_key_usage(wil, pairwise);
-	struct wil_tid_crypto_rx_single *cc = wil_find_crypto_ctx(wil,
-								  key_index,
-								  key_usage,
-								  mac_addr);
+	struct wil_sta_info *cs = wil_find_sta_by_key_usage(wil, key_usage,
+							    mac_addr);
 
 	wil_dbg_misc(wil, "%s(%pM %s[%d])\n", __func__, mac_addr,
 		     key_usage_str[key_usage], key_index);
 
-	if (IS_ERR(cc))
+	if (IS_ERR(cs))
 		wil_info(wil, "Not connected, %s(%pM %s[%d])\n", __func__,
 			 mac_addr, key_usage_str[key_usage], key_index);
 
-	if (!IS_ERR_OR_NULL(cc))
-		cc->key_set = false;
+	if (!IS_ERR_OR_NULL(cs))
+		wil_del_rx_key(key_index, key_usage, cs);
 
 	return wmi_del_cipher_key(wil, key_index, mac_addr, key_usage);
 }
-- 
1.9.1

