Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:59935 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S936729Ab3DJMnu (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 10 Apr 2013 08:43:50 -0400
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Cc: Johannes Berg <johannes.berg@intel.com>
Subject: [PATCH 5/8] mac80211: support secondary channel offset in CSA
Date: Wed, 10 Apr 2013 14:43:39 +0200
Message-Id: <1365597822-27660-6-git-send-email-johannes@sipsolutions.net> (sfid-20130410_144402_075980_C3A9F86F)
In-Reply-To: <1365597822-27660-1-git-send-email-johannes@sipsolutions.net>
References: <1365597822-27660-1-git-send-email-johannes@sipsolutions.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

Add support for the secondary channel offset IE in channel
switch announcements. This is necessary for proper handling
of CSA on HT access points.

For this to work it is also necessary to convert everything
here to use chandef structs instead of just channels. The
driver updates aren't really correct though. In particular,
the TI wl18xx driver update can't possibly be right since
it just ignores the new channel width for lack of firmware
API.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 drivers/net/wireless/iwlegacy/4965-mac.c    | 32 ++++++-------
 drivers/net/wireless/iwlegacy/4965.c        |  2 +-
 drivers/net/wireless/iwlwifi/dvm/devices.c  | 10 ++--
 drivers/net/wireless/iwlwifi/dvm/mac80211.c | 20 ++++++--
 drivers/net/wireless/iwlwifi/dvm/rxon.c     |  2 +-
 drivers/net/wireless/ti/wl12xx/cmd.c        |  2 +-
 drivers/net/wireless/ti/wl18xx/cmd.c        |  6 +--
 include/linux/ieee80211.h                   | 11 +++++
 include/net/mac80211.h                      |  4 +-
 net/mac80211/ieee80211_i.h                  |  3 +-
 net/mac80211/mlme.c                         | 71 +++++++++++++++++++++++------
 net/mac80211/trace.h                        |  8 ++--
 net/mac80211/util.c                         |  8 ++++
 13 files changed, 125 insertions(+), 54 deletions(-)

diff --git a/drivers/net/wireless/iwlegacy/4965-mac.c b/drivers/net/wireless/iwlegacy/4965-mac.c
index c092fcb..cb5882e 100644
--- a/drivers/net/wireless/iwlegacy/4965-mac.c
+++ b/drivers/net/wireless/iwlegacy/4965-mac.c
@@ -6057,7 +6057,7 @@ il4965_mac_channel_switch(struct ieee80211_hw *hw,
 	struct il_priv *il = hw->priv;
 	const struct il_channel_info *ch_info;
 	struct ieee80211_conf *conf = &hw->conf;
-	struct ieee80211_channel *channel = ch_switch->channel;
+	struct ieee80211_channel *channel = ch_switch->chandef.chan;
 	struct il_ht_config *ht_conf = &il->current_ht_config;
 	u16 ch;
 
@@ -6094,23 +6094,21 @@ il4965_mac_channel_switch(struct ieee80211_hw *hw,
 	il->current_ht_config.smps = conf->smps_mode;
 
 	/* Configure HT40 channels */
-	il->ht.enabled = conf_is_ht(conf);
-	if (il->ht.enabled) {
-		if (conf_is_ht40_minus(conf)) {
-			il->ht.extension_chan_offset =
-			    IEEE80211_HT_PARAM_CHA_SEC_BELOW;
-			il->ht.is_40mhz = true;
-		} else if (conf_is_ht40_plus(conf)) {
-			il->ht.extension_chan_offset =
-			    IEEE80211_HT_PARAM_CHA_SEC_ABOVE;
-			il->ht.is_40mhz = true;
-		} else {
-			il->ht.extension_chan_offset =
-			    IEEE80211_HT_PARAM_CHA_SEC_NONE;
-			il->ht.is_40mhz = false;
-		}
-	} else
+	switch (cfg80211_get_chandef_type(&ch_switch->chandef)) {
+	case NL80211_CHAN_NO_HT:
+	case NL80211_CHAN_HT20:
 		il->ht.is_40mhz = false;
+		il->ht.extension_chan_offset = IEEE80211_HT_PARAM_CHA_SEC_NONE;
+		break;
+	case NL80211_CHAN_HT40MINUS:
+		il->ht.extension_chan_offset = IEEE80211_HT_PARAM_CHA_SEC_BELOW;
+		il->ht.is_40mhz = true;
+		break;
+	case NL80211_CHAN_HT40PLUS:
+		il->ht.extension_chan_offset = IEEE80211_HT_PARAM_CHA_SEC_ABOVE;
+		il->ht.is_40mhz = true;
+		break;
+	}
 
 	if ((le16_to_cpu(il->staging.channel) != ch))
 		il->staging.flags = 0;
diff --git a/drivers/net/wireless/iwlegacy/4965.c b/drivers/net/wireless/iwlegacy/4965.c
index 91eb2d0..777a578 100644
--- a/drivers/net/wireless/iwlegacy/4965.c
+++ b/drivers/net/wireless/iwlegacy/4965.c
@@ -1493,7 +1493,7 @@ il4965_hw_channel_switch(struct il_priv *il,
 
 	cmd.band = band;
 	cmd.expect_beacon = 0;
-	ch = ch_switch->channel->hw_value;
+	ch = ch_switch->chandef.chan->hw_value;
 	cmd.channel = cpu_to_le16(ch);
 	cmd.rxon_flags = il->staging.flags;
 	cmd.rxon_filter_flags = il->staging.filter_flags;
diff --git a/drivers/net/wireless/iwlwifi/dvm/devices.c b/drivers/net/wireless/iwlwifi/dvm/devices.c
index 15cca2e..c48907c 100644
--- a/drivers/net/wireless/iwlwifi/dvm/devices.c
+++ b/drivers/net/wireless/iwlwifi/dvm/devices.c
@@ -379,7 +379,7 @@ static int iwl5000_hw_channel_switch(struct iwl_priv *priv,
 	};
 
 	cmd.band = priv->band == IEEE80211_BAND_2GHZ;
-	ch = ch_switch->channel->hw_value;
+	ch = ch_switch->chandef.chan->hw_value;
 	IWL_DEBUG_11H(priv, "channel switch from %d to %d\n",
 		      ctx->active.channel, ch);
 	cmd.channel = cpu_to_le16(ch);
@@ -414,7 +414,8 @@ static int iwl5000_hw_channel_switch(struct iwl_priv *priv,
 	}
 	IWL_DEBUG_11H(priv, "uCode time for the switch is 0x%x\n",
 		      cmd.switch_time);
-	cmd.expect_beacon = ch_switch->channel->flags & IEEE80211_CHAN_RADAR;
+	cmd.expect_beacon =
+		ch_switch->chandef.chan->flags & IEEE80211_CHAN_RADAR;
 
 	return iwl_dvm_send_cmd(priv, &hcmd);
 }
@@ -540,7 +541,7 @@ static int iwl6000_hw_channel_switch(struct iwl_priv *priv,
 	hcmd.data[0] = cmd;
 
 	cmd->band = priv->band == IEEE80211_BAND_2GHZ;
-	ch = ch_switch->channel->hw_value;
+	ch = ch_switch->chandef.chan->hw_value;
 	IWL_DEBUG_11H(priv, "channel switch from %u to %u\n",
 		      ctx->active.channel, ch);
 	cmd->channel = cpu_to_le16(ch);
@@ -575,7 +576,8 @@ static int iwl6000_hw_channel_switch(struct iwl_priv *priv,
 	}
 	IWL_DEBUG_11H(priv, "uCode time for the switch is 0x%x\n",
 		      cmd->switch_time);
-	cmd->expect_beacon = ch_switch->channel->flags & IEEE80211_CHAN_RADAR;
+	cmd->expect_beacon =
+		ch_switch->chandef.chan->flags & IEEE80211_CHAN_RADAR;
 
 	err = iwl_dvm_send_cmd(priv, &hcmd);
 	kfree(cmd);
diff --git a/drivers/net/wireless/iwlwifi/dvm/mac80211.c b/drivers/net/wireless/iwlwifi/dvm/mac80211.c
index a7294fa..2dc101f 100644
--- a/drivers/net/wireless/iwlwifi/dvm/mac80211.c
+++ b/drivers/net/wireless/iwlwifi/dvm/mac80211.c
@@ -967,7 +967,7 @@ static void iwlagn_mac_channel_switch(struct ieee80211_hw *hw,
 {
 	struct iwl_priv *priv = IWL_MAC80211_GET_DVM(hw);
 	struct ieee80211_conf *conf = &hw->conf;
-	struct ieee80211_channel *channel = ch_switch->channel;
+	struct ieee80211_channel *channel = ch_switch->chandef.chan;
 	struct iwl_ht_config *ht_conf = &priv->current_ht_config;
 	/*
 	 * MULTI-FIXME
@@ -1005,11 +1005,21 @@ static void iwlagn_mac_channel_switch(struct ieee80211_hw *hw,
 	priv->current_ht_config.smps = conf->smps_mode;
 
 	/* Configure HT40 channels */
-	ctx->ht.enabled = conf_is_ht(conf);
-	if (ctx->ht.enabled)
-		iwlagn_config_ht40(conf, ctx);
-	else
+	switch (cfg80211_get_chandef_type(&ch_switch->chandef)) {
+	case NL80211_CHAN_NO_HT:
+	case NL80211_CHAN_HT20:
 		ctx->ht.is_40mhz = false;
+		ctx->ht.extension_chan_offset = IEEE80211_HT_PARAM_CHA_SEC_NONE;
+		break;
+	case NL80211_CHAN_HT40MINUS:
+		ctx->ht.extension_chan_offset = IEEE80211_HT_PARAM_CHA_SEC_BELOW;
+		ctx->ht.is_40mhz = true;
+		break;
+	case NL80211_CHAN_HT40PLUS:
+		ctx->ht.extension_chan_offset = IEEE80211_HT_PARAM_CHA_SEC_ABOVE;
+		ctx->ht.is_40mhz = true;
+		break;
+	}
 
 	if ((le16_to_cpu(ctx->staging.channel) != ch))
 		ctx->staging.flags = 0;
diff --git a/drivers/net/wireless/iwlwifi/dvm/rxon.c b/drivers/net/wireless/iwlwifi/dvm/rxon.c
index 085c589..acbb50b 100644
--- a/drivers/net/wireless/iwlwifi/dvm/rxon.c
+++ b/drivers/net/wireless/iwlwifi/dvm/rxon.c
@@ -1160,7 +1160,7 @@ int iwlagn_commit_rxon(struct iwl_priv *priv, struct iwl_rxon_context *ctx)
 }
 
 void iwlagn_config_ht40(struct ieee80211_conf *conf,
-	struct iwl_rxon_context *ctx)
+			struct iwl_rxon_context *ctx)
 {
 	if (conf_is_ht40_minus(conf)) {
 		ctx->ht.extension_chan_offset =
diff --git a/drivers/net/wireless/ti/wl12xx/cmd.c b/drivers/net/wireless/ti/wl12xx/cmd.c
index 7dc9f96..7485dba 100644
--- a/drivers/net/wireless/ti/wl12xx/cmd.c
+++ b/drivers/net/wireless/ti/wl12xx/cmd.c
@@ -301,7 +301,7 @@ int wl12xx_cmd_channel_switch(struct wl1271 *wl,
 	}
 
 	cmd->role_id = wlvif->role_id;
-	cmd->channel = ch_switch->channel->hw_value;
+	cmd->channel = ch_switch->chandef.chan->hw_value;
 	cmd->switch_time = ch_switch->count;
 	cmd->stop_tx = ch_switch->block_tx;
 
diff --git a/drivers/net/wireless/ti/wl18xx/cmd.c b/drivers/net/wireless/ti/wl18xx/cmd.c
index 1d1f6cc..7649c75 100644
--- a/drivers/net/wireless/ti/wl18xx/cmd.c
+++ b/drivers/net/wireless/ti/wl18xx/cmd.c
@@ -42,11 +42,11 @@ int wl18xx_cmd_channel_switch(struct wl1271 *wl,
 	}
 
 	cmd->role_id = wlvif->role_id;
-	cmd->channel = ch_switch->channel->hw_value;
+	cmd->channel = ch_switch->chandef.chan->hw_value;
 	cmd->switch_time = ch_switch->count;
 	cmd->stop_tx = ch_switch->block_tx;
 
-	switch (ch_switch->channel->band) {
+	switch (ch_switch->chandef.chan->band) {
 	case IEEE80211_BAND_2GHZ:
 		cmd->band = WLCORE_BAND_2_4GHZ;
 		break;
@@ -55,7 +55,7 @@ int wl18xx_cmd_channel_switch(struct wl1271 *wl,
 		break;
 	default:
 		wl1271_error("invalid channel switch band: %d",
-			     ch_switch->channel->band);
+			     ch_switch->chandef.chan->band);
 		ret = -EINVAL;
 		goto out_free;
 	}
diff --git a/include/linux/ieee80211.h b/include/linux/ieee80211.h
index 2a10acc..9562152 100644
--- a/include/linux/ieee80211.h
+++ b/include/linux/ieee80211.h
@@ -685,6 +685,16 @@ struct ieee80211_ext_chansw_ie {
 } __packed;
 
 /**
+ * struct ieee80211_sec_chan_offs_ie - secondary channel offset IE
+ * @sec_chan_offs: secondary channel offset, uses IEEE80211_HT_PARAM_CHA_SEC_*
+ *	values here
+ * This structure represents the "Secondary Channel Offset element"
+ */
+struct ieee80211_sec_chan_offs_ie {
+	u8 sec_chan_offs;
+} __packed;
+
+/**
  * struct ieee80211_tim
  *
  * This structure refers to "Traffic Indication Map information element"
@@ -1648,6 +1658,7 @@ enum ieee80211_eid {
 
 	WLAN_EID_HT_CAPABILITY = 45,
 	WLAN_EID_HT_OPERATION = 61,
+	WLAN_EID_SECONDARY_CHANNEL_OFFSET = 62,
 
 	WLAN_EID_RSN = 48,
 	WLAN_EID_MMIE = 76,
diff --git a/include/net/mac80211.h b/include/net/mac80211.h
index 64faf01..70b0e56 100644
--- a/include/net/mac80211.h
+++ b/include/net/mac80211.h
@@ -1017,13 +1017,13 @@ struct ieee80211_conf {
  *	the driver passed into mac80211.
  * @block_tx: Indicates whether transmission must be blocked before the
  *	scheduled channel switch, as indicated by the AP.
- * @channel: the new channel to switch to
+ * @chandef: the new channel to switch to
  * @count: the number of TBTT's until the channel switch event
  */
 struct ieee80211_channel_switch {
 	u64 timestamp;
 	bool block_tx;
-	struct ieee80211_channel *channel;
+	struct cfg80211_chan_def chandef;
 	u8 count;
 };
 
diff --git a/net/mac80211/ieee80211_i.h b/net/mac80211/ieee80211_i.h
index 10c3180..8f240c0 100644
--- a/net/mac80211/ieee80211_i.h
+++ b/net/mac80211/ieee80211_i.h
@@ -1019,7 +1019,7 @@ struct ieee80211_local {
 	enum mac80211_scan_state next_scan_state;
 	struct delayed_work scan_work;
 	struct ieee80211_sub_if_data __rcu *scan_sdata;
-	struct ieee80211_channel *csa_channel;
+	struct cfg80211_chan_def csa_chandef;
 	/* For backward compatibility only -- do not use */
 	struct cfg80211_chan_def _oper_chandef;
 
@@ -1183,6 +1183,7 @@ struct ieee802_11_elems {
 	const u8 *pwr_constr_elem;
 	const struct ieee80211_timeout_interval_ie *timeout_int;
 	const u8 *opmode_notif;
+	const struct ieee80211_sec_chan_offs_ie *sec_chan_offs;
 
 	/* length of them, respectively */
 	u8 ssid_len;
diff --git a/net/mac80211/mlme.c b/net/mac80211/mlme.c
index e7b82f9..b0586e4 100644
--- a/net/mac80211/mlme.c
+++ b/net/mac80211/mlme.c
@@ -289,6 +289,8 @@ ieee80211_determine_chantype(struct ieee80211_sub_if_data *sdata,
 	} else {
 		/* 40 MHz (and 80 MHz) must be supported for VHT */
 		ret = IEEE80211_STA_DISABLE_VHT;
+		/* also mark 40 MHz disabled */
+		ret |= IEEE80211_STA_DISABLE_40MHZ;
 		goto out;
 	}
 
@@ -965,16 +967,7 @@ static void ieee80211_chswitch_work(struct work_struct *work)
 	if (!ifmgd->associated)
 		goto out;
 
-	/*
-	 * FIXME: Here we are downgrading to NL80211_CHAN_WIDTH_20_NOHT
-	 * and don't adjust our ht/vht settings
-	 * This is wrong - we should behave according to the CSA params
-	 */
-	local->_oper_chandef.chan = local->csa_channel;
-	local->_oper_chandef.width = NL80211_CHAN_WIDTH_20_NOHT;
-	local->_oper_chandef.center_freq1 =
-		local->_oper_chandef.chan->center_freq;
-	local->_oper_chandef.center_freq2 = 0;
+	local->_oper_chandef = local->csa_chandef;
 
 	if (!local->ops->channel_switch) {
 		/* call "hw_config" only if doing sw channel switch */
@@ -1029,13 +1022,14 @@ ieee80211_sta_process_chanswitch(struct ieee80211_sub_if_data *sdata,
 	struct ieee80211_if_managed *ifmgd = &sdata->u.mgd;
 	struct cfg80211_bss *cbss = ifmgd->associated;
 	struct ieee80211_bss *bss;
-	struct ieee80211_channel *new_ch;
 	struct ieee80211_chanctx *chanctx;
 	enum ieee80211_band new_band;
 	int new_freq;
 	u8 new_chan_no;
 	u8 count;
 	u8 mode;
+	struct cfg80211_chan_def new_chandef = {};
+	int secondary_channel_offset = -1;
 
 	ASSERT_MGD_MTX(ifmgd);
 
@@ -1049,6 +1043,19 @@ ieee80211_sta_process_chanswitch(struct ieee80211_sub_if_data *sdata,
 	if (ifmgd->flags & IEEE80211_STA_CSA_RECEIVED)
 		return;
 
+	if (!(ifmgd->flags & IEEE80211_STA_DISABLE_HT)) {
+		/* if HT is enabled and the IE not present, it's still HT */
+		secondary_channel_offset = IEEE80211_HT_PARAM_CHA_SEC_NONE;
+		if (elems->sec_chan_offs)
+			secondary_channel_offset =
+				elems->sec_chan_offs->sec_chan_offs;
+	}
+
+	if (ifmgd->flags & IEEE80211_STA_DISABLE_40MHZ &&
+	    (secondary_channel_offset == IEEE80211_HT_PARAM_CHA_SEC_ABOVE ||
+	     secondary_channel_offset == IEEE80211_HT_PARAM_CHA_SEC_BELOW))
+		secondary_channel_offset = IEEE80211_HT_PARAM_CHA_SEC_NONE;
+
 	if (elems->ext_chansw_ie) {
 		if (!ieee80211_operating_class_to_band(
 				elems->ext_chansw_ie->new_operating_class,
@@ -1075,8 +1082,9 @@ ieee80211_sta_process_chanswitch(struct ieee80211_sub_if_data *sdata,
 	bss = (void *)cbss->priv;
 
 	new_freq = ieee80211_channel_to_frequency(new_chan_no, new_band);
-	new_ch = ieee80211_get_channel(local->hw.wiphy, new_freq);
-	if (!new_ch || new_ch->flags & IEEE80211_CHAN_DISABLED) {
+	new_chandef.chan = ieee80211_get_channel(sdata->local->hw.wiphy, new_freq);
+	if (!new_chandef.chan ||
+	    new_chandef.chan->flags & IEEE80211_CHAN_DISABLED) {
 		sdata_info(sdata,
 			   "AP %pM switches to unsupported channel (%d MHz), disconnecting\n",
 			   ifmgd->associated->bssid, new_freq);
@@ -1085,6 +1093,39 @@ ieee80211_sta_process_chanswitch(struct ieee80211_sub_if_data *sdata,
 		return;
 	}
 
+	switch (secondary_channel_offset) {
+	default:
+		/* secondary_channel_offset was present but is invalid */
+	case IEEE80211_HT_PARAM_CHA_SEC_NONE:
+		cfg80211_chandef_create(&new_chandef, new_chandef.chan,
+					NL80211_CHAN_HT20);
+		break;
+	case IEEE80211_HT_PARAM_CHA_SEC_ABOVE:
+		cfg80211_chandef_create(&new_chandef, new_chandef.chan,
+					NL80211_CHAN_HT40PLUS);
+		break;
+	case IEEE80211_HT_PARAM_CHA_SEC_BELOW:
+		cfg80211_chandef_create(&new_chandef, new_chandef.chan,
+					NL80211_CHAN_HT40MINUS);
+		break;
+	case -1:
+		cfg80211_chandef_create(&new_chandef, new_chandef.chan,
+					NL80211_CHAN_NO_HT);
+		break;
+	}
+
+	if (!cfg80211_chandef_usable(local->hw.wiphy, &new_chandef,
+				     IEEE80211_CHAN_DISABLED)) {
+		sdata_info(sdata,
+			   "AP %pM switches to unsupported channel (%d MHz, width:%d, CF1/2: %d/%d MHz), disconnecting\n",
+			   ifmgd->associated->bssid, new_freq,
+			   new_chandef.width, new_chandef.center_freq1,
+			   new_chandef.center_freq2);
+		ieee80211_queue_work(&local->hw,
+				     &ifmgd->csa_connection_drop_work);
+		return;
+	}
+
 	ifmgd->flags |= IEEE80211_STA_CSA_RECEIVED;
 
 	if (local->use_chanctx) {
@@ -1112,7 +1153,7 @@ ieee80211_sta_process_chanswitch(struct ieee80211_sub_if_data *sdata,
 	}
 	mutex_unlock(&local->chanctx_mtx);
 
-	local->csa_channel = new_ch;
+	local->csa_chandef = new_chandef;
 
 	if (mode)
 		ieee80211_stop_queues_by_reason(&local->hw,
@@ -1124,7 +1165,7 @@ ieee80211_sta_process_chanswitch(struct ieee80211_sub_if_data *sdata,
 		struct ieee80211_channel_switch ch_switch = {
 			.timestamp = timestamp,
 			.block_tx = mode,
-			.channel = new_ch,
+			.chandef = new_chandef,
 			.count = count,
 		};
 
diff --git a/net/mac80211/trace.h b/net/mac80211/trace.h
index 8286dce..c215fafd7 100644
--- a/net/mac80211/trace.h
+++ b/net/mac80211/trace.h
@@ -990,23 +990,23 @@ TRACE_EVENT(drv_channel_switch,
 
 	TP_STRUCT__entry(
 		LOCAL_ENTRY
+		CHANDEF_ENTRY
 		__field(u64, timestamp)
 		__field(bool, block_tx)
-		__field(u16, freq)
 		__field(u8, count)
 	),
 
 	TP_fast_assign(
 		LOCAL_ASSIGN;
+		CHANDEF_ASSIGN(&ch_switch->chandef)
 		__entry->timestamp = ch_switch->timestamp;
 		__entry->block_tx = ch_switch->block_tx;
-		__entry->freq = ch_switch->channel->center_freq;
 		__entry->count = ch_switch->count;
 	),
 
 	TP_printk(
-		LOCAL_PR_FMT " new freq:%u count:%d",
-		LOCAL_PR_ARG, __entry->freq, __entry->count
+		LOCAL_PR_FMT " new " CHANDEF_PR_FMT " count:%d",
+		LOCAL_PR_ARG, CHANDEF_PR_ARG, __entry->count
 	)
 );
 
diff --git a/net/mac80211/util.c b/net/mac80211/util.c
index 7b0f2c7..6ded61a 100644
--- a/net/mac80211/util.c
+++ b/net/mac80211/util.c
@@ -715,6 +715,7 @@ u32 ieee802_11_parse_elems_crc(u8 *start, size_t len,
 		case WLAN_EID_COUNTRY:
 		case WLAN_EID_PWR_CONSTRAINT:
 		case WLAN_EID_TIMEOUT_INTERVAL:
+		case WLAN_EID_SECONDARY_CHANNEL_OFFSET:
 			if (test_bit(id, seen_elems)) {
 				elems->parse_error = true;
 				left -= elen;
@@ -869,6 +870,13 @@ u32 ieee802_11_parse_elems_crc(u8 *start, size_t len,
 			}
 			elems->ext_chansw_ie = (void *)pos;
 			break;
+		case WLAN_EID_SECONDARY_CHANNEL_OFFSET:
+			if (elen != sizeof(struct ieee80211_sec_chan_offs_ie)) {
+				elem_parse_failed = true;
+				break;
+			}
+			elems->sec_chan_offs = (void *)pos;
+			break;
 		case WLAN_EID_COUNTRY:
 			elems->country_elem = pos;
 			elems->country_elem_len = elen;
-- 
1.8.0

