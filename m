Return-Path: <SRS0=CI53=33=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.5 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 34373C2BA83
	for <linux-wireless@archiver.kernel.org>; Fri,  7 Feb 2020 17:00:11 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id F2E6020838
	for <linux-wireless@archiver.kernel.org>; Fri,  7 Feb 2020 17:00:10 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (1024-bit key) header.d=nbd.name header.i=@nbd.name header.b="FmScKsWS"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727390AbgBGRAK (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Fri, 7 Feb 2020 12:00:10 -0500
Received: from nbd.name ([46.4.11.11]:58248 "EHLO nbd.name"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726867AbgBGRAK (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 7 Feb 2020 12:00:10 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nbd.name;
         s=20160729; h=Content-Transfer-Encoding:MIME-Version:References:In-Reply-To:
        Message-Id:Date:Subject:To:From:Sender:Reply-To:Cc:Content-Type:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=Tsh9ByKW072RViyLCL6ki6nXhwjY7qENKuC7cJhBxcM=; b=FmScKsWSahKc/hMbSsHShJdnvx
        RH2afbanUhdDIvQhzds/2DQc+hB9MdY01SO2Wke8PWD17XBArXUKh/MWXiSpqpS0hvUmkYQQXdC39
        uRZh3RT3qSiB8ztCp/G0GCn0qUpmygo14g6xe7O86R2/6dy746D77WHDXNwp5ZZtzmck=;
Received: from [80.255.10.202] (helo=maeck.local)
        by ds12 with esmtpsa (TLS1.2:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.89)
        (envelope-from <nbd@nbd.name>)
        id 1j06zB-0000Wi-03
        for linux-wireless@vger.kernel.org; Fri, 07 Feb 2020 18:00:09 +0100
Received: by maeck.local (Postfix, from userid 501)
        id 844597B99ACE; Fri,  7 Feb 2020 18:00:03 +0100 (CET)
From:   Felix Fietkau <nbd@nbd.name>
To:     linux-wireless@vger.kernel.org
Subject: [PATCH 2/2] mt76: mt76x2: avoid starting the MAC too early
Date:   Fri,  7 Feb 2020 18:00:03 +0100
Message-Id: <20200207170003.35765-2-nbd@nbd.name>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <20200207170003.35765-1-nbd@nbd.name>
References: <20200207170003.35765-1-nbd@nbd.name>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Do not set the tx/rx start bits in MT_MAC_SYS_CTRL from within initvals.
The driver sets these later when the hardware is ready

Signed-off-by: Felix Fietkau <nbd@nbd.name>
---
 drivers/net/wireless/mediatek/mt76/mt76x2/init.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/wireless/mediatek/mt76/mt76x2/init.c b/drivers/net/wireless/mediatek/mt76/mt76x2/init.c
index 79e583eb066b..a92a479aebaa 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76x2/init.c
+++ b/drivers/net/wireless/mediatek/mt76/mt76x2/init.c
@@ -82,7 +82,7 @@ void mt76_write_mac_initvals(struct mt76x02_dev *dev)
 		{ MT_PBF_SYS_CTRL,		0x00080c00 },
 		{ MT_PBF_CFG,			0x1efebcff },
 		{ MT_FCE_PSE_CTRL,		0x00000001 },
-		{ MT_MAC_SYS_CTRL,		0x0000000c },
+		{ MT_MAC_SYS_CTRL,		0x00000000 },
 		{ MT_MAX_LEN_CFG,		0x003e3f00 },
 		{ MT_AMPDU_MAX_LEN_20M1S,	0xaaa99887 },
 		{ MT_AMPDU_MAX_LEN_20M2S,	0x000000aa },
-- 
2.24.0

