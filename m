Return-Path: <SRS0=BviI=RB=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.8 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 00AEDC43381
	for <linux-wireless@archiver.kernel.org>; Tue, 26 Feb 2019 09:29:53 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id B8C262147C
	for <linux-wireless@archiver.kernel.org>; Tue, 26 Feb 2019 09:29:52 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (1024-bit key) header.d=nbd.name header.i=@nbd.name header.b="rBZ283ZE"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727674AbfBZJ3w (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Tue, 26 Feb 2019 04:29:52 -0500
Received: from nbd.name ([46.4.11.11]:60904 "EHLO nbd.name"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727612AbfBZJ3s (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 26 Feb 2019 04:29:48 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nbd.name;
         s=20160729; h=References:In-Reply-To:Message-Id:Date:Subject:To:From:Sender:
        Reply-To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=jUsVYUNqoG4TOtOTXJBPf1/9j/FrHynu4uQ/3+cmfvQ=; b=rBZ283ZEIyI01y4RRCvni5uNfu
        g1cRgp7V5+UrksXgIPAgWFi1RQfVfeCkwqTjrZ1DwCnJFXJcNghEldYlf3cL5/pymEKV2NpqerIfc
        j+muqKqBFk6tDeaEYRA0TR9mXPhOWNVVgEvhki2PtUpYBSd45cNEqa47dJA+q4t1zKeQ=;
Received: by maeck.lan (Postfix, from userid 501)
        id BE8045047CFA; Tue, 26 Feb 2019 10:29:45 +0100 (CET)
From:   Felix Fietkau <nbd@nbd.name>
To:     linux-wireless@vger.kernel.org
Subject: [PATCH 4/8] mt76: mt76x02: only reset beacon drift counter when enabling beacons
Date:   Tue, 26 Feb 2019 10:29:41 +0100
Message-Id: <20190226092945.54738-4-nbd@nbd.name>
X-Mailer: git-send-email 2.17.0
In-Reply-To: <20190226092945.54738-1-nbd@nbd.name>
References: <20190226092945.54738-1-nbd@nbd.name>
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

When the timer is already running, there is no need to reset the counter,
because the drift will remain the same.

Signed-off-by: Felix Fietkau <nbd@nbd.name>
---
 drivers/net/wireless/mediatek/mt76/mt76x02_mac.c  | 3 +++
 drivers/net/wireless/mediatek/mt76/mt76x02_util.c | 1 -
 2 files changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/net/wireless/mediatek/mt76/mt76x02_mac.c b/drivers/net/wireless/mediatek/mt76/mt76x02_mac.c
index be2979f34f31..82b178fa83bb 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76x02_mac.c
+++ b/drivers/net/wireless/mediatek/mt76/mt76x02_mac.c
@@ -1126,6 +1126,9 @@ void mt76x02_mac_set_beacon_enable(struct mt76x02_dev *dev,
 	else if (val)
 		skb = ieee80211_beacon_get(mt76_hw(dev), vif);
 
+	if (!dev->beacon_mask)
+		dev->tbtt_count = 0;
+
 	__mt76x02_mac_set_beacon_enable(dev, vif_idx, val, skb);
 
 	if (mt76_is_mmio(dev))
diff --git a/drivers/net/wireless/mediatek/mt76/mt76x02_util.c b/drivers/net/wireless/mediatek/mt76/mt76x02_util.c
index 2e899d30e00d..a48c261b0c63 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76x02_util.c
+++ b/drivers/net/wireless/mediatek/mt76/mt76x02_util.c
@@ -713,7 +713,6 @@ void mt76x02_bss_info_changed(struct ieee80211_hw *hw,
 			       MT_BEACON_TIME_CFG_INTVAL,
 			       info->beacon_int << 4);
 		dev->beacon_int = info->beacon_int;
-		dev->tbtt_count = 0;
 	}
 
 	if (changed & BSS_CHANGED_BEACON_ENABLED)
-- 
2.17.0

