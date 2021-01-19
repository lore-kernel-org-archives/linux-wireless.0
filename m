Return-Path: <linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.6 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B5EAAC433E9
	for <linux-wireless@archiver.kernel.org>; Tue, 19 Jan 2021 18:28:41 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 8D5AA23104
	for <linux-wireless@archiver.kernel.org>; Tue, 19 Jan 2021 18:28:41 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390705AbhASQvB (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Tue, 19 Jan 2021 11:51:01 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54760 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2390349AbhASQu0 (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 19 Jan 2021 11:50:26 -0500
Received: from nbd.name (nbd.name [IPv6:2a01:4f8:221:3d45::2])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DB873C061574
        for <linux-wireless@vger.kernel.org>; Tue, 19 Jan 2021 08:49:45 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nbd.name;
         s=20160729; h=Content-Transfer-Encoding:MIME-Version:References:In-Reply-To:
        Message-Id:Date:Subject:To:From:Sender:Reply-To:Cc:Content-Type:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=ahmWnZAwkyvoeStbN40m0VVoSNcmj9YGbKfkZkaYnOA=; b=eRxHhKkyXYu7JB+tnNjJvBUAJc
        BCE3nckjlShpFgC/0HnTd2K4rdXG+FR//WB2emBJHACNPSmTHE/XEHh/QxCsgHWXrrDTvMdcq3mGn
        P2eFW6kQgjdj0BJ0R8qVclwvj18R4bgHU9tcRIZh/R7UkzP3eMnYKGawShnmhSYyMv74=;
Received: from p54ae91f2.dip0.t-ipconnect.de ([84.174.145.242] helo=localhost.localdomain)
        by ds12 with esmtpsa (TLS1.2:ECDHE_RSA_AES_128_CBC_SHA1:128)
        (Exim 4.89)
        (envelope-from <nbd@nbd.name>)
        id 1l1uCO-0004Hf-CJ
        for linux-wireless@vger.kernel.org; Tue, 19 Jan 2021 17:49:44 +0100
From:   Felix Fietkau <nbd@nbd.name>
To:     linux-wireless@vger.kernel.org
Subject: [PATCH 2/3] mt76: mt7915: fix vif sta index for DBDC
Date:   Tue, 19 Jan 2021 17:49:42 +0100
Message-Id: <20210119164943.99223-2-nbd@nbd.name>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20210119164943.99223-1-nbd@nbd.name>
References: <20210119164943.99223-1-nbd@nbd.name>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Since vif indexes are per-phy, we need to factor in the phy index to avoid
collisions on the WTBL index

Signed-off-by: Felix Fietkau <nbd@nbd.name>
---
 drivers/net/wireless/mediatek/mt76/mt7915/main.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/net/wireless/mediatek/mt76/mt7915/main.c b/drivers/net/wireless/mediatek/mt76/mt7915/main.c
index 8b8d0d2d532b..cbd9892f5bf9 100644
--- a/drivers/net/wireless/mediatek/mt76/mt7915/main.c
+++ b/drivers/net/wireless/mediatek/mt76/mt7915/main.c
@@ -189,7 +189,8 @@ static int mt7915_add_interface(struct ieee80211_hw *hw,
 	phy->mt76->vif_mask |= BIT(mvif->idx);
 	phy->omac_mask |= BIT_ULL(mvif->omac_idx);
 
-	idx = MT7915_WTBL_RESERVED - mvif->idx;
+	idx = MT7915_WTBL_RESERVED - mvif->idx -
+	      ext_phy * MT7915_MAX_INTERFACES / 2;
 
 	INIT_LIST_HEAD(&mvif->sta.rc_list);
 	INIT_LIST_HEAD(&mvif->sta.stats_list);
-- 
2.28.0

