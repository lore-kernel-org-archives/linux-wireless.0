Return-Path: <SRS0=IMqP=SN=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.8 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D7213C282CE
	for <linux-wireless@archiver.kernel.org>; Thu, 11 Apr 2019 20:47:51 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id A4F922146F
	for <linux-wireless@archiver.kernel.org>; Thu, 11 Apr 2019 20:47:51 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="TzTDTK3L";
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="TzTDTK3L"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726951AbfDKUrv (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Thu, 11 Apr 2019 16:47:51 -0400
Received: from smtp.codeaurora.org ([198.145.29.96]:48910 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726629AbfDKUru (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 11 Apr 2019 16:47:50 -0400
Received: by smtp.codeaurora.org (Postfix, from userid 1000)
        id B3CE261197; Thu, 11 Apr 2019 20:47:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1555015669;
        bh=96rhrY+nmJTHk6zErupcBgwVnNkhQ/QWcpt8hZpvgDo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=TzTDTK3L4pFYZEjcZDzLnvBdgLY8OZRhc5e1UwFuhMrEn+NEdKP9ro78LYl6oE3qi
         beV/m5tAc61qjBWXU7d/y06rqNNvtoIhXJb8PYsupFviSU2t7WcvZS8Vq5C/KWJF9k
         9KYfLt9FHWZULn+GF2wN3koV0goIitEtpFidKVGA=
Received: from smtp.codeaurora.org (i-global254.qualcomm.com [199.106.103.254])
        (using TLSv1 with cipher AES128-SHA (128/128 bits))
        (No client certificate requested)
        (Authenticated sender: rmanohar@smtp.codeaurora.org)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id 100EC61194;
        Thu, 11 Apr 2019 20:47:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1555015669;
        bh=96rhrY+nmJTHk6zErupcBgwVnNkhQ/QWcpt8hZpvgDo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=TzTDTK3L4pFYZEjcZDzLnvBdgLY8OZRhc5e1UwFuhMrEn+NEdKP9ro78LYl6oE3qi
         beV/m5tAc61qjBWXU7d/y06rqNNvtoIhXJb8PYsupFviSU2t7WcvZS8Vq5C/KWJF9k
         9KYfLt9FHWZULn+GF2wN3koV0goIitEtpFidKVGA=
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org 100EC61194
Authentication-Results: pdx-caf-mail.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: pdx-caf-mail.web.codeaurora.org; spf=none smtp.mailfrom=rmanohar@codeaurora.org
Received: by smtp.codeaurora.org (sSMTP sendmail emulation); Thu, 11 Apr 2019 13:47:47 -0700
From:   Rajkumar Manoharan <rmanohar@codeaurora.org>
To:     johannes@sipsolutions.net
Cc:     linux-wireless@vger.kernel.org,
        Rajkumar Manoharan <rmanohar@codeaurora.org>
Subject: [PATCH v4 2/3] mac80211: add option for setting control flags
Date:   Thu, 11 Apr 2019 13:47:25 -0700
Message-Id: <1555015646-7655-3-git-send-email-rmanohar@codeaurora.org>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1555015646-7655-1-git-send-email-rmanohar@codeaurora.org>
References: <1555015646-7655-1-git-send-email-rmanohar@codeaurora.org>
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Allows setting of control flags of skb cb - if needed -
when calling ieee80211_subif_start_xmit().

Tested-by: Pradeep Kumar Chitrapu <pradeepc@codeaurora.org>
Signed-off-by: Rajkumar Manoharan <rmanohar@codeaurora.org>
---
 net/mac80211/ieee80211_i.h |  3 ++-
 net/mac80211/tdls.c        |  2 +-
 net/mac80211/tx.c          | 18 +++++++++++-------
 3 files changed, 14 insertions(+), 9 deletions(-)

diff --git a/net/mac80211/ieee80211_i.h b/net/mac80211/ieee80211_i.h
index 861bf8312177..8a99bcfe81ec 100644
--- a/net/mac80211/ieee80211_i.h
+++ b/net/mac80211/ieee80211_i.h
@@ -1762,7 +1762,8 @@ netdev_tx_t ieee80211_subif_start_xmit(struct sk_buff *skb,
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
index 1e82ba7c34e3..ffe35fc89351 100644
--- a/net/mac80211/tx.c
+++ b/net/mac80211/tx.c
@@ -2432,6 +2432,7 @@ static int ieee80211_lookup_ra_sta(struct ieee80211_sub_if_data *sdata,
  * @sdata: virtual interface to build the header for
  * @skb: the skb to build the header in
  * @info_flags: skb flags to set
+ * @ctrl_flags: info control flags to set
  *
  * This function takes the skb with 802.3 header and reformats the header to
  * the appropriate IEEE 802.11 header based on which interface the packet is
@@ -2447,7 +2448,7 @@ static int ieee80211_lookup_ra_sta(struct ieee80211_sub_if_data *sdata,
  */
 static struct sk_buff *ieee80211_build_hdr(struct ieee80211_sub_if_data *sdata,
 					   struct sk_buff *skb, u32 info_flags,
-					   struct sta_info *sta)
+					   struct sta_info *sta, u32 ctrl_flags)
 {
 	struct ieee80211_local *local = sdata->local;
 	struct ieee80211_tx_info *info;
@@ -2824,6 +2825,7 @@ static struct sk_buff *ieee80211_build_hdr(struct ieee80211_sub_if_data *sdata,
 	info->flags = info_flags;
 	info->ack_frame_id = info_id;
 	info->band = band;
+	info->control.flags = ctrl_flags;
 
 	return skb;
  free:
@@ -3805,7 +3807,8 @@ void ieee80211_txq_schedule_end(struct ieee80211_hw *hw, u8 ac)
 
 void __ieee80211_subif_start_xmit(struct sk_buff *skb,
 				  struct net_device *dev,
-				  u32 info_flags)
+				  u32 info_flags,
+				  u32 ctrl_flags)
 {
 	struct ieee80211_sub_if_data *sdata = IEEE80211_DEV_TO_SUB_IF(dev);
 	struct ieee80211_local *local = sdata->local;
@@ -3879,7 +3882,8 @@ void __ieee80211_subif_start_xmit(struct sk_buff *skb,
 		skb->prev = NULL;
 		skb->next = NULL;
 
-		skb = ieee80211_build_hdr(sdata, skb, info_flags, sta);
+		skb = ieee80211_build_hdr(sdata, skb, info_flags,
+					  sta, ctrl_flags);
 		if (IS_ERR(skb))
 			goto out;
 
@@ -4019,9 +4023,9 @@ netdev_tx_t ieee80211_subif_start_xmit(struct sk_buff *skb,
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
@@ -4046,7 +4050,7 @@ struct sk_buff *
 		goto out;
 	}
 
-	skb = ieee80211_build_hdr(sdata, skb, info_flags, sta);
+	skb = ieee80211_build_hdr(sdata, skb, info_flags, sta, 0);
 	if (IS_ERR(skb))
 		goto out;
 
@@ -5084,7 +5088,7 @@ int ieee80211_tx_control_port(struct wiphy *wiphy, struct net_device *dev,
 	skb_reset_mac_header(skb);
 
 	local_bh_disable();
-	__ieee80211_subif_start_xmit(skb, skb->dev, flags);
+	__ieee80211_subif_start_xmit(skb, skb->dev, flags, 0);
 	local_bh_enable();
 
 	return 0;
-- 
1.9.1

