Return-Path: <SRS0=hbYo=M5=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 50233ECDE32
	for <linux-wireless@archiver.kernel.org>; Wed, 17 Oct 2018 12:33:26 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 2096E214DD
	for <linux-wireless@archiver.kernel.org>; Wed, 17 Oct 2018 12:33:26 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 2096E214DD
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=sipsolutions.net
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-wireless-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727139AbeJQU2y (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Wed, 17 Oct 2018 16:28:54 -0400
Received: from s3.sipsolutions.net ([144.76.43.62]:45358 "EHLO
        sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727013AbeJQU2y (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 17 Oct 2018 16:28:54 -0400
Received: by sipsolutions.net with esmtpsa (TLS1.2:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.91)
        (envelope-from <johannes@sipsolutions.net>)
        id 1gCl0s-00017e-5s; Wed, 17 Oct 2018 14:33:22 +0200
From:   Johannes Berg <johannes@sipsolutions.net>
To:     linux-wireless@vger.kernel.org
Cc:     Pradeep Kumar Chitrapu <pradeepc@codeaurora.org>,
        Lior David <liord@codeaurora.org>, luca@coelho.fi,
        Etan Cohen <etancohen@google.com>,
        Roy Want <roywant@google.com>,
        Arend Van Spriel <arend.vanspriel@broadcom.com>,
        Franky Lin <franky.lin@broadcom.com>,
        Johannes Berg <johannes.berg@intel.com>
Subject: [PATCH v5 2/2] mac80211: allow drivers to use peer measurement API
Date:   Wed, 17 Oct 2018 14:33:06 +0200
Message-Id: <20181017123306.11716-2-johannes@sipsolutions.net>
X-Mailer: git-send-email 2.17.2
In-Reply-To: <20181017123306.11716-1-johannes@sipsolutions.net>
References: <20181017123306.11716-1-johannes@sipsolutions.net>
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

From: Johannes Berg <johannes.berg@intel.com>

There's nothing much for mac80211 to do, so only pass through
the requests with minimal checks and tracing. The driver must
call cfg80211's results APIs.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
v4: first version - just takes the same number as the cfg80211 patch
v5: no changes
---
 include/net/mac80211.h    |  7 +++++++
 net/mac80211/cfg.c        | 22 ++++++++++++++++++++++
 net/mac80211/driver-ops.h | 34 ++++++++++++++++++++++++++++++++++
 net/mac80211/trace.h      | 12 ++++++++++++
 4 files changed, 75 insertions(+)

diff --git a/include/net/mac80211.h b/include/net/mac80211.h
index 71985e95d2d9..e3d57e7a55cc 100644
--- a/include/net/mac80211.h
+++ b/include/net/mac80211.h
@@ -3623,6 +3623,9 @@ enum ieee80211_reconfig_type {
  *	skb is always a real frame, head may or may not be an A-MSDU.
  * @get_ftm_responder_stats: Retrieve FTM responder statistics, if available.
  *	Statistics should be cumulative, currently no way to reset is provided.
+ *
+ * @start_pmsr: start peer measurement (e.g. FTM) (this call can sleep)
+ * @abort_pmsr: abort peer measurement (this call can sleep)
  */
 struct ieee80211_ops {
 	void (*tx)(struct ieee80211_hw *hw,
@@ -3911,6 +3914,10 @@ struct ieee80211_ops {
 	int (*get_ftm_responder_stats)(struct ieee80211_hw *hw,
 				       struct ieee80211_vif *vif,
 				       struct cfg80211_ftm_responder_stats *ftm_stats);
+	int (*start_pmsr)(struct ieee80211_hw *hw, struct ieee80211_vif *vif,
+			  struct cfg80211_pmsr_request *request);
+	void (*abort_pmsr)(struct ieee80211_hw *hw, struct ieee80211_vif *vif,
+			   struct cfg80211_pmsr_request *request);
 };
 
 /**
diff --git a/net/mac80211/cfg.c b/net/mac80211/cfg.c
index 51622333d460..2fccccfbbf4d 100644
--- a/net/mac80211/cfg.c
+++ b/net/mac80211/cfg.c
@@ -3849,6 +3849,26 @@ ieee80211_get_ftm_responder_stats(struct wiphy *wiphy,
 	return drv_get_ftm_responder_stats(local, sdata, ftm_stats);
 }
 
+static int
+ieee80211_start_pmsr(struct wiphy *wiphy, struct wireless_dev *dev,
+		     struct cfg80211_pmsr_request *request)
+{
+	struct ieee80211_local *local = wiphy_priv(wiphy);
+	struct ieee80211_sub_if_data *sdata = IEEE80211_WDEV_TO_SUB_IF(dev);
+
+	return drv_start_pmsr(local, sdata, request);
+}
+
+static void
+ieee80211_abort_pmsr(struct wiphy *wiphy, struct wireless_dev *dev,
+		     struct cfg80211_pmsr_request *request)
+{
+	struct ieee80211_local *local = wiphy_priv(wiphy);
+	struct ieee80211_sub_if_data *sdata = IEEE80211_WDEV_TO_SUB_IF(dev);
+
+	return drv_abort_pmsr(local, sdata, request);
+}
+
 const struct cfg80211_ops mac80211_config_ops = {
 	.add_virtual_intf = ieee80211_add_iface,
 	.del_virtual_intf = ieee80211_del_iface,
@@ -3944,4 +3964,6 @@ const struct cfg80211_ops mac80211_config_ops = {
 	.tx_control_port = ieee80211_tx_control_port,
 	.get_txq_stats = ieee80211_get_txq_stats,
 	.get_ftm_responder_stats = ieee80211_get_ftm_responder_stats,
+	.start_pmsr = ieee80211_start_pmsr,
+	.abort_pmsr = ieee80211_abort_pmsr,
 };
diff --git a/net/mac80211/driver-ops.h b/net/mac80211/driver-ops.h
index 0b1747a2313d..3e0d5922a440 100644
--- a/net/mac80211/driver-ops.h
+++ b/net/mac80211/driver-ops.h
@@ -1199,6 +1199,40 @@ drv_get_ftm_responder_stats(struct ieee80211_local *local,
 	return ret;
 }
 
+static inline int drv_start_pmsr(struct ieee80211_local *local,
+				 struct ieee80211_sub_if_data *sdata,
+				 struct cfg80211_pmsr_request *request)
+{
+	int ret = -EOPNOTSUPP;
+
+	might_sleep();
+	if (!check_sdata_in_driver(sdata))
+		return -EIO;
+
+	trace_drv_start_pmsr(local, sdata);
+
+	if (local->ops->start_pmsr)
+		ret = local->ops->start_pmsr(&local->hw, &sdata->vif, request);
+	trace_drv_return_int(local, ret);
+
+	return ret;
+}
+
+static inline void drv_abort_pmsr(struct ieee80211_local *local,
+				  struct ieee80211_sub_if_data *sdata,
+				  struct cfg80211_pmsr_request *request)
+{
+	trace_drv_abort_pmsr(local, sdata);
+
+	might_sleep();
+	if (!check_sdata_in_driver(sdata))
+		return;
+
+	if (local->ops->abort_pmsr)
+		local->ops->abort_pmsr(&local->hw, &sdata->vif, request);
+	trace_drv_return_void(local);
+}
+
 static inline int drv_start_nan(struct ieee80211_local *local,
 				struct ieee80211_sub_if_data *sdata,
 				struct cfg80211_nan_conf *conf)
diff --git a/net/mac80211/trace.h b/net/mac80211/trace.h
index 588c51a67c89..ac2f1922d469 100644
--- a/net/mac80211/trace.h
+++ b/net/mac80211/trace.h
@@ -1882,6 +1882,18 @@ TRACE_EVENT(drv_del_nan_func,
 	)
 );
 
+DEFINE_EVENT(local_sdata_evt, drv_start_pmsr,
+	TP_PROTO(struct ieee80211_local *local,
+		 struct ieee80211_sub_if_data *sdata),
+	TP_ARGS(local, sdata)
+);
+
+DEFINE_EVENT(local_sdata_evt, drv_abort_pmsr,
+	TP_PROTO(struct ieee80211_local *local,
+		 struct ieee80211_sub_if_data *sdata),
+	TP_ARGS(local, sdata)
+);
+
 /*
  * Tracing for API calls that drivers call.
  */
-- 
2.17.2

