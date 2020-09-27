Return-Path: <SRS0=HCd0=DE=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.7 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 32B36C4741F
	for <linux-wireless@archiver.kernel.org>; Sun, 27 Sep 2020 17:18:57 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id D947E23718
	for <linux-wireless@archiver.kernel.org>; Sun, 27 Sep 2020 17:18:56 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (1024-bit key) header.d=nbd.name header.i=@nbd.name header.b="hOej4OoF"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726315AbgI0RSz (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Sun, 27 Sep 2020 13:18:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42330 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726280AbgI0RSz (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Sun, 27 Sep 2020 13:18:55 -0400
Received: from nbd.name (nbd.name [IPv6:2a01:4f8:221:3d45::2])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3EEF5C0613D4
        for <linux-wireless@vger.kernel.org>; Sun, 27 Sep 2020 10:18:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nbd.name;
         s=20160729; h=Content-Transfer-Encoding:MIME-Version:References:In-Reply-To:
        Message-Id:Date:Subject:To:From:Sender:Reply-To:Cc:Content-Type:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=rpHo8xelTuKWnoFo2hboJNry9e/+lqJ+2CCIMk77fUg=; b=hOej4OoFZW2V3TRs6R8xGaCl1g
        3y98HRrIOBSRqpvh7upt6yx8mc0gB9Ua29s8Hluu/Zu28KFNXAGTbfYR8L2IWPmS9MxdyjeM3hpwe
        L6HEKD/5El5DDxr268N7DcG4vJtsLBho36YDcBBu8YfY/JYuxpy4Md4RdJeO9TUZvYxM=;
Received: from p4ff134da.dip0.t-ipconnect.de ([79.241.52.218] helo=localhost.localdomain)
        by ds12 with esmtpsa (TLS1.2:ECDHE_RSA_AES_128_CBC_SHA1:128)
        (Exim 4.89)
        (envelope-from <nbd@nbd.name>)
        id 1kMaK5-0002oU-SP
        for linux-wireless@vger.kernel.org; Sun, 27 Sep 2020 19:18:53 +0200
From:   Felix Fietkau <nbd@nbd.name>
To:     linux-wireless@vger.kernel.org
Subject: [PATCH 3/8] mt76: use ieee80211_rx_list to pass frames to the network stack as a batch
Date:   Sun, 27 Sep 2020 19:18:47 +0200
Message-Id: <20200927171852.48669-3-nbd@nbd.name>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200927171852.48669-1-nbd@nbd.name>
References: <20200927171852.48669-1-nbd@nbd.name>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Improves icache footprint

Signed-off-by: Felix Fietkau <nbd@nbd.name>
---
 drivers/net/wireless/mediatek/mt76/mac80211.c | 15 +++++++++++++--
 1 file changed, 13 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/mediatek/mt76/mac80211.c b/drivers/net/wireless/mediatek/mt76/mac80211.c
index 4befe7f937a9..4e0ed9c79d50 100644
--- a/drivers/net/wireless/mediatek/mt76/mac80211.c
+++ b/drivers/net/wireless/mediatek/mt76/mac80211.c
@@ -932,7 +932,8 @@ void mt76_rx_complete(struct mt76_dev *dev, struct sk_buff_head *frames,
 {
 	struct ieee80211_sta *sta;
 	struct ieee80211_hw *hw;
-	struct sk_buff *skb;
+	struct sk_buff *skb, *tmp;
+	LIST_HEAD(list);
 
 	spin_lock(&dev->rx_lock);
 	while ((skb = __skb_dequeue(frames)) != NULL) {
@@ -942,9 +943,19 @@ void mt76_rx_complete(struct mt76_dev *dev, struct sk_buff_head *frames,
 		}
 
 		mt76_rx_convert(dev, skb, &hw, &sta);
-		ieee80211_rx_napi(hw, sta, skb, napi);
+		ieee80211_rx_list(hw, sta, skb, &list);
 	}
 	spin_unlock(&dev->rx_lock);
+
+	if (!napi) {
+		netif_receive_skb_list(&list);
+		return;
+	}
+
+	list_for_each_entry_safe(skb, tmp, &list, list) {
+		skb_list_del_init(skb);
+		napi_gro_receive(napi, skb);
+	}
 }
 
 void mt76_rx_poll_complete(struct mt76_dev *dev, enum mt76_rxq_id q,
-- 
2.28.0

