Return-Path: <SRS0=VaBP=4Q=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DC7BCC3F2D2
	for <linux-wireless@archiver.kernel.org>; Fri, 28 Feb 2020 13:29:45 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id A2879246A8
	for <linux-wireless@archiver.kernel.org>; Fri, 28 Feb 2020 13:29:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1582896585;
	bh=ueRno9wU2ahuD234sm4+J9KY4nKcWSDVStSvZRzy9lI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:List-ID:From;
	b=xIVZIvf0ws86A6Rd0gnl6EileiZMwt2fg4iSPyLqjVuxMRZdKyVZehx5lybIVe1ir
	 DIV+IsclOywc4cqGU0hV1MrDowMk/LXKolHOx3kThD0ftF5CfgP09Vuzzp0/6LE/Qh
	 QcQb6U0wFUtlLQDfJtFpuQNpudnTTf30EyDJdDY0=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726418AbgB1N3p (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Fri, 28 Feb 2020 08:29:45 -0500
Received: from mail.kernel.org ([198.145.29.99]:42774 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726791AbgB1N3o (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 28 Feb 2020 08:29:44 -0500
Received: from lore-desk-wlan.redhat.com (unknown [151.48.128.122])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 1C92F246A3;
        Fri, 28 Feb 2020 13:29:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1582896584;
        bh=ueRno9wU2ahuD234sm4+J9KY4nKcWSDVStSvZRzy9lI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=wGD05IUSKBqdOO9G5aRu5joFlfEMQ8Dmcx6Ea7sPvYcvHjbo0YJWw09yLLGYOojUE
         6OX0wc+PPMNYFqn8tJT9zV3RxQ2Hlbc3zrFq4KmaEksHo5+dSqnrjutL53EQOsyZJp
         WpSQSW6UbBU2dHcgfgjCBwVNp68xSvosJrd19T3c=
From:   Lorenzo Bianconi <lorenzo@kernel.org>
To:     nbd@nbd.name
Cc:     lorenzo.bianconi@redhat.com, linux-wireless@vger.kernel.org,
        sean.wang@mediatek.com
Subject: [PATCH 6/6] mt76: mt7615: move mt7615_mac_wtbl_addr in mac.h
Date:   Fri, 28 Feb 2020 14:29:27 +0100
Message-Id: <aa1b3a566fe014718d7ab4de7207f3bf8bf88bdc.1582893136.git.lorenzo@kernel.org>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <cover.1582893136.git.lorenzo@kernel.org>
References: <cover.1582893136.git.lorenzo@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Move mt7615_mac_wtbl_addr in mac.h to reuse it in mt7663u driver

Signed-off-by: Lorenzo Bianconi <lorenzo@kernel.org>
---
 drivers/net/wireless/mediatek/mt76/mt7615/mac.c | 5 -----
 drivers/net/wireless/mediatek/mt76/mt7615/mac.h | 5 +++++
 2 files changed, 5 insertions(+), 5 deletions(-)

diff --git a/drivers/net/wireless/mediatek/mt76/mt7615/mac.c b/drivers/net/wireless/mediatek/mt76/mt7615/mac.c
index a14ca0825582..dcd1141792d6 100644
--- a/drivers/net/wireless/mediatek/mt76/mt7615/mac.c
+++ b/drivers/net/wireless/mediatek/mt76/mt7615/mac.c
@@ -707,11 +707,6 @@ void mt7615_txp_skb_unmap(struct mt76_dev *dev,
 		mt7615_txp_skb_unmap_hw(dev, &txp->hw);
 }
 
-static u32 mt7615_mac_wtbl_addr(struct mt7615_dev *dev, int wcid)
-{
-	return MT_WTBL_BASE(dev) + wcid * MT_WTBL_ENTRY_SIZE;
-}
-
 bool mt7615_mac_wtbl_update(struct mt7615_dev *dev, int idx, u32 mask)
 {
 	mt76_rmw(dev, MT_WTBL_UPDATE, MT_WTBL_UPDATE_WLAN_IDX,
diff --git a/drivers/net/wireless/mediatek/mt76/mt7615/mac.h b/drivers/net/wireless/mediatek/mt76/mt7615/mac.h
index 5fe6a0e667a9..0fb9c0b2bca4 100644
--- a/drivers/net/wireless/mediatek/mt76/mt7615/mac.h
+++ b/drivers/net/wireless/mediatek/mt76/mt7615/mac.h
@@ -405,4 +405,9 @@ mt7615_txwi_to_txp(struct mt76_dev *dev, struct mt76_txwi_cache *t)
 	return (struct mt7615_txp_common *)(txwi + MT_TXD_SIZE);
 }
 
+static inline u32 mt7615_mac_wtbl_addr(struct mt7615_dev *dev, int wcid)
+{
+	return MT_WTBL_BASE(dev) + wcid * MT_WTBL_ENTRY_SIZE;
+}
+
 #endif
-- 
2.24.1

