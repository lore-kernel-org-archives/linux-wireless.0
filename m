Return-Path: <linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.6 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3A3AFC433C1
	for <linux-wireless@archiver.kernel.org>; Sun, 28 Mar 2021 12:32:03 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 04FD96188B
	for <linux-wireless@archiver.kernel.org>; Sun, 28 Mar 2021 12:32:03 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229757AbhC1Mbr (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Sun, 28 Mar 2021 08:31:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48112 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229499AbhC1MbQ (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Sun, 28 Mar 2021 08:31:16 -0400
Received: from nbd.name (nbd.name [IPv6:2a01:4f8:221:3d45::2])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 434C0C061762
        for <linux-wireless@vger.kernel.org>; Sun, 28 Mar 2021 05:31:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nbd.name;
         s=20160729; h=Content-Transfer-Encoding:MIME-Version:References:In-Reply-To:
        Message-Id:Date:Subject:To:From:Sender:Reply-To:Cc:Content-Type:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=K02Wsvs2hY7BKOgW61kr+w+xbSSjvsiEWHY5J4ut8yk=; b=Zjst/p9SqBp2ZptbFzvlOV+jYB
        EV+Jr4iIEtr3NOmTLSm43gfMs0nxLHWNztjd/4PtHx1oqxHz/wsl7e4b9sGJvFVPnLOuPkMksKgfk
        oFS3Kwh+YpurNyWFFH1U/B/RwSadM74MH08EjPifNlMWH9R/erYQlotBBctC76uSBKes=;
Received: from p4ff13c8d.dip0.t-ipconnect.de ([79.241.60.141] helo=localhost.localdomain)
        by ds12 with esmtpsa (TLS1.2:ECDHE_RSA_AES_128_GCM_SHA256:128)
        (Exim 4.89)
        (envelope-from <nbd@nbd.name>)
        id 1lQUZR-0001Tv-4v
        for linux-wireless@vger.kernel.org; Sun, 28 Mar 2021 14:31:09 +0200
From:   Felix Fietkau <nbd@nbd.name>
To:     linux-wireless@vger.kernel.org
Subject: [PATCH 2/2] mt76: mt7915: limit firmware log message printk to buffer length
Date:   Sun, 28 Mar 2021 14:31:07 +0200
Message-Id: <20210328123107.74828-2-nbd@nbd.name>
X-Mailer: git-send-email 2.30.1
In-Reply-To: <20210328123107.74828-1-nbd@nbd.name>
References: <20210328123107.74828-1-nbd@nbd.name>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Avoid including garbage from previous rx data

Signed-off-by: Felix Fietkau <nbd@nbd.name>
---
 drivers/net/wireless/mediatek/mt76/mt7915/mcu.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/net/wireless/mediatek/mt76/mt7915/mcu.c b/drivers/net/wireless/mediatek/mt76/mt7915/mcu.c
index 9d0911ac1d90..67b1426e98b6 100644
--- a/drivers/net/wireless/mediatek/mt76/mt7915/mcu.c
+++ b/drivers/net/wireless/mediatek/mt76/mt7915/mcu.c
@@ -521,7 +521,8 @@ mt7915_mcu_rx_log_message(struct mt7915_dev *dev, struct sk_buff *skb)
 		break;
 	}
 
-	wiphy_info(mt76_hw(dev)->wiphy, "%s: %s", type, data);
+	wiphy_info(mt76_hw(dev)->wiphy, "%s: %*s", type,
+		   (int)(skb->len - sizeof(*rxd)), data);
 }
 
 static void
-- 
2.30.1

