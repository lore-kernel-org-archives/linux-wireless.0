Return-Path: <SRS0=p05y=ZW=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.5 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 77F6EC43215
	for <linux-wireless@archiver.kernel.org>; Sat, 30 Nov 2019 15:31:11 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 4FC712072C
	for <linux-wireless@archiver.kernel.org>; Sat, 30 Nov 2019 15:31:11 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (1024-bit key) header.d=nbd.name header.i=@nbd.name header.b="Ek5sDJvZ"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727167AbfK3Pas (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Sat, 30 Nov 2019 10:30:48 -0500
Received: from nbd.name ([46.4.11.11]:56024 "EHLO nbd.name"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726659AbfK3Par (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Sat, 30 Nov 2019 10:30:47 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nbd.name;
         s=20160729; h=Content-Transfer-Encoding:MIME-Version:References:In-Reply-To:
        Message-Id:Date:Subject:To:From:Sender:Reply-To:Cc:Content-Type:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=T90GlHyZd70rOf1PD49/1jJ0GA93k3tqYQjbJrfYu04=; b=Ek5sDJvZ3QlMGKUuoTfYLvD8Pu
        KEaH+I4WQG1G3RNeosPxGILhs7BzhqxSqzUQ7NDagyGSOoTecA2mqfFRizgJA7kfLpahrStGGqk+K
        tuvcl6OdGCKdiQRT4WKngNt8Q3Mek3mBCTBuUm+xYqq+YpUwK1nXATKaNtZLPm6Ip+W0=;
Received: from p5b2067e3.dip0.t-ipconnect.de ([91.32.103.227] helo=maeck.local)
        by ds12 with esmtpsa (TLS1.2:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.89)
        (envelope-from <nbd@nbd.name>)
        id 1ib4hq-0006hC-Gq
        for linux-wireless@vger.kernel.org; Sat, 30 Nov 2019 16:30:46 +0100
Received: by maeck.local (Postfix, from userid 501)
        id 06A72721EBD7; Sat, 30 Nov 2019 16:30:45 +0100 (CET)
From:   Felix Fietkau <nbd@nbd.name>
To:     linux-wireless@vger.kernel.org
Subject: [PATCH 29/29] mt76: mt7615: update beacon contents on BSS_CHANGED_BEACON
Date:   Sat, 30 Nov 2019 16:30:45 +0100
Message-Id: <20191130153045.28105-29-nbd@nbd.name>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <20191130153045.28105-1-nbd@nbd.name>
References: <20191130153045.28105-1-nbd@nbd.name>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Beacon changes need to be sent to the firmware, otherwise it will
keep sending stale data

Signed-off-by: Felix Fietkau <nbd@nbd.name>
---
 drivers/net/wireless/mediatek/mt76/mt7615/main.c | 9 ++++-----
 1 file changed, 4 insertions(+), 5 deletions(-)

diff --git a/drivers/net/wireless/mediatek/mt76/mt7615/main.c b/drivers/net/wireless/mediatek/mt76/mt7615/main.c
index a7e1ab22c81c..ef14779fdbc4 100644
--- a/drivers/net/wireless/mediatek/mt76/mt7615/main.c
+++ b/drivers/net/wireless/mediatek/mt76/mt7615/main.c
@@ -406,17 +406,16 @@ static void mt7615_bss_info_changed(struct ieee80211_hw *hw,
 	if (changed & BSS_CHANGED_ASSOC)
 		mt7615_mcu_set_bss_info(dev, vif, info->assoc);
 
-	/* TODO: update beacon content
-	 * BSS_CHANGED_BEACON
-	 */
-
 	if (changed & BSS_CHANGED_BEACON_ENABLED) {
 		mt7615_mcu_set_bss_info(dev, vif, info->enable_beacon);
 		mt7615_mcu_wtbl_bmc(dev, vif, info->enable_beacon);
 		mt7615_mcu_set_sta_rec_bmc(dev, vif, info->enable_beacon);
-		mt7615_mcu_set_bcn(hw, vif, info->enable_beacon);
 	}
 
+	if (changed & (BSS_CHANGED_BEACON |
+		       BSS_CHANGED_BEACON_ENABLED))
+		mt7615_mcu_set_bcn(hw, vif, info->enable_beacon);
+
 	mutex_unlock(&dev->mt76.mutex);
 }
 
-- 
2.24.0

