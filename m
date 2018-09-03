Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx3-rdu2.redhat.com ([66.187.233.73]:55190 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726052AbeICOpy (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 3 Sep 2018 10:45:54 -0400
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.rdu2.redhat.com [10.11.54.6])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id B86EB87916
        for <linux-wireless@vger.kernel.org>; Mon,  3 Sep 2018 10:26:22 +0000 (UTC)
From: Stanislaw Gruszka <sgruszka@redhat.com>
To: linux-wireless@vger.kernel.org
Cc: Stanislaw Gruszka <sgruszka@redhat.com>
Subject: [PATCH 4.19] mt76x0: fix remove_interface
Date: Mon,  3 Sep 2018 12:26:21 +0200
Message-Id: <1535970381-5526-1-git-send-email-sgruszka@redhat.com> (sfid-20180903_122628_571753_6E215F2A)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

We wrongly use wcid_mask instead of vif_mask

Fixes: 95e444098a7b ("mt76x0: main file")
Reported-and-tested-by: Sid Hayn <sidhayn@gmail.com>
Signed-off-by: Stanislaw Gruszka <sgruszka@redhat.com>
---
 drivers/net/wireless/mediatek/mt76/mt76x0/main.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/net/wireless/mediatek/mt76/mt76x0/main.c b/drivers/net/wireless/mediatek/mt76/mt76x0/main.c
index cf6ffb1ba4a2..22bc9d368728 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76x0/main.c
+++ b/drivers/net/wireless/mediatek/mt76/mt76x0/main.c
@@ -77,9 +77,8 @@ static void mt76x0_remove_interface(struct ieee80211_hw *hw,
 {
 	struct mt76x0_dev *dev = hw->priv;
 	struct mt76_vif *mvif = (struct mt76_vif *) vif->drv_priv;
-	unsigned int wcid = mvif->group_wcid.idx;
 
-	dev->wcid_mask[wcid / BITS_PER_LONG] &= ~BIT(wcid % BITS_PER_LONG);
+	dev->vif_mask &= ~BIT(mvif->idx);
 }
 
 static int mt76x0_config(struct ieee80211_hw *hw, u32 changed)
-- 
2.7.5
