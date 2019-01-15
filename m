Return-Path: <SRS0=v11p=PX=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.6 required=3.0 tests=DKIMWL_WL_MED,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,USER_AGENT_GIT,USER_IN_DEF_DKIM_WL
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BE2CDC43387
	for <linux-wireless@archiver.kernel.org>; Tue, 15 Jan 2019 23:28:56 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 82DE420883
	for <linux-wireless@archiver.kernel.org>; Tue, 15 Jan 2019 23:28:56 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="ZQ40Oee1"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2391398AbfAOX2z (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Tue, 15 Jan 2019 18:28:55 -0500
Received: from mail-yw1-f74.google.com ([209.85.161.74]:47569 "EHLO
        mail-yw1-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728841AbfAOX2z (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 15 Jan 2019 18:28:55 -0500
Received: by mail-yw1-f74.google.com with SMTP id m200so2155365ywd.14
        for <linux-wireless@vger.kernel.org>; Tue, 15 Jan 2019 15:28:54 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=TAtqO5rgreqPBCSMfznOFk7vuGi6IU/KKvy01EniQm0=;
        b=ZQ40Oee1HiwnwabvPBqy33k0Z1c0ZvTp2AUMQlZX6wrE7TnMcFnXOoh0MA5x1qxS4E
         pObG+vyWNpjOFtPsZ992JpYwtdeSacqUc36cF49Ev6SxxCqXKEsZ8mfBjBaO3rS25++I
         wnNUU5hWaV+ZMYWi6sybGFyYzeTM7Xd4KT02gM6iLwOh4dZMlnriXvgzICadqBohu/F3
         ZaIN5YtHPAeIat1XJ7Ppqsge993+3V2lI99/tXKBFHf7CPtYQoHqXAlKlWER7fEww1vJ
         Q7gns1SViFVPR0yX9OewkNkW7cBQLtpI0I2x38yUM4oSfYhcDJLPvCVRdmWzInlt+1pa
         Tzdw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=TAtqO5rgreqPBCSMfznOFk7vuGi6IU/KKvy01EniQm0=;
        b=ZluwnUodpqILTzQKXfniiZaPTT9nntUKmc4af9HwADyOEGee310LJNdwuGB+10NxHs
         DnLMP5jfh5A3W0xpBZkheDj4TBjXll1QItidxEOKXrqZra3t0In33/ImRVuA1XrMcYlR
         sjl9KYMA8oyoYwY4SVUNPU2UE0SA7HEtIdSkGIlFo5HSUsS/UwuudWyrvYkRHI2P/bl2
         6zyEo0lpIIIfYgqm4MGt0nRJuZ3zjRuoPZswn1ECyM4QM4JZnTcbIRw9IJFsCj4XcTn2
         8/BI9aH/AE+UcOkx1tOszBBfBQRgBtioRxpXUDaY6ROQg3FwUacAHEbSjo0uOmfdclYt
         B7tg==
X-Gm-Message-State: AJcUukdIRRAleRuvBY4Apt1ZaZwI1duSYC4Qdncq2WNMtXSjKO8oIv2d
        OjNc78+VRM+zU1PMlCpcKahUYVtDpM7XJw==
X-Google-Smtp-Source: ALg8bN77pDC+v3tJaLHldNs3zxYSKAtRtmwZAgqNLausRzKVo8fMPDmunPGXlH8xrFOA33xqsLzP9+ixHYa8Ew==
X-Received: by 2002:a25:d42:: with SMTP id 63mr2412445ybn.78.1547594934391;
 Tue, 15 Jan 2019 15:28:54 -0800 (PST)
Date:   Tue, 15 Jan 2019 15:28:43 -0800
In-Reply-To: <20190115232843.223532-1-julanhsu@google.com>
Message-Id: <20190115232843.223532-2-julanhsu@google.com>
Mime-Version: 1.0
References: <20190115232843.223532-1-julanhsu@google.com>
X-Mailer: git-send-email 2.20.1.97.g81188d93c3-goog
Subject: [PATCH 2/2] mac80211: mesh: add mesh path change count to mpath info
From:   julanhsu@google.com
To:     johannes@sipsolutions.net
Cc:     linux-wireless@vger.kernel.org, Julan Hsu <julanhsu@google.com>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

From: Julan Hsu <julanhsu@google.com>

Expose path change count to destination in mpath info

Signed-off-by: Julan Hsu <julanhsu@google.com>
---
 include/net/cfg80211.h       | 5 ++++-
 include/uapi/linux/nl80211.h | 4 +++-
 net/mac80211/cfg.c           | 4 +++-
 net/mac80211/mesh.h          | 2 ++
 net/mac80211/mesh_hwmp.c     | 4 ++++
 net/wireless/nl80211.c       | 5 ++++-
 6 files changed, 20 insertions(+), 4 deletions(-)

diff --git a/include/net/cfg80211.h b/include/net/cfg80211.h
index 6be50a550a13..4e5fb1daf0a1 100644
--- a/include/net/cfg80211.h
+++ b/include/net/cfg80211.h
@@ -1427,7 +1427,8 @@ enum mpath_info_flags {
 	MPATH_INFO_DISCOVERY_TIMEOUT	= BIT(4),
 	MPATH_INFO_DISCOVERY_RETRIES	= BIT(5),
 	MPATH_INFO_FLAGS		= BIT(6),
-	MPATH_INFO_HOP_COUNT		= BIT(7)
+	MPATH_INFO_HOP_COUNT		= BIT(7),
+	MPATH_INFO_PATH_CHANGE		= BIT(8)
 };
 
 /**
@@ -1448,6 +1449,7 @@ enum mpath_info_flags {
  *	changes, i.e. when a station is added or removed, so that
  *	userspace can tell whether it got a consistent snapshot.
  * @hop_count: hops to destination
+ * @path_change_count: total number of path changes to destination
  */
 struct mpath_info {
 	u32 filled;
@@ -1459,6 +1461,7 @@ struct mpath_info {
 	u8 discovery_retries;
 	u8 flags;
 	u8 hop_count;
+	u32 path_change_count;
 
 	int generation;
 };
diff --git a/include/uapi/linux/nl80211.h b/include/uapi/linux/nl80211.h
index fcfca197be59..1e24d236f675 100644
--- a/include/uapi/linux/nl80211.h
+++ b/include/uapi/linux/nl80211.h
@@ -3226,8 +3226,9 @@ enum nl80211_mpath_flags {
  * @NL80211_MPATH_INFO_DISCOVERY_TIMEOUT: total path discovery timeout, in msec
  * @NL80211_MPATH_INFO_DISCOVERY_RETRIES: mesh path discovery retries
  * @NL80211_MPATH_INFO_HOP_COUNT: hop count to destination
+ * @NL80211_MPATH_INFO_PATH_CHANGE: total number of path changes to destination
  * @NL80211_MPATH_INFO_MAX: highest mesh path information attribute number
- *	currently defind
+ *	currently defined
  * @__NL80211_MPATH_INFO_AFTER_LAST: internal use
  */
 enum nl80211_mpath_info {
@@ -3240,6 +3241,7 @@ enum nl80211_mpath_info {
 	NL80211_MPATH_INFO_DISCOVERY_TIMEOUT,
 	NL80211_MPATH_INFO_DISCOVERY_RETRIES,
 	NL80211_MPATH_INFO_HOP_COUNT,
+	NL80211_MPATH_INFO_PATH_CHANGE,
 
 	/* keep last */
 	__NL80211_MPATH_INFO_AFTER_LAST,
diff --git a/net/mac80211/cfg.c b/net/mac80211/cfg.c
index 8e756ac076ad..aba2f6cbdc4f 100644
--- a/net/mac80211/cfg.c
+++ b/net/mac80211/cfg.c
@@ -1743,7 +1743,8 @@ static void mpath_set_pinfo(struct mesh_path *mpath, u8 *next_hop,
 			MPATH_INFO_DISCOVERY_TIMEOUT |
 			MPATH_INFO_DISCOVERY_RETRIES |
 			MPATH_INFO_FLAGS |
-			MPATH_INFO_HOP_COUNT;
+			MPATH_INFO_HOP_COUNT |
+			MPATH_INFO_PATH_CHANGE;
 
 	pinfo->frame_qlen = mpath->frame_queue.qlen;
 	pinfo->sn = mpath->sn;
@@ -1764,6 +1765,7 @@ static void mpath_set_pinfo(struct mesh_path *mpath, u8 *next_hop,
 	if (mpath->flags & MESH_PATH_RESOLVED)
 		pinfo->flags |= NL80211_MPATH_FLAG_RESOLVED;
 	pinfo->hop_count = mpath->hop_count;
+	pinfo->path_change_count = mpath->path_change_count;
 }
 
 static int ieee80211_get_mpath(struct wiphy *wiphy, struct net_device *dev,
diff --git a/net/mac80211/mesh.h b/net/mac80211/mesh.h
index 21526630bf65..dbb43e9454e0 100644
--- a/net/mac80211/mesh.h
+++ b/net/mac80211/mesh.h
@@ -94,6 +94,7 @@ enum mesh_deferred_task_flags {
  * @last_preq_to_root: Timestamp of last PREQ sent to root
  * @is_root: the destination station of this path is a root node
  * @is_gate: the destination station of this path is a mesh gate
+ * @path_change_count: the number of path changes to destination
  *
  *
  * The dst address is unique in the mesh path table. Since the mesh_path is
@@ -124,6 +125,7 @@ struct mesh_path {
 	unsigned long last_preq_to_root;
 	bool is_root;
 	bool is_gate;
+	u32 path_change_count;
 };
 
 /**
diff --git a/net/mac80211/mesh_hwmp.c b/net/mac80211/mesh_hwmp.c
index 6d1190b3332f..a0aebf44493f 100644
--- a/net/mac80211/mesh_hwmp.c
+++ b/net/mac80211/mesh_hwmp.c
@@ -479,6 +479,8 @@ static u32 hwmp_route_info_get(struct ieee80211_sub_if_data *sdata,
 		}
 
 		if (fresh_info) {
+			if (rcu_access_pointer(mpath->next_hop) != sta)
+				mpath->path_change_count++;
 			mesh_path_assign_nexthop(mpath, sta);
 			mpath->flags |= MESH_PATH_SN_VALID;
 			mpath->metric = new_metric;
@@ -523,6 +525,8 @@ static u32 hwmp_route_info_get(struct ieee80211_sub_if_data *sdata,
 		}
 
 		if (fresh_info) {
+			if (rcu_access_pointer(mpath->next_hop) != sta)
+				mpath->path_change_count++;
 			mesh_path_assign_nexthop(mpath, sta);
 			mpath->metric = last_hop_metric;
 			mpath->exp_time = time_after(mpath->exp_time, exp_time)
diff --git a/net/wireless/nl80211.c b/net/wireless/nl80211.c
index 442c02415aed..3fde570f1cf3 100644
--- a/net/wireless/nl80211.c
+++ b/net/wireless/nl80211.c
@@ -5644,7 +5644,10 @@ static int nl80211_send_mpath(struct sk_buff *msg, u32 portid, u32 seq,
 			pinfo->discovery_retries)) ||
 	    ((pinfo->filled & MPATH_INFO_HOP_COUNT) &&
 	     nla_put_u8(msg, NL80211_MPATH_INFO_HOP_COUNT,
-			pinfo->hop_count)))
+			pinfo->hop_count)) ||
+	    ((pinfo->filled & MPATH_INFO_PATH_CHANGE) &&
+	     nla_put_u32(msg, NL80211_MPATH_INFO_PATH_CHANGE,
+			 pinfo->path_change_count)))
 		goto nla_put_failure;
 
 	nla_nest_end(msg, pinfoattr);
-- 
2.20.1.97.g81188d93c3-goog

