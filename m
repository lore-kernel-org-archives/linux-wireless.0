Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from paleale.coelho.fi ([176.9.41.70]:54510 "EHLO
        farmhouse.coelho.fi" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1956648AbdDZH7I (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 26 Apr 2017 03:59:08 -0400
From: Luca Coelho <luca@coelho.fi>
To: linux-wireless@vger.kernel.org
Cc: johannes@sipsolutions.net, Avraham Stern <avraham.stern@intel.com>,
        Luca Coelho <luciano.coelho@intel.com>
Date: Wed, 26 Apr 2017 10:58:47 +0300
Message-Id: <20170426075854.13546-3-luca@coelho.fi> (sfid-20170426_095926_065314_9D0A038B)
In-Reply-To: <20170426075854.13546-1-luca@coelho.fi>
References: <20170426075854.13546-1-luca@coelho.fi>
Subject: [PATCH 2/9] mac80211: Add support for BSS max idle period element
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Avraham Stern <avraham.stern@intel.com>

Parse the BSS max idle period element and set the BSS configuration
accordingly so the driver can use this information to configure the
max idle period and to use protected management frames for keep alive
when required.

The BSS max idle period element is defined in IEEE802.11-2016,
section 9.4.2.79

Signed-off-by: Avraham Stern <avraham.stern@intel.com>
Signed-off-by: Luca Coelho <luciano.coelho@intel.com>
---
 include/linux/ieee80211.h  | 28 +++++++++++++++++++++++++++-
 include/net/mac80211.h     | 14 +++++++++++++-
 net/mac80211/ieee80211_i.h |  1 +
 net/mac80211/mlme.c        | 14 +++++++++++++-
 net/mac80211/util.c        |  9 +++++++++
 5 files changed, 63 insertions(+), 3 deletions(-)

diff --git a/include/linux/ieee80211.h b/include/linux/ieee80211.h
index 23e095fa6701..c916ba4a22d4 100644
--- a/include/linux/ieee80211.h
+++ b/include/linux/ieee80211.h
@@ -7,7 +7,7 @@
  * Copyright (c) 2005, Devicescape Software, Inc.
  * Copyright (c) 2006, Michael Wu <flamingice@sourmilk.net>
  * Copyright (c) 2013 - 2014 Intel Mobile Communications GmbH
- * Copyright (c) 2016 Intel Deutschland GmbH
+ * Copyright (c) 2016 - 2017 Intel Deutschland GmbH
  *
  * This program is free software; you can redistribute it and/or modify
  * it under the terms of the GNU General Public License version 2 as
@@ -2316,6 +2316,32 @@ struct ieee80211_timeout_interval_ie {
 	__le32 value;
 } __packed;
 
+/**
+ * enum ieee80211_idle_options - BSS idle options
+ * @WLAN_IDLE_OPTIONS_PROTECTED_KEEP_ALIVE: the station should send an RSN
+ *	protected frame to the AP to reset the idle timer at the AP for
+ *	the station.
+ */
+enum ieee80211_idle_options {
+	WLAN_IDLE_OPTIONS_PROTECTED_KEEP_ALIVE = BIT(0),
+};
+
+/**
+ * struct ieee80211_bss_max_idle_period_ie
+ *
+ * This structure refers to "BSS Max idle period element"
+ *
+ * @max_idle_period: indicates the time period during which a station can
+ *	refrain from transmitting frames to its associated AP without being
+ *	disassociated. In units of 1000 TUs.
+ * @idle_options: indicates the options associated with the BSS idle capability
+ *	as specified in &enum ieee80211_idle_options.
+ */
+struct ieee80211_bss_max_idle_period_ie {
+	__le16 max_idle_period;
+	u8 idle_options;
+} __packed;
+
 /* BACK action code */
 enum ieee80211_back_actioncode {
 	WLAN_ACTION_ADDBA_REQ = 0,
diff --git a/include/net/mac80211.h b/include/net/mac80211.h
index b1ac872dc88a..66e602d501e5 100644
--- a/include/net/mac80211.h
+++ b/include/net/mac80211.h
@@ -5,7 +5,7 @@
  * Copyright 2006-2007	Jiri Benc <jbenc@suse.cz>
  * Copyright 2007-2010	Johannes Berg <johannes@sipsolutions.net>
  * Copyright 2013-2014  Intel Mobile Communications GmbH
- * Copyright (C) 2015 - 2016 Intel Deutschland GmbH
+ * Copyright (C) 2015 - 2017 Intel Deutschland GmbH
  *
  * This program is free software; you can redistribute it and/or modify
  * it under the terms of the GNU General Public License version 2 as
@@ -299,6 +299,8 @@ struct ieee80211_vif_chanctx_switch {
  *	context had been assigned.
  * @BSS_CHANGED_OCB: OCB join status changed
  * @BSS_CHANGED_MU_GROUPS: VHT MU-MIMO group id or user position changed
+ * @BSS_CHANGED_KEEP_ALIVE: keep alive options (idle period or protected
+ *	keep alive) changed.
  */
 enum ieee80211_bss_change {
 	BSS_CHANGED_ASSOC		= 1<<0,
@@ -325,6 +327,7 @@ enum ieee80211_bss_change {
 	BSS_CHANGED_BANDWIDTH		= 1<<21,
 	BSS_CHANGED_OCB                 = 1<<22,
 	BSS_CHANGED_MU_GROUPS		= 1<<23,
+	BSS_CHANGED_KEEP_ALIVE		= 1<<24,
 
 	/* when adding here, make sure to change ieee80211_reconfig */
 };
@@ -533,6 +536,13 @@ struct ieee80211_mu_group_data {
  * @allow_p2p_go_ps: indication for AP or P2P GO interface, whether it's allowed
  *	to use P2P PS mechanism or not. AP/P2P GO is not allowed to use P2P PS
  *	if it has associated clients without P2P PS support.
+ * @max_idle_period: the time period during which the station can refrain from
+ *	transmitting frames to its associated AP without being disassociated.
+ *	In units of 1000 TUs. Zero value indicates that the AP did not include
+ *	a (valid) BSS Max Idle Period Element.
+ * @protected_keep_alive: if set, indicates that the station should send an RSN
+ *	protected frame to the AP to reset the idle timer at the AP for the
+ *	station.
  */
 struct ieee80211_bss_conf {
 	const u8 *bssid;
@@ -573,6 +583,8 @@ struct ieee80211_bss_conf {
 	enum nl80211_tx_power_setting txpower_type;
 	struct ieee80211_p2p_noa_attr p2p_noa_attr;
 	bool allow_p2p_go_ps;
+	u16 max_idle_period;
+	bool protected_keep_alive;
 };
 
 /**
diff --git a/net/mac80211/ieee80211_i.h b/net/mac80211/ieee80211_i.h
index cf6d5abb65a3..476570175a12 100644
--- a/net/mac80211/ieee80211_i.h
+++ b/net/mac80211/ieee80211_i.h
@@ -1477,6 +1477,7 @@ struct ieee802_11_elems {
 	const u8 *opmode_notif;
 	const struct ieee80211_sec_chan_offs_ie *sec_chan_offs;
 	const struct ieee80211_mesh_chansw_params_ie *mesh_chansw_params_ie;
+	const struct ieee80211_bss_max_idle_period_ie *max_idle_period_ie;
 
 	/* length of them, respectively */
 	u8 ext_capab_len;
diff --git a/net/mac80211/mlme.c b/net/mac80211/mlme.c
index 24d69bcf71ad..93ecbd84d4fc 100644
--- a/net/mac80211/mlme.c
+++ b/net/mac80211/mlme.c
@@ -6,7 +6,7 @@
  * Copyright 2006-2007	Jiri Benc <jbenc@suse.cz>
  * Copyright 2007, Michael Wu <flamingice@sourmilk.net>
  * Copyright 2013-2014  Intel Mobile Communications GmbH
- * Copyright (C) 2015 - 2016 Intel Deutschland GmbH
+ * Copyright (C) 2015 - 2017 Intel Deutschland GmbH
  *
  * This program is free software; you can redistribute it and/or modify
  * it under the terms of the GNU General Public License version 2 as
@@ -3088,6 +3088,18 @@ static bool ieee80211_assoc_success(struct ieee80211_sub_if_data *sdata,
 	}
 	changed |= BSS_CHANGED_QOS;
 
+	if (elems.max_idle_period_ie) {
+		bss_conf->max_idle_period =
+			le16_to_cpu(elems.max_idle_period_ie->max_idle_period);
+		bss_conf->protected_keep_alive =
+			!!(elems.max_idle_period_ie->idle_options &
+			   WLAN_IDLE_OPTIONS_PROTECTED_KEEP_ALIVE);
+		changed |= BSS_CHANGED_KEEP_ALIVE;
+	} else {
+		bss_conf->max_idle_period = 0;
+		bss_conf->protected_keep_alive = false;
+	}
+
 	/* set AID and assoc capability,
 	 * ieee80211_set_associated() will tell the driver */
 	bss_conf->aid = aid;
diff --git a/net/mac80211/util.c b/net/mac80211/util.c
index 7a37ce78bb38..1b8e54444c36 100644
--- a/net/mac80211/util.c
+++ b/net/mac80211/util.c
@@ -828,6 +828,7 @@ u32 ieee802_11_parse_elems_crc(const u8 *start, size_t len, bool action,
 		case WLAN_EID_EXT_CAPABILITY:
 		case WLAN_EID_CHAN_SWITCH_TIMING:
 		case WLAN_EID_LINK_ID:
+		case WLAN_EID_BSS_MAX_IDLE_PERIOD:
 		/*
 		 * not listing WLAN_EID_CHANNEL_SWITCH_WRAPPER -- it seems possible
 		 * that if the content gets bigger it might be needed more than once
@@ -1089,6 +1090,10 @@ u32 ieee802_11_parse_elems_crc(const u8 *start, size_t len, bool action,
 			else
 				elem_parse_failed = true;
 			break;
+		case WLAN_EID_BSS_MAX_IDLE_PERIOD:
+			if (elen >= sizeof(*elems->max_idle_period_ie))
+				elems->max_idle_period_ie = (void *)pos;
+			break;
 		default:
 			break;
 		}
@@ -1983,6 +1988,10 @@ int ieee80211_reconfig(struct ieee80211_local *local)
 			if (sdata->u.mgd.have_beacon)
 				changed |= BSS_CHANGED_BEACON_INFO;
 
+			if (sdata->vif.bss_conf.max_idle_period ||
+			    sdata->vif.bss_conf.protected_keep_alive)
+				changed |= BSS_CHANGED_KEEP_ALIVE;
+
 			sdata_lock(sdata);
 			ieee80211_bss_info_change_notify(sdata, changed);
 			sdata_unlock(sdata);
-- 
2.11.0
