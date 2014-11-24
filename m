Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wg0-f50.google.com ([74.125.82.50]:62972 "EHLO
	mail-wg0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752635AbaKXOgR (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 24 Nov 2014 09:36:17 -0500
Received: by mail-wg0-f50.google.com with SMTP id k14so12497161wgh.9
        for <linux-wireless@vger.kernel.org>; Mon, 24 Nov 2014 06:36:16 -0800 (PST)
From: Emmanuel Grumbach <egrumbach@gmail.com>
To: linux-wireless@vger.kernel.org
Cc: Arik Nemtsov <arik@wizery.com>,
	Arik Nemtsov <arikx.nemtsov@intel.com>,
	Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Subject: [PATCH 48/75] iwlwifi: mvm: implement mac80211 TDLS channel-switch APIs
Date: Mon, 24 Nov 2014 16:34:24 +0200
Message-Id: <1416839691-28533-48-git-send-email-egrumbach@gmail.com> (sfid-20141124_153625_994480_B94F6A61)
In-Reply-To: <CANUX_P32q7EFvuOvm+c=yYP9okVEfSUvdDg0gDHHCSg2G+gA0g@mail.gmail.com>
References: <CANUX_P32q7EFvuOvm+c=yYP9okVEfSUvdDg0gDHHCSg2G+gA0g@mail.gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Arik Nemtsov <arik@wizery.com>

Maintain a TDLS channel-switch state and update it according to
notifications from FW and timeouts. Explicitly check all state
transitions are valid.
When switching is initiated by mac80211, use a delayed work to
periodically reschedule it from iwlwifi.
Give the FW mac80211 generated TDLS channel-switch request/response
templates. It will change appropriate values (switch timings) and Tx
them at appropriate times.

Enable the channel switch wiphy capability bit when the FW supports it.

Signed-off-by: Arik Nemtsov <arikx.nemtsov@intel.com>
Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
---
 drivers/net/wireless/iwlwifi/mvm/fw.c       |   2 +
 drivers/net/wireless/iwlwifi/mvm/mac80211.c |  10 +
 drivers/net/wireless/iwlwifi/mvm/mvm.h      |  43 +++
 drivers/net/wireless/iwlwifi/mvm/ops.c      |   4 +
 drivers/net/wireless/iwlwifi/mvm/sta.c      |   9 +
 drivers/net/wireless/iwlwifi/mvm/tdls.c     | 489 ++++++++++++++++++++++++++++
 6 files changed, 557 insertions(+)

diff --git a/drivers/net/wireless/iwlwifi/mvm/fw.c b/drivers/net/wireless/iwlwifi/mvm/fw.c
index b4f244f..5757790 100644
--- a/drivers/net/wireless/iwlwifi/mvm/fw.c
+++ b/drivers/net/wireless/iwlwifi/mvm/fw.c
@@ -466,6 +466,8 @@ int iwl_mvm_up(struct iwl_mvm *mvm)
 	for (i = 0; i < IWL_MVM_STATION_COUNT; i++)
 		RCU_INIT_POINTER(mvm->fw_id_to_mac_id[i], NULL);
 
+	mvm->tdls_cs.peer.sta_id = IWL_MVM_STATION_COUNT;
+
 	/* reset quota debouncing buffer - 0xff will yield invalid data */
 	memset(&mvm->last_quota_cmd, 0xff, sizeof(mvm->last_quota_cmd));
 
diff --git a/drivers/net/wireless/iwlwifi/mvm/mac80211.c b/drivers/net/wireless/iwlwifi/mvm/mac80211.c
index 5aedf9d..3841fcf 100644
--- a/drivers/net/wireless/iwlwifi/mvm/mac80211.c
+++ b/drivers/net/wireless/iwlwifi/mvm/mac80211.c
@@ -495,6 +495,12 @@ int iwl_mvm_mac_setup_register(struct iwl_mvm *mvm)
 		hw->wiphy->flags |= WIPHY_FLAG_SUPPORTS_TDLS;
 	}
 
+	if (mvm->fw->ucode_capa.capa[0] &
+	    IWL_UCODE_TLV_CAPA_TDLS_CHANNEL_SWITCH) {
+		IWL_DEBUG_TDLS(mvm, "TDLS channel switch supported\n");
+		hw->wiphy->features |= NL80211_FEATURE_TDLS_CHANNEL_SWITCH;
+	}
+
 	ret = ieee80211_register_hw(mvm->hw);
 	if (ret)
 		iwl_mvm_leds_exit(mvm);
@@ -3211,6 +3217,10 @@ const struct ieee80211_ops iwl_mvm_hw_ops = {
 
 	.channel_switch_beacon = iwl_mvm_channel_switch_beacon,
 
+	.tdls_channel_switch = iwl_mvm_tdls_channel_switch,
+	.tdls_cancel_channel_switch = iwl_mvm_tdls_cancel_channel_switch,
+	.tdls_recv_channel_switch = iwl_mvm_tdls_recv_channel_switch,
+
 	CFG80211_TESTMODE_CMD(iwl_mvm_mac_testmode_cmd)
 
 #ifdef CONFIG_PM_SLEEP
diff --git a/drivers/net/wireless/iwlwifi/mvm/mvm.h b/drivers/net/wireless/iwlwifi/mvm/mvm.h
index 63d2d45..44625ad 100644
--- a/drivers/net/wireless/iwlwifi/mvm/mvm.h
+++ b/drivers/net/wireless/iwlwifi/mvm/mvm.h
@@ -519,6 +519,13 @@ enum {
 #define IWL_MVM_DEBUG_SET_TEMPERATURE_MIN -100
 #define IWL_MVM_DEBUG_SET_TEMPERATURE_MAX 200
 
+enum iwl_mvm_tdls_cs_state {
+	IWL_MVM_TDLS_SW_IDLE = 0,
+	IWL_MVM_TDLS_SW_REQ_SENT,
+	IWL_MVM_TDLS_SW_REQ_RCVD,
+	IWL_MVM_TDLS_SW_ACTIVE,
+};
+
 struct iwl_mvm {
 	/* for logger access */
 	struct device *dev;
@@ -740,6 +747,28 @@ struct iwl_mvm {
 	u32 ap_last_beacon_gp2;
 
 	u8 low_latency_agg_frame_limit;
+
+	/* TDLS channel switch data */
+	struct {
+		struct delayed_work dwork;
+		enum iwl_mvm_tdls_cs_state state;
+
+		/*
+		 * Current cs sta - might be different from periodic cs peer
+		 * station. Value is meaningless when the cs-state is idle.
+		 */
+		u8 cur_sta_id;
+
+		/* TDLS periodic channel-switch peer */
+		struct {
+			u8 sta_id;
+			u8 op_class;
+			bool initiator; /* are we the link initiator */
+			struct cfg80211_chan_def chandef;
+			struct sk_buff *skb; /* ch sw template */
+			u32 ch_sw_tm_ie;
+		} peer;
+	} tdls_cs;
 };
 
 /* Extract MVM priv from op_mode and _hw */
@@ -1258,6 +1287,20 @@ void iwl_mvm_recalc_tdls_state(struct iwl_mvm *mvm, struct ieee80211_vif *vif,
 			       bool sta_added);
 void iwl_mvm_mac_mgd_protect_tdls_discover(struct ieee80211_hw *hw,
 					   struct ieee80211_vif *vif);
+int iwl_mvm_tdls_channel_switch(struct ieee80211_hw *hw,
+				struct ieee80211_vif *vif,
+				struct ieee80211_sta *sta, u8 oper_class,
+				struct cfg80211_chan_def *chandef,
+				struct sk_buff *tmpl_skb, u32 ch_sw_tm_ie);
+void iwl_mvm_tdls_recv_channel_switch(struct ieee80211_hw *hw,
+				      struct ieee80211_vif *vif,
+				      struct ieee80211_tdls_ch_sw_params *params);
+void iwl_mvm_tdls_cancel_channel_switch(struct ieee80211_hw *hw,
+					struct ieee80211_vif *vif,
+					struct ieee80211_sta *sta);
+int iwl_mvm_rx_tdls_notif(struct iwl_mvm *mvm, struct iwl_rx_cmd_buffer *rxb,
+			  struct iwl_device_cmd *cmd);
+void iwl_mvm_tdls_ch_switch_work(struct work_struct *work);
 
 struct ieee80211_vif *iwl_mvm_get_bss_vif(struct iwl_mvm *mvm);
 
diff --git a/drivers/net/wireless/iwlwifi/mvm/ops.c b/drivers/net/wireless/iwlwifi/mvm/ops.c
index 9f9c767..cc83ef5 100644
--- a/drivers/net/wireless/iwlwifi/mvm/ops.c
+++ b/drivers/net/wireless/iwlwifi/mvm/ops.c
@@ -258,6 +258,9 @@ static const struct iwl_rx_handlers iwl_mvm_rx_handlers[] = {
 		   iwl_mvm_power_uapsd_misbehaving_ap_notif, false),
 	RX_HANDLER(DTS_MEASUREMENT_NOTIFICATION, iwl_mvm_temp_notif, true),
 
+	RX_HANDLER(TDLS_CHANNEL_SWITCH_NOTIFICATION, iwl_mvm_rx_tdls_notif,
+		   true),
+
 };
 #undef RX_HANDLER
 #define CMD(x) [x] = #x
@@ -453,6 +456,7 @@ iwl_op_mode_mvm_start(struct iwl_trans *trans, const struct iwl_cfg *cfg,
 	INIT_WORK(&mvm->sta_drained_wk, iwl_mvm_sta_drained_wk);
 	INIT_WORK(&mvm->d0i3_exit_work, iwl_mvm_d0i3_exit_work);
 	INIT_WORK(&mvm->fw_error_dump_wk, iwl_mvm_fw_error_dump_wk);
+	INIT_DELAYED_WORK(&mvm->tdls_cs.dwork, iwl_mvm_tdls_ch_switch_work);
 
 	spin_lock_init(&mvm->d0i3_tx_lock);
 	spin_lock_init(&mvm->refs_lock);
diff --git a/drivers/net/wireless/iwlwifi/mvm/sta.c b/drivers/net/wireless/iwlwifi/mvm/sta.c
index 15afa9a..a38f1f1 100644
--- a/drivers/net/wireless/iwlwifi/mvm/sta.c
+++ b/drivers/net/wireless/iwlwifi/mvm/sta.c
@@ -504,6 +504,15 @@ int iwl_mvm_rm_sta(struct iwl_mvm *mvm,
 	}
 
 	/*
+	 * This shouldn't happen - the TDLS channel switch should be canceled
+	 * before the STA is removed.
+	 */
+	if (WARN_ON_ONCE(mvm->tdls_cs.peer.sta_id == mvm_sta->sta_id)) {
+		mvm->tdls_cs.peer.sta_id = IWL_MVM_STATION_COUNT;
+		cancel_delayed_work(&mvm->tdls_cs.dwork);
+	}
+
+	/*
 	 * Make sure that the tx response code sees the station as -EBUSY and
 	 * calls the drain worker.
 	 */
diff --git a/drivers/net/wireless/iwlwifi/mvm/tdls.c b/drivers/net/wireless/iwlwifi/mvm/tdls.c
index 6dc381b..c0e00ba 100644
--- a/drivers/net/wireless/iwlwifi/mvm/tdls.c
+++ b/drivers/net/wireless/iwlwifi/mvm/tdls.c
@@ -61,9 +61,13 @@
  *
  *****************************************************************************/
 
+#include <linux/etherdevice.h>
 #include "mvm.h"
 #include "time-event.h"
 
+#define TU_TO_US(x) (x * 1024)
+#define TU_TO_MS(x) (TU_TO_US(x) / 1000)
+
 void iwl_mvm_teardown_tdls_peers(struct iwl_mvm *mvm)
 {
 	struct ieee80211_sta *sta;
@@ -215,3 +219,488 @@ void iwl_mvm_mac_mgd_protect_tdls_discover(struct ieee80211_hw *hw,
 
 	iwl_mvm_unref(mvm, IWL_MVM_REF_PROTECT_TDLS);
 }
+
+static const char *
+iwl_mvm_tdls_cs_state_str(enum iwl_mvm_tdls_cs_state state)
+{
+	switch (state) {
+	case IWL_MVM_TDLS_SW_IDLE:
+		return "IDLE";
+	case IWL_MVM_TDLS_SW_REQ_SENT:
+		return "REQ SENT";
+	case IWL_MVM_TDLS_SW_REQ_RCVD:
+		return "REQ RECEIVED";
+	case IWL_MVM_TDLS_SW_ACTIVE:
+		return "ACTIVE";
+	}
+
+	return NULL;
+}
+
+static void iwl_mvm_tdls_update_cs_state(struct iwl_mvm *mvm,
+					 enum iwl_mvm_tdls_cs_state state)
+{
+	if (mvm->tdls_cs.state == state)
+		return;
+
+	IWL_DEBUG_TDLS(mvm, "TDLS channel switch state: %s -> %s\n",
+		       iwl_mvm_tdls_cs_state_str(mvm->tdls_cs.state),
+		       iwl_mvm_tdls_cs_state_str(state));
+	mvm->tdls_cs.state = state;
+
+	if (state == IWL_MVM_TDLS_SW_IDLE)
+		mvm->tdls_cs.cur_sta_id = IWL_MVM_STATION_COUNT;
+}
+
+int iwl_mvm_rx_tdls_notif(struct iwl_mvm *mvm, struct iwl_rx_cmd_buffer *rxb,
+			  struct iwl_device_cmd *cmd)
+{
+	struct iwl_rx_packet *pkt = rxb_addr(rxb);
+	struct iwl_tdls_channel_switch_notif *notif = (void *)pkt->data;
+	struct ieee80211_sta *sta;
+	unsigned int delay;
+	struct iwl_mvm_sta *mvmsta;
+	struct ieee80211_vif *vif;
+	u32 sta_id = le32_to_cpu(notif->sta_id);
+
+	lockdep_assert_held(&mvm->mutex);
+
+	/* can fail sometimes */
+	if (!le32_to_cpu(notif->status)) {
+		iwl_mvm_tdls_update_cs_state(mvm, IWL_MVM_TDLS_SW_IDLE);
+		goto out;
+	}
+
+	if (WARN_ON(sta_id >= IWL_MVM_STATION_COUNT))
+		goto out;
+
+	sta = rcu_dereference_protected(mvm->fw_id_to_mac_id[sta_id],
+					lockdep_is_held(&mvm->mutex));
+	/* the station may not be here, but if it is, it must be a TDLS peer */
+	if (IS_ERR_OR_NULL(sta) || WARN_ON(!sta->tdls))
+		goto out;
+
+	mvmsta = iwl_mvm_sta_from_mac80211(sta);
+	vif = mvmsta->vif;
+
+	/*
+	 * Update state and possibly switch again after this is over (DTIM).
+	 * Also convert TU to msec.
+	 */
+	delay = TU_TO_MS(vif->bss_conf.dtim_period * vif->bss_conf.beacon_int);
+	mod_delayed_work(system_wq, &mvm->tdls_cs.dwork,
+			 msecs_to_jiffies(delay));
+
+	iwl_mvm_tdls_update_cs_state(mvm, IWL_MVM_TDLS_SW_ACTIVE);
+
+out:
+	return 0;
+}
+
+static int
+iwl_mvm_tdls_check_action(struct iwl_mvm *mvm,
+			  enum iwl_tdls_channel_switch_type type,
+			  const u8 *peer, bool peer_initiator)
+{
+	bool same_peer = false;
+	int ret = 0;
+
+	/* get the existing peer if it's there */
+	if (mvm->tdls_cs.state != IWL_MVM_TDLS_SW_IDLE &&
+	    mvm->tdls_cs.cur_sta_id != IWL_MVM_STATION_COUNT) {
+		struct ieee80211_sta *sta = rcu_dereference_protected(
+				mvm->fw_id_to_mac_id[mvm->tdls_cs.cur_sta_id],
+				lockdep_is_held(&mvm->mutex));
+		if (!IS_ERR_OR_NULL(sta))
+			same_peer = ether_addr_equal(peer, sta->addr);
+	}
+
+	switch (mvm->tdls_cs.state) {
+	case IWL_MVM_TDLS_SW_IDLE:
+		/*
+		 * might be spurious packet from the peer after the switch is
+		 * already done
+		 */
+		if (type == TDLS_MOVE_CH)
+			ret = -EINVAL;
+		break;
+	case IWL_MVM_TDLS_SW_REQ_SENT:
+		/*
+		 * We received a ch-switch request while an outgoing one is
+		 * pending. Allow it to proceed if the other peer is the same
+		 * one we sent to, and we are not the link initiator.
+		 */
+		if (type == TDLS_SEND_CHAN_SW_RESP_AND_MOVE_CH) {
+			if (!same_peer)
+				ret = -EBUSY;
+			else if (!peer_initiator) /* we are the initiator */
+				ret = -EBUSY;
+		}
+		break;
+	case IWL_MVM_TDLS_SW_REQ_RCVD:
+		/* as above, allow the link initiator to proceed */
+		if (type == TDLS_SEND_CHAN_SW_REQ) {
+			if (!same_peer)
+				ret = -EBUSY;
+			else if (peer_initiator) /* they are the initiator */
+				ret = -EBUSY;
+		} else if (type == TDLS_MOVE_CH) {
+			ret = -EINVAL;
+		}
+		break;
+	case IWL_MVM_TDLS_SW_ACTIVE:
+		/* we don't allow initiations during active channel switch */
+		if (type == TDLS_SEND_CHAN_SW_REQ)
+			ret = -EINVAL;
+		break;
+	}
+
+	if (ret)
+		IWL_DEBUG_TDLS(mvm,
+			       "Invalid TDLS action %d state %d peer %pM same_peer %d initiator %d\n",
+			       type, mvm->tdls_cs.state, peer, same_peer,
+			       peer_initiator);
+
+	return ret;
+}
+
+static int
+iwl_mvm_tdls_config_channel_switch(struct iwl_mvm *mvm,
+				   struct ieee80211_vif *vif,
+				   enum iwl_tdls_channel_switch_type type,
+				   const u8 *peer, bool peer_initiator,
+				   u8 oper_class,
+				   struct cfg80211_chan_def *chandef,
+				   u32 timestamp, u16 switch_time,
+				   u16 switch_timeout, struct sk_buff *skb,
+				   u32 ch_sw_tm_ie)
+{
+	struct ieee80211_sta *sta;
+	struct iwl_mvm_sta *mvmsta;
+	struct ieee80211_tx_info *info;
+	struct ieee80211_hdr *hdr;
+	struct iwl_tdls_channel_switch_cmd cmd = {0};
+	int ret;
+
+	lockdep_assert_held(&mvm->mutex);
+
+	ret = iwl_mvm_tdls_check_action(mvm, type, peer, peer_initiator);
+	if (ret)
+		return ret;
+
+	if (!skb || WARN_ON(skb->len > IWL_TDLS_CH_SW_FRAME_MAX_SIZE)) {
+		ret = -EINVAL;
+		goto out;
+	}
+
+	cmd.switch_type = type;
+	cmd.timing.frame_timestamp = cpu_to_le32(timestamp);
+	cmd.timing.switch_time = cpu_to_le32(switch_time);
+	cmd.timing.switch_timeout = cpu_to_le32(switch_timeout);
+
+	rcu_read_lock();
+	sta = ieee80211_find_sta(vif, peer);
+	if (!sta) {
+		rcu_read_unlock();
+		ret = -ENOENT;
+		goto out;
+	}
+	mvmsta = iwl_mvm_sta_from_mac80211(sta);
+	cmd.peer_sta_id = cpu_to_le32(mvmsta->sta_id);
+
+	if (!chandef) {
+		if (mvm->tdls_cs.state == IWL_MVM_TDLS_SW_REQ_SENT &&
+		    mvm->tdls_cs.peer.chandef.chan) {
+			/* actually moving to the channel */
+			chandef = &mvm->tdls_cs.peer.chandef;
+		} else if (mvm->tdls_cs.state == IWL_MVM_TDLS_SW_ACTIVE &&
+			   type == TDLS_MOVE_CH) {
+			/* we need to return to base channel */
+			struct ieee80211_chanctx_conf *chanctx =
+					rcu_dereference(vif->chanctx_conf);
+
+			if (WARN_ON_ONCE(!chanctx)) {
+				rcu_read_unlock();
+				goto out;
+			}
+
+			chandef = &chanctx->def;
+		}
+	}
+
+	if (chandef) {
+		cmd.ci.band = (chandef->chan->band == IEEE80211_BAND_2GHZ ?
+			       PHY_BAND_24 : PHY_BAND_5);
+		cmd.ci.channel = chandef->chan->hw_value;
+		cmd.ci.width = iwl_mvm_get_channel_width(chandef);
+		cmd.ci.ctrl_pos = iwl_mvm_get_ctrl_pos(chandef);
+	}
+
+	/* keep quota calculation simple for now - 50% of DTIM for TDLS */
+	cmd.timing.max_offchan_duration =
+			cpu_to_le32(TU_TO_US(vif->bss_conf.dtim_period *
+					     vif->bss_conf.beacon_int) / 2);
+
+	/* Switch time is the first element in the switch-timing IE. */
+	cmd.frame.switch_time_offset = cpu_to_le32(ch_sw_tm_ie + 2);
+
+	info = IEEE80211_SKB_CB(skb);
+	if (info->control.hw_key)
+		iwl_mvm_set_tx_cmd_crypto(mvm, info, &cmd.frame.tx_cmd, skb);
+
+	iwl_mvm_set_tx_cmd(mvm, skb, &cmd.frame.tx_cmd, info,
+			   mvmsta->sta_id);
+
+	hdr = (void *)skb->data;
+	iwl_mvm_set_tx_cmd_rate(mvm, &cmd.frame.tx_cmd, info, sta,
+				hdr->frame_control);
+	rcu_read_unlock();
+
+	memcpy(cmd.frame.data, skb->data, skb->len);
+
+	ret = iwl_mvm_send_cmd_pdu(mvm, TDLS_CHANNEL_SWITCH_CMD, 0,
+				   sizeof(cmd), &cmd);
+	if (ret) {
+		IWL_ERR(mvm, "Failed to send TDLS_CHANNEL_SWITCH cmd: %d\n",
+			ret);
+		goto out;
+	}
+
+	/* channel switch has started, update state */
+	if (type != TDLS_MOVE_CH) {
+		mvm->tdls_cs.cur_sta_id = mvmsta->sta_id;
+		iwl_mvm_tdls_update_cs_state(mvm,
+					     type == TDLS_SEND_CHAN_SW_REQ ?
+					     IWL_MVM_TDLS_SW_REQ_SENT :
+					     IWL_MVM_TDLS_SW_REQ_RCVD);
+	}
+
+out:
+
+	/* channel switch failed - we are idle */
+	if (ret)
+		iwl_mvm_tdls_update_cs_state(mvm, IWL_MVM_TDLS_SW_IDLE);
+
+	return ret;
+}
+
+void iwl_mvm_tdls_ch_switch_work(struct work_struct *work)
+{
+	struct iwl_mvm *mvm;
+	struct ieee80211_sta *sta;
+	struct iwl_mvm_sta *mvmsta;
+	struct ieee80211_vif *vif;
+	unsigned int delay;
+	int ret;
+
+	mvm = container_of(work, struct iwl_mvm, tdls_cs.dwork.work);
+	mutex_lock(&mvm->mutex);
+
+	/* called after an active channel switch has finished or timed-out */
+	iwl_mvm_tdls_update_cs_state(mvm, IWL_MVM_TDLS_SW_IDLE);
+
+	/* station might be gone, in that case do nothing */
+	if (mvm->tdls_cs.peer.sta_id == IWL_MVM_STATION_COUNT)
+		goto out;
+
+	sta = rcu_dereference_protected(
+				mvm->fw_id_to_mac_id[mvm->tdls_cs.peer.sta_id],
+				lockdep_is_held(&mvm->mutex));
+	/* the station may not be here, but if it is, it must be a TDLS peer */
+	if (!sta || IS_ERR(sta) || WARN_ON(!sta->tdls))
+		goto out;
+
+	mvmsta = iwl_mvm_sta_from_mac80211(sta);
+	vif = mvmsta->vif;
+	ret = iwl_mvm_tdls_config_channel_switch(mvm, vif,
+						 TDLS_SEND_CHAN_SW_REQ,
+						 sta->addr,
+						 mvm->tdls_cs.peer.initiator,
+						 mvm->tdls_cs.peer.op_class,
+						 &mvm->tdls_cs.peer.chandef,
+						 0, 0, 0,
+						 mvm->tdls_cs.peer.skb,
+						 mvm->tdls_cs.peer.ch_sw_tm_ie);
+	if (ret)
+		IWL_ERR(mvm, "Not sending TDLS channel switch: %d\n", ret);
+
+	/* retry after a DTIM if we failed sending now */
+	delay = TU_TO_MS(vif->bss_conf.dtim_period * vif->bss_conf.beacon_int);
+	queue_delayed_work(system_wq, &mvm->tdls_cs.dwork,
+			   msecs_to_jiffies(delay));
+out:
+	mutex_unlock(&mvm->mutex);
+}
+
+int
+iwl_mvm_tdls_channel_switch(struct ieee80211_hw *hw,
+			    struct ieee80211_vif *vif,
+			    struct ieee80211_sta *sta, u8 oper_class,
+			    struct cfg80211_chan_def *chandef,
+			    struct sk_buff *tmpl_skb, u32 ch_sw_tm_ie)
+{
+	struct iwl_mvm *mvm = IWL_MAC80211_GET_MVM(hw);
+	struct iwl_mvm_sta *mvmsta;
+	unsigned int delay;
+	int ret;
+
+	mutex_lock(&mvm->mutex);
+
+	IWL_DEBUG_TDLS(mvm, "TDLS channel switch with %pM ch %d width %d\n",
+		       sta->addr, chandef->chan->center_freq, chandef->width);
+
+	/* we only support a single peer for channel switching */
+	if (mvm->tdls_cs.peer.sta_id != IWL_MVM_STATION_COUNT) {
+		IWL_DEBUG_TDLS(mvm,
+			       "Existing peer. Can't start switch with %pM\n",
+			       sta->addr);
+		ret = -EBUSY;
+		goto out;
+	}
+
+	ret = iwl_mvm_tdls_config_channel_switch(mvm, vif,
+						 TDLS_SEND_CHAN_SW_REQ,
+						 sta->addr, sta->tdls_initiator,
+						 oper_class, chandef, 0, 0, 0,
+						 tmpl_skb, ch_sw_tm_ie);
+	if (ret)
+		goto out;
+
+	/*
+	 * Mark the peer as "in tdls switch" for this vif. We only allow a
+	 * single such peer per vif.
+	 */
+	mvm->tdls_cs.peer.skb = skb_copy(tmpl_skb, GFP_KERNEL);
+	if (!mvm->tdls_cs.peer.skb) {
+		ret = -ENOMEM;
+		goto out;
+	}
+
+	mvmsta = iwl_mvm_sta_from_mac80211(sta);
+	mvm->tdls_cs.peer.sta_id = mvmsta->sta_id;
+	mvm->tdls_cs.peer.chandef = *chandef;
+	mvm->tdls_cs.peer.initiator = sta->tdls_initiator;
+	mvm->tdls_cs.peer.op_class = oper_class;
+	mvm->tdls_cs.peer.ch_sw_tm_ie = ch_sw_tm_ie;
+
+	/*
+	 * Wait for 2 DTIM periods before attempting the next switch. The next
+	 * switch will be made sooner if the current one completes before that.
+	 */
+	delay = 2 * TU_TO_MS(vif->bss_conf.dtim_period *
+			     vif->bss_conf.beacon_int);
+	mod_delayed_work(system_wq, &mvm->tdls_cs.dwork,
+			 msecs_to_jiffies(delay));
+
+out:
+	mutex_unlock(&mvm->mutex);
+	return ret;
+}
+
+void iwl_mvm_tdls_cancel_channel_switch(struct ieee80211_hw *hw,
+					struct ieee80211_vif *vif,
+					struct ieee80211_sta *sta)
+{
+	struct iwl_mvm *mvm = IWL_MAC80211_GET_MVM(hw);
+	struct ieee80211_sta *cur_sta;
+	bool wait_for_phy = false;
+
+	mutex_lock(&mvm->mutex);
+
+	IWL_DEBUG_TDLS(mvm, "TDLS cancel channel switch with %pM\n", sta->addr);
+
+	/* we only support a single peer for channel switching */
+	if (mvm->tdls_cs.peer.sta_id == IWL_MVM_STATION_COUNT) {
+		IWL_DEBUG_TDLS(mvm, "No ch switch peer - %pM\n", sta->addr);
+		goto out;
+	}
+
+	cur_sta = rcu_dereference_protected(
+				mvm->fw_id_to_mac_id[mvm->tdls_cs.peer.sta_id],
+				lockdep_is_held(&mvm->mutex));
+	/* make sure it's the same peer */
+	if (cur_sta != sta)
+		goto out;
+
+	/*
+	 * If we're currently in a switch because of the now canceled peer,
+	 * wait a DTIM here to make sure the phy is back on the base channel.
+	 * We can't otherwise force it.
+	 */
+	if (mvm->tdls_cs.cur_sta_id == mvm->tdls_cs.peer.sta_id &&
+	    mvm->tdls_cs.state != IWL_MVM_TDLS_SW_IDLE)
+		wait_for_phy = true;
+
+	mvm->tdls_cs.peer.sta_id = IWL_MVM_STATION_COUNT;
+	dev_kfree_skb(mvm->tdls_cs.peer.skb);
+	mvm->tdls_cs.peer.skb = NULL;
+
+out:
+	mutex_unlock(&mvm->mutex);
+
+	/* make sure the phy is on the base channel */
+	if (wait_for_phy)
+		msleep(TU_TO_MS(vif->bss_conf.dtim_period *
+				vif->bss_conf.beacon_int));
+
+	/* flush the channel switch state */
+	flush_delayed_work(&mvm->tdls_cs.dwork);
+
+	IWL_DEBUG_TDLS(mvm, "TDLS ending channel switch with %pM\n", sta->addr);
+}
+
+void
+iwl_mvm_tdls_recv_channel_switch(struct ieee80211_hw *hw,
+				 struct ieee80211_vif *vif,
+				 struct ieee80211_tdls_ch_sw_params *params)
+{
+	struct iwl_mvm *mvm = IWL_MAC80211_GET_MVM(hw);
+	enum iwl_tdls_channel_switch_type type;
+	unsigned int delay;
+
+	mutex_lock(&mvm->mutex);
+
+	IWL_DEBUG_TDLS(mvm,
+		       "Received TDLS ch switch action %d from %pM status %d\n",
+		       params->action_code, params->sta->addr, params->status);
+
+	/*
+	 * we got a non-zero status from a peer we were switching to - move to
+	 * the idle state and retry again later
+	 */
+	if (params->action_code == WLAN_TDLS_CHANNEL_SWITCH_RESPONSE &&
+	    params->status != 0 &&
+	    mvm->tdls_cs.state == IWL_MVM_TDLS_SW_REQ_SENT &&
+	    mvm->tdls_cs.cur_sta_id != IWL_MVM_STATION_COUNT) {
+		struct ieee80211_sta *cur_sta;
+
+		/* make sure it's the same peer */
+		cur_sta = rcu_dereference_protected(
+				mvm->fw_id_to_mac_id[mvm->tdls_cs.cur_sta_id],
+				lockdep_is_held(&mvm->mutex));
+		if (cur_sta == params->sta) {
+			iwl_mvm_tdls_update_cs_state(mvm,
+						     IWL_MVM_TDLS_SW_IDLE);
+			goto retry;
+		}
+	}
+
+	type = (params->action_code == WLAN_TDLS_CHANNEL_SWITCH_REQUEST) ?
+	       TDLS_SEND_CHAN_SW_RESP_AND_MOVE_CH : TDLS_MOVE_CH;
+
+	iwl_mvm_tdls_config_channel_switch(mvm, vif, type, params->sta->addr,
+					   params->sta->tdls_initiator, 0,
+					   params->chandef, params->timestamp,
+					   params->switch_time,
+					   params->switch_timeout,
+					   params->tmpl_skb,
+					   params->ch_sw_tm_ie);
+
+retry:
+	/* register a timeout in case we don't succeed in switching */
+	delay = vif->bss_conf.dtim_period * vif->bss_conf.beacon_int *
+		1024 / 1000;
+	mod_delayed_work(system_wq, &mvm->tdls_cs.dwork,
+			 msecs_to_jiffies(delay));
+	mutex_unlock(&mvm->mutex);
+}
-- 
1.9.1

