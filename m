Return-Path: <SRS0=cSSL=QN=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CB00FC169C4
	for <linux-wireless@archiver.kernel.org>; Wed,  6 Feb 2019 11:17:38 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 9A18A2080D
	for <linux-wireless@archiver.kernel.org>; Wed,  6 Feb 2019 11:17:38 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729858AbfBFLRh (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Wed, 6 Feb 2019 06:17:37 -0500
Received: from paleale.coelho.fi ([176.9.41.70]:55750 "EHLO
        farmhouse.coelho.fi" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1727501AbfBFLRg (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 6 Feb 2019 06:17:36 -0500
Received: from 91-156-4-241.elisa-laajakaista.fi ([91.156.4.241] helo=redipa.ger.corp.intel.com)
        by farmhouse.coelho.fi with esmtpsa (TLS1.2:ECDHE_RSA_AES_128_GCM_SHA256:128)
        (Exim 4.91)
        (envelope-from <luca@coelho.fi>)
        id 1grLCw-0001ED-7X; Wed, 06 Feb 2019 13:17:34 +0200
From:   Luca Coelho <luca@coelho.fi>
To:     johannes@sipsolutions.net
Cc:     linux-wireless@vger.kernel.org,
        Sara Sharon <sara.sharon@intel.com>,
        Luca Coelho <luciano.coelho@intel.com>
Date:   Wed,  6 Feb 2019 13:17:15 +0200
Message-Id: <20190206111721.29283-10-luca@coelho.fi>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190206111721.29283-1-luca@coelho.fi>
References: <20190206111721.29283-1-luca@coelho.fi>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: [PATCH 09/15] mac80211: notify driver on subsequent CSA beacons
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

From: Sara Sharon <sara.sharon@intel.com>

Some drivers may want to track further the CSA beacons, for example
to compensate for buggy APs that change the beacon count or quiet
mode during CSA flow.

Signed-off-by: Sara Sharon <sara.sharon@intel.com>
Signed-off-by: Luca Coelho <luciano.coelho@intel.com>
---
 include/net/mac80211.h    |  9 +++++++--
 net/mac80211/driver-ops.h | 17 ++++++++++++++++-
 net/mac80211/mlme.c       | 27 +++++++++++++++-----------
 net/mac80211/trace.h      | 40 +++++++++++++++++++++++++++++++++++++--
 4 files changed, 77 insertions(+), 16 deletions(-)

diff --git a/include/net/mac80211.h b/include/net/mac80211.h
index 45166e82c937..6aa7845e895b 100644
--- a/include/net/mac80211.h
+++ b/include/net/mac80211.h
@@ -6,7 +6,7 @@
  * Copyright 2007-2010	Johannes Berg <johannes@sipsolutions.net>
  * Copyright 2013-2014  Intel Mobile Communications GmbH
  * Copyright (C) 2015 - 2017 Intel Deutschland GmbH
- * Copyright (C) 2018        Intel Corporation
+ * Copyright (C) 2018 - 2019 Intel Corporation
  *
  * This program is free software; you can redistribute it and/or modify
  * it under the terms of the GNU General Public License version 2 as
@@ -3624,7 +3624,9 @@ enum ieee80211_reconfig_type {
  * @abort_channel_switch: This is an optional callback that is called
  *	when channel switch procedure was completed, allowing the
  *	driver to go back to a normal configuration.
- *
+ * @channel_switch_rx_beacon: This is an optional callback that is called
+ *	when channel switch procedure is in progress and additional beacon with
+ *	CSA IE was received, allowing driver to track changes in count.
  * @join_ibss: Join an IBSS (on an IBSS interface); this is called after all
  *	information in bss_conf is set up and the beacon can be retrieved. A
  *	channel context is bound before this is called.
@@ -3929,6 +3931,9 @@ struct ieee80211_ops {
 				   struct ieee80211_vif *vif);
 	void (*abort_channel_switch)(struct ieee80211_hw *hw,
 				     struct ieee80211_vif *vif);
+	void (*channel_switch_rx_beacon)(struct ieee80211_hw *hw,
+					 struct ieee80211_vif *vif,
+					 struct ieee80211_channel_switch *ch_switch);
 
 	int (*join_ibss)(struct ieee80211_hw *hw, struct ieee80211_vif *vif);
 	void (*leave_ibss)(struct ieee80211_hw *hw, struct ieee80211_vif *vif);
diff --git a/net/mac80211/driver-ops.h b/net/mac80211/driver-ops.h
index e069122595d0..28d022a3eee3 100644
--- a/net/mac80211/driver-ops.h
+++ b/net/mac80211/driver-ops.h
@@ -2,7 +2,7 @@
 /*
 * Portions of this file
 * Copyright(c) 2016 Intel Deutschland GmbH
-* Copyright (C) 2018 Intel Corporation
+* Copyright (C) 2018 - 2019 Intel Corporation
 */
 
 #ifndef __MAC80211_DRIVER_OPS
@@ -1066,6 +1066,21 @@ drv_abort_channel_switch(struct ieee80211_sub_if_data *sdata)
 		local->ops->abort_channel_switch(&local->hw, &sdata->vif);
 }
 
+static inline void
+drv_channel_switch_rx_beacon(struct ieee80211_sub_if_data *sdata,
+			     struct ieee80211_channel_switch *ch_switch)
+{
+	struct ieee80211_local *local = sdata->local;
+
+	if (!check_sdata_in_driver(sdata))
+		return;
+
+	trace_drv_channel_switch_rx_beacon(local, sdata, ch_switch);
+	if (local->ops->channel_switch_rx_beacon)
+		local->ops->channel_switch_rx_beacon(&local->hw, &sdata->vif,
+						     ch_switch);
+}
+
 static inline int drv_join_ibss(struct ieee80211_local *local,
 				struct ieee80211_sub_if_data *sdata)
 {
diff --git a/net/mac80211/mlme.c b/net/mac80211/mlme.c
index 1cc9dbbc2098..ad963204ece9 100644
--- a/net/mac80211/mlme.c
+++ b/net/mac80211/mlme.c
@@ -7,7 +7,7 @@
  * Copyright 2007, Michael Wu <flamingice@sourmilk.net>
  * Copyright 2013-2014  Intel Mobile Communications GmbH
  * Copyright (C) 2015 - 2017 Intel Deutschland GmbH
- * Copyright (C) 2018        Intel Corporation
+ * Copyright (C) 2018 - 2019 Intel Corporation
  *
  * This program is free software; you can redistribute it and/or modify
  * it under the terms of the GNU General Public License version 2 as
@@ -1291,15 +1291,27 @@ ieee80211_sta_process_chanswitch(struct ieee80211_sub_if_data *sdata,
 	res = ieee80211_parse_ch_switch_ie(sdata, elems, current_band,
 					   ifmgd->flags,
 					   ifmgd->associated->bssid, &csa_ie);
+
+	if (!res) {
+		ch_switch.timestamp = timestamp;
+		ch_switch.device_timestamp = device_timestamp;
+		ch_switch.block_tx = csa_ie.mode;
+		ch_switch.chandef = csa_ie.chandef;
+		ch_switch.count = csa_ie.count;
+		ch_switch.delay = csa_ie.max_switch_time;
+	}
+
 	if (res < 0) {
 		ieee80211_queue_work(&local->hw,
 				     &ifmgd->csa_connection_drop_work);
 		return;
 	}
 
-	if (res && beacon && sdata->vif.csa_active &&
-	    !ifmgd->csa_waiting_bcn) {
-		ieee80211_sta_abort_chanswitch(sdata);
+	if (beacon && sdata->vif.csa_active && !ifmgd->csa_waiting_bcn) {
+		if (res)
+			ieee80211_sta_abort_chanswitch(sdata);
+		else
+			drv_channel_switch_rx_beacon(sdata, &ch_switch);
 		return;
 	} else if (sdata->vif.csa_active || res) {
 		/* disregard subsequent announcements if already processing */
@@ -1357,13 +1369,6 @@ ieee80211_sta_process_chanswitch(struct ieee80211_sub_if_data *sdata,
 		goto drop_connection;
 	}
 
-	ch_switch.timestamp = timestamp;
-	ch_switch.device_timestamp = device_timestamp;
-	ch_switch.block_tx = csa_ie.mode;
-	ch_switch.chandef = csa_ie.chandef;
-	ch_switch.count = csa_ie.count;
-	ch_switch.delay = csa_ie.max_switch_time;
-
 	if (drv_pre_channel_switch(sdata, &ch_switch)) {
 		sdata_info(sdata,
 			   "preparing for channel switch failed, disconnecting\n");
diff --git a/net/mac80211/trace.h b/net/mac80211/trace.h
index c1e203fe281e..8ba70d26b82e 100644
--- a/net/mac80211/trace.h
+++ b/net/mac80211/trace.h
@@ -1,8 +1,8 @@
 /* SPDX-License-Identifier: GPL-2.0 */
 /*
 * Portions of this file
-* Copyright(c) 2016 Intel Deutschland GmbH
-* Copyright (C) 2018 Intel Corporation
+* Copyright(c) 2016-2017 Intel Deutschland GmbH
+* Copyright (C) 2018 - 2019 Intel Corporation
 */
 
 #if !defined(__MAC80211_DRIVER_TRACE) || defined(TRACE_HEADER_MULTI_READ)
@@ -2458,6 +2458,42 @@ DEFINE_EVENT(local_sdata_evt, drv_abort_channel_switch,
 	     TP_ARGS(local, sdata)
 );
 
+TRACE_EVENT(drv_channel_switch_rx_beacon,
+	TP_PROTO(struct ieee80211_local *local,
+		 struct ieee80211_sub_if_data *sdata,
+		 struct ieee80211_channel_switch *ch_switch),
+
+	TP_ARGS(local, sdata, ch_switch),
+
+	TP_STRUCT__entry(
+		LOCAL_ENTRY
+		VIF_ENTRY
+		CHANDEF_ENTRY
+		__field(u64, timestamp)
+		__field(u32, device_timestamp)
+		__field(bool, block_tx)
+		__field(u8, count)
+	),
+
+	TP_fast_assign(
+		LOCAL_ASSIGN;
+		VIF_ASSIGN;
+		CHANDEF_ASSIGN(&ch_switch->chandef)
+		__entry->timestamp = ch_switch->timestamp;
+		__entry->device_timestamp = ch_switch->device_timestamp;
+		__entry->block_tx = ch_switch->block_tx;
+		__entry->count = ch_switch->count;
+	),
+
+	TP_printk(
+		LOCAL_PR_FMT VIF_PR_FMT
+		" received a channel switch beacon to "
+		CHANDEF_PR_FMT  " count:%d block_tx:%d timestamp:%llu",
+		LOCAL_PR_ARG, VIF_PR_ARG, CHANDEF_PR_ARG, __entry->count,
+		__entry->block_tx, __entry->timestamp
+	)
+);
+
 TRACE_EVENT(drv_get_txpower,
 	TP_PROTO(struct ieee80211_local *local,
 		 struct ieee80211_sub_if_data *sdata,
-- 
2.20.1

