Return-Path: <SRS0=HAyh=NM=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 39AFCC0044C
	for <linux-wireless@archiver.kernel.org>; Thu,  1 Nov 2018 15:35:09 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id D46A32081B
	for <linux-wireless@archiver.kernel.org>; Thu,  1 Nov 2018 15:35:08 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org D46A32081B
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=redhat.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-wireless-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728632AbeKBAif (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Thu, 1 Nov 2018 20:38:35 -0400
Received: from mx1.redhat.com ([209.132.183.28]:56208 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727996AbeKBAif (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 1 Nov 2018 20:38:35 -0400
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 06A993154841;
        Thu,  1 Nov 2018 15:35:07 +0000 (UTC)
Received: from localhost (ovpn-204-125.brq.redhat.com [10.40.204.125])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 1A733100190B;
        Thu,  1 Nov 2018 15:35:02 +0000 (UTC)
From:   Stanislaw Gruszka <sgruszka@redhat.com>
To:     Felix Fietkau <nbd@nbd.name>
Cc:     Lorenzo Bianconi <lorenzo.bianconi@redhat.com>,
        linux-wireless@vger.kernel.org
Subject: [PATCH v3 1/2] mt76x02: run calibration after scanning
Date:   Thu,  1 Nov 2018 16:35:01 +0100
Message-Id: <1541086502-21239-1-git-send-email-sgruszka@redhat.com>
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.41]); Thu, 01 Nov 2018 15:35:07 +0000 (UTC)
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

If we are associated and scanning is performed, sw_scan_complete callback
is done after we get back to operating channel, so we do not perform
queue cal work. Fix this queue cal work from sw_scan_complete().

On mt76x0 we have to restore gain in MT_BBP(AGC, 8) register after
scanning, as it was multiple times modified by channel switch code.
So queue cal work without any delay to set AGC gain value.

Similar like in mt76x2 init AGC gain only when set operating channel
and just check before queuing cal work in sw_scan_complete() if 
initialization was already done.

Fixes: bbd10586f0df ("mt76x0: phy: do not run calibration during channel switch")
Signed-off-by: Stanislaw Gruszka <sgruszka@redhat.com>
---
v1 -> v2:
only queue cal work with 0 delay
v2 -> v3:
- do not check for assoc, check init gain was done
- do not init agc gain for any channel in mt76x0

 drivers/net/wireless/mediatek/mt76/mt76x0/phy.c   | 2 +-
 drivers/net/wireless/mediatek/mt76/mt76x02.h      | 1 +
 drivers/net/wireless/mediatek/mt76/mt76x02_phy.c  | 1 +
 drivers/net/wireless/mediatek/mt76/mt76x02_util.c | 3 +++
 4 files changed, 6 insertions(+), 1 deletion(-)

diff --git a/drivers/net/wireless/mediatek/mt76/mt76x0/phy.c b/drivers/net/wireless/mediatek/mt76/mt76x0/phy.c
index ba3cbceb5dd2..b2cbe4f19023 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76x0/phy.c
+++ b/drivers/net/wireless/mediatek/mt76/mt76x0/phy.c
@@ -657,13 +657,13 @@ int mt76x0_phy_set_channel(struct mt76x02_dev *dev,
 
 	mt76x0_read_rx_gain(dev);
 	mt76x0_phy_set_chan_bbp_params(dev, rf_bw_band);
-	mt76x02_init_agc_gain(dev);
 
 	/* enable vco */
 	mt76x0_rf_set(dev, MT_RF(0, 4), BIT(7));
 	if (scan)
 		return 0;
 
+	mt76x02_init_agc_gain(dev);
 	mt76x0_phy_calibrate(dev, false);
 	mt76x0_phy_set_txpower(dev);
 
diff --git a/drivers/net/wireless/mediatek/mt76/mt76x02.h b/drivers/net/wireless/mediatek/mt76/mt76x02.h
index 19489a72fc2b..3a3324eb4a69 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76x02.h
+++ b/drivers/net/wireless/mediatek/mt76/mt76x02.h
@@ -57,6 +57,7 @@ struct mt76x02_calibration {
 	bool tssi_comp_pending;
 	bool dpd_cal_done;
 	bool channel_cal_done;
+	bool gain_init_done;
 };
 
 struct mt76x02_dev {
diff --git a/drivers/net/wireless/mediatek/mt76/mt76x02_phy.c b/drivers/net/wireless/mediatek/mt76/mt76x02_phy.c
index 0f1d7b5c9f68..977a8e7e26df 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76x02_phy.c
+++ b/drivers/net/wireless/mediatek/mt76/mt76x02_phy.c
@@ -254,5 +254,6 @@ void mt76x02_init_agc_gain(struct mt76x02_dev *dev)
 	memcpy(dev->cal.agc_gain_cur, dev->cal.agc_gain_init,
 	       sizeof(dev->cal.agc_gain_cur));
 	dev->cal.low_gain = -1;
+	dev->cal.gain_init_done = true;
 }
 EXPORT_SYMBOL_GPL(mt76x02_init_agc_gain);
diff --git a/drivers/net/wireless/mediatek/mt76/mt76x02_util.c b/drivers/net/wireless/mediatek/mt76/mt76x02_util.c
index adfc46419b6b..8a250224fcd7 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76x02_util.c
+++ b/drivers/net/wireless/mediatek/mt76/mt76x02_util.c
@@ -554,6 +554,9 @@ void mt76x02_sw_scan_complete(struct ieee80211_hw *hw,
 	clear_bit(MT76_SCANNING, &dev->mt76.state);
 	if (mt76_is_mmio(dev))
 		tasklet_enable(&dev->pre_tbtt_tasklet);
+
+	if (dev->cal.gain_init_done)
+		ieee80211_queue_delayed_work(hw, &dev->cal_work, 0);
 }
 EXPORT_SYMBOL_GPL(mt76x02_sw_scan_complete);
 
-- 
2.7.5

