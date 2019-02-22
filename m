Return-Path: <SRS0=FR9J=Q5=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.8 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS,USER_AGENT_GIT autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 26602C10F00
	for <linux-wireless@archiver.kernel.org>; Fri, 22 Feb 2019 12:21:19 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id DF2652075A
	for <linux-wireless@archiver.kernel.org>; Fri, 22 Feb 2019 12:21:18 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (1024-bit key) header.d=nbd.name header.i=@nbd.name header.b="YlCSBRWm"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726560AbfBVMVS (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Fri, 22 Feb 2019 07:21:18 -0500
Received: from nbd.name ([46.4.11.11]:36816 "EHLO nbd.name"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725942AbfBVMVS (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 22 Feb 2019 07:21:18 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nbd.name;
         s=20160729; h=Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To:
        MIME-Version:Content-Type:Content-Transfer-Encoding:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:In-Reply-To:References:List-Id:List-Help:List-Unsubscribe:
        List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=O/wsj2f5Vu3Hon+Ac7nYsViYrnm9THJvJH2YHMHTXEY=; b=YlCSBRWmPCvdV9unRZPovwUgfv
        F1pALouKwkjATB6QYQiOsmlOfIgcdep3Pcg4QYm0jn2/ws3EXSis/oUJ6pP/0wzygF0puwwkfVLw6
        XrJTJ2Ao+M+rT6SkvHYx1wUhAUd+fzY2f9gsAcb14z6nHijerbf5cNnf2Ldkuq6ODEfQ=;
Received: by maeck.lan (Postfix, from userid 501)
        id A60BC502FA2D; Fri, 22 Feb 2019 13:21:15 +0100 (CET)
From:   Felix Fietkau <nbd@nbd.name>
To:     linux-wireless@vger.kernel.org
Cc:     johannes@sipsolutions.net, stable@vger.kernel.org
Subject: [PATCH] mac80211: allocate tailroom for forwarded mesh packets
Date:   Fri, 22 Feb 2019 13:21:15 +0100
Message-Id: <20190222122115.68485-1-nbd@nbd.name>
X-Mailer: git-send-email 2.17.0
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Forwarded packets enter the tx path through ieee80211_add_pending_skb,
which skips the ieee80211_skb_resize call.
Fixes WARN_ON in ccmp_encrypt_skb and resulting packet loss.

Cc: stable@vger.kernel.org
Signed-off-by: Felix Fietkau <nbd@nbd.name>
---
 net/mac80211/rx.c | 7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

diff --git a/net/mac80211/rx.c b/net/mac80211/rx.c
index 45aad3d3108c..d78c106ef314 100644
--- a/net/mac80211/rx.c
+++ b/net/mac80211/rx.c
@@ -2644,6 +2644,7 @@ ieee80211_rx_h_mesh_fwding(struct ieee80211_rx_data *rx)
 	struct ieee80211_sub_if_data *sdata = rx->sdata;
 	struct ieee80211_if_mesh *ifmsh = &sdata->u.mesh;
 	u16 ac, q, hdrlen;
+	int tailroom = 0;
 
 	hdr = (struct ieee80211_hdr *) skb->data;
 	hdrlen = ieee80211_hdrlen(hdr->frame_control);
@@ -2730,8 +2731,12 @@ ieee80211_rx_h_mesh_fwding(struct ieee80211_rx_data *rx)
 	if (!ifmsh->mshcfg.dot11MeshForwarding)
 		goto out;
 
+	if (sdata->crypto_tx_tailroom_needed_cnt)
+		tailroom = IEEE80211_ENCRYPT_TAILROOM;
+
 	fwd_skb = skb_copy_expand(skb, local->tx_headroom +
-				       sdata->encrypt_headroom, 0, GFP_ATOMIC);
+				       sdata->encrypt_headroom,
+				  tailroom, GFP_ATOMIC);
 	if (!fwd_skb)
 		goto out;
 
-- 
2.17.0

