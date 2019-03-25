Return-Path: <SRS0=1+XV=R4=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.8 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6ABF8C43381
	for <linux-wireless@archiver.kernel.org>; Mon, 25 Mar 2019 07:59:28 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 051C82075C
	for <linux-wireless@archiver.kernel.org>; Mon, 25 Mar 2019 07:59:28 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (1024-bit key) header.d=nbd.name header.i=@nbd.name header.b="q348FkE6"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729902AbfCYH71 (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Mon, 25 Mar 2019 03:59:27 -0400
Received: from nbd.name ([46.4.11.11]:35458 "EHLO nbd.name"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729812AbfCYH71 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 25 Mar 2019 03:59:27 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nbd.name;
         s=20160729; h=Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To:
        MIME-Version:Content-Type:Content-Transfer-Encoding:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:In-Reply-To:References:List-Id:List-Help:List-Unsubscribe:
        List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=t6L8VTe+VGhQBmXldCr0Bz6N4/D+iBM2NSIfes9h7AM=; b=q348FkE6pHVoKUs6JPk87PE6fn
        ZsU6EYYjG1df8xcj/8fq34pIFHZr/ZL+yUjfTtvATVS6iexuZdroTYyO71kiaYUXcWu+WmAcnqYkT
        NAP+PP3jiJxVVN98Ek1tziLlMgNYAhHPMi6HRB+iCT1VaObrl2Wp7TDGlTrGKHkew/QQ=;
Received: from p4ff13338.dip0.t-ipconnect.de ([79.241.51.56] helo=maeck-2.local)
        by ds12 with esmtpsa (TLS1.2:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.89)
        (envelope-from <nbd@nbd.name>)
        id 1h8KVw-0007uD-Hi; Mon, 25 Mar 2019 08:59:24 +0100
Received: by maeck-2.local (Postfix, from userid 501)
        id CFE4C5566B3E; Mon, 25 Mar 2019 08:59:23 +0100 (CET)
From:   Felix Fietkau <nbd@nbd.name>
To:     linux-wireless@vger.kernel.org
Cc:     johannes@sipsolutions.net
Subject: [PATCH] mac80211: when using iTXQ, select the queue in ieee80211_subif_start_xmit
Date:   Mon, 25 Mar 2019 08:59:23 +0100
Message-Id: <20190325075923.77039-1-nbd@nbd.name>
X-Mailer: git-send-email 2.17.0
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

When using iTXQ, the network stack does not need the real queue number, since
mac80211 is using its internal queues anyway. In that case we can defer
selecting the queue and remove a redundant station lookup in the tx path to save
some CPU cycles.

Signed-off-by: Felix Fietkau <nbd@nbd.name>
---
 net/mac80211/tx.c  | 11 ++++++-
 net/mac80211/wme.c | 82 +++++++++++++++++++++++++---------------------
 net/mac80211/wme.h |  2 ++
 3 files changed, 56 insertions(+), 39 deletions(-)

diff --git a/net/mac80211/tx.c b/net/mac80211/tx.c
index e22de40a7790..e9d4a811ddce 100644
--- a/net/mac80211/tx.c
+++ b/net/mac80211/tx.c
@@ -3790,6 +3790,7 @@ void __ieee80211_subif_start_xmit(struct sk_buff *skb,
 				  u32 info_flags)
 {
 	struct ieee80211_sub_if_data *sdata = IEEE80211_DEV_TO_SUB_IF(dev);
+	struct ieee80211_local *local = sdata->local;
 	struct sta_info *sta;
 	struct sk_buff *next;
 
@@ -3803,7 +3804,15 @@ void __ieee80211_subif_start_xmit(struct sk_buff *skb,
 	if (ieee80211_lookup_ra_sta(sdata, skb, &sta))
 		goto out_free;
 
-	if (!IS_ERR_OR_NULL(sta)) {
+	if (IS_ERR(sta))
+		sta = NULL;
+
+	if (local->ops->wake_tx_queue) {
+		u16 queue = __ieee80211_select_queue(sdata, sta, skb);
+		skb_set_queue_mapping(skb, queue);
+	}
+
+	if (sta) {
 		struct ieee80211_fast_tx *fast_tx;
 
 		sk_pacing_shift_update(skb->sk, sdata->local->hw.tx_sk_pacing_shift);
diff --git a/net/mac80211/wme.c b/net/mac80211/wme.c
index 5f7c96368b11..6a3187883c4b 100644
--- a/net/mac80211/wme.c
+++ b/net/mac80211/wme.c
@@ -141,6 +141,42 @@ u16 ieee80211_select_queue_80211(struct ieee80211_sub_if_data *sdata,
 	return ieee80211_downgrade_queue(sdata, NULL, skb);
 }
 
+u16 __ieee80211_select_queue(struct ieee80211_sub_if_data *sdata,
+			     struct sta_info *sta, struct sk_buff *skb)
+{
+	struct mac80211_qos_map *qos_map;
+	bool qos;
+
+	/* all mesh/ocb stations are required to support WME */
+	if (sdata->vif.type == NL80211_IFTYPE_MESH_POINT ||
+	    sdata->vif.type == NL80211_IFTYPE_OCB)
+		qos = true;
+	else if (sta)
+		qos = sta->sta.wme;
+	else
+		qos = false;
+
+	if (!qos) {
+		skb->priority = 0; /* required for correct WPA/11i MIC */
+		return IEEE80211_AC_BE;
+	}
+
+	if (skb->protocol == sdata->control_port_protocol) {
+		skb->priority = 7;
+		goto downgrade;
+	}
+
+	/* use the data classifier to determine what 802.1d tag the
+	 * data frame has */
+	qos_map = rcu_dereference(sdata->qos_map);
+	skb->priority = cfg80211_classify8021d(skb, qos_map ?
+					       &qos_map->qos_map : NULL);
+
+ downgrade:
+	return ieee80211_downgrade_queue(sdata, sta, skb);
+}
+
+
 /* Indicate which queue to use. */
 u16 ieee80211_select_queue(struct ieee80211_sub_if_data *sdata,
 			   struct sk_buff *skb)
@@ -148,10 +184,12 @@ u16 ieee80211_select_queue(struct ieee80211_sub_if_data *sdata,
 	struct ieee80211_local *local = sdata->local;
 	struct sta_info *sta = NULL;
 	const u8 *ra = NULL;
-	bool qos = false;
-	struct mac80211_qos_map *qos_map;
 	u16 ret;
 
+	/* when using iTXQ, we can do this later */
+	if (local->ops->wake_tx_queue)
+		return 0;
+
 	if (local->hw.queues < IEEE80211_NUM_ACS || skb->len < 6) {
 		skb->priority = 0; /* required for correct WPA/11i MIC */
 		return 0;
@@ -161,10 +199,8 @@ u16 ieee80211_select_queue(struct ieee80211_sub_if_data *sdata,
 	switch (sdata->vif.type) {
 	case NL80211_IFTYPE_AP_VLAN:
 		sta = rcu_dereference(sdata->u.vlan.sta);
-		if (sta) {
-			qos = sta->sta.wme;
+		if (sta)
 			break;
-		}
 		/* fall through */
 	case NL80211_IFTYPE_AP:
 		ra = skb->data;
@@ -172,56 +208,26 @@ u16 ieee80211_select_queue(struct ieee80211_sub_if_data *sdata,
 	case NL80211_IFTYPE_WDS:
 		ra = sdata->u.wds.remote_addr;
 		break;
-#ifdef CONFIG_MAC80211_MESH
-	case NL80211_IFTYPE_MESH_POINT:
-		qos = true;
-		break;
-#endif
 	case NL80211_IFTYPE_STATION:
 		/* might be a TDLS station */
 		sta = sta_info_get(sdata, skb->data);
 		if (sta)
-			qos = sta->sta.wme;
+			break;
 
 		ra = sdata->u.mgd.bssid;
 		break;
 	case NL80211_IFTYPE_ADHOC:
 		ra = skb->data;
 		break;
-	case NL80211_IFTYPE_OCB:
-		/* all stations are required to support WME */
-		qos = true;
-		break;
 	default:
 		break;
 	}
 
-	if (!sta && ra && !is_multicast_ether_addr(ra)) {
+	if (!sta && ra && !is_multicast_ether_addr(ra))
 		sta = sta_info_get(sdata, ra);
-		if (sta)
-			qos = sta->sta.wme;
-	}
 
-	if (!qos) {
-		skb->priority = 0; /* required for correct WPA/11i MIC */
-		ret = IEEE80211_AC_BE;
-		goto out;
-	}
+	ret = __ieee80211_select_queue(sdata, sta, skb);
 
-	if (skb->protocol == sdata->control_port_protocol) {
-		skb->priority = 7;
-		goto downgrade;
-	}
-
-	/* use the data classifier to determine what 802.1d tag the
-	 * data frame has */
-	qos_map = rcu_dereference(sdata->qos_map);
-	skb->priority = cfg80211_classify8021d(skb, qos_map ?
-					       &qos_map->qos_map : NULL);
-
- downgrade:
-	ret = ieee80211_downgrade_queue(sdata, sta, skb);
- out:
 	rcu_read_unlock();
 	return ret;
 }
diff --git a/net/mac80211/wme.h b/net/mac80211/wme.h
index 80151edc5195..b1b1439cb91b 100644
--- a/net/mac80211/wme.h
+++ b/net/mac80211/wme.h
@@ -16,6 +16,8 @@
 u16 ieee80211_select_queue_80211(struct ieee80211_sub_if_data *sdata,
 				 struct sk_buff *skb,
 				 struct ieee80211_hdr *hdr);
+u16 __ieee80211_select_queue(struct ieee80211_sub_if_data *sdata,
+			     struct sta_info *sta, struct sk_buff *skb);
 u16 ieee80211_select_queue(struct ieee80211_sub_if_data *sdata,
 			   struct sk_buff *skb);
 void ieee80211_set_qos_hdr(struct ieee80211_sub_if_data *sdata,
-- 
2.17.0

