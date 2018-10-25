Return-Path: <SRS0=+bZT=NF=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5C3A8C46475
	for <linux-wireless@archiver.kernel.org>; Thu, 25 Oct 2018 16:18:41 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 18F0620848
	for <linux-wireless@archiver.kernel.org>; Thu, 25 Oct 2018 16:18:41 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 18F0620848
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=redhat.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-wireless-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727837AbeJZAwF (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Thu, 25 Oct 2018 20:52:05 -0400
Received: from mx1.redhat.com ([209.132.183.28]:60046 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727834AbeJZAwE (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 25 Oct 2018 20:52:04 -0400
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 35DBF3084032;
        Thu, 25 Oct 2018 16:18:37 +0000 (UTC)
Received: from localhost (ovpn-204-18.brq.redhat.com [10.40.204.18])
        by smtp.corp.redhat.com (Postfix) with ESMTP id DB072608EC;
        Thu, 25 Oct 2018 16:18:34 +0000 (UTC)
From:   Stanislaw Gruszka <sgruszka@redhat.com>
To:     Felix Fietkau <nbd@nbd.name>
Cc:     Lorenzo Bianconi <lorenzo.bianconi@redhat.com>,
        linux-wireless@vger.kernel.org
Subject: [PATCH] mt76x0: use band parameter for LC calibration
Date:   Thu, 25 Oct 2018 18:18:33 +0200
Message-Id: <1540484313-9354-1-git-send-email-sgruszka@redhat.com>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.40]); Thu, 25 Oct 2018 16:18:37 +0000 (UTC)
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

We use always 1 as band parameter for MCU_CAL_LC, this break 2GHz,
we should use 0 for this band instead.

Patch fixes problems happened sometimes when try to associate with 2GHz
AP and manifest by errors like below:

[14680.920823] wlan0: authenticate with 18:31:bf:c0:51:b0
[14681.109506] wlan0: send auth to 18:31:bf:c0:51:b0 (try 1/3)
[14681.310454] wlan0: send auth to 18:31:bf:c0:51:b0 (try 2/3)
[14681.518469] wlan0: send auth to 18:31:bf:c0:51:b0 (try 3/3)
[14681.726499] wlan0: authentication with 18:31:bf:c0:51:b0 timed out

Fixes: 9aec146d0f6b ("mt76x0: pci: introduce mt76x0_phy_calirate routine")
Signed-off-by: Stanislaw Gruszka <sgruszka@redhat.com>
---
This is for 4.20.

 drivers/net/wireless/mediatek/mt76/mt76x0/phy.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/mediatek/mt76/mt76x0/phy.c b/drivers/net/wireless/mediatek/mt76/mt76x0/phy.c
index c734987a344c..ca24b5716b58 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76x0/phy.c
+++ b/drivers/net/wireless/mediatek/mt76/mt76x0/phy.c
@@ -522,6 +522,7 @@ void mt76x0_phy_set_txpower(struct mt76x02_dev *dev)
 void mt76x0_phy_calibrate(struct mt76x02_dev *dev, bool power_on)
 {
 	struct ieee80211_channel *chan = dev->mt76.chandef.chan;
+	int is_5ghz = (chan->band == NL80211_BAND_5GHZ) ? 1 : 0;
 	u32 val, tx_alc, reg_val;
 
 	if (is_mt7630(dev))
@@ -542,7 +543,7 @@ void mt76x0_phy_calibrate(struct mt76x02_dev *dev, bool power_on)
 	reg_val = mt76_rr(dev, MT_BBP(IBI, 9));
 	mt76_wr(dev, MT_BBP(IBI, 9), 0xffffff7e);
 
-	if (chan->band == NL80211_BAND_5GHZ) {
+	if (is_5ghz) {
 		if (chan->hw_value < 100)
 			val = 0x701;
 		else if (chan->hw_value < 140)
@@ -555,7 +556,7 @@ void mt76x0_phy_calibrate(struct mt76x02_dev *dev, bool power_on)
 
 	mt76x02_mcu_calibrate(dev, MCU_CAL_FULL, val, false);
 	msleep(350);
-	mt76x02_mcu_calibrate(dev, MCU_CAL_LC, 1, false);
+	mt76x02_mcu_calibrate(dev, MCU_CAL_LC, is_5ghz, false);
 	usleep_range(15000, 20000);
 
 	mt76_wr(dev, MT_BBP(IBI, 9), reg_val);
-- 
2.7.5

