Return-Path: <SRS0=z7UY=PZ=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.8 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 52F73C43387
	for <linux-wireless@archiver.kernel.org>; Thu, 17 Jan 2019 13:51:40 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 1FB4220851
	for <linux-wireless@archiver.kernel.org>; Thu, 17 Jan 2019 13:51:40 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (1024-bit key) header.d=nbd.name header.i=@nbd.name header.b="d+M7AsJp"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727488AbfAQNvj (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Thu, 17 Jan 2019 08:51:39 -0500
Received: from nbd.name ([46.4.11.11]:56462 "EHLO nbd.name"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727012AbfAQNvg (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 17 Jan 2019 08:51:36 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nbd.name;
         s=20160729; h=References:In-Reply-To:Message-Id:Date:Subject:To:From:Sender:
        Reply-To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=+by9Cn62g4q6F02isRhJ0yqn9aBkKbhvHF5l8wv5kAM=; b=d+M7AsJp8i28RyEjW5nR/gt075
        u0tz79hF2mwDxYCclGFiP41qLQu8PgZDECf0AfxJHJnz3aEx2TSoLy4Za2m20ptJpD5jB57Vc01wm
        A05kQCvT1Nwyl+bAnzZo6gni8npzC+M8LVn5NMIFFOR89RdJrbAmwFn1UuIPhnqbcY1g=;
Received: by maeck.lan (Postfix, from userid 501)
        id 3681E4C6F052; Thu, 17 Jan 2019 14:51:33 +0100 (CET)
From:   Felix Fietkau <nbd@nbd.name>
To:     linux-wireless@vger.kernel.org
Subject: [PATCH 2/7] mt76: set IEEE80211_HW_NEEDS_UNIQUE_STA_ADDR flag
Date:   Thu, 17 Jan 2019 14:51:28 +0100
Message-Id: <20190117135133.2753-2-nbd@nbd.name>
X-Mailer: git-send-email 2.17.0
In-Reply-To: <20190117135133.2753-1-nbd@nbd.name>
References: <20190117135133.2753-1-nbd@nbd.name>
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

The hardware does not deal with multiple WCID entries for the same station
properly. Set IEEE80211_HW_NEEDS_UNIQUE_STA_ADDR to avoid those cases

Signed-off-by: Felix Fietkau <nbd@nbd.name>
---
 drivers/net/wireless/mediatek/mt76/mac80211.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/net/wireless/mediatek/mt76/mac80211.c b/drivers/net/wireless/mediatek/mt76/mac80211.c
index 7b926dfa6b97..3d976ac4cb41 100644
--- a/drivers/net/wireless/mediatek/mt76/mac80211.c
+++ b/drivers/net/wireless/mediatek/mt76/mac80211.c
@@ -328,6 +328,7 @@ int mt76_register_device(struct mt76_dev *dev, bool vht,
 	ieee80211_hw_set(hw, MFP_CAPABLE);
 	ieee80211_hw_set(hw, AP_LINK_PS);
 	ieee80211_hw_set(hw, REPORTS_TX_ACK_STATUS);
+	ieee80211_hw_set(hw, NEEDS_UNIQUE_STA_ADDR);
 
 	wiphy->flags |= WIPHY_FLAG_IBSS_RSN;
 
-- 
2.17.0

