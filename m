Return-Path: <SRS0=F8Dj=QZ=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.8 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS,USER_AGENT_GIT autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D5B49C4360F
	for <linux-wireless@archiver.kernel.org>; Mon, 18 Feb 2019 19:42:23 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 9EBC6217D9
	for <linux-wireless@archiver.kernel.org>; Mon, 18 Feb 2019 19:42:23 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (1024-bit key) header.d=nbd.name header.i=@nbd.name header.b="dAFU7cEd"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726150AbfBRTmW (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Mon, 18 Feb 2019 14:42:22 -0500
Received: from nbd.name ([46.4.11.11]:56648 "EHLO nbd.name"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726038AbfBRTmV (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 18 Feb 2019 14:42:21 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nbd.name;
         s=20160729; h=References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:
        Sender:Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Resent-Date:Resent-From:Resent-Sender:
        Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:
        List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=66y+Ch0yerqnv9p+LbFawZGwus+3HUsWsqPMaMVsMho=; b=dAFU7cEdO7tJCqF+qhHMzYdcKd
        US4z3pJPgUflUakFHMSR/uZ03f6R6wK2xN1ZoAdWu4AmspIKrXs/51x4mi2aEufquMk5phGz76JgJ
        GSPEaO6Pn8LM0l9CVakkWMPnB2p1YtHPKbroYNYNNeYVsFP911OIqFT4GqXQvIu/iAyc=;
Received: by maeck.lan (Postfix, from userid 501)
        id 266075004556; Mon, 18 Feb 2019 20:42:18 +0100 (CET)
From:   Felix Fietkau <nbd@nbd.name>
To:     linux-wireless@vger.kernel.org
Cc:     stable@vger.kernel.org
Subject: [PATCH 2/4] mt76: fix corrupted software generated tx CCMP PN
Date:   Mon, 18 Feb 2019 20:42:16 +0100
Message-Id: <20190218194218.41314-2-nbd@nbd.name>
X-Mailer: git-send-email 2.17.0
In-Reply-To: <20190218194218.41314-1-nbd@nbd.name>
References: <20190218194218.41314-1-nbd@nbd.name>
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Since ccmp_pn is u8 *, the second half needs to start at array index 4
instead of 0. Fixes a connection stall after a certain amount of traffic

Fixes: 23405236460b9 ("mt76: fix transmission of encrypted management frames")
Cc: stable@vger.kernel.org
Signed-off-by: Felix Fietkau <nbd@nbd.name>
---
 drivers/net/wireless/mediatek/mt76/mt76x02_mac.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/wireless/mediatek/mt76/mt76x02_mac.c b/drivers/net/wireless/mediatek/mt76/mt76x02_mac.c
index bf39624c9b98..eab713723b7e 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76x02_mac.c
+++ b/drivers/net/wireless/mediatek/mt76/mt76x02_mac.c
@@ -314,7 +314,7 @@ void mt76x02_mac_write_txwi(struct mt76x02_dev *dev, struct mt76x02_txwi *txwi,
 		ccmp_pn[6] = pn >> 32;
 		ccmp_pn[7] = pn >> 40;
 		txwi->iv = *((__le32 *)&ccmp_pn[0]);
-		txwi->eiv = *((__le32 *)&ccmp_pn[1]);
+		txwi->eiv = *((__le32 *)&ccmp_pn[4]);
 	}
 
 	spin_lock_bh(&dev->mt76.lock);
-- 
2.17.0

