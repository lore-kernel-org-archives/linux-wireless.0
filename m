Return-Path: <SRS0=sJ5f=TE=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,
	T_DKIMWL_WL_HIGH,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5744FC43219
	for <linux-wireless@archiver.kernel.org>; Sat,  4 May 2019 15:29:40 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 2221D2086C
	for <linux-wireless@archiver.kernel.org>; Sat,  4 May 2019 15:29:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1556983780;
	bh=hyDm8ogsdnAzWmVidK6Orxk1673PNKBDGs7f+Tb92ag=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:List-ID:From;
	b=Q5Cm5wLmF8KmkimzQ2LkLtYVPtQ+C6r247sitnYhV2G+mDd3uUPtoVphWtQicEUty
	 SyjOlAU9f22BEGvthNdPkJRhr7qKHqJpf4gHWpEnU6CzgxeHfruTNXLa6VWyQkeoiU
	 XaVDI0bAkER58LSNEmeLDqyFK1vyiOC94nP2Q2wA=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726996AbfEDP3j (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Sat, 4 May 2019 11:29:39 -0400
Received: from mail.kernel.org ([198.145.29.99]:49472 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726763AbfEDP3i (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Sat, 4 May 2019 11:29:38 -0400
Received: from lore-desk-wlan.lan (unknown [151.66.59.15])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id A4C1C2086A;
        Sat,  4 May 2019 15:29:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1556983777;
        bh=hyDm8ogsdnAzWmVidK6Orxk1673PNKBDGs7f+Tb92ag=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=BoyrV8m7g+DD1feieEOhua4TRqoqHCUvi2Pneaf0Bfp/fXpX2aARq0lmTZhY1I3P9
         Hr377B1ArskZuyWgBUASGUX2B8leN7at5a5K33Wouz7RZe2CPmfQ80Q4SqTkgv3/ix
         hEq2dS9YSZiCYiLqeyU/BPGvL3pzMb/H6ZK1tDiM=
From:   Lorenzo Bianconi <lorenzo@kernel.org>
To:     nbd@nbd.name
Cc:     lorenzo.bianconi@redhat.com, linux-wireless@vger.kernel.org,
        ryder.lee@mediatek.com, royluo@google.com
Subject: [PATCH 07/17] mt7615: mcu: remove unused parameter in mt7615_mcu_del_wtbl
Date:   Sat,  4 May 2019 17:28:59 +0200
Message-Id: <919d16d56ac4b354644fd99f2e8473c429349054.1556981521.git.lorenzo@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <cover.1556981521.git.lorenzo@kernel.org>
References: <cover.1556981521.git.lorenzo@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Remove unused vif parameter in mt7615_mcu_del_wtbl signature

Signed-off-by: Lorenzo Bianconi <lorenzo@kernel.org>
---
 drivers/net/wireless/mediatek/mt76/mt7615/main.c   | 2 +-
 drivers/net/wireless/mediatek/mt76/mt7615/mcu.c    | 2 +-
 drivers/net/wireless/mediatek/mt76/mt7615/mt7615.h | 3 +--
 3 files changed, 3 insertions(+), 4 deletions(-)

diff --git a/drivers/net/wireless/mediatek/mt76/mt7615/main.c b/drivers/net/wireless/mediatek/mt76/mt7615/main.c
index c45ab9980b69..d6b350a248f9 100644
--- a/drivers/net/wireless/mediatek/mt76/mt7615/main.c
+++ b/drivers/net/wireless/mediatek/mt76/mt7615/main.c
@@ -336,7 +336,7 @@ void mt7615_sta_remove(struct mt76_dev *mdev, struct ieee80211_vif *vif,
 	struct mt7615_dev *dev = container_of(mdev, struct mt7615_dev, mt76);
 
 	mt7615_mcu_set_sta_rec(dev, vif, sta, 0);
-	mt7615_mcu_del_wtbl(dev, vif, sta);
+	mt7615_mcu_del_wtbl(dev, sta);
 }
 
 static void mt7615_sta_rate_tbl_update(struct ieee80211_hw *hw,
diff --git a/drivers/net/wireless/mediatek/mt76/mt7615/mcu.c b/drivers/net/wireless/mediatek/mt76/mt7615/mcu.c
index b1062c7fd5d1..b6f16ac16041 100644
--- a/drivers/net/wireless/mediatek/mt76/mt7615/mcu.c
+++ b/drivers/net/wireless/mediatek/mt76/mt7615/mcu.c
@@ -1060,7 +1060,7 @@ int mt7615_mcu_add_wtbl(struct mt7615_dev *dev, struct ieee80211_vif *vif,
 				     sizeof(struct wtbl_rx));
 }
 
-int mt7615_mcu_del_wtbl(struct mt7615_dev *dev, struct ieee80211_vif *vif,
+int mt7615_mcu_del_wtbl(struct mt7615_dev *dev,
 			struct ieee80211_sta *sta)
 {
 	struct mt7615_sta *msta = (struct mt7615_sta *)sta->drv_priv;
diff --git a/drivers/net/wireless/mediatek/mt76/mt7615/mt7615.h b/drivers/net/wireless/mediatek/mt76/mt7615/mt7615.h
index 2331f0a9bc65..81501cb64f1f 100644
--- a/drivers/net/wireless/mediatek/mt76/mt7615/mt7615.h
+++ b/drivers/net/wireless/mediatek/mt76/mt7615/mt7615.h
@@ -122,8 +122,7 @@ int mt7615_mcu_wtbl_bmc(struct mt7615_dev *dev, struct ieee80211_vif *vif,
 			bool enable);
 int mt7615_mcu_add_wtbl(struct mt7615_dev *dev, struct ieee80211_vif *vif,
 			struct ieee80211_sta *sta);
-int mt7615_mcu_del_wtbl(struct mt7615_dev *dev, struct ieee80211_vif *vif,
-			struct ieee80211_sta *sta);
+int mt7615_mcu_del_wtbl(struct mt7615_dev *dev, struct ieee80211_sta *sta);
 int mt7615_mcu_del_wtbl_all(struct mt7615_dev *dev);
 int mt7615_mcu_set_sta_rec_bmc(struct mt7615_dev *dev,
 			       struct ieee80211_vif *vif, bool en);
-- 
2.20.1

