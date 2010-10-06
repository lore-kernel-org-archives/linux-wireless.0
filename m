Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from comal.ext.ti.com ([198.47.26.152]:43694 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759521Ab0JFSGc (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 6 Oct 2010 14:06:32 -0400
From: Shahar Levi <shahar_levi@ti.com>
To: <linux-wireless@vger.kernel.org>
Cc: Luciano Coelho <luciano.coelho@nokia.com>
Subject: [PATCH v2 02/03] wl1271: 11n Support, ACX Commands
Date: Wed,  6 Oct 2010 20:08:10 +0200
Message-Id: <1286388491-28752-4-git-send-email-shahar_levi@ti.com>
In-Reply-To: <1286388491-28752-1-git-send-email-shahar_levi@ti.com>
References: <1286388491-28752-1-git-send-email-shahar_levi@ti.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Added ACX command to the FW for 11n support.

Signed-off-by: Shahar Levi <shahar_levi@ti.com>
---
 drivers/net/wireless/wl12xx/wl1271_acx.c |   91 ++++++++++++++++++++++++++++++
 drivers/net/wireless/wl12xx/wl1271_acx.h |    5 ++
 2 files changed, 96 insertions(+), 0 deletions(-)

diff --git a/drivers/net/wireless/wl12xx/wl1271_acx.c b/drivers/net/wireless/wl12xx/wl1271_acx.c
index 6189934..cc6b7d8 100644
--- a/drivers/net/wireless/wl12xx/wl1271_acx.c
+++ b/drivers/net/wireless/wl12xx/wl1271_acx.c
@@ -1226,6 +1226,97 @@ out:
 	return ret;
 }
 
+int wl1271_acx_set_ht_capabilities(struct wl1271 *wl,
+				    struct ieee80211_sta_ht_cap *ht_cap,
+				    bool allow_ht_operation)
+{
+	struct wl1271_acx_ht_capabilities *acx;
+	/*
+	* Note, currently this value will be set to FFFFFFFFFFFF to indicate
+	* it is relevant for all peers since we only support HT in
+	* infrastructure mode. Later on this field will be relevant to
+	* IBSS/DLS operation */
+	u8 mac_address[ETH_ALEN] = {0xff, 0xff, 0xff, 0xff, 0xff, 0xff};
+	int ret = 0;
+
+	wl1271_debug(DEBUG_ACX, "acx ht capabilities setting");
+
+	acx = kzalloc(sizeof(*acx), GFP_KERNEL);
+	if (!acx) {
+		ret = -ENOMEM;
+		goto out;
+	}
+
+	/* Allow HT Operation ? */
+	if (true == allow_ht_operation) {
+		acx->ht_capabilites =
+		WL1271_ACX_FW_CAP_BIT_MASK_HT_OPERATION;
+		acx->ht_capabilites |=
+		((ht_cap->cap & IEEE80211_HT_CAP_GRN_FLD) ?
+		WL1271_ACX_FW_CAP_BIT_MASK_GREENFIELD_FRAME_FORMAT : 0);
+		acx->ht_capabilites |=
+		((ht_cap->cap & IEEE80211_HT_CAP_SGI_20) ?
+		WL1271_ACX_FW_CAP_BIT_MASK_SHORT_GI_FOR_20MHZ_PACKETS : 0);
+		acx->ht_capabilites |=
+		((ht_cap->cap & IEEE80211_HT_CAP_LSIG_TXOP_PROT) ?
+		WL1271_ACX_FW_CAP_BIT_MASK_LSIG_TXOP_PROTECTION : 0);
+
+		/* get date from A-MPDU parameters field */
+		acx->ampdu_max_length = ht_cap->ampdu_factor;
+		acx->ampdu_min_spacing = ht_cap->ampdu_density;
+
+		memcpy(acx->mac_address, mac_address, ETH_ALEN);
+	}
+	/* HT operations are not allowed */
+	else
+		acx->ht_capabilites = 0;
+
+	ret = wl1271_cmd_configure(wl, ACX_PEER_HT_CAP, acx, sizeof(*acx));
+	if (ret < 0) {
+		wl1271_warning("acx ht capabilities setting failed: %d", ret);
+		goto out;
+	}
+
+out:
+	kfree(acx);
+	return ret;
+}
+
+int wl1271_acx_set_ht_information(struct wl1271 *wl,
+				   u16 ht_operation_mode)
+{
+	struct wl1271_acx_ht_information *acx;
+	int ret = 0;
+
+	wl1271_debug(DEBUG_ACX, "acx ht information setting");
+
+	acx = kzalloc(sizeof(*acx), GFP_KERNEL);
+	if (!acx) {
+		ret = -ENOMEM;
+		goto out;
+	}
+
+	acx->ht_protection =
+		(u8)(ht_operation_mode & IEEE80211_HT_OP_MODE_PROTECTION);
+	acx->rifs_mode = 0;
+	acx->gf_protection = 0;
+	acx->ht_tx_burst_limit = 0;
+	acx->dual_cts_protection = 0;
+
+	ret = wl1271_cmd_configure(wl,
+				   ACX_HT_BSS_OPERATION,
+				   acx,
+				   sizeof(*acx));
+	if (ret < 0) {
+		wl1271_warning("acx ht information setting failed: %d", ret);
+		goto out;
+	}
+
+out:
+	kfree(acx);
+	return ret;
+}
+
 int wl1271_acx_tsf_info(struct wl1271 *wl, u64 *mactime)
 {
 	struct wl1271_acx_fw_tsf_information *tsf_info;
diff --git a/drivers/net/wireless/wl12xx/wl1271_acx.h b/drivers/net/wireless/wl12xx/wl1271_acx.h
index 5cf5a0d..abd4c70 100644
--- a/drivers/net/wireless/wl12xx/wl1271_acx.h
+++ b/drivers/net/wireless/wl12xx/wl1271_acx.h
@@ -1183,6 +1183,11 @@ int wl1271_acx_keep_alive_config(struct wl1271 *wl, u8 index, u8 tpl_valid);
 int wl1271_acx_rssi_snr_trigger(struct wl1271 *wl, bool enable,
 				s16 thold, u8 hyst);
 int wl1271_acx_rssi_snr_avg_weights(struct wl1271 *wl);
+int wl1271_acx_set_ht_capabilities(struct wl1271 *wl,
+				    struct ieee80211_sta_ht_cap *ht_cap,
+				    bool allow_ht_operation);
+int wl1271_acx_set_ht_information(struct wl1271 *wl,
+				   u16 ht_operation_mode);
 int wl1271_acx_tsf_info(struct wl1271 *wl, u64 *mactime);
 
 #endif /* __WL1271_ACX_H__ */
-- 
1.6.0.4

