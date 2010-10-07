Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga01.intel.com ([192.55.52.88]:59931 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753511Ab0JGXIt (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 7 Oct 2010 19:08:49 -0400
From: Wey-Yi Guy <wey-yi.w.guy@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	ipw3945-devel@lists.sourceforge.net,
	Johannes Berg <johannes.berg@intel.com>,
	Wey-Yi Guy <wey-yi.w.guy@intel.com>
Subject: [PATCH 07/22] iwlwifi: move agn specific station code there
Date: Thu,  7 Oct 2010 16:07:46 -0700
Message-Id: <1286492881-15743-8-git-send-email-wey-yi.w.guy@intel.com>
In-Reply-To: <1286492881-15743-1-git-send-email-wey-yi.w.guy@intel.com>
References: <1286492881-15743-1-git-send-email-wey-yi.w.guy@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

By duplicating a little bit of code between 3945
and agn, we can move a lot of code into an agn
specific station management file and thus reduce
the amount of code in core that is dead to 3945.

before:
   text	   data	    bss	    dec	    hex	filename
 212886	   3872	     96	 216854	  34f16	iwlcore.ko
 620542	  10448	    304	 631294	  9a1fe	iwlagn.ko
 314013	   3264	    196	 317473	  4d821	iwl3945.ko

after:
   text	   data	    bss	    dec	    hex	filename
 202857	   3872	     92	 206821	  327e5	iwlcore.ko
 629102	  10448	    308	 639858	  9c372	iwlagn.ko
 314240	   3264	    196	 317700	  4d904	iwl3945.ko

delta:
 -10029   iwlcore.ko
   8560   iwlagn.ko
    227   iwl3945.ko

so it's a net win even if you have both loaded,
likely because a lot of EXPORT_SYMBOLs go away.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Wey-Yi Guy <wey-yi.w.guy@intel.com>
---
 drivers/net/wireless/iwlwifi/Makefile       |    2 +-
 drivers/net/wireless/iwlwifi/iwl-3945.c     |   32 +-
 drivers/net/wireless/iwlwifi/iwl-agn-lib.c  |    6 +-
 drivers/net/wireless/iwlwifi/iwl-agn-rs.c   |    1 +
 drivers/net/wireless/iwlwifi/iwl-agn-sta.c  |  716 ++++++++++++++++++++++++++
 drivers/net/wireless/iwlwifi/iwl-agn.c      |    2 +-
 drivers/net/wireless/iwlwifi/iwl-agn.h      |   31 ++
 drivers/net/wireless/iwlwifi/iwl-core.h     |    2 -
 drivers/net/wireless/iwlwifi/iwl-sta.c      |  725 +--------------------------
 drivers/net/wireless/iwlwifi/iwl-sta.h      |   35 +--
 drivers/net/wireless/iwlwifi/iwl3945-base.c |   25 +-
 11 files changed, 823 insertions(+), 754 deletions(-)
 create mode 100644 drivers/net/wireless/iwlwifi/iwl-agn-sta.c

diff --git a/drivers/net/wireless/iwlwifi/Makefile b/drivers/net/wireless/iwlwifi/Makefile
index 4931639..b4b24b6 100644
--- a/drivers/net/wireless/iwlwifi/Makefile
+++ b/drivers/net/wireless/iwlwifi/Makefile
@@ -12,7 +12,7 @@ obj-$(CONFIG_IWLAGN)	+= iwlagn.o
 iwlagn-objs		:= iwl-agn.o iwl-agn-rs.o iwl-agn-led.o iwl-agn-ict.o
 iwlagn-objs		+= iwl-agn-ucode.o iwl-agn-hcmd.o iwl-agn-tx.o
 iwlagn-objs		+= iwl-agn-lib.o iwl-agn-rx.o iwl-agn-calib.o
-iwlagn-objs		+= iwl-agn-tt.o
+iwlagn-objs		+= iwl-agn-tt.o iwl-agn-sta.o
 iwlagn-$(CONFIG_IWLWIFI_DEBUGFS) += iwl-agn-debugfs.o
 
 iwlagn-$(CONFIG_IWL4965) += iwl-4965.o
diff --git a/drivers/net/wireless/iwlwifi/iwl-3945.c b/drivers/net/wireless/iwlwifi/iwl-3945.c
index a7dbb28..4b3eb78 100644
--- a/drivers/net/wireless/iwlwifi/iwl-3945.c
+++ b/drivers/net/wireless/iwlwifi/iwl-3945.c
@@ -2299,6 +2299,32 @@ static u16 iwl3945_build_addsta_hcmd(const struct iwl_addsta_cmd *cmd, u8 *data)
 	return (u16)sizeof(struct iwl3945_addsta_cmd);
 }
 
+static int iwl3945_add_bssid_station(struct iwl_priv *priv,
+				     const u8 *addr, u8 *sta_id_r)
+{
+	struct iwl_rxon_context *ctx = &priv->contexts[IWL_RXON_CTX_BSS];
+	int ret;
+	u8 sta_id;
+	unsigned long flags;
+
+	if (sta_id_r)
+		*sta_id_r = IWL_INVALID_STATION;
+
+	ret = iwl_add_station_common(priv, ctx, addr, 0, NULL, &sta_id);
+	if (ret) {
+		IWL_ERR(priv, "Unable to add station %pM\n", addr);
+		return ret;
+	}
+
+	if (sta_id_r)
+		*sta_id_r = sta_id;
+
+	spin_lock_irqsave(&priv->sta_lock, flags);
+	priv->stations[sta_id].used |= IWL_STA_LOCAL;
+	spin_unlock_irqrestore(&priv->sta_lock, flags);
+
+	return 0;
+}
 static int iwl3945_manage_ibss_station(struct iwl_priv *priv,
 				       struct ieee80211_vif *vif, bool add)
 {
@@ -2306,10 +2332,8 @@ static int iwl3945_manage_ibss_station(struct iwl_priv *priv,
 	int ret;
 
 	if (add) {
-		ret = iwl_add_bssid_station(
-				priv, &priv->contexts[IWL_RXON_CTX_BSS],
-				vif->bss_conf.bssid, false,
-				&vif_priv->ibss_bssid_sta_id);
+		ret = iwl3945_add_bssid_station(priv, vif->bss_conf.bssid,
+						&vif_priv->ibss_bssid_sta_id);
 		if (ret)
 			return ret;
 
diff --git a/drivers/net/wireless/iwlwifi/iwl-agn-lib.c b/drivers/net/wireless/iwlwifi/iwl-agn-lib.c
index 0b45bce..3eeab0a 100644
--- a/drivers/net/wireless/iwlwifi/iwl-agn-lib.c
+++ b/drivers/net/wireless/iwlwifi/iwl-agn-lib.c
@@ -1587,9 +1587,9 @@ int iwlagn_manage_ibss_station(struct iwl_priv *priv,
 	struct iwl_vif_priv *vif_priv = (void *)vif->drv_priv;
 
 	if (add)
-		return iwl_add_bssid_station(priv, vif_priv->ctx,
-					     vif->bss_conf.bssid, true,
-					     &vif_priv->ibss_bssid_sta_id);
+		return iwlagn_add_bssid_station(priv, vif_priv->ctx,
+						vif->bss_conf.bssid,
+						&vif_priv->ibss_bssid_sta_id);
 	return iwl_remove_station(priv, vif_priv->ibss_bssid_sta_id,
 				  vif->bss_conf.bssid);
 }
diff --git a/drivers/net/wireless/iwlwifi/iwl-agn-rs.c b/drivers/net/wireless/iwlwifi/iwl-agn-rs.c
index f865685..7e5cf1a 100644
--- a/drivers/net/wireless/iwlwifi/iwl-agn-rs.c
+++ b/drivers/net/wireless/iwlwifi/iwl-agn-rs.c
@@ -39,6 +39,7 @@
 #include "iwl-dev.h"
 #include "iwl-sta.h"
 #include "iwl-core.h"
+#include "iwl-agn.h"
 
 #define RS_NAME "iwl-agn-rs"
 
diff --git a/drivers/net/wireless/iwlwifi/iwl-agn-sta.c b/drivers/net/wireless/iwlwifi/iwl-agn-sta.c
new file mode 100644
index 0000000..35a30d2
--- /dev/null
+++ b/drivers/net/wireless/iwlwifi/iwl-agn-sta.c
@@ -0,0 +1,716 @@
+/******************************************************************************
+ *
+ * Copyright(c) 2003 - 2010 Intel Corporation. All rights reserved.
+ *
+ * Portions of this file are derived from the ipw3945 project, as well
+ * as portions of the ieee80211 subsystem header files.
+ *
+ * This program is free software; you can redistribute it and/or modify it
+ * under the terms of version 2 of the GNU General Public License as
+ * published by the Free Software Foundation.
+ *
+ * This program is distributed in the hope that it will be useful, but WITHOUT
+ * ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or
+ * FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License for
+ * more details.
+ *
+ * You should have received a copy of the GNU General Public License along with
+ * this program; if not, write to the Free Software Foundation, Inc.,
+ * 51 Franklin Street, Fifth Floor, Boston, MA 02110, USA
+ *
+ * The full GNU General Public License is included in this distribution in the
+ * file called LICENSE.
+ *
+ * Contact Information:
+ *  Intel Linux Wireless <ilw@linux.intel.com>
+ * Intel Corporation, 5200 N.E. Elam Young Parkway, Hillsboro, OR 97124-6497
+ *
+ *****************************************************************************/
+
+#include <net/mac80211.h>
+
+#include "iwl-dev.h"
+#include "iwl-core.h"
+#include "iwl-sta.h"
+#include "iwl-agn.h"
+
+static struct iwl_link_quality_cmd *
+iwl_sta_alloc_lq(struct iwl_priv *priv, u8 sta_id)
+{
+	int i, r;
+	struct iwl_link_quality_cmd *link_cmd;
+	u32 rate_flags = 0;
+	__le32 rate_n_flags;
+
+	link_cmd = kzalloc(sizeof(struct iwl_link_quality_cmd), GFP_KERNEL);
+	if (!link_cmd) {
+		IWL_ERR(priv, "Unable to allocate memory for LQ cmd.\n");
+		return NULL;
+	}
+	/* Set up the rate scaling to start at selected rate, fall back
+	 * all the way down to 1M in IEEE order, and then spin on 1M */
+	if (priv->band == IEEE80211_BAND_5GHZ)
+		r = IWL_RATE_6M_INDEX;
+	else
+		r = IWL_RATE_1M_INDEX;
+
+	if (r >= IWL_FIRST_CCK_RATE && r <= IWL_LAST_CCK_RATE)
+		rate_flags |= RATE_MCS_CCK_MSK;
+
+	rate_flags |= first_antenna(priv->hw_params.valid_tx_ant) <<
+				RATE_MCS_ANT_POS;
+	rate_n_flags = iwl_hw_set_rate_n_flags(iwl_rates[r].plcp, rate_flags);
+	for (i = 0; i < LINK_QUAL_MAX_RETRY_NUM; i++)
+		link_cmd->rs_table[i].rate_n_flags = rate_n_flags;
+
+	link_cmd->general_params.single_stream_ant_msk =
+				first_antenna(priv->hw_params.valid_tx_ant);
+
+	link_cmd->general_params.dual_stream_ant_msk =
+		priv->hw_params.valid_tx_ant &
+		~first_antenna(priv->hw_params.valid_tx_ant);
+	if (!link_cmd->general_params.dual_stream_ant_msk) {
+		link_cmd->general_params.dual_stream_ant_msk = ANT_AB;
+	} else if (num_of_ant(priv->hw_params.valid_tx_ant) == 2) {
+		link_cmd->general_params.dual_stream_ant_msk =
+			priv->hw_params.valid_tx_ant;
+	}
+
+	link_cmd->agg_params.agg_dis_start_th = LINK_QUAL_AGG_DISABLE_START_DEF;
+	link_cmd->agg_params.agg_time_limit =
+		cpu_to_le16(LINK_QUAL_AGG_TIME_LIMIT_DEF);
+
+	link_cmd->sta_id = sta_id;
+
+	return link_cmd;
+}
+
+/*
+ * iwlagn_add_bssid_station - Add the special IBSS BSSID station
+ *
+ * Function sleeps.
+ */
+int iwlagn_add_bssid_station(struct iwl_priv *priv, struct iwl_rxon_context *ctx,
+			     const u8 *addr, u8 *sta_id_r)
+{
+	int ret;
+	u8 sta_id;
+	struct iwl_link_quality_cmd *link_cmd;
+	unsigned long flags;
+
+	if (sta_id_r)
+		*sta_id_r = IWL_INVALID_STATION;
+
+	ret = iwl_add_station_common(priv, ctx, addr, 0, NULL, &sta_id);
+	if (ret) {
+		IWL_ERR(priv, "Unable to add station %pM\n", addr);
+		return ret;
+	}
+
+	if (sta_id_r)
+		*sta_id_r = sta_id;
+
+	spin_lock_irqsave(&priv->sta_lock, flags);
+	priv->stations[sta_id].used |= IWL_STA_LOCAL;
+	spin_unlock_irqrestore(&priv->sta_lock, flags);
+
+	/* Set up default rate scaling table in device's station table */
+	link_cmd = iwl_sta_alloc_lq(priv, sta_id);
+	if (!link_cmd) {
+		IWL_ERR(priv, "Unable to initialize rate scaling for station %pM.\n",
+			addr);
+		return -ENOMEM;
+	}
+
+	ret = iwl_send_lq_cmd(priv, ctx, link_cmd, CMD_SYNC, true);
+	if (ret)
+		IWL_ERR(priv, "Link quality command failed (%d)\n", ret);
+
+	spin_lock_irqsave(&priv->sta_lock, flags);
+	priv->stations[sta_id].lq = link_cmd;
+	spin_unlock_irqrestore(&priv->sta_lock, flags);
+
+	return 0;
+}
+
+static int iwl_send_static_wepkey_cmd(struct iwl_priv *priv,
+				      struct iwl_rxon_context *ctx,
+				      bool send_if_empty)
+{
+	int i, not_empty = 0;
+	u8 buff[sizeof(struct iwl_wep_cmd) +
+		sizeof(struct iwl_wep_key) * WEP_KEYS_MAX];
+	struct iwl_wep_cmd *wep_cmd = (struct iwl_wep_cmd *)buff;
+	size_t cmd_size  = sizeof(struct iwl_wep_cmd);
+	struct iwl_host_cmd cmd = {
+		.id = ctx->wep_key_cmd,
+		.data = wep_cmd,
+		.flags = CMD_SYNC,
+	};
+
+	might_sleep();
+
+	memset(wep_cmd, 0, cmd_size +
+			(sizeof(struct iwl_wep_key) * WEP_KEYS_MAX));
+
+	for (i = 0; i < WEP_KEYS_MAX ; i++) {
+		wep_cmd->key[i].key_index = i;
+		if (ctx->wep_keys[i].key_size) {
+			wep_cmd->key[i].key_offset = i;
+			not_empty = 1;
+		} else {
+			wep_cmd->key[i].key_offset = WEP_INVALID_OFFSET;
+		}
+
+		wep_cmd->key[i].key_size = ctx->wep_keys[i].key_size;
+		memcpy(&wep_cmd->key[i].key[3], ctx->wep_keys[i].key,
+				ctx->wep_keys[i].key_size);
+	}
+
+	wep_cmd->global_key_type = WEP_KEY_WEP_TYPE;
+	wep_cmd->num_keys = WEP_KEYS_MAX;
+
+	cmd_size += sizeof(struct iwl_wep_key) * WEP_KEYS_MAX;
+
+	cmd.len = cmd_size;
+
+	if (not_empty || send_if_empty)
+		return iwl_send_cmd(priv, &cmd);
+	else
+		return 0;
+}
+
+int iwl_restore_default_wep_keys(struct iwl_priv *priv,
+				 struct iwl_rxon_context *ctx)
+{
+	lockdep_assert_held(&priv->mutex);
+
+	return iwl_send_static_wepkey_cmd(priv, ctx, false);
+}
+
+int iwl_remove_default_wep_key(struct iwl_priv *priv,
+			       struct iwl_rxon_context *ctx,
+			       struct ieee80211_key_conf *keyconf)
+{
+	int ret;
+
+	lockdep_assert_held(&priv->mutex);
+
+	IWL_DEBUG_WEP(priv, "Removing default WEP key: idx=%d\n",
+		      keyconf->keyidx);
+
+	memset(&ctx->wep_keys[keyconf->keyidx], 0, sizeof(ctx->wep_keys[0]));
+	if (iwl_is_rfkill(priv)) {
+		IWL_DEBUG_WEP(priv, "Not sending REPLY_WEPKEY command due to RFKILL.\n");
+		/* but keys in device are clear anyway so return success */
+		return 0;
+	}
+	ret = iwl_send_static_wepkey_cmd(priv, ctx, 1);
+	IWL_DEBUG_WEP(priv, "Remove default WEP key: idx=%d ret=%d\n",
+		      keyconf->keyidx, ret);
+
+	return ret;
+}
+
+int iwl_set_default_wep_key(struct iwl_priv *priv,
+			    struct iwl_rxon_context *ctx,
+			    struct ieee80211_key_conf *keyconf)
+{
+	int ret;
+
+	lockdep_assert_held(&priv->mutex);
+
+	if (keyconf->keylen != WEP_KEY_LEN_128 &&
+	    keyconf->keylen != WEP_KEY_LEN_64) {
+		IWL_DEBUG_WEP(priv, "Bad WEP key length %d\n", keyconf->keylen);
+		return -EINVAL;
+	}
+
+	keyconf->flags &= ~IEEE80211_KEY_FLAG_GENERATE_IV;
+	keyconf->hw_key_idx = HW_KEY_DEFAULT;
+	priv->stations[ctx->ap_sta_id].keyinfo.cipher = keyconf->cipher;
+
+	ctx->wep_keys[keyconf->keyidx].key_size = keyconf->keylen;
+	memcpy(&ctx->wep_keys[keyconf->keyidx].key, &keyconf->key,
+							keyconf->keylen);
+
+	ret = iwl_send_static_wepkey_cmd(priv, ctx, false);
+	IWL_DEBUG_WEP(priv, "Set default WEP key: len=%d idx=%d ret=%d\n",
+		keyconf->keylen, keyconf->keyidx, ret);
+
+	return ret;
+}
+
+static int iwl_set_wep_dynamic_key_info(struct iwl_priv *priv,
+					struct iwl_rxon_context *ctx,
+					struct ieee80211_key_conf *keyconf,
+					u8 sta_id)
+{
+	unsigned long flags;
+	__le16 key_flags = 0;
+	struct iwl_addsta_cmd sta_cmd;
+
+	lockdep_assert_held(&priv->mutex);
+
+	keyconf->flags &= ~IEEE80211_KEY_FLAG_GENERATE_IV;
+
+	key_flags |= (STA_KEY_FLG_WEP | STA_KEY_FLG_MAP_KEY_MSK);
+	key_flags |= cpu_to_le16(keyconf->keyidx << STA_KEY_FLG_KEYID_POS);
+	key_flags &= ~STA_KEY_FLG_INVALID;
+
+	if (keyconf->keylen == WEP_KEY_LEN_128)
+		key_flags |= STA_KEY_FLG_KEY_SIZE_MSK;
+
+	if (sta_id == ctx->bcast_sta_id)
+		key_flags |= STA_KEY_MULTICAST_MSK;
+
+	spin_lock_irqsave(&priv->sta_lock, flags);
+
+	priv->stations[sta_id].keyinfo.cipher = keyconf->cipher;
+	priv->stations[sta_id].keyinfo.keylen = keyconf->keylen;
+	priv->stations[sta_id].keyinfo.keyidx = keyconf->keyidx;
+
+	memcpy(priv->stations[sta_id].keyinfo.key,
+				keyconf->key, keyconf->keylen);
+
+	memcpy(&priv->stations[sta_id].sta.key.key[3],
+				keyconf->key, keyconf->keylen);
+
+	if ((priv->stations[sta_id].sta.key.key_flags & STA_KEY_FLG_ENCRYPT_MSK)
+			== STA_KEY_FLG_NO_ENC)
+		priv->stations[sta_id].sta.key.key_offset =
+				 iwl_get_free_ucode_key_index(priv);
+	/* else, we are overriding an existing key => no need to allocated room
+	 * in uCode. */
+
+	WARN(priv->stations[sta_id].sta.key.key_offset == WEP_INVALID_OFFSET,
+		"no space for a new key");
+
+	priv->stations[sta_id].sta.key.key_flags = key_flags;
+	priv->stations[sta_id].sta.sta.modify_mask = STA_MODIFY_KEY_MASK;
+	priv->stations[sta_id].sta.mode = STA_CONTROL_MODIFY_MSK;
+
+	memcpy(&sta_cmd, &priv->stations[sta_id].sta, sizeof(struct iwl_addsta_cmd));
+	spin_unlock_irqrestore(&priv->sta_lock, flags);
+
+	return iwl_send_add_sta(priv, &sta_cmd, CMD_SYNC);
+}
+
+static int iwl_set_ccmp_dynamic_key_info(struct iwl_priv *priv,
+					 struct iwl_rxon_context *ctx,
+					 struct ieee80211_key_conf *keyconf,
+					 u8 sta_id)
+{
+	unsigned long flags;
+	__le16 key_flags = 0;
+	struct iwl_addsta_cmd sta_cmd;
+
+	lockdep_assert_held(&priv->mutex);
+
+	key_flags |= (STA_KEY_FLG_CCMP | STA_KEY_FLG_MAP_KEY_MSK);
+	key_flags |= cpu_to_le16(keyconf->keyidx << STA_KEY_FLG_KEYID_POS);
+	key_flags &= ~STA_KEY_FLG_INVALID;
+
+	if (sta_id == ctx->bcast_sta_id)
+		key_flags |= STA_KEY_MULTICAST_MSK;
+
+	keyconf->flags |= IEEE80211_KEY_FLAG_GENERATE_IV;
+
+	spin_lock_irqsave(&priv->sta_lock, flags);
+	priv->stations[sta_id].keyinfo.cipher = keyconf->cipher;
+	priv->stations[sta_id].keyinfo.keylen = keyconf->keylen;
+
+	memcpy(priv->stations[sta_id].keyinfo.key, keyconf->key,
+	       keyconf->keylen);
+
+	memcpy(priv->stations[sta_id].sta.key.key, keyconf->key,
+	       keyconf->keylen);
+
+	if ((priv->stations[sta_id].sta.key.key_flags & STA_KEY_FLG_ENCRYPT_MSK)
+			== STA_KEY_FLG_NO_ENC)
+		priv->stations[sta_id].sta.key.key_offset =
+				 iwl_get_free_ucode_key_index(priv);
+	/* else, we are overriding an existing key => no need to allocated room
+	 * in uCode. */
+
+	WARN(priv->stations[sta_id].sta.key.key_offset == WEP_INVALID_OFFSET,
+		"no space for a new key");
+
+	priv->stations[sta_id].sta.key.key_flags = key_flags;
+	priv->stations[sta_id].sta.sta.modify_mask = STA_MODIFY_KEY_MASK;
+	priv->stations[sta_id].sta.mode = STA_CONTROL_MODIFY_MSK;
+
+	memcpy(&sta_cmd, &priv->stations[sta_id].sta, sizeof(struct iwl_addsta_cmd));
+	spin_unlock_irqrestore(&priv->sta_lock, flags);
+
+	return iwl_send_add_sta(priv, &sta_cmd, CMD_SYNC);
+}
+
+static int iwl_set_tkip_dynamic_key_info(struct iwl_priv *priv,
+					 struct iwl_rxon_context *ctx,
+					 struct ieee80211_key_conf *keyconf,
+					 u8 sta_id)
+{
+	unsigned long flags;
+	int ret = 0;
+	__le16 key_flags = 0;
+
+	key_flags |= (STA_KEY_FLG_TKIP | STA_KEY_FLG_MAP_KEY_MSK);
+	key_flags |= cpu_to_le16(keyconf->keyidx << STA_KEY_FLG_KEYID_POS);
+	key_flags &= ~STA_KEY_FLG_INVALID;
+
+	if (sta_id == ctx->bcast_sta_id)
+		key_flags |= STA_KEY_MULTICAST_MSK;
+
+	keyconf->flags |= IEEE80211_KEY_FLAG_GENERATE_IV;
+	keyconf->flags |= IEEE80211_KEY_FLAG_GENERATE_MMIC;
+
+	spin_lock_irqsave(&priv->sta_lock, flags);
+
+	priv->stations[sta_id].keyinfo.cipher = keyconf->cipher;
+	priv->stations[sta_id].keyinfo.keylen = 16;
+
+	if ((priv->stations[sta_id].sta.key.key_flags & STA_KEY_FLG_ENCRYPT_MSK)
+			== STA_KEY_FLG_NO_ENC)
+		priv->stations[sta_id].sta.key.key_offset =
+				 iwl_get_free_ucode_key_index(priv);
+	/* else, we are overriding an existing key => no need to allocated room
+	 * in uCode. */
+
+	WARN(priv->stations[sta_id].sta.key.key_offset == WEP_INVALID_OFFSET,
+		"no space for a new key");
+
+	priv->stations[sta_id].sta.key.key_flags = key_flags;
+
+
+	/* This copy is acutally not needed: we get the key with each TX */
+	memcpy(priv->stations[sta_id].keyinfo.key, keyconf->key, 16);
+
+	memcpy(priv->stations[sta_id].sta.key.key, keyconf->key, 16);
+
+	spin_unlock_irqrestore(&priv->sta_lock, flags);
+
+	return ret;
+}
+
+void iwl_update_tkip_key(struct iwl_priv *priv,
+			 struct iwl_rxon_context *ctx,
+			 struct ieee80211_key_conf *keyconf,
+			 struct ieee80211_sta *sta, u32 iv32, u16 *phase1key)
+{
+	u8 sta_id;
+	unsigned long flags;
+	int i;
+
+	if (iwl_scan_cancel(priv)) {
+		/* cancel scan failed, just live w/ bad key and rely
+		   briefly on SW decryption */
+		return;
+	}
+
+	sta_id = iwl_sta_id_or_broadcast(priv, ctx, sta);
+	if (sta_id == IWL_INVALID_STATION)
+		return;
+
+	spin_lock_irqsave(&priv->sta_lock, flags);
+
+	priv->stations[sta_id].sta.key.tkip_rx_tsc_byte2 = (u8) iv32;
+
+	for (i = 0; i < 5; i++)
+		priv->stations[sta_id].sta.key.tkip_rx_ttak[i] =
+			cpu_to_le16(phase1key[i]);
+
+	priv->stations[sta_id].sta.sta.modify_mask = STA_MODIFY_KEY_MASK;
+	priv->stations[sta_id].sta.mode = STA_CONTROL_MODIFY_MSK;
+
+	iwl_send_add_sta(priv, &priv->stations[sta_id].sta, CMD_ASYNC);
+
+	spin_unlock_irqrestore(&priv->sta_lock, flags);
+
+}
+
+int iwl_remove_dynamic_key(struct iwl_priv *priv,
+			   struct iwl_rxon_context *ctx,
+			   struct ieee80211_key_conf *keyconf,
+			   u8 sta_id)
+{
+	unsigned long flags;
+	u16 key_flags;
+	u8 keyidx;
+	struct iwl_addsta_cmd sta_cmd;
+
+	lockdep_assert_held(&priv->mutex);
+
+	ctx->key_mapping_keys--;
+
+	spin_lock_irqsave(&priv->sta_lock, flags);
+	key_flags = le16_to_cpu(priv->stations[sta_id].sta.key.key_flags);
+	keyidx = (key_flags >> STA_KEY_FLG_KEYID_POS) & 0x3;
+
+	IWL_DEBUG_WEP(priv, "Remove dynamic key: idx=%d sta=%d\n",
+		      keyconf->keyidx, sta_id);
+
+	if (keyconf->keyidx != keyidx) {
+		/* We need to remove a key with index different that the one
+		 * in the uCode. This means that the key we need to remove has
+		 * been replaced by another one with different index.
+		 * Don't do anything and return ok
+		 */
+		spin_unlock_irqrestore(&priv->sta_lock, flags);
+		return 0;
+	}
+
+	if (priv->stations[sta_id].sta.key.key_offset == WEP_INVALID_OFFSET) {
+		IWL_WARN(priv, "Removing wrong key %d 0x%x\n",
+			    keyconf->keyidx, key_flags);
+		spin_unlock_irqrestore(&priv->sta_lock, flags);
+		return 0;
+	}
+
+	if (!test_and_clear_bit(priv->stations[sta_id].sta.key.key_offset,
+		&priv->ucode_key_table))
+		IWL_ERR(priv, "index %d not used in uCode key table.\n",
+			priv->stations[sta_id].sta.key.key_offset);
+	memset(&priv->stations[sta_id].keyinfo, 0,
+					sizeof(struct iwl_hw_key));
+	memset(&priv->stations[sta_id].sta.key, 0,
+					sizeof(struct iwl4965_keyinfo));
+	priv->stations[sta_id].sta.key.key_flags =
+			STA_KEY_FLG_NO_ENC | STA_KEY_FLG_INVALID;
+	priv->stations[sta_id].sta.key.key_offset = WEP_INVALID_OFFSET;
+	priv->stations[sta_id].sta.sta.modify_mask = STA_MODIFY_KEY_MASK;
+	priv->stations[sta_id].sta.mode = STA_CONTROL_MODIFY_MSK;
+
+	if (iwl_is_rfkill(priv)) {
+		IWL_DEBUG_WEP(priv, "Not sending REPLY_ADD_STA command because RFKILL enabled.\n");
+		spin_unlock_irqrestore(&priv->sta_lock, flags);
+		return 0;
+	}
+	memcpy(&sta_cmd, &priv->stations[sta_id].sta, sizeof(struct iwl_addsta_cmd));
+	spin_unlock_irqrestore(&priv->sta_lock, flags);
+
+	return iwl_send_add_sta(priv, &sta_cmd, CMD_SYNC);
+}
+
+int iwl_set_dynamic_key(struct iwl_priv *priv, struct iwl_rxon_context *ctx,
+			struct ieee80211_key_conf *keyconf, u8 sta_id)
+{
+	int ret;
+
+	lockdep_assert_held(&priv->mutex);
+
+	ctx->key_mapping_keys++;
+	keyconf->hw_key_idx = HW_KEY_DYNAMIC;
+
+	switch (keyconf->cipher) {
+	case WLAN_CIPHER_SUITE_CCMP:
+		ret = iwl_set_ccmp_dynamic_key_info(priv, ctx, keyconf, sta_id);
+		break;
+	case WLAN_CIPHER_SUITE_TKIP:
+		ret = iwl_set_tkip_dynamic_key_info(priv, ctx, keyconf, sta_id);
+		break;
+	case WLAN_CIPHER_SUITE_WEP40:
+	case WLAN_CIPHER_SUITE_WEP104:
+		ret = iwl_set_wep_dynamic_key_info(priv, ctx, keyconf, sta_id);
+		break;
+	default:
+		IWL_ERR(priv,
+			"Unknown alg: %s cipher = %x\n", __func__,
+			keyconf->cipher);
+		ret = -EINVAL;
+	}
+
+	IWL_DEBUG_WEP(priv, "Set dynamic key: cipher=%x len=%d idx=%d sta=%d ret=%d\n",
+		      keyconf->cipher, keyconf->keylen, keyconf->keyidx,
+		      sta_id, ret);
+
+	return ret;
+}
+
+/**
+ * iwlagn_alloc_bcast_station - add broadcast station into driver's station table.
+ *
+ * This adds the broadcast station into the driver's station table
+ * and marks it driver active, so that it will be restored to the
+ * device at the next best time.
+ */
+int iwlagn_alloc_bcast_station(struct iwl_priv *priv,
+			       struct iwl_rxon_context *ctx)
+{
+	struct iwl_link_quality_cmd *link_cmd;
+	unsigned long flags;
+	u8 sta_id;
+
+	spin_lock_irqsave(&priv->sta_lock, flags);
+	sta_id = iwl_prep_station(priv, ctx, iwl_bcast_addr, false, NULL);
+	if (sta_id == IWL_INVALID_STATION) {
+		IWL_ERR(priv, "Unable to prepare broadcast station\n");
+		spin_unlock_irqrestore(&priv->sta_lock, flags);
+
+		return -EINVAL;
+	}
+
+	priv->stations[sta_id].used |= IWL_STA_DRIVER_ACTIVE;
+	priv->stations[sta_id].used |= IWL_STA_BCAST;
+	spin_unlock_irqrestore(&priv->sta_lock, flags);
+
+	link_cmd = iwl_sta_alloc_lq(priv, sta_id);
+	if (!link_cmd) {
+		IWL_ERR(priv,
+			"Unable to initialize rate scaling for bcast station.\n");
+		return -ENOMEM;
+	}
+
+	spin_lock_irqsave(&priv->sta_lock, flags);
+	priv->stations[sta_id].lq = link_cmd;
+	spin_unlock_irqrestore(&priv->sta_lock, flags);
+
+	return 0;
+}
+
+/**
+ * iwl_update_bcast_station - update broadcast station's LQ command
+ *
+ * Only used by iwlagn. Placed here to have all bcast station management
+ * code together.
+ */
+static int iwl_update_bcast_station(struct iwl_priv *priv,
+				    struct iwl_rxon_context *ctx)
+{
+	unsigned long flags;
+	struct iwl_link_quality_cmd *link_cmd;
+	u8 sta_id = ctx->bcast_sta_id;
+
+	link_cmd = iwl_sta_alloc_lq(priv, sta_id);
+	if (!link_cmd) {
+		IWL_ERR(priv, "Unable to initialize rate scaling for bcast station.\n");
+		return -ENOMEM;
+	}
+
+	spin_lock_irqsave(&priv->sta_lock, flags);
+	if (priv->stations[sta_id].lq)
+		kfree(priv->stations[sta_id].lq);
+	else
+		IWL_DEBUG_INFO(priv, "Bcast station rate scaling has not been initialized yet.\n");
+	priv->stations[sta_id].lq = link_cmd;
+	spin_unlock_irqrestore(&priv->sta_lock, flags);
+
+	return 0;
+}
+
+int iwl_update_bcast_stations(struct iwl_priv *priv)
+{
+	struct iwl_rxon_context *ctx;
+	int ret = 0;
+
+	for_each_context(priv, ctx) {
+		ret = iwl_update_bcast_station(priv, ctx);
+		if (ret)
+			break;
+	}
+
+	return ret;
+}
+
+/**
+ * iwl_sta_tx_modify_enable_tid - Enable Tx for this TID in station table
+ */
+int iwl_sta_tx_modify_enable_tid(struct iwl_priv *priv, int sta_id, int tid)
+{
+	unsigned long flags;
+	struct iwl_addsta_cmd sta_cmd;
+
+	lockdep_assert_held(&priv->mutex);
+
+	/* Remove "disable" flag, to enable Tx for this TID */
+	spin_lock_irqsave(&priv->sta_lock, flags);
+	priv->stations[sta_id].sta.sta.modify_mask = STA_MODIFY_TID_DISABLE_TX;
+	priv->stations[sta_id].sta.tid_disable_tx &= cpu_to_le16(~(1 << tid));
+	priv->stations[sta_id].sta.mode = STA_CONTROL_MODIFY_MSK;
+	memcpy(&sta_cmd, &priv->stations[sta_id].sta, sizeof(struct iwl_addsta_cmd));
+	spin_unlock_irqrestore(&priv->sta_lock, flags);
+
+	return iwl_send_add_sta(priv, &sta_cmd, CMD_SYNC);
+}
+
+int iwl_sta_rx_agg_start(struct iwl_priv *priv, struct ieee80211_sta *sta,
+			 int tid, u16 ssn)
+{
+	unsigned long flags;
+	int sta_id;
+	struct iwl_addsta_cmd sta_cmd;
+
+	lockdep_assert_held(&priv->mutex);
+
+	sta_id = iwl_sta_id(sta);
+	if (sta_id == IWL_INVALID_STATION)
+		return -ENXIO;
+
+	spin_lock_irqsave(&priv->sta_lock, flags);
+	priv->stations[sta_id].sta.station_flags_msk = 0;
+	priv->stations[sta_id].sta.sta.modify_mask = STA_MODIFY_ADDBA_TID_MSK;
+	priv->stations[sta_id].sta.add_immediate_ba_tid = (u8)tid;
+	priv->stations[sta_id].sta.add_immediate_ba_ssn = cpu_to_le16(ssn);
+	priv->stations[sta_id].sta.mode = STA_CONTROL_MODIFY_MSK;
+	memcpy(&sta_cmd, &priv->stations[sta_id].sta, sizeof(struct iwl_addsta_cmd));
+	spin_unlock_irqrestore(&priv->sta_lock, flags);
+
+	return iwl_send_add_sta(priv, &sta_cmd, CMD_SYNC);
+}
+
+int iwl_sta_rx_agg_stop(struct iwl_priv *priv, struct ieee80211_sta *sta,
+			int tid)
+{
+	unsigned long flags;
+	int sta_id;
+	struct iwl_addsta_cmd sta_cmd;
+
+	lockdep_assert_held(&priv->mutex);
+
+	sta_id = iwl_sta_id(sta);
+	if (sta_id == IWL_INVALID_STATION) {
+		IWL_ERR(priv, "Invalid station for AGG tid %d\n", tid);
+		return -ENXIO;
+	}
+
+	spin_lock_irqsave(&priv->sta_lock, flags);
+	priv->stations[sta_id].sta.station_flags_msk = 0;
+	priv->stations[sta_id].sta.sta.modify_mask = STA_MODIFY_DELBA_TID_MSK;
+	priv->stations[sta_id].sta.remove_immediate_ba_tid = (u8)tid;
+	priv->stations[sta_id].sta.mode = STA_CONTROL_MODIFY_MSK;
+	memcpy(&sta_cmd, &priv->stations[sta_id].sta, sizeof(struct iwl_addsta_cmd));
+	spin_unlock_irqrestore(&priv->sta_lock, flags);
+
+	return iwl_send_add_sta(priv, &sta_cmd, CMD_SYNC);
+}
+
+void iwl_sta_modify_ps_wake(struct iwl_priv *priv, int sta_id)
+{
+	unsigned long flags;
+
+	spin_lock_irqsave(&priv->sta_lock, flags);
+	priv->stations[sta_id].sta.station_flags &= ~STA_FLG_PWR_SAVE_MSK;
+	priv->stations[sta_id].sta.station_flags_msk = STA_FLG_PWR_SAVE_MSK;
+	priv->stations[sta_id].sta.sta.modify_mask = 0;
+	priv->stations[sta_id].sta.sleep_tx_count = 0;
+	priv->stations[sta_id].sta.mode = STA_CONTROL_MODIFY_MSK;
+	iwl_send_add_sta(priv, &priv->stations[sta_id].sta, CMD_ASYNC);
+	spin_unlock_irqrestore(&priv->sta_lock, flags);
+
+}
+
+void iwl_sta_modify_sleep_tx_count(struct iwl_priv *priv, int sta_id, int cnt)
+{
+	unsigned long flags;
+
+	spin_lock_irqsave(&priv->sta_lock, flags);
+	priv->stations[sta_id].sta.station_flags |= STA_FLG_PWR_SAVE_MSK;
+	priv->stations[sta_id].sta.station_flags_msk = STA_FLG_PWR_SAVE_MSK;
+	priv->stations[sta_id].sta.sta.modify_mask =
+					STA_MODIFY_SLEEP_TX_COUNT_MSK;
+	priv->stations[sta_id].sta.sleep_tx_count = cpu_to_le16(cnt);
+	priv->stations[sta_id].sta.mode = STA_CONTROL_MODIFY_MSK;
+	iwl_send_add_sta(priv, &priv->stations[sta_id].sta, CMD_ASYNC);
+	spin_unlock_irqrestore(&priv->sta_lock, flags);
+
+}
diff --git a/drivers/net/wireless/iwlwifi/iwl-agn.c b/drivers/net/wireless/iwlwifi/iwl-agn.c
index b59ce92..8233c64 100644
--- a/drivers/net/wireless/iwlwifi/iwl-agn.c
+++ b/drivers/net/wireless/iwlwifi/iwl-agn.c
@@ -3089,7 +3089,7 @@ static int __iwl_up(struct iwl_priv *priv)
 	}
 
 	for_each_context(priv, ctx) {
-		ret = iwl_alloc_bcast_station(priv, ctx, true);
+		ret = iwlagn_alloc_bcast_station(priv, ctx);
 		if (ret) {
 			iwl_dealloc_bcast_stations(priv);
 			return ret;
diff --git a/drivers/net/wireless/iwlwifi/iwl-agn.h b/drivers/net/wireless/iwlwifi/iwl-agn.h
index 5d5cacb..632ea4b 100644
--- a/drivers/net/wireless/iwlwifi/iwl-agn.h
+++ b/drivers/net/wireless/iwlwifi/iwl-agn.h
@@ -252,4 +252,35 @@ const char *iwl_get_agg_tx_fail_reason(u16 status);
 #else
 static inline const char *iwl_get_agg_tx_fail_reason(u16 status) { return ""; }
 #endif
+
+/* station management */
+int iwlagn_alloc_bcast_station(struct iwl_priv *priv,
+			       struct iwl_rxon_context *ctx);
+int iwlagn_add_bssid_station(struct iwl_priv *priv, struct iwl_rxon_context *ctx,
+			     const u8 *addr, u8 *sta_id_r);
+int iwl_remove_default_wep_key(struct iwl_priv *priv,
+			       struct iwl_rxon_context *ctx,
+			       struct ieee80211_key_conf *key);
+int iwl_set_default_wep_key(struct iwl_priv *priv,
+			    struct iwl_rxon_context *ctx,
+			    struct ieee80211_key_conf *key);
+int iwl_restore_default_wep_keys(struct iwl_priv *priv,
+				 struct iwl_rxon_context *ctx);
+int iwl_set_dynamic_key(struct iwl_priv *priv, struct iwl_rxon_context *ctx,
+			struct ieee80211_key_conf *key, u8 sta_id);
+int iwl_remove_dynamic_key(struct iwl_priv *priv, struct iwl_rxon_context *ctx,
+			   struct ieee80211_key_conf *key, u8 sta_id);
+void iwl_update_tkip_key(struct iwl_priv *priv,
+			 struct iwl_rxon_context *ctx,
+			 struct ieee80211_key_conf *keyconf,
+			 struct ieee80211_sta *sta, u32 iv32, u16 *phase1key);
+int iwl_sta_tx_modify_enable_tid(struct iwl_priv *priv, int sta_id, int tid);
+int iwl_sta_rx_agg_start(struct iwl_priv *priv, struct ieee80211_sta *sta,
+			 int tid, u16 ssn);
+int iwl_sta_rx_agg_stop(struct iwl_priv *priv, struct ieee80211_sta *sta,
+			int tid);
+void iwl_sta_modify_ps_wake(struct iwl_priv *priv, int sta_id);
+void iwl_sta_modify_sleep_tx_count(struct iwl_priv *priv, int sta_id, int cnt);
+int iwl_update_bcast_stations(struct iwl_priv *priv);
+
 #endif /* __iwl_agn_h__ */
diff --git a/drivers/net/wireless/iwlwifi/iwl-core.h b/drivers/net/wireless/iwlwifi/iwl-core.h
index 50a3c26..31ec9db 100644
--- a/drivers/net/wireless/iwlwifi/iwl-core.h
+++ b/drivers/net/wireless/iwlwifi/iwl-core.h
@@ -750,8 +750,6 @@ static inline int iwl_is_ready_rf(struct iwl_priv *priv)
 extern void iwl_send_bt_config(struct iwl_priv *priv);
 extern int iwl_send_statistics_request(struct iwl_priv *priv,
 				       u8 flags, bool clear);
-extern int iwl_send_lq_cmd(struct iwl_priv *priv, struct iwl_rxon_context *ctx,
-		struct iwl_link_quality_cmd *lq, u8 flags, bool init);
 void iwl_apm_stop(struct iwl_priv *priv);
 int iwl_apm_init(struct iwl_priv *priv);
 
diff --git a/drivers/net/wireless/iwlwifi/iwl-sta.c b/drivers/net/wireless/iwlwifi/iwl-sta.c
index 6edd034..7c7f7dc 100644
--- a/drivers/net/wireless/iwlwifi/iwl-sta.c
+++ b/drivers/net/wireless/iwlwifi/iwl-sta.c
@@ -228,9 +228,8 @@ static void iwl_set_ht_add_station(struct iwl_priv *priv, u8 index,
  *
  * should be called with sta_lock held
  */
-static u8 iwl_prep_station(struct iwl_priv *priv, struct iwl_rxon_context *ctx,
-			   const u8 *addr, bool is_ap,
-			   struct ieee80211_sta *sta)
+u8 iwl_prep_station(struct iwl_priv *priv, struct iwl_rxon_context *ctx,
+		    const u8 *addr, bool is_ap, struct ieee80211_sta *sta)
 {
 	struct iwl_station_entry *station;
 	int i;
@@ -317,6 +316,7 @@ static u8 iwl_prep_station(struct iwl_priv *priv, struct iwl_rxon_context *ctx,
 	return sta_id;
 
 }
+EXPORT_SYMBOL_GPL(iwl_prep_station);
 
 #define STA_WAIT_TIMEOUT (HZ/2)
 
@@ -381,108 +381,6 @@ int iwl_add_station_common(struct iwl_priv *priv, struct iwl_rxon_context *ctx,
 }
 EXPORT_SYMBOL(iwl_add_station_common);
 
-static struct iwl_link_quality_cmd *iwl_sta_alloc_lq(struct iwl_priv *priv,
-						     u8 sta_id)
-{
-	int i, r;
-	struct iwl_link_quality_cmd *link_cmd;
-	u32 rate_flags = 0;
-	__le32 rate_n_flags;
-
-	link_cmd = kzalloc(sizeof(struct iwl_link_quality_cmd), GFP_KERNEL);
-	if (!link_cmd) {
-		IWL_ERR(priv, "Unable to allocate memory for LQ cmd.\n");
-		return NULL;
-	}
-	/* Set up the rate scaling to start at selected rate, fall back
-	 * all the way down to 1M in IEEE order, and then spin on 1M */
-	if (priv->band == IEEE80211_BAND_5GHZ)
-		r = IWL_RATE_6M_INDEX;
-	else
-		r = IWL_RATE_1M_INDEX;
-
-	if (r >= IWL_FIRST_CCK_RATE && r <= IWL_LAST_CCK_RATE)
-		rate_flags |= RATE_MCS_CCK_MSK;
-
-	rate_flags |= first_antenna(priv->hw_params.valid_tx_ant) <<
-				RATE_MCS_ANT_POS;
-	rate_n_flags = iwl_hw_set_rate_n_flags(iwl_rates[r].plcp, rate_flags);
-	for (i = 0; i < LINK_QUAL_MAX_RETRY_NUM; i++)
-		link_cmd->rs_table[i].rate_n_flags = rate_n_flags;
-
-	link_cmd->general_params.single_stream_ant_msk =
-				first_antenna(priv->hw_params.valid_tx_ant);
-
-	link_cmd->general_params.dual_stream_ant_msk =
-		priv->hw_params.valid_tx_ant &
-		~first_antenna(priv->hw_params.valid_tx_ant);
-	if (!link_cmd->general_params.dual_stream_ant_msk) {
-		link_cmd->general_params.dual_stream_ant_msk = ANT_AB;
-	} else if (num_of_ant(priv->hw_params.valid_tx_ant) == 2) {
-		link_cmd->general_params.dual_stream_ant_msk =
-			priv->hw_params.valid_tx_ant;
-	}
-
-	link_cmd->agg_params.agg_dis_start_th = LINK_QUAL_AGG_DISABLE_START_DEF;
-	link_cmd->agg_params.agg_time_limit =
-		cpu_to_le16(LINK_QUAL_AGG_TIME_LIMIT_DEF);
-
-	link_cmd->sta_id = sta_id;
-
-	return link_cmd;
-}
-
-/*
- * iwl_add_bssid_station - Add the special IBSS BSSID station
- *
- * Function sleeps.
- */
-int iwl_add_bssid_station(struct iwl_priv *priv, struct iwl_rxon_context *ctx,
-			  const u8 *addr, bool init_rs, u8 *sta_id_r)
-{
-	int ret;
-	u8 sta_id;
-	struct iwl_link_quality_cmd *link_cmd;
-	unsigned long flags;
-
-	if (sta_id_r)
-		*sta_id_r = IWL_INVALID_STATION;
-
-	ret = iwl_add_station_common(priv, ctx, addr, 0, NULL, &sta_id);
-	if (ret) {
-		IWL_ERR(priv, "Unable to add station %pM\n", addr);
-		return ret;
-	}
-
-	if (sta_id_r)
-		*sta_id_r = sta_id;
-
-	spin_lock_irqsave(&priv->sta_lock, flags);
-	priv->stations[sta_id].used |= IWL_STA_LOCAL;
-	spin_unlock_irqrestore(&priv->sta_lock, flags);
-
-	if (init_rs) {
-		/* Set up default rate scaling table in device's station table */
-		link_cmd = iwl_sta_alloc_lq(priv, sta_id);
-		if (!link_cmd) {
-			IWL_ERR(priv, "Unable to initialize rate scaling for station %pM.\n",
-				addr);
-			return -ENOMEM;
-		}
-
-		ret = iwl_send_lq_cmd(priv, ctx, link_cmd, CMD_SYNC, true);
-		if (ret)
-			IWL_ERR(priv, "Link quality command failed (%d)\n", ret);
-
-		spin_lock_irqsave(&priv->sta_lock, flags);
-		priv->stations[sta_id].lq = link_cmd;
-		spin_unlock_irqrestore(&priv->sta_lock, flags);
-	}
-
-	return 0;
-}
-EXPORT_SYMBOL(iwl_add_bssid_station);
-
 /**
  * iwl_sta_ucode_deactivate - deactivate ucode status for a station
  *
@@ -738,405 +636,25 @@ int iwl_get_free_ucode_key_index(struct iwl_priv *priv)
 }
 EXPORT_SYMBOL(iwl_get_free_ucode_key_index);
 
-static int iwl_send_static_wepkey_cmd(struct iwl_priv *priv,
-				      struct iwl_rxon_context *ctx,
-				      bool send_if_empty)
-{
-	int i, not_empty = 0;
-	u8 buff[sizeof(struct iwl_wep_cmd) +
-		sizeof(struct iwl_wep_key) * WEP_KEYS_MAX];
-	struct iwl_wep_cmd *wep_cmd = (struct iwl_wep_cmd *)buff;
-	size_t cmd_size  = sizeof(struct iwl_wep_cmd);
-	struct iwl_host_cmd cmd = {
-		.id = ctx->wep_key_cmd,
-		.data = wep_cmd,
-		.flags = CMD_SYNC,
-	};
-
-	might_sleep();
-
-	memset(wep_cmd, 0, cmd_size +
-			(sizeof(struct iwl_wep_key) * WEP_KEYS_MAX));
-
-	for (i = 0; i < WEP_KEYS_MAX ; i++) {
-		wep_cmd->key[i].key_index = i;
-		if (ctx->wep_keys[i].key_size) {
-			wep_cmd->key[i].key_offset = i;
-			not_empty = 1;
-		} else {
-			wep_cmd->key[i].key_offset = WEP_INVALID_OFFSET;
-		}
-
-		wep_cmd->key[i].key_size = ctx->wep_keys[i].key_size;
-		memcpy(&wep_cmd->key[i].key[3], ctx->wep_keys[i].key,
-				ctx->wep_keys[i].key_size);
-	}
-
-	wep_cmd->global_key_type = WEP_KEY_WEP_TYPE;
-	wep_cmd->num_keys = WEP_KEYS_MAX;
-
-	cmd_size += sizeof(struct iwl_wep_key) * WEP_KEYS_MAX;
-
-	cmd.len = cmd_size;
-
-	if (not_empty || send_if_empty)
-		return iwl_send_cmd(priv, &cmd);
-	else
-		return 0;
-}
-
-int iwl_restore_default_wep_keys(struct iwl_priv *priv,
-				 struct iwl_rxon_context *ctx)
-{
-	lockdep_assert_held(&priv->mutex);
-
-	return iwl_send_static_wepkey_cmd(priv, ctx, false);
-}
-EXPORT_SYMBOL(iwl_restore_default_wep_keys);
-
-int iwl_remove_default_wep_key(struct iwl_priv *priv,
-			       struct iwl_rxon_context *ctx,
-			       struct ieee80211_key_conf *keyconf)
-{
-	int ret;
-
-	lockdep_assert_held(&priv->mutex);
-
-	IWL_DEBUG_WEP(priv, "Removing default WEP key: idx=%d\n",
-		      keyconf->keyidx);
-
-	memset(&ctx->wep_keys[keyconf->keyidx], 0, sizeof(ctx->wep_keys[0]));
-	if (iwl_is_rfkill(priv)) {
-		IWL_DEBUG_WEP(priv, "Not sending REPLY_WEPKEY command due to RFKILL.\n");
-		/* but keys in device are clear anyway so return success */
-		return 0;
-	}
-	ret = iwl_send_static_wepkey_cmd(priv, ctx, 1);
-	IWL_DEBUG_WEP(priv, "Remove default WEP key: idx=%d ret=%d\n",
-		      keyconf->keyidx, ret);
-
-	return ret;
-}
-EXPORT_SYMBOL(iwl_remove_default_wep_key);
-
-int iwl_set_default_wep_key(struct iwl_priv *priv,
-			    struct iwl_rxon_context *ctx,
-			    struct ieee80211_key_conf *keyconf)
-{
-	int ret;
-
-	lockdep_assert_held(&priv->mutex);
-
-	if (keyconf->keylen != WEP_KEY_LEN_128 &&
-	    keyconf->keylen != WEP_KEY_LEN_64) {
-		IWL_DEBUG_WEP(priv, "Bad WEP key length %d\n", keyconf->keylen);
-		return -EINVAL;
-	}
-
-	keyconf->flags &= ~IEEE80211_KEY_FLAG_GENERATE_IV;
-	keyconf->hw_key_idx = HW_KEY_DEFAULT;
-	priv->stations[ctx->ap_sta_id].keyinfo.cipher = keyconf->cipher;
-
-	ctx->wep_keys[keyconf->keyidx].key_size = keyconf->keylen;
-	memcpy(&ctx->wep_keys[keyconf->keyidx].key, &keyconf->key,
-							keyconf->keylen);
-
-	ret = iwl_send_static_wepkey_cmd(priv, ctx, false);
-	IWL_DEBUG_WEP(priv, "Set default WEP key: len=%d idx=%d ret=%d\n",
-		keyconf->keylen, keyconf->keyidx, ret);
-
-	return ret;
-}
-EXPORT_SYMBOL(iwl_set_default_wep_key);
-
-static int iwl_set_wep_dynamic_key_info(struct iwl_priv *priv,
-					struct iwl_rxon_context *ctx,
-					struct ieee80211_key_conf *keyconf,
-					u8 sta_id)
-{
-	unsigned long flags;
-	__le16 key_flags = 0;
-	struct iwl_addsta_cmd sta_cmd;
-
-	lockdep_assert_held(&priv->mutex);
-
-	keyconf->flags &= ~IEEE80211_KEY_FLAG_GENERATE_IV;
-
-	key_flags |= (STA_KEY_FLG_WEP | STA_KEY_FLG_MAP_KEY_MSK);
-	key_flags |= cpu_to_le16(keyconf->keyidx << STA_KEY_FLG_KEYID_POS);
-	key_flags &= ~STA_KEY_FLG_INVALID;
-
-	if (keyconf->keylen == WEP_KEY_LEN_128)
-		key_flags |= STA_KEY_FLG_KEY_SIZE_MSK;
-
-	if (sta_id == ctx->bcast_sta_id)
-		key_flags |= STA_KEY_MULTICAST_MSK;
-
-	spin_lock_irqsave(&priv->sta_lock, flags);
-
-	priv->stations[sta_id].keyinfo.cipher = keyconf->cipher;
-	priv->stations[sta_id].keyinfo.keylen = keyconf->keylen;
-	priv->stations[sta_id].keyinfo.keyidx = keyconf->keyidx;
-
-	memcpy(priv->stations[sta_id].keyinfo.key,
-				keyconf->key, keyconf->keylen);
-
-	memcpy(&priv->stations[sta_id].sta.key.key[3],
-				keyconf->key, keyconf->keylen);
-
-	if ((priv->stations[sta_id].sta.key.key_flags & STA_KEY_FLG_ENCRYPT_MSK)
-			== STA_KEY_FLG_NO_ENC)
-		priv->stations[sta_id].sta.key.key_offset =
-				 iwl_get_free_ucode_key_index(priv);
-	/* else, we are overriding an existing key => no need to allocated room
-	 * in uCode. */
-
-	WARN(priv->stations[sta_id].sta.key.key_offset == WEP_INVALID_OFFSET,
-		"no space for a new key");
-
-	priv->stations[sta_id].sta.key.key_flags = key_flags;
-	priv->stations[sta_id].sta.sta.modify_mask = STA_MODIFY_KEY_MASK;
-	priv->stations[sta_id].sta.mode = STA_CONTROL_MODIFY_MSK;
-
-	memcpy(&sta_cmd, &priv->stations[sta_id].sta, sizeof(struct iwl_addsta_cmd));
-	spin_unlock_irqrestore(&priv->sta_lock, flags);
-
-	return iwl_send_add_sta(priv, &sta_cmd, CMD_SYNC);
-}
-
-static int iwl_set_ccmp_dynamic_key_info(struct iwl_priv *priv,
-					 struct iwl_rxon_context *ctx,
-					 struct ieee80211_key_conf *keyconf,
-					 u8 sta_id)
-{
-	unsigned long flags;
-	__le16 key_flags = 0;
-	struct iwl_addsta_cmd sta_cmd;
-
-	lockdep_assert_held(&priv->mutex);
-
-	key_flags |= (STA_KEY_FLG_CCMP | STA_KEY_FLG_MAP_KEY_MSK);
-	key_flags |= cpu_to_le16(keyconf->keyidx << STA_KEY_FLG_KEYID_POS);
-	key_flags &= ~STA_KEY_FLG_INVALID;
-
-	if (sta_id == ctx->bcast_sta_id)
-		key_flags |= STA_KEY_MULTICAST_MSK;
-
-	keyconf->flags |= IEEE80211_KEY_FLAG_GENERATE_IV;
-
-	spin_lock_irqsave(&priv->sta_lock, flags);
-	priv->stations[sta_id].keyinfo.cipher = keyconf->cipher;
-	priv->stations[sta_id].keyinfo.keylen = keyconf->keylen;
-
-	memcpy(priv->stations[sta_id].keyinfo.key, keyconf->key,
-	       keyconf->keylen);
-
-	memcpy(priv->stations[sta_id].sta.key.key, keyconf->key,
-	       keyconf->keylen);
-
-	if ((priv->stations[sta_id].sta.key.key_flags & STA_KEY_FLG_ENCRYPT_MSK)
-			== STA_KEY_FLG_NO_ENC)
-		priv->stations[sta_id].sta.key.key_offset =
-				 iwl_get_free_ucode_key_index(priv);
-	/* else, we are overriding an existing key => no need to allocated room
-	 * in uCode. */
-
-	WARN(priv->stations[sta_id].sta.key.key_offset == WEP_INVALID_OFFSET,
-		"no space for a new key");
-
-	priv->stations[sta_id].sta.key.key_flags = key_flags;
-	priv->stations[sta_id].sta.sta.modify_mask = STA_MODIFY_KEY_MASK;
-	priv->stations[sta_id].sta.mode = STA_CONTROL_MODIFY_MSK;
-
-	memcpy(&sta_cmd, &priv->stations[sta_id].sta, sizeof(struct iwl_addsta_cmd));
-	spin_unlock_irqrestore(&priv->sta_lock, flags);
-
-	return iwl_send_add_sta(priv, &sta_cmd, CMD_SYNC);
-}
-
-static int iwl_set_tkip_dynamic_key_info(struct iwl_priv *priv,
-					 struct iwl_rxon_context *ctx,
-					 struct ieee80211_key_conf *keyconf,
-					 u8 sta_id)
-{
-	unsigned long flags;
-	int ret = 0;
-	__le16 key_flags = 0;
-
-	key_flags |= (STA_KEY_FLG_TKIP | STA_KEY_FLG_MAP_KEY_MSK);
-	key_flags |= cpu_to_le16(keyconf->keyidx << STA_KEY_FLG_KEYID_POS);
-	key_flags &= ~STA_KEY_FLG_INVALID;
-
-	if (sta_id == ctx->bcast_sta_id)
-		key_flags |= STA_KEY_MULTICAST_MSK;
-
-	keyconf->flags |= IEEE80211_KEY_FLAG_GENERATE_IV;
-	keyconf->flags |= IEEE80211_KEY_FLAG_GENERATE_MMIC;
-
-	spin_lock_irqsave(&priv->sta_lock, flags);
-
-	priv->stations[sta_id].keyinfo.cipher = keyconf->cipher;
-	priv->stations[sta_id].keyinfo.keylen = 16;
-
-	if ((priv->stations[sta_id].sta.key.key_flags & STA_KEY_FLG_ENCRYPT_MSK)
-			== STA_KEY_FLG_NO_ENC)
-		priv->stations[sta_id].sta.key.key_offset =
-				 iwl_get_free_ucode_key_index(priv);
-	/* else, we are overriding an existing key => no need to allocated room
-	 * in uCode. */
-
-	WARN(priv->stations[sta_id].sta.key.key_offset == WEP_INVALID_OFFSET,
-		"no space for a new key");
-
-	priv->stations[sta_id].sta.key.key_flags = key_flags;
-
-
-	/* This copy is acutally not needed: we get the key with each TX */
-	memcpy(priv->stations[sta_id].keyinfo.key, keyconf->key, 16);
-
-	memcpy(priv->stations[sta_id].sta.key.key, keyconf->key, 16);
-
-	spin_unlock_irqrestore(&priv->sta_lock, flags);
-
-	return ret;
-}
-
-void iwl_update_tkip_key(struct iwl_priv *priv,
-			 struct iwl_rxon_context *ctx,
-			 struct ieee80211_key_conf *keyconf,
-			 struct ieee80211_sta *sta, u32 iv32, u16 *phase1key)
+void iwl_dealloc_bcast_stations(struct iwl_priv *priv)
 {
-	u8 sta_id;
 	unsigned long flags;
 	int i;
 
-	if (iwl_scan_cancel(priv)) {
-		/* cancel scan failed, just live w/ bad key and rely
-		   briefly on SW decryption */
-		return;
-	}
-
-	sta_id = iwl_sta_id_or_broadcast(priv, ctx, sta);
-	if (sta_id == IWL_INVALID_STATION)
-		return;
-
-	spin_lock_irqsave(&priv->sta_lock, flags);
-
-	priv->stations[sta_id].sta.key.tkip_rx_tsc_byte2 = (u8) iv32;
-
-	for (i = 0; i < 5; i++)
-		priv->stations[sta_id].sta.key.tkip_rx_ttak[i] =
-			cpu_to_le16(phase1key[i]);
-
-	priv->stations[sta_id].sta.sta.modify_mask = STA_MODIFY_KEY_MASK;
-	priv->stations[sta_id].sta.mode = STA_CONTROL_MODIFY_MSK;
-
-	iwl_send_add_sta(priv, &priv->stations[sta_id].sta, CMD_ASYNC);
-
-	spin_unlock_irqrestore(&priv->sta_lock, flags);
-
-}
-EXPORT_SYMBOL(iwl_update_tkip_key);
-
-int iwl_remove_dynamic_key(struct iwl_priv *priv,
-			   struct iwl_rxon_context *ctx,
-			   struct ieee80211_key_conf *keyconf,
-			   u8 sta_id)
-{
-	unsigned long flags;
-	u16 key_flags;
-	u8 keyidx;
-	struct iwl_addsta_cmd sta_cmd;
-
-	lockdep_assert_held(&priv->mutex);
-
-	ctx->key_mapping_keys--;
-
 	spin_lock_irqsave(&priv->sta_lock, flags);
-	key_flags = le16_to_cpu(priv->stations[sta_id].sta.key.key_flags);
-	keyidx = (key_flags >> STA_KEY_FLG_KEYID_POS) & 0x3;
-
-	IWL_DEBUG_WEP(priv, "Remove dynamic key: idx=%d sta=%d\n",
-		      keyconf->keyidx, sta_id);
-
-	if (keyconf->keyidx != keyidx) {
-		/* We need to remove a key with index different that the one
-		 * in the uCode. This means that the key we need to remove has
-		 * been replaced by another one with different index.
-		 * Don't do anything and return ok
-		 */
-		spin_unlock_irqrestore(&priv->sta_lock, flags);
-		return 0;
-	}
-
-	if (priv->stations[sta_id].sta.key.key_offset == WEP_INVALID_OFFSET) {
-		IWL_WARN(priv, "Removing wrong key %d 0x%x\n",
-			    keyconf->keyidx, key_flags);
-		spin_unlock_irqrestore(&priv->sta_lock, flags);
-		return 0;
-	}
+	for (i = 0; i < priv->hw_params.max_stations; i++) {
+		if (!(priv->stations[i].used & IWL_STA_BCAST))
+			continue;
 
-	if (!test_and_clear_bit(priv->stations[sta_id].sta.key.key_offset,
-		&priv->ucode_key_table))
-		IWL_ERR(priv, "index %d not used in uCode key table.\n",
-			priv->stations[sta_id].sta.key.key_offset);
-	memset(&priv->stations[sta_id].keyinfo, 0,
-					sizeof(struct iwl_hw_key));
-	memset(&priv->stations[sta_id].sta.key, 0,
-					sizeof(struct iwl4965_keyinfo));
-	priv->stations[sta_id].sta.key.key_flags =
-			STA_KEY_FLG_NO_ENC | STA_KEY_FLG_INVALID;
-	priv->stations[sta_id].sta.key.key_offset = WEP_INVALID_OFFSET;
-	priv->stations[sta_id].sta.sta.modify_mask = STA_MODIFY_KEY_MASK;
-	priv->stations[sta_id].sta.mode = STA_CONTROL_MODIFY_MSK;
-
-	if (iwl_is_rfkill(priv)) {
-		IWL_DEBUG_WEP(priv, "Not sending REPLY_ADD_STA command because RFKILL enabled.\n");
-		spin_unlock_irqrestore(&priv->sta_lock, flags);
-		return 0;
+		priv->stations[i].used &= ~IWL_STA_UCODE_ACTIVE;
+		priv->num_stations--;
+		BUG_ON(priv->num_stations < 0);
+		kfree(priv->stations[i].lq);
+		priv->stations[i].lq = NULL;
 	}
-	memcpy(&sta_cmd, &priv->stations[sta_id].sta, sizeof(struct iwl_addsta_cmd));
 	spin_unlock_irqrestore(&priv->sta_lock, flags);
-
-	return iwl_send_add_sta(priv, &sta_cmd, CMD_SYNC);
-}
-EXPORT_SYMBOL(iwl_remove_dynamic_key);
-
-int iwl_set_dynamic_key(struct iwl_priv *priv, struct iwl_rxon_context *ctx,
-			struct ieee80211_key_conf *keyconf, u8 sta_id)
-{
-	int ret;
-
-	lockdep_assert_held(&priv->mutex);
-
-	ctx->key_mapping_keys++;
-	keyconf->hw_key_idx = HW_KEY_DYNAMIC;
-
-	switch (keyconf->cipher) {
-	case WLAN_CIPHER_SUITE_CCMP:
-		ret = iwl_set_ccmp_dynamic_key_info(priv, ctx, keyconf, sta_id);
-		break;
-	case WLAN_CIPHER_SUITE_TKIP:
-		ret = iwl_set_tkip_dynamic_key_info(priv, ctx, keyconf, sta_id);
-		break;
-	case WLAN_CIPHER_SUITE_WEP40:
-	case WLAN_CIPHER_SUITE_WEP104:
-		ret = iwl_set_wep_dynamic_key_info(priv, ctx, keyconf, sta_id);
-		break;
-	default:
-		IWL_ERR(priv,
-			"Unknown alg: %s cipher = %x\n", __func__,
-			keyconf->cipher);
-		ret = -EINVAL;
-	}
-
-	IWL_DEBUG_WEP(priv, "Set dynamic key: cipher=%x len=%d idx=%d sta=%d ret=%d\n",
-		      keyconf->cipher, keyconf->keylen, keyconf->keyidx,
-		      sta_id, ret);
-
-	return ret;
 }
-EXPORT_SYMBOL(iwl_set_dynamic_key);
+EXPORT_SYMBOL_GPL(iwl_dealloc_bcast_stations);
 
 #ifdef CONFIG_IWLWIFI_DEBUG
 static void iwl_dump_lq_cmd(struct iwl_priv *priv,
@@ -1240,223 +758,6 @@ int iwl_send_lq_cmd(struct iwl_priv *priv, struct iwl_rxon_context *ctx,
 }
 EXPORT_SYMBOL(iwl_send_lq_cmd);
 
-/**
- * iwl_alloc_bcast_station - add broadcast station into driver's station table.
- *
- * This adds the broadcast station into the driver's station table
- * and marks it driver active, so that it will be restored to the
- * device at the next best time.
- */
-int iwl_alloc_bcast_station(struct iwl_priv *priv, struct iwl_rxon_context *ctx,
-			    bool init_lq)
-{
-	struct iwl_link_quality_cmd *link_cmd;
-	unsigned long flags;
-	u8 sta_id;
-
-	spin_lock_irqsave(&priv->sta_lock, flags);
-	sta_id = iwl_prep_station(priv, ctx, iwl_bcast_addr, false, NULL);
-	if (sta_id == IWL_INVALID_STATION) {
-		IWL_ERR(priv, "Unable to prepare broadcast station\n");
-		spin_unlock_irqrestore(&priv->sta_lock, flags);
-
-		return -EINVAL;
-	}
-
-	priv->stations[sta_id].used |= IWL_STA_DRIVER_ACTIVE;
-	priv->stations[sta_id].used |= IWL_STA_BCAST;
-	spin_unlock_irqrestore(&priv->sta_lock, flags);
-
-	if (init_lq) {
-		link_cmd = iwl_sta_alloc_lq(priv, sta_id);
-		if (!link_cmd) {
-			IWL_ERR(priv,
-				"Unable to initialize rate scaling for bcast station.\n");
-			return -ENOMEM;
-		}
-
-		spin_lock_irqsave(&priv->sta_lock, flags);
-		priv->stations[sta_id].lq = link_cmd;
-		spin_unlock_irqrestore(&priv->sta_lock, flags);
-	}
-
-	return 0;
-}
-EXPORT_SYMBOL_GPL(iwl_alloc_bcast_station);
-
-/**
- * iwl_update_bcast_station - update broadcast station's LQ command
- *
- * Only used by iwlagn. Placed here to have all bcast station management
- * code together.
- */
-static int iwl_update_bcast_station(struct iwl_priv *priv,
-				    struct iwl_rxon_context *ctx)
-{
-	unsigned long flags;
-	struct iwl_link_quality_cmd *link_cmd;
-	u8 sta_id = ctx->bcast_sta_id;
-
-	link_cmd = iwl_sta_alloc_lq(priv, sta_id);
-	if (!link_cmd) {
-		IWL_ERR(priv, "Unable to initialize rate scaling for bcast station.\n");
-		return -ENOMEM;
-	}
-
-	spin_lock_irqsave(&priv->sta_lock, flags);
-	if (priv->stations[sta_id].lq)
-		kfree(priv->stations[sta_id].lq);
-	else
-		IWL_DEBUG_INFO(priv, "Bcast station rate scaling has not been initialized yet.\n");
-	priv->stations[sta_id].lq = link_cmd;
-	spin_unlock_irqrestore(&priv->sta_lock, flags);
-
-	return 0;
-}
-
-int iwl_update_bcast_stations(struct iwl_priv *priv)
-{
-	struct iwl_rxon_context *ctx;
-	int ret = 0;
-
-	for_each_context(priv, ctx) {
-		ret = iwl_update_bcast_station(priv, ctx);
-		if (ret)
-			break;
-	}
-
-	return ret;
-}
-EXPORT_SYMBOL_GPL(iwl_update_bcast_stations);
-
-void iwl_dealloc_bcast_stations(struct iwl_priv *priv)
-{
-	unsigned long flags;
-	int i;
-
-	spin_lock_irqsave(&priv->sta_lock, flags);
-	for (i = 0; i < priv->hw_params.max_stations; i++) {
-		if (!(priv->stations[i].used & IWL_STA_BCAST))
-			continue;
-
-		priv->stations[i].used &= ~IWL_STA_UCODE_ACTIVE;
-		priv->num_stations--;
-		BUG_ON(priv->num_stations < 0);
-		kfree(priv->stations[i].lq);
-		priv->stations[i].lq = NULL;
-	}
-	spin_unlock_irqrestore(&priv->sta_lock, flags);
-}
-EXPORT_SYMBOL_GPL(iwl_dealloc_bcast_stations);
-
-/**
- * iwl_sta_tx_modify_enable_tid - Enable Tx for this TID in station table
- */
-int iwl_sta_tx_modify_enable_tid(struct iwl_priv *priv, int sta_id, int tid)
-{
-	unsigned long flags;
-	struct iwl_addsta_cmd sta_cmd;
-
-	lockdep_assert_held(&priv->mutex);
-
-	/* Remove "disable" flag, to enable Tx for this TID */
-	spin_lock_irqsave(&priv->sta_lock, flags);
-	priv->stations[sta_id].sta.sta.modify_mask = STA_MODIFY_TID_DISABLE_TX;
-	priv->stations[sta_id].sta.tid_disable_tx &= cpu_to_le16(~(1 << tid));
-	priv->stations[sta_id].sta.mode = STA_CONTROL_MODIFY_MSK;
-	memcpy(&sta_cmd, &priv->stations[sta_id].sta, sizeof(struct iwl_addsta_cmd));
-	spin_unlock_irqrestore(&priv->sta_lock, flags);
-
-	return iwl_send_add_sta(priv, &sta_cmd, CMD_SYNC);
-}
-EXPORT_SYMBOL(iwl_sta_tx_modify_enable_tid);
-
-int iwl_sta_rx_agg_start(struct iwl_priv *priv, struct ieee80211_sta *sta,
-			 int tid, u16 ssn)
-{
-	unsigned long flags;
-	int sta_id;
-	struct iwl_addsta_cmd sta_cmd;
-
-	lockdep_assert_held(&priv->mutex);
-
-	sta_id = iwl_sta_id(sta);
-	if (sta_id == IWL_INVALID_STATION)
-		return -ENXIO;
-
-	spin_lock_irqsave(&priv->sta_lock, flags);
-	priv->stations[sta_id].sta.station_flags_msk = 0;
-	priv->stations[sta_id].sta.sta.modify_mask = STA_MODIFY_ADDBA_TID_MSK;
-	priv->stations[sta_id].sta.add_immediate_ba_tid = (u8)tid;
-	priv->stations[sta_id].sta.add_immediate_ba_ssn = cpu_to_le16(ssn);
-	priv->stations[sta_id].sta.mode = STA_CONTROL_MODIFY_MSK;
-	memcpy(&sta_cmd, &priv->stations[sta_id].sta, sizeof(struct iwl_addsta_cmd));
-	spin_unlock_irqrestore(&priv->sta_lock, flags);
-
-	return iwl_send_add_sta(priv, &sta_cmd, CMD_SYNC);
-}
-EXPORT_SYMBOL(iwl_sta_rx_agg_start);
-
-int iwl_sta_rx_agg_stop(struct iwl_priv *priv, struct ieee80211_sta *sta,
-			int tid)
-{
-	unsigned long flags;
-	int sta_id;
-	struct iwl_addsta_cmd sta_cmd;
-
-	lockdep_assert_held(&priv->mutex);
-
-	sta_id = iwl_sta_id(sta);
-	if (sta_id == IWL_INVALID_STATION) {
-		IWL_ERR(priv, "Invalid station for AGG tid %d\n", tid);
-		return -ENXIO;
-	}
-
-	spin_lock_irqsave(&priv->sta_lock, flags);
-	priv->stations[sta_id].sta.station_flags_msk = 0;
-	priv->stations[sta_id].sta.sta.modify_mask = STA_MODIFY_DELBA_TID_MSK;
-	priv->stations[sta_id].sta.remove_immediate_ba_tid = (u8)tid;
-	priv->stations[sta_id].sta.mode = STA_CONTROL_MODIFY_MSK;
-	memcpy(&sta_cmd, &priv->stations[sta_id].sta, sizeof(struct iwl_addsta_cmd));
-	spin_unlock_irqrestore(&priv->sta_lock, flags);
-
-	return iwl_send_add_sta(priv, &sta_cmd, CMD_SYNC);
-}
-EXPORT_SYMBOL(iwl_sta_rx_agg_stop);
-
-void iwl_sta_modify_ps_wake(struct iwl_priv *priv, int sta_id)
-{
-	unsigned long flags;
-
-	spin_lock_irqsave(&priv->sta_lock, flags);
-	priv->stations[sta_id].sta.station_flags &= ~STA_FLG_PWR_SAVE_MSK;
-	priv->stations[sta_id].sta.station_flags_msk = STA_FLG_PWR_SAVE_MSK;
-	priv->stations[sta_id].sta.sta.modify_mask = 0;
-	priv->stations[sta_id].sta.sleep_tx_count = 0;
-	priv->stations[sta_id].sta.mode = STA_CONTROL_MODIFY_MSK;
-	iwl_send_add_sta(priv, &priv->stations[sta_id].sta, CMD_ASYNC);
-	spin_unlock_irqrestore(&priv->sta_lock, flags);
-
-}
-EXPORT_SYMBOL(iwl_sta_modify_ps_wake);
-
-void iwl_sta_modify_sleep_tx_count(struct iwl_priv *priv, int sta_id, int cnt)
-{
-	unsigned long flags;
-
-	spin_lock_irqsave(&priv->sta_lock, flags);
-	priv->stations[sta_id].sta.station_flags |= STA_FLG_PWR_SAVE_MSK;
-	priv->stations[sta_id].sta.station_flags_msk = STA_FLG_PWR_SAVE_MSK;
-	priv->stations[sta_id].sta.sta.modify_mask =
-					STA_MODIFY_SLEEP_TX_COUNT_MSK;
-	priv->stations[sta_id].sta.sleep_tx_count = cpu_to_le16(cnt);
-	priv->stations[sta_id].sta.mode = STA_CONTROL_MODIFY_MSK;
-	iwl_send_add_sta(priv, &priv->stations[sta_id].sta, CMD_ASYNC);
-	spin_unlock_irqrestore(&priv->sta_lock, flags);
-
-}
-EXPORT_SYMBOL(iwl_sta_modify_sleep_tx_count);
-
 int iwl_mac_sta_remove(struct ieee80211_hw *hw,
 		       struct ieee80211_vif *vif,
 		       struct ieee80211_sta *sta)
diff --git a/drivers/net/wireless/iwlwifi/iwl-sta.h b/drivers/net/wireless/iwlwifi/iwl-sta.h
index 56bad3f..0647587 100644
--- a/drivers/net/wireless/iwlwifi/iwl-sta.h
+++ b/drivers/net/wireless/iwlwifi/iwl-sta.h
@@ -43,35 +43,13 @@
 #define IWL_STA_BCAST BIT(4) /* this station is the special bcast station */
 
 
-int iwl_remove_default_wep_key(struct iwl_priv *priv,
-			       struct iwl_rxon_context *ctx,
-			       struct ieee80211_key_conf *key);
-int iwl_set_default_wep_key(struct iwl_priv *priv,
-			    struct iwl_rxon_context *ctx,
-			    struct ieee80211_key_conf *key);
-int iwl_restore_default_wep_keys(struct iwl_priv *priv,
-				 struct iwl_rxon_context *ctx);
-int iwl_set_dynamic_key(struct iwl_priv *priv, struct iwl_rxon_context *ctx,
-			struct ieee80211_key_conf *key, u8 sta_id);
-int iwl_remove_dynamic_key(struct iwl_priv *priv, struct iwl_rxon_context *ctx,
-			   struct ieee80211_key_conf *key, u8 sta_id);
-void iwl_update_tkip_key(struct iwl_priv *priv,
-			 struct iwl_rxon_context *ctx,
-			 struct ieee80211_key_conf *keyconf,
-			 struct ieee80211_sta *sta, u32 iv32, u16 *phase1key);
-
 void iwl_restore_stations(struct iwl_priv *priv, struct iwl_rxon_context *ctx);
 void iwl_clear_ucode_stations(struct iwl_priv *priv,
 			      struct iwl_rxon_context *ctx);
-int iwl_alloc_bcast_station(struct iwl_priv *priv, struct iwl_rxon_context *ctx,
-			    bool init_lq);
 void iwl_dealloc_bcast_stations(struct iwl_priv *priv);
-int iwl_update_bcast_stations(struct iwl_priv *priv);
 int iwl_get_free_ucode_key_index(struct iwl_priv *priv);
 int iwl_send_add_sta(struct iwl_priv *priv,
 		     struct iwl_addsta_cmd *sta, u8 flags);
-int iwl_add_bssid_station(struct iwl_priv *priv, struct iwl_rxon_context *ctx,
-			  const u8 *addr, bool init_rs, u8 *sta_id_r);
 int iwl_add_station_common(struct iwl_priv *priv, struct iwl_rxon_context *ctx,
 			   const u8 *addr, bool is_ap,
 			   struct ieee80211_sta *sta, u8 *sta_id_r);
@@ -79,13 +57,12 @@ int iwl_remove_station(struct iwl_priv *priv, const u8 sta_id,
 		       const u8 *addr);
 int iwl_mac_sta_remove(struct ieee80211_hw *hw, struct ieee80211_vif *vif,
 		       struct ieee80211_sta *sta);
-int iwl_sta_tx_modify_enable_tid(struct iwl_priv *priv, int sta_id, int tid);
-int iwl_sta_rx_agg_start(struct iwl_priv *priv, struct ieee80211_sta *sta,
-			 int tid, u16 ssn);
-int iwl_sta_rx_agg_stop(struct iwl_priv *priv, struct ieee80211_sta *sta,
-			int tid);
-void iwl_sta_modify_ps_wake(struct iwl_priv *priv, int sta_id);
-void iwl_sta_modify_sleep_tx_count(struct iwl_priv *priv, int sta_id, int cnt);
+
+u8 iwl_prep_station(struct iwl_priv *priv, struct iwl_rxon_context *ctx,
+		    const u8 *addr, bool is_ap, struct ieee80211_sta *sta);
+
+int iwl_send_lq_cmd(struct iwl_priv *priv, struct iwl_rxon_context *ctx,
+		    struct iwl_link_quality_cmd *lq, u8 flags, bool init);
 
 /**
  * iwl_clear_driver_stations - clear knowledge of all stations from driver
diff --git a/drivers/net/wireless/iwlwifi/iwl3945-base.c b/drivers/net/wireless/iwlwifi/iwl3945-base.c
index 64eb049..c06b218 100644
--- a/drivers/net/wireless/iwlwifi/iwl3945-base.c
+++ b/drivers/net/wireless/iwlwifi/iwl3945-base.c
@@ -2661,12 +2661,33 @@ static void iwl3945_down(struct iwl_priv *priv)
 
 #define MAX_HW_RESTARTS 5
 
+static int iwl3945_alloc_bcast_station(struct iwl_priv *priv)
+{
+	struct iwl_rxon_context *ctx = &priv->contexts[IWL_RXON_CTX_BSS];
+	unsigned long flags;
+	u8 sta_id;
+
+	spin_lock_irqsave(&priv->sta_lock, flags);
+	sta_id = iwl_prep_station(priv, ctx, iwl_bcast_addr, false, NULL);
+	if (sta_id == IWL_INVALID_STATION) {
+		IWL_ERR(priv, "Unable to prepare broadcast station\n");
+		spin_unlock_irqrestore(&priv->sta_lock, flags);
+
+		return -EINVAL;
+	}
+
+	priv->stations[sta_id].used |= IWL_STA_DRIVER_ACTIVE;
+	priv->stations[sta_id].used |= IWL_STA_BCAST;
+	spin_unlock_irqrestore(&priv->sta_lock, flags);
+
+	return 0;
+}
+
 static int __iwl3945_up(struct iwl_priv *priv)
 {
 	int rc, i;
 
-	rc = iwl_alloc_bcast_station(priv, &priv->contexts[IWL_RXON_CTX_BSS],
-				     false);
+	rc = iwl3945_alloc_bcast_station(priv);
 	if (rc)
 		return rc;
 
-- 
1.7.0.4

