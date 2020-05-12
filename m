Return-Path: <SRS0=ks57=62=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.3 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2EF0CCA90AF
	for <linux-wireless@archiver.kernel.org>; Tue, 12 May 2020 19:39:23 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id E9DFA20731
	for <linux-wireless@archiver.kernel.org>; Tue, 12 May 2020 19:39:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1589312363;
	bh=cEO2UxS+58IVwrtFxpvwa4vTrrz+8SPKSk8iWUrc3Hs=;
	h=From:To:Cc:Subject:Date:List-ID:From;
	b=avFbSj/ebn8nDu/ABN+WDPVHyydTMoJW94nX6EnuAjg5HjC21IRJShecnKXm773do
	 JlyoCxhySmILSoXJlHIXnBRymawfSKQ6Jh42n4E7B6LM2Y/p4kbrBgjvsAyctz+inu
	 sM9EL3zIa3UkJxjOVvybojmUQ1iuT2Q0ijZhP0Wk=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725987AbgELTjW (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Tue, 12 May 2020 15:39:22 -0400
Received: from mail.kernel.org ([198.145.29.99]:38274 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725554AbgELTjU (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 12 May 2020 15:39:20 -0400
Received: from localhost.localdomain.com (unknown [151.48.155.206])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 0B67120740;
        Tue, 12 May 2020 19:39:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1589312360;
        bh=cEO2UxS+58IVwrtFxpvwa4vTrrz+8SPKSk8iWUrc3Hs=;
        h=From:To:Cc:Subject:Date:From;
        b=0w44dNpd/1VkDBn68+V3GYcYgpz8ALBmsu7Uf6RbxcH8Ki107RNA9Ep5ZUUyZGJS7
         ZV+YeiutSbLsjtmTi422s+LJpAfm2EDA7m4kVPsEcG10i6u5NVG1q9SsigRsLNb0wU
         gLD+AXvTWOJsjBbmIWo0kx1kkG2vYGQJvLv4vL74=
From:   Lorenzo Bianconi <lorenzo@kernel.org>
To:     nbd@nbd.name
Cc:     linux-wireless@vger.kernel.org, lorenzo.bianconi@redhat.com,
        sean.wang@mediatek.com, linux-mediatek@lists.infradead.org
Subject: [PATCH] mt76: mt7663: fix the usage WoW with net detect support
Date:   Tue, 12 May 2020 21:39:13 +0200
Message-Id: <b2f1eeb63059e5b337a1f1996f0fd9890fef1955.1589312203.git.lorenzo@kernel.org>
X-Mailer: git-send-email 2.26.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

From: Sean Wang <sean.wang@mediatek.com>

mt7615_mcu_sched_scan_enable should be taken along with
mt7615_mcu_sched_scan_req to have proper scan plans initialization.

Fixes: bd39bd2f00c3 ("mt76: mt7663: introduce WoW with net detect support")
Co-developed-by: Wan-Feng Jiang <Wan-Feng.Jiang@mediatek.com>
Signed-off-by: Wan-Feng Jiang <Wan-Feng.Jiang@mediatek.com>
Co-developed-by: Soul Huang <Soul.Huang@mediatek.com>
Signed-off-by: Soul Huang <Soul.Huang@mediatek.com>
Signed-off-by: Sean Wang <sean.wang@mediatek.com>
Signed-off-by: Lorenzo Bianconi <lorenzo@kernel.org>
---
 drivers/net/wireless/mediatek/mt76/mt7615/mcu.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/wireless/mediatek/mt76/mt7615/mcu.c b/drivers/net/wireless/mediatek/mt76/mt7615/mcu.c
index 96bf39a4a3da..ef50b9a885f4 100644
--- a/drivers/net/wireless/mediatek/mt76/mt7615/mcu.c
+++ b/drivers/net/wireless/mediatek/mt76/mt7615/mcu.c
@@ -3351,8 +3351,8 @@ mt7615_mcu_set_wow_ctrl(struct mt7615_phy *phy, struct ieee80211_vif *vif,
 	if (wowlan->nd_config) {
 		mt7615_mcu_sched_scan_req(phy, vif, wowlan->nd_config);
 		req.wow_ctrl_tlv.trigger |= BIT(5);
+		mt7615_mcu_sched_scan_enable(phy, vif, suspend);
 	}
-	mt7615_mcu_sched_scan_enable(phy, vif, suspend);
 
 	if (mt76_is_mmio(&dev->mt76))
 		req.wow_ctrl_tlv.wakeup_hif = 2;
-- 
2.26.2

