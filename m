Return-Path: <SRS0=K+dv=RH=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.8 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1D310C4360F
	for <linux-wireless@archiver.kernel.org>; Mon,  4 Mar 2019 08:02:42 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id DC4C220863
	for <linux-wireless@archiver.kernel.org>; Mon,  4 Mar 2019 08:02:41 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (1024-bit key) header.d=nbd.name header.i=@nbd.name header.b="M/doayzm"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726080AbfCDICl (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Mon, 4 Mar 2019 03:02:41 -0500
Received: from nbd.name ([46.4.11.11]:40440 "EHLO nbd.name"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726014AbfCDICk (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 4 Mar 2019 03:02:40 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nbd.name;
         s=20160729; h=References:In-Reply-To:Message-Id:Date:Subject:To:From:Sender:
        Reply-To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=gc1iSfJS/ZyamgWzCt8ru7xqmGX+zyarEDdTT/if+o4=; b=M/doayzm08ODdQkbNwAvW2gTpl
        cd7S4NDFgTpP4FubtZMjwLTjS8bUa5K8mStpGYYYrZiHmDuYgTKQQ+forjGftU6rFA0CmVcFTYPPH
        FeydO6Ha+Rl/uIb/2Vn32wLTlf1+th1oPE/79N6kyvmlvklLLVgbXsyFn3nvXvmpJFhg=;
Received: by maeck.lan (Postfix, from userid 501)
        id 18AF050E5410; Mon,  4 Mar 2019 09:02:34 +0100 (CET)
From:   Felix Fietkau <nbd@nbd.name>
To:     linux-wireless@vger.kernel.org
Subject: [PATCH 09/11] mt76: when releasing PS frames, end the service period if no frame was found
Date:   Mon,  4 Mar 2019 09:02:32 +0100
Message-Id: <20190304080234.3221-9-nbd@nbd.name>
X-Mailer: git-send-email 2.17.0
In-Reply-To: <20190304080234.3221-1-nbd@nbd.name>
References: <20190304080234.3221-1-nbd@nbd.name>
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Fixes a rare corner case if the txq dequeue attempt fails, but mac80211
still has PS buffered packets

Signed-off-by: Felix Fietkau <nbd@nbd.name>
---
 drivers/net/wireless/mediatek/mt76/tx.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/net/wireless/mediatek/mt76/tx.c b/drivers/net/wireless/mediatek/mt76/tx.c
index fc7dffe066be..2585df512335 100644
--- a/drivers/net/wireless/mediatek/mt76/tx.c
+++ b/drivers/net/wireless/mediatek/mt76/tx.c
@@ -377,7 +377,10 @@ mt76_release_buffered_frames(struct ieee80211_hw *hw, struct ieee80211_sta *sta,
 	if (last_skb) {
 		mt76_queue_ps_skb(dev, sta, last_skb, true);
 		dev->queue_ops->kick(dev, hwq);
+	} else {
+		ieee80211_sta_eosp(sta);
 	}
+
 	spin_unlock_bh(&hwq->lock);
 }
 EXPORT_SYMBOL_GPL(mt76_release_buffered_frames);
-- 
2.17.0

