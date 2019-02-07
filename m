Return-Path: <SRS0=Kusg=QO=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.8 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AC65AC282C2
	for <linux-wireless@archiver.kernel.org>; Thu,  7 Feb 2019 13:47:37 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 7EB0121908
	for <linux-wireless@archiver.kernel.org>; Thu,  7 Feb 2019 13:47:37 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (1024-bit key) header.d=nbd.name header.i=@nbd.name header.b="B+rDh8V0"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727138AbfBGNrg (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Thu, 7 Feb 2019 08:47:36 -0500
Received: from nbd.name ([46.4.11.11]:47494 "EHLO nbd.name"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727019AbfBGNrZ (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 7 Feb 2019 08:47:25 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nbd.name;
         s=20160729; h=References:In-Reply-To:Message-Id:Date:Subject:To:From:Sender:
        Reply-To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=KmRjSVSgvuNSQVFTvShWVL+yHCSleUo6hKY8CZHKRd8=; b=B+rDh8V0Y4zwRHNhgdk9Pr44SC
        xmKdPjMm5rb09DsceXwkgKXPRak2VGDQFK777l0tg4P+++hPDIAD/l/fppjYGDhhbaqwXi/IOqv93
        9lzCnP9IiwleWJ3vk3Vu6tOyw9MaJIUHWGjs5tIM9kZUaccnJfVvFb3FQBl2wsdxcmQo=;
Received: by maeck.lan (Postfix, from userid 501)
        id 84ABF4F0BF99; Thu,  7 Feb 2019 14:47:23 +0100 (CET)
From:   Felix Fietkau <nbd@nbd.name>
To:     linux-wireless@vger.kernel.org
Subject: [PATCH 5/7] mt76: clear CCA timer stats in mt76x02_edcca_init
Date:   Thu,  7 Feb 2019 14:47:21 +0100
Message-Id: <20190207134723.59163-5-nbd@nbd.name>
X-Mailer: git-send-email 2.17.0
In-Reply-To: <20190207134723.59163-1-nbd@nbd.name>
References: <20190207134723.59163-1-nbd@nbd.name>
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Avoid triggering too early

Signed-off-by: Felix Fietkau <nbd@nbd.name>
---
 drivers/net/wireless/mediatek/mt76/mt76x02_mac.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/net/wireless/mediatek/mt76/mt76x02_mac.c b/drivers/net/wireless/mediatek/mt76/mt76x02_mac.c
index 89c7368cbd52..aecf514bb89b 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76x02_mac.c
+++ b/drivers/net/wireless/mediatek/mt76/mt76x02_mac.c
@@ -919,6 +919,9 @@ void mt76x02_edcca_init(struct mt76x02_dev *dev, bool enable)
 		}
 	}
 	mt76x02_edcca_tx_enable(dev, true);
+
+	/* clear previous CCA timer value */
+	mt76_rr(dev, MT_ED_CCA_TIMER);
 }
 EXPORT_SYMBOL_GPL(mt76x02_edcca_init);
 
-- 
2.17.0

