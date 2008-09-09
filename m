Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:56898 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756247AbYIIMtK (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 9 Sep 2008 08:49:10 -0400
Subject: [PATCH] mac80211: move spectrum management code out
From: Johannes Berg <johannes@sipsolutions.net>
To: John Linville <linville@tuxdriver.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain
Date: Tue, 09 Sep 2008 14:49:03 +0200
Message-Id: <1220964543.31304.169.camel@johannes.berg> (sfid-20080909_144928_636862_371B24FB)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Like the HT code, this doesn't depend on the STA-mode implementation
and can be handled entirely independently. There's only stub code
for now, but when it gets filled having it in its own file will be
beneficial.

Signed-off-by: Johannes Berg <johannes@sipsolutions.net>
---
 net/mac80211/Makefile      |    1 
 net/mac80211/ieee80211_i.h |    5 ++
 net/mac80211/mlme.c        |   89 ++-------------------------------------------
 net/mac80211/rx.c          |   22 +++++++++--
 net/mac80211/spectmgmt.c   |   86 +++++++++++++++++++++++++++++++++++++++++++
 5 files changed, 114 insertions(+), 89 deletions(-)

--- everything.orig/net/mac80211/mlme.c	2008-09-09 14:43:15.000000000 +0200
+++ everything/net/mac80211/mlme.c	2008-09-09 14:44:21.000000000 +0200
@@ -445,53 +445,6 @@ static void ieee80211_send_deauth_disass
 	ieee80211_sta_tx(sdata, skb, 0);
 }
 
-static void ieee80211_send_refuse_measurement_request(struct ieee80211_sub_if_data *sdata,
-					struct ieee80211_msrment_ie *request_ie,
-					const u8 *da, const u8 *bssid,
-					u8 dialog_token)
-{
-	struct ieee80211_local *local = sdata->local;
-	struct sk_buff *skb;
-	struct ieee80211_mgmt *msr_report;
-
-	skb = dev_alloc_skb(sizeof(*msr_report) + local->hw.extra_tx_headroom +
-				sizeof(struct ieee80211_msrment_ie));
-
-	if (!skb) {
-		printk(KERN_ERR "%s: failed to allocate buffer for "
-				"measurement report frame\n", sdata->dev->name);
-		return;
-	}
-
-	skb_reserve(skb, local->hw.extra_tx_headroom);
-	msr_report = (struct ieee80211_mgmt *)skb_put(skb, 24);
-	memset(msr_report, 0, 24);
-	memcpy(msr_report->da, da, ETH_ALEN);
-	memcpy(msr_report->sa, sdata->dev->dev_addr, ETH_ALEN);
-	memcpy(msr_report->bssid, bssid, ETH_ALEN);
-	msr_report->frame_control = cpu_to_le16(IEEE80211_FTYPE_MGMT |
-						IEEE80211_STYPE_ACTION);
-
-	skb_put(skb, 1 + sizeof(msr_report->u.action.u.measurement));
-	msr_report->u.action.category = WLAN_CATEGORY_SPECTRUM_MGMT;
-	msr_report->u.action.u.measurement.action_code =
-				WLAN_ACTION_SPCT_MSR_RPRT;
-	msr_report->u.action.u.measurement.dialog_token = dialog_token;
-
-	msr_report->u.action.u.measurement.element_id = WLAN_EID_MEASURE_REPORT;
-	msr_report->u.action.u.measurement.length =
-			sizeof(struct ieee80211_msrment_ie);
-
-	memset(&msr_report->u.action.u.measurement.msr_elem, 0,
-		sizeof(struct ieee80211_msrment_ie));
-	msr_report->u.action.u.measurement.msr_elem.token = request_ie->token;
-	msr_report->u.action.u.measurement.msr_elem.mode |=
-			IEEE80211_SPCT_MSR_RPRT_MODE_REFUSED;
-	msr_report->u.action.u.measurement.msr_elem.type = request_ie->type;
-
-	ieee80211_sta_tx(sdata, skb, 0);
-}
-
 /* MLME */
 static void ieee80211_sta_def_wmm_params(struct ieee80211_sub_if_data *sdata,
 					 struct ieee80211_sta_bss *bss)
@@ -1012,24 +965,6 @@ static void ieee80211_auth_challenge(str
 			    elems.challenge_len + 2, 1);
 }
 
-static void ieee80211_sta_process_measurement_req(struct ieee80211_sub_if_data *sdata,
-						struct ieee80211_mgmt *mgmt,
-						size_t len)
-{
-	/*
-	 * Ignoring measurement request is spec violation.
-	 * Mandatory measurements must be reported optional
-	 * measurements might be refused or reported incapable
-	 * For now just refuse
-	 * TODO: Answer basic measurement as unmeasured
-	 */
-	ieee80211_send_refuse_measurement_request(sdata,
-			&mgmt->u.action.u.measurement.msr_elem,
-			mgmt->sa, mgmt->bssid,
-			mgmt->u.action.u.measurement.dialog_token);
-}
-
-
 static void ieee80211_rx_mgmt_auth(struct ieee80211_sub_if_data *sdata,
 				   struct ieee80211_if_sta *ifsta,
 				   struct ieee80211_mgmt *mgmt,
@@ -1871,32 +1806,16 @@ static void ieee80211_rx_mgmt_action(str
 				     size_t len,
 				     struct ieee80211_rx_status *rx_status)
 {
-	struct ieee80211_local *local = sdata->local;
-
-	/* all categories we currently handle have action_code */
-	if (len < IEEE80211_MIN_ACTION_SIZE + 1)
+	/* currently we only handle mesh interface action frames here */
+	if (!ieee80211_vif_is_mesh(&sdata->vif))
 		return;
 
 	switch (mgmt->u.action.category) {
-	case WLAN_CATEGORY_SPECTRUM_MGMT:
-		if (local->hw.conf.channel->band != IEEE80211_BAND_5GHZ)
-			break;
-		switch (mgmt->u.action.u.measurement.action_code) {
-		case WLAN_ACTION_SPCT_MSR_REQ:
-			if (len < (IEEE80211_MIN_ACTION_SIZE +
-				   sizeof(mgmt->u.action.u.measurement)))
-				break;
-			ieee80211_sta_process_measurement_req(sdata, mgmt, len);
-			break;
-		}
-		break;
 	case PLINK_CATEGORY:
-		if (ieee80211_vif_is_mesh(&sdata->vif))
-			mesh_rx_plink_frame(sdata, mgmt, len, rx_status);
+		mesh_rx_plink_frame(sdata, mgmt, len, rx_status);
 		break;
 	case MESH_PATH_SEL_CATEGORY:
-		if (ieee80211_vif_is_mesh(&sdata->vif))
-			mesh_rx_path_sel_frame(sdata, mgmt, len);
+		mesh_rx_path_sel_frame(sdata, mgmt, len);
 		break;
 	}
 }
--- everything.orig/net/mac80211/rx.c	2008-09-09 14:43:15.000000000 +0200
+++ everything/net/mac80211/rx.c	2008-09-09 14:44:41.000000000 +0200
@@ -1561,12 +1561,26 @@ ieee80211_rx_h_action(struct ieee80211_r
 			ieee80211_process_delba(sdata, rx->sta, mgmt, len);
 			break;
 		}
-		rx->sta->rx_packets++;
-		dev_kfree_skb(rx->skb);
-		return RX_QUEUED;
+		break;
+	case WLAN_CATEGORY_SPECTRUM_MGMT:
+		if (local->hw.conf.channel->band != IEEE80211_BAND_5GHZ)
+			return RX_DROP_MONITOR;
+		switch (mgmt->u.action.u.measurement.action_code) {
+		case WLAN_ACTION_SPCT_MSR_REQ:
+			if (len < (IEEE80211_MIN_ACTION_SIZE +
+				   sizeof(mgmt->u.action.u.measurement)))
+				return RX_DROP_MONITOR;
+			ieee80211_process_measurement_req(sdata, mgmt, len);
+			break;
+		}
+		break;
+	default:
+		return RX_CONTINUE;
 	}
 
-	return RX_CONTINUE;
+	rx->sta->rx_packets++;
+	dev_kfree_skb(rx->skb);
+	return RX_QUEUED;
 }
 
 static ieee80211_rx_result debug_noinline
--- /dev/null	1970-01-01 00:00:00.000000000 +0000
+++ everything/net/mac80211/spectmgmt.c	2008-09-09 14:44:57.000000000 +0200
@@ -0,0 +1,86 @@
+/*
+ * spectrum management
+ *
+ * Copyright 2003, Jouni Malinen <jkmaline@cc.hut.fi>
+ * Copyright 2002-2005, Instant802 Networks, Inc.
+ * Copyright 2005-2006, Devicescape Software, Inc.
+ * Copyright 2006-2007  Jiri Benc <jbenc@suse.cz>
+ * Copyright 2007, Michael Wu <flamingice@sourmilk.net>
+ * Copyright 2007-2008, Intel Corporation
+ * Copyright 2008, Johannes Berg <johannes@sipsolutions.net>
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ */
+
+#include <linux/ieee80211.h>
+#include <net/wireless.h>
+#include <net/mac80211.h>
+#include "ieee80211_i.h"
+#include "sta_info.h"
+#include "wme.h"
+
+static void ieee80211_send_refuse_measurement_request(struct ieee80211_sub_if_data *sdata,
+					struct ieee80211_msrment_ie *request_ie,
+					const u8 *da, const u8 *bssid,
+					u8 dialog_token)
+{
+	struct ieee80211_local *local = sdata->local;
+	struct sk_buff *skb;
+	struct ieee80211_mgmt *msr_report;
+
+	skb = dev_alloc_skb(sizeof(*msr_report) + local->hw.extra_tx_headroom +
+				sizeof(struct ieee80211_msrment_ie));
+
+	if (!skb) {
+		printk(KERN_ERR "%s: failed to allocate buffer for "
+				"measurement report frame\n", sdata->dev->name);
+		return;
+	}
+
+	skb_reserve(skb, local->hw.extra_tx_headroom);
+	msr_report = (struct ieee80211_mgmt *)skb_put(skb, 24);
+	memset(msr_report, 0, 24);
+	memcpy(msr_report->da, da, ETH_ALEN);
+	memcpy(msr_report->sa, sdata->dev->dev_addr, ETH_ALEN);
+	memcpy(msr_report->bssid, bssid, ETH_ALEN);
+	msr_report->frame_control = cpu_to_le16(IEEE80211_FTYPE_MGMT |
+						IEEE80211_STYPE_ACTION);
+
+	skb_put(skb, 1 + sizeof(msr_report->u.action.u.measurement));
+	msr_report->u.action.category = WLAN_CATEGORY_SPECTRUM_MGMT;
+	msr_report->u.action.u.measurement.action_code =
+				WLAN_ACTION_SPCT_MSR_RPRT;
+	msr_report->u.action.u.measurement.dialog_token = dialog_token;
+
+	msr_report->u.action.u.measurement.element_id = WLAN_EID_MEASURE_REPORT;
+	msr_report->u.action.u.measurement.length =
+			sizeof(struct ieee80211_msrment_ie);
+
+	memset(&msr_report->u.action.u.measurement.msr_elem, 0,
+		sizeof(struct ieee80211_msrment_ie));
+	msr_report->u.action.u.measurement.msr_elem.token = request_ie->token;
+	msr_report->u.action.u.measurement.msr_elem.mode |=
+			IEEE80211_SPCT_MSR_RPRT_MODE_REFUSED;
+	msr_report->u.action.u.measurement.msr_elem.type = request_ie->type;
+
+	ieee80211_sta_tx(sdata, skb, 0);
+}
+
+void ieee80211_process_measurement_req(struct ieee80211_sub_if_data *sdata,
+				       struct ieee80211_mgmt *mgmt,
+				       size_t len)
+{
+	/*
+	 * Ignoring measurement request is spec violation.
+	 * Mandatory measurements must be reported optional
+	 * measurements might be refused or reported incapable
+	 * For now just refuse
+	 * TODO: Answer basic measurement as unmeasured
+	 */
+	ieee80211_send_refuse_measurement_request(sdata,
+			&mgmt->u.action.u.measurement.msr_elem,
+			mgmt->sa, mgmt->bssid,
+			mgmt->u.action.u.measurement.dialog_token);
+}
--- everything.orig/net/mac80211/ieee80211_i.h	2008-09-09 14:45:08.000000000 +0200
+++ everything/net/mac80211/ieee80211_i.h	2008-09-09 14:45:25.000000000 +0200
@@ -984,6 +984,11 @@ void ieee80211_process_addba_request(str
 				     struct ieee80211_mgmt *mgmt,
 				     size_t len);
 
+/* Spectrum management */
+void ieee80211_process_measurement_req(struct ieee80211_sub_if_data *sdata,
+				       struct ieee80211_mgmt *mgmt,
+				       size_t len);
+
 /* utility functions/constants */
 extern void *mac80211_wiphy_privid; /* for wiphy privid */
 extern const unsigned char rfc1042_header[6];
--- everything.orig/net/mac80211/Makefile	2008-09-09 14:46:44.000000000 +0200
+++ everything/net/mac80211/Makefile	2008-09-09 14:46:51.000000000 +0200
@@ -17,6 +17,7 @@ mac80211-y := \
 	aes_ccm.o \
 	cfg.o \
 	rx.o \
+	spectmgmt.o \
 	tx.o \
 	key.o \
 	util.o \


