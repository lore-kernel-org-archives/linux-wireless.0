Return-Path: <SRS0=xyYy=SG=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 182C7C10F05
	for <linux-wireless@archiver.kernel.org>; Thu,  4 Apr 2019 09:30:34 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id DBA4D205F4
	for <linux-wireless@archiver.kernel.org>; Thu,  4 Apr 2019 09:30:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1554370233;
	bh=GHiXkZAloJXwcrj4Qa7/SdV9pTNyQRq0Vl8arTgRe60=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:List-ID:From;
	b=Q18Q0TGyk6TvXQmD26I1y4q7pRTIeIDyjAOoUb62/yt++in2++prQAxXGs1tvRR01
	 qYKK/SeWpsQc1rVVK9MKrHx8LDAgoDD47FsERoUQfFlBH5tjxFR6FQQN/oo9C/0+kl
	 37U/xou7XZwByXhapZk9LLFd0hEzoWVzASGtWQCI=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732929AbfDDJKD (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Thu, 4 Apr 2019 05:10:03 -0400
Received: from mail.kernel.org ([198.145.29.99]:49376 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732920AbfDDJKA (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 4 Apr 2019 05:10:00 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id CCE6020693;
        Thu,  4 Apr 2019 09:09:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1554368999;
        bh=GHiXkZAloJXwcrj4Qa7/SdV9pTNyQRq0Vl8arTgRe60=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=wCByu3M7ppH8A+fL9L3iUEnJ3lCdWZU6dGZM2O9QAX+uLJCSytrps0CClpRYVhtPh
         HL+52iRQvVba554vm9lO64YL0mZv6KFlZ9L93xW+SDI2leo9W4sHXinaw77dCSM+1r
         HBuXek2/FBhuogCaF3NHrjSSjX2vOufPCW6wFPgM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Wen Yang <wen.yang99@zte.com.cn>,
        Felix Fietkau <nbd@nbd.name>,
        Lorenzo Bianconi <lorenzo.bianconi83@gmail.com>,
        Kalle Valo <kvalo@codeaurora.org>,
        "David S. Miller" <davem@davemloft.net>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        linux-mediatek@lists.infradead.org, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.0 060/246] mt76: fix a leaked reference by adding a missing of_node_put
Date:   Thu,  4 Apr 2019 10:46:00 +0200
Message-Id: <20190404084621.274424274@linuxfoundation.org>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190404084619.236418459@linuxfoundation.org>
References: <20190404084619.236418459@linuxfoundation.org>
User-Agent: quilt/0.65
X-stable: review
X-Patchwork-Hint: ignore
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

5.0-stable review patch.  If anyone has any objections, please let me know.

------------------

[ Upstream commit 34e022d8b780a03902d82fb3997ba7c7b1f40c81 ]

The call to of_find_node_by_phandle returns a node pointer with refcount
incremented thus it must be explicitly decremented after the last
usage.

Detected by coccinelle with the following warnings:
./drivers/net/wireless/mediatek/mt76/eeprom.c:58:2-8: ERROR: missing of_node_put; acquired a node pointer with refcount incremented on line 48, but without a corresponding object release within this function.
./drivers/net/wireless/mediatek/mt76/eeprom.c:61:2-8: ERROR: missing of_node_put; acquired a node pointer with refcount incremented on line 48, but without a corresponding object release within this function.
./drivers/net/wireless/mediatek/mt76/eeprom.c:67:2-8: ERROR: missing of_node_put; acquired a node pointer with refcount incremented on line 48, but without a corresponding object release within this function.
./drivers/net/wireless/mediatek/mt76/eeprom.c:70:2-8: ERROR: missing of_node_put; acquired a node pointer with refcount incremented on line 48, but without a corresponding object release within this function.
./drivers/net/wireless/mediatek/mt76/eeprom.c:72:1-7: ERROR: missing of_node_put; acquired a node pointer with refcount incremented on line 48, but without a corresponding object release within this function.

Signed-off-by: Wen Yang <wen.yang99@zte.com.cn>
Cc: Felix Fietkau <nbd@nbd.name>
Cc: Lorenzo Bianconi <lorenzo.bianconi83@gmail.com>
Cc: Kalle Valo <kvalo@codeaurora.org>
Cc: "David S. Miller" <davem@davemloft.net>
Cc: Matthias Brugger <matthias.bgg@gmail.com>
Cc: linux-wireless@vger.kernel.org
Cc: netdev@vger.kernel.org
Cc: linux-arm-kernel@lists.infradead.org
Cc: linux-mediatek@lists.infradead.org
Cc: linux-kernel@vger.kernel.org
Signed-off-by: Kalle Valo <kvalo@codeaurora.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/mediatek/mt76/eeprom.c | 24 ++++++++++++++-------
 1 file changed, 16 insertions(+), 8 deletions(-)

diff --git a/drivers/net/wireless/mediatek/mt76/eeprom.c b/drivers/net/wireless/mediatek/mt76/eeprom.c
index 530e5593765c..a1529920d877 100644
--- a/drivers/net/wireless/mediatek/mt76/eeprom.c
+++ b/drivers/net/wireless/mediatek/mt76/eeprom.c
@@ -54,22 +54,30 @@ mt76_get_of_eeprom(struct mt76_dev *dev, int len)
 		part = np->name;
 
 	mtd = get_mtd_device_nm(part);
-	if (IS_ERR(mtd))
-		return PTR_ERR(mtd);
+	if (IS_ERR(mtd)) {
+		ret =  PTR_ERR(mtd);
+		goto out_put_node;
+	}
 
-	if (size <= sizeof(*list))
-		return -EINVAL;
+	if (size <= sizeof(*list)) {
+		ret = -EINVAL;
+		goto out_put_node;
+	}
 
 	offset = be32_to_cpup(list);
 	ret = mtd_read(mtd, offset, len, &retlen, dev->eeprom.data);
 	put_mtd_device(mtd);
 	if (ret)
-		return ret;
+		goto out_put_node;
 
-	if (retlen < len)
-		return -EINVAL;
+	if (retlen < len) {
+		ret = -EINVAL;
+		goto out_put_node;
+	}
 
-	return 0;
+out_put_node:
+	of_node_put(np);
+	return ret;
 #else
 	return -ENOENT;
 #endif
-- 
2.19.1



