Return-Path: <linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.6 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5ED2EC433E0
	for <linux-wireless@archiver.kernel.org>; Sat, 13 Feb 2021 17:52:06 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 3216C64E39
	for <linux-wireless@archiver.kernel.org>; Sat, 13 Feb 2021 17:52:06 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229733AbhBMRwD (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Sat, 13 Feb 2021 12:52:03 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49280 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229574AbhBMRwB (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Sat, 13 Feb 2021 12:52:01 -0500
Received: from nbd.name (nbd.name [IPv6:2a01:4f8:221:3d45::2])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CC9D8C061786
        for <linux-wireless@vger.kernel.org>; Sat, 13 Feb 2021 09:51:05 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nbd.name;
         s=20160729; h=Content-Transfer-Encoding:MIME-Version:References:In-Reply-To:
        Message-Id:Date:Subject:To:From:Sender:Reply-To:Cc:Content-Type:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=QUhoPA7+TgwhBubF7bN4/hSu/rcVbYa8JakcE61iayg=; b=ou/ynXk0FhTu7bXzOZK5a41dIS
        wUkqgvSDaxBb6m2lIaBuhnInqg10yB57esHZcxw6CxW8j9jiTBNq6O2IO/3dVusA1vw7mvsDeaEZK
        riSE1rNgsNox4chx+TcfPUOMZthQYt8kPPmkTb8BbhhUwgEd88yHzIr0cEWcGxXeq31M=;
Received: from p4ff13c8d.dip0.t-ipconnect.de ([79.241.60.141] helo=localhost.localdomain)
        by ds12 with esmtpsa (TLS1.2:ECDHE_RSA_AES_128_CBC_SHA1:128)
        (Exim 4.89)
        (envelope-from <nbd@nbd.name>)
        id 1lAz4Q-0007si-Cy
        for linux-wireless@vger.kernel.org; Sat, 13 Feb 2021 18:51:02 +0100
From:   Felix Fietkau <nbd@nbd.name>
To:     linux-wireless@vger.kernel.org
Subject: [PATCH 3/7] mt76: mt7915: add rx checksum offload support
Date:   Sat, 13 Feb 2021 18:50:56 +0100
Message-Id: <20210213175100.22608-3-nbd@nbd.name>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20210213175100.22608-1-nbd@nbd.name>
References: <20210213175100.22608-1-nbd@nbd.name>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Set skb->ip_summed to CHECKSUM_UNNECESSARY if the hardware has validated
the IP and TCP/UDP checksum

Signed-off-by: Felix Fietkau <nbd@nbd.name>
---
 drivers/net/wireless/mediatek/mt76/mt7915/init.c | 1 +
 drivers/net/wireless/mediatek/mt76/mt7915/mac.c  | 5 +++++
 2 files changed, 6 insertions(+)

diff --git a/drivers/net/wireless/mediatek/mt76/mt7915/init.c b/drivers/net/wireless/mediatek/mt76/mt7915/init.c
index 76dfcb76fb03..34a4fee24c48 100644
--- a/drivers/net/wireless/mediatek/mt76/mt7915/init.c
+++ b/drivers/net/wireless/mediatek/mt76/mt7915/init.c
@@ -93,6 +93,7 @@ mt7915_init_wiphy(struct ieee80211_hw *hw)
 	hw->queues = 4;
 	hw->max_rx_aggregation_subframes = IEEE80211_MAX_AMPDU_BUF;
 	hw->max_tx_aggregation_subframes = IEEE80211_MAX_AMPDU_BUF;
+	hw->netdev_features = NETIF_F_RXCSUM;
 
 	phy->slottime = 9;
 
diff --git a/drivers/net/wireless/mediatek/mt76/mt7915/mac.c b/drivers/net/wireless/mediatek/mt76/mt7915/mac.c
index 2f96f31e33c9..22d4f16cf830 100644
--- a/drivers/net/wireless/mediatek/mt76/mt7915/mac.c
+++ b/drivers/net/wireless/mediatek/mt76/mt7915/mac.c
@@ -317,10 +317,12 @@ int mt7915_mac_fill_rx(struct mt7915_dev *dev, struct sk_buff *skb)
 	__le32 *rxd = (__le32 *)skb->data;
 	__le32 *rxv = NULL;
 	u32 mode = 0;
+	u32 rxd0 = le32_to_cpu(rxd[0]);
 	u32 rxd1 = le32_to_cpu(rxd[1]);
 	u32 rxd2 = le32_to_cpu(rxd[2]);
 	u32 rxd3 = le32_to_cpu(rxd[3]);
 	u32 rxd4 = le32_to_cpu(rxd[4]);
+	u32 csum_mask = MT_RXD0_NORMAL_IP_SUM | MT_RXD0_NORMAL_UDP_TCP_SUM;
 	bool unicast, insert_ccmp_hdr = false;
 	u8 remove_pad, amsdu_info;
 	int i, idx;
@@ -366,6 +368,9 @@ int mt7915_mac_fill_rx(struct mt7915_dev *dev, struct sk_buff *skb)
 	if (!sband->channels)
 		return -EINVAL;
 
+	if ((rxd0 & csum_mask) == csum_mask)
+		skb->ip_summed = CHECKSUM_UNNECESSARY;
+
 	if (rxd1 & MT_RXD1_NORMAL_FCS_ERR)
 		status->flag |= RX_FLAG_FAILED_FCS_CRC;
 
-- 
2.28.0

