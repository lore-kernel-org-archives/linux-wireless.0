Return-Path: <SRS0=F8Dj=QZ=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.8 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E9216C10F01
	for <linux-wireless@archiver.kernel.org>; Mon, 18 Feb 2019 19:42:24 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id B3074217D9
	for <linux-wireless@archiver.kernel.org>; Mon, 18 Feb 2019 19:42:24 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (1024-bit key) header.d=nbd.name header.i=@nbd.name header.b="GuOz0vHU"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726090AbfBRTmV (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Mon, 18 Feb 2019 14:42:21 -0500
Received: from nbd.name ([46.4.11.11]:56646 "EHLO nbd.name"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725535AbfBRTmV (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 18 Feb 2019 14:42:21 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nbd.name;
         s=20160729; h=References:In-Reply-To:Message-Id:Date:Subject:To:From:Sender:
        Reply-To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=Ku1X6UiCgiqBorfNLfiMuj3XpfkLejB0WHXXQqwDMmA=; b=GuOz0vHUTwjBvH3S99LSfv+CMd
        WA5gW3/AYEajBDJFh2eOBf/9buRdKTUqWn2FpPc/80bInywLvghkK5X7F/bHXDZQZDXwJftxgTApL
        sjQ8AF2ppQFaX5/8OHn6H4Au2phqZto4/H2cVd2XkmCr36BTRomcp8RqFGyKKjKZhLSM=;
Received: by maeck.lan (Postfix, from userid 501)
        id 25DA65004554; Mon, 18 Feb 2019 20:42:18 +0100 (CET)
From:   Felix Fietkau <nbd@nbd.name>
To:     linux-wireless@vger.kernel.org
Subject: [PATCH 4/4] mt76: mt76x2: simplify per-chain signal strength handling
Date:   Mon, 18 Feb 2019 20:42:18 +0100
Message-Id: <20190218194218.41314-4-nbd@nbd.name>
X-Mailer: git-send-email 2.17.0
In-Reply-To: <20190218194218.41314-1-nbd@nbd.name>
References: <20190218194218.41314-1-nbd@nbd.name>
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

There is no need to use a for loop here, supported chips can only support
up to 2 chains.

Signed-off-by: Felix Fietkau <nbd@nbd.name>
---
 drivers/net/wireless/mediatek/mt76/mt76x02_mac.c | 15 ++++++++-------
 1 file changed, 8 insertions(+), 7 deletions(-)

diff --git a/drivers/net/wireless/mediatek/mt76/mt76x02_mac.c b/drivers/net/wireless/mediatek/mt76/mt76x02_mac.c
index eab713723b7e..be2979f34f31 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76x02_mac.c
+++ b/drivers/net/wireless/mediatek/mt76/mt76x02_mac.c
@@ -608,7 +608,7 @@ int mt76x02_mac_process_rx(struct mt76x02_dev *dev, struct sk_buff *skb,
 	u16 rate = le16_to_cpu(rxwi->rate);
 	u16 tid_sn = le16_to_cpu(rxwi->tid_sn);
 	bool unicast = rxwi->rxinfo & cpu_to_le32(MT_RXINFO_UNICAST);
-	int i, pad_len = 0, nstreams = dev->mt76.chainmask & 0xf;
+	int pad_len = 0, nstreams = dev->mt76.chainmask & 0xf;
 	s8 signal;
 	u8 pn_len;
 	u8 wcid;
@@ -668,12 +668,13 @@ int mt76x02_mac_process_rx(struct mt76x02_dev *dev, struct sk_buff *skb,
 
 	status->chains = BIT(0);
 	signal = mt76x02_mac_get_rssi(dev, rxwi->rssi[0], 0);
-	for (i = 0; i < nstreams; i++) {
-		status->chains |= BIT(i);
-		status->chain_signal[i] = mt76x02_mac_get_rssi(dev,
-							       rxwi->rssi[i],
-							       i);
-		signal = max_t(s8, signal, status->chain_signal[i]);
+	status->chain_signal[0] = signal;
+	if (nstreams > 1) {
+		status->chains |= BIT(1);
+		status->chain_signal[1] = mt76x02_mac_get_rssi(dev,
+							       rxwi->rssi[1],
+							       1);
+		signal = max_t(s8, signal, status->chain_signal[1]);
 	}
 	status->signal = signal;
 	status->freq = dev->mt76.chandef.chan->center_freq;
-- 
2.17.0

