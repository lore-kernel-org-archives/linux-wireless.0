Return-Path: <SRS0=Ms0V=QP=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4E2D6C282CB
	for <linux-wireless@archiver.kernel.org>; Fri,  8 Feb 2019 13:15:54 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 1CF8D218AC
	for <linux-wireless@archiver.kernel.org>; Fri,  8 Feb 2019 13:15:54 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727563AbfBHNPu (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Fri, 8 Feb 2019 08:15:50 -0500
Received: from s3.sipsolutions.net ([144.76.43.62]:48716 "EHLO
        sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726456AbfBHNPr (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 8 Feb 2019 08:15:47 -0500
Received: by sipsolutions.net with esmtpsa (TLS1.2:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92-RC4)
        (envelope-from <johannes@sipsolutions.net>)
        id 1gs60P-0008Jb-4U; Fri, 08 Feb 2019 14:15:45 +0100
From:   Johannes Berg <johannes@sipsolutions.net>
To:     linux-wireless@vger.kernel.org
Cc:     Sara Sharon <sara.sharon@intel.com>
Subject: [PATCH v8 10/15] mac80211: support multi-bssid
Date:   Fri,  8 Feb 2019 14:15:34 +0100
Message-Id: <20190208131539.6813-10-johannes@sipsolutions.net>
X-Mailer: git-send-email 2.17.2
In-Reply-To: <20190208131539.6813-1-johannes@sipsolutions.net>
References: <20190208131539.6813-1-johannes@sipsolutions.net>
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

From: Sara Sharon <sara.sharon@intel.com>

Add support for multi-bssid.

This includes:
- Parsing multi-bssid element
- Overriding DTIM values
- Taking into account in various places the inner BSSID instead of
  transmitter BSSID
- Save aside some multi-bssid properties needed by drivers

Signed-off-by: Sara Sharon <sara.sharon@intel.com>
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 include/linux/ieee80211.h  |  34 +++++++++-
 include/net/mac80211.h     |  15 +++++
 net/mac80211/ieee80211_i.h |   7 +++
 net/mac80211/mlme.c        | 125 ++++++++++++++++++++++++++-----------
 net/mac80211/scan.c        |  11 +++-
 net/mac80211/util.c        | 111 +++++++++++++++++++++++++++++---
 6 files changed, 255 insertions(+), 48 deletions(-)

diff --git a/include/linux/ieee80211.h b/include/linux/ieee80211.h
index 4e3a4e293348..7479f0bd50e1 100644
--- a/include/linux/ieee80211.h
+++ b/include/linux/ieee80211.h
@@ -8,7 +8,7 @@
  * Copyright (c) 2006, Michael Wu <flamingice@sourmilk.net>
  * Copyright (c) 2013 - 2014 Intel Mobile Communications GmbH
  * Copyright (c) 2016 - 2017 Intel Deutschland GmbH
- * Copyright (c) 2018        Intel Corporation
+ * Copyright (c) 2018 - 2019 Intel Corporation
  *
  * This program is free software; you can redistribute it and/or modify
  * it under the terms of the GNU General Public License version 2 as
@@ -2475,6 +2475,7 @@ enum ieee80211_eid_ext {
 	WLAN_EID_EXT_HE_OPERATION = 36,
 	WLAN_EID_EXT_UORA = 37,
 	WLAN_EID_EXT_HE_MU_EDCA = 38,
+	WLAN_EID_EXT_MULTIPLE_BSSID_CONFIGURATION = 55,
 };
 
 /* Action category code */
@@ -2691,6 +2692,9 @@ enum ieee80211_tdls_actioncode {
 #define WLAN_EXT_CAPA10_TWT_REQUESTER_SUPPORT	BIT(5)
 #define WLAN_EXT_CAPA10_TWT_RESPONDER_SUPPORT	BIT(6)
 
+/* Defines support for enhanced multi-bssid advertisement*/
+#define WLAN_EXT_CAPA11_EMA_SUPPORT	BIT(1)
+
 /* TDLS specific payload type in the LLC/SNAP header */
 #define WLAN_TDLS_SNAP_RFTYPE	0x2
 
@@ -2882,6 +2886,34 @@ enum ieee80211_sa_query_action {
 	WLAN_ACTION_SA_QUERY_RESPONSE = 1,
 };
 
+/**
+ * struct ieee80211_bssid_index
+ *
+ * This structure refers to "Multiple BSSID-index element"
+ *
+ * @bssid_index: BSSID index
+ * @dtim_period: optional, overrides transmitted BSS dtim period
+ * @dtim_count: optional, overrides transmitted BSS dtim count
+ */
+struct ieee80211_bssid_index {
+	u8 bssid_index;
+	u8 dtim_period;
+	u8 dtim_count;
+};
+
+/**
+ * struct ieee80211_multiple_bssid_configuration
+ *
+ * This structure refers to "Multiple BSSID Configuration element"
+ *
+ * @bssid_count: total number of active BSSIDs in the set
+ * @profile_periodicity: the least number of beacon frames need to be received
+ *	in order to discover all the nontransmitted BSSIDs in the set.
+ */
+struct ieee80211_multiple_bssid_configuration {
+	u8 bssid_count;
+	u8 profile_periodicity;
+};
 
 #define SUITE(oui, id)	(((oui) << 8) | (id))
 
diff --git a/include/net/mac80211.h b/include/net/mac80211.h
index de866a7253c9..b0e364f50285 100644
--- a/include/net/mac80211.h
+++ b/include/net/mac80211.h
@@ -591,6 +591,14 @@ struct ieee80211_ftm_responder_params {
  * @ftm_responder: whether to enable or disable fine timing measurement FTM
  *	responder functionality.
  * @ftmr_params: configurable lci/civic parameter when enabling FTM responder.
+ * @nontransmitted: this BSS is a nontransmitted BSS profile
+ * @transmitter_bssid: the address of transmitter AP
+ * @bssid_index: index inside the multiple BSSID set
+ * @bssid_indicator: 2^bssid_indicator is the maximum number of APs in set
+ * @ema_ap: AP supports enhancements of discovery and advertisement of
+ *	nontransmitted BSSIDs
+ * @profile_periodicity: the least number of beacon frames need to be received
+ *	in order to discover all the nontransmitted BSSIDs in the set.
  */
 struct ieee80211_bss_conf {
 	const u8 *bssid;
@@ -644,6 +652,13 @@ struct ieee80211_bss_conf {
 	bool protected_keep_alive;
 	bool ftm_responder;
 	struct ieee80211_ftm_responder_params *ftmr_params;
+	/* Multiple BSSID data */
+	bool nontransmitted;
+	u8 transmitter_bssid[ETH_ALEN];
+	u8 bssid_index;
+	u8 bssid_indicator;
+	bool ema_ap;
+	u8 profile_periodicity;
 };
 
 /**
diff --git a/net/mac80211/ieee80211_i.h b/net/mac80211/ieee80211_i.h
index cc3f833db022..5795eef98771 100644
--- a/net/mac80211/ieee80211_i.h
+++ b/net/mac80211/ieee80211_i.h
@@ -1495,6 +1495,12 @@ struct ieee802_11_elems {
 	const struct ieee80211_sec_chan_offs_ie *sec_chan_offs;
 	struct ieee80211_mesh_chansw_params_ie *mesh_chansw_params_ie;
 	const struct ieee80211_bss_max_idle_period_ie *max_idle_period_ie;
+	const struct ieee80211_multiple_bssid_configuration *mbssid_config_ie;
+	const struct ieee80211_bssid_index *bssid_index;
+	const u8 *nontransmitted_bssid_profile;
+	u8 max_bssid_indicator;
+	u8 dtim_count;
+	u8 dtim_period;
 
 	/* length of them, respectively */
 	u8 ext_capab_len;
@@ -1513,6 +1519,7 @@ struct ieee802_11_elems {
 	u8 prep_len;
 	u8 perr_len;
 	u8 country_elem_len;
+	u8 bssid_index_len;
 
 	/* whether a parse error occurred while retrieving these elements */
 	bool parse_error;
diff --git a/net/mac80211/mlme.c b/net/mac80211/mlme.c
index 1f41f760bd22..64b6ddb67456 100644
--- a/net/mac80211/mlme.c
+++ b/net/mac80211/mlme.c
@@ -3308,6 +3308,14 @@ static bool ieee80211_assoc_success(struct ieee80211_sub_if_data *sdata,
 		/* TODO: OPEN: what happens if BSS color disable is set? */
 	}
 
+	if (cbss->transmitted_bss) {
+		bss_conf->nontransmitted = true;
+		ether_addr_copy(bss_conf->transmitter_bssid,
+				cbss->transmitted_bss->bssid);
+		bss_conf->bssid_indicator = cbss->max_bssid_indicator;
+		bss_conf->bssid_index = cbss->bssid_index;
+	}
+
 	/*
 	 * Some APs, e.g. Netgear WNDR3700, report invalid HT operation data
 	 * in their association response, so ignore that data for our own
@@ -3692,6 +3700,16 @@ static void ieee80211_handle_beacon_sig(struct ieee80211_sub_if_data *sdata,
 	}
 }
 
+static bool ieee80211_rx_our_beacon(const u8 *tx_bssid,
+				    struct cfg80211_bss *bss)
+{
+	if (ether_addr_equal(tx_bssid, bss->bssid))
+		return true;
+	if (!bss->transmitted_bss)
+		return false;
+	return ether_addr_equal(tx_bssid, bss->transmitted_bss->bssid);
+}
+
 static void ieee80211_rx_mgmt_beacon(struct ieee80211_sub_if_data *sdata,
 				     struct ieee80211_mgmt *mgmt, size_t len,
 				     struct ieee80211_rx_status *rx_status)
@@ -3733,17 +3751,16 @@ static void ieee80211_rx_mgmt_beacon(struct ieee80211_sub_if_data *sdata,
 	rcu_read_unlock();
 
 	if (ifmgd->assoc_data && ifmgd->assoc_data->need_beacon &&
-	    ether_addr_equal(mgmt->bssid, ifmgd->assoc_data->bss->bssid)) {
+	    ieee80211_rx_our_beacon(mgmt->bssid, ifmgd->assoc_data->bss)) {
 		ieee802_11_parse_elems(mgmt->u.beacon.variable,
 				       len - baselen, false, &elems,
 				       mgmt->bssid,
 				       ifmgd->assoc_data->bss->bssid);
 
 		ieee80211_rx_bss_info(sdata, mgmt, len, rx_status);
-		if (elems.tim && !elems.parse_error) {
-			const struct ieee80211_tim_ie *tim_ie = elems.tim;
-			ifmgd->dtim_period = tim_ie->dtim_period;
-		}
+
+		if (elems.dtim_period)
+			ifmgd->dtim_period = elems.dtim_period;
 		ifmgd->have_beacon = true;
 		ifmgd->assoc_data->need_beacon = false;
 		if (ieee80211_hw_check(&local->hw, TIMING_BEACON_ONLY)) {
@@ -3751,12 +3768,17 @@ static void ieee80211_rx_mgmt_beacon(struct ieee80211_sub_if_data *sdata,
 				le64_to_cpu(mgmt->u.beacon.timestamp);
 			sdata->vif.bss_conf.sync_device_ts =
 				rx_status->device_timestamp;
-			if (elems.tim)
-				sdata->vif.bss_conf.sync_dtim_count =
-					elems.tim->dtim_count;
-			else
-				sdata->vif.bss_conf.sync_dtim_count = 0;
+			sdata->vif.bss_conf.sync_dtim_count = elems.dtim_count;
 		}
+
+		if (elems.mbssid_config_ie)
+			bss_conf->profile_periodicity =
+				elems.mbssid_config_ie->profile_periodicity;
+
+		if (elems.ext_capab_len >= 11 &&
+		    (elems.ext_capab[10] & WLAN_EXT_CAPA11_EMA_SUPPORT))
+			bss_conf->ema_ap = true;
+
 		/* continue assoc process */
 		ifmgd->assoc_data->timeout = jiffies;
 		ifmgd->assoc_data->timeout_started = true;
@@ -3765,7 +3787,7 @@ static void ieee80211_rx_mgmt_beacon(struct ieee80211_sub_if_data *sdata,
 	}
 
 	if (!ifmgd->associated ||
-	    !ether_addr_equal(mgmt->bssid, ifmgd->associated->bssid))
+	    !ieee80211_rx_our_beacon(mgmt->bssid,  ifmgd->associated))
 		return;
 	bssid = ifmgd->associated->bssid;
 
@@ -3861,11 +3883,7 @@ static void ieee80211_rx_mgmt_beacon(struct ieee80211_sub_if_data *sdata,
 			le64_to_cpu(mgmt->u.beacon.timestamp);
 		sdata->vif.bss_conf.sync_device_ts =
 			rx_status->device_timestamp;
-		if (elems.tim)
-			sdata->vif.bss_conf.sync_dtim_count =
-				elems.tim->dtim_count;
-		else
-			sdata->vif.bss_conf.sync_dtim_count = 0;
+		sdata->vif.bss_conf.sync_dtim_count = elems.dtim_count;
 	}
 
 	if (ncrc == ifmgd->beacon_crc && ifmgd->beacon_crc_valid)
@@ -3891,10 +3909,7 @@ static void ieee80211_rx_mgmt_beacon(struct ieee80211_sub_if_data *sdata,
 	 */
 	if (!ifmgd->have_beacon) {
 		/* a few bogus AP send dtim_period = 0 or no TIM IE */
-		if (elems.tim)
-			bss_conf->dtim_period = elems.tim->dtim_period ?: 1;
-		else
-			bss_conf->dtim_period = 1;
+		bss_conf->dtim_period = elems.dtim_period ?: 1;
 
 		changed |= BSS_CHANGED_BEACON_INFO;
 		ifmgd->have_beacon = true;
@@ -4761,6 +4776,40 @@ static int ieee80211_prep_channel(struct ieee80211_sub_if_data *sdata,
 	return ret;
 }
 
+static bool ieee80211_get_dtim(const struct cfg80211_bss_ies *ies,
+			       u8 *dtim_count, u8 *dtim_period)
+{
+	const u8 *tim_ie = cfg80211_find_ie(WLAN_EID_TIM, ies->data, ies->len);
+	const u8 *idx_ie = cfg80211_find_ie(WLAN_EID_MULTI_BSSID_IDX, ies->data,
+					 ies->len);
+	const struct ieee80211_tim_ie *tim = NULL;
+	const struct ieee80211_bssid_index *idx;
+	bool valid = tim_ie && tim_ie[1] >= 2;
+
+	if (valid)
+		tim = (void *)(tim_ie + 2);
+
+	if (dtim_count)
+		*dtim_count = valid ? tim->dtim_count : 0;
+
+	if (dtim_period)
+		*dtim_period = valid ? tim->dtim_period : 0;
+
+	/* Check if value is overridden by non-transmitted profile */
+	if (!idx_ie || idx_ie[1] < 3)
+		return valid;
+
+	idx = (void *)(idx_ie + 2);
+
+	if (dtim_count)
+		*dtim_count = idx->dtim_count;
+
+	if (dtim_period)
+		*dtim_period = idx->dtim_period;
+
+	return true;
+}
+
 static int ieee80211_prep_connection(struct ieee80211_sub_if_data *sdata,
 				     struct cfg80211_bss *cbss, bool assoc,
 				     bool override)
@@ -4852,17 +4901,13 @@ static int ieee80211_prep_connection(struct ieee80211_sub_if_data *sdata,
 		rcu_read_lock();
 		ies = rcu_dereference(cbss->beacon_ies);
 		if (ies) {
-			const u8 *tim_ie;
-
 			sdata->vif.bss_conf.sync_tsf = ies->tsf;
 			sdata->vif.bss_conf.sync_device_ts =
 				bss->device_ts_beacon;
-			tim_ie = cfg80211_find_ie(WLAN_EID_TIM,
-						  ies->data, ies->len);
-			if (tim_ie && tim_ie[1] >= 2)
-				sdata->vif.bss_conf.sync_dtim_count = tim_ie[2];
-			else
-				sdata->vif.bss_conf.sync_dtim_count = 0;
+
+			ieee80211_get_dtim(ies,
+					   &sdata->vif.bss_conf.sync_dtim_count,
+					   NULL);
 		} else if (!ieee80211_hw_check(&sdata->local->hw,
 					       TIMING_BEACON_ONLY)) {
 			ies = rcu_dereference(cbss->proberesp_ies);
@@ -5332,17 +5377,12 @@ int ieee80211_mgd_assoc(struct ieee80211_sub_if_data *sdata,
 		assoc_data->timeout_started = true;
 		assoc_data->need_beacon = true;
 	} else if (beacon_ies) {
-		const u8 *tim_ie = cfg80211_find_ie(WLAN_EID_TIM,
-						    beacon_ies->data,
-						    beacon_ies->len);
+		const u8 *ie;
 		u8 dtim_count = 0;
 
-		if (tim_ie && tim_ie[1] >= sizeof(struct ieee80211_tim_ie)) {
-			const struct ieee80211_tim_ie *tim;
-			tim = (void *)(tim_ie + 2);
-			ifmgd->dtim_period = tim->dtim_period;
-			dtim_count = tim->dtim_count;
-		}
+		ieee80211_get_dtim(beacon_ies, &dtim_count,
+				   &ifmgd->dtim_period);
+
 		ifmgd->have_beacon = true;
 		assoc_data->timeout = jiffies;
 		assoc_data->timeout_started = true;
@@ -5353,6 +5393,17 @@ int ieee80211_mgd_assoc(struct ieee80211_sub_if_data *sdata,
 				bss->device_ts_beacon;
 			sdata->vif.bss_conf.sync_dtim_count = dtim_count;
 		}
+
+		ie = cfg80211_find_ext_ie(WLAN_EID_EXT_MULTIPLE_BSSID_CONFIGURATION,
+					  beacon_ies->data, beacon_ies->len);
+		if (ie && ie[1] >= 3)
+			sdata->vif.bss_conf.profile_periodicity = ie[4];
+
+		ie = cfg80211_find_ie(WLAN_EID_EXT_CAPABILITY,
+				      beacon_ies->data, beacon_ies->len);
+		if (ie && ie[1] >= 11 &&
+		    (ie[10] & WLAN_EXT_CAPA11_EMA_SUPPORT))
+			sdata->vif.bss_conf.ema_ap = true;
 	} else {
 		assoc_data->timeout = jiffies;
 		assoc_data->timeout_started = true;
diff --git a/net/mac80211/scan.c b/net/mac80211/scan.c
index 20211cbc63f4..0cf066700623 100644
--- a/net/mac80211/scan.c
+++ b/net/mac80211/scan.c
@@ -144,8 +144,8 @@ ieee80211_bss_info_update(struct ieee80211_local *local,
 			  struct ieee80211_channel *channel)
 {
 	bool beacon = ieee80211_is_beacon(mgmt->frame_control);
-	struct cfg80211_bss *cbss;
-	struct ieee80211_bss *bss;
+	struct cfg80211_bss *cbss, *non_tx_cbss;
+	struct ieee80211_bss *bss, *non_tx_bss;
 	struct cfg80211_inform_bss bss_meta = {
 		.boottime_ns = rx_status->boottime_ns,
 	};
@@ -212,6 +212,13 @@ ieee80211_bss_info_update(struct ieee80211_local *local,
 	bss = (void *)cbss->priv;
 	ieee80211_update_bss_from_elems(local, bss, &elems, rx_status, beacon);
 
+	list_for_each_entry(non_tx_cbss, &cbss->nontrans_list, nontrans_list) {
+		non_tx_bss = (void *)non_tx_cbss->priv;
+
+		ieee80211_update_bss_from_elems(local, non_tx_bss, &elems,
+						rx_status, beacon);
+	}
+
 	return bss;
 }
 
diff --git a/net/mac80211/util.c b/net/mac80211/util.c
index 77882ca327de..8349c91250ef 100644
--- a/net/mac80211/util.c
+++ b/net/mac80211/util.c
@@ -891,20 +891,18 @@ void ieee80211_queue_delayed_work(struct ieee80211_hw *hw,
 }
 EXPORT_SYMBOL(ieee80211_queue_delayed_work);
 
-u32 ieee802_11_parse_elems_crc(const u8 *start, size_t len, bool action,
-			       struct ieee802_11_elems *elems,
-			       u64 filter, u32 crc, u8 *transmitter_bssid,
-			       u8 *bss_bssid)
+static u32
+_ieee802_11_parse_elems_crc(const u8 *start, size_t len, bool action,
+			    struct ieee802_11_elems *elems,
+			    u64 filter, u32 crc, u8 *transmitter_bssid,
+			    u8 *bss_bssid)
 {
-	struct element *elem;
+	const struct element *elem, *sub;
 	bool calc_crc = filter != 0;
 	DECLARE_BITMAP(seen_elems, 256);
 	const u8 *ie;
 
 	bitmap_zero(seen_elems, 256);
-	memset(elems, 0, sizeof(*elems));
-	elems->ie_start = start;
-	elems->total_len = len;
 
 	for_each_element(elem, start, len) {
 		bool elem_parse_failed;
@@ -1210,6 +1208,57 @@ u32 ieee802_11_parse_elems_crc(const u8 *start, size_t len, bool action,
 			if (elen >= sizeof(*elems->max_idle_period_ie))
 				elems->max_idle_period_ie = (void *)pos;
 			break;
+		case WLAN_EID_MULTIPLE_BSSID:
+			if (!bss_bssid || !transmitter_bssid || elen < 4)
+				break;
+
+			elems->max_bssid_indicator = pos[0];
+
+			for_each_element(sub, pos + 1, elen - 1) {
+				u8 sub_len = sub->datalen;
+				u8 new_bssid[ETH_ALEN];
+				const u8 *index;
+
+				/*
+				 * we only expect the "non-transmitted BSSID
+				 * profile" subelement (subelement id 0)
+				 */
+				if (sub->id != 0 || sub->datalen < 4) {
+					/* not a valid BSS profile */
+					continue;
+				}
+
+				if (sub->data[0] != WLAN_EID_NON_TX_BSSID_CAP ||
+				    sub->data[1] != 2) {
+					/* The first element of the
+					 * Nontransmitted BSSID Profile is not
+					 * the Nontransmitted BSSID Capability
+					 * element.
+					 */
+					continue;
+				}
+
+				/* found a Nontransmitted BSSID Profile */
+				index = cfg80211_find_ie(WLAN_EID_MULTI_BSSID_IDX,
+							 sub->data, sub_len);
+				if (!index || index[1] < 1 || index[2] == 0) {
+					/* Invalid MBSSID Index element */
+					continue;
+				}
+
+				cfg80211_gen_new_bssid(transmitter_bssid,
+						       pos[0],
+						       index[2],
+						       new_bssid);
+				if (ether_addr_equal(new_bssid, bss_bssid)) {
+					elems->nontransmitted_bssid_profile =
+						(void *)sub;
+					elems->bssid_index_len = index[1];
+					elems->bssid_index = (void *)&index[2];
+					break;
+				}
+			}
+			break;
 		case WLAN_EID_EXTENSION:
 			if (pos[0] == WLAN_EID_EXT_HE_MU_EDCA &&
 			    elen >= (sizeof(*elems->mu_edca_param_set) + 1)) {
@@ -1225,6 +1274,10 @@ u32 ieee802_11_parse_elems_crc(const u8 *start, size_t len, bool action,
 				elems->he_operation = (void *)&pos[1];
 			} else if (pos[0] == WLAN_EID_EXT_UORA && elen >= 1) {
 				elems->uora_element = (void *)&pos[1];
+			} else if (pos[0] ==
+				   WLAN_EID_EXT_MULTIPLE_BSSID_CONFIGURATION &&
+				   elen == 3) {
+				elems->mbssid_config_ie = (void *)&pos[1];
 			}
 			break;
 		default:
@@ -1243,6 +1296,48 @@ u32 ieee802_11_parse_elems_crc(const u8 *start, size_t len, bool action,
 	return crc;
 }
 
+u32 ieee802_11_parse_elems_crc(const u8 *start, size_t len, bool action,
+			       struct ieee802_11_elems *elems,
+			       u64 filter, u32 crc, u8 *transmitter_bssid,
+			       u8 *bss_bssid)
+{
+	memset(elems, 0, sizeof(*elems));
+	elems->ie_start = start;
+	elems->total_len = len;
+
+	crc = _ieee802_11_parse_elems_crc(start, len, action, elems, filter,
+					  crc, transmitter_bssid, bss_bssid);
+
+	/* Override with nontransmitted profile, if found */
+	if (transmitter_bssid && elems->nontransmitted_bssid_profile) {
+		const u8 *profile = elems->nontransmitted_bssid_profile;
+
+		_ieee802_11_parse_elems_crc(&profile[2], profile[1],
+					    action, elems, 0, 0,
+					    transmitter_bssid, bss_bssid);
+	}
+
+	if (elems->tim && !elems->parse_error) {
+		const struct ieee80211_tim_ie *tim_ie = elems->tim;
+
+		elems->dtim_period = tim_ie->dtim_period;
+		elems->dtim_count = tim_ie->dtim_count;
+	}
+
+	/* Override DTIM period and count if needed */
+	if (elems->bssid_index &&
+	    elems->bssid_index_len >=
+	    offsetofend(struct ieee80211_bssid_index, dtim_period))
+		elems->dtim_period = elems->bssid_index->dtim_period;
+
+	if (elems->bssid_index &&
+	    elems->bssid_index_len >=
+	    offsetofend(struct ieee80211_bssid_index, dtim_count))
+		elems->dtim_count = elems->bssid_index->dtim_count;
+
+	return crc;
+}
+
 void ieee80211_regulatory_limit_wmm_params(struct ieee80211_sub_if_data *sdata,
 					   struct ieee80211_tx_queue_params
 					   *qparam, int ac)
-- 
2.17.2

