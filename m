Received: from sipsolutions.net (s3.sipsolutions.net [168.119.38.16])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 37E854EBAC6
	for <linux-wireless@vger.kernel.org>; Wed, 14 Oct 2026 14:08:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=168.119.38.16
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791986888; cv=none; b=M0q1DnOs6p73HR8063ZhGjTClR9sJ8ruTLNavwgIFbr/K2xASflLQfZd2BXVVGUfA2RAT8xqBrtfItmjgySa+ypGKiaeocfc+zIs85NOm7Be0TBh8mxQCOSs3x1LsS30XAAq7IiREvWdBDYZX07nsRefDV4/vyeq4+aFYR1bnys=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791986888; c=relaxed/simple;
	bh=Qgq72kM0ELUoFmQu8NNqARrcrFJHKItiuQUrnbsyIS8=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=TXb6ESWPD/s/OqlAZKcRtPysSkdCv3c4HeFy/sD8WDoi752Y0xybVXYklBRE4jgP3qUS/0UKP5qIyoU2/NthO8dWx+FXX7Q6n1dMOTUk9GUaDhzJS19tcIaO9qdFFVKmdjJY6T8rMpIVS+WPv8d6ePpbbxf4pbRsNDIkULcUD+E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=permerror header.from=sipsolutions.net; spf=pass smtp.mailfrom=sipsolutions.net; dkim=pass (2048-bit key) header.d=sipsolutions.net header.i=@sipsolutions.net header.b=DweITvfO; arc=none smtp.client-ip=168.119.38.16
Authentication-Results: smtp.subspace.kernel.org; dmarc=permerror header.from=sipsolutions.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=sipsolutions.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=sipsolutions.net header.i=@sipsolutions.net header.b="DweITvfO"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=sipsolutions.net; s=mail; h=Content-Transfer-Encoding:MIME-Version:
	Message-ID:Date:Subject:Cc:To:From:Content-Type:Sender:Reply-To:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-To:Resent-Cc:
	Resent-Message-ID:In-Reply-To:References;
	bh=QbprVKZoIhxVI6J+3xDlU5Ey5lTv6iWnyiE6PVE9nl0=; t=1791986885; x=1793196485; 
	b=DweITvfOq/yVqtYy8xrV8cFVieWEvIk8o5d6YpUC3pG6qQLBaEt8YOrEIa8/q0JkQ7XMWUIHcLz
	zygM8CsCbJIiuBCaCxc2kleMdsQZzj+3AaGW2wQcGkNPC82enRvz4X01lU7OIPAEhEceVYoYhQBXA
	l7YVEEkU4t5c+gX3husMwPo8JukQqsLBUeS21JE3Nw/Y8nZVexbla0sZFFe28swvoROEQ8++MP6bd
	ryvyL6V+ZpJwa0qlU1p90M/aFklhOI70+/jTsLniKowMv2aqrGaFsu7S6JpaBL0hVll9E21x+3vil
	hJbR4ll6r2ZJOL2utry6tqQ80c/55HuDtxKw==;
Received: by sipsolutions.net with esmtpsa (TLS1.3:ECDHE_X25519__ECDSA_SECP256R1_SHA256__AES_256_GCM:256)
	(Exim 4.98.2)
	(envelope-from <johannes@sipsolutions.net>)
	id 1xGze7-00000001dBi-3rYX;
	Wed, 14 Oct 2026 16:07:56 +0200
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Cc: Johannes Berg <johannes.berg@intel.com>
Subject: [PATCH wireless-next] wifi: mac80211: remove .config method requirement
Date: Wed, 14 Oct 2026 16:07:51 +0200
Message-ID: <20261014140752.754329-2-johannes@sipsolutions.net>
X-Mailer: git-send-email 2.56.0
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Johannes Berg <johannes.berg@intel.com>

Given chanctx support, driver don't really need to
have a .config, so quite a few drivers now have an
empty one. Allow it to be not set and remove those
that are no longer needed.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 drivers/net/wireless/ath/ath12k/mac.c                 | 6 ------
 drivers/net/wireless/ath/ath12k/mac.h                 | 1 -
 drivers/net/wireless/ath/ath12k/wifi7/hw.c            | 1 -
 drivers/net/wireless/intel/iwlwifi/mld/mac80211.c     | 8 --------
 drivers/net/wireless/intel/iwlwifi/mvm/mac80211.c     | 1 -
 drivers/net/wireless/intel/iwlwifi/mvm/mld-mac80211.c | 1 -
 drivers/net/wireless/intel/iwlwifi/mvm/mvm.h          | 5 -----
 drivers/net/wireless/mediatek/mt76/mt7996/main.c      | 6 ------
 drivers/net/wireless/purelifi/plfxlc/mac.c            | 6 ------
 drivers/net/wireless/silabs/wfx/main.c                | 1 -
 drivers/net/wireless/silabs/wfx/sta.c                 | 5 -----
 drivers/net/wireless/silabs/wfx/sta.h                 | 1 -
 include/net/mac80211.h                                | 2 +-
 net/mac80211/driver-ops.h                             | 5 +++--
 net/mac80211/main.c                                   | 2 +-
 15 files changed, 5 insertions(+), 46 deletions(-)

diff --git a/drivers/net/wireless/ath/ath12k/mac.c b/drivers/net/wireless/ath/ath12k/mac.c
index 01f8c6572f65..c08216352c2c 100644
--- a/drivers/net/wireless/ath/ath12k/mac.c
+++ b/drivers/net/wireless/ath/ath12k/mac.c
@@ -1584,12 +1584,6 @@ int ath12k_mac_vdev_stop(struct ath12k_link_vif *arvif)
 	return ret;
 }
 
-int ath12k_mac_op_config(struct ieee80211_hw *hw, int radio_idx, u32 changed)
-{
-	return 0;
-}
-EXPORT_SYMBOL(ath12k_mac_op_config);
-
 static int ath12k_mac_setup_bcn_p2p_ie(struct ath12k_link_vif *arvif,
 				       struct sk_buff *bcn)
 {
diff --git a/drivers/net/wireless/ath/ath12k/mac.h b/drivers/net/wireless/ath/ath12k/mac.h
index ae44ebfd9bd9..61c2ec8865a3 100644
--- a/drivers/net/wireless/ath/ath12k/mac.h
+++ b/drivers/net/wireless/ath/ath12k/mac.h
@@ -218,7 +218,6 @@ void ath12k_mac_op_remove_interface(struct ieee80211_hw *hw,
 				    struct ieee80211_vif *vif);
 void ath12k_mac_op_update_vif_offload(struct ieee80211_hw *hw,
 				      struct ieee80211_vif *vif);
-int ath12k_mac_op_config(struct ieee80211_hw *hw, int radio_idx, u32 changed);
 void ath12k_mac_op_link_info_changed(struct ieee80211_hw *hw,
 				     struct ieee80211_vif *vif,
 				     struct ieee80211_bss_conf *info,
diff --git a/drivers/net/wireless/ath/ath12k/wifi7/hw.c b/drivers/net/wireless/ath/ath12k/wifi7/hw.c
index b1c17cc197df..d3ae9e987fa9 100644
--- a/drivers/net/wireless/ath/ath12k/wifi7/hw.c
+++ b/drivers/net/wireless/ath/ath12k/wifi7/hw.c
@@ -1183,7 +1183,6 @@ static const struct ieee80211_ops ath12k_ops_wifi7 = {
 	.add_interface                  = ath12k_mac_op_add_interface,
 	.remove_interface		= ath12k_mac_op_remove_interface,
 	.update_vif_offload		= ath12k_mac_op_update_vif_offload,
-	.config                         = ath12k_mac_op_config,
 	.link_info_changed              = ath12k_mac_op_link_info_changed,
 	.vif_cfg_changed		= ath12k_mac_op_vif_cfg_changed,
 	.change_vif_links               = ath12k_mac_op_change_vif_links,
diff --git a/drivers/net/wireless/intel/iwlwifi/mld/mac80211.c b/drivers/net/wireless/intel/iwlwifi/mld/mac80211.c
index e05bdbd3e1a9..99cbd279ce48 100644
--- a/drivers/net/wireless/intel/iwlwifi/mld/mac80211.c
+++ b/drivers/net/wireless/intel/iwlwifi/mld/mac80211.c
@@ -652,13 +652,6 @@ void iwl_mld_mac80211_stop(struct ieee80211_hw *hw, bool suspend)
 			mld->scan.uid_status[i] = 0;
 }
 
-static
-int iwl_mld_mac80211_config(struct ieee80211_hw *hw, int radio_idx,
-			    u32 changed)
-{
-	return 0;
-}
-
 static
 int iwl_mld_mac80211_add_interface(struct ieee80211_hw *hw,
 				   struct ieee80211_vif *vif)
@@ -2921,7 +2914,6 @@ const struct ieee80211_ops iwl_mld_hw_ops = {
 	.tx = iwl_mld_mac80211_tx,
 	.start = iwl_mld_mac80211_start,
 	.stop = iwl_mld_mac80211_stop,
-	.config = iwl_mld_mac80211_config,
 	.get_antenna = iwl_mld_get_antenna,
 	.set_antenna = iwl_mld_set_antenna,
 	.add_interface = iwl_mld_mac80211_add_interface,
diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/mac80211.c b/drivers/net/wireless/intel/iwlwifi/mvm/mac80211.c
index daa05339e3fb..937232882ea2 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/mac80211.c
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/mac80211.c
@@ -6359,7 +6359,6 @@ const struct ieee80211_ops iwl_mvm_hw_ops = {
 	.stop = iwl_mvm_mac_stop,
 	.add_interface = iwl_mvm_mac_add_interface,
 	.remove_interface = iwl_mvm_mac_remove_interface,
-	.config = iwl_mvm_mac_config,
 	.prepare_multicast = iwl_mvm_prepare_multicast,
 	.configure_filter = iwl_mvm_configure_filter,
 	.config_iface_filter = iwl_mvm_config_iface_filter,
diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/mld-mac80211.c b/drivers/net/wireless/intel/iwlwifi/mvm/mld-mac80211.c
index 6ea9a7c8da0c..5d1815528ac0 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/mld-mac80211.c
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/mld-mac80211.c
@@ -897,7 +897,6 @@ const struct ieee80211_ops iwl_mvm_mld_hw_ops = {
 	.stop = iwl_mvm_mac_stop,
 	.add_interface = iwl_mvm_mld_mac_add_interface,
 	.remove_interface = iwl_mvm_mld_mac_remove_interface,
-	.config = iwl_mvm_mac_config,
 	.prepare_multicast = iwl_mvm_prepare_multicast,
 	.configure_filter = iwl_mvm_configure_filter,
 	.config_iface_filter = iwl_mvm_mld_config_iface_filter,
diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/mvm.h b/drivers/net/wireless/intel/iwlwifi/mvm/mvm.h
index ae2ee8771f16..cfc0b0debfd8 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/mvm.h
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/mvm.h
@@ -2704,11 +2704,6 @@ int iwl_mvm_mac_start(struct ieee80211_hw *hw);
 void iwl_mvm_mac_reconfig_complete(struct ieee80211_hw *hw,
 				   enum ieee80211_reconfig_type reconfig_type);
 void iwl_mvm_mac_stop(struct ieee80211_hw *hw, bool suspend);
-static inline int iwl_mvm_mac_config(struct ieee80211_hw *hw, int radio_idx,
-				     u32 changed)
-{
-	return 0;
-}
 
 u64 iwl_mvm_prepare_multicast(struct ieee80211_hw *hw,
 			      struct netdev_hw_addr_list *mc_list);
diff --git a/drivers/net/wireless/mediatek/mt76/mt7996/main.c b/drivers/net/wireless/mediatek/mt76/mt7996/main.c
index 9321c8146e2a..873c5aef4935 100644
--- a/drivers/net/wireless/mediatek/mt76/mt7996/main.c
+++ b/drivers/net/wireless/mediatek/mt76/mt7996/main.c
@@ -752,11 +752,6 @@ static int mt7996_set_key(struct ieee80211_hw *hw, enum set_key_cmd cmd,
 	return err;
 }
 
-static int mt7996_config(struct ieee80211_hw *hw, int radio_idx, u32 changed)
-{
-	return 0;
-}
-
 static int
 mt7996_conf_tx(struct ieee80211_hw *hw, struct ieee80211_vif *vif,
 	       unsigned int link_id, u16 queue,
@@ -3052,7 +3047,6 @@ const struct ieee80211_ops mt7996_ops = {
 	.stop = mt7996_stop,
 	.add_interface = mt7996_add_interface,
 	.remove_interface = mt7996_remove_interface,
-	.config = mt7996_config,
 	.conf_tx = mt7996_conf_tx,
 	.configure_filter = mt7996_configure_filter,
 	.vif_cfg_changed = mt7996_vif_cfg_changed,
diff --git a/drivers/net/wireless/purelifi/plfxlc/mac.c b/drivers/net/wireless/purelifi/plfxlc/mac.c
index a900421753ac..ad04730c8c0b 100644
--- a/drivers/net/wireless/purelifi/plfxlc/mac.c
+++ b/drivers/net/wireless/purelifi/plfxlc/mac.c
@@ -526,11 +526,6 @@ static void plfxlc_op_remove_interface(struct ieee80211_hw *hw,
 	mac->vif = NULL;
 }
 
-static int plfxlc_op_config(struct ieee80211_hw *hw, int radio_idx, u32 changed)
-{
-	return 0;
-}
-
 #define SUPPORTED_FIF_FLAGS \
 	(FIF_ALLMULTI | FIF_FCSFAIL | FIF_CONTROL | \
 	 FIF_OTHER_BSS | FIF_BCN_PRBRESP_PROMISC)
@@ -690,7 +685,6 @@ static const struct ieee80211_ops plfxlc_ops = {
 	.add_interface = plfxlc_op_add_interface,
 	.remove_interface = plfxlc_op_remove_interface,
 	.set_rts_threshold = plfxlc_set_rts_threshold,
-	.config = plfxlc_op_config,
 	.configure_filter = plfxlc_op_configure_filter,
 	.bss_info_changed = plfxlc_op_bss_info_changed,
 	.get_stats = plfxlc_get_stats,
diff --git a/drivers/net/wireless/silabs/wfx/main.c b/drivers/net/wireless/silabs/wfx/main.c
index 16d5b51f6f03..9c40d738e5a1 100644
--- a/drivers/net/wireless/silabs/wfx/main.c
+++ b/drivers/net/wireless/silabs/wfx/main.c
@@ -132,7 +132,6 @@ static const struct ieee80211_ops wfx_ops = {
 	.stop                    = wfx_stop,
 	.add_interface           = wfx_add_interface,
 	.remove_interface        = wfx_remove_interface,
-	.config                  = wfx_config,
 	.tx                      = wfx_tx,
 	.wake_tx_queue           = ieee80211_handle_wake_tx_queue,
 	.join_ibss               = wfx_join_ibss,
diff --git a/drivers/net/wireless/silabs/wfx/sta.c b/drivers/net/wireless/silabs/wfx/sta.c
index d12fcc755701..210d2c07db87 100644
--- a/drivers/net/wireless/silabs/wfx/sta.c
+++ b/drivers/net/wireless/silabs/wfx/sta.c
@@ -706,11 +706,6 @@ void wfx_unassign_vif_chanctx(struct ieee80211_hw *hw, struct ieee80211_vif *vif
 	wvif->channel = NULL;
 }
 
-int wfx_config(struct ieee80211_hw *hw, int radio_idx, u32 changed)
-{
-	return 0;
-}
-
 int wfx_add_interface(struct ieee80211_hw *hw, struct ieee80211_vif *vif)
 {
 	int i;
diff --git a/drivers/net/wireless/silabs/wfx/sta.h b/drivers/net/wireless/silabs/wfx/sta.h
index b4812b294f3c..1d301b0f8d33 100644
--- a/drivers/net/wireless/silabs/wfx/sta.h
+++ b/drivers/net/wireless/silabs/wfx/sta.h
@@ -21,7 +21,6 @@ struct wfx_sta_priv {
 /* mac80211 interface */
 int wfx_start(struct ieee80211_hw *hw);
 void wfx_stop(struct ieee80211_hw *hw, bool suspend);
-int wfx_config(struct ieee80211_hw *hw, int radio_idx, u32 changed);
 int wfx_set_rts_threshold(struct ieee80211_hw *hw, int radio_idx, u32 value);
 void wfx_set_default_unicast_key(struct ieee80211_hw *hw, struct ieee80211_vif *vif, int idx);
 void wfx_configure_filter(struct ieee80211_hw *hw, unsigned int changed_flags,
diff --git a/include/net/mac80211.h b/include/net/mac80211.h
index a1a6409b44c1..a9ad89e77858 100644
--- a/include/net/mac80211.h
+++ b/include/net/mac80211.h
@@ -4162,7 +4162,7 @@ struct ieee80211_prep_tx_info {
  * @config: Handler for configuration requests. IEEE 802.11 code calls this
  *	function to change hardware configuration, e.g., channel.
  *	This function should never fail but returns a negative error code
- *	if it does. The callback can sleep.
+ *	if it does. The callback is optional and can sleep.
  *
  * @bss_info_changed: Handler for configuration requests related to BSS
  *	parameters that may vary during BSS's lifespan, and may affect low
diff --git a/net/mac80211/driver-ops.h b/net/mac80211/driver-ops.h
index 83dd15f2daf6..c401d27bb502 100644
--- a/net/mac80211/driver-ops.h
+++ b/net/mac80211/driver-ops.h
@@ -147,13 +147,14 @@ void drv_remove_interface(struct ieee80211_local *local,
 static inline int drv_config(struct ieee80211_local *local, int radio_idx,
 			     u32 changed)
 {
-	int ret;
+	int ret = 0;
 
 	might_sleep();
 	lockdep_assert_wiphy(local->hw.wiphy);
 
 	trace_drv_config(local, radio_idx, changed);
-	ret = local->ops->config(&local->hw, radio_idx, changed);
+	if (local->ops->config)
+		ret = local->ops->config(&local->hw, radio_idx, changed);
 	trace_drv_return_int(local, ret);
 	return ret;
 }
diff --git a/net/mac80211/main.c b/net/mac80211/main.c
index 76e85754deff..7d27e707f8fd 100644
--- a/net/mac80211/main.c
+++ b/net/mac80211/main.c
@@ -804,7 +804,7 @@ struct ieee80211_hw *ieee80211_alloc_hw_nm(size_t priv_data_len,
 	struct wiphy *wiphy;
 	bool emulate_chanctx;
 
-	if (WARN_ON(!ops->tx || !ops->start || !ops->stop || !ops->config ||
+	if (WARN_ON(!ops->tx || !ops->start || !ops->stop ||
 		    !ops->add_interface || !ops->remove_interface ||
 		    !ops->configure_filter || !ops->wake_tx_queue))
 		return NULL;
-- 
2.56.0

