Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga11.intel.com ([192.55.52.93]:55711 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753318Ab1HBPlg convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 2 Aug 2011 11:41:36 -0400
From: "Guy, Wey-Yi W" <wey-yi.w.guy@intel.com>
To: "linville@tuxdriver.com" <linville@tuxdriver.com>
CC: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"Berg, Johannes" <johannes.berg@intel.com>,
	"Guy, Wey-Yi W" <wey-yi.w.guy@intel.com>
Date: Tue, 2 Aug 2011 08:41:36 -0700
Subject: Please do not apply  [PATCH 04/11] iwlagn: handle GO powersave
Message-ID: <E9954878DD1FB34FAE5187FB88C58A35019955342D@orsmsx506.amr.corp.intel.com> (sfid-20110802_174140_152301_F0235BE4)
References: <1311441890-19959-1-git-send-email-wey-yi.w.guy@intel.com>
 <1311441890-19959-5-git-send-email-wey-yi.w.guy@intel.com>
In-Reply-To: <1311441890-19959-5-git-send-email-wey-yi.w.guy@intel.com>
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

John,

Please "DO NOT" apply this patch, it will cause IBSS mode not working 

Thanks
Wey


 
Subject: [PATCH 04/11] iwlagn: handle GO powersave

From: Johannes Berg <johannes.berg@intel.com>

In order to implement support for GO powersave on
the P2P client side, the ucode needs to know what
GO we're trying to authenticate/associate with,
it needs to have a station entry and the BSSID in
the RXON set.

Implement the new mac80211 callbacks to give this
data to the device.

Since this is also useful for the device when a
normal connection is established, also program it
with the information in that case.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Wey-Yi Guy <wey-yi.w.guy@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-agn-rxon.c |    7 ++-
 drivers/net/wireless/iwlwifi/iwl-agn.c      |   68 +++++++++++++++++++++++++++
 drivers/net/wireless/iwlwifi/iwl-dev.h      |    3 +
 3 files changed, 76 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-agn-rxon.c b/drivers/net/wireless/iwlwifi/iwl-agn-rxon.c
index d42ef17..1428bcf 100644
--- a/drivers/net/wireless/iwlwifi/iwl-agn-rxon.c
+++ b/drivers/net/wireless/iwlwifi/iwl-agn-rxon.c
@@ -434,6 +434,10 @@ int iwlagn_commit_rxon(struct iwl_priv *priv, struct iwl_rxon_context *ctx)
 	if (!ctx->is_active)
 		return 0;
 
+	/* override BSSID if necessary due to preauth */
+	if (ctx->preauth_bssid)
+		memcpy(ctx->staging.bssid_addr, ctx->bssid, ETH_ALEN);
+
 	/* always get timestamp with Rx frame */
 	ctx->staging.flags |= RXON_FLG_TSF2HOST_MSK;
 
@@ -883,8 +887,6 @@ void iwlagn_bss_info_changed(struct ieee80211_hw *hw,
 	else
 		ctx->staging.flags &= ~RXON_FLG_SELF_CTS_EN;
 
-	memcpy(ctx->staging.bssid_addr, bss_conf->bssid, ETH_ALEN);
-
 	if (vif->type == NL80211_IFTYPE_AP ||
 	    vif->type == NL80211_IFTYPE_ADHOC) {
 		if (vif->bss_conf.enable_beacon) {
@@ -912,6 +914,7 @@ void iwlagn_bss_info_changed(struct ieee80211_hw *hw,
 		if (!priv->disable_chain_noise_cal)
 			iwlagn_chain_noise_reset(priv);
 		priv->start_calib = 1;
+		WARN_ON(ctx->preauth_bssid);
 	}
 
 	if (changes & BSS_CHANGED_IBSS) {
diff --git a/drivers/net/wireless/iwlwifi/iwl-agn.c b/drivers/net/wireless/iwlwifi/iwl-agn.c
index 4b666b7..bb16726 100644
--- a/drivers/net/wireless/iwlwifi/iwl-agn.c
+++ b/drivers/net/wireless/iwlwifi/iwl-agn.c
@@ -3283,6 +3283,72 @@ static int iwl_mac_cancel_remain_on_channel(struct ieee80211_hw *hw)
 	return 0;
 }
 
+static int iwl_mac_tx_sync(struct ieee80211_hw *hw, struct ieee80211_vif *vif,
+			   const u8 *bssid, enum ieee80211_tx_sync_type type)
+{
+	struct iwl_priv *priv = hw->priv;
+	struct iwl_vif_priv *vif_priv = (void *)vif->drv_priv;
+	struct iwl_rxon_context *ctx = vif_priv->ctx;
+	int ret;
+	u8 sta_id;
+
+	mutex_lock(&priv->mutex);
+
+	if (iwl_is_associated_ctx(ctx)) {
+		ret = 0;
+		goto out;
+	}
+
+	if (ctx->preauth_bssid || test_bit(STATUS_SCAN_HW, &priv->status)) {
+		ret = -EBUSY;
+		goto out;
+	}
+
+	ret = iwl_add_station_common(priv, ctx, bssid, true, NULL, &sta_id);
+	if (ret)
+		goto out;
+
+	if (WARN_ON(sta_id != ctx->ap_sta_id)) {
+		ret = -EIO;
+		goto out_remove_sta;
+	}
+
+	memcpy(ctx->bssid, bssid, ETH_ALEN);
+	ctx->preauth_bssid = true;
+
+	ret = iwlagn_commit_rxon(priv, ctx);
+
+	if (ret == 0)
+		goto out;
+
+ out_remove_sta:
+	iwl_remove_station(priv, sta_id, bssid);
+ out:
+	mutex_unlock(&priv->mutex);
+	return ret;
+}
+
+static void iwl_mac_finish_tx_sync(struct ieee80211_hw *hw,
+				   struct ieee80211_vif *vif,
+				   const u8 *bssid,
+				   enum ieee80211_tx_sync_type type)
+{
+	struct iwl_priv *priv = hw->priv;
+	struct iwl_vif_priv *vif_priv = (void *)vif->drv_priv;
+	struct iwl_rxon_context *ctx = vif_priv->ctx;
+
+	mutex_lock(&priv->mutex);
+
+	if (iwl_is_associated_ctx(ctx))
+		goto out;
+
+	iwl_remove_station(priv, ctx->ap_sta_id, bssid);
+	ctx->preauth_bssid = false;
+	/* no need to commit */
+ out:
+	mutex_unlock(&priv->mutex);
+}
+
 /*****************************************************************************
  *
  * driver setup and teardown
@@ -3488,6 +3554,8 @@ struct ieee80211_ops iwlagn_hw_ops = {
 	.rssi_callback = iwl_mac_rssi_callback,
 	CFG80211_TESTMODE_CMD(iwl_testmode_cmd)
 	CFG80211_TESTMODE_DUMP(iwl_testmode_dump)
+	.tx_sync = iwl_mac_tx_sync,
+	.finish_tx_sync = iwl_mac_finish_tx_sync,
 };
 
 static u32 iwl_hw_detect(struct iwl_priv *priv)
diff --git a/drivers/net/wireless/iwlwifi/iwl-dev.h b/drivers/net/wireless/iwlwifi/iwl-dev.h
index 287f478..4349782 100644
--- a/drivers/net/wireless/iwlwifi/iwl-dev.h
+++ b/drivers/net/wireless/iwlwifi/iwl-dev.h
@@ -1125,6 +1125,9 @@ struct iwl_rxon_context {
 	const u8 *ac_to_queue;
 	u8 mcast_queue;
 
+	u8 bssid[ETH_ALEN];
+	bool preauth_bssid;
+
 	/*
 	 * We could use the vif to indicate active, but we
 	 * also need it to be active during disabling when
-- 
1.7.0.4

