Return-Path: <SRS0=0pM2=P6=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E0A74C282C3
	for <linux-wireless@archiver.kernel.org>; Tue, 22 Jan 2019 12:38:45 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id C09AD20870
	for <linux-wireless@archiver.kernel.org>; Tue, 22 Jan 2019 12:38:45 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728444AbfAVMip (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Tue, 22 Jan 2019 07:38:45 -0500
Received: from mx1.redhat.com ([209.132.183.28]:56790 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728209AbfAVMio (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 22 Jan 2019 07:38:44 -0500
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 25FA8C00D727;
        Tue, 22 Jan 2019 12:38:44 +0000 (UTC)
Received: from localhost (unknown [10.43.2.219])
        by smtp.corp.redhat.com (Postfix) with ESMTP id B97931C923;
        Tue, 22 Jan 2019 12:38:43 +0000 (UTC)
From:   Stanislaw Gruszka <sgruszka@redhat.com>
To:     stable@vger.kernel.org
Cc:     Felix Fietkau <nbd@nbd.name>, linux-wireless@vger.kernel.org,
        Lorenzo Bianconi <lorenzo.bianconi@redhat.com>
Subject: [PATCH 4.20.x 3/7] mt76x02: run calibration after scanning
Date:   Tue, 22 Jan 2019 13:38:33 +0100
Message-Id: <1548160717-4059-4-git-send-email-sgruszka@redhat.com>
In-Reply-To: <1548160717-4059-1-git-send-email-sgruszka@redhat.com>
References: <1548160717-4059-1-git-send-email-sgruszka@redhat.com>
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.31]); Tue, 22 Jan 2019 12:38:44 +0000 (UTC)
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

commit f1b8ee35fec4a070b7760a99709fc98f237c2b86 upstream.

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
Signed-off-by: Felix Fietkau <nbd@nbd.name>
Signed-off-by: Stanislaw Gruszka <sgruszka@redhat.com>
---
 drivers/net/wireless/mediatek/mt76/mt76x0/main.c     | 3 +++
 drivers/net/wireless/mediatek/mt76/mt76x0/phy.c      | 2 +-
 drivers/net/wireless/mediatek/mt76/mt76x02.h         | 1 +
 drivers/net/wireless/mediatek/mt76/mt76x02_phy.c     | 1 +
 drivers/net/wireless/mediatek/mt76/mt76x2/usb_main.c | 3 +++
 5 files changed, 9 insertions(+), 1 deletion(-)

diff --git a/drivers/net/wireless/mediatek/mt76/mt76x0/main.c b/drivers/net/wireless/mediatek/mt76/mt76x0/main.c
index 9273d2d2764a..205c3afe2aeb 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76x0/main.c
+++ b/drivers/net/wireless/mediatek/mt76/mt76x0/main.c
@@ -138,6 +138,9 @@ void mt76x0_sw_scan_complete(struct ieee80211_hw *hw,
 	struct mt76x02_dev *dev = hw->priv;
 
 	clear_bit(MT76_SCANNING, &dev->mt76.state);
+
+	if (dev->cal.gain_init_done)
+		ieee80211_queue_delayed_work(hw, &dev->cal_work, 0);
 }
 EXPORT_SYMBOL_GPL(mt76x0_sw_scan_complete);
 
diff --git a/drivers/net/wireless/mediatek/mt76/mt76x0/phy.c b/drivers/net/wireless/mediatek/mt76/mt76x0/phy.c
index b1314c0f74c8..771e54b39abf 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76x0/phy.c
+++ b/drivers/net/wireless/mediatek/mt76/mt76x0/phy.c
@@ -720,7 +720,6 @@ int mt76x0_phy_set_channel(struct mt76x02_dev *dev,
 
 	mt76x0_read_rx_gain(dev);
 	mt76x0_phy_set_chan_bbp_params(dev, rf_bw_band);
-	mt76x02_init_agc_gain(dev);
 
 	if (mt76_is_usb(dev)) {
 		mt76x0_vco_cal(dev, channel);
@@ -732,6 +731,7 @@ int mt76x0_phy_set_channel(struct mt76x02_dev *dev,
 	if (scan)
 		return 0;
 
+	mt76x02_init_agc_gain(dev);
 	if (mt76_is_mmio(dev))
 		mt76x0_phy_calibrate(dev, false);
 	mt76x0_phy_set_txpower(dev);
diff --git a/drivers/net/wireless/mediatek/mt76/mt76x02.h b/drivers/net/wireless/mediatek/mt76/mt76x02.h
index 7806963b1905..9a5ae5c06840 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76x02.h
+++ b/drivers/net/wireless/mediatek/mt76/mt76x02.h
@@ -63,6 +63,7 @@ struct mt76x02_calibration {
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
diff --git a/drivers/net/wireless/mediatek/mt76/mt76x2/usb_main.c b/drivers/net/wireless/mediatek/mt76/mt76x2/usb_main.c
index 1971a1b00038..9471b44ce558 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76x2/usb_main.c
+++ b/drivers/net/wireless/mediatek/mt76/mt76x2/usb_main.c
@@ -156,6 +156,9 @@ static int mt76x2u_add_interface(struct ieee80211_hw *hw,
 	struct mt76x02_dev *dev = hw->priv;
 
 	clear_bit(MT76_SCANNING, &dev->mt76.state);
+
+	if (dev->cal.gain_init_done)
+		ieee80211_queue_delayed_work(hw, &dev->cal_work, 0);
 }
 
 const struct ieee80211_ops mt76x2u_ops = {
-- 
1.9.3

