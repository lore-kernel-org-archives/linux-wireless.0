Return-Path: <SRS0=s1k3=OY=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.9 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id ABB09C4363B
	for <linux-wireless@archiver.kernel.org>; Sat, 15 Dec 2018 09:03:38 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 824972084D
	for <linux-wireless@archiver.kernel.org>; Sat, 15 Dec 2018 09:03:38 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730023AbeLOJDh (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Sat, 15 Dec 2018 04:03:37 -0500
Received: from paleale.coelho.fi ([176.9.41.70]:42212 "EHLO
        farmhouse.coelho.fi" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1729750AbeLOJDh (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Sat, 15 Dec 2018 04:03:37 -0500
Received: from 91-156-4-241.elisa-laajakaista.fi ([91.156.4.241] helo=redipa.ger.corp.intel.com)
        by farmhouse.coelho.fi with esmtpsa (TLS1.2:ECDHE_RSA_AES_128_GCM_SHA256:128)
        (Exim 4.91)
        (envelope-from <luca@coelho.fi>)
        id 1gY5rD-0002oc-7K; Sat, 15 Dec 2018 11:03:35 +0200
From:   Luca Coelho <luca@coelho.fi>
To:     johannes@sipsolutions.net
Cc:     linux-wireless@vger.kernel.org,
        Sara Sharon <sara.sharon@intel.com>,
        Luca Coelho <luciano.coelho@intel.com>
Date:   Sat, 15 Dec 2018 11:03:07 +0200
Message-Id: <20181215090325.31604-7-luca@coelho.fi>
X-Mailer: git-send-email 2.19.2
In-Reply-To: <20181215090325.31604-1-luca@coelho.fi>
References: <20181215090325.31604-1-luca@coelho.fi>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: [PATCH 06/24] mac80211: don't build AMSDU from GSO packets
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

From: Sara Sharon <sara.sharon@intel.com>

If we build AMSDU from GSO packets, it can lead to
bad results if anyone tries to call skb_gso_segment
on the packets.

Signed-off-by: Sara Sharon <sara.sharon@intel.com>
Signed-off-by: Luca Coelho <luciano.coelho@intel.com>
---
 net/mac80211/tx.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/net/mac80211/tx.c b/net/mac80211/tx.c
index 582b3d49f891..565fe7291c7d 100644
--- a/net/mac80211/tx.c
+++ b/net/mac80211/tx.c
@@ -3218,6 +3218,9 @@ static bool ieee80211_amsdu_aggregate(struct ieee80211_sub_if_data *sdata,
 	if (!ieee80211_hw_check(&local->hw, TX_AMSDU))
 		return false;
 
+	if (skb_is_gso(skb))
+		return false;
+
 	if (!txq)
 		return false;
 
@@ -3242,7 +3245,7 @@ static bool ieee80211_amsdu_aggregate(struct ieee80211_sub_if_data *sdata,
 	tin = &txqi->tin;
 	flow = fq_flow_classify(fq, tin, skb, fq_flow_get_default_func);
 	head = skb_peek_tail(&flow->queue);
-	if (!head)
+	if (!head || skb_is_gso(head))
 		goto out;
 
 	orig_len = head->len;
-- 
2.19.2

