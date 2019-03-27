Return-Path: <SRS0=A7Z7=R6=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,
	USER_AGENT_GIT autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AEF93C43381
	for <linux-wireless@archiver.kernel.org>; Wed, 27 Mar 2019 19:29:17 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 7BB7D2075C
	for <linux-wireless@archiver.kernel.org>; Wed, 27 Mar 2019 19:29:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1553714957;
	bh=Ffqck2aIWABNUq3ZwltuooVhhQ3A2FFCOQHwiHl4c8U=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:List-ID:From;
	b=X4CkwWnD3h+LLpFwMhR/JhEbG0fCxuboayic4FjlnPg3N17qxuLknmo+ZTqJclq5y
	 FV8kgLukrAciLP49Ttyfb7mVbgTSKS/8AOLtjM6PsFyURMw4cPDKQ/V1F+GUzpjlnO
	 dejKt0EiSFOrfrJY/rIMUcoZlBRQWXzT6GeNG6Ws=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732989AbfC0SDz (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Wed, 27 Mar 2019 14:03:55 -0400
Received: from mail.kernel.org ([198.145.29.99]:44278 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732879AbfC0SDx (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 27 Mar 2019 14:03:53 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 29310217D7;
        Wed, 27 Mar 2019 18:03:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1553709832;
        bh=Ffqck2aIWABNUq3ZwltuooVhhQ3A2FFCOQHwiHl4c8U=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Jy6Fl+hp/xthAo710DUyJhO5Rvu8qul/7hFcw5HeRxAGQJ7qWVbuFH1hv37pNYwCp
         U9lc9rFbrK9DTNBFtZSsRGCte7SJuDOn05dCfwqip+VAIfaThrzo9CItLg+Oe6IMzx
         oGTvfNVfxoooUHkUwDcJYXIYGvVySTzklodpnePA=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Wen Yang <wen.yang99@zte.com.cn>, Felix Fietkau <nbd@nbd.name>,
        Lorenzo Bianconi <lorenzo.bianconi83@gmail.com>,
        Kalle Valo <kvalo@codeaurora.org>,
        "David S. Miller" <davem@davemloft.net>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        linux-mediatek@lists.infradead.org, Sasha Levin <sashal@kernel.org>
Subject: [PATCH AUTOSEL 5.0 064/262] mt76: fix a leaked reference by adding a missing of_node_put
Date:   Wed, 27 Mar 2019 13:58:39 -0400
Message-Id: <20190327180158.10245-64-sashal@kernel.org>
X-Mailer: git-send-email 2.19.1
In-Reply-To: <20190327180158.10245-1-sashal@kernel.org>
References: <20190327180158.10245-1-sashal@kernel.org>
MIME-Version: 1.0
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

From: Wen Yang <wen.yang99@zte.com.cn>

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

