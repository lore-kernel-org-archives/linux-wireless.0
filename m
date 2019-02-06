Return-Path: <SRS0=cSSL=QN=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5F04EC169C4
	for <linux-wireless@archiver.kernel.org>; Wed,  6 Feb 2019 11:17:34 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 3714E2080D
	for <linux-wireless@archiver.kernel.org>; Wed,  6 Feb 2019 11:17:34 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729829AbfBFLRd (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Wed, 6 Feb 2019 06:17:33 -0500
Received: from paleale.coelho.fi ([176.9.41.70]:55702 "EHLO
        farmhouse.coelho.fi" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1729217AbfBFLRc (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 6 Feb 2019 06:17:32 -0500
Received: from 91-156-4-241.elisa-laajakaista.fi ([91.156.4.241] helo=redipa.ger.corp.intel.com)
        by farmhouse.coelho.fi with esmtpsa (TLS1.2:ECDHE_RSA_AES_128_GCM_SHA256:128)
        (Exim 4.91)
        (envelope-from <luca@coelho.fi>)
        id 1grLCs-0001ED-5A; Wed, 06 Feb 2019 13:17:30 +0200
From:   Luca Coelho <luca@coelho.fi>
To:     johannes@sipsolutions.net
Cc:     linux-wireless@vger.kernel.org,
        Sara Sharon <sara.sharon@intel.com>,
        Luca Coelho <luciano.coelho@intel.com>
Date:   Wed,  6 Feb 2019 13:17:10 +0200
Message-Id: <20190206111721.29283-5-luca@coelho.fi>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190206111721.29283-1-luca@coelho.fi>
References: <20190206111721.29283-1-luca@coelho.fi>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: [PATCH 04/15] mac80211: abort CSA if beacon does not include CSA IEs
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

From: Sara Sharon <sara.sharon@intel.com>

In case we receive a beacon without CSA IE while we are in
the middle of channel switch - abort the operation.

Signed-off-by: Sara Sharon <sara.sharon@intel.com>
Signed-off-by: Luca Coelho <luciano.coelho@intel.com>
---
 include/net/mac80211.h    |  5 +++++
 net/mac80211/driver-ops.h | 14 +++++++++++++
 net/mac80211/mlme.c       | 43 +++++++++++++++++++++++++++++++++------
 net/mac80211/trace.h      |  6 ++++++
 4 files changed, 62 insertions(+), 6 deletions(-)

diff --git a/include/net/mac80211.h b/include/net/mac80211.h
index 29e1350a30b6..45166e82c937 100644
--- a/include/net/mac80211.h
+++ b/include/net/mac80211.h
@@ -3621,6 +3621,9 @@ enum ieee80211_reconfig_type {
  * @post_channel_switch: This is an optional callback that is called
  *	after a channel switch procedure is completed, allowing the
  *	driver to go back to a normal configuration.
+ * @abort_channel_switch: This is an optional callback that is called
+ *	when channel switch procedure was completed, allowing the
+ *	driver to go back to a normal configuration.
  *
  * @join_ibss: Join an IBSS (on an IBSS interface); this is called after all
  *	information in bss_conf is set up and the beacon can be retrieved. A
@@ -3924,6 +3927,8 @@ struct ieee80211_ops {
 
 	int (*post_channel_switch)(struct ieee80211_hw *hw,
 				   struct ieee80211_vif *vif);
+	void (*abort_channel_switch)(struct ieee80211_hw *hw,
+				     struct ieee80211_vif *vif);
 
 	int (*join_ibss)(struct ieee80211_hw *hw, struct ieee80211_vif *vif);
 	void (*leave_ibss)(struct ieee80211_hw *hw, struct ieee80211_vif *vif);
diff --git a/net/mac80211/driver-ops.h b/net/mac80211/driver-ops.h
index ba3c07b10cd0..e069122595d0 100644
--- a/net/mac80211/driver-ops.h
+++ b/net/mac80211/driver-ops.h
@@ -1052,6 +1052,20 @@ drv_post_channel_switch(struct ieee80211_sub_if_data *sdata)
 	return ret;
 }
 
+static inline void
+drv_abort_channel_switch(struct ieee80211_sub_if_data *sdata)
+{
+	struct ieee80211_local *local = sdata->local;
+
+	if (!check_sdata_in_driver(sdata))
+		return;
+
+	trace_drv_abort_channel_switch(local, sdata);
+
+	if (local->ops->abort_channel_switch)
+		local->ops->abort_channel_switch(&local->hw, &sdata->vif);
+}
+
 static inline int drv_join_ibss(struct ieee80211_local *local,
 				struct ieee80211_sub_if_data *sdata)
 {
diff --git a/net/mac80211/mlme.c b/net/mac80211/mlme.c
index 1deb6bb62eb0..1cc9dbbc2098 100644
--- a/net/mac80211/mlme.c
+++ b/net/mac80211/mlme.c
@@ -1237,6 +1237,32 @@ static void ieee80211_chswitch_timer(struct timer_list *t)
 	ieee80211_queue_work(&sdata->local->hw, &sdata->u.mgd.chswitch_work);
 }
 
+static void
+ieee80211_sta_abort_chanswitch(struct ieee80211_sub_if_data *sdata)
+{
+	struct ieee80211_local *local = sdata->local;
+
+	if (!local->ops->abort_channel_switch)
+		return;
+
+	mutex_lock(&local->mtx);
+
+	mutex_lock(&local->chanctx_mtx);
+	ieee80211_vif_unreserve_chanctx(sdata);
+	mutex_unlock(&local->chanctx_mtx);
+
+	if (sdata->csa_block_tx)
+		ieee80211_wake_vif_queues(local, sdata,
+					  IEEE80211_QUEUE_STOP_REASON_CSA);
+
+	sdata->csa_block_tx = false;
+	sdata->vif.csa_active = false;
+
+	mutex_unlock(&local->mtx);
+
+	drv_abort_channel_switch(sdata);
+}
+
 static void
 ieee80211_sta_process_chanswitch(struct ieee80211_sub_if_data *sdata,
 				 u64 timestamp, u32 device_timestamp,
@@ -1261,19 +1287,24 @@ ieee80211_sta_process_chanswitch(struct ieee80211_sub_if_data *sdata,
 	if (local->scanning)
 		return;
 
-	/* disregard subsequent announcements if we are already processing */
-	if (sdata->vif.csa_active)
-		return;
-
 	current_band = cbss->channel->band;
 	res = ieee80211_parse_ch_switch_ie(sdata, elems, current_band,
 					   ifmgd->flags,
 					   ifmgd->associated->bssid, &csa_ie);
-	if (res	< 0)
+	if (res < 0) {
 		ieee80211_queue_work(&local->hw,
 				     &ifmgd->csa_connection_drop_work);
-	if (res)
 		return;
+	}
+
+	if (res && beacon && sdata->vif.csa_active &&
+	    !ifmgd->csa_waiting_bcn) {
+		ieee80211_sta_abort_chanswitch(sdata);
+		return;
+	} else if (sdata->vif.csa_active || res) {
+		/* disregard subsequent announcements if already processing */
+		return;
+	}
 
 	if (!cfg80211_chandef_usable(local->hw.wiphy, &csa_ie.chandef,
 				     IEEE80211_CHAN_DISABLED)) {
diff --git a/net/mac80211/trace.h b/net/mac80211/trace.h
index 35ea0dcb55e6..c1e203fe281e 100644
--- a/net/mac80211/trace.h
+++ b/net/mac80211/trace.h
@@ -2452,6 +2452,12 @@ DEFINE_EVENT(local_sdata_evt, drv_post_channel_switch,
 	     TP_ARGS(local, sdata)
 );
 
+DEFINE_EVENT(local_sdata_evt, drv_abort_channel_switch,
+	     TP_PROTO(struct ieee80211_local *local,
+		      struct ieee80211_sub_if_data *sdata),
+	     TP_ARGS(local, sdata)
+);
+
 TRACE_EVENT(drv_get_txpower,
 	TP_PROTO(struct ieee80211_local *local,
 		 struct ieee80211_sub_if_data *sdata,
-- 
2.20.1

