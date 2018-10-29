Return-Path: <SRS0=ivqe=NJ=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D0E80C0044C
	for <linux-wireless@archiver.kernel.org>; Mon, 29 Oct 2018 10:17:03 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 95BD020827
	for <linux-wireless@archiver.kernel.org>; Mon, 29 Oct 2018 10:17:03 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 95BD020827
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=redhat.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-wireless-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729686AbeJ2TFD (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Mon, 29 Oct 2018 15:05:03 -0400
Received: from mx1.redhat.com ([209.132.183.28]:30666 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729613AbeJ2TFD (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 29 Oct 2018 15:05:03 -0400
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 08500142C17;
        Mon, 29 Oct 2018 10:17:02 +0000 (UTC)
Received: from localhost (ovpn-204-127.brq.redhat.com [10.40.204.127])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 2B0351057043;
        Mon, 29 Oct 2018 10:16:53 +0000 (UTC)
From:   Stanislaw Gruszka <sgruszka@redhat.com>
To:     Felix Fietkau <nbd@nbd.name>
Cc:     Lorenzo Bianconi <lorenzo.bianconi@redhat.com>,
        linux-wireless@vger.kernel.org
Subject: [PATCH] mt76x0: run calibration after scanning
Date:   Mon, 29 Oct 2018 11:16:53 +0100
Message-Id: <1540808213-14442-1-git-send-email-sgruszka@redhat.com>
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.38]); Mon, 29 Oct 2018 10:17:02 +0000 (UTC)
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

If we are associated and scanning is performed , sw_scan_complete callback
is done after we get back to operating channel, so we do not perform
phy calibration and queue cal work. Fix this by run calibration from
sw_scan_complete().

Fixes: bbd10586f0df ("mt76x0: phy: do not run calibration during channel switch")
Signed-off-by: Stanislaw Gruszka <sgruszka@redhat.com>
---
This is for 4.20

 drivers/net/wireless/mediatek/mt76/mt76x0/main.c   | 19 +++++++++++++++++++
 drivers/net/wireless/mediatek/mt76/mt76x0/mt76x0.h |  2 ++
 drivers/net/wireless/mediatek/mt76/mt76x0/pci.c    |  2 +-
 drivers/net/wireless/mediatek/mt76/mt76x0/usb.c    |  2 +-
 4 files changed, 23 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/mediatek/mt76/mt76x0/main.c b/drivers/net/wireless/mediatek/mt76/mt76x0/main.c
index a803a9b6a4c5..896a9d46bb76 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76x0/main.c
+++ b/drivers/net/wireless/mediatek/mt76/mt76x0/main.c
@@ -78,3 +78,22 @@ int mt76x0_config(struct ieee80211_hw *hw, u32 changed)
 	return ret;
 }
 EXPORT_SYMBOL_GPL(mt76x0_config);
+
+void mt76x0_sw_scan_complete(struct ieee80211_hw *hw,
+			     struct ieee80211_vif *vif)
+{
+	struct mt76x02_dev *dev = hw->priv;
+
+	mutex_lock(&dev->mt76.mutex);
+	if (vif->bss_conf.assoc) {
+		mt76x0_phy_calibrate(dev, false);
+		mt76x0_phy_set_txpower(dev);
+
+		ieee80211_queue_delayed_work(dev->mt76.hw, &dev->cal_work,
+					     MT_CALIBRATE_INTERVAL);
+	}
+	mutex_unlock(&dev->mt76.mutex);
+
+	mt76x02_sw_scan_complete(hw, vif);
+}
+EXPORT_SYMBOL_GPL(mt76x0_sw_scan_complete);
diff --git a/drivers/net/wireless/mediatek/mt76/mt76x0/mt76x0.h b/drivers/net/wireless/mediatek/mt76/mt76x0/mt76x0.h
index 46629f61673b..d850a6702598 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76x0/mt76x0.h
+++ b/drivers/net/wireless/mediatek/mt76/mt76x0/mt76x0.h
@@ -62,6 +62,8 @@ int mt76x0_mac_start(struct mt76x02_dev *dev);
 void mt76x0_mac_stop(struct mt76x02_dev *dev);
 
 int mt76x0_config(struct ieee80211_hw *hw, u32 changed);
+void mt76x0_sw_scan_complete(struct ieee80211_hw *hw,
+			     struct ieee80211_vif *vif);
 
 /* PHY */
 void mt76x0_phy_init(struct mt76x02_dev *dev);
diff --git a/drivers/net/wireless/mediatek/mt76/mt76x0/pci.c b/drivers/net/wireless/mediatek/mt76/mt76x0/pci.c
index 757816d2b1ab..854d882f775b 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76x0/pci.c
+++ b/drivers/net/wireless/mediatek/mt76/mt76x0/pci.c
@@ -95,7 +95,7 @@ static const struct ieee80211_ops mt76x0e_ops = {
 	.set_key = mt76x02_set_key,
 	.conf_tx = mt76x02_conf_tx,
 	.sw_scan_start = mt76x02_sw_scan,
-	.sw_scan_complete = mt76x02_sw_scan_complete,
+	.sw_scan_complete = mt76x0_sw_scan_complete,
 	.ampdu_action = mt76x02_ampdu_action,
 	.sta_rate_tbl_update = mt76x02_sta_rate_tbl_update,
 	.wake_tx_queue = mt76_wake_tx_queue,
diff --git a/drivers/net/wireless/mediatek/mt76/mt76x0/usb.c b/drivers/net/wireless/mediatek/mt76/mt76x0/usb.c
index 35b98661632a..9a83d9f62012 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76x0/usb.c
+++ b/drivers/net/wireless/mediatek/mt76/mt76x0/usb.c
@@ -151,7 +151,7 @@ static const struct ieee80211_ops mt76x0u_ops = {
 	.set_key = mt76x02_set_key,
 	.conf_tx = mt76x02_conf_tx,
 	.sw_scan_start = mt76x02_sw_scan,
-	.sw_scan_complete = mt76x02_sw_scan_complete,
+	.sw_scan_complete = mt76x0_sw_scan_complete,
 	.ampdu_action = mt76x02_ampdu_action,
 	.sta_rate_tbl_update = mt76x02_sta_rate_tbl_update,
 	.set_rts_threshold = mt76x02_set_rts_threshold,
-- 
2.7.5

