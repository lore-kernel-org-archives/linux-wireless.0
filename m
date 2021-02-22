Return-Path: <linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-19.3 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2A31AC433DB
	for <linux-wireless@archiver.kernel.org>; Mon, 22 Feb 2021 01:15:27 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id EBA2264E5C
	for <linux-wireless@archiver.kernel.org>; Mon, 22 Feb 2021 01:15:26 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229967AbhBVBP0 (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Sun, 21 Feb 2021 20:15:26 -0500
Received: from mail.kernel.org ([198.145.29.99]:54300 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229866AbhBVBPZ (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Sun, 21 Feb 2021 20:15:25 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id D51FF64EC8;
        Mon, 22 Feb 2021 01:14:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1613956484;
        bh=b0tCKONw8Iw4ipcpGGjAWovmFpegtak3H8Km2Be4MZI=;
        h=From:To:Cc:Subject:Date:From;
        b=gPB5yiwyyCYmept/ylFiUeuWaFY/LXQxtEDkumpbvgDTRy98lFVBEsFz+SSLW9Rmv
         P7pANS9eSHpgKy91uMTAwACK4hLufbIsIZ0PZFcSPzdhEkEcsOl/xYmALoRkI6DZon
         J0yQ+6yyttQiZCfPCklK9p7KsjChFp/G5DH3KHzJ0uKnVpp1SLvxlXnV2/5eRZmH0y
         ng0jjdmuTxQeLeYgFD9hl4precRu0vW/7Y6sa0bqKBDrRM+x7KN9e8aDWZJNhB6ETH
         rW9v5YA6JahH4N4mk1jETAIOqvdRVsCl+ggP/mOzYYDOomkJ7ZU76ZxJbECTc7MG23
         9x+4NsdZYR0cA==
From:   Lorenzo Bianconi <lorenzo@kernel.org>
To:     nbd@nbd.name
Cc:     linux-wireless@vger.kernel.org, lorenzo.bianconi@redhat.com,
        sean.wang@mediatek.com, ryder.lee@mediatek.com
Subject: [PATCH] mt76: mt7915: fix aggr len debugfs node
Date:   Mon, 22 Feb 2021 02:14:36 +0100
Message-Id: <3554ccd235b30d568a49e180e54fcf82ee14c43d.1613956408.git.lorenzo@kernel.org>
X-Mailer: git-send-email 2.29.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Similar to mt7921, fix 802.11 aggr len debugfs reporting for mt7915 driver.

Fixes: e57b7901469fc ("mt76: add mac80211 driver for MT7915 PCIe-based chipsets")
Signed-off-by: Lorenzo Bianconi <lorenzo@kernel.org>
---
 drivers/net/wireless/mediatek/mt76/mt7915/debugfs.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/wireless/mediatek/mt76/mt7915/debugfs.c b/drivers/net/wireless/mediatek/mt76/mt7915/debugfs.c
index 77dcd71e49a5..2f706620686e 100644
--- a/drivers/net/wireless/mediatek/mt76/mt7915/debugfs.c
+++ b/drivers/net/wireless/mediatek/mt76/mt7915/debugfs.c
@@ -124,7 +124,7 @@ mt7915_ampdu_stat_read_phy(struct mt7915_phy *phy,
 		range[i] = mt76_rr(dev, MT_MIB_ARNG(ext_phy, i));
 
 	for (i = 0; i < ARRAY_SIZE(bound); i++)
-		bound[i] = MT_MIB_ARNCR_RANGE(range[i / 4], i) + 1;
+		bound[i] = MT_MIB_ARNCR_RANGE(range[i / 4], i % 4) + 1;
 
 	seq_printf(file, "\nPhy %d\n", ext_phy);
 
-- 
2.29.2

