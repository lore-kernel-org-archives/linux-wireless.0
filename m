Return-Path: <SRS0=Zq5x=5F=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4F23CC4332B
	for <linux-wireless@archiver.kernel.org>; Fri, 20 Mar 2020 09:20:40 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 22BFF20739
	for <linux-wireless@archiver.kernel.org>; Fri, 20 Mar 2020 09:20:40 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726704AbgCTJUj (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Fri, 20 Mar 2020 05:20:39 -0400
Received: from s3.sipsolutions.net ([144.76.43.62]:42224 "EHLO
        sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726232AbgCTJUj (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 20 Mar 2020 05:20:39 -0400
Received: by sipsolutions.net with esmtpsa (TLS1.3:ECDHE_X25519__RSA_PSS_RSAE_SHA256__AES_256_GCM:256)
        (Exim 4.93)
        (envelope-from <johannes@sipsolutions.net>)
        id 1jFDpT-00APNL-Cp; Fri, 20 Mar 2020 10:20:35 +0100
From:   Johannes Berg <johannes@sipsolutions.net>
To:     linux-wireless@vger.kernel.org
Cc:     Johannes Berg <johannes.berg@intel.com>
Subject: [PATCH] mac80211: don't leave skb->next/prev pointing to stack
Date:   Fri, 20 Mar 2020 10:20:23 +0100
Message-Id: <20200320102021.1be7823fc05e.Ia89fb79a0469d32137c9a04315a1d2dfc7b7d6f5@changeid>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

From: Johannes Berg <johannes.berg@intel.com>

In beacon protection, don't leave skb->next/prev pointing to the
on-stack list, even if that's actually harmless since we don't use
them again afterwards.

While at it, check that the SKB on the list is still the same, as
that's required here. If not, the encryption (protection) code is
buggy.

Fixes: 0a3a84360b37 ("mac80211: Beacon protection using the new BIGTK (AP)")
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 net/mac80211/tx.c | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/net/mac80211/tx.c b/net/mac80211/tx.c
index 83147385c200..49d35936cc9d 100644
--- a/net/mac80211/tx.c
+++ b/net/mac80211/tx.c
@@ -4670,6 +4670,7 @@ static int ieee80211_beacon_protect(struct sk_buff *skb,
 {
 	ieee80211_tx_result res;
 	struct ieee80211_tx_data tx;
+	struct sk_buff *check_skb;
 
 	memset(&tx, 0, sizeof(tx));
 	tx.key = rcu_dereference(sdata->default_beacon_key);
@@ -4680,8 +4681,11 @@ static int ieee80211_beacon_protect(struct sk_buff *skb,
 	__skb_queue_head_init(&tx.skbs);
 	__skb_queue_tail(&tx.skbs, skb);
 	res = ieee80211_tx_h_encrypt(&tx);
+	check_skb = __skb_dequeue(&tx.skbs);
+	/* we may crash after this, but it'd be a bug in crypto */
+	WARN_ON(check_skb != skb);
 	if (WARN_ON_ONCE(res != TX_CONTINUE))
-		return -1;
+		return -EINVAL;
 
 	return 0;
 }
-- 
2.25.1

