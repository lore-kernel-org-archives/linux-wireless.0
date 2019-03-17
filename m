Return-Path: <SRS0=pME5=RU=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS,USER_AGENT_GIT autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 95FEDC10F03
	for <linux-wireless@archiver.kernel.org>; Sun, 17 Mar 2019 02:34:18 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 68DA7218AC
	for <linux-wireless@archiver.kernel.org>; Sun, 17 Mar 2019 02:34:18 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=nifty.com header.i=@nifty.com header.b="qDf3+KQ2"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726971AbfCQCeP (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Sat, 16 Mar 2019 22:34:15 -0400
Received: from conuserg-07.nifty.com ([210.131.2.74]:54905 "EHLO
        conuserg-07.nifty.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726776AbfCQCeP (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Sat, 16 Mar 2019 22:34:15 -0400
Received: from grover.tkatk1.zaq.ne.jp (zaqdadce369.zaq.ne.jp [218.220.227.105]) (authenticated)
        by conuserg-07.nifty.com with ESMTP id x2H2Wbvd003170;
        Sun, 17 Mar 2019 11:32:37 +0900
DKIM-Filter: OpenDKIM Filter v2.10.3 conuserg-07.nifty.com x2H2Wbvd003170
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nifty.com;
        s=dec2015msa; t=1552789958;
        bh=BVT1LleI9pYQfZ1bdDjM0clFuEOHrUZYy7AWi1Gqi9E=;
        h=From:To:Cc:Subject:Date:From;
        b=qDf3+KQ2muF+v8sbh/OetE80s1sr8w76QJ8tVSO6BwLEtQTnXfvZd5FrDlLRokLNU
         b88ZG6zeUwPVs0CcNd0/EsmCL8zGriKA5loE/4mo7HAedzLRWaFIf8DwX255mkVjxF
         zeTxcNRelLixufYC+WUj4miRlTVZ8vQqW0XOvw5BHvrLceZrN4wKvTkRGunjqzlZia
         +1UKwNd5euy2las69iI80EKYxVfbTlqezGpjMRU2gIf02BxhaRkEjYE7HJPrRE2JS1
         iBy0nC6tHAF4b2c3LKxdSB1aBTdUqGELo+rRYzZV5GK532auczky4VhVIMmYNs+yvQ
         kyfZioOTppJWA==
X-Nifty-SrcIP: [218.220.227.105]
From:   Masahiro Yamada <yamada.masahiro@socionext.com>
To:     Felix Fietkau <nbd@nbd.name>, linux-wireless@vger.kernel.org
Cc:     Ben Hutchings <ben@decadent.org.uk>,
        Kalle Valo <kvalo@codeaurora.org>,
        Masahiro Yamada <yamada.masahiro@socionext.com>,
        "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Lorenzo Bianconi <lorenzo.bianconi83@gmail.com>,
        linux-mediatek@lists.infradead.org,
        linux-arm-kernel@lists.infradead.org,
        Matthias Brugger <matthias.bgg@gmail.com>
Subject: [PATCH] mt76: Use the correct hweight8() function again
Date:   Sun, 17 Mar 2019 11:32:28 +0900
Message-Id: <1552789948-31564-1-git-send-email-yamada.masahiro@socionext.com>
X-Mailer: git-send-email 2.7.4
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Commit d0ff23c1107e ("mt76: Use the correct hweight8() function")
fixed the wrong use of __sw_hweight8().

Just a week later, commit c8846e101502 ("mt76: add driver for MT7603E
and MT7628/7688") was applid, introducing __sw_hweight8() again.

Fixes: c8846e101502 ("mt76: add driver for MT7603E and MT7628/7688")
Signed-off-by: Masahiro Yamada <yamada.masahiro@socionext.com>
---

 drivers/net/wireless/mediatek/mt76/mt7603/beacon.c | 3 +--
 drivers/net/wireless/mediatek/mt76/mt7603/init.c   | 2 +-
 drivers/net/wireless/mediatek/mt76/mt7603/mcu.c    | 2 +-
 3 files changed, 3 insertions(+), 4 deletions(-)

diff --git a/drivers/net/wireless/mediatek/mt76/mt7603/beacon.c b/drivers/net/wireless/mediatek/mt76/mt7603/beacon.c
index afcd86f..4dcb465 100644
--- a/drivers/net/wireless/mediatek/mt76/mt7603/beacon.c
+++ b/drivers/net/wireless/mediatek/mt76/mt7603/beacon.c
@@ -135,8 +135,7 @@ void mt7603_pre_tbtt_tasklet(unsigned long arg)
 
 out:
 	mt76_queue_tx_cleanup(dev, MT_TXQ_BEACON, false);
-	if (dev->mt76.q_tx[MT_TXQ_BEACON].queued >
-	    __sw_hweight8(dev->beacon_mask))
+	if (dev->mt76.q_tx[MT_TXQ_BEACON].queued > hweight8(dev->beacon_mask))
 		dev->beacon_check++;
 }
 
diff --git a/drivers/net/wireless/mediatek/mt76/mt7603/init.c b/drivers/net/wireless/mediatek/mt76/mt7603/init.c
index 15cc8f3..d54dda6 100644
--- a/drivers/net/wireless/mediatek/mt76/mt7603/init.c
+++ b/drivers/net/wireless/mediatek/mt76/mt7603/init.c
@@ -112,7 +112,7 @@ static void
 mt7603_phy_init(struct mt7603_dev *dev)
 {
 	int rx_chains = dev->mt76.antenna_mask;
-	int tx_chains = __sw_hweight8(rx_chains) - 1;
+	int tx_chains = hweight8(rx_chains) - 1;
 
 	mt76_rmw(dev, MT_WF_RMAC_RMCR,
 		 (MT_WF_RMAC_RMCR_SMPS_MODE |
diff --git a/drivers/net/wireless/mediatek/mt76/mt7603/mcu.c b/drivers/net/wireless/mediatek/mt76/mt7603/mcu.c
index 4b0713f..d06905e 100644
--- a/drivers/net/wireless/mediatek/mt76/mt7603/mcu.c
+++ b/drivers/net/wireless/mediatek/mt76/mt7603/mcu.c
@@ -433,7 +433,7 @@ int mt7603_mcu_set_channel(struct mt7603_dev *dev)
 {
 	struct cfg80211_chan_def *chandef = &dev->mt76.chandef;
 	struct ieee80211_hw *hw = mt76_hw(dev);
-	int n_chains = __sw_hweight8(dev->mt76.antenna_mask);
+	int n_chains = hweight8(dev->mt76.antenna_mask);
 	struct {
 		u8 control_chan;
 		u8 center_chan;
-- 
2.7.4

