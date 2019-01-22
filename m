Return-Path: <SRS0=0pM2=P6=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 84F8BC282C3
	for <linux-wireless@archiver.kernel.org>; Tue, 22 Jan 2019 12:38:44 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 5636020870
	for <linux-wireless@archiver.kernel.org>; Tue, 22 Jan 2019 12:38:44 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728440AbfAVMin (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Tue, 22 Jan 2019 07:38:43 -0500
Received: from mx1.redhat.com ([209.132.183.28]:43416 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728209AbfAVMim (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 22 Jan 2019 07:38:42 -0500
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id C6C0C88319;
        Tue, 22 Jan 2019 12:38:42 +0000 (UTC)
Received: from localhost (unknown [10.43.2.219])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 65D831C923;
        Tue, 22 Jan 2019 12:38:42 +0000 (UTC)
From:   Stanislaw Gruszka <sgruszka@redhat.com>
To:     stable@vger.kernel.org
Cc:     Felix Fietkau <nbd@nbd.name>, linux-wireless@vger.kernel.org,
        Lorenzo Bianconi <lorenzo.bianconi@redhat.com>
Subject: [PATCH 4.20.x 2/7] mt76x0: use band parameter for LC calibration
Date:   Tue, 22 Jan 2019 13:38:32 +0100
Message-Id: <1548160717-4059-3-git-send-email-sgruszka@redhat.com>
In-Reply-To: <1548160717-4059-1-git-send-email-sgruszka@redhat.com>
References: <1548160717-4059-1-git-send-email-sgruszka@redhat.com>
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.28]); Tue, 22 Jan 2019 12:38:42 +0000 (UTC)
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

commit ad3f993a0857ad3b792e7463828eb0d90cdd6f4d upstream.

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
Signed-off-by: Stanislaw Gruszka <sgruszka@redhat.com>
---
 drivers/net/wireless/mediatek/mt76/mt76x0/phy.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/mediatek/mt76/mt76x0/phy.c b/drivers/net/wireless/mediatek/mt76/mt76x0/phy.c
index 1af2a1227924..b1314c0f74c8 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76x0/phy.c
+++ b/drivers/net/wireless/mediatek/mt76/mt76x0/phy.c
@@ -585,6 +585,7 @@ void mt76x0_phy_set_txpower(struct mt76x02_dev *dev)
 void mt76x0_phy_calibrate(struct mt76x02_dev *dev, bool power_on)
 {
 	struct ieee80211_channel *chan = dev->mt76.chandef.chan;
+	int is_5ghz = (chan->band == NL80211_BAND_5GHZ) ? 1 : 0;
 	u32 val, tx_alc, reg_val;
 
 	if (power_on) {
@@ -602,7 +603,7 @@ void mt76x0_phy_calibrate(struct mt76x02_dev *dev, bool power_on)
 	reg_val = mt76_rr(dev, MT_BBP(IBI, 9));
 	mt76_wr(dev, MT_BBP(IBI, 9), 0xffffff7e);
 
-	if (chan->band == NL80211_BAND_5GHZ) {
+	if (is_5ghz) {
 		if (chan->hw_value < 100)
 			val = 0x701;
 		else if (chan->hw_value < 140)
@@ -615,7 +616,7 @@ void mt76x0_phy_calibrate(struct mt76x02_dev *dev, bool power_on)
 
 	mt76x02_mcu_calibrate(dev, MCU_CAL_FULL, val, false);
 	msleep(350);
-	mt76x02_mcu_calibrate(dev, MCU_CAL_LC, 1, false);
+	mt76x02_mcu_calibrate(dev, MCU_CAL_LC, is_5ghz, false);
 	usleep_range(15000, 20000);
 
 	mt76_wr(dev, MT_BBP(IBI, 9), reg_val);
-- 
1.9.3

