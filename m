Return-Path: <SRS0=z7UY=PZ=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.8 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9FF37C43444
	for <linux-wireless@archiver.kernel.org>; Thu, 17 Jan 2019 13:51:38 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 6E9AB20851
	for <linux-wireless@archiver.kernel.org>; Thu, 17 Jan 2019 13:51:38 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (1024-bit key) header.d=nbd.name header.i=@nbd.name header.b="mRsAs+4w"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727180AbfAQNvg (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Thu, 17 Jan 2019 08:51:36 -0500
Received: from nbd.name ([46.4.11.11]:56444 "EHLO nbd.name"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726883AbfAQNvg (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 17 Jan 2019 08:51:36 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nbd.name;
         s=20160729; h=References:In-Reply-To:Message-Id:Date:Subject:To:From:Sender:
        Reply-To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=sufme5/VdVs5hnN0ZuJOrsbbdbWZhLFLtcVaaJdrcbg=; b=mRsAs+4w3qLS2BPOLbuELooN4z
        nF8wfwUqOn2RJITLotV1LboLFfghrsspRReaK9G1/ljQpnnbPSf4Q1dd89tV9aWH5ycyERRgFtCFW
        ttzbf1WU1EXaNcq8W5GJ84s4UvtdGzwIs2/O9ieTKFEdiOHcDG0pLjU4DYphpPbnSnv0=;
Received: by maeck.lan (Postfix, from userid 501)
        id 34F734C6F04D; Thu, 17 Jan 2019 14:51:34 +0100 (CET)
From:   Felix Fietkau <nbd@nbd.name>
To:     linux-wireless@vger.kernel.org
Subject: [PATCH 6/7] mt76: fix signedness of rx status signal field
Date:   Thu, 17 Jan 2019 14:51:32 +0100
Message-Id: <20190117135133.2753-6-nbd@nbd.name>
X-Mailer: git-send-email 2.17.0
In-Reply-To: <20190117135133.2753-1-nbd@nbd.name>
References: <20190117135133.2753-1-nbd@nbd.name>
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

It is usually negative, so it needs to be signed.

Signed-off-by: Felix Fietkau <nbd@nbd.name>
---
 drivers/net/wireless/mediatek/mt76/mt76.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/wireless/mediatek/mt76/mt76.h b/drivers/net/wireless/mediatek/mt76/mt76.h
index 2267163d2445..0435d623e9ad 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76.h
+++ b/drivers/net/wireless/mediatek/mt76/mt76.h
@@ -497,7 +497,7 @@ struct mt76_rx_status {
 	u8 rate_idx;
 	u8 nss;
 	u8 band;
-	u8 signal;
+	s8 signal;
 	u8 chains;
 	s8 chain_signal[IEEE80211_MAX_CHAINS];
 };
-- 
2.17.0

