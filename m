Return-Path: <SRS0=49bh=RV=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 71C11C43381
	for <linux-wireless@archiver.kernel.org>; Mon, 18 Mar 2019 10:21:57 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 2F4E92070D
	for <linux-wireless@archiver.kernel.org>; Mon, 18 Mar 2019 10:21:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1552904517;
	bh=NqvDyyDqadDqh9Z+QWaPHjktE4I1nZHCHkfc953zowA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:List-ID:From;
	b=ICZC83eazVqxTCJjd0hV52a1Ah1Obu+5fGNMz0OyHf4IzQoWyipTAyQraDuyZb+rc
	 z9E1w9oo3EdBUt7o+G9vmYfjXKFyAZ/5150d73hDWH2It0L8DkGvS2ZsQ4vwpnL/wj
	 C2szsiKxFQCs5hHqQVqynmBsNufxTxXK01nNLDSs=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727203AbfCRKV4 (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Mon, 18 Mar 2019 06:21:56 -0400
Received: from mail.kernel.org ([198.145.29.99]:38268 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727151AbfCRKV4 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 18 Mar 2019 06:21:56 -0400
Received: from localhost.localdomain (unknown [151.66.48.245])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 939122070D;
        Mon, 18 Mar 2019 10:21:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1552904514;
        bh=NqvDyyDqadDqh9Z+QWaPHjktE4I1nZHCHkfc953zowA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=bWcgQEybxcb5NzS+sRQqJMIEAiOwsbCw8CHyy4ZQfpCczQibF29I4DGWSt7ewogi3
         XmDKdELJSTlF8XVmYrcGuWwcMLh3S63Z2TtToApPDmKcpU/EuOW18rqmp2WmP6ApqY
         /8SSf7rNxLyJZ90kuzCUx3KVbexDsblOMOyFlW9k=
From:   Lorenzo Bianconi <lorenzo@kernel.org>
To:     nbd@nbd.name
Cc:     linux-wireless@vger.kernel.org, lorenzo.bianconi@redhat.com,
        sgruszka@redhat.com
Subject: [PATCH v2] mt76: move mac_work in mt76_dev
Date:   Mon, 18 Mar 2019 11:21:44 +0100
Message-Id: <d4eb4aa6f8f8b003442b4f04b0f659e612486263.1552903068.git.lorenzo@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <cover.1552903068.git.lorenzo@kernel.org>
References: <cover.1552903068.git.lorenzo@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Move mac_work delayed work in mt76_dev data structure since
it is used by all drivers and it will be reused adding mac work to
mt7615

Signed-off-by: Lorenzo Bianconi <lorenzo@kernel.org>
---
Changes since v1:
- drop typecast in mt7603_mac_work/mt76x02_mac_work
- rebase on top of https://patchwork.kernel.org/patch/10856027/
---
 drivers/net/wireless/mediatek/mt76/mt76.h            |  1 +
 drivers/net/wireless/mediatek/mt76/mt7603/init.c     |  2 +-
 drivers/net/wireless/mediatek/mt76/mt7603/mac.c      |  4 ++--
 drivers/net/wireless/mediatek/mt76/mt7603/main.c     | 10 +++++-----
 drivers/net/wireless/mediatek/mt76/mt7603/mt7603.h   |  1 -
 drivers/net/wireless/mediatek/mt76/mt76x0/pci.c      |  4 ++--
 drivers/net/wireless/mediatek/mt76/mt76x0/usb.c      |  4 ++--
 drivers/net/wireless/mediatek/mt76/mt76x02.h         |  1 -
 drivers/net/wireless/mediatek/mt76/mt76x02_mac.c     |  4 ++--
 drivers/net/wireless/mediatek/mt76/mt76x02_util.c    |  2 +-
 drivers/net/wireless/mediatek/mt76/mt76x2/pci_init.c |  2 +-
 drivers/net/wireless/mediatek/mt76/mt76x2/pci_main.c |  2 +-
 drivers/net/wireless/mediatek/mt76/mt76x2/usb_init.c |  2 +-
 drivers/net/wireless/mediatek/mt76/mt76x2/usb_main.c |  2 +-
 14 files changed, 20 insertions(+), 21 deletions(-)

diff --git a/drivers/net/wireless/mediatek/mt76/mt76.h b/drivers/net/wireless/mediatek/mt76/mt76.h
index 54e1e50eb4d2..2128c82c413b 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76.h
+++ b/drivers/net/wireless/mediatek/mt76/mt76.h
@@ -458,6 +458,7 @@ struct mt76_dev {
 	int tx_dma_idx[4];
 
 	struct tasklet_struct tx_tasklet;
+	struct delayed_work mac_work;
 
 	wait_queue_head_t tx_wait;
 	struct sk_buff_head status_list;
diff --git a/drivers/net/wireless/mediatek/mt76/mt7603/init.c b/drivers/net/wireless/mediatek/mt76/mt7603/init.c
index e17b6b89dfe2..a25a13a39640 100644
--- a/drivers/net/wireless/mediatek/mt76/mt7603/init.c
+++ b/drivers/net/wireless/mediatek/mt76/mt7603/init.c
@@ -510,7 +510,7 @@ int mt7603_register_device(struct mt7603_dev *dev)
 	bus_ops->rmw = mt7603_rmw;
 	dev->mt76.bus = bus_ops;
 
-	INIT_DELAYED_WORK(&dev->mac_work, mt7603_mac_work);
+	INIT_DELAYED_WORK(&dev->mt76.mac_work, mt7603_mac_work);
 	tasklet_init(&dev->pre_tbtt_tasklet, mt7603_pre_tbtt_tasklet,
 		     (unsigned long)dev);
 
diff --git a/drivers/net/wireless/mediatek/mt76/mt7603/mac.c b/drivers/net/wireless/mediatek/mt76/mt7603/mac.c
index 2badfe527397..1d6e2ba5925e 100644
--- a/drivers/net/wireless/mediatek/mt76/mt7603/mac.c
+++ b/drivers/net/wireless/mediatek/mt76/mt7603/mac.c
@@ -1696,7 +1696,7 @@ mt7603_false_cca_check(struct mt7603_dev *dev)
 void mt7603_mac_work(struct work_struct *work)
 {
 	struct mt7603_dev *dev = container_of(work, struct mt7603_dev,
-					      mac_work.work);
+					      mt76.mac_work.work);
 	bool reset = false;
 
 	mt76_tx_status_check(&dev->mt76, NULL, false);
@@ -1749,6 +1749,6 @@ void mt7603_mac_work(struct work_struct *work)
 	if (reset)
 		mt7603_mac_watchdog_reset(dev);
 
-	ieee80211_queue_delayed_work(mt76_hw(dev), &dev->mac_work,
+	ieee80211_queue_delayed_work(mt76_hw(dev), &dev->mt76.mac_work,
 				     msecs_to_jiffies(MT7603_WATCHDOG_TIME));
 }
diff --git a/drivers/net/wireless/mediatek/mt76/mt7603/main.c b/drivers/net/wireless/mediatek/mt76/mt7603/main.c
index 3754723190d5..e5fca95193e9 100644
--- a/drivers/net/wireless/mediatek/mt76/mt7603/main.c
+++ b/drivers/net/wireless/mediatek/mt76/mt7603/main.c
@@ -16,7 +16,7 @@ mt7603_start(struct ieee80211_hw *hw)
 	mt7603_mac_start(dev);
 	dev->survey_time = ktime_get_boottime();
 	set_bit(MT76_STATE_RUNNING, &dev->mt76.state);
-	mt7603_mac_work(&dev->mac_work.work);
+	mt7603_mac_work(&dev->mt76.mac_work.work);
 
 	return 0;
 }
@@ -27,7 +27,7 @@ mt7603_stop(struct ieee80211_hw *hw)
 	struct mt7603_dev *dev = hw->priv;
 
 	clear_bit(MT76_STATE_RUNNING, &dev->mt76.state);
-	cancel_delayed_work_sync(&dev->mac_work);
+	cancel_delayed_work_sync(&dev->mt76.mac_work);
 	mt7603_mac_stop(dev);
 }
 
@@ -132,7 +132,7 @@ mt7603_set_channel(struct mt7603_dev *dev, struct cfg80211_chan_def *def)
 	u8 bw = MT_BW_20;
 	bool failed = false;
 
-	cancel_delayed_work_sync(&dev->mac_work);
+	cancel_delayed_work_sync(&dev->mt76.mac_work);
 
 	mutex_lock(&dev->mt76.mutex);
 	set_bit(MT76_RESET, &dev->mt76.state);
@@ -171,7 +171,7 @@ mt7603_set_channel(struct mt7603_dev *dev, struct cfg80211_chan_def *def)
 
 	mt76_txq_schedule_all(&dev->mt76);
 
-	ieee80211_queue_delayed_work(mt76_hw(dev), &dev->mac_work,
+	ieee80211_queue_delayed_work(mt76_hw(dev), &dev->mt76.mac_work,
 				     MT7603_WATCHDOG_TIME);
 
 	/* reset channel stats */
@@ -189,7 +189,7 @@ mt7603_set_channel(struct mt7603_dev *dev, struct cfg80211_chan_def *def)
 	mutex_unlock(&dev->mt76.mutex);
 
 	if (failed)
-		mt7603_mac_work(&dev->mac_work.work);
+		mt7603_mac_work(&dev->mt76.mac_work.work);
 
 	return ret;
 }
diff --git a/drivers/net/wireless/mediatek/mt76/mt7603/mt7603.h b/drivers/net/wireless/mediatek/mt76/mt7603/mt7603.h
index 3848a011105f..1559ca122b9a 100644
--- a/drivers/net/wireless/mediatek/mt76/mt7603/mt7603.h
+++ b/drivers/net/wireless/mediatek/mt76/mt7603/mt7603.h
@@ -144,7 +144,6 @@ struct mt7603_dev {
 
 	unsigned int reset_cause[__RESET_CAUSE_MAX];
 
-	struct delayed_work mac_work;
 	struct tasklet_struct pre_tbtt_tasklet;
 };
 
diff --git a/drivers/net/wireless/mediatek/mt76/mt76x0/pci.c b/drivers/net/wireless/mediatek/mt76/mt76x0/pci.c
index e07a62246db7..b934a974df32 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76x0/pci.c
+++ b/drivers/net/wireless/mediatek/mt76/mt76x0/pci.c
@@ -29,7 +29,7 @@ static int mt76x0e_start(struct ieee80211_hw *hw)
 
 	mt76x02_mac_start(dev);
 	mt76x0_phy_calibrate(dev, true);
-	ieee80211_queue_delayed_work(dev->mt76.hw, &dev->mac_work,
+	ieee80211_queue_delayed_work(dev->mt76.hw, &dev->mt76.mac_work,
 				     MT_MAC_WORK_INTERVAL);
 	ieee80211_queue_delayed_work(dev->mt76.hw, &dev->cal_work,
 				     MT_CALIBRATE_INTERVAL);
@@ -43,7 +43,7 @@ static int mt76x0e_start(struct ieee80211_hw *hw)
 static void mt76x0e_stop_hw(struct mt76x02_dev *dev)
 {
 	cancel_delayed_work_sync(&dev->cal_work);
-	cancel_delayed_work_sync(&dev->mac_work);
+	cancel_delayed_work_sync(&dev->mt76.mac_work);
 
 	if (!mt76_poll(dev, MT_WPDMA_GLO_CFG, MT_WPDMA_GLO_CFG_TX_DMA_BUSY,
 		       0, 1000))
diff --git a/drivers/net/wireless/mediatek/mt76/mt76x0/usb.c b/drivers/net/wireless/mediatek/mt76/mt76x0/usb.c
index ff887454e51e..619fc3ecdd5d 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76x0/usb.c
+++ b/drivers/net/wireless/mediatek/mt76/mt76x0/usb.c
@@ -85,7 +85,7 @@ static void mt76x0u_mac_stop(struct mt76x02_dev *dev)
 {
 	clear_bit(MT76_STATE_RUNNING, &dev->mt76.state);
 	cancel_delayed_work_sync(&dev->cal_work);
-	cancel_delayed_work_sync(&dev->mac_work);
+	cancel_delayed_work_sync(&dev->mt76.mac_work);
 	mt76u_stop_stat_wk(&dev->mt76);
 
 	if (test_bit(MT76_REMOVED, &dev->mt76.state))
@@ -116,7 +116,7 @@ static int mt76x0u_start(struct ieee80211_hw *hw)
 		goto out;
 
 	mt76x0_phy_calibrate(dev, true);
-	ieee80211_queue_delayed_work(dev->mt76.hw, &dev->mac_work,
+	ieee80211_queue_delayed_work(dev->mt76.hw, &dev->mt76.mac_work,
 				     MT_MAC_WORK_INTERVAL);
 	ieee80211_queue_delayed_work(dev->mt76.hw, &dev->cal_work,
 				     MT_CALIBRATE_INTERVAL);
diff --git a/drivers/net/wireless/mediatek/mt76/mt76x02.h b/drivers/net/wireless/mediatek/mt76/mt76x02.h
index cb5792b41d2d..8e17fbb6fd04 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76x02.h
+++ b/drivers/net/wireless/mediatek/mt76/mt76x02.h
@@ -85,7 +85,6 @@ struct mt76x02_dev {
 	struct tasklet_struct tx_tasklet;
 	struct tasklet_struct pre_tbtt_tasklet;
 	struct delayed_work cal_work;
-	struct delayed_work mac_work;
 	struct delayed_work wdt_work;
 
 	u32 aggr_stats[32];
diff --git a/drivers/net/wireless/mediatek/mt76/mt76x02_mac.c b/drivers/net/wireless/mediatek/mt76/mt76x02_mac.c
index 8e5f920deef1..ef9432a12302 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76x02_mac.c
+++ b/drivers/net/wireless/mediatek/mt76/mt76x02_mac.c
@@ -1032,7 +1032,7 @@ static void mt76x02_edcca_check(struct mt76x02_dev *dev)
 void mt76x02_mac_work(struct work_struct *work)
 {
 	struct mt76x02_dev *dev = container_of(work, struct mt76x02_dev,
-					       mac_work.work);
+					       mt76.mac_work.work);
 	int i, idx;
 
 	mutex_lock(&dev->mt76.mutex);
@@ -1055,7 +1055,7 @@ void mt76x02_mac_work(struct work_struct *work)
 
 	mt76_tx_status_check(&dev->mt76, NULL, false);
 
-	ieee80211_queue_delayed_work(mt76_hw(dev), &dev->mac_work,
+	ieee80211_queue_delayed_work(mt76_hw(dev), &dev->mt76.mac_work,
 				     MT_MAC_WORK_INTERVAL);
 }
 
diff --git a/drivers/net/wireless/mediatek/mt76/mt76x02_util.c b/drivers/net/wireless/mediatek/mt76/mt76x02_util.c
index 079ac265ef26..d76544834420 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76x02_util.c
+++ b/drivers/net/wireless/mediatek/mt76/mt76x02_util.c
@@ -132,7 +132,7 @@ void mt76x02_init_device(struct mt76x02_dev *dev)
 	struct ieee80211_hw *hw = mt76_hw(dev);
 	struct wiphy *wiphy = hw->wiphy;
 
-	INIT_DELAYED_WORK(&dev->mac_work, mt76x02_mac_work);
+	INIT_DELAYED_WORK(&dev->mt76.mac_work, mt76x02_mac_work);
 
 	hw->queues = 4;
 	hw->max_rates = 1;
diff --git a/drivers/net/wireless/mediatek/mt76/mt76x2/pci_init.c b/drivers/net/wireless/mediatek/mt76/mt76x2/pci_init.c
index d3927a13e92e..9661e9ba734d 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76x2/pci_init.c
+++ b/drivers/net/wireless/mediatek/mt76/mt76x2/pci_init.c
@@ -291,7 +291,7 @@ static int mt76x2_init_hardware(struct mt76x02_dev *dev)
 void mt76x2_stop_hardware(struct mt76x02_dev *dev)
 {
 	cancel_delayed_work_sync(&dev->cal_work);
-	cancel_delayed_work_sync(&dev->mac_work);
+	cancel_delayed_work_sync(&dev->mt76.mac_work);
 	cancel_delayed_work_sync(&dev->wdt_work);
 	mt76x02_mcu_set_radio_state(dev, false);
 	mt76x2_mac_stop(dev, false);
diff --git a/drivers/net/wireless/mediatek/mt76/mt76x2/pci_main.c b/drivers/net/wireless/mediatek/mt76/mt76x2/pci_main.c
index 878ce92405ed..ef42743364e4 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76x2/pci_main.c
+++ b/drivers/net/wireless/mediatek/mt76/mt76x2/pci_main.c
@@ -32,7 +32,7 @@ mt76x2_start(struct ieee80211_hw *hw)
 	if (ret)
 		goto out;
 
-	ieee80211_queue_delayed_work(mt76_hw(dev), &dev->mac_work,
+	ieee80211_queue_delayed_work(mt76_hw(dev), &dev->mt76.mac_work,
 				     MT_MAC_WORK_INTERVAL);
 	ieee80211_queue_delayed_work(mt76_hw(dev), &dev->wdt_work,
 				     MT_WATCHDOG_TIME);
diff --git a/drivers/net/wireless/mediatek/mt76/mt76x2/usb_init.c b/drivers/net/wireless/mediatek/mt76/mt76x2/usb_init.c
index 1da90e58d942..4bfd958b4334 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76x2/usb_init.c
+++ b/drivers/net/wireless/mediatek/mt76/mt76x2/usb_init.c
@@ -246,7 +246,7 @@ void mt76x2u_stop_hw(struct mt76x02_dev *dev)
 {
 	mt76u_stop_stat_wk(&dev->mt76);
 	cancel_delayed_work_sync(&dev->cal_work);
-	cancel_delayed_work_sync(&dev->mac_work);
+	cancel_delayed_work_sync(&dev->mt76.mac_work);
 	mt76x2u_mac_stop(dev);
 }
 
diff --git a/drivers/net/wireless/mediatek/mt76/mt76x2/usb_main.c b/drivers/net/wireless/mediatek/mt76/mt76x2/usb_main.c
index 2ac78e4dc41a..5f746c8df906 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76x2/usb_main.c
+++ b/drivers/net/wireless/mediatek/mt76/mt76x2/usb_main.c
@@ -27,7 +27,7 @@ static int mt76x2u_start(struct ieee80211_hw *hw)
 	if (ret)
 		goto out;
 
-	ieee80211_queue_delayed_work(mt76_hw(dev), &dev->mac_work,
+	ieee80211_queue_delayed_work(mt76_hw(dev), &dev->mt76.mac_work,
 				     MT_MAC_WORK_INTERVAL);
 	set_bit(MT76_STATE_RUNNING, &dev->mt76.state);
 
-- 
2.20.1

