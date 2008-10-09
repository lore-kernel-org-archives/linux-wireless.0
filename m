Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:56080 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755888AbYJIK3t (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 9 Oct 2008 06:29:49 -0400
Subject: [PATCH/RFC/RFT] mac80211: rewrite HT handling
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless <linux-wireless@vger.kernel.org>
Cc: Tomas Winkler <tomasw@gmail.com>,
	"Luis R. Rodriguez" <mcgrof@gmail.com>, Jouni Malinen <j@w1.fi>
Content-Type: text/plain
Date: Thu, 09 Oct 2008 12:29:48 +0200
Message-Id: <1223548188.22490.47.camel@johannes.berg> (sfid-20081009_122955_429188_A744301F)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The HT handling has the following deficiencies, which I've
(partially) fixed:
 * it always uses the AP info even if there is no AP,
   hence has no chance of working as an AP
 * it pretends to be HW config, but really is per-BSS
 * channel sanity checking is left to the drivers
 * it generally lets the driver control too much

HT enabling is still wrong with this patch if you have more than
one virtual STA mode interface, but that never happens currently.
Once WDS, IBSS or AP/VLAN gets HT capabilities, it will also be
wrong, see the comment in ieee80211_enable_ht().

Additionally, this fixes a number of bugs:
 * mac80211: ieee80211_set_disassoc doesn't notify the driver any
             more since the refactoring
 * iwl-agn-rs: always uses the HT capabilities from the wrong stuff
               mac80211 gives it rather than the actual peer STA
 * ath9k: a number of bugs resulting from the broken HT API

I'm not entirely happy with putting the HT capabilities into
struct ieee80211_sta as restricted to our own HT TX capabilities,
but I see no cleaner solution.

Signed-off-by: Johannes Berg <johannes@sipsolutions.net>
---
This should help making an HT AP.

No complaints please, I only want to hear constructive feedback like
"you missed that" or "this has to be different". Or you can tell me
_why_ the new design is wrong, I've outlined above why I think the
current design is wrong.

 drivers/net/wireless/ath9k/core.h         |    6 
 drivers/net/wireless/ath9k/main.c         |   41 +++---
 drivers/net/wireless/ath9k/rc.c           |    8 -
 drivers/net/wireless/ath9k/recv.c         |    3 
 drivers/net/wireless/ath9k/xmit.c         |   17 +-
 drivers/net/wireless/iwlwifi/iwl-agn-rs.c |   23 +--
 drivers/net/wireless/iwlwifi/iwl-agn.c    |   39 ++++--
 drivers/net/wireless/iwlwifi/iwl-core.c   |   17 --
 drivers/net/wireless/iwlwifi/iwl-dev.h    |    1 
 drivers/net/wireless/iwlwifi/iwl-sta.c    |   31 +++--
 include/net/mac80211.h                    |   59 ++++-----
 net/mac80211/cfg.c                        |    6 
 net/mac80211/ht.c                         |  183 ++++++++++++------------------
 net/mac80211/ieee80211_i.h                |   12 -
 net/mac80211/mlme.c                       |   82 +++++++------
 15 files changed, 253 insertions(+), 275 deletions(-)

--- everything.orig/include/net/mac80211.h	2008-10-09 11:06:53.000000000 +0200
+++ everything/include/net/mac80211.h	2008-10-09 12:23:02.000000000 +0200
@@ -3,7 +3,7 @@
  *
  * Copyright 2002-2005, Devicescape Software, Inc.
  * Copyright 2006-2007	Jiri Benc <jbenc@suse.cz>
- * Copyright 2007	Johannes Berg <johannes@sipsolutions.net>
+ * Copyright 2007-2008	Johannes Berg <johannes@sipsolutions.net>
  *
  * This program is free software; you can redistribute it and/or modify
  * it under the terms of the GNU General Public License version 2 as
@@ -82,22 +82,6 @@ enum ieee80211_notification_types {
 };
 
 /**
- * struct ieee80211_ht_bss_info - describing BSS's HT characteristics
- *
- * This structure describes most essential parameters needed
- * to describe 802.11n HT characteristics in a BSS.
- *
- * @primary_channel: channel number of primery channel
- * @bss_cap: 802.11n's general BSS capabilities (e.g. channel width)
- * @bss_op_mode: 802.11n's BSS operation modes (e.g. HT protection)
- */
-struct ieee80211_ht_bss_info {
-	u8 primary_channel;
-	u8 bss_cap;  /* use IEEE80211_HT_IE_CHA_ */
-	u8 bss_op_mode; /* use IEEE80211_HT_IE_ */
-};
-
-/**
  * enum ieee80211_max_queues - maximum number of queues
  *
  * @IEEE80211_MAX_QUEUES: Maximum number of regular device queues.
@@ -172,6 +156,19 @@ enum ieee80211_bss_change {
 };
 
 /**
+ * struct ieee80211_bss_ht_conf - BSS's changing HT configuration
+ * @secondary_channel_offset: secondary channel offset, uses
+ *	%IEEE80211_HT_PARAM_CHA_SEC_ values
+ * @width_40_ok: indicates that 40 MHz bandwidth may be used for TX
+ * @operation_mode: HT operation mode (like in &struct ieee80211_ht_info)
+ */
+struct ieee80211_bss_ht_conf {
+	u8 secondary_channel_offset;
+	bool width_40_ok;
+	u16 operation_mode;
+};
+
+/**
  * struct ieee80211_bss_conf - holds the BSS's changing parameters
  *
  * This structure keeps information about a BSS (and an association
@@ -190,9 +187,7 @@ enum ieee80211_bss_change {
  * @timestamp: beacon timestamp
  * @beacon_int: beacon interval
  * @assoc_capability: capabilities taken from assoc resp
- * @assoc_ht: association in HT mode
- * @ht_cap: ht capabilities
- * @ht_bss_conf: ht extended capabilities
+ * @ht: BSS's HT configuration
  * @basic_rates: bitmap of basic rates, each bit stands for an
  *	index into the rate table configured by the driver in
  *	the current band.
@@ -210,10 +205,7 @@ struct ieee80211_bss_conf {
 	u16 assoc_capability;
 	u64 timestamp;
 	u64 basic_rates;
-	/* ht related data */
-	bool assoc_ht;
-	struct ieee80211_sta_ht_cap *ht_cap;
-	struct ieee80211_ht_bss_info *ht_bss_conf;
+	struct ieee80211_bss_ht_conf ht;
 };
 
 /**
@@ -447,13 +439,11 @@ struct ieee80211_rx_status {
  * Flags to define PHY configuration options
  *
  * @IEEE80211_CONF_RADIOTAP: add radiotap header at receive time (if supported)
- * @IEEE80211_CONF_SUPPORT_HT_MODE: use 802.11n HT capabilities (if supported)
  * @IEEE80211_CONF_PS: Enable 802.11 power save mode
  */
 enum ieee80211_conf_flags {
 	IEEE80211_CONF_RADIOTAP		= (1<<0),
-	IEEE80211_CONF_SUPPORT_HT_MODE	= (1<<1),
-	IEEE80211_CONF_PS		= (1<<2),
+	IEEE80211_CONF_PS		= (1<<1),
 };
 
 /* XXX: remove all this once drivers stop trying to use it */
@@ -463,6 +453,10 @@ static inline int __deprecated __IEEE802
 }
 #define IEEE80211_CONF_SHORT_SLOT_TIME (__IEEE80211_CONF_SHORT_SLOT_TIME())
 
+struct ieee80211_ht_conf {
+	bool enabled;
+};
+
 /**
  * enum ieee80211_conf_changed - denotes which configuration changed
  *
@@ -473,6 +467,7 @@ static inline int __deprecated __IEEE802
  * @IEEE80211_CONF_CHANGE_PS: the PS flag changed
  * @IEEE80211_CONF_CHANGE_POWER: the TX power changed
  * @IEEE80211_CONF_CHANGE_CHANNEL: the channel changed
+ * @IEEE80211_CONF_CHANGE_HT: HT configuration changed
  */
 enum ieee80211_conf_changed {
 	IEEE80211_CONF_CHANGE_RADIO_ENABLED	= BIT(0),
@@ -482,6 +477,7 @@ enum ieee80211_conf_changed {
 	IEEE80211_CONF_CHANGE_PS		= BIT(4),
 	IEEE80211_CONF_CHANGE_POWER		= BIT(5),
 	IEEE80211_CONF_CHANGE_CHANNEL		= BIT(6),
+	IEEE80211_CONF_CHANGE_HT		= BIT(7),
 };
 
 /**
@@ -494,9 +490,8 @@ enum ieee80211_conf_changed {
  * @listen_interval: listen interval in units of beacon interval
  * @flags: configuration flags defined above
  * @power_level: requested transmit power (in dBm)
- * @ht_cap: describes current self configuration of 802.11n HT capabilities
- * @ht_bss_conf: describes current BSS configuration of 802.11n HT parameters
  * @channel: the channel to tune to
+ * @ht: the HT configuration for the device
  */
 struct ieee80211_conf {
 	int beacon_int;
@@ -507,9 +502,7 @@ struct ieee80211_conf {
 	bool radio_enabled;
 
 	struct ieee80211_channel *channel;
-
-	struct ieee80211_sta_ht_cap ht_cap;
-	struct ieee80211_ht_bss_info ht_bss_conf;
+	struct ieee80211_ht_conf ht;
 };
 
 /**
@@ -701,7 +694,7 @@ enum set_key_cmd {
  * @addr: MAC address
  * @aid: AID we assigned to the station if we're an AP
  * @supp_rates: Bitmap of supported rates (per band)
- * @ht_cap: HT capabilities of this STA
+ * @ht_cap: HT capabilities of this STA; restricted to our own TX capabilities
  * @drv_priv: data area for driver use, will always be aligned to
  *	sizeof(void *), size is determined in hw information.
  */
--- everything.orig/net/mac80211/ht.c	2008-10-09 11:06:54.000000000 +0200
+++ everything/net/mac80211/ht.c	2008-10-09 11:12:13.000000000 +0200
@@ -20,114 +20,38 @@
 #include "sta_info.h"
 #include "wme.h"
 
-void ieee80211_ht_cap_ie_to_sta_ht_cap(struct ieee80211_ht_cap *ht_cap_ie,
+void ieee80211_ht_cap_ie_to_sta_ht_cap(struct ieee80211_supported_band *sband,
+				       struct ieee80211_ht_cap *ht_cap_ie,
 				       struct ieee80211_sta_ht_cap *ht_cap)
 {
+	u8 ampdu_info, tx_mcs_set_cap;
+	int i, max_tx_streams;
 
 	BUG_ON(!ht_cap);
 
 	memset(ht_cap, 0, sizeof(*ht_cap));
 
-	if (ht_cap_ie) {
-		u8 ampdu_info = ht_cap_ie->ampdu_params_info;
-
-		ht_cap->ht_supported = true;
-		ht_cap->cap = le16_to_cpu(ht_cap_ie->cap_info);
-		ht_cap->ampdu_factor =
-			ampdu_info & IEEE80211_HT_AMPDU_PARM_FACTOR;
-		ht_cap->ampdu_density =
-			(ampdu_info & IEEE80211_HT_AMPDU_PARM_DENSITY) >> 2;
-		memcpy(&ht_cap->mcs, &ht_cap_ie->mcs, sizeof(ht_cap->mcs));
-	} else
-		ht_cap->ht_supported = false;
-}
-
-void ieee80211_ht_info_ie_to_ht_bss_info(
-			struct ieee80211_ht_info *ht_add_info_ie,
-			struct ieee80211_ht_bss_info *bss_info)
-{
-	BUG_ON(!bss_info);
-
-	memset(bss_info, 0, sizeof(*bss_info));
-
-	if (ht_add_info_ie) {
-		u16 op_mode;
-		op_mode = le16_to_cpu(ht_add_info_ie->operation_mode);
-
-		bss_info->primary_channel = ht_add_info_ie->control_chan;
-		bss_info->bss_cap = ht_add_info_ie->ht_param;
-		bss_info->bss_op_mode = (u8)(op_mode & 0xff);
-	}
-}
-
-/*
- * ieee80211_handle_ht should be called only after the operating band
- * has been determined as ht configuration depends on the hw's
- * HT abilities for a specific band.
- */
-u32 ieee80211_handle_ht(struct ieee80211_local *local,
-			struct ieee80211_sta_ht_cap *req_ht_cap,
-			struct ieee80211_ht_bss_info *req_bss_cap)
-{
-	struct ieee80211_conf *conf = &local->hw.conf;
-	struct ieee80211_supported_band *sband;
-	struct ieee80211_sta_ht_cap ht_cap;
-	struct ieee80211_ht_bss_info ht_bss_conf;
-	u32 changed = 0;
-	int i;
-	u8 max_tx_streams;
-	u8 tx_mcs_set_cap;
-	bool enable_ht = true;
-
-	sband = local->hw.wiphy->bands[conf->channel->band];
-
-	memset(&ht_cap, 0, sizeof(ht_cap));
-	memset(&ht_bss_conf, 0, sizeof(struct ieee80211_ht_bss_info));
-
-	/* HT is not supported */
-	if (!sband->ht_cap.ht_supported)
-		enable_ht = false;
-
-	/* disable HT */
-	if (!enable_ht) {
-		if (conf->flags & IEEE80211_CONF_SUPPORT_HT_MODE)
-			changed |= BSS_CHANGED_HT;
-		conf->flags &= ~IEEE80211_CONF_SUPPORT_HT_MODE;
-		conf->ht_cap.ht_supported = false;
-		return changed;
-	}
-
-
-	if (!(conf->flags & IEEE80211_CONF_SUPPORT_HT_MODE))
-		changed |= BSS_CHANGED_HT;
-
-	conf->flags |= IEEE80211_CONF_SUPPORT_HT_MODE;
-	ht_cap.ht_supported = true;
+	if (!ht_cap_ie)
+		return;
 
-	ht_cap.cap = req_ht_cap->cap & sband->ht_cap.cap;
-	ht_cap.cap &= ~IEEE80211_HT_CAP_SM_PS;
-	ht_cap.cap |= sband->ht_cap.cap & IEEE80211_HT_CAP_SM_PS;
-
-	ht_bss_conf.primary_channel = req_bss_cap->primary_channel;
-	ht_bss_conf.bss_cap = req_bss_cap->bss_cap;
-	ht_bss_conf.bss_op_mode = req_bss_cap->bss_op_mode;
+	ht_cap->ht_supported = true;
 
-	ht_cap.ampdu_factor = req_ht_cap->ampdu_factor;
-	ht_cap.ampdu_density = req_ht_cap->ampdu_density;
+	ht_cap->cap = ht_cap->cap & sband->ht_cap.cap;
+	ht_cap->cap &= ~IEEE80211_HT_CAP_SM_PS;
+	ht_cap->cap |= sband->ht_cap.cap & IEEE80211_HT_CAP_SM_PS;
+
+	ampdu_info = ht_cap_ie->ampdu_params_info;
+	ht_cap->ampdu_factor =
+		ampdu_info & IEEE80211_HT_AMPDU_PARM_FACTOR;
+	ht_cap->ampdu_density =
+		(ampdu_info & IEEE80211_HT_AMPDU_PARM_DENSITY) >> 2;
 
 	/* own MCS TX capabilities */
 	tx_mcs_set_cap = sband->ht_cap.mcs.tx_params;
 
-	/*
-	 * configure supported Tx MCS according to requested MCS
-	 * (based in most cases on Rx capabilities of peer) and self
-	 * Tx MCS capabilities (as defined by low level driver HW
-	 * Tx capabilities)
-	 */
-
 	/* can we TX with MCS rates? */
 	if (!(tx_mcs_set_cap & IEEE80211_HT_MCS_TX_DEFINED))
-		goto check_changed;
+		return;
 
 	/* Counting from 0, therefore +1 */
 	if (tx_mcs_set_cap & IEEE80211_HT_MCS_TX_RX_DIFF)
@@ -145,29 +69,73 @@ u32 ieee80211_handle_ht(struct ieee80211
 	 * - remainder are multiple spatial streams using unequal modulation
 	 */
 	for (i = 0; i < max_tx_streams; i++)
-		ht_cap.mcs.rx_mask[i] =
-			sband->ht_cap.mcs.rx_mask[i] &
-					req_ht_cap->mcs.rx_mask[i];
+		ht_cap->mcs.rx_mask[i] =
+			sband->ht_cap.mcs.rx_mask[i] & ht_cap_ie->mcs.rx_mask[i];
 
 	if (tx_mcs_set_cap & IEEE80211_HT_MCS_TX_UNEQUAL_MODULATION)
 		for (i = IEEE80211_HT_MCS_UNEQUAL_MODULATION_START_BYTE;
 		     i < IEEE80211_HT_MCS_MASK_LEN; i++)
-			ht_cap.mcs.rx_mask[i] =
+			ht_cap->mcs.rx_mask[i] =
 				sband->ht_cap.mcs.rx_mask[i] &
-					req_ht_cap->mcs.rx_mask[i];
+					ht_cap_ie->mcs.rx_mask[i];
 
 	/* handle MCS rate 32 too */
-	if (sband->ht_cap.mcs.rx_mask[32/8] &
-	    req_ht_cap->mcs.rx_mask[32/8] & 1)
-		ht_cap.mcs.rx_mask[32/8] |= 1;
+	if (sband->ht_cap.mcs.rx_mask[32/8] & ht_cap_ie->mcs.rx_mask[32/8] & 1)
+		ht_cap->mcs.rx_mask[32/8] |= 1;
+}
+
+/*
+ * ieee80211_enable_ht should be called only after the operating band
+ * has been determined as ht configuration depends on the hw's
+ * HT abilities for a specific band.
+ */
+u32 ieee80211_enable_ht(struct ieee80211_sub_if_data *sdata,
+			struct ieee80211_ht_info *hti,
+			struct sta_info *ap)
+{
+	struct ieee80211_local *local = sdata->local;
+	struct ieee80211_supported_band *sband;
+	struct ieee80211_bss_ht_conf ht;
+	u32 changed = 0;
+	bool enable_ht = true, ht_changed;
+
+	sband = local->hw.wiphy->bands[local->hw.conf.channel->band];
+
+	memset(&ht, 0, sizeof(ht));
+
+	/* HT is not supported */
+	if (!sband->ht_cap.ht_supported)
+		enable_ht = false;
+
+	/* check that channel matches the right operating channel */
+	if (local->hw.conf.channel->center_freq !=
+	    ieee80211_channel_to_frequency(hti->control_chan))
+		enable_ht = false;
+
+	/*
+	 * XXX: This is totally incorrect when there are multiple virtual
+	 *	interfaces, needs to be fixed later.
+	 */
+	ht_changed = local->hw.conf.ht.enabled != enable_ht;
+	local->hw.conf.ht.enabled = enable_ht;
+	if (ht_changed)
+		ieee80211_hw_config(local, IEEE80211_CONF_CHANGE_HT);
+
+	/* disable HT */
+	if (!enable_ht)
+		return 0;
+	ht.secondary_channel_offset =
+		hti->ht_param & IEEE80211_HT_PARAM_CHA_SEC_OFFSET;
+	ht.width_40_ok =
+		!(ap->sta.ht_cap.cap & IEEE80211_HT_CAP_40MHZ_INTOLERANT) &&
+		(sband->ht_cap.cap & IEEE80211_HT_CAP_SUP_WIDTH_20_40) &&
+		(hti->ht_param & IEEE80211_HT_PARAM_CHAN_WIDTH_ANY);
+	ht.operation_mode = le16_to_cpu(hti->operation_mode);
 
- check_changed:
 	/* if bss configuration changed store the new one */
-	if (memcmp(&conf->ht_cap, &ht_cap, sizeof(ht_cap)) ||
-	    memcmp(&conf->ht_bss_conf, &ht_bss_conf, sizeof(ht_bss_conf))) {
+	if (memcmp(&sdata->bss_conf.ht, &ht, sizeof(ht))) {
 		changed |= BSS_CHANGED_HT;
-		memcpy(&conf->ht_cap, &ht_cap, sizeof(ht_cap));
-		memcpy(&conf->ht_bss_conf, &ht_bss_conf, sizeof(ht_bss_conf));
+		sdata->bss_conf.ht = ht;
 	}
 
 	return changed;
@@ -908,8 +876,9 @@ void ieee80211_process_addba_request(str
 	/* sanity check for incoming parameters:
 	 * check if configuration can support the BA policy
 	 * and if buffer size does not exceeds max value */
+	/* XXX: check own ht delayed BA capability?? */
 	if (((ba_policy != 1)
-		&& (!(conf->ht_cap.cap & IEEE80211_HT_CAP_DELAY_BA)))
+		&& (!(sta->sta.ht_cap.cap & IEEE80211_HT_CAP_DELAY_BA)))
 		|| (buf_size > IEEE80211_MAX_AMPDU_BUF)) {
 		status = WLAN_STATUS_INVALID_QOS_PARAM;
 #ifdef CONFIG_MAC80211_HT_DEBUG
--- everything.orig/net/mac80211/mlme.c	2008-10-09 11:06:53.000000000 +0200
+++ everything/net/mac80211/mlme.c	2008-10-09 12:23:03.000000000 +0200
@@ -702,14 +702,15 @@ static void ieee80211_sta_send_associnfo
 
 
 static void ieee80211_set_associated(struct ieee80211_sub_if_data *sdata,
-				     struct ieee80211_if_sta *ifsta)
+				     struct ieee80211_if_sta *ifsta,
+				     u32 bss_info_changed)
 {
 	struct ieee80211_local *local = sdata->local;
 	struct ieee80211_conf *conf = &local_to_hw(local)->conf;
-	u32 changed = BSS_CHANGED_ASSOC;
 
 	struct ieee80211_bss *bss;
 
+	bss_info_changed |= BSS_CHANGED_ASSOC;
 	ifsta->flags |= IEEE80211_STA_ASSOCIATED;
 
 	if (sdata->vif.type != NL80211_IFTYPE_STATION)
@@ -724,19 +725,12 @@ static void ieee80211_set_associated(str
 		sdata->bss_conf.timestamp = bss->timestamp;
 		sdata->bss_conf.dtim_period = bss->dtim_period;
 
-		changed |= ieee80211_handle_bss_capability(sdata,
+		bss_info_changed |= ieee80211_handle_bss_capability(sdata,
 			bss->capability, bss->has_erp_value, bss->erp_value);
 
 		ieee80211_rx_bss_put(local, bss);
 	}
 
-	if (conf->flags & IEEE80211_CONF_SUPPORT_HT_MODE) {
-		changed |= BSS_CHANGED_HT;
-		sdata->bss_conf.assoc_ht = 1;
-		sdata->bss_conf.ht_cap = &conf->ht_cap;
-		sdata->bss_conf.ht_bss_conf = &conf->ht_bss_conf;
-	}
-
 	ifsta->flags |= IEEE80211_STA_PREV_BSSID_SET;
 	memcpy(ifsta->prev_bssid, sdata->u.sta.bssid, ETH_ALEN);
 	ieee80211_sta_send_associnfo(sdata, ifsta);
@@ -750,8 +744,8 @@ static void ieee80211_set_associated(str
 	 * when we have associated, we aren't checking whether it actually
 	 * changed or not.
 	 */
-	changed |= BSS_CHANGED_BASIC_RATES;
-	ieee80211_bss_info_change_notify(sdata, changed);
+	bss_info_changed |= BSS_CHANGED_BASIC_RATES;
+	ieee80211_bss_info_change_notify(sdata, bss_info_changed);
 
 	netif_tx_start_all_queues(sdata->dev);
 	netif_carrier_on(sdata->dev);
@@ -819,7 +813,7 @@ static void ieee80211_set_disassoc(struc
 {
 	struct ieee80211_local *local = sdata->local;
 	struct sta_info *sta;
-	u32 changed = BSS_CHANGED_ASSOC;
+	u32 changed = 0;
 
 	rcu_read_lock();
 
@@ -853,15 +847,9 @@ static void ieee80211_set_disassoc(struc
 	ifsta->flags &= ~IEEE80211_STA_ASSOCIATED;
 	changed |= ieee80211_reset_erp_info(sdata);
 
-	if (sdata->bss_conf.assoc_ht)
-		changed |= BSS_CHANGED_HT;
-
-	sdata->bss_conf.assoc_ht = 0;
-	sdata->bss_conf.ht_cap = NULL;
-	sdata->bss_conf.ht_bss_conf = NULL;
-
 	ieee80211_led_assoc(local, 0);
-	sdata->bss_conf.assoc = 0;
+	changed |= BSS_CHANGED_ASSOC;
+	sdata->bss_conf.assoc = false;
 
 	ieee80211_sta_send_apinfo(sdata, ifsta);
 
@@ -873,6 +861,11 @@ static void ieee80211_set_disassoc(struc
 	rcu_read_unlock();
 
 	sta_info_destroy(sta);
+
+	local->hw.conf.ht.enabled = false;
+	ieee80211_hw_config(local, IEEE80211_CONF_CHANGE_HT);
+
+	ieee80211_bss_info_change_notify(sdata, changed);
 }
 
 static int ieee80211_sta_wep_configured(struct ieee80211_sub_if_data *sdata)
@@ -1196,6 +1189,7 @@ static void ieee80211_rx_mgmt_assoc_resp
 	struct ieee802_11_elems elems;
 	struct ieee80211_bss_conf *bss_conf = &sdata->bss_conf;
 	u8 *pos;
+	u32 changed = 0;
 	int i, j;
 	DECLARE_MAC_BUF(mac);
 	bool have_higher_than_11mbit = false;
@@ -1346,15 +1340,13 @@ static void ieee80211_rx_mgmt_assoc_resp
 	else
 		sdata->flags &= ~IEEE80211_SDATA_OPERATING_GMODE;
 
-	if (elems.ht_cap_elem && elems.ht_info_elem && elems.wmm_param &&
-	    (ifsta->flags & IEEE80211_STA_WMM_ENABLED)) {
-		struct ieee80211_ht_bss_info bss_info;
-		ieee80211_ht_cap_ie_to_sta_ht_cap(
+	if (elems.ht_cap_elem)
+		ieee80211_ht_cap_ie_to_sta_ht_cap(sband,
 				elems.ht_cap_elem, &sta->sta.ht_cap);
-		ieee80211_ht_info_ie_to_ht_bss_info(
-				elems.ht_info_elem, &bss_info);
-		ieee80211_handle_ht(local, &sta->sta.ht_cap, &bss_info);
-	}
+
+	if (elems.ht_info_elem && elems.wmm_param &&
+	    (ifsta->flags & IEEE80211_STA_WMM_ENABLED))
+		changed |= ieee80211_enable_ht(sdata, elems.ht_info_elem, sta);
 
 	rate_control_rate_init(sta);
 
@@ -1370,7 +1362,7 @@ static void ieee80211_rx_mgmt_assoc_resp
 	 * ieee80211_set_associated() will tell the driver */
 	bss_conf->aid = aid;
 	bss_conf->assoc_capability = capab_info;
-	ieee80211_set_associated(sdata, ifsta);
+	ieee80211_set_associated(sdata, ifsta, changed);
 
 	ieee80211_associated(sdata, ifsta);
 }
@@ -1673,7 +1665,6 @@ static void ieee80211_rx_mgmt_beacon(str
 	size_t baselen;
 	struct ieee802_11_elems elems;
 	struct ieee80211_local *local = sdata->local;
-	struct ieee80211_conf *conf = &local->hw.conf;
 	u32 changed = 0;
 	bool erp_valid;
 	u8 erp_value = 0;
@@ -1709,14 +1700,27 @@ static void ieee80211_rx_mgmt_beacon(str
 			le16_to_cpu(mgmt->u.beacon.capab_info),
 			erp_valid, erp_value);
 
-	if (elems.ht_cap_elem && elems.ht_info_elem &&
-	    elems.wmm_param && conf->flags & IEEE80211_CONF_SUPPORT_HT_MODE) {
-		struct ieee80211_ht_bss_info bss_info;
-
-		ieee80211_ht_info_ie_to_ht_bss_info(
-				elems.ht_info_elem, &bss_info);
-		changed |= ieee80211_handle_ht(local, &conf->ht_cap,
-					       &bss_info);
+
+	if (elems.ht_cap_elem && elems.ht_info_elem && elems.wmm_param) {
+		struct sta_info *sta;
+		struct ieee80211_supported_band *sband;
+
+		rcu_read_lock();
+
+		sta = sta_info_get(local, ifsta->bssid);
+		if (!sta) {
+			rcu_read_unlock();
+			return;
+		}
+
+		sband = local->hw.wiphy->bands[local->hw.conf.channel->band];
+
+		ieee80211_ht_cap_ie_to_sta_ht_cap(sband,
+				elems.ht_cap_elem, &sta->sta.ht_cap);
+
+		changed |= ieee80211_enable_ht(sdata, elems.ht_info_elem, sta);
+
+		rcu_read_unlock();
 	}
 
 	ieee80211_bss_info_change_notify(sdata, changed);
--- everything.orig/drivers/net/wireless/ath9k/main.c	2008-10-09 11:06:54.000000000 +0200
+++ everything/drivers/net/wireless/ath9k/main.c	2008-10-09 11:12:13.000000000 +0200
@@ -330,25 +330,15 @@ static void ath9k_ht_conf(struct ath_sof
 {
 	struct ath_ht_info *ht_info = &sc->sc_ht_info;
 
-	if (bss_conf->assoc_ht) {
-		ht_info->ext_chan_offset =
-			bss_conf->ht_bss_conf->bss_cap &
-				IEEE80211_HT_PARAM_CHA_SEC_OFFSET;
-
-		if (!(bss_conf->ht_cap->cap &
-			IEEE80211_HT_CAP_40MHZ_INTOLERANT) &&
-			    (bss_conf->ht_bss_conf->bss_cap &
-				IEEE80211_HT_PARAM_CHAN_WIDTH_ANY))
+	if (sc->hw->conf.ht.enabled) {
+		ht_info->ext_chan_offset = bss_conf->ht.secondary_channel_offset;
+
+		if (bss_conf->ht.width_40_ok)
 			ht_info->tx_chan_width = ATH9K_HT_MACMODE_2040;
 		else
 			ht_info->tx_chan_width = ATH9K_HT_MACMODE_20;
 
 		ath9k_hw_set11nmac2040(sc->sc_ah, ht_info->tx_chan_width);
-		ht_info->maxampdu = 1 << (IEEE80211_HTCAP_MAXRXAMPDU_FACTOR +
-					bss_conf->ht_cap->ampdu_factor);
-		ht_info->mpdudensity =
-			parse_mpdudensity(bss_conf->ht_cap->ampdu_density);
-
 	}
 }
 
@@ -391,7 +381,7 @@ static void ath9k_bss_assoc_info(struct 
 		sc->sc_halstats.ns_avgtxrate = ATH_RATE_DUMMY_MARKER;
 
 		/* Update chainmask */
-		ath_update_chainmask(sc, bss_conf->assoc_ht);
+		ath_update_chainmask(sc, hw->conf.ht.enabled);
 
 		DPRINTF(sc, ATH_DBG_CONFIG,
 			"%s: bssid %s aid 0x%x\n",
@@ -409,7 +399,7 @@ static void ath9k_bss_assoc_info(struct 
 			return;
 		}
 
-		if (hw->conf.ht_cap.ht_supported)
+		if (hw->conf.ht.enabled)
 			sc->sc_ah->ah_channels[pos].chanmode =
 				ath_get_extchanmode(sc, curchan);
 		else
@@ -532,7 +522,6 @@ int _ath_rx_indicate(struct ath_softc *s
 
 	if (an) {
 		ath_rx_input(sc, an,
-			     hw->conf.ht_cap.ht_supported,
 			     skb, status, &st);
 	}
 	if (!an || (st != ATH_RX_CONSUMED))
@@ -1242,6 +1231,9 @@ static int ath9k_config(struct ieee80211
 		__func__,
 		curchan->center_freq);
 
+	/* Update chainmask */
+	ath_update_chainmask(sc, conf->ht.enabled);
+
 	pos = ath_get_channel(sc, curchan);
 	if (pos == -1) {
 		DPRINTF(sc, ATH_DBG_FATAL, "%s: Invalid channel\n", __func__);
@@ -1252,7 +1244,7 @@ static int ath9k_config(struct ieee80211
 		(curchan->band == IEEE80211_BAND_2GHZ) ?
 		CHANNEL_G : CHANNEL_A;
 
-	if (sc->sc_curaid && hw->conf.ht_cap.ht_supported)
+	if (sc->sc_curaid && hw->conf.ht.enabled)
 		sc->sc_ah->ah_channels[pos].chanmode =
 			ath_get_extchanmode(sc, curchan);
 
@@ -1437,6 +1429,14 @@ static void ath9k_sta_notify(struct ieee
 		} else {
 			ath_node_get(sc, sta->addr);
 		}
+
+		/* XXX: Is this right? Can the capabilities change? */
+		an = ath_node_find(sc, sta->addr);
+		an->maxampdu = 1 << (IEEE80211_HTCAP_MAXRXAMPDU_FACTOR +
+					sta->ht_cap.ampdu_factor);
+		an->mpdudensity =
+			parse_mpdudensity(sta->ht_cap.ampdu_density);
+
 		spin_unlock_irqrestore(&sc->node_lock, flags);
 		break;
 	case STA_NOTIFY_REMOVE:
@@ -1555,9 +1555,8 @@ static void ath9k_bss_info_changed(struc
 	}
 
 	if (changed & BSS_CHANGED_HT) {
-		DPRINTF(sc, ATH_DBG_CONFIG, "%s: BSS Changed HT %d\n",
-			__func__,
-			bss_conf->assoc_ht);
+		DPRINTF(sc, ATH_DBG_CONFIG, "%s: BSS Changed HT\n",
+			__func__);
 		ath9k_ht_conf(sc, bss_conf);
 	}
 
--- everything.orig/drivers/net/wireless/iwlwifi/iwl-agn-rs.c	2008-10-09 11:06:54.000000000 +0200
+++ everything/drivers/net/wireless/iwlwifi/iwl-agn-rs.c	2008-10-09 11:12:13.000000000 +0200
@@ -1135,8 +1135,7 @@ static int rs_switch_to_mimo2(struct iwl
 	s32 rate;
 	s8 is_green = lq_sta->is_green;
 
-	if (!(conf->flags & IEEE80211_CONF_SUPPORT_HT_MODE) ||
-	    !sta->ht_cap.ht_supported)
+	if (!conf->ht.enabled || !sta->ht_cap.ht_supported)
 		return -1;
 
 	if (((sta->ht_cap.cap & IEEE80211_HT_CAP_SM_PS) >> 2)
@@ -1203,8 +1202,7 @@ static int rs_switch_to_siso(struct iwl_
 	u8 is_green = lq_sta->is_green;
 	s32 rate;
 
-	if (!(conf->flags & IEEE80211_CONF_SUPPORT_HT_MODE) ||
-	    !sta->ht_cap.ht_supported)
+	if (!conf->ht.enabled || !sta->ht_cap.ht_supported)
 		return -1;
 
 	IWL_DEBUG_RATE("LQ: try to switch to SISO\n");
@@ -2003,9 +2001,8 @@ lq_update:
 		 * stay with best antenna legacy modulation for a while
 		 * before next round of mode comparisons. */
 		tbl1 = &(lq_sta->lq_info[lq_sta->active_tbl]);
-		if (is_legacy(tbl1->lq_type) &&
-		   (!(conf->flags & IEEE80211_CONF_SUPPORT_HT_MODE)) &&
-		    (lq_sta->action_counter >= 1)) {
+		if (is_legacy(tbl1->lq_type) && !conf->ht.enabled &&
+		    lq_sta->action_counter >= 1) {
 			lq_sta->action_counter = 0;
 			IWL_DEBUG_RATE("LQ: STAY in legacy table\n");
 			rs_set_stay_in_table(priv, 1, lq_sta);
@@ -2244,19 +2241,19 @@ static void rs_rate_init(void *priv_r, s
 	 * active_siso_rate mask includes 9 MBits (bit 5), and CCK (bits 0-3),
 	 * supp_rates[] does not; shift to convert format, force 9 MBits off.
 	 */
-	lq_sta->active_siso_rate = conf->ht_cap.mcs.rx_mask[0] << 1;
-	lq_sta->active_siso_rate |= conf->ht_cap.mcs.rx_mask[0] & 0x1;
+	lq_sta->active_siso_rate = sta->ht_cap.mcs.rx_mask[0] << 1;
+	lq_sta->active_siso_rate |= sta->ht_cap.mcs.rx_mask[0] & 0x1;
 	lq_sta->active_siso_rate &= ~((u16)0x2);
 	lq_sta->active_siso_rate <<= IWL_FIRST_OFDM_RATE;
 
 	/* Same here */
-	lq_sta->active_mimo2_rate = conf->ht_cap.mcs.rx_mask[1] << 1;
-	lq_sta->active_mimo2_rate |= conf->ht_cap.mcs.rx_mask[1] & 0x1;
+	lq_sta->active_mimo2_rate = sta->ht_cap.mcs.rx_mask[1] << 1;
+	lq_sta->active_mimo2_rate |= sta->ht_cap.mcs.rx_mask[1] & 0x1;
 	lq_sta->active_mimo2_rate &= ~((u16)0x2);
 	lq_sta->active_mimo2_rate <<= IWL_FIRST_OFDM_RATE;
 
-	lq_sta->active_mimo3_rate = conf->ht_cap.mcs.rx_mask[2] << 1;
-	lq_sta->active_mimo3_rate |= conf->ht_cap.mcs.rx_mask[2] & 0x1;
+	lq_sta->active_mimo3_rate = sta->ht_cap.mcs.rx_mask[2] << 1;
+	lq_sta->active_mimo3_rate |= sta->ht_cap.mcs.rx_mask[2] & 0x1;
 	lq_sta->active_mimo3_rate &= ~((u16)0x2);
 	lq_sta->active_mimo3_rate <<= IWL_FIRST_OFDM_RATE;
 
--- everything.orig/drivers/net/wireless/iwlwifi/iwl-agn.c	2008-10-09 11:06:54.000000000 +0200
+++ everything/drivers/net/wireless/iwlwifi/iwl-agn.c	2008-10-09 12:23:04.000000000 +0200
@@ -553,17 +553,30 @@ static int iwl4965_send_beacon_cmd(struc
 static void iwl4965_ht_conf(struct iwl_priv *priv,
 			    struct ieee80211_bss_conf *bss_conf)
 {
-	struct ieee80211_sta_ht_cap *ht_conf = bss_conf->ht_cap;
-	struct ieee80211_ht_bss_info *ht_bss_conf = bss_conf->ht_bss_conf;
+	struct ieee80211_sta_ht_cap *ht_conf;
 	struct iwl_ht_info *iwl_conf = &priv->current_ht_config;
+	struct ieee80211_sta *sta;
 
 	IWL_DEBUG_MAC80211("enter: \n");
 
-	iwl_conf->is_ht = bss_conf->assoc_ht;
-
 	if (!iwl_conf->is_ht)
 		return;
 
+
+	/*
+	 * It is totally wrong to base global information on something
+	 * that is valid only when associated, alas, this driver works
+	 * that way and I don't know how to fix it.
+	 */
+
+	rcu_read_lock();
+	sta = ieee80211_find_sta(priv->hw, priv->bssid);
+	if (!sta) {
+		rcu_read_unlock();
+		return;
+	}
+	ht_conf = &sta->ht_cap;
+
 	if (ht_conf->cap & IEEE80211_HT_CAP_SGI_20)
 		iwl_conf->sgf |= HT_SHORT_GI_20MHZ;
 	if (ht_conf->cap & IEEE80211_HT_CAP_SGI_40)
@@ -575,8 +588,8 @@ static void iwl4965_ht_conf(struct iwl_p
 
 	iwl_conf->supported_chan_width =
 		!!(ht_conf->cap & IEEE80211_HT_CAP_SUP_WIDTH_20_40);
-	iwl_conf->extension_chan_offset =
-		ht_bss_conf->bss_cap & IEEE80211_HT_PARAM_CHA_SEC_OFFSET;
+
+	iwl_conf->extension_chan_offset = bss_conf->ht.secondary_channel_offset;
 	/* If no above or below channel supplied disable FAT channel */
 	if (iwl_conf->extension_chan_offset != IEEE80211_HT_PARAM_CHA_SEC_ABOVE &&
 	    iwl_conf->extension_chan_offset != IEEE80211_HT_PARAM_CHA_SEC_BELOW) {
@@ -588,15 +601,14 @@ static void iwl4965_ht_conf(struct iwl_p
 
 	memcpy(&iwl_conf->mcs, &ht_conf->mcs, 16);
 
-	iwl_conf->control_channel = ht_bss_conf->primary_channel;
-	iwl_conf->tx_chan_width =
-		!!(ht_bss_conf->bss_cap & IEEE80211_HT_PARAM_CHAN_WIDTH_ANY);
+	iwl_conf->tx_chan_width = bss_conf->ht.width_40_ok;
 	iwl_conf->ht_protection =
-		ht_bss_conf->bss_op_mode & IEEE80211_HT_OP_MODE_PROTECTION;
+		bss_conf->ht.operation_mode & IEEE80211_HT_OP_MODE_PROTECTION;
 	iwl_conf->non_GF_STA_present =
-		!!(ht_bss_conf->bss_op_mode & IEEE80211_HT_OP_MODE_NON_GF_STA_PRSNT);
+		!!(bss_conf->ht.operation_mode & IEEE80211_HT_OP_MODE_NON_GF_STA_PRSNT);
+
+	rcu_read_unlock();
 
-	IWL_DEBUG_MAC80211("control channel %d\n", iwl_conf->control_channel);
 	IWL_DEBUG_MAC80211("leave\n");
 }
 
@@ -2772,6 +2784,8 @@ static int iwl4965_mac_config(struct iee
 	mutex_lock(&priv->mutex);
 	IWL_DEBUG_MAC80211("enter to channel %d\n", conf->channel->hw_value);
 
+	priv->current_ht_config.is_ht = conf->ht.enabled;
+
 	if (conf->radio_enabled && iwl_radio_kill_sw_enable_radio(priv)) {
 		IWL_DEBUG_MAC80211("leave - RF-KILL - waiting for uCode\n");
 		goto out;
@@ -3133,7 +3147,6 @@ static void iwl4965_bss_info_changed(str
 	}
 
 	if (changes & BSS_CHANGED_HT) {
-		IWL_DEBUG_MAC80211("HT %d\n", bss_conf->assoc_ht);
 		iwl4965_ht_conf(priv, bss_conf);
 		iwl_set_rxon_chain(priv);
 	}
--- everything.orig/drivers/net/wireless/iwlwifi/iwl-sta.c	2008-10-09 11:06:54.000000000 +0200
+++ everything/drivers/net/wireless/iwlwifi/iwl-sta.c	2008-10-09 11:12:13.000000000 +0200
@@ -896,20 +896,31 @@ static void iwl_sta_init_lq(struct iwl_p
  */
 int iwl_rxon_add_station(struct iwl_priv *priv, const u8 *addr, int is_ap)
 {
+	struct ieee80211_sta *sta;
+	struct ieee80211_sta_ht_cap ht_config;
+	struct ieee80211_sta_ht_cap *cur_ht_config = NULL;
 	u8 sta_id;
 
 	/* Add station to device's station table */
-	struct ieee80211_conf *conf = &priv->hw->conf;
-	struct ieee80211_sta_ht_cap *cur_ht_config = &conf->ht_cap;
 
-	if ((is_ap) &&
-	    (conf->flags & IEEE80211_CONF_SUPPORT_HT_MODE) &&
-	    (priv->iw_mode == NL80211_IFTYPE_STATION))
-		sta_id = iwl_add_station_flags(priv, addr, is_ap,
-						   0, cur_ht_config);
-	else
-		sta_id = iwl_add_station_flags(priv, addr, is_ap,
-						   0, NULL);
+	/*
+	 * XXX: This check is definitely not correct, if we're an AP
+	 *	it'll always be false which is not what we want, but
+	 *	it doesn't look like iwlagn is prepared to be an HT
+	 *	AP anyway.
+	 */
+	if (priv->current_ht_config.is_ht) {
+		rcu_read_lock();
+		sta = ieee80211_find_sta(priv->hw, addr);
+		if (sta) {
+			memcpy(&ht_config, &sta->ht_cap, sizeof(ht_config));
+			cur_ht_config = &ht_config;
+		}
+		rcu_read_unlock();
+	}
+
+	sta_id = iwl_add_station_flags(priv, addr, is_ap,
+				       0, cur_ht_config);
 
 	/* Set up default rate scaling table in device's station table */
 	iwl_sta_init_lq(priv, addr, is_ap);
--- everything.orig/drivers/net/wireless/ath9k/core.h	2008-10-09 11:06:54.000000000 +0200
+++ everything/drivers/net/wireless/ath9k/core.h	2008-10-09 11:12:13.000000000 +0200
@@ -380,7 +380,6 @@ void ath_rx_cleanup(struct ath_softc *sc
 int ath_rx_tasklet(struct ath_softc *sc, int flush);
 int ath_rx_input(struct ath_softc *sc,
 		 struct ath_node *node,
-		 int is_ampdu,
 		 struct sk_buff *skb,
 		 struct ath_recv_status *rx_status,
 		 enum ATH_RX_TYPE *status);
@@ -650,6 +649,9 @@ struct ath_node {
 	u8 an_smmode; /* SM Power save mode */
 	u8 an_flags;
 	u8 an_addr[ETH_ALEN];
+
+	u16 maxampdu;
+	u8 mpdudensity;
 };
 
 void ath_tx_resume_tid(struct ath_softc *sc,
@@ -919,8 +921,6 @@ enum RATE_TYPE {
 
 struct ath_ht_info {
 	enum ath9k_ht_macmode tx_chan_width;
-	u16 maxampdu;
-	u8 mpdudensity;
 	u8 ext_chan_offset;
 };
 
--- everything.orig/drivers/net/wireless/ath9k/recv.c	2008-10-09 11:06:54.000000000 +0200
+++ everything/drivers/net/wireless/ath9k/recv.c	2008-10-09 11:12:13.000000000 +0200
@@ -720,12 +720,11 @@ void ath_flushrecv(struct ath_softc *sc)
 
 int ath_rx_input(struct ath_softc *sc,
 		 struct ath_node *an,
-		 int is_ampdu,
 		 struct sk_buff *skb,
 		 struct ath_recv_status *rx_status,
 		 enum ATH_RX_TYPE *status)
 {
-	if (is_ampdu && (sc->sc_flags & SC_OP_RXAGGR)) {
+	if (sc->sc_flags & SC_OP_RXAGGR) {
 		*status = ATH_RX_CONSUMED;
 		return ath_ampdu_input(sc, an, skb, rx_status);
 	} else {
--- everything.orig/net/mac80211/ieee80211_i.h	2008-10-09 11:06:54.000000000 +0200
+++ everything/net/mac80211/ieee80211_i.h	2008-10-09 12:23:04.000000000 +0200
@@ -963,14 +963,12 @@ int ieee80211_monitor_start_xmit(struct 
 int ieee80211_subif_start_xmit(struct sk_buff *skb, struct net_device *dev);
 
 /* HT */
-void ieee80211_ht_cap_ie_to_sta_ht_cap(struct ieee80211_ht_cap *ht_cap_ie,
+void ieee80211_ht_cap_ie_to_sta_ht_cap(struct ieee80211_supported_band *sband,
+				       struct ieee80211_ht_cap *ht_cap_ie,
 				       struct ieee80211_sta_ht_cap *ht_cap);
-void ieee80211_ht_info_ie_to_ht_bss_info(
-			struct ieee80211_ht_info *ht_add_info_ie,
-			struct ieee80211_ht_bss_info *bss_info);
-u32 ieee80211_handle_ht(struct ieee80211_local *local,
-			struct ieee80211_sta_ht_cap *req_ht_cap,
-			struct ieee80211_ht_bss_info *req_bss_cap);
+u32 ieee80211_enable_ht(struct ieee80211_sub_if_data *sdata,
+			struct ieee80211_ht_info *hti,
+			struct sta_info *ap);
 void ieee80211_send_bar(struct ieee80211_sub_if_data *sdata, u8 *ra, u16 tid, u16 ssn);
 
 void ieee80211_sta_stop_rx_ba_session(struct ieee80211_sub_if_data *sdata, u8 *da,
--- everything.orig/drivers/net/wireless/ath9k/rc.c	2008-10-09 11:06:54.000000000 +0200
+++ everything/drivers/net/wireless/ath9k/rc.c	2008-10-09 11:12:13.000000000 +0200
@@ -1838,7 +1838,7 @@ void ath_rc_node_update(struct ieee80211
 	struct ath_softc *sc = hw->priv;
 	u32 capflag = 0;
 
-	if (hw->conf.ht_cap.ht_supported) {
+	if (hw->conf.ht.enabled) {
 		capflag |= ATH_RC_HT_FLAG | ATH_RC_DS_FLAG;
 		if (sc->sc_ht_info.tx_chan_width == ATH9K_HT_MACMODE_2040)
 			capflag |= ATH_RC_CW40_FLAG;
@@ -1980,7 +1980,7 @@ static void ath_get_rate(void *priv, str
 
 	/* Check if aggregation has to be enabled for this tid */
 
-	if (hw->conf.ht_cap.ht_supported) {
+	if (hw->conf.ht.enabled) {
 		if (ieee80211_is_data_qos(fc)) {
 			qc = ieee80211_get_qos_ctl(hdr);
 			tid = qc[0] & 0xf;
@@ -2027,9 +2027,9 @@ static void ath_rate_init(void *priv, st
 	DPRINTF(sc, ATH_DBG_RATE, "%s\n", __func__);
 
 	ath_setup_rates(sc, sband, sta, ath_rc_priv);
-	if (sc->hw->conf.flags & IEEE80211_CONF_SUPPORT_HT_MODE) {
+	if (sc->hw->conf.ht.enabled) {
 		for (i = 0; i < 77; i++) {
-			if (sc->hw->conf.ht_cap.mcs.rx_mask[i/8] & (1<<(i%8)))
+			if (sta->ht_cap.mcs.rx_mask[i/8] & (1<<(i%8)))
 				ath_rc_priv->neg_ht_rates.rs_rates[j++] = i;
 			if (j == ATH_RATE_MAX)
 				break;
--- everything.orig/drivers/net/wireless/ath9k/xmit.c	2008-10-09 11:06:54.000000000 +0200
+++ everything/drivers/net/wireless/ath9k/xmit.c	2008-10-09 11:12:13.000000000 +0200
@@ -300,7 +300,8 @@ static int ath_tx_prepare(struct ath_sof
 	if (ieee80211_is_data(fc) && !txctl->use_minrate) {
 
 		/* Enable HT only for DATA frames and not for EAPOL */
-		txctl->ht = (hw->conf.ht_cap.ht_supported &&
+		/* XXX why AMPDU only?? */
+		txctl->ht = (hw->conf.ht.enabled &&
 			    (tx_info->flags & IEEE80211_TX_CTL_AMPDU));
 
 		if (is_multicast_ether_addr(hdr->addr1)) {
@@ -1450,7 +1451,8 @@ static int ath_tx_send_ampdu(struct ath_
  */
 
 static u32 ath_lookup_rate(struct ath_softc *sc,
-				 struct ath_buf *bf)
+			   struct ath_buf *bf,
+			   struct ath_atx_tid *tid)
 {
 	const struct ath9k_rate_table *rt = sc->sc_currates;
 	struct sk_buff *skb;
@@ -1504,7 +1506,7 @@ static u32 ath_lookup_rate(struct ath_so
 	 * The IE, however can hold upto 65536, which shows up here
 	 * as zero. Ignore 65536 since we  are constrained by hw.
 	 */
-	maxampdu = sc->sc_ht_info.maxampdu;
+	maxampdu = tid->an->maxampdu;
 	if (maxampdu)
 		aggr_limit = min(aggr_limit, maxampdu);
 
@@ -1518,6 +1520,7 @@ static u32 ath_lookup_rate(struct ath_so
  */
 
 static int ath_compute_num_delims(struct ath_softc *sc,
+				  struct ath_atx_tid *tid,
 				  struct ath_buf *bf,
 				  u16 frmlen)
 {
@@ -1545,7 +1548,7 @@ static int ath_compute_num_delims(struct
 	 * required minimum length for subframe. Take into account
 	 * whether high rate is 20 or 40Mhz and half or full GI.
 	 */
-	mpdudensity = sc->sc_ht_info.mpdudensity;
+	mpdudensity = tid->an->mpdudensity;
 
 	/*
 	 * If there is no mpdu density restriction, no further calculation
@@ -1619,7 +1622,7 @@ static enum ATH_AGGR_STATUS ath_tx_form_
 		}
 
 		if (!rl) {
-			aggr_limit = ath_lookup_rate(sc, bf);
+			aggr_limit = ath_lookup_rate(sc, bf, tid);
 			rl = 1;
 			/*
 			 * Is rate dual stream
@@ -1657,7 +1660,7 @@ static enum ATH_AGGR_STATUS ath_tx_form_
 		 * Get the delimiters needed to meet the MPDU
 		 * density for this node.
 		 */
-		ndelim = ath_compute_num_delims(sc, bf_first, bf->bf_frmlen);
+		ndelim = ath_compute_num_delims(sc, tid, bf_first, bf->bf_frmlen);
 
 		bpad = PADBYTES(al_delta) + (ndelim << 2);
 
@@ -2630,7 +2633,7 @@ void ath_tx_node_init(struct ath_softc *
 		struct ath_atx_ac *ac;
 		int tidno, acno;
 
-		sc->sc_ht_info.maxampdu = ATH_AMPDU_LIMIT_DEFAULT;
+		an->maxampdu = ATH_AMPDU_LIMIT_DEFAULT;
 
 		/*
 		 * Init per tid tx state
--- everything.orig/drivers/net/wireless/iwlwifi/iwl-dev.h	2008-10-09 11:06:54.000000000 +0200
+++ everything/drivers/net/wireless/iwlwifi/iwl-dev.h	2008-10-09 11:12:13.000000000 +0200
@@ -414,7 +414,6 @@ struct iwl_ht_info {
 	u8 mpdu_density;
 	struct ieee80211_mcs_info mcs;
 	/* BSS related data */
-	u8 control_channel;
 	u8 extension_chan_offset;
 	u8 tx_chan_width;
 	u8 ht_protection;
--- everything.orig/drivers/net/wireless/iwlwifi/iwl-core.c	2008-10-09 11:06:54.000000000 +0200
+++ everything/drivers/net/wireless/iwlwifi/iwl-core.c	2008-10-09 12:23:04.000000000 +0200
@@ -637,8 +637,8 @@ u8 iwl_is_fat_tx_allowed(struct iwl_priv
 	}
 
 	return iwl_is_channel_extension(priv, priv->band,
-					 iwl_ht_conf->control_channel,
-					 iwl_ht_conf->extension_chan_offset);
+					le16_to_cpu(priv->staging_rxon.channel),
+					iwl_ht_conf->extension_chan_offset);
 }
 EXPORT_SYMBOL(iwl_is_fat_tx_allowed);
 
@@ -663,13 +663,6 @@ void iwl_set_rxon_ht(struct iwl_priv *pr
 		rxon->flags &= ~(RXON_FLG_CHANNEL_MODE_MIXED_MSK |
 				 RXON_FLG_CHANNEL_MODE_PURE_40_MSK);
 
-	if (le16_to_cpu(rxon->channel) != ht_info->control_channel) {
-		IWL_DEBUG_ASSOC("control diff than current %d %d\n",
-				le16_to_cpu(rxon->channel),
-				ht_info->control_channel);
-		return;
-	}
-
 	/* Note: control channel is opposite of extension channel */
 	switch (ht_info->extension_chan_offset) {
 	case IEEE80211_HT_PARAM_CHA_SEC_ABOVE:
@@ -692,14 +685,12 @@ void iwl_set_rxon_ht(struct iwl_priv *pr
 
 	IWL_DEBUG_ASSOC("supported HT rate 0x%X 0x%X 0x%X "
 			"rxon flags 0x%X operation mode :0x%X "
-			"extension channel offset 0x%x "
-			"control chan %d\n",
+			"extension channel offset 0x%x\n",
 			ht_info->mcs.rx_mask[0],
 			ht_info->mcs.rx_mask[1],
 			ht_info->mcs.rx_mask[2],
 			le32_to_cpu(rxon->flags), ht_info->ht_protection,
-			ht_info->extension_chan_offset,
-			ht_info->control_channel);
+			ht_info->extension_chan_offset);
 	return;
 }
 EXPORT_SYMBOL(iwl_set_rxon_ht);
--- everything.orig/net/mac80211/cfg.c	2008-10-09 11:06:53.000000000 +0200
+++ everything/net/mac80211/cfg.c	2008-10-09 12:23:03.000000000 +0200
@@ -584,6 +584,8 @@ static void sta_apply_parameters(struct 
 	struct ieee80211_supported_band *sband;
 	struct ieee80211_sub_if_data *sdata = sta->sdata;
 
+	sband = local->hw.wiphy->bands[local->oper_channel->band];
+
 	/*
 	 * FIXME: updating the flags is racy when this function is
 	 *	  called from ieee80211_change_station(), this will
@@ -624,7 +626,6 @@ static void sta_apply_parameters(struct 
 
 	if (params->supported_rates) {
 		rates = 0;
-		sband = local->hw.wiphy->bands[local->oper_channel->band];
 
 		for (i = 0; i < params->supported_rates_len; i++) {
 			int rate = (params->supported_rates[i] & 0x7f) * 5;
@@ -637,7 +638,8 @@ static void sta_apply_parameters(struct 
 	}
 
 	if (params->ht_capa)
-		ieee80211_ht_cap_ie_to_sta_ht_cap(params->ht_capa,
+		ieee80211_ht_cap_ie_to_sta_ht_cap(sband,
+						  params->ht_capa,
 						  &sta->sta.ht_cap);
 
 	if (ieee80211_vif_is_mesh(&sdata->vif) && params->plink_action) {


