Return-Path: <linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.6 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C5820C433F5
	for <linux-wireless@archiver.kernel.org>; Wed,  8 Sep 2021 15:58:50 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id A309D61153
	for <linux-wireless@archiver.kernel.org>; Wed,  8 Sep 2021 15:58:50 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235528AbhIHP7z (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Wed, 8 Sep 2021 11:59:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52328 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235639AbhIHP7x (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 8 Sep 2021 11:59:53 -0400
Received: from nbd.name (nbd.name [IPv6:2a01:4f8:221:3d45::2])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C70EAC061575
        for <linux-wireless@vger.kernel.org>; Wed,  8 Sep 2021 08:58:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nbd.name;
         s=20160729; h=Content-Transfer-Encoding:MIME-Version:Message-Id:Date:Subject
        :To:From:Sender:Reply-To:Cc:Content-Type:Content-ID:Content-Description:
        Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:
        In-Reply-To:References:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=bwUJ0mOLIES2TymxULs5+K2zH3KosYkF47cSDVR8Su8=; b=MA3pW4IBVeY71VpaeNFxAaYG8z
        42vFgBx/x8Bw6qHzsKiyKb33XdzUO3bBMpckAXvKP0yZBEK5O3nev7R0R5AqbHG1+KRn4504jsXac
        THBq8RenZslN7EzgKTPNzuGkCIs2Wt8Fhlf9xRKU/masG5PmnexjulNtn3a5DBeGOo4w=;
Received: from p4ff13206.dip0.t-ipconnect.de ([79.241.50.6] helo=localhost.localdomain)
        by ds12 with esmtpsa (TLS1.2:ECDHE_RSA_AES_128_GCM_SHA256:128)
        (Exim 4.89)
        (envelope-from <nbd@nbd.name>)
        id 1mNzyF-0004pm-Kk
        for linux-wireless@vger.kernel.org; Wed, 08 Sep 2021 17:58:43 +0200
From:   Felix Fietkau <nbd@nbd.name>
To:     linux-wireless@vger.kernel.org
Subject: [PATCH] mt76: mt7915: fix WMM index on DBDC cards
Date:   Wed,  8 Sep 2021 17:58:41 +0200
Message-Id: <20210908155841.72052-1-nbd@nbd.name>
X-Mailer: git-send-email 2.30.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

WMM index range needs to be split between both PHYs if a second PHY exists.
The condition for that was accidentally written as checking if the vif PHY
is the secondary one

Signed-off-by: Felix Fietkau <nbd@nbd.name>
---
 drivers/net/wireless/mediatek/mt76/mt7915/main.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/wireless/mediatek/mt76/mt7915/main.c b/drivers/net/wireless/mediatek/mt76/mt7915/main.c
index 748ea70ea12e..a19e68668c65 100644
--- a/drivers/net/wireless/mediatek/mt76/mt7915/main.c
+++ b/drivers/net/wireless/mediatek/mt76/mt7915/main.c
@@ -215,7 +215,7 @@ static int mt7915_add_interface(struct ieee80211_hw *hw,
 	mvif->phy = phy;
 	mvif->band_idx = ext_phy;
 
-	if (ext_phy)
+	if (dev->mt76.phy2)
 		mvif->wmm_idx = ext_phy * (MT7915_MAX_WMM_SETS / 2) +
 				mvif->idx % (MT7915_MAX_WMM_SETS / 2);
 	else
-- 
2.30.1

