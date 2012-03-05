Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga09.intel.com ([134.134.136.24]:22398 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965103Ab2CEUiF (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 5 Mar 2012 15:38:05 -0500
From: Wey-Yi Guy <wey-yi.w.guy@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	Johannes Berg <johannes.berg@intel.com>,
	Wey-Yi Guy <wey-yi.w.guy@intel.com>
Subject: [PATCH RESEND 07/33] iwlwifi: make sta lock private & BH lock
Date: Mon,  5 Mar 2012 11:24:25 -0800
Message-Id: <1330975491-19680-8-git-send-email-wey-yi.w.guy@intel.com> (sfid-20120305_213907_202664_B8C60E98)
In-Reply-To: <1330975491-19680-1-git-send-email-wey-yi.w.guy@intel.com>
References: <1330975491-19680-1-git-send-email-wey-yi.w.guy@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

Now that the transport has its own locking,
there's no need to have the sta_lock in the
shared data. Also, it can be a BH lock as
it's not used from IRQ handlers.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Wey-Yi Guy <wey-yi.w.guy@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-agn-sta.c |  141 ++++++++++++----------------
 drivers/net/wireless/iwlwifi/iwl-agn-tx.c  |   46 ++++-----
 drivers/net/wireless/iwlwifi/iwl-agn.c     |    7 +-
 drivers/net/wireless/iwlwifi/iwl-dev.h     |    6 +
 drivers/net/wireless/iwlwifi/iwl-shared.h  |    3 -
 5 files changed, 88 insertions(+), 115 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-agn-sta.c b/drivers/net/wireless/iwlwifi/iwl-agn-sta.c
index 6b9af99..4bd50da 100644
--- a/drivers/net/wireless/iwlwifi/iwl-agn-sta.c
+++ b/drivers/net/wireless/iwlwifi/iwl-agn-sta.c
@@ -34,9 +34,10 @@
 #include "iwl-agn.h"
 #include "iwl-trans.h"
 
-/* priv->shrd->sta_lock must be held */
 static int iwl_sta_ucode_activate(struct iwl_priv *priv, u8 sta_id)
 {
+	lockdep_assert_held(&priv->sta_lock);
+
 	if (sta_id >= IWLAGN_STATION_COUNT) {
 		IWL_ERR(priv, "invalid sta_id %u", sta_id);
 		return -EINVAL;
@@ -64,7 +65,6 @@ static int iwl_process_add_sta_resp(struct iwl_priv *priv,
 				    struct iwl_rx_packet *pkt)
 {
 	u8 sta_id = addsta->sta.sta_id;
-	unsigned long flags;
 	int ret = -EIO;
 
 	if (pkt->hdr.flags & IWL_CMD_FAILED_MSK) {
@@ -76,7 +76,7 @@ static int iwl_process_add_sta_resp(struct iwl_priv *priv,
 	IWL_DEBUG_INFO(priv, "Processing response for adding station %u\n",
 		       sta_id);
 
-	spin_lock_irqsave(&priv->shrd->sta_lock, flags);
+	spin_lock(&priv->sta_lock);
 
 	switch (pkt->u.add_sta.status) {
 	case ADD_STA_SUCCESS_MSK:
@@ -118,7 +118,7 @@ static int iwl_process_add_sta_resp(struct iwl_priv *priv,
 		       priv->stations[sta_id].sta.mode ==
 		       STA_CONTROL_MODIFY_MSK ? "Modified" : "Added",
 		       addsta->sta.addr);
-	spin_unlock_irqrestore(&priv->shrd->sta_lock, flags);
+	spin_unlock(&priv->sta_lock);
 
 	return ret;
 }
@@ -317,18 +317,17 @@ int iwl_add_station_common(struct iwl_priv *priv, struct iwl_rxon_context *ctx,
 			   const u8 *addr, bool is_ap,
 			   struct ieee80211_sta *sta, u8 *sta_id_r)
 {
-	unsigned long flags_spin;
 	int ret = 0;
 	u8 sta_id;
 	struct iwl_addsta_cmd sta_cmd;
 
 	*sta_id_r = 0;
-	spin_lock_irqsave(&priv->shrd->sta_lock, flags_spin);
+	spin_lock_bh(&priv->sta_lock);
 	sta_id = iwl_prep_station(priv, ctx, addr, is_ap, sta);
 	if (sta_id == IWL_INVALID_STATION) {
 		IWL_ERR(priv, "Unable to prepare station %pM for addition\n",
 			addr);
-		spin_unlock_irqrestore(&priv->shrd->sta_lock, flags_spin);
+		spin_unlock_bh(&priv->sta_lock);
 		return -EINVAL;
 	}
 
@@ -340,7 +339,7 @@ int iwl_add_station_common(struct iwl_priv *priv, struct iwl_rxon_context *ctx,
 	if (priv->stations[sta_id].used & IWL_STA_UCODE_INPROGRESS) {
 		IWL_DEBUG_INFO(priv, "STA %d already in process of being "
 			       "added.\n", sta_id);
-		spin_unlock_irqrestore(&priv->shrd->sta_lock, flags_spin);
+		spin_unlock_bh(&priv->sta_lock);
 		return -EEXIST;
 	}
 
@@ -348,24 +347,24 @@ int iwl_add_station_common(struct iwl_priv *priv, struct iwl_rxon_context *ctx,
 	    (priv->stations[sta_id].used & IWL_STA_UCODE_ACTIVE)) {
 		IWL_DEBUG_ASSOC(priv, "STA %d (%pM) already added, not "
 				"adding again.\n", sta_id, addr);
-		spin_unlock_irqrestore(&priv->shrd->sta_lock, flags_spin);
+		spin_unlock_bh(&priv->sta_lock);
 		return -EEXIST;
 	}
 
 	priv->stations[sta_id].used |= IWL_STA_UCODE_INPROGRESS;
 	memcpy(&sta_cmd, &priv->stations[sta_id].sta,
 	       sizeof(struct iwl_addsta_cmd));
-	spin_unlock_irqrestore(&priv->shrd->sta_lock, flags_spin);
+	spin_unlock_bh(&priv->sta_lock);
 
 	/* Add station to device's station table */
 	ret = iwl_send_add_sta(priv, &sta_cmd, CMD_SYNC);
 	if (ret) {
-		spin_lock_irqsave(&priv->shrd->sta_lock, flags_spin);
+		spin_lock_bh(&priv->sta_lock);
 		IWL_ERR(priv, "Adding station %pM failed.\n",
 			priv->stations[sta_id].sta.sta.addr);
 		priv->stations[sta_id].used &= ~IWL_STA_DRIVER_ACTIVE;
 		priv->stations[sta_id].used &= ~IWL_STA_UCODE_INPROGRESS;
-		spin_unlock_irqrestore(&priv->shrd->sta_lock, flags_spin);
+		spin_unlock_bh(&priv->sta_lock);
 	}
 	*sta_id_r = sta_id;
 	return ret;
@@ -373,11 +372,11 @@ int iwl_add_station_common(struct iwl_priv *priv, struct iwl_rxon_context *ctx,
 
 /**
  * iwl_sta_ucode_deactivate - deactivate ucode status for a station
- *
- * priv->shrd->sta_lock must be held
  */
 static void iwl_sta_ucode_deactivate(struct iwl_priv *priv, u8 sta_id)
 {
+	lockdep_assert_held(&priv->sta_lock);
+
 	/* Ucode must be active and driver must be non active */
 	if ((priv->stations[sta_id].used &
 	     (IWL_STA_UCODE_ACTIVE | IWL_STA_DRIVER_ACTIVE)) !=
@@ -396,8 +395,6 @@ static int iwl_send_remove_station(struct iwl_priv *priv,
 {
 	struct iwl_rx_packet *pkt;
 	int ret;
-
-	unsigned long flags_spin;
 	struct iwl_rem_sta_cmd rm_sta_cmd;
 
 	struct iwl_host_cmd cmd = {
@@ -429,11 +426,9 @@ static int iwl_send_remove_station(struct iwl_priv *priv,
 		switch (pkt->u.rem_sta.status) {
 		case REM_STA_SUCCESS_MSK:
 			if (!temporary) {
-				spin_lock_irqsave(&priv->shrd->sta_lock,
-					flags_spin);
+				spin_lock_bh(&priv->sta_lock);
 				iwl_sta_ucode_deactivate(priv, sta_id);
-				spin_unlock_irqrestore(&priv->shrd->sta_lock,
-					flags_spin);
+				spin_unlock_bh(&priv->sta_lock);
 			}
 			IWL_DEBUG_ASSOC(priv, "REPLY_REMOVE_STA PASSED\n");
 			break;
@@ -454,7 +449,6 @@ static int iwl_send_remove_station(struct iwl_priv *priv,
 int iwl_remove_station(struct iwl_priv *priv, const u8 sta_id,
 		       const u8 *addr)
 {
-	unsigned long flags;
 	u8 tid;
 
 	if (!iwl_is_ready(priv->shrd)) {
@@ -475,7 +469,7 @@ int iwl_remove_station(struct iwl_priv *priv, const u8 sta_id,
 	if (WARN_ON(sta_id == IWL_INVALID_STATION))
 		return -EINVAL;
 
-	spin_lock_irqsave(&priv->shrd->sta_lock, flags);
+	spin_lock_bh(&priv->sta_lock);
 
 	if (!(priv->stations[sta_id].used & IWL_STA_DRIVER_ACTIVE)) {
 		IWL_DEBUG_INFO(priv, "Removing %pM but non DRIVER active\n",
@@ -505,11 +499,11 @@ int iwl_remove_station(struct iwl_priv *priv, const u8 sta_id,
 	if (WARN_ON(priv->num_stations < 0))
 		priv->num_stations = 0;
 
-	spin_unlock_irqrestore(&priv->shrd->sta_lock, flags);
+	spin_unlock_bh(&priv->sta_lock);
 
 	return iwl_send_remove_station(priv, addr, sta_id, false);
 out_err:
-	spin_unlock_irqrestore(&priv->shrd->sta_lock, flags);
+	spin_unlock_bh(&priv->sta_lock);
 	return -EINVAL;
 }
 
@@ -525,12 +519,11 @@ void iwl_clear_ucode_stations(struct iwl_priv *priv,
 			      struct iwl_rxon_context *ctx)
 {
 	int i;
-	unsigned long flags_spin;
 	bool cleared = false;
 
 	IWL_DEBUG_INFO(priv, "Clearing ucode stations in driver\n");
 
-	spin_lock_irqsave(&priv->shrd->sta_lock, flags_spin);
+	spin_lock_bh(&priv->sta_lock);
 	for (i = 0; i < IWLAGN_STATION_COUNT; i++) {
 		if (ctx && ctx->ctxid != priv->stations[i].ctxid)
 			continue;
@@ -542,7 +535,7 @@ void iwl_clear_ucode_stations(struct iwl_priv *priv,
 			cleared = true;
 		}
 	}
-	spin_unlock_irqrestore(&priv->shrd->sta_lock, flags_spin);
+	spin_unlock_bh(&priv->sta_lock);
 
 	if (!cleared)
 		IWL_DEBUG_INFO(priv,
@@ -561,7 +554,6 @@ void iwl_restore_stations(struct iwl_priv *priv, struct iwl_rxon_context *ctx)
 {
 	struct iwl_addsta_cmd sta_cmd;
 	struct iwl_link_quality_cmd lq;
-	unsigned long flags_spin;
 	int i;
 	bool found = false;
 	int ret;
@@ -574,7 +566,7 @@ void iwl_restore_stations(struct iwl_priv *priv, struct iwl_rxon_context *ctx)
 	}
 
 	IWL_DEBUG_ASSOC(priv, "Restoring all known stations ... start.\n");
-	spin_lock_irqsave(&priv->shrd->sta_lock, flags_spin);
+	spin_lock_bh(&priv->sta_lock);
 	for (i = 0; i < IWLAGN_STATION_COUNT; i++) {
 		if (ctx->ctxid != priv->stations[i].ctxid)
 			continue;
@@ -601,20 +593,17 @@ void iwl_restore_stations(struct iwl_priv *priv, struct iwl_rxon_context *ctx)
 					       sizeof(struct iwl_link_quality_cmd));
 				send_lq = true;
 			}
-			spin_unlock_irqrestore(&priv->shrd->sta_lock,
-					       flags_spin);
+			spin_unlock_bh(&priv->sta_lock);
 			ret = iwl_send_add_sta(priv, &sta_cmd, CMD_SYNC);
 			if (ret) {
-				spin_lock_irqsave(&priv->shrd->sta_lock,
-						  flags_spin);
+				spin_lock_bh(&priv->sta_lock);
 				IWL_ERR(priv, "Adding station %pM failed.\n",
 					priv->stations[i].sta.sta.addr);
 				priv->stations[i].used &=
 						~IWL_STA_DRIVER_ACTIVE;
 				priv->stations[i].used &=
 						~IWL_STA_UCODE_INPROGRESS;
-				spin_unlock_irqrestore(&priv->shrd->sta_lock,
-						       flags_spin);
+				spin_unlock_bh(&priv->sta_lock);
 			}
 			/*
 			 * Rate scaling has already been initialized, send
@@ -623,12 +612,12 @@ void iwl_restore_stations(struct iwl_priv *priv, struct iwl_rxon_context *ctx)
 			if (send_lq)
 				iwl_send_lq_cmd(priv, ctx, &lq,
 						CMD_SYNC, true);
-			spin_lock_irqsave(&priv->shrd->sta_lock, flags_spin);
+			spin_lock_bh(&priv->sta_lock);
 			priv->stations[i].used &= ~IWL_STA_UCODE_INPROGRESS;
 		}
 	}
 
-	spin_unlock_irqrestore(&priv->shrd->sta_lock, flags_spin);
+	spin_unlock_bh(&priv->sta_lock);
 	if (!found)
 		IWL_DEBUG_INFO(priv, "Restoring all known stations .... "
 			"no stations to be restored.\n");
@@ -639,16 +628,15 @@ void iwl_restore_stations(struct iwl_priv *priv, struct iwl_rxon_context *ctx)
 
 void iwl_reprogram_ap_sta(struct iwl_priv *priv, struct iwl_rxon_context *ctx)
 {
-	unsigned long flags;
 	int sta_id = ctx->ap_sta_id;
 	int ret;
 	struct iwl_addsta_cmd sta_cmd;
 	struct iwl_link_quality_cmd lq;
 	bool active, have_lq = false;
 
-	spin_lock_irqsave(&priv->shrd->sta_lock, flags);
+	spin_lock_bh(&priv->sta_lock);
 	if (!(priv->stations[sta_id].used & IWL_STA_DRIVER_ACTIVE)) {
-		spin_unlock_irqrestore(&priv->shrd->sta_lock, flags);
+		spin_unlock_bh(&priv->sta_lock);
 		return;
 	}
 
@@ -661,7 +649,7 @@ void iwl_reprogram_ap_sta(struct iwl_priv *priv, struct iwl_rxon_context *ctx)
 
 	active = priv->stations[sta_id].used & IWL_STA_UCODE_ACTIVE;
 	priv->stations[sta_id].used &= ~IWL_STA_DRIVER_ACTIVE;
-	spin_unlock_irqrestore(&priv->shrd->sta_lock, flags);
+	spin_unlock_bh(&priv->sta_lock);
 
 	if (active) {
 		ret = iwl_send_remove_station(
@@ -671,9 +659,9 @@ void iwl_reprogram_ap_sta(struct iwl_priv *priv, struct iwl_rxon_context *ctx)
 			IWL_ERR(priv, "failed to remove STA %pM (%d)\n",
 				priv->stations[sta_id].sta.sta.addr, ret);
 	}
-	spin_lock_irqsave(&priv->shrd->sta_lock, flags);
+	spin_lock_bh(&priv->sta_lock);
 	priv->stations[sta_id].used |= IWL_STA_DRIVER_ACTIVE;
-	spin_unlock_irqrestore(&priv->shrd->sta_lock, flags);
+	spin_unlock_bh(&priv->sta_lock);
 
 	ret = iwl_send_add_sta(priv, &sta_cmd, CMD_SYNC);
 	if (ret)
@@ -696,10 +684,9 @@ int iwl_get_free_ucode_key_offset(struct iwl_priv *priv)
 
 void iwl_dealloc_bcast_stations(struct iwl_priv *priv)
 {
-	unsigned long flags;
 	int i;
 
-	spin_lock_irqsave(&priv->shrd->sta_lock, flags);
+	spin_lock_bh(&priv->sta_lock);
 	for (i = 0; i < IWLAGN_STATION_COUNT; i++) {
 		if (!(priv->stations[i].used & IWL_STA_BCAST))
 			continue;
@@ -711,7 +698,7 @@ void iwl_dealloc_bcast_stations(struct iwl_priv *priv)
 		kfree(priv->stations[i].lq);
 		priv->stations[i].lq = NULL;
 	}
-	spin_unlock_irqrestore(&priv->shrd->sta_lock, flags);
+	spin_unlock_bh(&priv->sta_lock);
 }
 
 #ifdef CONFIG_IWLWIFI_DEBUG
@@ -783,8 +770,6 @@ int iwl_send_lq_cmd(struct iwl_priv *priv, struct iwl_rxon_context *ctx,
 		    struct iwl_link_quality_cmd *lq, u8 flags, bool init)
 {
 	int ret = 0;
-	unsigned long flags_spin;
-
 	struct iwl_host_cmd cmd = {
 		.id = REPLY_TX_LINK_QUALITY_CMD,
 		.len = { sizeof(struct iwl_link_quality_cmd), },
@@ -796,12 +781,12 @@ int iwl_send_lq_cmd(struct iwl_priv *priv, struct iwl_rxon_context *ctx,
 		return -EINVAL;
 
 
-	spin_lock_irqsave(&priv->shrd->sta_lock, flags_spin);
+	spin_lock_bh(&priv->sta_lock);
 	if (!(priv->stations[lq->sta_id].used & IWL_STA_DRIVER_ACTIVE)) {
-		spin_unlock_irqrestore(&priv->shrd->sta_lock, flags_spin);
+		spin_unlock_bh(&priv->sta_lock);
 		return -EINVAL;
 	}
-	spin_unlock_irqrestore(&priv->shrd->sta_lock, flags_spin);
+	spin_unlock_bh(&priv->sta_lock);
 
 	iwl_dump_lq_cmd(priv, lq);
 	if (WARN_ON(init && (cmd.flags & CMD_ASYNC)))
@@ -819,9 +804,9 @@ int iwl_send_lq_cmd(struct iwl_priv *priv, struct iwl_rxon_context *ctx,
 		IWL_DEBUG_INFO(priv, "init LQ command complete, "
 			       "clearing sta addition status for sta %d\n",
 			       lq->sta_id);
-		spin_lock_irqsave(&priv->shrd->sta_lock, flags_spin);
+		spin_lock_bh(&priv->sta_lock);
 		priv->stations[lq->sta_id].used &= ~IWL_STA_UCODE_INPROGRESS;
-		spin_unlock_irqrestore(&priv->shrd->sta_lock, flags_spin);
+		spin_unlock_bh(&priv->sta_lock);
 	}
 	return ret;
 }
@@ -906,7 +891,6 @@ int iwlagn_add_bssid_station(struct iwl_priv *priv,
 	int ret;
 	u8 sta_id;
 	struct iwl_link_quality_cmd *link_cmd;
-	unsigned long flags;
 
 	if (sta_id_r)
 		*sta_id_r = IWL_INVALID_STATION;
@@ -920,9 +904,9 @@ int iwlagn_add_bssid_station(struct iwl_priv *priv,
 	if (sta_id_r)
 		*sta_id_r = sta_id;
 
-	spin_lock_irqsave(&priv->shrd->sta_lock, flags);
+	spin_lock_bh(&priv->sta_lock);
 	priv->stations[sta_id].used |= IWL_STA_LOCAL;
-	spin_unlock_irqrestore(&priv->shrd->sta_lock, flags);
+	spin_unlock_bh(&priv->sta_lock);
 
 	/* Set up default rate scaling table in device's station table */
 	link_cmd = iwl_sta_alloc_lq(priv, ctx, sta_id);
@@ -937,9 +921,9 @@ int iwlagn_add_bssid_station(struct iwl_priv *priv,
 	if (ret)
 		IWL_ERR(priv, "Link quality command failed (%d)\n", ret);
 
-	spin_lock_irqsave(&priv->shrd->sta_lock, flags);
+	spin_lock_bh(&priv->sta_lock);
 	priv->stations[sta_id].lq = link_cmd;
-	spin_unlock_irqrestore(&priv->shrd->sta_lock, flags);
+	spin_unlock_bh(&priv->sta_lock);
 
 	return 0;
 }
@@ -1100,14 +1084,13 @@ static int iwlagn_send_sta_key(struct iwl_priv *priv,
 			       u8 sta_id, u32 tkip_iv32, u16 *tkip_p1k,
 			       u32 cmd_flags)
 {
-	unsigned long flags;
 	__le16 key_flags;
 	struct iwl_addsta_cmd sta_cmd;
 	int i;
 
-	spin_lock_irqsave(&priv->shrd->sta_lock, flags);
+	spin_lock_bh(&priv->sta_lock);
 	memcpy(&sta_cmd, &priv->stations[sta_id].sta, sizeof(sta_cmd));
-	spin_unlock_irqrestore(&priv->shrd->sta_lock, flags);
+	spin_unlock_bh(&priv->sta_lock);
 
 	key_flags = cpu_to_le16(keyconf->keyidx << STA_KEY_FLG_KEYID_POS);
 	key_flags |= STA_KEY_FLG_MAP_KEY_MSK;
@@ -1174,7 +1157,6 @@ int iwl_remove_dynamic_key(struct iwl_priv *priv,
 			   struct ieee80211_key_conf *keyconf,
 			   struct ieee80211_sta *sta)
 {
-	unsigned long flags;
 	struct iwl_addsta_cmd sta_cmd;
 	u8 sta_id = iwlagn_key_sta_id(priv, ctx->vif, sta);
 	__le16 key_flags;
@@ -1183,11 +1165,11 @@ int iwl_remove_dynamic_key(struct iwl_priv *priv,
 	if (sta_id == IWL_INVALID_STATION)
 		return -ENOENT;
 
-	spin_lock_irqsave(&priv->shrd->sta_lock, flags);
+	spin_lock_bh(&priv->sta_lock);
 	memcpy(&sta_cmd, &priv->stations[sta_id].sta, sizeof(sta_cmd));
 	if (!(priv->stations[sta_id].used & IWL_STA_UCODE_ACTIVE))
 		sta_id = IWL_INVALID_STATION;
-	spin_unlock_irqrestore(&priv->shrd->sta_lock, flags);
+	spin_unlock_bh(&priv->sta_lock);
 
 	if (sta_id == IWL_INVALID_STATION)
 		return 0;
@@ -1287,21 +1269,20 @@ int iwlagn_alloc_bcast_station(struct iwl_priv *priv,
 			       struct iwl_rxon_context *ctx)
 {
 	struct iwl_link_quality_cmd *link_cmd;
-	unsigned long flags;
 	u8 sta_id;
 
-	spin_lock_irqsave(&priv->shrd->sta_lock, flags);
+	spin_lock_bh(&priv->sta_lock);
 	sta_id = iwl_prep_station(priv, ctx, iwl_bcast_addr, false, NULL);
 	if (sta_id == IWL_INVALID_STATION) {
 		IWL_ERR(priv, "Unable to prepare broadcast station\n");
-		spin_unlock_irqrestore(&priv->shrd->sta_lock, flags);
+		spin_unlock_bh(&priv->sta_lock);
 
 		return -EINVAL;
 	}
 
 	priv->stations[sta_id].used |= IWL_STA_DRIVER_ACTIVE;
 	priv->stations[sta_id].used |= IWL_STA_BCAST;
-	spin_unlock_irqrestore(&priv->shrd->sta_lock, flags);
+	spin_unlock_bh(&priv->sta_lock);
 
 	link_cmd = iwl_sta_alloc_lq(priv, ctx, sta_id);
 	if (!link_cmd) {
@@ -1310,9 +1291,9 @@ int iwlagn_alloc_bcast_station(struct iwl_priv *priv,
 		return -ENOMEM;
 	}
 
-	spin_lock_irqsave(&priv->shrd->sta_lock, flags);
+	spin_lock_bh(&priv->sta_lock);
 	priv->stations[sta_id].lq = link_cmd;
-	spin_unlock_irqrestore(&priv->shrd->sta_lock, flags);
+	spin_unlock_bh(&priv->sta_lock);
 
 	return 0;
 }
@@ -1326,7 +1307,6 @@ int iwlagn_alloc_bcast_station(struct iwl_priv *priv,
 int iwl_update_bcast_station(struct iwl_priv *priv,
 			     struct iwl_rxon_context *ctx)
 {
-	unsigned long flags;
 	struct iwl_link_quality_cmd *link_cmd;
 	u8 sta_id = ctx->bcast_sta_id;
 
@@ -1336,13 +1316,13 @@ int iwl_update_bcast_station(struct iwl_priv *priv,
 		return -ENOMEM;
 	}
 
-	spin_lock_irqsave(&priv->shrd->sta_lock, flags);
+	spin_lock_bh(&priv->sta_lock);
 	if (priv->stations[sta_id].lq)
 		kfree(priv->stations[sta_id].lq);
 	else
 		IWL_DEBUG_INFO(priv, "Bcast station rate scaling has not been initialized yet.\n");
 	priv->stations[sta_id].lq = link_cmd;
-	spin_unlock_irqrestore(&priv->shrd->sta_lock, flags);
+	spin_unlock_bh(&priv->sta_lock);
 
 	return 0;
 }
@@ -1366,18 +1346,17 @@ int iwl_update_bcast_stations(struct iwl_priv *priv)
  */
 int iwl_sta_tx_modify_enable_tid(struct iwl_priv *priv, int sta_id, int tid)
 {
-	unsigned long flags;
 	struct iwl_addsta_cmd sta_cmd;
 
 	lockdep_assert_held(&priv->shrd->mutex);
 
 	/* Remove "disable" flag, to enable Tx for this TID */
-	spin_lock_irqsave(&priv->shrd->sta_lock, flags);
+	spin_lock_bh(&priv->sta_lock);
 	priv->stations[sta_id].sta.sta.modify_mask = STA_MODIFY_TID_DISABLE_TX;
 	priv->stations[sta_id].sta.tid_disable_tx &= cpu_to_le16(~(1 << tid));
 	priv->stations[sta_id].sta.mode = STA_CONTROL_MODIFY_MSK;
 	memcpy(&sta_cmd, &priv->stations[sta_id].sta, sizeof(struct iwl_addsta_cmd));
-	spin_unlock_irqrestore(&priv->shrd->sta_lock, flags);
+	spin_unlock_bh(&priv->sta_lock);
 
 	return iwl_send_add_sta(priv, &sta_cmd, CMD_SYNC);
 }
@@ -1385,7 +1364,6 @@ int iwl_sta_tx_modify_enable_tid(struct iwl_priv *priv, int sta_id, int tid)
 int iwl_sta_rx_agg_start(struct iwl_priv *priv, struct ieee80211_sta *sta,
 			 int tid, u16 ssn)
 {
-	unsigned long flags;
 	int sta_id;
 	struct iwl_addsta_cmd sta_cmd;
 
@@ -1395,14 +1373,14 @@ int iwl_sta_rx_agg_start(struct iwl_priv *priv, struct ieee80211_sta *sta,
 	if (sta_id == IWL_INVALID_STATION)
 		return -ENXIO;
 
-	spin_lock_irqsave(&priv->shrd->sta_lock, flags);
+	spin_lock_bh(&priv->sta_lock);
 	priv->stations[sta_id].sta.station_flags_msk = 0;
 	priv->stations[sta_id].sta.sta.modify_mask = STA_MODIFY_ADDBA_TID_MSK;
 	priv->stations[sta_id].sta.add_immediate_ba_tid = (u8)tid;
 	priv->stations[sta_id].sta.add_immediate_ba_ssn = cpu_to_le16(ssn);
 	priv->stations[sta_id].sta.mode = STA_CONTROL_MODIFY_MSK;
 	memcpy(&sta_cmd, &priv->stations[sta_id].sta, sizeof(struct iwl_addsta_cmd));
-	spin_unlock_irqrestore(&priv->shrd->sta_lock, flags);
+	spin_unlock_bh(&priv->sta_lock);
 
 	return iwl_send_add_sta(priv, &sta_cmd, CMD_SYNC);
 }
@@ -1410,7 +1388,6 @@ int iwl_sta_rx_agg_start(struct iwl_priv *priv, struct ieee80211_sta *sta,
 int iwl_sta_rx_agg_stop(struct iwl_priv *priv, struct ieee80211_sta *sta,
 			int tid)
 {
-	unsigned long flags;
 	int sta_id;
 	struct iwl_addsta_cmd sta_cmd;
 
@@ -1422,13 +1399,13 @@ int iwl_sta_rx_agg_stop(struct iwl_priv *priv, struct ieee80211_sta *sta,
 		return -ENXIO;
 	}
 
-	spin_lock_irqsave(&priv->shrd->sta_lock, flags);
+	spin_lock_bh(&priv->sta_lock);
 	priv->stations[sta_id].sta.station_flags_msk = 0;
 	priv->stations[sta_id].sta.sta.modify_mask = STA_MODIFY_DELBA_TID_MSK;
 	priv->stations[sta_id].sta.remove_immediate_ba_tid = (u8)tid;
 	priv->stations[sta_id].sta.mode = STA_CONTROL_MODIFY_MSK;
 	memcpy(&sta_cmd, &priv->stations[sta_id].sta, sizeof(struct iwl_addsta_cmd));
-	spin_unlock_irqrestore(&priv->shrd->sta_lock, flags);
+	spin_unlock_bh(&priv->sta_lock);
 
 	return iwl_send_add_sta(priv, &sta_cmd, CMD_SYNC);
 }
diff --git a/drivers/net/wireless/iwlwifi/iwl-agn-tx.c b/drivers/net/wireless/iwlwifi/iwl-agn-tx.c
index 59509d8..4e69189 100644
--- a/drivers/net/wireless/iwlwifi/iwl-agn-tx.c
+++ b/drivers/net/wireless/iwlwifi/iwl-agn-tx.c
@@ -370,7 +370,7 @@ int iwlagn_tx_skb(struct iwl_priv *priv, struct sk_buff *skb)
 	info->driver_data[1] = dev_cmd;
 
 	/* irqs already disabled/saved above when locking priv->shrd->lock */
-	spin_lock(&priv->shrd->sta_lock);
+	spin_lock(&priv->sta_lock);
 
 	if (ieee80211_is_data_qos(fc) && !ieee80211_is_qos_nullfunc(fc)) {
 		u8 *qc = NULL;
@@ -417,7 +417,7 @@ int iwlagn_tx_skb(struct iwl_priv *priv, struct sk_buff *skb)
 	    !ieee80211_has_morefrags(fc))
 		priv->tid_data[sta_id][tid].seq_number = seq_number;
 
-	spin_unlock(&priv->shrd->sta_lock);
+	spin_unlock(&priv->sta_lock);
 	spin_unlock_irqrestore(&priv->shrd->lock, flags);
 
 	/*
@@ -435,7 +435,7 @@ int iwlagn_tx_skb(struct iwl_priv *priv, struct sk_buff *skb)
 drop_unlock_sta:
 	if (dev_cmd)
 		kmem_cache_free(priv->tx_cmd_pool, dev_cmd);
-	spin_unlock(&priv->shrd->sta_lock);
+	spin_unlock(&priv->sta_lock);
 drop_unlock_priv:
 	spin_unlock_irqrestore(&priv->shrd->lock, flags);
 	return -1;
@@ -455,7 +455,7 @@ int iwlagn_tx_agg_stop(struct iwl_priv *priv, struct ieee80211_vif *vif,
 		return -ENXIO;
 	}
 
-	spin_lock_irqsave(&priv->shrd->sta_lock, flags);
+	spin_lock_bh(&priv->sta_lock);
 
 	tid_data = &priv->tid_data[sta_id][tid];
 
@@ -475,7 +475,7 @@ int iwlagn_tx_agg_stop(struct iwl_priv *priv, struct ieee80211_vif *vif,
 		IWL_WARN(priv, "Stopping AGG while state not ON "
 			 "or starting for %d on %d (%d)\n", sta_id, tid,
 			 priv->tid_data[sta_id][tid].agg.state);
-		spin_unlock_irqrestore(&priv->shrd->sta_lock, flags);
+		spin_unlock_bh(&priv->sta_lock);
 		return 0;
 	}
 
@@ -489,7 +489,7 @@ int iwlagn_tx_agg_stop(struct iwl_priv *priv, struct ieee80211_vif *vif,
 				    tid_data->next_reclaimed);
 		priv->tid_data[sta_id][tid].agg.state =
 			IWL_EMPTYING_HW_QUEUE_DELBA;
-		spin_unlock_irqrestore(&priv->shrd->sta_lock, flags);
+		spin_unlock_bh(&priv->sta_lock);
 		return 0;
 	}
 
@@ -498,12 +498,10 @@ int iwlagn_tx_agg_stop(struct iwl_priv *priv, struct ieee80211_vif *vif,
 turn_off:
 	priv->tid_data[sta_id][tid].agg.state = IWL_AGG_OFF;
 
-	/* do not restore/save irqs */
-	spin_unlock(&priv->shrd->sta_lock);
-	spin_lock(&priv->shrd->lock);
+	spin_unlock_bh(&priv->sta_lock);
 
+	spin_lock_irqsave(&priv->shrd->lock, flags);
 	iwl_trans_tx_agg_disable(trans(priv), sta_id, tid);
-
 	spin_unlock_irqrestore(&priv->shrd->lock, flags);
 
 	ieee80211_stop_tx_ba_cb_irqsafe(vif, sta->addr, tid);
@@ -515,7 +513,6 @@ int iwlagn_tx_agg_start(struct iwl_priv *priv, struct ieee80211_vif *vif,
 			struct ieee80211_sta *sta, u16 tid, u16 *ssn)
 {
 	struct iwl_tid_data *tid_data;
-	unsigned long flags;
 	int sta_id;
 	int ret;
 
@@ -539,7 +536,7 @@ int iwlagn_tx_agg_start(struct iwl_priv *priv, struct ieee80211_vif *vif,
 	if (ret)
 		return ret;
 
-	spin_lock_irqsave(&priv->shrd->sta_lock, flags);
+	spin_lock_bh(&priv->sta_lock);
 
 	tid_data = &priv->tid_data[sta_id][tid];
 	tid_data->agg.ssn = SEQ_TO_SN(tid_data->seq_number);
@@ -548,7 +545,7 @@ int iwlagn_tx_agg_start(struct iwl_priv *priv, struct ieee80211_vif *vif,
 
 	ret = iwl_trans_tx_agg_alloc(trans(priv), sta_id, tid);
 	if (ret) {
-		spin_unlock_irqrestore(&priv->shrd->sta_lock, flags);
+		spin_unlock_bh(&priv->sta_lock);
 		return ret;
 	}
 
@@ -565,7 +562,7 @@ int iwlagn_tx_agg_start(struct iwl_priv *priv, struct ieee80211_vif *vif,
 		tid_data->agg.state = IWL_EMPTYING_HW_QUEUE_ADDBA;
 	}
 
-	spin_unlock_irqrestore(&priv->shrd->sta_lock, flags);
+	spin_unlock_bh(&priv->sta_lock);
 
 	return ret;
 }
@@ -575,14 +572,13 @@ int iwlagn_tx_agg_oper(struct iwl_priv *priv, struct ieee80211_vif *vif,
 {
 	struct iwl_station_priv *sta_priv = (void *) sta->drv_priv;
 	struct iwl_rxon_context *ctx = iwl_rxon_ctx_from_vif(vif);
-	unsigned long flags;
 	u16 ssn;
 
 	buf_size = min_t(int, buf_size, LINK_QUAL_AGG_FRAME_LIMIT_DEF);
 
-	spin_lock_irqsave(&priv->shrd->sta_lock, flags);
+	spin_lock_bh(&priv->sta_lock);
 	ssn = priv->tid_data[sta_priv->sta_id][tid].agg.ssn;
-	spin_unlock_irqrestore(&priv->shrd->sta_lock, flags);
+	spin_unlock_bh(&priv->sta_lock);
 
 	iwl_trans_tx_agg_setup(trans(priv), ctx->ctxid, sta_priv->sta_id, tid,
 			       buf_size, ssn);
@@ -638,7 +634,7 @@ static void iwlagn_check_ratid_empty(struct iwl_priv *priv, int sta_id, u8 tid)
 	struct ieee80211_vif *vif;
 	u8 *addr;
 
-	lockdep_assert_held(&priv->shrd->sta_lock);
+	lockdep_assert_held(&priv->sta_lock);
 
 	addr = priv->stations[sta_id].sta.sta.addr;
 	ctx = priv->stations[sta_id].ctxid;
@@ -1005,7 +1001,6 @@ int iwlagn_rx_reply_tx(struct iwl_priv *priv, struct iwl_rx_mem_buffer *rxb,
 	int sta_id;
 	int freed;
 	struct ieee80211_tx_info *info;
-	unsigned long flags;
 	struct sk_buff_head skbs;
 	struct sk_buff *skb;
 	struct iwl_rxon_context *ctx;
@@ -1016,7 +1011,7 @@ int iwlagn_rx_reply_tx(struct iwl_priv *priv, struct iwl_rx_mem_buffer *rxb,
 	sta_id = (tx_resp->ra_tid & IWLAGN_TX_RES_RA_MSK) >>
 		IWLAGN_TX_RES_RA_POS;
 
-	spin_lock_irqsave(&priv->shrd->sta_lock, flags);
+	spin_lock(&priv->sta_lock);
 
 	if (is_agg)
 		iwl_rx_reply_tx_agg(priv, tx_resp);
@@ -1106,7 +1101,7 @@ int iwlagn_rx_reply_tx(struct iwl_priv *priv, struct iwl_rx_mem_buffer *rxb,
 	}
 
 	iwl_check_abort_status(priv, tx_resp->frame_count, status);
-	spin_unlock_irqrestore(&priv->shrd->sta_lock, flags);
+	spin_unlock(&priv->sta_lock);
 	return 0;
 }
 
@@ -1127,7 +1122,6 @@ int iwlagn_rx_reply_compressed_ba(struct iwl_priv *priv,
 	struct ieee80211_tx_info *info;
 	struct ieee80211_hdr *hdr;
 	struct sk_buff *skb;
-	unsigned long flags;
 	int sta_id;
 	int tid;
 	int freed;
@@ -1149,12 +1143,12 @@ int iwlagn_rx_reply_compressed_ba(struct iwl_priv *priv,
 	tid = ba_resp->tid;
 	agg = &priv->tid_data[sta_id][tid].agg;
 
-	spin_lock_irqsave(&priv->shrd->sta_lock, flags);
+	spin_lock(&priv->sta_lock);
 
 	if (unlikely(!agg->wait_for_ba)) {
 		if (unlikely(ba_resp->bitmap))
 			IWL_ERR(priv, "Received BA when not expected\n");
-		spin_unlock_irqrestore(&priv->shrd->sta_lock, flags);
+		spin_unlock(&priv->sta_lock);
 		return 0;
 	}
 
@@ -1165,7 +1159,7 @@ int iwlagn_rx_reply_compressed_ba(struct iwl_priv *priv,
 	 * transmitted ... if not, it's too late anyway). */
 	if (iwl_trans_reclaim(trans(priv), sta_id, tid, scd_flow,
 			      ba_resp_scd_ssn, 0, &reclaimed_skbs)) {
-		spin_unlock_irqrestore(&priv->shrd->sta_lock, flags);
+		spin_unlock(&priv->sta_lock);
 		return 0;
 	}
 
@@ -1230,6 +1224,6 @@ int iwlagn_rx_reply_compressed_ba(struct iwl_priv *priv,
 		ieee80211_tx_status_irqsafe(priv->hw, skb);
 	}
 
-	spin_unlock_irqrestore(&priv->shrd->sta_lock, flags);
+	spin_unlock(&priv->sta_lock);
 	return 0;
 }
diff --git a/drivers/net/wireless/iwlwifi/iwl-agn.c b/drivers/net/wireless/iwlwifi/iwl-agn.c
index a7f3a70..0090fab 100644
--- a/drivers/net/wireless/iwlwifi/iwl-agn.c
+++ b/drivers/net/wireless/iwlwifi/iwl-agn.c
@@ -749,10 +749,9 @@ int iwl_alive_start(struct iwl_priv *priv)
  */
 static void iwl_clear_driver_stations(struct iwl_priv *priv)
 {
-	unsigned long flags;
 	struct iwl_rxon_context *ctx;
 
-	spin_lock_irqsave(&priv->shrd->sta_lock, flags);
+	spin_lock_bh(&priv->sta_lock);
 	memset(priv->stations, 0, sizeof(priv->stations));
 	priv->num_stations = 0;
 
@@ -770,7 +769,7 @@ static void iwl_clear_driver_stations(struct iwl_priv *priv)
 		ctx->key_mapping_keys = 0;
 	}
 
-	spin_unlock_irqrestore(&priv->shrd->sta_lock, flags);
+	spin_unlock_bh(&priv->sta_lock);
 }
 
 void iwl_down(struct iwl_priv *priv)
@@ -1039,7 +1038,7 @@ static int iwl_init_drv(struct iwl_priv *priv)
 {
 	int ret;
 
-	spin_lock_init(&priv->shrd->sta_lock);
+	spin_lock_init(&priv->sta_lock);
 
 	mutex_init(&priv->shrd->mutex);
 
diff --git a/drivers/net/wireless/iwlwifi/iwl-dev.h b/drivers/net/wireless/iwlwifi/iwl-dev.h
index 6e5bf0a..dc57522 100644
--- a/drivers/net/wireless/iwlwifi/iwl-dev.h
+++ b/drivers/net/wireless/iwlwifi/iwl-dev.h
@@ -719,6 +719,12 @@ struct iwl_priv {
 	/*data shared among all the driver's layers */
 	struct iwl_shared *shrd;
 
+	/*
+	 * protects the station table, if shrd->lock and sta_lock are
+	 * needed, shrd->lock must be acquired first
+	 */
+	spinlock_t sta_lock;
+
 	/* ieee device used by generic ieee processing code */
 	struct ieee80211_hw *hw;
 	struct ieee80211_channel *ieee_channels;
diff --git a/drivers/net/wireless/iwlwifi/iwl-shared.h b/drivers/net/wireless/iwlwifi/iwl-shared.h
index a644162..3a0f0a4 100644
--- a/drivers/net/wireless/iwlwifi/iwl-shared.h
+++ b/drivers/net/wireless/iwlwifi/iwl-shared.h
@@ -360,8 +360,6 @@ struct iwl_cfg {
  * @nic: pointer to the nic data
  * @hw_params: see struct iwl_hw_params
  * @lock: protect general shared data
- * @sta_lock: protects the station table.
- *	If lock and sta_lock are needed, lock must be acquired first.
  * @mutex:
  * @wait_command_queue: the wait_queue for SYNC host command nad uCode load
  * @eeprom: pointer to the eeprom/OTP image
@@ -391,7 +389,6 @@ struct iwl_shared {
 	struct iwl_hw_params hw_params;
 
 	spinlock_t lock;
-	spinlock_t sta_lock;
 	struct mutex mutex;
 
 	wait_queue_head_t wait_command_queue;
-- 
1.7.0.4

