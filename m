Return-Path: <SRS0=s1k3=OY=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.9 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D864AC43174
	for <linux-wireless@archiver.kernel.org>; Sat, 15 Dec 2018 09:03:40 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id B6C7F2084D
	for <linux-wireless@archiver.kernel.org>; Sat, 15 Dec 2018 09:03:40 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730060AbeLOJDk (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Sat, 15 Dec 2018 04:03:40 -0500
Received: from paleale.coelho.fi ([176.9.41.70]:42234 "EHLO
        farmhouse.coelho.fi" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1730022AbeLOJDi (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Sat, 15 Dec 2018 04:03:38 -0500
Received: from 91-156-4-241.elisa-laajakaista.fi ([91.156.4.241] helo=redipa.ger.corp.intel.com)
        by farmhouse.coelho.fi with esmtpsa (TLS1.2:ECDHE_RSA_AES_128_GCM_SHA256:128)
        (Exim 4.91)
        (envelope-from <luca@coelho.fi>)
        id 1gY5rE-0002oc-IQ; Sat, 15 Dec 2018 11:03:36 +0200
From:   Luca Coelho <luca@coelho.fi>
To:     johannes@sipsolutions.net
Cc:     linux-wireless@vger.kernel.org,
        Johannes Berg <johannes.berg@intel.com>
Date:   Sat, 15 Dec 2018 11:03:09 +0200
Message-Id: <20181215090325.31604-9-luca@coelho.fi>
X-Mailer: git-send-email 2.19.2
In-Reply-To: <20181215090325.31604-1-luca@coelho.fi>
References: <20181215090325.31604-1-luca@coelho.fi>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: [PATCH 08/24] mac80211: remove superfluous NULL check
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

From: Johannes Berg <johannes.berg@intel.com>

At the place where this code lives now, the skb can never be
NULL, so we can remove the pointless NULL check.

It seems to exist because this code was moved around a few times
and originally came from a place where it could in fact be NULL.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 net/mac80211/tx.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/mac80211/tx.c b/net/mac80211/tx.c
index 565fe7291c7d..4f348b116549 100644
--- a/net/mac80211/tx.c
+++ b/net/mac80211/tx.c
@@ -3586,7 +3586,7 @@ struct sk_buff *ieee80211_tx_dequeue(struct ieee80211_hw *hw,
 			skb_queue_splice_tail(&tx.skbs, &txqi->frags);
 	}
 
-	if (skb && skb_has_frag_list(skb) &&
+	if (skb_has_frag_list(skb) &&
 	    !ieee80211_hw_check(&local->hw, TX_FRAG_LIST)) {
 		if (skb_linearize(skb)) {
 			ieee80211_free_txskb(&local->hw, skb);
-- 
2.19.2

