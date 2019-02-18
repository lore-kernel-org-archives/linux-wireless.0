Return-Path: <SRS0=F8Dj=QZ=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.8 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CC0B0C43381
	for <linux-wireless@archiver.kernel.org>; Mon, 18 Feb 2019 06:04:35 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 9B8E7218B0
	for <linux-wireless@archiver.kernel.org>; Mon, 18 Feb 2019 06:04:35 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="JZ5GfDZm";
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="dm7KwZov"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727271AbfBRGEe (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Mon, 18 Feb 2019 01:04:34 -0500
Received: from smtp.codeaurora.org ([198.145.29.96]:34512 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725809AbfBRGEe (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 18 Feb 2019 01:04:34 -0500
Received: by smtp.codeaurora.org (Postfix, from userid 1000)
        id 10F25607EF; Mon, 18 Feb 2019 06:04:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1550469873;
        bh=hFtlDkhoN3macWvji8K7gVAkyr82WGAIw7VdJm0EkJc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=JZ5GfDZmovI+KvwQgNm8+NPELz9kO3IrfTDdwTGy00DkawBUuqYvLDB4kvbM875QL
         fPVxdy5DAOnRmydarlYDVXDdfksLA9u4dSeCskf4saa2kW/OZyvvIsybDr3N539oqy
         eOfbXaL86WeX0OuTaLqMCCrFXk2WRFg9pLu3ZMB0=
Received: from smtp.codeaurora.org (i-global254.qualcomm.com [199.106.103.254])
        (using TLSv1 with cipher AES128-SHA (128/128 bits))
        (No client certificate requested)
        (Authenticated sender: rmanohar@smtp.codeaurora.org)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id 3F42360397;
        Mon, 18 Feb 2019 06:04:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1550469872;
        bh=hFtlDkhoN3macWvji8K7gVAkyr82WGAIw7VdJm0EkJc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=dm7KwZovWRecIkkNsISCJSL6JAGJrEyBTCd/RUx4daIvYlUsySeBDejtbHM3/q/rC
         Es0h7Kqvmh2S2Z4/aiy+CJ9dowvByRdeJtk2WsN1VGe1Od14jHaAMVkmIJbtkDB//2
         Z38WFX56X97bl0rCNKXarPiXhqe3ncsBcFkYYLfo=
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org 3F42360397
Authentication-Results: pdx-caf-mail.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: pdx-caf-mail.web.codeaurora.org; spf=none smtp.mailfrom=rmanohar@codeaurora.org
Received: by smtp.codeaurora.org (sSMTP sendmail emulation); Sun, 17 Feb 2019 22:04:30 -0800
From:   Rajkumar Manoharan <rmanohar@codeaurora.org>
To:     johannes@sipsolutions.net
Cc:     linux-wireless@vger.kernel.org,
        Rajkumar Manoharan <rmanohar@codeaurora.org>
Subject: [PATCH 2/3] mac80211: add option for setting control flags
Date:   Sun, 17 Feb 2019 22:04:16 -0800
Message-Id: <1550469857-3968-3-git-send-email-rmanohar@codeaurora.org>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1550469857-3968-1-git-send-email-rmanohar@codeaurora.org>
References: <1550469857-3968-1-git-send-email-rmanohar@codeaurora.org>
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
index 7dfb4e2f98b2..a1638a5d4188 100644
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
index 928f13a208b0..c2ee5678b2d8 100644
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
 
@@ -4907,7 +4911,7 @@ int ieee80211_tx_control_port(struct wiphy *wiphy, struct net_device *dev,
 	skb_reset_mac_header(skb);
 
 	local_bh_disable();
-	__ieee80211_subif_start_xmit(skb, skb->dev, flags);
+	__ieee80211_subif_start_xmit(skb, skb->dev, flags, 0);
 	local_bh_enable();
 
 	return 0;
-- 
1.9.1

