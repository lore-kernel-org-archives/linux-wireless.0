Return-Path: <SRS0=/9EI=QV=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.8 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4692EC43381
	for <linux-wireless@archiver.kernel.org>; Thu, 14 Feb 2019 13:56:26 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 0A841222B6
	for <linux-wireless@archiver.kernel.org>; Thu, 14 Feb 2019 13:56:26 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="QgxmwXb4";
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="epEpUVHv"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2391248AbfBNN4Z (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Thu, 14 Feb 2019 08:56:25 -0500
Received: from smtp.codeaurora.org ([198.145.29.96]:45264 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2389017AbfBNN4Z (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 14 Feb 2019 08:56:25 -0500
Received: by smtp.codeaurora.org (Postfix, from userid 1000)
        id 0522C60908; Thu, 14 Feb 2019 13:56:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1550152584;
        bh=tv+/gYWGnqvHJMzx4m2NQaOcUClxSWVQZzynlwbVRrE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=QgxmwXb4YKc22boQjv7yM4AVLzF7Or14Ua69gV8muraIyKoyltfqSPGo0yleVE0V5
         bPjesfM+J+ukTNjktOOPh8hwR5hAllUHT02H6rGbZBTwBV9yjGyNwdBm7edBvxuRLJ
         ErYQ6XIBWLABb7VEBgJ66RZaJ7XaIUu0fGul1Wbg=
Received: from smtp.codeaurora.org (i-global254.qualcomm.com [199.106.103.254])
        (using TLSv1 with cipher AES128-SHA (128/128 bits))
        (No client certificate requested)
        (Authenticated sender: rmanohar@smtp.codeaurora.org)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id 7EF36608BA;
        Thu, 14 Feb 2019 13:56:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1550152582;
        bh=tv+/gYWGnqvHJMzx4m2NQaOcUClxSWVQZzynlwbVRrE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=epEpUVHvf7FUwAAviZ/zaau4SLMkNiWlUfsL0rFEMC2VcGT+uTF0ihQZtfpM1m+lT
         vllunAJ0OHYpOfIlBJOMbvpA6HFkyu3fONx7yUsBEdMYilA0hUmwGrXfz1ZZW0+TsV
         g6PIwbId1cjoOZvCNXu/MUPg95czEfs5e/TSEIUE=
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org 7EF36608BA
Authentication-Results: pdx-caf-mail.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: pdx-caf-mail.web.codeaurora.org; spf=none smtp.mailfrom=rmanohar@codeaurora.org
Received: by smtp.codeaurora.org (sSMTP sendmail emulation); Thu, 14 Feb 2019 05:56:20 -0800
From:   Rajkumar Manoharan <rmanohar@codeaurora.org>
To:     johannes@sipsolutions.net
Cc:     linux-wireless@vger.kernel.org, kevinhayes@google.com,
        julanhsu@google.com, Rajkumar Manoharan <rmanohar@codeaurora.org>
Subject: [PATCH 2/2] mac80211: probe unexercised mesh links
Date:   Thu, 14 Feb 2019 05:56:10 -0800
Message-Id: <1550152570-13051-3-git-send-email-rmanohar@codeaurora.org>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1550152570-13051-1-git-send-email-rmanohar@codeaurora.org>
References: <1550152570-13051-1-git-send-email-rmanohar@codeaurora.org>
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

The requirement for mesh link metric refreshing, is that from one
mesh point we be able to send some data frames to other mesh points
which are not currently selected as a primary traffic path, but which
are only 1 hop away. The absence of the primary path to the chosen node
makes it necessary to apply some form of marking on a chosen packet
stream so that the packets can be properly steered to the selected node
for testing, and not by the regular mesh path lookup.

Signed-off-by: Rajkumar Manoharan <rmanohar@codeaurora.org>
---
 include/net/mac80211.h     |  2 ++
 net/mac80211/cfg.c         |  1 +
 net/mac80211/ieee80211_i.h |  5 +++-
 net/mac80211/mesh_hwmp.c   |  4 +++
 net/mac80211/tdls.c        |  2 +-
 net/mac80211/tx.c          | 66 +++++++++++++++++++++++++++++++++++++++++-----
 6 files changed, 71 insertions(+), 9 deletions(-)

diff --git a/include/net/mac80211.h b/include/net/mac80211.h
index 88219cc137c3..65a5889be6b0 100644
--- a/include/net/mac80211.h
+++ b/include/net/mac80211.h
@@ -786,6 +786,7 @@ enum mac80211_tx_info_flags {
  * @IEEE80211_TX_CTRL_RATE_INJECT: This frame is injected with rate information
  * @IEEE80211_TX_CTRL_AMSDU: This frame is an A-MSDU frame
  * @IEEE80211_TX_CTRL_FAST_XMIT: This frame is going through the fast_xmit path
+ * @IEEE80211_TX_CTRL_SKIP_MPATH_LOOKUP: This frame skips mesh path lookup
  *
  * These flags are used in tx_info->control.flags.
  */
@@ -795,6 +796,7 @@ enum mac80211_tx_control_flags {
 	IEEE80211_TX_CTRL_RATE_INJECT		= BIT(2),
 	IEEE80211_TX_CTRL_AMSDU			= BIT(3),
 	IEEE80211_TX_CTRL_FAST_XMIT		= BIT(4),
+	IEEE80211_TX_CTRL_SKIP_MPATH_LOOKUP	= BIT(5),
 };
 
 /*
diff --git a/net/mac80211/cfg.c b/net/mac80211/cfg.c
index 2493c74c2d37..ceddf7a982f7 100644
--- a/net/mac80211/cfg.c
+++ b/net/mac80211/cfg.c
@@ -3974,4 +3974,5 @@ static int ieee80211_get_txq_stats(struct wiphy *wiphy,
 	.get_ftm_responder_stats = ieee80211_get_ftm_responder_stats,
 	.start_pmsr = ieee80211_start_pmsr,
 	.abort_pmsr = ieee80211_abort_pmsr,
+	.probe_mesh_link = ieee80211_probe_mesh_link,
 };
diff --git a/net/mac80211/ieee80211_i.h b/net/mac80211/ieee80211_i.h
index 7dfb4e2f98b2..2986da5d4fb0 100644
--- a/net/mac80211/ieee80211_i.h
+++ b/net/mac80211/ieee80211_i.h
@@ -1736,7 +1736,8 @@ netdev_tx_t ieee80211_subif_start_xmit(struct sk_buff *skb,
 				       struct net_device *dev);
 void __ieee80211_subif_start_xmit(struct sk_buff *skb,
 				  struct net_device *dev,
-				  u32 info_flags);
+				  u32 info_flags,
+				  u32 ctrl_flags);
 void ieee80211_purge_tx_queue(struct ieee80211_hw *hw,
 			      struct sk_buff_head *skbs);
 struct sk_buff *
@@ -1753,6 +1754,8 @@ void ieee80211_tx_monitor(struct ieee80211_local *local, struct sk_buff *skb,
 int ieee80211_tx_control_port(struct wiphy *wiphy, struct net_device *dev,
 			      const u8 *buf, size_t len,
 			      const u8 *dest, __be16 proto, bool unencrypted);
+int ieee80211_probe_mesh_link(struct wiphy *wiphy, struct net_device *dev,
+			      const u8 *dest, const u8 *buf, size_t len);
 
 /* HT */
 void ieee80211_apply_htcap_overrides(struct ieee80211_sub_if_data *sdata,
diff --git a/net/mac80211/mesh_hwmp.c b/net/mac80211/mesh_hwmp.c
index 6950cd0bf594..fe11bbd137ef 100644
--- a/net/mac80211/mesh_hwmp.c
+++ b/net/mac80211/mesh_hwmp.c
@@ -1118,6 +1118,10 @@ int mesh_nexthop_resolve(struct ieee80211_sub_if_data *sdata,
 	if (ieee80211_is_qos_nullfunc(hdr->frame_control))
 		return 0;
 
+	/* Allow injected packets to bypass mesh routing */
+	if (info->control.flags & IEEE80211_TX_CTRL_SKIP_MPATH_LOOKUP)
+		return 0;
+
 	rcu_read_lock();
 	err = mesh_nexthop_lookup(sdata, skb);
 	if (!err)
diff --git a/net/mac80211/tdls.c b/net/mac80211/tdls.c
index 6c647f425e05..044dad3e0423 100644
--- a/net/mac80211/tdls.c
+++ b/net/mac80211/tdls.c
@@ -1055,7 +1055,7 @@ static void ieee80211_tdls_add_ies(struct ieee80211_sub_if_data *sdata,
 
 	/* disable bottom halves when entering the Tx path */
 	local_bh_disable();
-	__ieee80211_subif_start_xmit(skb, dev, flags);
+	__ieee80211_subif_start_xmit(skb, dev, flags, 0);
 	local_bh_enable();
 
 	return ret;
diff --git a/net/mac80211/tx.c b/net/mac80211/tx.c
index 928f13a208b0..77ae4026aa0b 100644
--- a/net/mac80211/tx.c
+++ b/net/mac80211/tx.c
@@ -2424,6 +2424,7 @@ static int ieee80211_lookup_ra_sta(struct ieee80211_sub_if_data *sdata,
  * @sdata: virtual interface to build the header for
  * @skb: the skb to build the header in
  * @info_flags: skb flags to set
+ * @ctrl_flags: info control flags to set
  *
  * This function takes the skb with 802.3 header and reformats the header to
  * the appropriate IEEE 802.11 header based on which interface the packet is
@@ -2439,7 +2440,7 @@ static int ieee80211_lookup_ra_sta(struct ieee80211_sub_if_data *sdata,
  */
 static struct sk_buff *ieee80211_build_hdr(struct ieee80211_sub_if_data *sdata,
 					   struct sk_buff *skb, u32 info_flags,
-					   struct sta_info *sta)
+					   struct sta_info *sta, u32 ctrl_flags)
 {
 	struct ieee80211_local *local = sdata->local;
 	struct ieee80211_tx_info *info;
@@ -2811,6 +2812,7 @@ static struct sk_buff *ieee80211_build_hdr(struct ieee80211_sub_if_data *sdata,
 	info->flags = info_flags;
 	info->ack_frame_id = info_id;
 	info->band = band;
+	info->control.flags = ctrl_flags;
 
 	return skb;
  free:
@@ -3638,7 +3640,8 @@ struct sk_buff *ieee80211_tx_dequeue(struct ieee80211_hw *hw,
 
 void __ieee80211_subif_start_xmit(struct sk_buff *skb,
 				  struct net_device *dev,
-				  u32 info_flags)
+				  u32 info_flags,
+				  u32 ctrl_flags)
 {
 	struct ieee80211_sub_if_data *sdata = IEEE80211_DEV_TO_SUB_IF(dev);
 	struct sta_info *sta;
@@ -3703,7 +3706,8 @@ void __ieee80211_subif_start_xmit(struct sk_buff *skb,
 		skb->prev = NULL;
 		skb->next = NULL;
 
-		skb = ieee80211_build_hdr(sdata, skb, info_flags, sta);
+		skb = ieee80211_build_hdr(sdata, skb, info_flags,
+					  sta, ctrl_flags);
 		if (IS_ERR(skb))
 			goto out;
 
@@ -3843,9 +3847,9 @@ netdev_tx_t ieee80211_subif_start_xmit(struct sk_buff *skb,
 		__skb_queue_head_init(&queue);
 		ieee80211_convert_to_unicast(skb, dev, &queue);
 		while ((skb = __skb_dequeue(&queue)))
-			__ieee80211_subif_start_xmit(skb, dev, 0);
+			__ieee80211_subif_start_xmit(skb, dev, 0, 0);
 	} else {
-		__ieee80211_subif_start_xmit(skb, dev, 0);
+		__ieee80211_subif_start_xmit(skb, dev, 0, 0);
 	}
 
 	return NETDEV_TX_OK;
@@ -3870,7 +3874,7 @@ struct sk_buff *
 		goto out;
 	}
 
-	skb = ieee80211_build_hdr(sdata, skb, info_flags, sta);
+	skb = ieee80211_build_hdr(sdata, skb, info_flags, sta, 0);
 	if (IS_ERR(skb))
 		goto out;
 
@@ -4907,7 +4911,55 @@ int ieee80211_tx_control_port(struct wiphy *wiphy, struct net_device *dev,
 	skb_reset_mac_header(skb);
 
 	local_bh_disable();
-	__ieee80211_subif_start_xmit(skb, skb->dev, flags);
+	__ieee80211_subif_start_xmit(skb, skb->dev, flags, 0);
+	local_bh_enable();
+
+	return 0;
+}
+
+int ieee80211_probe_mesh_link(struct wiphy *wiphy, struct net_device *dev,
+			      const u8 *dest, const u8 *buf, size_t len)
+{
+	struct ieee80211_sub_if_data *sdata = IEEE80211_DEV_TO_SUB_IF(dev);
+	struct ieee80211_local *local = sdata->local;
+	struct sta_info *sta;
+	struct sk_buff *skb;
+	struct ethhdr *ehdr;
+
+	if (len < sizeof(*ehdr))
+		return -EINVAL;
+
+	mutex_lock(&local->sta_mtx);
+	sta = sta_info_get_bss(sdata, dest);
+	mutex_unlock(&local->sta_mtx);
+
+	if (!sta)
+		return -ENOENT;
+
+	ehdr = (struct ethhdr *)buf;
+	if (!ether_addr_equal(ehdr->h_dest, dest) ||
+	    !ether_addr_equal(ehdr->h_source, sdata->vif.addr) ||
+	    is_multicast_ether_addr(ehdr->h_dest))
+		return -EINVAL;
+
+	if (ehdr->h_proto != htons(ETH_P_802_3))
+		return -EINVAL;
+
+	skb = dev_alloc_skb(local->hw.extra_tx_headroom + len);
+	if (!skb)
+		return -ENOMEM;
+
+	skb_reserve(skb, local->hw.extra_tx_headroom);
+	skb_put_data(skb, buf, len);
+
+	skb->dev = dev;
+	skb->protocol = htons(ETH_P_802_3);
+	skb_reset_network_header(skb);
+	skb_reset_mac_header(skb);
+
+	local_bh_disable();
+	__ieee80211_subif_start_xmit(skb, skb->dev, 0,
+				     IEEE80211_TX_CTRL_SKIP_MPATH_LOOKUP);
 	local_bh_enable();
 
 	return 0;
-- 
1.9.1

