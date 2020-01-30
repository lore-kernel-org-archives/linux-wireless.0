Return-Path: <SRS0=/tVN=3T=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.6 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CD6EFC35240
	for <linux-wireless@archiver.kernel.org>; Thu, 30 Jan 2020 14:47:28 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 99719214AF
	for <linux-wireless@archiver.kernel.org>; Thu, 30 Jan 2020 14:47:28 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (1024-bit key) header.d=nbd.name header.i=@nbd.name header.b="b+oboRtm"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727348AbgA3Or1 (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Thu, 30 Jan 2020 09:47:27 -0500
Received: from nbd.name ([46.4.11.11]:57474 "EHLO nbd.name"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727186AbgA3Or1 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 30 Jan 2020 09:47:27 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nbd.name;
         s=20160729; h=Content-Transfer-Encoding:MIME-Version:References:In-Reply-To:
        Message-Id:Date:Subject:To:From:Sender:Reply-To:Cc:Content-Type:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=rqtNqZZYcXgcYy/9ids+XvioO4bn1OSwu6Q6yjabXwk=; b=b+oboRtmiTccc2OFXsvnZ8c159
        KrowsDMeFv/yuRCZSLphrVR9rLv2ccH73Ta/U+4FNpIvxtyR63l3nS7hshaLmMiNxKgmUBhF1S35O
        /CWmkIsAuGqgxZ4XGOX+JqVRsWtqR3T+MCwUoCcFy77LCIAAj6ZRRIquf+bMg5W6Uv7k=;
Received: from [178.162.209.135] (helo=maeck.local)
        by ds12 with esmtpsa (TLS1.2:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.89)
        (envelope-from <nbd@nbd.name>)
        id 1ixB6L-0001Vm-Jc
        for linux-wireless@vger.kernel.org; Thu, 30 Jan 2020 15:47:25 +0100
Received: by maeck.local (Postfix, from userid 501)
        id EEEEA7AE4695; Thu, 30 Jan 2020 15:47:18 +0100 (CET)
From:   Felix Fietkau <nbd@nbd.name>
To:     linux-wireless@vger.kernel.org
Subject: [PATCH 10/15] mt76: mt7615: disable 5 GHz on MT7622
Date:   Thu, 30 Jan 2020 15:47:13 +0100
Message-Id: <20200130144718.14298-10-nbd@nbd.name>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <20200130144718.14298-1-nbd@nbd.name>
References: <20200130144718.14298-1-nbd@nbd.name>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

It is not supported by the chip, so avoid issues with potentially wrong
EEPROM configurations.

Signed-off-by: Felix Fietkau <nbd@nbd.name>
---
 drivers/net/wireless/mediatek/mt76/mt7615/eeprom.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/net/wireless/mediatek/mt76/mt7615/eeprom.c b/drivers/net/wireless/mediatek/mt76/mt7615/eeprom.c
index 0008e4584537..49d8ae091190 100644
--- a/drivers/net/wireless/mediatek/mt76/mt7615/eeprom.c
+++ b/drivers/net/wireless/mediatek/mt76/mt7615/eeprom.c
@@ -111,6 +111,9 @@ static void mt7615_eeprom_parse_hw_cap(struct mt7615_dev *dev)
 		break;
 	}
 
+	if (is_mt7622(&dev->mt76))
+		dev->mt76.cap.has_5ghz = false;
+
 	/* read tx-rx mask from eeprom */
 	val = mt76_rr(dev, MT_TOP_STRAP_STA);
 	max_nss = val & MT_TOP_3NSS ? 3 : 4;
-- 
2.24.0

