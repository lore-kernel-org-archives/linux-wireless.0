Return-Path: <linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.6 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0F94FC4332E
	for <linux-wireless@archiver.kernel.org>; Tue, 19 Jan 2021 18:28:42 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id D997322CAD
	for <linux-wireless@archiver.kernel.org>; Tue, 19 Jan 2021 18:28:41 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390913AbhASQvi (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Tue, 19 Jan 2021 11:51:38 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54762 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731297AbhASQul (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 19 Jan 2021 11:50:41 -0500
Received: from nbd.name (nbd.name [IPv6:2a01:4f8:221:3d45::2])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DBEB8C061575
        for <linux-wireless@vger.kernel.org>; Tue, 19 Jan 2021 08:49:45 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nbd.name;
         s=20160729; h=Content-Transfer-Encoding:MIME-Version:Message-Id:Date:Subject
        :To:From:Sender:Reply-To:Cc:Content-Type:Content-ID:Content-Description:
        Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:
        In-Reply-To:References:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=6w7headccSB59swvRpobgD0yFcr++Rbit3mShGL0LWw=; b=b3P7BqIRuJ5xBHb2u7c1VRlGbo
        FEn/tod027uFIkQXj/VHpVparCHpkRTjHurv1jhJ9vdAsBUXZ/WxUzbwcLE90wjgC8pqrMztwd1T1
        3Nuby7jRZSg2fMbzRBBb6nBI/9N5G8mVXO4hCYmpzJ3TzA0a325CQANblSACT8SekZhk=;
Received: from p54ae91f2.dip0.t-ipconnect.de ([84.174.145.242] helo=localhost.localdomain)
        by ds12 with esmtpsa (TLS1.2:ECDHE_RSA_AES_128_CBC_SHA1:128)
        (Exim 4.89)
        (envelope-from <nbd@nbd.name>)
        id 1l1uCO-0004Hf-6R
        for linux-wireless@vger.kernel.org; Tue, 19 Jan 2021 17:49:44 +0100
From:   Felix Fietkau <nbd@nbd.name>
To:     linux-wireless@vger.kernel.org
Subject: [PATCH 1/3] mt76: fix crash on tearing down ext phy
Date:   Tue, 19 Jan 2021 17:49:41 +0100
Message-Id: <20210119164943.99223-1-nbd@nbd.name>
X-Mailer: git-send-email 2.28.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Only clear dev->phy2 after the phy is gone, the driver may still need to access
it until shutdown is complete

Signed-off-by: Felix Fietkau <nbd@nbd.name>
---
 drivers/net/wireless/mediatek/mt76/mac80211.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/wireless/mediatek/mt76/mac80211.c b/drivers/net/wireless/mediatek/mt76/mac80211.c
index f2714436883b..696d00d1976c 100644
--- a/drivers/net/wireless/mediatek/mt76/mac80211.c
+++ b/drivers/net/wireless/mediatek/mt76/mac80211.c
@@ -387,9 +387,9 @@ void mt76_unregister_phy(struct mt76_phy *phy)
 {
 	struct mt76_dev *dev = phy->dev;
 
-	dev->phy2 = NULL;
 	mt76_tx_status_check(dev, NULL, true);
 	ieee80211_unregister_hw(phy->hw);
+	dev->phy2 = NULL;
 }
 EXPORT_SYMBOL_GPL(mt76_unregister_phy);
 
-- 
2.28.0

