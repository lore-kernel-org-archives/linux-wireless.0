Return-Path: <SRS0=BJpU=RT=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.8 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 31446C43381
	for <linux-wireless@archiver.kernel.org>; Sat, 16 Mar 2019 17:06:39 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id E204C218D0
	for <linux-wireless@archiver.kernel.org>; Sat, 16 Mar 2019 17:06:38 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (1024-bit key) header.d=nbd.name header.i=@nbd.name header.b="Wiv+8Msr"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727092AbfCPRGi (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Sat, 16 Mar 2019 13:06:38 -0400
Received: from nbd.name ([46.4.11.11]:55508 "EHLO nbd.name"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726842AbfCPRGh (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Sat, 16 Mar 2019 13:06:37 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nbd.name;
         s=20160729; h=Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To:
        MIME-Version:Content-Type:Content-Transfer-Encoding:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:In-Reply-To:References:List-Id:List-Help:List-Unsubscribe:
        List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=/QZTglqFvpqNr/1Nx6VSiqGFXD6gxc/vRPWbWzc6kZw=; b=Wiv+8Msr4Du2MRR15igTtl/ecq
        ruXpHoekPbUlK2renq2BGwzTmQxSSMRRnQmD8VyLyGJrfZi7vdjgyszA5X0aXCK5g1QMU0LVElUZx
        lghPYoSBtZJSz0V/Edv5JfxXyiyJ4RbLBNogdXkiLXBHJA3kp5gaIDTM+xM1zqucglNA=;
Received: from p4ff1316d.dip0.t-ipconnect.de ([79.241.49.109] helo=maeck-2.local)
        by ds12 with esmtpsa (TLS1.2:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.89)
        (envelope-from <nbd@nbd.name>)
        id 1h5ClX-00071m-On; Sat, 16 Mar 2019 18:06:36 +0100
Received: by maeck-2.local (Postfix, from userid 501)
        id C73C852C90E2; Sat, 16 Mar 2019 18:06:34 +0100 (CET)
From:   Felix Fietkau <nbd@nbd.name>
To:     linux-wireless@vger.kernel.org
Cc:     johannes@sipsolutions.net
Subject: [PATCH 1/5] mac80211: mesh: drop redundant rcu_read_lock/unlock calls
Date:   Sat, 16 Mar 2019 18:06:30 +0100
Message-Id: <20190316170634.13125-1-nbd@nbd.name>
X-Mailer: git-send-email 2.17.0
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

The callers of these functions are all within RCU locked sections

Signed-off-by: Felix Fietkau <nbd@nbd.name>
---
 net/mac80211/mesh_hwmp.c    | 26 +++++++-------------------
 net/mac80211/mesh_pathtbl.c |  2 +-
 2 files changed, 8 insertions(+), 20 deletions(-)

diff --git a/net/mac80211/mesh_hwmp.c b/net/mac80211/mesh_hwmp.c
index f7517668e77a..dcbca7c8c67d 100644
--- a/net/mac80211/mesh_hwmp.c
+++ b/net/mac80211/mesh_hwmp.c
@@ -1130,16 +1130,13 @@ int mesh_nexthop_resolve(struct ieee80211_sub_if_data *sdata,
 	struct mesh_path *mpath;
 	struct sk_buff *skb_to_free = NULL;
 	u8 *target_addr = hdr->addr3;
-	int err = 0;
 
 	/* Nulls are only sent to peers for PS and should be pre-addressed */
 	if (ieee80211_is_qos_nullfunc(hdr->frame_control))
 		return 0;
 
-	rcu_read_lock();
-	err = mesh_nexthop_lookup(sdata, skb);
-	if (!err)
-		goto endlookup;
+	if (!mesh_nexthop_lookup(sdata, skb))
+		return 0;
 
 	/* no nexthop found, start resolving */
 	mpath = mesh_path_lookup(sdata, target_addr);
@@ -1147,8 +1144,7 @@ int mesh_nexthop_resolve(struct ieee80211_sub_if_data *sdata,
 		mpath = mesh_path_add(sdata, target_addr);
 		if (IS_ERR(mpath)) {
 			mesh_path_discard_frame(sdata, skb);
-			err = PTR_ERR(mpath);
-			goto endlookup;
+			return PTR_ERR(mpath);
 		}
 	}
 
@@ -1161,13 +1157,10 @@ int mesh_nexthop_resolve(struct ieee80211_sub_if_data *sdata,
 	info->flags |= IEEE80211_TX_INTFL_NEED_TXPROCESSING;
 	ieee80211_set_qos_hdr(sdata, skb);
 	skb_queue_tail(&mpath->frame_queue, skb);
-	err = -ENOENT;
 	if (skb_to_free)
 		mesh_path_discard_frame(sdata, skb_to_free);
 
-endlookup:
-	rcu_read_unlock();
-	return err;
+	return -ENOENT;
 }
 
 /**
@@ -1187,13 +1180,10 @@ int mesh_nexthop_lookup(struct ieee80211_sub_if_data *sdata,
 	struct sta_info *next_hop;
 	struct ieee80211_hdr *hdr = (struct ieee80211_hdr *) skb->data;
 	u8 *target_addr = hdr->addr3;
-	int err = -ENOENT;
 
-	rcu_read_lock();
 	mpath = mesh_path_lookup(sdata, target_addr);
-
 	if (!mpath || !(mpath->flags & MESH_PATH_ACTIVE))
-		goto endlookup;
+		return -ENOENT;
 
 	if (time_after(jiffies,
 		       mpath->exp_time -
@@ -1208,12 +1198,10 @@ int mesh_nexthop_lookup(struct ieee80211_sub_if_data *sdata,
 		memcpy(hdr->addr1, next_hop->sta.addr, ETH_ALEN);
 		memcpy(hdr->addr2, sdata->vif.addr, ETH_ALEN);
 		ieee80211_mps_set_frame_flags(sdata, next_hop, hdr);
-		err = 0;
+		return 0;
 	}
 
-endlookup:
-	rcu_read_unlock();
-	return err;
+	return -ENOENT;
 }
 
 void mesh_path_timer(struct timer_list *t)
diff --git a/net/mac80211/mesh_pathtbl.c b/net/mac80211/mesh_pathtbl.c
index 0a1148328f19..498bf580bff4 100644
--- a/net/mac80211/mesh_pathtbl.c
+++ b/net/mac80211/mesh_pathtbl.c
@@ -219,7 +219,7 @@ static struct mesh_path *mpath_lookup(struct mesh_table *tbl, const u8 *dst,
 {
 	struct mesh_path *mpath;
 
-	mpath = rhashtable_lookup_fast(&tbl->rhead, dst, mesh_rht_params);
+	mpath = rhashtable_lookup(&tbl->rhead, dst, mesh_rht_params);
 
 	if (mpath && mpath_expired(mpath)) {
 		spin_lock_bh(&mpath->state_lock);
-- 
2.17.0

