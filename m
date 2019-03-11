Return-Path: <SRS0=FsXk=RO=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.8 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 58B00C43381
	for <linux-wireless@archiver.kernel.org>; Mon, 11 Mar 2019 13:09:57 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 1ED7620657
	for <linux-wireless@archiver.kernel.org>; Mon, 11 Mar 2019 13:09:57 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (1024-bit key) header.d=nbd.name header.i=@nbd.name header.b="ldRntuZD"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726872AbfCKNJ4 (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Mon, 11 Mar 2019 09:09:56 -0400
Received: from nbd.name ([46.4.11.11]:57714 "EHLO nbd.name"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726605AbfCKNJ4 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 11 Mar 2019 09:09:56 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nbd.name;
         s=20160729; h=Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To:
        MIME-Version:Content-Type:Content-Transfer-Encoding:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:In-Reply-To:References:List-Id:List-Help:List-Unsubscribe:
        List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=Ia20NrSnvIdCqvZU9TwWg6kp6KTw7w8sWgBPnt8g9Jo=; b=ldRntuZDRTXxCBbbKUziGnsHgO
        Dwgj9b8dCDNGD950VLfaM63LBiae5KCYqAGo1CCopZUDg3IAWO+1j3kmPXoK/6lUspx8jmkbtIS1w
        tNayYaxoYdYMG1sOjXoCjGnboB1zivLPA9+qM5DxvT8LE3d8yesSOETSMV69zXQeAqzM=;
Received: by maeck-2.local (Postfix, from userid 501)
        id 2E04451FD629; Mon, 11 Mar 2019 14:09:53 +0100 (CET)
From:   Felix Fietkau <nbd@nbd.name>
To:     linux-wireless@vger.kernel.org
Cc:     kvalo@codeaurora.org
Subject: [PATCH] mt76: mt7603: use the correct hweight8() function
Date:   Mon, 11 Mar 2019 14:09:53 +0100
Message-Id: <20190311130953.61869-1-nbd@nbd.name>
X-Mailer: git-send-email 2.17.0
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

__sw_hweight8() is only defined if CONFIG_GENERIC_HWEIGHT is enabled.
The function that works on all architectures is hweight8().

Signed-off-by: Felix Fietkau <nbd@nbd.name>
---
 drivers/net/wireless/mediatek/mt76/mt7603/beacon.c | 3 +--
 drivers/net/wireless/mediatek/mt76/mt7603/init.c   | 2 +-
 drivers/net/wireless/mediatek/mt76/mt7603/mcu.c    | 2 +-
 3 files changed, 3 insertions(+), 4 deletions(-)

diff --git a/drivers/net/wireless/mediatek/mt76/mt7603/beacon.c b/drivers/net/wireless/mediatek/mt76/mt7603/beacon.c
index afcd86f735b4..4dcb465095d1 100644
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
index 15cc8f33b34d..d54dda67d036 100644
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
index 4b0713f1fd5e..d06905ea8cc6 100644
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
2.17.0

