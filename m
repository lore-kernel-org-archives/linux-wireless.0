Return-Path: <SRS0=ylPz=CR=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.6 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8A0FBC433E2
	for <linux-wireless@archiver.kernel.org>; Tue,  8 Sep 2020 21:18:21 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 48E6F2080C
	for <linux-wireless@archiver.kernel.org>; Tue,  8 Sep 2020 21:18:21 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (1024-bit key) header.d=nbd.name header.i=@nbd.name header.b="hMHqPrQ9"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730150AbgIHVSS (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Tue, 8 Sep 2020 17:18:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48526 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729037AbgIHVSD (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 8 Sep 2020 17:18:03 -0400
Received: from nbd.name (nbd.name [IPv6:2a01:4f8:221:3d45::2])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A843CC061755
        for <linux-wireless@vger.kernel.org>; Tue,  8 Sep 2020 14:18:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nbd.name;
         s=20160729; h=Content-Transfer-Encoding:MIME-Version:References:In-Reply-To:
        Message-Id:Date:Subject:To:From:Sender:Reply-To:Cc:Content-Type:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=Fkk/NPSQizkeizGh4CR58dOAgw/4mXi/6NL0DFZpVXk=; b=hMHqPrQ9Ch0cQ5MNqf8gbGvFxR
        RdcVHVRA0eQPxoF9gBrz+YiZNZeQq+qwRKUhla8deSCPFr3f641FdLgxxEElrk3OXb/o2nDc2c6SZ
        QuGqJtRkJgho4mqjB2Hk1tTpmdHXIt97olXqwuaDfVgLbsGguZX3FbjS5T1KwO+Qd5NU=;
Received: from p4ff13fcb.dip0.t-ipconnect.de ([79.241.63.203] helo=localhost.localdomain)
        by ds12 with esmtpsa (TLS1.2:ECDHE_RSA_AES_128_CBC_SHA1:128)
        (Exim 4.89)
        (envelope-from <nbd@nbd.name>)
        id 1kFl02-0002Cx-C3
        for linux-wireless@vger.kernel.org; Tue, 08 Sep 2020 23:17:58 +0200
From:   Felix Fietkau <nbd@nbd.name>
To:     linux-wireless@vger.kernel.org
Subject: [PATCH 02/11] mt76: mt7615: fix antenna selection for testmode tx_frames
Date:   Tue,  8 Sep 2020 23:17:47 +0200
Message-Id: <20200908211756.15998-2-nbd@nbd.name>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200908211756.15998-1-nbd@nbd.name>
References: <20200908211756.15998-1-nbd@nbd.name>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Do not alter the tx/rx chain settings during channel setup, antennas are
remapped by the testmode specific register writes already

Signed-off-by: Felix Fietkau <nbd@nbd.name>
---
 drivers/net/wireless/mediatek/mt76/mt7615/mcu.c      | 8 --------
 drivers/net/wireless/mediatek/mt76/mt7615/testmode.c | 2 +-
 2 files changed, 1 insertion(+), 9 deletions(-)

diff --git a/drivers/net/wireless/mediatek/mt76/mt7615/mcu.c b/drivers/net/wireless/mediatek/mt76/mt7615/mcu.c
index 074cdefba8aa..967c0e80a4a8 100644
--- a/drivers/net/wireless/mediatek/mt76/mt7615/mcu.c
+++ b/drivers/net/wireless/mediatek/mt76/mt7615/mcu.c
@@ -2850,14 +2850,6 @@ int mt7615_mcu_set_chan_info(struct mt7615_phy *phy, int cmd)
 		.center_chan2 = ieee80211_frequency_to_channel(freq2),
 	};
 
-#ifdef CONFIG_NL80211_TESTMODE
-	if (dev->mt76.test.state == MT76_TM_STATE_TX_FRAMES &&
-	    dev->mt76.test.tx_antenna_mask) {
-		req.tx_streams = hweight8(dev->mt76.test.tx_antenna_mask);
-		req.rx_streams_mask = dev->mt76.test.tx_antenna_mask;
-	}
-#endif
-
 	if (dev->mt76.hw->conf.flags & IEEE80211_CONF_OFFCHANNEL)
 		req.switch_reason = CH_SWITCH_SCAN_BYPASS_DPD;
 	else if ((chandef->chan->flags & IEEE80211_CHAN_RADAR) &&
diff --git a/drivers/net/wireless/mediatek/mt76/mt7615/testmode.c b/drivers/net/wireless/mediatek/mt76/mt7615/testmode.c
index 2cfa58d49832..1a67c244e96f 100644
--- a/drivers/net/wireless/mediatek/mt76/mt7615/testmode.c
+++ b/drivers/net/wireless/mediatek/mt76/mt7615/testmode.c
@@ -193,7 +193,7 @@ mt7615_tm_set_tx_antenna(struct mt7615_dev *dev, bool en)
 	for (i = 0; i < 4; i++) {
 		mt76_rmw_field(dev, MT_WF_PHY_RFINTF3_0(i),
 			       MT_WF_PHY_RFINTF3_0_ANT,
-			       td->tx_antenna_mask & BIT(i) ? 0 : 0xa);
+			       (td->tx_antenna_mask & BIT(i)) ? 0 : 0xa);
 
 	}
 
-- 
2.28.0

