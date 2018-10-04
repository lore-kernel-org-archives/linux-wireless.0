Return-Path: <SRS0=EqeY=MQ=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.6 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8BEC1C64EBC
	for <linux-wireless@archiver.kernel.org>; Thu,  4 Oct 2018 03:19:34 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 3D44120645
	for <linux-wireless@archiver.kernel.org>; Thu,  4 Oct 2018 03:19:34 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="RY84eOND";
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="hUbpC2sr"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 3D44120645
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-wireless-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727447AbeJDKKm (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Thu, 4 Oct 2018 06:10:42 -0400
Received: from smtp.codeaurora.org ([198.145.29.96]:48340 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726852AbeJDKKm (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 4 Oct 2018 06:10:42 -0400
Received: by smtp.codeaurora.org (Postfix, from userid 1000)
        id 4CBDF607F4; Thu,  4 Oct 2018 03:19:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1538623171;
        bh=kcGqn6WnMOdZzEFsjeHT/YqGjshRSQR81YpLXSuNF1E=;
        h=From:To:Cc:Subject:Date:From;
        b=RY84eONDpDgZghxGkx+DhAEYXvVYraHP8StMuxfXXEnqFHZZIfqc5SJC2iwT4gnzx
         Bab19/Xy2oG0YyTfQr+du+l2c1LAm4zJp2/B0yqcjTmVqpOFz3iYzRonrMmiW8kcEB
         NewQRT3mVElvmR6oR2QsOTdvyFZtsrAr9Q3LY9J0=
Received: from pradeepc-linux.qualcomm.com (i-global254.qualcomm.com [199.106.103.254])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-SHA256 (128/128 bits))
        (No client certificate requested)
        (Authenticated sender: pradeepc@codeaurora.org)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id A9F5160BE3;
        Thu,  4 Oct 2018 03:19:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1538623170;
        bh=kcGqn6WnMOdZzEFsjeHT/YqGjshRSQR81YpLXSuNF1E=;
        h=From:To:Cc:Subject:Date:From;
        b=hUbpC2srCHFXk2uVKCs3l1/DufarnvVFr2xcqWelDOpkaKBmDNWvhCHr44AWUmHnE
         fLtrVs2C0SpV5EYx4V8KaOnPpDan8ausNHquzwxJ4rqQ4tfyqE5/99fyORpzV4qgw4
         B6CQkYHty9KcgMu/xz2T2t7tsKp1RbX//v81fBFA=
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org A9F5160BE3
Authentication-Results: pdx-caf-mail.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: pdx-caf-mail.web.codeaurora.org; spf=none smtp.mailfrom=pradeepc@codeaurora.org
From:   Pradeep Kumar Chitrapu <pradeepc@codeaurora.org>
To:     Johannes Berg <johannes@sipsolutions.net>
Cc:     linux-wireless@vger.kernel.org,
        Pradeep Kumar Chitrapu <pradeepc@codeaurora.org>,
        David Spinadel <david.spinadel@intel.com>,
        Johannes Berg <johannes.berg@intel.com>
Subject: [PATCH] mac80211: support FTM responder configuration/statistics
Date:   Wed,  3 Oct 2018 20:19:20 -0700
Message-Id: <1538623160-25886-1-git-send-email-pradeepc@codeaurora.org>
X-Mailer: git-send-email 1.9.1
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

New bss param ftm_responder is used to notify the driver to
enable fine timing request (FTM) responder role in AP mode.

Plumb the new cfg80211 API for FTM responder statistics through to
the driver API in mac80211.

Signed-off-by: David Spinadel <david.spinadel@intel.com>
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Pradeep Kumar Chitrapu <pradeepc@codeaurora.org>
---
 include/net/mac80211.h    | 28 ++++++++++++++++
 net/mac80211/cfg.c        | 85 +++++++++++++++++++++++++++++++++++++++++++++++
 net/mac80211/driver-ops.h | 16 +++++++++
 net/mac80211/trace.h      | 23 +++++++++++++
 net/mac80211/util.c       |  5 +++
 5 files changed, 157 insertions(+)

diff --git a/include/net/mac80211.h b/include/net/mac80211.h
index c4fadbafbf21..2ccd4d1bef89 100644
--- a/include/net/mac80211.h
+++ b/include/net/mac80211.h
@@ -309,6 +309,8 @@ struct ieee80211_vif_chanctx_switch {
  * @BSS_CHANGED_KEEP_ALIVE: keep alive options (idle period or protected
  *	keep alive) changed.
  * @BSS_CHANGED_MCAST_RATE: Multicast Rate setting changed for this interface
+ * @BSS_CHANGED_FTM_RESPONDER: fime timing reasurement request responder
+ *	functionality changed for this BSS (AP mode).
  *
  */
 enum ieee80211_bss_change {
@@ -338,6 +340,7 @@ enum ieee80211_bss_change {
 	BSS_CHANGED_MU_GROUPS		= 1<<23,
 	BSS_CHANGED_KEEP_ALIVE		= 1<<24,
 	BSS_CHANGED_MCAST_RATE		= 1<<25,
+	BSS_CHANGED_FTM_RESPONDER	= 1<<26,
 
 	/* when adding here, make sure to change ieee80211_reconfig */
 };
@@ -464,6 +467,21 @@ struct ieee80211_mu_group_data {
 };
 
 /**
+ * ieee80211_ftm_responder_params - FTM responder parameters
+ *
+ * @lci: LCI subelement content
+ * @civicloc: CIVIC location subelement content
+ * @lci_len: LCI data length
+ * @civicloc_len: Civic data length
+ */
+struct ieee80211_ftm_responder_params {
+	const u8 *lci;
+	const u8 *civicloc;
+	size_t lci_len;
+	size_t civicloc_len;
+};
+
+/**
  * struct ieee80211_bss_conf - holds the BSS's changing parameters
  *
  * This structure keeps information about a BSS (and an association
@@ -562,6 +580,9 @@ struct ieee80211_mu_group_data {
  * @protected_keep_alive: if set, indicates that the station should send an RSN
  *	protected frame to the AP to reset the idle timer at the AP for the
  *	station.
+ * @ftm_responder: whether to enable or disable fine timing measurement FTM
+ *	responder functionality.
+ * @ftmr_params: configurable lci/civic parameter when enabling FTM responder.
  */
 struct ieee80211_bss_conf {
 	const u8 *bssid;
@@ -612,6 +633,8 @@ struct ieee80211_bss_conf {
 	bool allow_p2p_go_ps;
 	u16 max_idle_period;
 	bool protected_keep_alive;
+	bool ftm_responder;
+	struct ieee80211_ftm_responder_params *ftmr_params;
 };
 
 /**
@@ -3598,6 +3621,8 @@ enum ieee80211_reconfig_type {
  *	aggregating two specific frames in the same A-MSDU. The relation
  *	between the skbs should be symmetric and transitive. Note that while
  *	skb is always a real frame, head may or may not be an A-MSDU.
+ * @get_ftm_responder_stats: Retrieve FTM responder statistics, if available.
+ *	Statistics should be cumulative, currently no way to reset is provided.
  */
 struct ieee80211_ops {
 	void (*tx)(struct ieee80211_hw *hw,
@@ -3883,6 +3908,9 @@ struct ieee80211_ops {
 	bool (*can_aggregate_in_amsdu)(struct ieee80211_hw *hw,
 				       struct sk_buff *head,
 				       struct sk_buff *skb);
+	int (*get_ftm_responder_stats)(struct ieee80211_hw *hw,
+				       struct ieee80211_vif *vif,
+				       struct cfg80211_ftm_responder_stats *ftm_stats);
 };
 
 /**
diff --git a/net/mac80211/cfg.c b/net/mac80211/cfg.c
index 504627e2117f..c3904d45e82a 100644
--- a/net/mac80211/cfg.c
+++ b/net/mac80211/cfg.c
@@ -790,6 +790,48 @@ static int ieee80211_set_probe_resp(struct ieee80211_sub_if_data *sdata,
 	return 0;
 }
 
+static int ieee80211_set_ftm_responder_params(
+				struct ieee80211_sub_if_data *sdata,
+				const u8 *lci, size_t lci_len,
+				const u8 *civicloc, size_t civicloc_len)
+{
+	struct ieee80211_ftm_responder_params *new, *old;
+	struct ieee80211_bss_conf *bss_conf;
+	u8 *pos;
+	int len;
+
+	if ((!lci || !lci_len) && (!civicloc || !civicloc_len))
+		return 1;
+
+	bss_conf = &sdata->vif.bss_conf;
+	old = bss_conf->ftmr_params;
+	len = lci_len + civicloc_len;
+
+	new = kzalloc(sizeof(*new) + len, GFP_KERNEL);
+	if (!new)
+		return -ENOMEM;
+
+	pos = (u8 *)(new + 1);
+	if (lci_len) {
+		new->lci_len = lci_len;
+		new->lci = pos;
+		memcpy(pos, lci, lci_len);
+		pos += lci_len;
+	}
+
+	if (civicloc_len) {
+		new->civicloc_len = civicloc_len;
+		new->civicloc = pos;
+		memcpy(pos, civicloc, civicloc_len);
+		pos += civicloc_len;
+	}
+
+	bss_conf->ftmr_params = new;
+	kfree(old);
+
+	return 0;
+}
+
 static int ieee80211_assign_beacon(struct ieee80211_sub_if_data *sdata,
 				   struct cfg80211_beacon_data *params,
 				   const struct ieee80211_csa_settings *csa)
@@ -863,6 +905,20 @@ static int ieee80211_assign_beacon(struct ieee80211_sub_if_data *sdata,
 	if (err == 0)
 		changed |= BSS_CHANGED_AP_PROBE_RESP;
 
+	if (params->ftm_responder != -1) {
+		sdata->vif.bss_conf.ftm_responder = params->ftm_responder;
+		err = ieee80211_set_ftm_responder_params(sdata,
+							 params->lci,
+							 params->lci_len,
+							 params->civicloc,
+							 params->civicloc_len);
+
+		if (err < 0)
+			return err;
+
+		changed |= BSS_CHANGED_FTM_RESPONDER;
+	}
+
 	rcu_assign_pointer(sdata->u.ap.beacon, new);
 
 	if (old)
@@ -1063,6 +1119,9 @@ static int ieee80211_stop_ap(struct wiphy *wiphy, struct net_device *dev)
 		kfree_rcu(old_probe_resp, rcu_head);
 	sdata->u.ap.driver_smps_mode = IEEE80211_SMPS_OFF;
 
+	kfree(sdata->vif.bss_conf.ftmr_params);
+	sdata->vif.bss_conf.ftmr_params = NULL;
+
 	__sta_info_flush(sdata, true);
 	ieee80211_free_keys(sdata, true);
 
@@ -2875,6 +2934,20 @@ static int ieee80211_start_radar_detection(struct wiphy *wiphy,
 		memcpy(pos, beacon->probe_resp, beacon->probe_resp_len);
 		pos += beacon->probe_resp_len;
 	}
+	if (beacon->ftm_responder)
+		new_beacon->ftm_responder = beacon->ftm_responder;
+	if (beacon->lci) {
+		new_beacon->lci_len = beacon->lci_len;
+		new_beacon->lci = pos;
+		memcpy(pos, beacon->lci, beacon->lci_len);
+		pos += beacon->lci_len;
+	}
+	if (beacon->civicloc) {
+		new_beacon->civicloc_len = beacon->civicloc_len;
+		new_beacon->civicloc = pos;
+		memcpy(pos, beacon->civicloc, beacon->civicloc_len);
+		pos += beacon->civicloc_len;
+	}
 
 	return new_beacon;
 }
@@ -3765,6 +3838,17 @@ static int ieee80211_get_txq_stats(struct wiphy *wiphy,
 	return ret;
 }
 
+static int
+ieee80211_get_ftm_responder_stats(struct wiphy *wiphy,
+				  struct net_device *dev,
+				  struct cfg80211_ftm_responder_stats *ftm_stats)
+{
+	struct ieee80211_local *local = wiphy_priv(wiphy);
+	struct ieee80211_sub_if_data *sdata = IEEE80211_DEV_TO_SUB_IF(dev);
+
+	return drv_get_ftm_responder_stats(local, sdata, ftm_stats);
+}
+
 const struct cfg80211_ops mac80211_config_ops = {
 	.add_virtual_intf = ieee80211_add_iface,
 	.del_virtual_intf = ieee80211_del_iface,
@@ -3859,4 +3943,5 @@ static int ieee80211_get_txq_stats(struct wiphy *wiphy,
 	.set_multicast_to_unicast = ieee80211_set_multicast_to_unicast,
 	.tx_control_port = ieee80211_tx_control_port,
 	.get_txq_stats = ieee80211_get_txq_stats,
+	.get_ftm_responder_stats = ieee80211_get_ftm_responder_stats,
 };
diff --git a/net/mac80211/driver-ops.h b/net/mac80211/driver-ops.h
index e42c641b6190..0b1747a2313d 100644
--- a/net/mac80211/driver-ops.h
+++ b/net/mac80211/driver-ops.h
@@ -1183,6 +1183,22 @@ static inline int drv_can_aggregate_in_amsdu(struct ieee80211_local *local,
 	return local->ops->can_aggregate_in_amsdu(&local->hw, head, skb);
 }
 
+static inline int
+drv_get_ftm_responder_stats(struct ieee80211_local *local,
+			    struct ieee80211_sub_if_data *sdata,
+			    struct cfg80211_ftm_responder_stats *ftm_stats)
+{
+	u32 ret = -EOPNOTSUPP;
+
+	if (local->ops->get_ftm_responder_stats)
+		ret = local->ops->get_ftm_responder_stats(&local->hw,
+							 &sdata->vif,
+							 ftm_stats);
+	trace_drv_get_ftm_responder_stats(local, sdata, ftm_stats);
+
+	return ret;
+}
+
 static inline int drv_start_nan(struct ieee80211_local *local,
 				struct ieee80211_sub_if_data *sdata,
 				struct cfg80211_nan_conf *conf)
diff --git a/net/mac80211/trace.h b/net/mac80211/trace.h
index 0ab69a1964f8..588c51a67c89 100644
--- a/net/mac80211/trace.h
+++ b/net/mac80211/trace.h
@@ -2600,6 +2600,29 @@ struct trace_switch_entry {
 	)
 );
 
+TRACE_EVENT(drv_get_ftm_responder_stats,
+	TP_PROTO(struct ieee80211_local *local,
+		 struct ieee80211_sub_if_data *sdata,
+		 struct cfg80211_ftm_responder_stats *ftm_stats),
+
+	TP_ARGS(local, sdata, ftm_stats),
+
+	TP_STRUCT__entry(
+		LOCAL_ENTRY
+		VIF_ENTRY
+	),
+
+	TP_fast_assign(
+		LOCAL_ASSIGN;
+		VIF_ASSIGN;
+	),
+
+	TP_printk(
+		LOCAL_PR_FMT VIF_PR_FMT,
+		LOCAL_PR_ARG, VIF_PR_ARG
+	)
+);
+
 #endif /* !__MAC80211_DRIVER_TRACE || TRACE_HEADER_MULTI_READ */
 
 #undef TRACE_INCLUDE_PATH
diff --git a/net/mac80211/util.c b/net/mac80211/util.c
index ef5d1f60a63b..bec424316ea4 100644
--- a/net/mac80211/util.c
+++ b/net/mac80211/util.c
@@ -2178,6 +2178,11 @@ int ieee80211_reconfig(struct ieee80211_local *local)
 		case NL80211_IFTYPE_AP:
 			changed |= BSS_CHANGED_SSID | BSS_CHANGED_P2P_PS;
 
+			if (sdata->vif.bss_conf.ftm_responder == 1 &&
+			    wiphy_ext_feature_isset(sdata->local->hw.wiphy,
+					NL80211_EXT_FEATURE_ENABLE_FTM_RESPONDER))
+				changed |= BSS_CHANGED_FTM_RESPONDER;
+
 			if (sdata->vif.type == NL80211_IFTYPE_AP) {
 				changed |= BSS_CHANGED_AP_PROBE_RESP;
 
-- 
1.9.1

