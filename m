Return-Path: <SRS0=87w+=7P=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6AE1CC433E0
	for <linux-wireless@archiver.kernel.org>; Tue,  2 Jun 2020 20:26:50 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 4330A206E2
	for <linux-wireless@archiver.kernel.org>; Tue,  2 Jun 2020 20:26:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1591129610;
	bh=FHXsp2m6HAicDywDO1cu5BvylXzSzEv1c5Arc3Bhwyg=;
	h=From:To:Cc:Subject:Date:List-ID:From;
	b=EQhtIL0aSmIzNNtLqTZWwaG7lMmHVfICjrpjJDEOK3QftljmXL6ppC/RKX39U4hGW
	 AQF/e+Lkz3rmamVI5zGk0xy4Cv/s2XTuw7/L3K4CJP9gJ2nMqf/T7FPUob2LtGu1Ts
	 K0+HbuQEdwiLD2Yt8VoOUSE+pH+feXmR1X0Lvoi4=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726647AbgFBU0t (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Tue, 2 Jun 2020 16:26:49 -0400
Received: from mail.kernel.org ([198.145.29.99]:41390 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726112AbgFBU0t (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 2 Jun 2020 16:26:49 -0400
Received: from localhost.localdomain.com (unknown [151.48.128.87])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id E6556206A2;
        Tue,  2 Jun 2020 20:26:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1591129608;
        bh=FHXsp2m6HAicDywDO1cu5BvylXzSzEv1c5Arc3Bhwyg=;
        h=From:To:Cc:Subject:Date:From;
        b=J/02ZlsvW0V6R/t/KjE1qgGKTTpYoJm3aMkNBZYk/R4qxxAjQ03eVV7xzgPz0J3hY
         RCyVeusW+LDQPMHsQyJkLprRGPTfk+7Ys0DnoLlSUJqVQuWy66SeZKW9klV7iQ2emh
         1+W1t/bVmSy9uY4BCwi3B/jv+N+/jmDcTI9y5d/8=
From:   Lorenzo Bianconi <lorenzo@kernel.org>
To:     nbd@nbd.name
Cc:     linux-wireless@vger.kernel.org, lorenzo.bianconi@redhat.com,
        ryder.lee@mediatek.com, sean.wang@mediatek.com
Subject: [PATCH] mt76: add missing lock configuring coverage class
Date:   Tue,  2 Jun 2020 22:26:38 +0200
Message-Id: <abc46a2c0a1ae1d31e47111439e4e82fdf3e2a43.1591129549.git.lorenzo@kernel.org>
X-Mailer: git-send-email 2.26.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Coverage class callback can potentially run in parallel with other
routines (e.g. mt7615_set_channel) that configures timing registers.
Run coverage class callback holding mt76 mutex

Signed-off-by: Lorenzo Bianconi <lorenzo@kernel.org>
---
 drivers/net/wireless/mediatek/mt76/mt7603/main.c | 2 ++
 drivers/net/wireless/mediatek/mt76/mt7615/main.c | 3 +++
 drivers/net/wireless/mediatek/mt76/mt7915/main.c | 3 +++
 3 files changed, 8 insertions(+)

diff --git a/drivers/net/wireless/mediatek/mt76/mt7603/main.c b/drivers/net/wireless/mediatek/mt76/mt7603/main.c
index 26cb711b465f..83dfa6da4761 100644
--- a/drivers/net/wireless/mediatek/mt76/mt7603/main.c
+++ b/drivers/net/wireless/mediatek/mt76/mt7603/main.c
@@ -642,8 +642,10 @@ mt7603_set_coverage_class(struct ieee80211_hw *hw, s16 coverage_class)
 {
 	struct mt7603_dev *dev = hw->priv;
 
+	mutex_lock(&dev->mt76.mutex);
 	dev->coverage_class = max_t(s16, coverage_class, 0);
 	mt7603_mac_set_timing(dev);
+	mutex_unlock(&dev->mt76.mutex);
 }
 
 static void mt7603_tx(struct ieee80211_hw *hw,
diff --git a/drivers/net/wireless/mediatek/mt76/mt7615/main.c b/drivers/net/wireless/mediatek/mt76/mt7615/main.c
index 6c7aed51bcfd..81fc4982a01f 100644
--- a/drivers/net/wireless/mediatek/mt76/mt7615/main.c
+++ b/drivers/net/wireless/mediatek/mt76/mt7615/main.c
@@ -739,9 +739,12 @@ static void
 mt7615_set_coverage_class(struct ieee80211_hw *hw, s16 coverage_class)
 {
 	struct mt7615_phy *phy = mt7615_hw_phy(hw);
+	struct mt7615_dev *dev = phy->dev;
 
+	mutex_lock(&dev->mt76.mutex);
 	phy->coverage_class = max_t(s16, coverage_class, 0);
 	mt7615_mac_set_timing(phy);
+	mutex_unlock(&dev->mt76.mutex);
 }
 
 static int
diff --git a/drivers/net/wireless/mediatek/mt76/mt7915/main.c b/drivers/net/wireless/mediatek/mt76/mt7915/main.c
index 0575c259f245..05b5650c56c8 100644
--- a/drivers/net/wireless/mediatek/mt76/mt7915/main.c
+++ b/drivers/net/wireless/mediatek/mt76/mt7915/main.c
@@ -716,9 +716,12 @@ static void
 mt7915_set_coverage_class(struct ieee80211_hw *hw, s16 coverage_class)
 {
 	struct mt7915_phy *phy = mt7915_hw_phy(hw);
+	struct mt7915_dev *dev = phy->dev;
 
+	mutex_lock(&dev->mt76.mutex);
 	phy->coverage_class = max_t(s16, coverage_class, 0);
 	mt7915_mac_set_timing(phy);
+	mutex_unlock(&dev->mt76.mutex);
 }
 
 static int
-- 
2.26.2

