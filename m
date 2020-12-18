Return-Path: <linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 58F6BC3526D
	for <linux-wireless@archiver.kernel.org>; Fri, 18 Dec 2020 17:33:09 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 1099D23B8A
	for <linux-wireless@archiver.kernel.org>; Fri, 18 Dec 2020 17:33:09 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731608AbgLRRcw (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Fri, 18 Dec 2020 12:32:52 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59916 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730410AbgLRRcw (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 18 Dec 2020 12:32:52 -0500
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C8A3AC0617A7;
        Fri, 18 Dec 2020 09:32:11 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=Content-Transfer-Encoding:MIME-Version:
        Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:Content-ID:
        Content-Description:In-Reply-To:References;
        bh=1LDFfQBYh7yjr3C0jWACsjitBa3VClxYhSmNicB3yqg=; b=gLBKl7EMKBaxkw/1xVxrjciOQD
        uxS/T/pelMcAtfsk3lC467nNAOGvfpxFHd/hoMGK534J8zyLjPuZbk43im3aPmSGhQDQ8LFFkIo86
        BOGZuMbGLUzfE6PIhfirAfA0VxFTGgL4BDl7lsHRUdzK6Kbh/1uhH50e0GPhtYnfHU0z5ph+S2ISm
        AKfqvv5ZAtHRB3UnBGUPYNYZctAUPfX3pOMGTiPJvUNmLrdYIxqtASQNDixshPjiD6BNaAJvfT1b4
        SzPtvS20CKm4HdowKFvgmD69g3n3zU5My9I64FahLlSCTVePt3BsBLci/fn81N5A8dni4iACrXyWR
        vkF3zP2Q==;
Received: from [2601:1c0:6280:3f0::64ea] (helo=smtpauth.infradead.org)
        by casper.infradead.org with esmtpsa (Exim 4.92.3 #3 (Red Hat Linux))
        id 1kqJbq-00083i-SW; Fri, 18 Dec 2020 17:32:07 +0000
From:   Randy Dunlap <rdunlap@infradead.org>
To:     linux-kernel@vger.kernel.org
Cc:     Randy Dunlap <rdunlap@infradead.org>,
        Shayne Chen <shayne.chen@mediatek.com>,
        Ryder Lee <ryder.lee@mediatek.com>,
        Lorenzo Bianconi <lorenzo@kernel.org>,
        Felix Fietkau <nbd@nbd.name>, linux-wireless@vger.kernel.org,
        Kalle Valo <kvalo@codeaurora.org>
Subject: [PATCH -next] net: wireless/mediatek/mt7915: fix MESH ifdef block
Date:   Fri, 18 Dec 2020 09:32:02 -0800
Message-Id: <20201218173202.23159-1-rdunlap@infradead.org>
X-Mailer: git-send-email 2.26.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Fix a build error when CONFIG_MAC80211_MESH is not enabled:

../drivers/net/wireless/mediatek/mt76/mt7915/init.c:47:2: error: expected expression before '}' token
  }, {
  ^

Fixes: af901eb4ab80 ("mt76: mt7915: get rid of dbdc debugfs knob")
Signed-off-by: Randy Dunlap <rdunlap@infradead.org>
Cc: Shayne Chen <shayne.chen@mediatek.com>
Cc: Ryder Lee <ryder.lee@mediatek.com>
Cc: Lorenzo Bianconi <lorenzo@kernel.org>
Cc: Felix Fietkau <nbd@nbd.name>
Cc: linux-wireless@vger.kernel.org
Cc: Kalle Valo <kvalo@codeaurora.org>
---
 drivers/net/wireless/mediatek/mt76/mt7915/init.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- linux-next-20201218.orig/drivers/net/wireless/mediatek/mt76/mt7915/init.c
+++ linux-next-20201218/drivers/net/wireless/mediatek/mt76/mt7915/init.c
@@ -40,9 +40,9 @@ static const struct ieee80211_iface_limi
 		.types = BIT(NL80211_IFTYPE_ADHOC)
 	}, {
 		.max = 16,
-		.types = BIT(NL80211_IFTYPE_AP) |
+		.types = BIT(NL80211_IFTYPE_AP)
 #ifdef CONFIG_MAC80211_MESH
-			 BIT(NL80211_IFTYPE_MESH_POINT)
+			 | BIT(NL80211_IFTYPE_MESH_POINT)
 #endif
 	}, {
 		.max = MT7915_MAX_INTERFACES,
