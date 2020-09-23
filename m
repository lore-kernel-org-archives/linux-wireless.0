Return-Path: <SRS0=J1VL=DA=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.6 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 55B43C4363D
	for <linux-wireless@archiver.kernel.org>; Wed, 23 Sep 2020 05:25:28 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id D338021D43
	for <linux-wireless@archiver.kernel.org>; Wed, 23 Sep 2020 05:25:27 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (1024-bit key) header.d=nbd.name header.i=@nbd.name header.b="Xt1Ex9uG"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726882AbgIWFYq (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Wed, 23 Sep 2020 01:24:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34414 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726834AbgIWFYq (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 23 Sep 2020 01:24:46 -0400
Received: from nbd.name (nbd.name [IPv6:2a01:4f8:221:3d45::2])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 89EDCC061755
        for <linux-wireless@vger.kernel.org>; Tue, 22 Sep 2020 22:24:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nbd.name;
         s=20160729; h=Content-Transfer-Encoding:MIME-Version:Message-Id:Date:Subject
        :Cc:To:From:Sender:Reply-To:Content-Type:Content-ID:Content-Description:
        Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:
        In-Reply-To:References:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=eZQndTKmWa1+HW0hulSBu7t3uE7Q/NqfAYN9ighJEPI=; b=Xt1Ex9uGlFEnI8CS4OJUPzE/FR
        ElV0pjUl7zGjrvjPsG1HK10Y5qm+qFg24kLv8sTzaLkbIKlvxQVS2Xe1lEGjb0/JoQOjcMnafU8DA
        JeEPl9OQh3iMzsEW7JfsIglNZLMe30k8Ul+Jo7LNx2xhj9nHfAbp52L3yUeCfluKOyAQ=;
Received: from [80.255.7.109] (helo=localhost.localdomain)
        by ds12 with esmtpsa (TLS1.2:ECDHE_RSA_AES_128_CBC_SHA1:128)
        (Exim 4.89)
        (envelope-from <nbd@nbd.name>)
        id 1kKxGl-0006Zz-NV; Wed, 23 Sep 2020 07:24:43 +0200
From:   Felix Fietkau <nbd@nbd.name>
To:     linux-wireless@vger.kernel.org
Cc:     kvalo@codeaurora.org
Subject: [PATCH 5.9] mt76: mt7615: reduce maximum VHT MPDU length to 7991
Date:   Wed, 23 Sep 2020 07:24:42 +0200
Message-Id: <20200923052442.24141-1-nbd@nbd.name>
X-Mailer: git-send-email 2.28.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

After fixing mac80211 to allow larger A-MSDUs in some cases, there have been
reports of performance regressions and packet loss with some clients.
It appears that the issue occurs when the hardware is transmitting A-MSDUs
bigger than 8k. Limit the local VHT MPDU size capability to 7991, matching
the value used for MT7915 as well.

Signed-off-by: Felix Fietkau <nbd@nbd.name>
---
 drivers/net/wireless/mediatek/mt76/mt7615/init.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/wireless/mediatek/mt76/mt7615/init.c b/drivers/net/wireless/mediatek/mt76/mt7615/init.c
index 2a4db46727fb..e194259c84e9 100644
--- a/drivers/net/wireless/mediatek/mt76/mt7615/init.c
+++ b/drivers/net/wireless/mediatek/mt76/mt7615/init.c
@@ -481,7 +481,7 @@ void mt7615_init_device(struct mt7615_dev *dev)
 	dev->mphy.sband_2g.sband.ht_cap.cap |= IEEE80211_HT_CAP_LDPC_CODING;
 	dev->mphy.sband_5g.sband.ht_cap.cap |= IEEE80211_HT_CAP_LDPC_CODING;
 	dev->mphy.sband_5g.sband.vht_cap.cap |=
-			IEEE80211_VHT_CAP_MAX_MPDU_LENGTH_11454 |
+			IEEE80211_VHT_CAP_MAX_MPDU_LENGTH_7991 |
 			IEEE80211_VHT_CAP_MAX_A_MPDU_LENGTH_EXPONENT_MASK;
 	mt7615_cap_dbdc_disable(dev);
 	dev->phy.dfs_state = -1;
-- 
2.28.0

