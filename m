Return-Path: <SRS0=gYL7=SO=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.8 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 20693C10F14
	for <linux-wireless@archiver.kernel.org>; Fri, 12 Apr 2019 13:20:16 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id D290E2054F
	for <linux-wireless@archiver.kernel.org>; Fri, 12 Apr 2019 13:20:15 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (1024-bit key) header.d=nbd.name header.i=@nbd.name header.b="Gkl32ajI"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726829AbfDLNUP (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Fri, 12 Apr 2019 09:20:15 -0400
Received: from nbd.name ([46.4.11.11]:40044 "EHLO nbd.name"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726702AbfDLNUN (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 12 Apr 2019 09:20:13 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nbd.name;
         s=20160729; h=Message-Id:Date:Subject:To:From:Sender:Reply-To:Cc:
        MIME-Version:Content-Type:Content-Transfer-Encoding:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:In-Reply-To:References:List-Id:List-Help:List-Unsubscribe:
        List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=xS+P98BHyUcVaqmRsVYy/3JAxlZR9oPcSrl7zz6VYCE=; b=Gkl32ajIY2B4US2l6AM4M1pvYo
        EIghZ7ETc7VcVbzW1j4XRaRx78wtLwfpdn7d63U8ELL9Wh1Q7U5KRHK2fnutSFJzFXedMtvTRdxqb
        qsnSGdhgEjjysAoR1zwHjfU9Ps3Beyht7Yd4nnAbDXgv709GcCAEXcfK2R7AhX9xOSXs=;
Received: from p4ff13bac.dip0.t-ipconnect.de ([79.241.59.172] helo=maeck-2.local)
        by ds12 with esmtpsa (TLS1.2:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.89)
        (envelope-from <nbd@nbd.name>)
        id 1hEw6F-0002au-Eo
        for linux-wireless@vger.kernel.org; Fri, 12 Apr 2019 15:20:11 +0200
Received: by maeck-2.local (Postfix, from userid 501)
        id 90ED558438FA; Fri, 12 Apr 2019 15:20:10 +0200 (CEST)
From:   Felix Fietkau <nbd@nbd.name>
To:     linux-wireless@vger.kernel.org
Subject: [PATCH] mt76: fix tx power issues
Date:   Fri, 12 Apr 2019 15:20:10 +0200
Message-Id: <20190412132010.68993-1-nbd@nbd.name>
X-Mailer: git-send-email 2.17.0
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

- tx power is stored in the channels after ieee80211_register_hw, so
  chan->orig_mpwr needs to be updated as well
- for non-TSSI devices, mt76x2e needs to use a different target power value
  from the EEPROM
- fix a rounding error in a few places (need to round up, not down)

Signed-off-by: Felix Fietkau <nbd@nbd.name>
---
 drivers/net/wireless/mediatek/mt76/mac80211.c    |  2 +-
 drivers/net/wireless/mediatek/mt76/mt7603/init.c |  1 +
 drivers/net/wireless/mediatek/mt76/mt76x0/init.c |  1 +
 drivers/net/wireless/mediatek/mt76/mt76x2/init.c | 12 +++---------
 drivers/net/wireless/mediatek/mt76/mt76x2/phy.c  |  6 +++---
 5 files changed, 9 insertions(+), 13 deletions(-)

diff --git a/drivers/net/wireless/mediatek/mt76/mac80211.c b/drivers/net/wireless/mediatek/mt76/mac80211.c
index f0d418b751ad..4b63d061c2a0 100644
--- a/drivers/net/wireless/mediatek/mt76/mac80211.c
+++ b/drivers/net/wireless/mediatek/mt76/mac80211.c
@@ -745,7 +745,7 @@ int mt76_get_txpower(struct ieee80211_hw *hw, struct ieee80211_vif *vif,
 	struct mt76_dev *dev = hw->priv;
 	int n_chains = hweight8(dev->antenna_mask);
 
-	*dbm = dev->txpower_cur / 2;
+	*dbm = DIV_ROUND_UP(dev->txpower_cur, 2);
 
 	/* convert from per-chain power to combined
 	 * output on 2x2 devices
diff --git a/drivers/net/wireless/mediatek/mt76/mt7603/init.c b/drivers/net/wireless/mediatek/mt76/mt7603/init.c
index a84b239887ca..569c61b9b5ae 100644
--- a/drivers/net/wireless/mediatek/mt76/mt7603/init.c
+++ b/drivers/net/wireless/mediatek/mt76/mt7603/init.c
@@ -488,6 +488,7 @@ mt7603_init_txpower(struct mt7603_dev *dev,
 	for (i = 0; i < sband->n_channels; i++) {
 		chan = &sband->channels[i];
 		chan->max_power = target_power;
+		chan->orig_mpwr = target_power;
 	}
 }
 
diff --git a/drivers/net/wireless/mediatek/mt76/mt76x0/init.c b/drivers/net/wireless/mediatek/mt76/mt76x0/init.c
index e5f4ce3b595b..57e46d57b449 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76x0/init.c
+++ b/drivers/net/wireless/mediatek/mt76/mt76x0/init.c
@@ -280,6 +280,7 @@ mt76x0_init_txpower(struct mt76x02_dev *dev,
 		mt76x0_get_power_info(dev, chan, &tp);
 
 		chan->max_power = (mt76x02_get_max_rate_power(&t) + tp) / 2;
+		chan->orig_mpwr = chan->max_power;
 	}
 }
 
diff --git a/drivers/net/wireless/mediatek/mt76/mt76x2/init.c b/drivers/net/wireless/mediatek/mt76/mt76x2/init.c
index a30ef2c5a9db..c6078e90ca43 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76x2/init.c
+++ b/drivers/net/wireless/mediatek/mt76/mt76x2/init.c
@@ -165,27 +165,21 @@ void mt76x2_init_txpower(struct mt76x02_dev *dev,
 	struct ieee80211_channel *chan;
 	struct mt76x2_tx_power_info txp;
 	struct mt76_rate_power t = {};
-	int target_power;
 	int i;
 
 	for (i = 0; i < sband->n_channels; i++) {
 		chan = &sband->channels[i];
 
 		mt76x2_get_power_info(dev, &txp, chan);
-
-		target_power = max_t(int, (txp.chain[0].target_power +
-					   txp.chain[0].delta),
-					  (txp.chain[1].target_power +
-					   txp.chain[1].delta));
-
 		mt76x2_get_rate_power(dev, &t, chan);
 
 		chan->max_power = mt76x02_get_max_rate_power(&t) +
-				  target_power;
-		chan->max_power /= 2;
+				  txp.target_power;
+		chan->max_power = DIV_ROUND_UP(chan->max_power, 2);
 
 		/* convert to combined output power on 2x2 devices */
 		chan->max_power += 3;
+		chan->orig_mpwr = chan->max_power;
 	}
 }
 EXPORT_SYMBOL_GPL(mt76x2_init_txpower);
diff --git a/drivers/net/wireless/mediatek/mt76/mt76x2/phy.c b/drivers/net/wireless/mediatek/mt76/mt76x2/phy.c
index 769a9b972044..cdedf95ca4f5 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76x2/phy.c
+++ b/drivers/net/wireless/mediatek/mt76/mt76x2/phy.c
@@ -161,12 +161,12 @@ void mt76x2_phy_set_txpower(struct mt76x02_dev *dev)
 		delta = txp.delta_bw80;
 
 	mt76x2_get_rate_power(dev, &t, chan);
-	mt76x02_add_rate_power_offset(&t, txp.chain[0].target_power);
+	mt76x02_add_rate_power_offset(&t, txp.target_power + delta);
 	mt76x02_limit_rate_power(&t, dev->mt76.txpower_conf);
 	dev->mt76.txpower_cur = mt76x02_get_max_rate_power(&t);
 
 	base_power = mt76x2_get_min_rate_power(&t);
-	delta += base_power - txp.chain[0].target_power;
+	delta = base_power - txp.target_power;
 	txp_0 = txp.chain[0].target_power + txp.chain[0].delta + delta;
 	txp_1 = txp.chain[1].target_power + txp.chain[1].delta + delta;
 
@@ -182,7 +182,7 @@ void mt76x2_phy_set_txpower(struct mt76x02_dev *dev)
 	}
 
 	mt76x02_add_rate_power_offset(&t, -base_power);
-	dev->target_power = txp.chain[0].target_power;
+	dev->target_power = txp.target_power;
 	dev->target_power_delta[0] = txp_0 - txp.chain[0].target_power;
 	dev->target_power_delta[1] = txp_1 - txp.chain[0].target_power;
 	dev->mt76.rate_power = t;
-- 
2.17.0

