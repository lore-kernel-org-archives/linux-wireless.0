Return-Path: <SRS0=k7+a=M4=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 313AAC04EBD
	for <linux-wireless@archiver.kernel.org>; Tue, 16 Oct 2018 07:58:50 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 0176920869
	for <linux-wireless@archiver.kernel.org>; Tue, 16 Oct 2018 07:58:49 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 0176920869
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=redhat.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-wireless-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727014AbeJPPr7 (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Tue, 16 Oct 2018 11:47:59 -0400
Received: from mx1.redhat.com ([209.132.183.28]:41656 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726934AbeJPPr7 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 16 Oct 2018 11:47:59 -0400
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id B237D30A5A51;
        Tue, 16 Oct 2018 07:58:48 +0000 (UTC)
Received: from localhost (unknown [10.43.2.63])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 615D562488;
        Tue, 16 Oct 2018 07:58:45 +0000 (UTC)
From:   Stanislaw Gruszka <sgruszka@redhat.com>
To:     Felix Fietkau <nbd@nbd.name>
Cc:     linux-wireless@vger.kernel.org,
        Lorenzo Bianconi <lorenzo.bianconi@redhat.com>
Subject: [PATCH] mt76x0: do not perform MCU calibration for MT7630
Date:   Tue, 16 Oct 2018 09:58:43 +0200
Message-Id: <1539676723-4113-1-git-send-email-sgruszka@redhat.com>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.47]); Tue, 16 Oct 2018 07:58:48 +0000 (UTC)
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Driver works better for MT7630 without MCU calibration, which
looks like it can hangs the firmware. Vendor driver do not
perform it for MT7630 as well.

Signed-off-by: Stanislaw Gruszka <sgruszka@redhat.com>
---
This is on top of:
https://marc.info/?l=linux-wireless&m=153960591116586&w=2

 drivers/net/wireless/mediatek/mt76/mt76x0/mt76x0.h | 5 +++++
 drivers/net/wireless/mediatek/mt76/mt76x0/phy.c    | 3 +++
 2 files changed, 8 insertions(+)

diff --git a/drivers/net/wireless/mediatek/mt76/mt76x0/mt76x0.h b/drivers/net/wireless/mediatek/mt76/mt76x0/mt76x0.h
index 17ad3fa0858b..33475788bc26 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76x0/mt76x0.h
+++ b/drivers/net/wireless/mediatek/mt76/mt76x0/mt76x0.h
@@ -37,6 +37,11 @@ static inline bool is_mt7610e(struct mt76x02_dev *dev)
 	return false;
 }
 
+static inline bool is_mt7630(struct mt76x02_dev *dev)
+{
+	return mt76_chip(&dev->mt76) == 0x7630;
+}
+
 /* Init */
 struct mt76x02_dev *
 mt76x0_alloc_device(struct device *pdev,
diff --git a/drivers/net/wireless/mediatek/mt76/mt76x0/phy.c b/drivers/net/wireless/mediatek/mt76/mt76x0/phy.c
index dbb92586b6e1..37e1ead1dc85 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76x0/phy.c
+++ b/drivers/net/wireless/mediatek/mt76/mt76x0/phy.c
@@ -500,6 +500,9 @@ void mt76x0_phy_calibrate(struct mt76x02_dev *dev, bool power_on)
 	struct ieee80211_channel *chan = dev->mt76.chandef.chan;
 	u32 val, tx_alc, reg_val;
 
+	if (is_mt7630(dev))
+		return;
+
 	if (power_on) {
 		mt76x02_mcu_calibrate(dev, MCU_CAL_R, 0, false);
 		mt76x02_mcu_calibrate(dev, MCU_CAL_VCO, chan->hw_value,
-- 
1.9.3

