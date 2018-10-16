Return-Path: <SRS0=k7+a=M4=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.6 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9F665C5ACCA
	for <linux-wireless@archiver.kernel.org>; Tue, 16 Oct 2018 18:42:56 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 5950C2098A
	for <linux-wireless@archiver.kernel.org>; Tue, 16 Oct 2018 18:42:56 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="HkoEv0pu";
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="SeJUinsW"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 5950C2098A
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-wireless-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727377AbeJQCel (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Tue, 16 Oct 2018 22:34:41 -0400
Received: from smtp.codeaurora.org ([198.145.29.96]:51584 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727006AbeJQCel (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 16 Oct 2018 22:34:41 -0400
Received: by smtp.codeaurora.org (Postfix, from userid 1000)
        id 2445C61311; Tue, 16 Oct 2018 18:42:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1539715374;
        bh=eL9qDZzXrcvzVKCRlFObzeWGXEZrr2Z17WzpMrK3Ufg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=HkoEv0puCIKrIvyVeA7mwNqU8XjZd5Y+M8rpG2BnxZhsO4OjPaHqI3zKRYuC69I5A
         WKekv0BiqeQ4VR8yQg5mwJuwW+XDKkM4y4LwQkD+w37RKatjFX6ZfqFmmo9lr963cp
         xH/WssRDOq5vAsB1ddpO0WVX1PyXXGlVNGGXPs3Q=
Received: from cheath10p342229-lin.qca.qualcomm.com (blr-c-bdr-fw-01_globalnat_allzones-outside.qualcomm.com [103.229.19.19])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-SHA256 (128/128 bits))
        (No client certificate requested)
        (Authenticated sender: tamizhr@smtp.codeaurora.org)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id E447F61308;
        Tue, 16 Oct 2018 18:42:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1539715373;
        bh=eL9qDZzXrcvzVKCRlFObzeWGXEZrr2Z17WzpMrK3Ufg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=SeJUinsWdlK9ScCmOWVfzT2tkAnjPOlfs/VAvkbnsQY5g54DwFr3O5XkhLwvsgfLH
         klrQuz718NQ7rXEgP8baSv2/1cXkt6tX5P61MLZZjHRD1FCuv2UALho2oU9uzeM4w6
         F9iZyvwiSWbolFB1Ta0gi5b2UZx7R1L3Y5HsRlH8=
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org E447F61308
Authentication-Results: pdx-caf-mail.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: pdx-caf-mail.web.codeaurora.org; spf=none smtp.mailfrom=tamizhr@codeaurora.org
From:   Tamizh chelvam <tamizhr@codeaurora.org>
To:     ath10k@lists.infradead.org, johannes@sipsolutions.net
Cc:     linux-wireless@vger.kernel.org,
        Vasanthakumar Thiagarajan <vthiagar@codeaurora.org>,
        Tamizh chelvam <tamizhr@codeaurora.org>
Subject: [PATCH 1/6] mac80211: Add NoAck policy functionality offload infrastructure
Date:   Wed, 17 Oct 2018 00:11:06 +0530
Message-Id: <1539715271-14325-2-git-send-email-tamizhr@codeaurora.org>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1539715271-14325-1-git-send-email-tamizhr@codeaurora.org>
References: <1539715271-14325-1-git-send-email-tamizhr@codeaurora.org>
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

From: Vasanthakumar Thiagarajan <vthiagar@codeaurora.org>

Add infrastructure for drivers to implement NoAck policy functionlity.
Driver like ath10k does not use the per-packet TID NoAck policy
configuration.  Instead NoAck map is sent to the firmware/hardware
in control path. Firmware takes care of setting up QOS header with
NoAck policy based on the TID NoAck map.

Drivers having this support should implement callback set_noack_tid_bitmap().
Supporting drivers would receive TID NoAck map through set_noack_tid_bitmap()
instead of receiving as part of every tx skb.

Signed-off-by: Vasanthakumar Thiagarajan <vthiagar@codeaurora.org>
Signed-off-by: Tamizh chelvam <tamizhr@codeaurora.org>
---
 include/net/mac80211.h    |    7 +++++++
 net/mac80211/cfg.c        |   10 ++++++++--
 net/mac80211/driver-ops.h |   21 +++++++++++++++++++++
 net/mac80211/iface.c      |    4 ++++
 net/mac80211/trace.h      |   25 +++++++++++++++++++++++++
 net/mac80211/tx.c         |    2 +-
 net/mac80211/wme.c        |    3 ++-
 7 files changed, 68 insertions(+), 4 deletions(-)

diff --git a/include/net/mac80211.h b/include/net/mac80211.h
index 71985e9..7da9d30 100644
--- a/include/net/mac80211.h
+++ b/include/net/mac80211.h
@@ -3623,6 +3623,10 @@ enum ieee80211_reconfig_type {
  *	skb is always a real frame, head may or may not be an A-MSDU.
  * @get_ftm_responder_stats: Retrieve FTM responder statistics, if available.
  *	Statistics should be cumulative, currently no way to reset is provided.
+ *
+ * @set_noack_tid_bitmap: Set NoAck policy TID bitmap for a virtual interface.
+ *	Drivers mplementing this callback must take care of setting NoAck policy
+ *	in QOS control field based on the configured TID bitmap.
  */
 struct ieee80211_ops {
 	void (*tx)(struct ieee80211_hw *hw,
@@ -3911,6 +3915,9 @@ struct ieee80211_ops {
 	int (*get_ftm_responder_stats)(struct ieee80211_hw *hw,
 				       struct ieee80211_vif *vif,
 				       struct cfg80211_ftm_responder_stats *ftm_stats);
+
+	int (*set_noack_tid_bitmap)(struct ieee80211_hw *hw,
+				    struct ieee80211_vif *vif, u16 noack_map);
 };
 
 /**
diff --git a/net/mac80211/cfg.c b/net/mac80211/cfg.c
index 5162233..4d8cc8d 100644
--- a/net/mac80211/cfg.c
+++ b/net/mac80211/cfg.c
@@ -346,9 +346,15 @@ static int ieee80211_set_noack_map(struct wiphy *wiphy,
 
 	sdata->noack_map = noack_map;
 
-	ieee80211_check_fast_xmit_iface(sdata);
+	if (!sdata->local->ops->set_noack_tid_bitmap) {
+		ieee80211_check_fast_xmit_iface(sdata);
+		return 0;
+	}
 
-	return 0;
+	if (!ieee80211_sdata_running(sdata))
+		return 0;
+
+	return drv_set_noack_tid_bitmap(sdata->local, sdata, noack_map);
 }
 
 static int ieee80211_add_key(struct wiphy *wiphy, struct net_device *dev,
diff --git a/net/mac80211/driver-ops.h b/net/mac80211/driver-ops.h
index 0b1747a..a6dcef5 100644
--- a/net/mac80211/driver-ops.h
+++ b/net/mac80211/driver-ops.h
@@ -1278,4 +1278,25 @@ static inline void drv_del_nan_func(struct ieee80211_local *local,
 	trace_drv_return_void(local);
 }
 
+static inline int drv_set_noack_tid_bitmap(struct ieee80211_local *local,
+					   struct ieee80211_sub_if_data *sdata,
+					   u16 noack_map)
+{
+	int ret;
+
+	might_sleep();
+	if (!check_sdata_in_driver(sdata))
+		return -EIO;
+
+	if (!local->ops->set_noack_tid_bitmap)
+		return -EOPNOTSUPP;
+
+	trace_drv_set_noack_tid_bitmap(local, sdata, noack_map);
+	ret = local->ops->set_noack_tid_bitmap(&local->hw, &sdata->vif,
+					       noack_map);
+	trace_drv_return_int(local, ret);
+
+	return ret;
+}
+
 #endif /* __MAC80211_DRIVER_OPS */
diff --git a/net/mac80211/iface.c b/net/mac80211/iface.c
index 5836dde..06106f2 100644
--- a/net/mac80211/iface.c
+++ b/net/mac80211/iface.c
@@ -633,6 +633,10 @@ int ieee80211_do_open(struct wireless_dev *wdev, bool coming_up)
 				ieee80211_vif_type_p2p(&sdata->vif));
 			if (res)
 				goto err_del_interface;
+
+			if (sdata->noack_map)
+				drv_set_noack_tid_bitmap(local, sdata,
+							 sdata->noack_map);
 		}
 
 		if (sdata->vif.type == NL80211_IFTYPE_AP) {
diff --git a/net/mac80211/trace.h b/net/mac80211/trace.h
index 588c51a..a563904 100644
--- a/net/mac80211/trace.h
+++ b/net/mac80211/trace.h
@@ -1882,6 +1882,31 @@ struct trace_switch_entry {
 	)
 );
 
+TRACE_EVENT(drv_set_noack_tid_bitmap,
+	TP_PROTO(struct ieee80211_local *local,
+		 struct ieee80211_sub_if_data *sdata,
+		 u16 noack_map),
+
+	TP_ARGS(local, sdata, noack_map),
+	TP_STRUCT__entry(
+		LOCAL_ENTRY
+		VIF_ENTRY
+		__field(u16, noack_map)
+	),
+
+	TP_fast_assign(
+		LOCAL_ASSIGN;
+		VIF_ASSIGN;
+		__entry->noack_map = noack_map;
+	),
+
+	TP_printk(
+		LOCAL_PR_FMT  VIF_PR_FMT
+		", noack_map: %u",
+		LOCAL_PR_ARG, VIF_PR_ARG, __entry->noack_map
+	)
+);
+
 /*
  * Tracing for API calls that drivers call.
  */
diff --git a/net/mac80211/tx.c b/net/mac80211/tx.c
index e0ccee2..d744c4b 100644
--- a/net/mac80211/tx.c
+++ b/net/mac80211/tx.c
@@ -2872,7 +2872,7 @@ void ieee80211_check_fast_xmit(struct sta_info *sta)
 	    test_sta_flag(sta, WLAN_STA_CLEAR_PS_FILT))
 		goto out;
 
-	if (sdata->noack_map)
+	if (sdata->noack_map && !local->ops->set_noack_tid_bitmap)
 		goto out;
 
 	/* fast-xmit doesn't handle fragmentation at all */
diff --git a/net/mac80211/wme.c b/net/mac80211/wme.c
index 5f7c963..11c14b9 100644
--- a/net/mac80211/wme.c
+++ b/net/mac80211/wme.c
@@ -256,7 +256,8 @@ void ieee80211_set_qos_hdr(struct ieee80211_sub_if_data *sdata,
 		       IEEE80211_QOS_CTL_ACK_POLICY_MASK);
 
 	if (is_multicast_ether_addr(hdr->addr1) ||
-	    sdata->noack_map & BIT(tid)) {
+	    (!sdata->local->ops->set_noack_tid_bitmap &&
+	    sdata->noack_map & BIT(tid))) {
 		flags |= IEEE80211_QOS_CTL_ACK_POLICY_NOACK;
 		info->flags |= IEEE80211_TX_CTL_NO_ACK;
 	}
-- 
1.7.9.5

