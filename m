Return-Path: <SRS0=BJpU=RT=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.8 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 824E5C43381
	for <linux-wireless@archiver.kernel.org>; Sat, 16 Mar 2019 17:06:40 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 464A3218D0
	for <linux-wireless@archiver.kernel.org>; Sat, 16 Mar 2019 17:06:40 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (1024-bit key) header.d=nbd.name header.i=@nbd.name header.b="qISvyjzq"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727017AbfCPRGi (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Sat, 16 Mar 2019 13:06:38 -0400
Received: from nbd.name ([46.4.11.11]:55504 "EHLO nbd.name"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726815AbfCPRGh (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Sat, 16 Mar 2019 13:06:37 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nbd.name;
         s=20160729; h=References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:
        Sender:Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Resent-Date:Resent-From:Resent-Sender:
        Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:
        List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=62kpW9KfinGAQqcZq8Md0zSUhqrNrPMPo7g2p1szLT4=; b=qISvyjzqTRx+KP/poeF8SnDqJg
        L5JzEg/sGzcYRnm9X6GmzWst5GhgplgcjfXYcCLHe7/15H9JHQoPv+b3kozlrEZHF3onun6HNfNQB
        /BldUcdVxUofEwFtnSZdSUmU/9cgwf5h0VAH3zDnF/9wuwvyhCy94CNegwiUGNBAdkjM=;
Received: from p4ff1316d.dip0.t-ipconnect.de ([79.241.49.109] helo=maeck-2.local)
        by ds12 with esmtpsa (TLS1.2:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.89)
        (envelope-from <nbd@nbd.name>)
        id 1h5ClX-00071o-Oj; Sat, 16 Mar 2019 18:06:36 +0100
Received: by maeck-2.local (Postfix, from userid 501)
        id CC11452C90E4; Sat, 16 Mar 2019 18:06:34 +0100 (CET)
From:   Felix Fietkau <nbd@nbd.name>
To:     linux-wireless@vger.kernel.org
Cc:     johannes@sipsolutions.net
Subject: [PATCH 4/5] mac80211: run late dequeue late tx handlers without holding fq->lock
Date:   Sat, 16 Mar 2019 18:06:33 +0100
Message-Id: <20190316170634.13125-4-nbd@nbd.name>
X-Mailer: git-send-email 2.17.0
In-Reply-To: <20190316170634.13125-1-nbd@nbd.name>
References: <20190316170634.13125-1-nbd@nbd.name>
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Reduces lock contention on enqueue/dequeue of iTXQ packets

Signed-off-by: Felix Fietkau <nbd@nbd.name>
---
 net/mac80211/tx.c | 10 ++++++++--
 1 file changed, 8 insertions(+), 2 deletions(-)

diff --git a/net/mac80211/tx.c b/net/mac80211/tx.c
index 8127e43e12b1..f85344c9af62 100644
--- a/net/mac80211/tx.c
+++ b/net/mac80211/tx.c
@@ -3544,6 +3544,7 @@ struct sk_buff *ieee80211_tx_dequeue(struct ieee80211_hw *hw,
 	ieee80211_tx_result r;
 	struct ieee80211_vif *vif = txq->vif;
 
+begin:
 	spin_lock_bh(&fq->lock);
 
 	if (test_bit(IEEE80211_TXQ_STOP, &txqi->flags) ||
@@ -3560,11 +3561,12 @@ struct sk_buff *ieee80211_tx_dequeue(struct ieee80211_hw *hw,
 	if (skb)
 		goto out;
 
-begin:
 	skb = fq_tin_dequeue(fq, tin, fq_tin_dequeue_func);
 	if (!skb)
 		goto out;
 
+	spin_unlock_bh(&fq->lock);
+
 	hdr = (struct ieee80211_hdr *)skb->data;
 	info = IEEE80211_SKB_CB(skb);
 
@@ -3610,8 +3612,11 @@ struct sk_buff *ieee80211_tx_dequeue(struct ieee80211_hw *hw,
 
 		skb = __skb_dequeue(&tx.skbs);
 
-		if (!skb_queue_empty(&tx.skbs))
+		if (!skb_queue_empty(&tx.skbs)) {
+			spin_lock_bh(&fq->lock);
 			skb_queue_splice_tail(&tx.skbs, &txqi->frags);
+			spin_unlock_bh(&fq->lock);
+		}
 	}
 
 	if (skb_has_frag_list(skb) &&
@@ -3650,6 +3655,7 @@ struct sk_buff *ieee80211_tx_dequeue(struct ieee80211_hw *hw,
 	}
 
 	IEEE80211_SKB_CB(skb)->control.vif = vif;
+	return skb;
 
 out:
 	spin_unlock_bh(&fq->lock);
-- 
2.17.0

