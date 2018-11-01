Return-Path: <SRS0=HAyh=NM=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B816BC0044C
	for <linux-wireless@archiver.kernel.org>; Thu,  1 Nov 2018 15:35:14 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 89B152081B
	for <linux-wireless@archiver.kernel.org>; Thu,  1 Nov 2018 15:35:14 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 89B152081B
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=redhat.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-wireless-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728671AbeKBAil (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Thu, 1 Nov 2018 20:38:41 -0400
Received: from mx1.redhat.com ([209.132.183.28]:56946 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727996AbeKBAil (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 1 Nov 2018 20:38:41 -0400
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 816E880F8D;
        Thu,  1 Nov 2018 15:35:13 +0000 (UTC)
Received: from localhost (ovpn-204-125.brq.redhat.com [10.40.204.125])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 099DE1755D;
        Thu,  1 Nov 2018 15:35:07 +0000 (UTC)
From:   Stanislaw Gruszka <sgruszka@redhat.com>
To:     Felix Fietkau <nbd@nbd.name>
Cc:     Lorenzo Bianconi <lorenzo.bianconi@redhat.com>,
        linux-wireless@vger.kernel.org
Subject: [PATCH v3 2/2] mt76x02: assure we update gain after scan
Date:   Thu,  1 Nov 2018 16:35:02 +0100
Message-Id: <1541086502-21239-2-git-send-email-sgruszka@redhat.com>
In-Reply-To: <1541086502-21239-1-git-send-email-sgruszka@redhat.com>
References: <1541086502-21239-1-git-send-email-sgruszka@redhat.com>
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.27]); Thu, 01 Nov 2018 15:35:13 +0000 (UTC)
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Assure that after we initialize dev->cal.low_gain to -1 this
will cause update gain calibration. Otherwise this might or
might not happen depending on value of second bit of low_gain
and values read from registers in mt76x02_phy_adjust_vga_gain().

Signed-off-by: Stanislaw Gruszka <sgruszka@redhat.com>
---
 drivers/net/wireless/mediatek/mt76/mt76x0/phy.c   | 3 ++-
 drivers/net/wireless/mediatek/mt76/mt76x02_util.c | 5 ++++-
 drivers/net/wireless/mediatek/mt76/mt76x2/phy.c   | 3 ++-
 3 files changed, 8 insertions(+), 3 deletions(-)

diff --git a/drivers/net/wireless/mediatek/mt76/mt76x0/phy.c b/drivers/net/wireless/mediatek/mt76/mt76x0/phy.c
index b2cbe4f19023..7eee91bedacc 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76x0/phy.c
+++ b/drivers/net/wireless/mediatek/mt76/mt76x0/phy.c
@@ -736,7 +736,8 @@ mt76x0_phy_update_channel_gain(struct mt76x02_dev *dev)
 	low_gain = (dev->cal.avg_rssi_all > mt76x02_get_rssi_gain_thresh(dev)) +
 		   (dev->cal.avg_rssi_all > mt76x02_get_low_rssi_gain_thresh(dev));
 
-	gain_change = (dev->cal.low_gain & 2) ^ (low_gain & 2);
+	gain_change = dev->cal.low_gain < 0 ||
+		      (dev->cal.low_gain & 2) ^ (low_gain & 2);
 	dev->cal.low_gain = low_gain;
 
 	if (!gain_change) {
diff --git a/drivers/net/wireless/mediatek/mt76/mt76x02_util.c b/drivers/net/wireless/mediatek/mt76/mt76x02_util.c
index 8a250224fcd7..87ce6a51fb05 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76x02_util.c
+++ b/drivers/net/wireless/mediatek/mt76/mt76x02_util.c
@@ -555,8 +555,11 @@ void mt76x02_sw_scan_complete(struct ieee80211_hw *hw,
 	if (mt76_is_mmio(dev))
 		tasklet_enable(&dev->pre_tbtt_tasklet);
 
-	if (dev->cal.gain_init_done)
+	if (dev->cal.gain_init_done) {
+		/* Restore AGC gain and resume calibration after scanning. */
+		dev->cal.low_gain = -1;
 		ieee80211_queue_delayed_work(hw, &dev->cal_work, 0);
+	}
 }
 EXPORT_SYMBOL_GPL(mt76x02_sw_scan_complete);
 
diff --git a/drivers/net/wireless/mediatek/mt76/mt76x2/phy.c b/drivers/net/wireless/mediatek/mt76/mt76x2/phy.c
index bbeff9c19997..1b85fb415548 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76x2/phy.c
+++ b/drivers/net/wireless/mediatek/mt76/mt76x2/phy.c
@@ -289,7 +289,8 @@ void mt76x2_phy_update_channel_gain(struct mt76x02_dev *dev)
 	low_gain = (dev->cal.avg_rssi_all > mt76x02_get_rssi_gain_thresh(dev)) +
 		   (dev->cal.avg_rssi_all > mt76x02_get_low_rssi_gain_thresh(dev));
 
-	gain_change = (dev->cal.low_gain & 2) ^ (low_gain & 2);
+	gain_change = dev->cal.low_gain < 0 ||
+		      (dev->cal.low_gain & 2) ^ (low_gain & 2);
 	dev->cal.low_gain = low_gain;
 
 	if (!gain_change) {
-- 
2.7.5

