Return-Path: <linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-19.7 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C2814C4338F
	for <linux-wireless@archiver.kernel.org>; Fri, 20 Aug 2021 08:38:11 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id AA8B46113E
	for <linux-wireless@archiver.kernel.org>; Fri, 20 Aug 2021 08:38:11 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233617AbhHTIir (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Fri, 20 Aug 2021 04:38:47 -0400
Received: from mail.kernel.org ([198.145.29.99]:53064 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231963AbhHTIij (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 20 Aug 2021 04:38:39 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 0B21A61130;
        Fri, 20 Aug 2021 08:38:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1629448682;
        bh=GeripngIwAb3s3BUMXnfWW8gLCyFQps4yhTgrtrC97A=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=iZzPK3TwPz5PCttHSHHUDBO55Mq9dciCfTvyU28ijfPSPvNou3Tb6f7OlMsYysR7W
         rp3tJ1Tp+JkVg4BGBQaxLtddK/xMu/3801HpMFCC9yBJ4e5b6uzeYDLfpOZ3Zyr66A
         FO4guRrWDR6BWbBTtQzUTYCl5MQQXanj7KT3lgj0znIPeocWVifFqiwa/HHVjzJfj8
         P+hpX1vIAMm6XQ9j4AHQXyXMlmNs1Q0xuOQdu8Mhr2kkHg/bn84Vbn3JWh73P9G7Sp
         8Asy49WbV4INM83Ia/wOQsJAGhDf6q16hzQSO8IIqysRaIvwcB9Z3JALVM4Tt2fyLn
         AonO7Ju7zTqVg==
From:   Lorenzo Bianconi <lorenzo@kernel.org>
To:     nbd@nbd.name
Cc:     linux-wireless@vger.kernel.org, lorenzo.bianconi@redhat.com,
        sean.wang@mediatek.com, Deren.Wu@mediatek.com
Subject: [PATCH v3 5/5] mt76: mt7921: remove mt7921_sta_stats
Date:   Fri, 20 Aug 2021 10:37:45 +0200
Message-Id: <f90bbeb7fdafcbcb749d62ce42fac4e13ee62b7e.1629448559.git.lorenzo@kernel.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <cover.1629448559.git.lorenzo@kernel.org>
References: <cover.1629448559.git.lorenzo@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

mt7921_sta_stats is no longer needed

Signed-off-by: Lorenzo Bianconi <lorenzo@kernel.org>
---
 drivers/net/wireless/mediatek/mt76/mt7921/mac.c    |  4 ++--
 drivers/net/wireless/mediatek/mt76/mt7921/main.c   |  2 +-
 drivers/net/wireless/mediatek/mt76/mt7921/mt7921.h | 12 +-----------
 3 files changed, 4 insertions(+), 14 deletions(-)

diff --git a/drivers/net/wireless/mediatek/mt76/mt7921/mac.c b/drivers/net/wireless/mediatek/mt76/mt7921/mac.c
index 762e6ee4be1d..55b7a52cd232 100644
--- a/drivers/net/wireless/mediatek/mt76/mt7921/mac.c
+++ b/drivers/net/wireless/mediatek/mt76/mt7921/mac.c
@@ -968,9 +968,9 @@ int mt7921_tx_prepare_skb(struct mt76_dev *mdev, void *txwi_ptr,
 	if (sta) {
 		struct mt7921_sta *msta = (struct mt7921_sta *)sta->drv_priv;
 
-		if (time_after(jiffies, msta->stats.jiffies + HZ / 4)) {
+		if (time_after(jiffies, msta->last_txs + HZ / 4)) {
 			info->flags |= IEEE80211_TX_CTL_REQ_TX_STATUS;
-			msta->stats.jiffies = jiffies;
+			msta->last_txs = jiffies;
 		}
 	}
 
diff --git a/drivers/net/wireless/mediatek/mt76/mt7921/main.c b/drivers/net/wireless/mediatek/mt76/mt7921/main.c
index 8a7b4e78c097..217ed7055aa0 100644
--- a/drivers/net/wireless/mediatek/mt76/mt7921/main.c
+++ b/drivers/net/wireless/mediatek/mt76/mt7921/main.c
@@ -586,7 +586,7 @@ int mt7921_mac_sta_add(struct mt76_dev *mdev, struct ieee80211_vif *vif,
 	msta->wcid.idx = idx;
 	msta->wcid.ext_phy = mvif->mt76.band_idx;
 	msta->wcid.tx_info |= MT_WCID_TX_INFO_SET;
-	msta->stats.jiffies = jiffies;
+	msta->last_txs = jiffies;
 
 	ret = mt76_connac_pm_wake(&dev->mphy, &dev->pm);
 	if (ret)
diff --git a/drivers/net/wireless/mediatek/mt76/mt7921/mt7921.h b/drivers/net/wireless/mediatek/mt76/mt7921/mt7921.h
index 61fa53af3840..a6caca73fdda 100644
--- a/drivers/net/wireless/mediatek/mt76/mt7921/mt7921.h
+++ b/drivers/net/wireless/mediatek/mt76/mt7921/mt7921.h
@@ -65,15 +65,6 @@ enum mt7921_rxq_id {
 	MT7921_RXQ_MCU_WM = 0,
 };
 
-struct mt7921_sta_stats {
-	struct rate_info prob_rate;
-	struct rate_info tx_rate;
-
-	unsigned long per;
-	unsigned long changed;
-	unsigned long jiffies;
-};
-
 struct mt7921_sta_key_conf {
 	s8 keyidx;
 	u8 key[16];
@@ -87,8 +78,7 @@ struct mt7921_sta {
 	struct list_head poll_list;
 	u32 airtime_ac[8];
 
-	struct mt7921_sta_stats stats;
-
+	unsigned long last_txs;
 	unsigned long ampdu_state;
 
 	struct mt7921_sta_key_conf bip;
-- 
2.31.1

