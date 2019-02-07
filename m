Return-Path: <SRS0=Kusg=QO=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.8 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 92230C282CC
	for <linux-wireless@archiver.kernel.org>; Thu,  7 Feb 2019 13:47:34 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 5FA6921908
	for <linux-wireless@archiver.kernel.org>; Thu,  7 Feb 2019 13:47:34 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (1024-bit key) header.d=nbd.name header.i=@nbd.name header.b="LZRofS+e"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726985AbfBGNrc (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Thu, 7 Feb 2019 08:47:32 -0500
Received: from nbd.name ([46.4.11.11]:47502 "EHLO nbd.name"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727058AbfBGNr0 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 7 Feb 2019 08:47:26 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nbd.name;
         s=20160729; h=References:In-Reply-To:Message-Id:Date:Subject:To:From:Sender:
        Reply-To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=HqPMH+AUBSSoNGl14dZRs1g3y4hZhEX9FxoZtHeW3co=; b=LZRofS+eaVs8LuiB7W7jn7CS3M
        dTC1LJLTkpoTPNT34dSFhW+4Azg9Y7zNORRZiWur055BXa5zrDDd2Y6myAeSQ3iiyThirZ09+g/KC
        0HZJhISGiWkXl9hPMO2WTMBzCxtKcYGtg9Bshe+R4yBy0u25QWkWRJiBkW2X9rIkDeyI=;
Received: by maeck.lan (Postfix, from userid 501)
        id 852444F0BF9B; Thu,  7 Feb 2019 14:47:23 +0100 (CET)
From:   Felix Fietkau <nbd@nbd.name>
To:     linux-wireless@vger.kernel.org
Subject: [PATCH 7/7] mt76: increase ED/CCA tx block threshold
Date:   Thu,  7 Feb 2019 14:47:23 +0100
Message-Id: <20190207134723.59163-7-nbd@nbd.name>
X-Mailer: git-send-email 2.17.0
In-Reply-To: <20190207134723.59163-1-nbd@nbd.name>
References: <20190207134723.59163-1-nbd@nbd.name>
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Block only when the busy time reaches 92%, as lower values can be reached with
heavy 802.11 traffic as well.

Signed-off-by: Felix Fietkau <nbd@nbd.name>
---
 drivers/net/wireless/mediatek/mt76/mt76x02_mac.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/wireless/mediatek/mt76/mt76x02_mac.c b/drivers/net/wireless/mediatek/mt76/mt76x02_mac.c
index 462ac030c08a..bf39624c9b98 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76x02_mac.c
+++ b/drivers/net/wireless/mediatek/mt76/mt76x02_mac.c
@@ -926,7 +926,7 @@ void mt76x02_edcca_init(struct mt76x02_dev *dev, bool enable)
 }
 EXPORT_SYMBOL_GPL(mt76x02_edcca_init);
 
-#define MT_EDCCA_TH		90
+#define MT_EDCCA_TH		92
 #define MT_EDCCA_BLOCK_TH	2
 static void mt76x02_edcca_check(struct mt76x02_dev *dev)
 {
-- 
2.17.0

