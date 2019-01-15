Return-Path: <SRS0=v11p=PX=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.6 required=3.0 tests=DKIMWL_WL_MED,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,USER_AGENT_GIT,USER_IN_DEF_DKIM_WL
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BB0CBC43387
	for <linux-wireless@archiver.kernel.org>; Tue, 15 Jan 2019 23:28:51 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 7FBC220883
	for <linux-wireless@archiver.kernel.org>; Tue, 15 Jan 2019 23:28:51 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="aCVYKIfd"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387957AbfAOX2u (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Tue, 15 Jan 2019 18:28:50 -0500
Received: from mail-ua1-f73.google.com ([209.85.222.73]:43540 "EHLO
        mail-ua1-f73.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728841AbfAOX2u (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 15 Jan 2019 18:28:50 -0500
Received: by mail-ua1-f73.google.com with SMTP id b8so301805uaq.10
        for <linux-wireless@vger.kernel.org>; Tue, 15 Jan 2019 15:28:49 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:message-id:mime-version:subject:from:to:cc;
        bh=npBabNpBkRgqHSIZ+VHvx/8PxItQscO9L+CieWJnhro=;
        b=aCVYKIfdIsqdCC0yBFdBZ9BD2t0kjj7MJ0KYScnsmgZlwa0MLiS39kMgBWMQe5j+1R
         /IEYUhoEUD+v+0k6PYB0QMYddBG2ph+MMLIpRQJFfH7GyODbkzlTlwR9Zy+EJ5Wsl47D
         xm6W63ew5FQD4q3N5oUlRQixylITtSULjNAmqVGAnXVWrItdzET64JsAGT4yYNdd0SaM
         NOskjVR1YYJL7eY316KxQJdeAYFv1n6Y+BORNCsulYBW4JnY6xFgB7pEOVA/QQU+AoeX
         M2ybCV5Tj41+WmjdekpbYpPKGCsWL1RV5xuL6chtigwmXdqyUQlE1cz79P4qEzQEN745
         11EQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:message-id:mime-version:subject:from:to:cc;
        bh=npBabNpBkRgqHSIZ+VHvx/8PxItQscO9L+CieWJnhro=;
        b=FQmPlTE89nedKo1mQr03y+fd4FVMsvJuaazbhqBZwzbA53dAghwpW2rD++Lbi48g7d
         jjLB99RNaTTCyi6008fMXnjI5dJgAo+YAbLAiCzR9s7lwag8iNCE+12aj1Py6HAP8xqI
         FHC9yv5SvVgB65yS7g509+7FmhLGcA0hxJRiaDJBqx+LAeeubF1edOJV6zKgWaVb34ye
         BB448c/CWn+h46+c5bjNzfDXWQg9s5/MsorrPadpVpS9TwIegZKhJshycvZj5hBN8NS5
         5s/fhFIwdCGBobC7fzM7ZHtZKtATvKmLNVQ0qAg9HZ/Qec2R5OJ7tGqx9T2spPTSlVNv
         yDug==
X-Gm-Message-State: AJcUukfk/GoH0Gpd7F/tnWp4WYTZbN6vPbkKufHGwfwM47nczWa7hhls
        8xao03gU7c5ZjB44GkO0U7KYRUEiBiO3SQ==
X-Google-Smtp-Source: ALg8bN43ycOehrCngriNedsoRafkPnCXA0MWKYFom2K/HmG63cVaiEdsk2wdzV+5svmds0S3cAUttrxpm7mTRw==
X-Received: by 2002:a1f:10a5:: with SMTP id 37mr3842750vkq.16.1547594928846;
 Tue, 15 Jan 2019 15:28:48 -0800 (PST)
Date:   Tue, 15 Jan 2019 15:28:42 -0800
Message-Id: <20190115232843.223532-1-julanhsu@google.com>
Mime-Version: 1.0
X-Mailer: git-send-email 2.20.1.97.g81188d93c3-goog
Subject: [PATCH 1/2] mac80211: mesh: add hop count to mpath info
From:   julanhsu@google.com
To:     johannes@sipsolutions.net
Cc:     linux-wireless@vger.kernel.org, Julan Hsu <julanhsu@google.com>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

From: Julan Hsu <julanhsu@google.com>

Expose hop count to destination information in mpath info

Signed-off-by: Julan Hsu <julanhsu@google.com>
---
 include/net/cfg80211.h       | 4 ++++
 include/uapi/linux/nl80211.h | 2 ++
 net/mac80211/cfg.c           | 4 +++-
 net/mac80211/mesh_hwmp.c     | 5 +++++
 net/wireless/nl80211.c       | 5 ++++-
 5 files changed, 18 insertions(+), 2 deletions(-)

diff --git a/include/net/cfg80211.h b/include/net/cfg80211.h
index 1fa41b7a1be3..6be50a550a13 100644
--- a/include/net/cfg80211.h
+++ b/include/net/cfg80211.h
@@ -1417,6 +1417,7 @@ enum monitor_flags {
  * @MPATH_INFO_DISCOVERY_TIMEOUT: @discovery_timeout filled
  * @MPATH_INFO_DISCOVERY_RETRIES: @discovery_retries filled
  * @MPATH_INFO_FLAGS: @flags filled
+ * @MPATH_INFO_HOP_COUNT: @hop_count filled
  */
 enum mpath_info_flags {
 	MPATH_INFO_FRAME_QLEN		= BIT(0),
@@ -1426,6 +1427,7 @@ enum mpath_info_flags {
 	MPATH_INFO_DISCOVERY_TIMEOUT	= BIT(4),
 	MPATH_INFO_DISCOVERY_RETRIES	= BIT(5),
 	MPATH_INFO_FLAGS		= BIT(6),
+	MPATH_INFO_HOP_COUNT		= BIT(7)
 };
 
 /**
@@ -1445,6 +1447,7 @@ enum mpath_info_flags {
  *	This number should increase every time the list of mesh paths
  *	changes, i.e. when a station is added or removed, so that
  *	userspace can tell whether it got a consistent snapshot.
+ * @hop_count: hops to destination
  */
 struct mpath_info {
 	u32 filled;
@@ -1455,6 +1458,7 @@ struct mpath_info {
 	u32 discovery_timeout;
 	u8 discovery_retries;
 	u8 flags;
+	u8 hop_count;
 
 	int generation;
 };
diff --git a/include/uapi/linux/nl80211.h b/include/uapi/linux/nl80211.h
index 6d610bae30a9..fcfca197be59 100644
--- a/include/uapi/linux/nl80211.h
+++ b/include/uapi/linux/nl80211.h
@@ -3225,6 +3225,7 @@ enum nl80211_mpath_flags {
  * 	&enum nl80211_mpath_flags;
  * @NL80211_MPATH_INFO_DISCOVERY_TIMEOUT: total path discovery timeout, in msec
  * @NL80211_MPATH_INFO_DISCOVERY_RETRIES: mesh path discovery retries
+ * @NL80211_MPATH_INFO_HOP_COUNT: hop count to destination
  * @NL80211_MPATH_INFO_MAX: highest mesh path information attribute number
  *	currently defind
  * @__NL80211_MPATH_INFO_AFTER_LAST: internal use
@@ -3238,6 +3239,7 @@ enum nl80211_mpath_info {
 	NL80211_MPATH_INFO_FLAGS,
 	NL80211_MPATH_INFO_DISCOVERY_TIMEOUT,
 	NL80211_MPATH_INFO_DISCOVERY_RETRIES,
+	NL80211_MPATH_INFO_HOP_COUNT,
 
 	/* keep last */
 	__NL80211_MPATH_INFO_AFTER_LAST,
diff --git a/net/mac80211/cfg.c b/net/mac80211/cfg.c
index 818aa0060349..8e756ac076ad 100644
--- a/net/mac80211/cfg.c
+++ b/net/mac80211/cfg.c
@@ -1742,7 +1742,8 @@ static void mpath_set_pinfo(struct mesh_path *mpath, u8 *next_hop,
 			MPATH_INFO_EXPTIME |
 			MPATH_INFO_DISCOVERY_TIMEOUT |
 			MPATH_INFO_DISCOVERY_RETRIES |
-			MPATH_INFO_FLAGS;
+			MPATH_INFO_FLAGS |
+			MPATH_INFO_HOP_COUNT;
 
 	pinfo->frame_qlen = mpath->frame_queue.qlen;
 	pinfo->sn = mpath->sn;
@@ -1762,6 +1763,7 @@ static void mpath_set_pinfo(struct mesh_path *mpath, u8 *next_hop,
 		pinfo->flags |= NL80211_MPATH_FLAG_FIXED;
 	if (mpath->flags & MESH_PATH_RESOLVED)
 		pinfo->flags |= NL80211_MPATH_FLAG_RESOLVED;
+	pinfo->hop_count = mpath->hop_count;
 }
 
 static int ieee80211_get_mpath(struct wiphy *wiphy, struct net_device *dev,
diff --git a/net/mac80211/mesh_hwmp.c b/net/mac80211/mesh_hwmp.c
index 6950cd0bf594..6d1190b3332f 100644
--- a/net/mac80211/mesh_hwmp.c
+++ b/net/mac80211/mesh_hwmp.c
@@ -386,6 +386,7 @@ static u32 hwmp_route_info_get(struct ieee80211_sub_if_data *sdata,
 	unsigned long orig_lifetime, exp_time;
 	u32 last_hop_metric, new_metric;
 	bool process = true;
+	u8 hopcount;
 
 	rcu_read_lock();
 	sta = sta_info_get(sdata, mgmt->sa);
@@ -404,6 +405,7 @@ static u32 hwmp_route_info_get(struct ieee80211_sub_if_data *sdata,
 		orig_sn = PREQ_IE_ORIG_SN(hwmp_ie);
 		orig_lifetime = PREQ_IE_LIFETIME(hwmp_ie);
 		orig_metric = PREQ_IE_METRIC(hwmp_ie);
+		hopcount = PREQ_IE_HOPCOUNT(hwmp_ie) + 1;
 		break;
 	case MPATH_PREP:
 		/* Originator here refers to the MP that was the target in the
@@ -415,6 +417,7 @@ static u32 hwmp_route_info_get(struct ieee80211_sub_if_data *sdata,
 		orig_sn = PREP_IE_TARGET_SN(hwmp_ie);
 		orig_lifetime = PREP_IE_LIFETIME(hwmp_ie);
 		orig_metric = PREP_IE_METRIC(hwmp_ie);
+		hopcount = PREP_IE_HOPCOUNT(hwmp_ie) + 1;
 		break;
 	default:
 		rcu_read_unlock();
@@ -482,6 +485,7 @@ static u32 hwmp_route_info_get(struct ieee80211_sub_if_data *sdata,
 			mpath->sn = orig_sn;
 			mpath->exp_time = time_after(mpath->exp_time, exp_time)
 					  ?  mpath->exp_time : exp_time;
+			mpath->hop_count = hopcount;
 			mesh_path_activate(mpath);
 			spin_unlock_bh(&mpath->state_lock);
 			ewma_mesh_fail_avg_init(&sta->mesh->fail_avg);
@@ -523,6 +527,7 @@ static u32 hwmp_route_info_get(struct ieee80211_sub_if_data *sdata,
 			mpath->metric = last_hop_metric;
 			mpath->exp_time = time_after(mpath->exp_time, exp_time)
 					  ?  mpath->exp_time : exp_time;
+			mpath->hop_count = 1;
 			mesh_path_activate(mpath);
 			spin_unlock_bh(&mpath->state_lock);
 			ewma_mesh_fail_avg_init(&sta->mesh->fail_avg);
diff --git a/net/wireless/nl80211.c b/net/wireless/nl80211.c
index 2317727d6413..442c02415aed 100644
--- a/net/wireless/nl80211.c
+++ b/net/wireless/nl80211.c
@@ -5641,7 +5641,10 @@ static int nl80211_send_mpath(struct sk_buff *msg, u32 portid, u32 seq,
 			 pinfo->discovery_timeout)) ||
 	    ((pinfo->filled & MPATH_INFO_DISCOVERY_RETRIES) &&
 	     nla_put_u8(msg, NL80211_MPATH_INFO_DISCOVERY_RETRIES,
-			pinfo->discovery_retries)))
+			pinfo->discovery_retries)) ||
+	    ((pinfo->filled & MPATH_INFO_HOP_COUNT) &&
+	     nla_put_u8(msg, NL80211_MPATH_INFO_HOP_COUNT,
+			pinfo->hop_count)))
 		goto nla_put_failure;
 
 	nla_nest_end(msg, pinfoattr);
-- 
2.20.1.97.g81188d93c3-goog

