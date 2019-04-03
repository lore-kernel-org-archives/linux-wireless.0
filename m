Return-Path: <SRS0=OUAD=SF=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.8 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6D85CC10F0B
	for <linux-wireless@archiver.kernel.org>; Wed,  3 Apr 2019 19:14:57 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 39ED620882
	for <linux-wireless@archiver.kernel.org>; Wed,  3 Apr 2019 19:14:57 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="P+tT+T1O";
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="lZ0qbGvW"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726530AbfDCTO4 (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Wed, 3 Apr 2019 15:14:56 -0400
Received: from smtp.codeaurora.org ([198.145.29.96]:32960 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726064AbfDCTOz (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 3 Apr 2019 15:14:55 -0400
Received: by smtp.codeaurora.org (Postfix, from userid 1000)
        id 507476115C; Wed,  3 Apr 2019 19:14:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1554318895;
        bh=8+6n5PUUog++kECr6I4FZsP48ZE2OMLKHM3N1KUvPEw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=P+tT+T1O9rctUaEsUzAbwX0czJoU7tmq/BV1YnCK2TBocEdae/nDlxpEt/4OOGnHf
         WtYgjwxZqzKx9G242jIiduV2VV93NoZaG8Q9nZNGRz+Al61qcmrWcwWWCKibs6VEbT
         cXZxLFYPmsu5TN9109vvZecxuDjnGPKSU4BNECzY=
Received: from smtp.codeaurora.org (i-global254.qualcomm.com [199.106.103.254])
        (using TLSv1 with cipher AES128-SHA (128/128 bits))
        (No client certificate requested)
        (Authenticated sender: rmanohar@smtp.codeaurora.org)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id 8145A609CD;
        Wed,  3 Apr 2019 19:14:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1554318894;
        bh=8+6n5PUUog++kECr6I4FZsP48ZE2OMLKHM3N1KUvPEw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=lZ0qbGvWKXh6Alxtgg2W9gmNFE78Jt0cKbYfN7/bAeFYAgskI1BI2j7OMLJBfNtGW
         eWCmxmVIMMxw6wAfvH0m27gBoKwBWLF84C08LxnHsHFd8naHrn0BuPcaQ1l2A6XA9R
         PqisotZHy95s8ku1EzW2i1hy7Zw04BfIAkjS0vFM=
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org 8145A609CD
Authentication-Results: pdx-caf-mail.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: pdx-caf-mail.web.codeaurora.org; spf=none smtp.mailfrom=rmanohar@codeaurora.org
Received: by smtp.codeaurora.org (sSMTP sendmail emulation); Wed, 03 Apr 2019 12:14:52 -0700
From:   Rajkumar Manoharan <rmanohar@codeaurora.org>
To:     johannes@sipsolutions.net
Cc:     linux-wireless@vger.kernel.org,
        Rajkumar Manoharan <rmanohar@codeaurora.org>
Subject: [PATCH v3 2/3] mac80211: add option for setting control flags
Date:   Wed,  3 Apr 2019 12:14:43 -0700
Message-Id: <1554318884-22450-3-git-send-email-rmanohar@codeaurora.org>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1554318884-22450-1-git-send-email-rmanohar@codeaurora.org>
References: <1554318884-22450-1-git-send-email-rmanohar@codeaurora.org>
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Allows setting of control flags of skb cb - if needed -
when calling ieee80211_subif_start_xmit().

Signed-off-by: Rajkumar Manoharan <rmanohar@codeaurora.org>
---
 net/mac80211/ieee80211_i.h |  3 ++-
 net/mac80211/tdls.c        |  2 +-
 net/mac80211/tx.c          | 18 +++++++++++-------
 3 files changed, 14 insertions(+), 9 deletions(-)

diff --git a/net/mac80211/ieee80211_i.h b/net/mac80211/ieee80211_i.h
index e170f986d226..bf3906ba42dd 100644
--- a/net/mac80211/ieee80211_i.h
+++ b/net/mac80211/ieee80211_i.h
@@ -1761,7 +1761,8 @@ netdev_tx_t ieee80211_subif_start_xmit(struct sk_buff *skb,
 				       struct net_device *dev);
 void __ieee80211_subif_start_xmit(struct sk_buff *skb,
 				  struct net_device *dev,
-				  u32 info_flags);
+				  u32 info_flags,
+				  u32 ctrl_flags);
 void ieee80211_purge_tx_queue(struct ieee80211_hw *hw,
 			      struct sk_buff_head *skbs);
 struct sk_buff *
diff --git a/net/mac80211/tdls.c b/net/mac80211/tdls.c
index d30690d79a58..24c37f91ca46 100644
--- a/net/mac80211/tdls.c
+++ b/net/mac80211/tdls.c
@@ -1056,7 +1056,7 @@ static void ieee80211_tdls_add_ies(struct ieee80211_sub_if_data *sdata,
 
 	/* disable bottom halves when entering the Tx path */
 	local_bh_disable();
-	__ieee80211_subif_start_xmit(skb, dev, flags);
+	__ieee80211_subif_start_xmit(skb, dev, flags, 0);
 	local_bh_enable();
 
 	return ret;
diff --git a/net/mac80211/tx.c b/net/mac80211/tx.c
index 2e816dd67be7..f352ec9f150c 100644
--- a/net/mac80211/tx.c
+++ b/net/mac80211/tx.c
@@ -2431,6 +2431,7 @@ static int ieee80211_lookup_ra_sta(struct ieee80211_sub_if_data *sdata,
  * @sdata: virtual interface to build the header for
  * @skb: the skb to build the header in
  * @info_flags: skb flags to set
+ * @ctrl_flags: info control flags to set
  *
  * This function takes the skb with 802.3 header and reformats the header to
  * the appropriate IEEE 802.11 header based on which interface the packet is
@@ -2446,7 +2447,7 @@ static int ieee80211_lookup_ra_sta(struct ieee80211_sub_if_data *sdata,
  */
 static struct sk_buff *ieee80211_build_hdr(struct ieee80211_sub_if_data *sdata,
 					   struct sk_buff *skb, u32 info_flags,
-					   struct sta_info *sta)
+					   struct sta_info *sta, u32 ctrl_flags)
 {
 	struct ieee80211_local *local = sdata->local;
 	struct ieee80211_tx_info *info;
@@ -2818,6 +2819,7 @@ static struct sk_buff *ieee80211_build_hdr(struct ieee80211_sub_if_data *sdata,
 	info->flags = info_flags;
 	info->ack_frame_id = info_id;
 	info->band = band;
+	info->control.flags = ctrl_flags;
 
 	return skb;
  free:
@@ -3783,7 +3785,8 @@ void ieee80211_txq_schedule_start(struct ieee80211_hw *hw, u8 ac)
 
 void __ieee80211_subif_start_xmit(struct sk_buff *skb,
 				  struct net_device *dev,
-				  u32 info_flags)
+				  u32 info_flags,
+				  u32 ctrl_flags)
 {
 	struct ieee80211_sub_if_data *sdata = IEEE80211_DEV_TO_SUB_IF(dev);
 	struct sta_info *sta;
@@ -3848,7 +3851,8 @@ void __ieee80211_subif_start_xmit(struct sk_buff *skb,
 		skb->prev = NULL;
 		skb->next = NULL;
 
-		skb = ieee80211_build_hdr(sdata, skb, info_flags, sta);
+		skb = ieee80211_build_hdr(sdata, skb, info_flags,
+					  sta, ctrl_flags);
 		if (IS_ERR(skb))
 			goto out;
 
@@ -3988,9 +3992,9 @@ netdev_tx_t ieee80211_subif_start_xmit(struct sk_buff *skb,
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
@@ -4015,7 +4019,7 @@ struct sk_buff *
 		goto out;
 	}
 
-	skb = ieee80211_build_hdr(sdata, skb, info_flags, sta);
+	skb = ieee80211_build_hdr(sdata, skb, info_flags, sta, 0);
 	if (IS_ERR(skb))
 		goto out;
 
@@ -5052,7 +5056,7 @@ int ieee80211_tx_control_port(struct wiphy *wiphy, struct net_device *dev,
 	skb_reset_mac_header(skb);
 
 	local_bh_disable();
-	__ieee80211_subif_start_xmit(skb, skb->dev, flags);
+	__ieee80211_subif_start_xmit(skb, skb->dev, flags, 0);
 	local_bh_enable();
 
 	return 0;
-- 
1.9.1

