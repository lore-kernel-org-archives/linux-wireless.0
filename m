Return-Path: <SRS0=oGbZ=WT=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3C152C3A5A2
	for <linux-wireless@archiver.kernel.org>; Fri, 23 Aug 2019 08:52:30 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 1A5E0233A0
	for <linux-wireless@archiver.kernel.org>; Fri, 23 Aug 2019 08:52:30 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2392931AbfHWIw3 (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Fri, 23 Aug 2019 04:52:29 -0400
Received: from mx1.redhat.com ([209.132.183.28]:43884 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2391183AbfHWIw3 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 23 Aug 2019 04:52:29 -0400
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 40EC810BFB3F;
        Fri, 23 Aug 2019 08:52:29 +0000 (UTC)
Received: from localhost (unknown [10.43.2.236])
        by smtp.corp.redhat.com (Postfix) with ESMTP id B4615100194E;
        Fri, 23 Aug 2019 08:52:26 +0000 (UTC)
From:   Stanislaw Gruszka <sgruszka@redhat.com>
To:     linux-wireless@vger.kernel.org
Cc:     Felix Fietkau <nbd@nbd.name>,
        Lorenzo Bianconi <lorenzo.bianconi@redhat.com>,
        Ryder Lee <ryder.lee@mediatek.com>, Roy Luo <royluo@google.com>
Subject: [PATCH 2/3] mt76: mt76x0: remove redundant chandef copy
Date:   Fri, 23 Aug 2019 10:52:16 +0200
Message-Id: <1566550337-6287-3-git-send-email-sgruszka@redhat.com>
In-Reply-To: <1566550337-6287-1-git-send-email-sgruszka@redhat.com>
References: <1566550337-6287-1-git-send-email-sgruszka@redhat.com>
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.6.2 (mx1.redhat.com [10.5.110.65]); Fri, 23 Aug 2019 08:52:29 +0000 (UTC)
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

We set dev->mt76.chandef in mt76_set_channel() already.

Signed-off-by: Stanislaw Gruszka <sgruszka@redhat.com>
---
 drivers/net/wireless/mediatek/mt76/mt76x0/phy.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/drivers/net/wireless/mediatek/mt76/mt76x0/phy.c b/drivers/net/wireless/mediatek/mt76/mt76x0/phy.c
index 31f988e86d92..1d00aa5da95b 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76x0/phy.c
+++ b/drivers/net/wireless/mediatek/mt76/mt76x0/phy.c
@@ -944,7 +944,6 @@ int mt76x0_phy_set_channel(struct mt76x02_dev *dev,
 	freq1 = chandef->center_freq1;
 	channel = chandef->chan->hw_value;
 	rf_bw_band = (channel <= 14) ? RF_G_BAND : RF_A_BAND;
-	dev->mt76.chandef = *chandef;
 
 	switch (chandef->width) {
 	case NL80211_CHAN_WIDTH_40:
-- 
1.9.3

