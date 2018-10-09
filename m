Return-Path: <SRS0=ggvw=MV=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.6 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 43625C64EB8
	for <linux-wireless@archiver.kernel.org>; Tue,  9 Oct 2018 08:55:27 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id EBC392075C
	for <linux-wireless@archiver.kernel.org>; Tue,  9 Oct 2018 08:55:26 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (1024-bit key) header.d=nbd.name header.i=@nbd.name header.b="kl0Rv4cE"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org EBC392075C
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=nbd.name
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-wireless-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726103AbeJIQLR (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Tue, 9 Oct 2018 12:11:17 -0400
Received: from nbd.name ([46.4.11.11]:55656 "EHLO nbd.name"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725861AbeJIQLR (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 9 Oct 2018 12:11:17 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nbd.name;
         s=20160729; h=Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To:
        MIME-Version:Content-Type:Content-Transfer-Encoding:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:In-Reply-To:References:List-Id:List-Help:List-Unsubscribe:
        List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=utFZ55n4FfpQ2fqunt4IlOj43oHybVG7L+55MbVC8tY=; b=kl0Rv4cEW3ERHns3QL6Jkeo0PW
        OJHwoT8Szzddu6SRBSLkrkN3Kv89tizw9vU6rfDbgxyBJB+NPqC8MJ26TM6trn/Jbu8vncOBU8Kkv
        NvaUNWckGui4+QSMEOIBnQKImAfwAt+t4LxNVrKN1zRQ9tqtFL0zajbfxUgyUCK4sAGo=;
Received: by maeck.lan (Postfix, from userid 501)
        id 1B7413EB1D7C; Tue,  9 Oct 2018 10:55:20 +0200 (CEST)
From:   Felix Fietkau <nbd@nbd.name>
To:     linux-wireless@vger.kernel.org
Cc:     yuehaibing@huawei.com, lorenzo.bianconi@redhat.com
Subject: [PATCH] mt76: mt76x0e: another fix for the external PA current setting
Date:   Tue,  9 Oct 2018 10:55:20 +0200
Message-Id: <20181009085520.61804-1-nbd@nbd.name>
X-Mailer: git-send-email 2.17.0
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

- Use the register number define instead of a magic value
- Fix inverted bit test (override needs to be applied if the bit is not set)

Fixes: 2b2cb40bcd7d ("mt76x0: pci: add hw initialization at bootstrap")
Signed-off-by: Felix Fietkau <nbd@nbd.name>
---
 drivers/net/wireless/mediatek/mt76/mt76x0/pci.c | 13 +++----------
 1 file changed, 3 insertions(+), 10 deletions(-)

diff --git a/drivers/net/wireless/mediatek/mt76/mt76x0/pci.c b/drivers/net/wireless/mediatek/mt76/mt76x0/pci.c
index cc8af17dc9c7..fd2dc7efeea3 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76x0/pci.c
+++ b/drivers/net/wireless/mediatek/mt76/mt76x0/pci.c
@@ -111,17 +111,10 @@ static int mt76x0e_register_device(struct mt76x02_dev *dev)
 		u16 val;
 
 		mt76_clear(dev, MT_COEXCFG0, BIT(0));
+
 		val = mt76x02_eeprom_get(dev, MT_EE_NIC_CONF_0);
-		if (val & MT_EE_NIC_CONF_0_PA_IO_CURRENT) {
-			u32 data;
-
-			/* set external PA I/O
-			 * current to 16mA
-			 */
-			data = mt76_rr(dev, 0x11c);
-			data |= 0xc03;
-			mt76_wr(dev, 0x11c, data);
-		}
+		if (!(val & MT_EE_NIC_CONF_0_PA_IO_CURRENT))
+			mt76_set(dev, MT_XO_CTRL7, 0xc03);
 	}
 
 	mt76_clear(dev, 0x110, BIT(9));
-- 
2.17.0

