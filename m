Return-Path: <linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.6 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4FEBEC0018C
	for <linux-wireless@archiver.kernel.org>; Wed, 16 Dec 2020 20:44:19 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 32C7B233F7
	for <linux-wireless@archiver.kernel.org>; Wed, 16 Dec 2020 20:44:19 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729039AbgLPUoS (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Wed, 16 Dec 2020 15:44:18 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41654 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728811AbgLPUoR (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 16 Dec 2020 15:44:17 -0500
Received: from nbd.name (nbd.name [IPv6:2a01:4f8:221:3d45::2])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5A316C061794
        for <linux-wireless@vger.kernel.org>; Wed, 16 Dec 2020 12:43:22 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nbd.name;
         s=20160729; h=Content-Transfer-Encoding:MIME-Version:References:In-Reply-To:
        Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=d0Jysqlv14mdChJvJUNMswAvTXdXy8HR0mID1snGPkw=; b=nGsMHvEu4xnTL9la5/FeNjSmNb
        hzbowXIUkkKcS+FHfUgt1ObwU28c3DWYyfbinyIW/9SczC+gAJriM7NmL9A76I7LmYkxKrDRHrLR7
        f4EXcosA4ywj5CTGLiPHSfyx4CcJmLrAK67n8tB+SaOEyhCcuXBkqSsTgEWJh1vALSnE=;
Received: from p4ff13815.dip0.t-ipconnect.de ([79.241.56.21] helo=localhost.localdomain)
        by ds12 with esmtpsa (TLS1.2:ECDHE_RSA_AES_128_CBC_SHA1:128)
        (Exim 4.89)
        (envelope-from <nbd@nbd.name>)
        id 1kpddm-0002eR-Rf; Wed, 16 Dec 2020 21:43:18 +0100
From:   Felix Fietkau <nbd@nbd.name>
To:     linux-wireless@vger.kernel.org
Cc:     johannes@sipsolutions.net
Subject: [PATCH 5/7] mac80211: fix encryption key selection for 802.3 xmit
Date:   Wed, 16 Dec 2020 21:43:14 +0100
Message-Id: <20201216204316.44498-5-nbd@nbd.name>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20201216204316.44498-1-nbd@nbd.name>
References: <20201216204316.44498-1-nbd@nbd.name>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

When using WEP, the default unicast key needs to be selected, instead of
the STA PTK.

Signed-off-by: Felix Fietkau <nbd@nbd.name>
---
 net/mac80211/tx.c | 27 +++++++++++++++------------
 1 file changed, 15 insertions(+), 12 deletions(-)

diff --git a/net/mac80211/tx.c b/net/mac80211/tx.c
index cb3c2d6334b3..3eb9604e316f 100644
--- a/net/mac80211/tx.c
+++ b/net/mac80211/tx.c
@@ -4237,7 +4237,6 @@ netdev_tx_t ieee80211_subif_start_xmit_8023(struct sk_buff *skb,
 	struct ethhdr *ehdr = (struct ethhdr *)skb->data;
 	struct ieee80211_key *key;
 	struct sta_info *sta;
-	bool offload = true;
 
 	if (unlikely(skb->len < ETH_HLEN)) {
 		kfree_skb(skb);
@@ -4253,18 +4252,22 @@ netdev_tx_t ieee80211_subif_start_xmit_8023(struct sk_buff *skb,
 
 	if (unlikely(IS_ERR_OR_NULL(sta) || !sta->uploaded ||
 	    !test_sta_flag(sta, WLAN_STA_AUTHORIZED) ||
-		sdata->control_port_protocol == ehdr->h_proto))
-		offload = false;
-	else if ((key = rcu_dereference(sta->ptk[sta->ptk_idx])) &&
-		 (!(key->flags & KEY_FLAG_UPLOADED_TO_HARDWARE) ||
-		  key->conf.cipher == WLAN_CIPHER_SUITE_TKIP))
-		offload = false;
-
-	if (offload)
-		ieee80211_8023_xmit(sdata, dev, sta, key, skb);
-	else
-		ieee80211_subif_start_xmit(skb, dev);
+	    sdata->control_port_protocol == ehdr->h_proto))
+		goto skip_offload;
+
+	key = rcu_dereference(sta->ptk[sta->ptk_idx]);
+	if (!key)
+		key = rcu_dereference(sdata->default_unicast_key);
+
+	if (key && (!(key->flags & KEY_FLAG_UPLOADED_TO_HARDWARE) ||
+		    key->conf.cipher == WLAN_CIPHER_SUITE_TKIP))
+		goto skip_offload;
+
+	ieee80211_8023_xmit(sdata, dev, sta, key, skb);
+	goto out;
 
+skip_offload:
+	ieee80211_subif_start_xmit(skb, dev);
 out:
 	rcu_read_unlock();
 
-- 
2.28.0

