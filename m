Return-Path: <SRS0=B3tD=AH=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 21305C433E0
	for <linux-wireless@archiver.kernel.org>; Fri, 26 Jun 2020 21:25:54 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id EF48D20B80
	for <linux-wireless@archiver.kernel.org>; Fri, 26 Jun 2020 21:25:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1593206754;
	bh=B4urpNBnbqrJc3aTZLtJhAEvtRQLx1H/USypH4b6B04=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:List-ID:From;
	b=qzbkpTy4y+oEgHTmQOAaR86ujH3f3Wu7Fbc3UBi7KOTye0hV5Vb0bf+9R5ZTSWFuQ
	 kxs8qxevdOOvkC+sqd5aQTjE8iRRjkA6VJxF4Lk/OJRvQzi5Ga1tlOT7kffHoKwlvt
	 QuGbqCn/hYP7dbUpCA7MxUIj+4FUFcGp4q5TkzzQ=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726373AbgFZVZw (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Fri, 26 Jun 2020 17:25:52 -0400
Received: from mail.kernel.org ([198.145.29.99]:33934 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726385AbgFZVZu (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 26 Jun 2020 17:25:50 -0400
Received: from localhost.localdomain.com (unknown [151.48.138.186])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 3739E20B1F;
        Fri, 26 Jun 2020 21:25:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1593206750;
        bh=B4urpNBnbqrJc3aTZLtJhAEvtRQLx1H/USypH4b6B04=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=R4lKw8JWMBLkj3cef0GODGfmG5aMA50icbMAPWk38f9JeK6rBT9bW9LoxfT6QK5+x
         4Bk7ajyds0wyB8V0J7AuyuspFQb9Ek7puINRAJdZrgk52K87/cneHjF4KzSYCbn5Xd
         DsypIGHCkC1tEnFS/9jsrZ3/cnxNSBlfOXtThukk=
From:   Lorenzo Bianconi <lorenzo@kernel.org>
To:     nbd@nbd.name
Cc:     linux-wireless@vger.kernel.org, lorenzo.bianconi@redhat.com,
        sean.wang@mediatek.com, ryder.lee@mediatek.com,
        linux-mediatek@lists.infradead.org
Subject: [PATCH 10/17] mt76: mt7615: wake device before pulling packets from mac80211 queues
Date:   Fri, 26 Jun 2020 23:25:10 +0200
Message-Id: <5bd9536f6518a3b21ee0029777b4d9a84c0b44e7.1593204577.git.lorenzo@kernel.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <cover.1593204577.git.lorenzo@kernel.org>
References: <cover.1593204577.git.lorenzo@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Make sure the device is in full-power before pulling frames from
mac80211 queues

Signed-off-by: Lorenzo Bianconi <lorenzo@kernel.org>
---
 .../net/wireless/mediatek/mt76/mt7615/mac.c   |  6 +++++-
 .../net/wireless/mediatek/mt76/mt7615/main.c  | 20 ++++++++++++++++++-
 2 files changed, 24 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/mediatek/mt76/mt7615/mac.c b/drivers/net/wireless/mediatek/mt76/mt7615/mac.c
index acefcc2e571a..0a16acf40cf8 100644
--- a/drivers/net/wireless/mediatek/mt76/mt7615/mac.c
+++ b/drivers/net/wireless/mediatek/mt76/mt7615/mac.c
@@ -1841,9 +1841,13 @@ void mt7615_pm_wake_work(struct work_struct *work)
 						pm.wake_work);
 	mphy = dev->phy.mt76;
 
-	if (mt7615_driver_own(dev))
+	if (mt7615_driver_own(dev)) {
 		dev_err(mphy->dev->dev, "failed to wake device\n");
+		goto out;
+	}
 
+	tasklet_schedule(&dev->mt76.tx_tasklet);
+out:
 	complete_all(&dev->pm.wake_cmpl);
 }
 
diff --git a/drivers/net/wireless/mediatek/mt76/mt7615/main.c b/drivers/net/wireless/mediatek/mt76/mt7615/main.c
index e63c2584b326..9c17026c541d 100644
--- a/drivers/net/wireless/mediatek/mt76/mt7615/main.c
+++ b/drivers/net/wireless/mediatek/mt76/mt7615/main.c
@@ -635,6 +635,24 @@ static void mt7615_sta_rate_tbl_update(struct ieee80211_hw *hw,
 	spin_unlock_bh(&dev->mt76.lock);
 }
 
+static void
+mt7615_wake_tx_queue(struct ieee80211_hw *hw, struct ieee80211_txq *txq)
+{
+	struct mt7615_dev *dev = mt7615_hw_dev(hw);
+	struct mt7615_phy *phy = mt7615_hw_phy(hw);
+	struct mt76_phy *mphy = phy->mt76;
+
+	if (!test_bit(MT76_STATE_RUNNING, &mphy->state))
+		return;
+
+	if (test_bit(MT76_STATE_PM, &mphy->state)) {
+		queue_work(dev->mt76.wq, &dev->pm.wake_work);
+		return;
+	}
+
+	tasklet_schedule(&dev->mt76.tx_tasklet);
+}
+
 static void mt7615_tx(struct ieee80211_hw *hw,
 		      struct ieee80211_tx_control *control,
 		      struct sk_buff *skb)
@@ -1097,7 +1115,7 @@ const struct ieee80211_ops mt7615_ops = {
 	.set_key = mt7615_set_key,
 	.ampdu_action = mt7615_ampdu_action,
 	.set_rts_threshold = mt7615_set_rts_threshold,
-	.wake_tx_queue = mt76_wake_tx_queue,
+	.wake_tx_queue = mt7615_wake_tx_queue,
 	.sta_rate_tbl_update = mt7615_sta_rate_tbl_update,
 	.sw_scan_start = mt76_sw_scan,
 	.sw_scan_complete = mt76_sw_scan_complete,
-- 
2.26.2

