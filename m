Return-Path: <SRS0=MEvv=QB=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C4CBDC282C6
	for <linux-wireless@archiver.kernel.org>; Fri, 25 Jan 2019 11:48:40 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 8C2C2218CD
	for <linux-wireless@archiver.kernel.org>; Fri, 25 Jan 2019 11:48:40 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727145AbfAYLsc (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Fri, 25 Jan 2019 06:48:32 -0500
Received: from s3.sipsolutions.net ([144.76.43.62]:55786 "EHLO
        sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726100AbfAYLsc (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 25 Jan 2019 06:48:32 -0500
Received: by sipsolutions.net with esmtpsa (TLS1.2:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92-RC4)
        (envelope-from <johannes@sipsolutions.net>)
        id 1gmzyG-0007S0-T2; Fri, 25 Jan 2019 12:48:29 +0100
From:   Johannes Berg <johannes@sipsolutions.net>
To:     linux-wireless@vger.kernel.org
Cc:     Sara Sharon <sara.sharon@intel.com>
Subject: [PATCH 01/12] mac80211: pass bssids to elements parsing function
Date:   Fri, 25 Jan 2019 12:48:14 +0100
Message-Id: <20190125114825.5872-1-johannes@sipsolutions.net>
X-Mailer: git-send-email 2.17.2
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

From: Sara Sharon <sara.sharon@intel.com>

In multiple BSSID, we have nested IEs inside the multiple
BSSID IE, that override the external ones for that specific
BSS. As preparation for supporting that, pass 2 BSSIDs to the
parse function, the transmitter, and the selected BSSID, so
it can know which IEs to choose. If the selected BSSID is
NULL, the outer ones will be applied.

Change ieee80211_bss_info_update to parse elements itself,
instead of receiving them parsed, so we have the relevant
bss entry in hand.

Signed-off-by: Sara Sharon <sara.sharon@intel.com>
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 net/mac80211/ibss.c        |  8 ++--
 net/mac80211/ieee80211_i.h | 13 ++++---
 net/mac80211/mesh.c        | 10 +++--
 net/mac80211/mesh_hwmp.c   |  3 +-
 net/mac80211/mesh_plink.c  |  4 +-
 net/mac80211/mlme.c        | 45 +++++++++++++----------
 net/mac80211/scan.c        | 75 ++++++++++++++++++++------------------
 net/mac80211/tdls.c        |  6 ++-
 net/mac80211/util.c        |  3 +-
 9 files changed, 95 insertions(+), 72 deletions(-)

diff --git a/net/mac80211/ibss.c b/net/mac80211/ibss.c
index 0d704e8d7078..4e4507115cf3 100644
--- a/net/mac80211/ibss.c
+++ b/net/mac80211/ibss.c
@@ -8,6 +8,7 @@
  * Copyright 2009, Johannes Berg <johannes@sipsolutions.net>
  * Copyright 2013-2014  Intel Mobile Communications GmbH
  * Copyright(c) 2016 Intel Deutschland GmbH
+ * Copyright(c) 2018-2019 Intel Corporation
  *
  * This program is free software; you can redistribute it and/or modify
  * it under the terms of the GNU General Public License version 2 as
@@ -1124,8 +1125,7 @@ static void ieee80211_rx_bss_info(struct ieee80211_sub_if_data *sdata,
 
 	ieee80211_update_sta_info(sdata, mgmt, len, rx_status, elems, channel);
 
-	bss = ieee80211_bss_info_update(local, rx_status, mgmt, len, elems,
-					channel);
+	bss = ieee80211_bss_info_update(local, rx_status, mgmt, len, channel);
 	if (!bss)
 		return;
 
@@ -1604,7 +1604,7 @@ void ieee80211_rx_mgmt_probe_beacon(struct ieee80211_sub_if_data *sdata,
 		return;
 
 	ieee802_11_parse_elems(mgmt->u.probe_resp.variable, len - baselen,
-			       false, &elems);
+			       false, &elems, mgmt->bssid, NULL);
 
 	ieee80211_rx_bss_info(sdata, mgmt, len, rx_status, &elems);
 }
@@ -1654,7 +1654,7 @@ void ieee80211_ibss_rx_queued_mgmt(struct ieee80211_sub_if_data *sdata,
 
 			ieee802_11_parse_elems(
 				mgmt->u.action.u.chan_switch.variable,
-				ies_len, true, &elems);
+				ies_len, true, &elems, mgmt->bssid, NULL);
 
 			if (elems.parse_error)
 				break;
diff --git a/net/mac80211/ieee80211_i.h b/net/mac80211/ieee80211_i.h
index 056b16bce3b0..cc3f833db022 100644
--- a/net/mac80211/ieee80211_i.h
+++ b/net/mac80211/ieee80211_i.h
@@ -4,7 +4,7 @@
  * Copyright 2006-2007	Jiri Benc <jbenc@suse.cz>
  * Copyright 2007-2010	Johannes Berg <johannes@sipsolutions.net>
  * Copyright 2013-2015  Intel Mobile Communications GmbH
- * Copyright (C) 2018 Intel Corporation
+ * Copyright (C) 2018-2019 Intel Corporation
  *
  * This program is free software; you can redistribute it and/or modify
  * it under the terms of the GNU General Public License version 2 as
@@ -1672,7 +1672,6 @@ ieee80211_bss_info_update(struct ieee80211_local *local,
 			  struct ieee80211_rx_status *rx_status,
 			  struct ieee80211_mgmt *mgmt,
 			  size_t len,
-			  struct ieee802_11_elems *elems,
 			  struct ieee80211_channel *channel);
 void ieee80211_rx_bss_put(struct ieee80211_local *local,
 			  struct ieee80211_bss *bss);
@@ -1956,12 +1955,16 @@ static inline void ieee80211_tx_skb(struct ieee80211_sub_if_data *sdata,
 
 u32 ieee802_11_parse_elems_crc(const u8 *start, size_t len, bool action,
 			       struct ieee802_11_elems *elems,
-			       u64 filter, u32 crc);
+			       u64 filter, u32 crc, u8 *transmitter_bssid,
+			       u8 *bss_bssid);
 static inline void ieee802_11_parse_elems(const u8 *start, size_t len,
 					  bool action,
-					  struct ieee802_11_elems *elems)
+					  struct ieee802_11_elems *elems,
+					  u8 *transmitter_bssid,
+					  u8 *bss_bssid)
 {
-	ieee802_11_parse_elems_crc(start, len, action, elems, 0, 0);
+	ieee802_11_parse_elems_crc(start, len, action, elems, 0, 0,
+				   transmitter_bssid, bss_bssid);
 }
 
 
diff --git a/net/mac80211/mesh.c b/net/mac80211/mesh.c
index c90452aa0c42..766e5e5bab8a 100644
--- a/net/mac80211/mesh.c
+++ b/net/mac80211/mesh.c
@@ -1,6 +1,6 @@
 /*
  * Copyright (c) 2008, 2009 open80211s Ltd.
- * Copyright (C) 2018 Intel Corporation
+ * Copyright (C) 2018 - 2019 Intel Corporation
  * Authors:    Luis Carlos Cobo <luisca@cozybit.com>
  * 	       Javier Cardona <javier@cozybit.com>
  *
@@ -1106,7 +1106,8 @@ ieee80211_mesh_rx_probe_req(struct ieee80211_sub_if_data *sdata,
 	if (baselen > len)
 		return;
 
-	ieee802_11_parse_elems(pos, len - baselen, false, &elems);
+	ieee802_11_parse_elems(pos, len - baselen, false, &elems, mgmt->bssid,
+			       NULL);
 
 	if (!elems.mesh_id)
 		return;
@@ -1170,7 +1171,7 @@ static void ieee80211_mesh_rx_bcn_presp(struct ieee80211_sub_if_data *sdata,
 		return;
 
 	ieee802_11_parse_elems(mgmt->u.probe_resp.variable, len - baselen,
-			       false, &elems);
+			       false, &elems, mgmt->bssid, NULL);
 
 	/* ignore non-mesh or secure / unsecure mismatch */
 	if ((!elems.mesh_id || !elems.mesh_config) ||
@@ -1306,7 +1307,8 @@ static void mesh_rx_csa_frame(struct ieee80211_sub_if_data *sdata,
 	pos = mgmt->u.action.u.chan_switch.variable;
 	baselen = offsetof(struct ieee80211_mgmt,
 			   u.action.u.chan_switch.variable);
-	ieee802_11_parse_elems(pos, len - baselen, true, &elems);
+	ieee802_11_parse_elems(pos, len - baselen, true, &elems,
+			       mgmt->bssid, NULL);
 
 	ifmsh->chsw_ttl = elems.mesh_chansw_params_ie->mesh_ttl;
 	if (!--ifmsh->chsw_ttl)
diff --git a/net/mac80211/mesh_hwmp.c b/net/mac80211/mesh_hwmp.c
index e00284afdda5..f7517668e77a 100644
--- a/net/mac80211/mesh_hwmp.c
+++ b/net/mac80211/mesh_hwmp.c
@@ -1,5 +1,6 @@
 /*
  * Copyright (c) 2008, 2009 open80211s Ltd.
+ * Copyright (C) 2019 Intel Corporation
  * Author:     Luis Carlos Cobo <luisca@cozybit.com>
  *
  * This program is free software; you can redistribute it and/or modify
@@ -926,7 +927,7 @@ void mesh_rx_path_sel_frame(struct ieee80211_sub_if_data *sdata,
 
 	baselen = (u8 *) mgmt->u.action.u.mesh_action.variable - (u8 *) mgmt;
 	ieee802_11_parse_elems(mgmt->u.action.u.mesh_action.variable,
-			       len - baselen, false, &elems);
+			       len - baselen, false, &elems, mgmt->bssid, NULL);
 
 	if (elems.preq) {
 		if (elems.preq_len != 37)
diff --git a/net/mac80211/mesh_plink.c b/net/mac80211/mesh_plink.c
index 33055c8ed37e..8afd0ece94c9 100644
--- a/net/mac80211/mesh_plink.c
+++ b/net/mac80211/mesh_plink.c
@@ -1,5 +1,6 @@
 /*
  * Copyright (c) 2008, 2009 open80211s Ltd.
+ * Copyright (C) 2019 Intel Corporation
  * Author:     Luis Carlos Cobo <luisca@cozybit.com>
  *
  * This program is free software; you can redistribute it and/or modify
@@ -1214,6 +1215,7 @@ void mesh_rx_plink_frame(struct ieee80211_sub_if_data *sdata,
 		if (baselen > len)
 			return;
 	}
-	ieee802_11_parse_elems(baseaddr, len - baselen, true, &elems);
+	ieee802_11_parse_elems(baseaddr, len - baselen, true, &elems,
+			       mgmt->bssid, NULL);
 	mesh_process_plink_frame(sdata, mgmt, &elems, rx_status);
 }
diff --git a/net/mac80211/mlme.c b/net/mac80211/mlme.c
index 687821567287..1f41f760bd22 100644
--- a/net/mac80211/mlme.c
+++ b/net/mac80211/mlme.c
@@ -2762,7 +2762,8 @@ static void ieee80211_auth_challenge(struct ieee80211_sub_if_data *sdata,
 	u32 tx_flags = 0;
 
 	pos = mgmt->u.auth.variable;
-	ieee802_11_parse_elems(pos, len - (pos - (u8 *) mgmt), false, &elems);
+	ieee802_11_parse_elems(pos, len - (pos - (u8 *)mgmt), false, &elems,
+			       mgmt->bssid, auth_data->bss->bssid);
 	if (!elems.challenge)
 		return;
 	auth_data->expected_transaction = 4;
@@ -3130,7 +3131,8 @@ static bool ieee80211_assoc_success(struct ieee80211_sub_if_data *sdata,
 	}
 
 	pos = mgmt->u.assoc_resp.variable;
-	ieee802_11_parse_elems(pos, len - (pos - (u8 *) mgmt), false, &elems);
+	ieee802_11_parse_elems(pos, len - (pos - (u8 *)mgmt), false, &elems,
+			       mgmt->bssid, assoc_data->bss->bssid);
 
 	if (!elems.supp_rates) {
 		sdata_info(sdata, "no SuppRates element in AssocResp\n");
@@ -3167,7 +3169,9 @@ static bool ieee80211_assoc_success(struct ieee80211_sub_if_data *sdata,
 			return false;
 
 		ieee802_11_parse_elems(bss_ies->data, bss_ies->len,
-				       false, &bss_elems);
+				       false, &bss_elems,
+				       mgmt->bssid,
+				       assoc_data->bss->bssid);
 		if (assoc_data->wmm &&
 		    !elems.wmm_param && bss_elems.wmm_param) {
 			elems.wmm_param = bss_elems.wmm_param;
@@ -3464,7 +3468,8 @@ static void ieee80211_rx_mgmt_assoc_resp(struct ieee80211_sub_if_data *sdata,
 		return;
 
 	pos = mgmt->u.assoc_resp.variable;
-	ieee802_11_parse_elems(pos, len - (pos - (u8 *) mgmt), false, &elems);
+	ieee802_11_parse_elems(pos, len - (pos - (u8 *)mgmt), false, &elems,
+			       mgmt->bssid, assoc_data->bss->bssid);
 
 	if (status_code == WLAN_STATUS_ASSOC_REJECTED_TEMPORARILY &&
 	    elems.timeout_int &&
@@ -3521,8 +3526,7 @@ static void ieee80211_rx_mgmt_assoc_resp(struct ieee80211_sub_if_data *sdata,
 
 static void ieee80211_rx_bss_info(struct ieee80211_sub_if_data *sdata,
 				  struct ieee80211_mgmt *mgmt, size_t len,
-				  struct ieee80211_rx_status *rx_status,
-				  struct ieee802_11_elems *elems)
+				  struct ieee80211_rx_status *rx_status)
 {
 	struct ieee80211_local *local = sdata->local;
 	struct ieee80211_bss *bss;
@@ -3534,8 +3538,7 @@ static void ieee80211_rx_bss_info(struct ieee80211_sub_if_data *sdata,
 	if (!channel)
 		return;
 
-	bss = ieee80211_bss_info_update(local, rx_status, mgmt, len, elems,
-					channel);
+	bss = ieee80211_bss_info_update(local, rx_status, mgmt, len, channel);
 	if (bss) {
 		sdata->vif.bss_conf.beacon_rate = bss->beacon_rate;
 		ieee80211_rx_bss_put(local, bss);
@@ -3550,7 +3553,6 @@ static void ieee80211_rx_mgmt_probe_resp(struct ieee80211_sub_if_data *sdata,
 	struct ieee80211_if_managed *ifmgd;
 	struct ieee80211_rx_status *rx_status = (void *) skb->cb;
 	size_t baselen, len = skb->len;
-	struct ieee802_11_elems elems;
 
 	ifmgd = &sdata->u.mgd;
 
@@ -3563,10 +3565,7 @@ static void ieee80211_rx_mgmt_probe_resp(struct ieee80211_sub_if_data *sdata,
 	if (baselen > len)
 		return;
 
-	ieee802_11_parse_elems(mgmt->u.probe_resp.variable, len - baselen,
-			       false, &elems);
-
-	ieee80211_rx_bss_info(sdata, mgmt, len, rx_status, &elems);
+	ieee80211_rx_bss_info(sdata, mgmt, len, rx_status);
 
 	if (ifmgd->associated &&
 	    ether_addr_equal(mgmt->bssid, ifmgd->associated->bssid))
@@ -3736,9 +3735,11 @@ static void ieee80211_rx_mgmt_beacon(struct ieee80211_sub_if_data *sdata,
 	if (ifmgd->assoc_data && ifmgd->assoc_data->need_beacon &&
 	    ether_addr_equal(mgmt->bssid, ifmgd->assoc_data->bss->bssid)) {
 		ieee802_11_parse_elems(mgmt->u.beacon.variable,
-				       len - baselen, false, &elems);
+				       len - baselen, false, &elems,
+				       mgmt->bssid,
+				       ifmgd->assoc_data->bss->bssid);
 
-		ieee80211_rx_bss_info(sdata, mgmt, len, rx_status, &elems);
+		ieee80211_rx_bss_info(sdata, mgmt, len, rx_status);
 		if (elems.tim && !elems.parse_error) {
 			const struct ieee80211_tim_ie *tim_ie = elems.tim;
 			ifmgd->dtim_period = tim_ie->dtim_period;
@@ -3787,7 +3788,8 @@ static void ieee80211_rx_mgmt_beacon(struct ieee80211_sub_if_data *sdata,
 	ncrc = crc32_be(0, (void *)&mgmt->u.beacon.beacon_int, 4);
 	ncrc = ieee802_11_parse_elems_crc(mgmt->u.beacon.variable,
 					  len - baselen, false, &elems,
-					  care_about_ies, ncrc);
+					  care_about_ies, ncrc,
+					  mgmt->bssid, bssid);
 
 	if (ieee80211_hw_check(&local->hw, PS_NULLFUNC_STACK) &&
 	    ieee80211_check_tim(elems.tim, elems.tim_len, ifmgd->aid)) {
@@ -3871,7 +3873,7 @@ static void ieee80211_rx_mgmt_beacon(struct ieee80211_sub_if_data *sdata,
 	ifmgd->beacon_crc = ncrc;
 	ifmgd->beacon_crc_valid = true;
 
-	ieee80211_rx_bss_info(sdata, mgmt, len, rx_status, &elems);
+	ieee80211_rx_bss_info(sdata, mgmt, len, rx_status);
 
 	ieee80211_sta_process_chanswitch(sdata, rx_status->mactime,
 					 rx_status->device_timestamp,
@@ -3992,9 +3994,10 @@ void ieee80211_sta_rx_queued_mgmt(struct ieee80211_sub_if_data *sdata,
 			if (ies_len < 0)
 				break;
 
+			/* CSA IE cannot be overridden, no need for BSSID */
 			ieee802_11_parse_elems(
 				mgmt->u.action.u.chan_switch.variable,
-				ies_len, true, &elems);
+				ies_len, true, &elems, mgmt->bssid, NULL);
 
 			if (elems.parse_error)
 				break;
@@ -4011,9 +4014,13 @@ void ieee80211_sta_rx_queued_mgmt(struct ieee80211_sub_if_data *sdata,
 			if (ies_len < 0)
 				break;
 
+			/*
+			 * extended CSA IE can't be overridden, no need for
+			 * BSSID
+			 */
 			ieee802_11_parse_elems(
 				mgmt->u.action.u.ext_chan_switch.variable,
-				ies_len, true, &elems);
+				ies_len, true, &elems, mgmt->bssid, NULL);
 
 			if (elems.parse_error)
 				break;
diff --git a/net/mac80211/scan.c b/net/mac80211/scan.c
index 95413413f98c..b58f75da9c84 100644
--- a/net/mac80211/scan.c
+++ b/net/mac80211/scan.c
@@ -8,6 +8,7 @@
  * Copyright 2007, Michael Wu <flamingice@sourmilk.net>
  * Copyright 2013-2015  Intel Mobile Communications GmbH
  * Copyright 2016-2017  Intel Deutschland GmbH
+ * Copyright (C) 2018-2019 Intel Corporation
  *
  * This program is free software; you can redistribute it and/or modify
  * it under the terms of the GNU General Public License version 2 as
@@ -61,7 +62,6 @@ struct ieee80211_bss *
 ieee80211_bss_info_update(struct ieee80211_local *local,
 			  struct ieee80211_rx_status *rx_status,
 			  struct ieee80211_mgmt *mgmt, size_t len,
-			  struct ieee802_11_elems *elems,
 			  struct ieee80211_channel *channel)
 {
 	bool beacon = ieee80211_is_beacon(mgmt->frame_control);
@@ -73,6 +73,9 @@ ieee80211_bss_info_update(struct ieee80211_local *local,
 	};
 	bool signal_valid;
 	struct ieee80211_sub_if_data *scan_sdata;
+	struct ieee802_11_elems elems;
+	size_t baselen;
+	u8 *elements;
 
 	if (rx_status->flag & RX_FLAG_NO_SIGNAL_VAL)
 		bss_meta.signal = 0; /* invalid signal indication */
@@ -106,6 +109,22 @@ ieee80211_bss_info_update(struct ieee80211_local *local,
 					      mgmt, len, GFP_ATOMIC);
 	if (!cbss)
 		return NULL;
+
+	if (ieee80211_is_probe_resp(mgmt->frame_control)) {
+		elements = mgmt->u.probe_resp.variable;
+		baselen = offsetof(struct ieee80211_mgmt,
+				   u.probe_resp.variable);
+	} else {
+		baselen = offsetof(struct ieee80211_mgmt, u.beacon.variable);
+		elements = mgmt->u.beacon.variable;
+	}
+
+	if (baselen > len)
+		return NULL;
+
+	ieee802_11_parse_elems(elements, len - baselen, false, &elems,
+			       mgmt->bssid, cbss->bssid);
+
 	/* In case the signal is invalid update the status */
 	signal_valid = abs(channel->center_freq - cbss->channel->center_freq)
 		<= local->hw.wiphy->max_adj_channel_rssi_comp;
@@ -119,7 +138,7 @@ ieee80211_bss_info_update(struct ieee80211_local *local,
 	else
 		bss->device_ts_presp = rx_status->device_timestamp;
 
-	if (elems->parse_error) {
+	if (elems.parse_error) {
 		if (beacon)
 			bss->corrupt_data |= IEEE80211_BSS_CORRUPT_BEACON;
 		else
@@ -132,45 +151,45 @@ ieee80211_bss_info_update(struct ieee80211_local *local,
 	}
 
 	/* save the ERP value so that it is available at association time */
-	if (elems->erp_info && (!elems->parse_error ||
-				!(bss->valid_data & IEEE80211_BSS_VALID_ERP))) {
-		bss->erp_value = elems->erp_info[0];
+	if (elems.erp_info && (!elems.parse_error ||
+			       !(bss->valid_data & IEEE80211_BSS_VALID_ERP))) {
+		bss->erp_value = elems.erp_info[0];
 		bss->has_erp_value = true;
-		if (!elems->parse_error)
+		if (!elems.parse_error)
 			bss->valid_data |= IEEE80211_BSS_VALID_ERP;
 	}
 
 	/* replace old supported rates if we get new values */
-	if (!elems->parse_error ||
+	if (!elems.parse_error ||
 	    !(bss->valid_data & IEEE80211_BSS_VALID_RATES)) {
 		srlen = 0;
-		if (elems->supp_rates) {
+		if (elems.supp_rates) {
 			clen = IEEE80211_MAX_SUPP_RATES;
-			if (clen > elems->supp_rates_len)
-				clen = elems->supp_rates_len;
-			memcpy(bss->supp_rates, elems->supp_rates, clen);
+			if (clen > elems.supp_rates_len)
+				clen = elems.supp_rates_len;
+			memcpy(bss->supp_rates, elems.supp_rates, clen);
 			srlen += clen;
 		}
-		if (elems->ext_supp_rates) {
+		if (elems.ext_supp_rates) {
 			clen = IEEE80211_MAX_SUPP_RATES - srlen;
-			if (clen > elems->ext_supp_rates_len)
-				clen = elems->ext_supp_rates_len;
-			memcpy(bss->supp_rates + srlen, elems->ext_supp_rates,
+			if (clen > elems.ext_supp_rates_len)
+				clen = elems.ext_supp_rates_len;
+			memcpy(bss->supp_rates + srlen, elems.ext_supp_rates,
 			       clen);
 			srlen += clen;
 		}
 		if (srlen) {
 			bss->supp_rates_len = srlen;
-			if (!elems->parse_error)
+			if (!elems.parse_error)
 				bss->valid_data |= IEEE80211_BSS_VALID_RATES;
 		}
 	}
 
-	if (!elems->parse_error ||
+	if (!elems.parse_error ||
 	    !(bss->valid_data & IEEE80211_BSS_VALID_WMM)) {
-		bss->wmm_used = elems->wmm_param || elems->wmm_info;
-		bss->uapsd_supported = is_uapsd_supported(elems);
-		if (!elems->parse_error)
+		bss->wmm_used = elems.wmm_param || elems.wmm_info;
+		bss->uapsd_supported = is_uapsd_supported(&elems);
+		if (!elems.parse_error)
 			bss->valid_data |= IEEE80211_BSS_VALID_WMM;
 	}
 
@@ -206,10 +225,7 @@ void ieee80211_scan_rx(struct ieee80211_local *local, struct sk_buff *skb)
 	struct ieee80211_sub_if_data *sdata1, *sdata2;
 	struct ieee80211_mgmt *mgmt = (void *)skb->data;
 	struct ieee80211_bss *bss;
-	u8 *elements;
 	struct ieee80211_channel *channel;
-	size_t baselen;
-	struct ieee802_11_elems elems;
 
 	if (skb->len < 24 ||
 	    (!ieee80211_is_probe_resp(mgmt->frame_control) &&
@@ -244,26 +260,15 @@ void ieee80211_scan_rx(struct ieee80211_local *local, struct sk_buff *skb)
 		    !ieee80211_scan_accept_presp(sdata2, sched_scan_req_flags,
 						 mgmt->da))
 			return;
-
-		elements = mgmt->u.probe_resp.variable;
-		baselen = offsetof(struct ieee80211_mgmt, u.probe_resp.variable);
-	} else {
-		baselen = offsetof(struct ieee80211_mgmt, u.beacon.variable);
-		elements = mgmt->u.beacon.variable;
 	}
 
-	if (baselen > skb->len)
-		return;
-
-	ieee802_11_parse_elems(elements, skb->len - baselen, false, &elems);
-
 	channel = ieee80211_get_channel(local->hw.wiphy, rx_status->freq);
 
 	if (!channel || channel->flags & IEEE80211_CHAN_DISABLED)
 		return;
 
 	bss = ieee80211_bss_info_update(local, rx_status,
-					mgmt, skb->len, &elems,
+					mgmt, skb->len,
 					channel);
 	if (bss)
 		ieee80211_rx_bss_put(local, bss);
diff --git a/net/mac80211/tdls.c b/net/mac80211/tdls.c
index 6c647f425e05..d30690d79a58 100644
--- a/net/mac80211/tdls.c
+++ b/net/mac80211/tdls.c
@@ -5,6 +5,7 @@
  * Copyright 2014, Intel Corporation
  * Copyright 2014  Intel Mobile Communications GmbH
  * Copyright 2015 - 2016 Intel Deutschland GmbH
+ * Copyright (C) 2019 Intel Corporation
  *
  * This file is GPLv2 as found in COPYING.
  */
@@ -1716,7 +1717,8 @@ ieee80211_process_tdls_channel_switch_resp(struct ieee80211_sub_if_data *sdata,
 	}
 
 	ieee802_11_parse_elems(tf->u.chan_switch_resp.variable,
-			       skb->len - baselen, false, &elems);
+			       skb->len - baselen, false, &elems,
+			       NULL, NULL);
 	if (elems.parse_error) {
 		tdls_dbg(sdata, "Invalid IEs in TDLS channel switch resp\n");
 		ret = -EINVAL;
@@ -1828,7 +1830,7 @@ ieee80211_process_tdls_channel_switch_req(struct ieee80211_sub_if_data *sdata,
 	}
 
 	ieee802_11_parse_elems(tf->u.chan_switch_req.variable,
-			       skb->len - baselen, false, &elems);
+			       skb->len - baselen, false, &elems, NULL, NULL);
 	if (elems.parse_error) {
 		tdls_dbg(sdata, "Invalid IEs in TDLS channel switch req\n");
 		return -EINVAL;
diff --git a/net/mac80211/util.c b/net/mac80211/util.c
index d0eb38b890aa..f493a7bba727 100644
--- a/net/mac80211/util.c
+++ b/net/mac80211/util.c
@@ -893,7 +893,8 @@ EXPORT_SYMBOL(ieee80211_queue_delayed_work);
 
 u32 ieee802_11_parse_elems_crc(const u8 *start, size_t len, bool action,
 			       struct ieee802_11_elems *elems,
-			       u64 filter, u32 crc)
+			       u64 filter, u32 crc, u8 *transmitter_bssid,
+			       u8 *bss_bssid)
 {
 	size_t left = len;
 	const u8 *pos = start;
-- 
2.17.2

