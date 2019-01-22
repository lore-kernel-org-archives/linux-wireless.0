Return-Path: <SRS0=0pM2=P6=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5554BC282C5
	for <linux-wireless@archiver.kernel.org>; Tue, 22 Jan 2019 12:38:54 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 29F3621019
	for <linux-wireless@archiver.kernel.org>; Tue, 22 Jan 2019 12:38:54 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728451AbfAVMix (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Tue, 22 Jan 2019 07:38:53 -0500
Received: from mx1.redhat.com ([209.132.183.28]:46112 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728446AbfAVMix (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 22 Jan 2019 07:38:53 -0500
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id AC0C790919;
        Tue, 22 Jan 2019 12:38:52 +0000 (UTC)
Received: from localhost (unknown [10.43.2.219])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 4CBE060920;
        Tue, 22 Jan 2019 12:38:52 +0000 (UTC)
From:   Stanislaw Gruszka <sgruszka@redhat.com>
To:     stable@vger.kernel.org
Cc:     Felix Fietkau <nbd@nbd.name>, linux-wireless@vger.kernel.org,
        Lorenzo Bianconi <lorenzo.bianconi@redhat.com>
Subject: [PATCH 4.20.x 5/7] mt76x0: do not perform MCU calibration for MT7630
Date:   Tue, 22 Jan 2019 13:38:35 +0100
Message-Id: <1548160717-4059-6-git-send-email-sgruszka@redhat.com>
In-Reply-To: <1548160717-4059-1-git-send-email-sgruszka@redhat.com>
References: <1548160717-4059-1-git-send-email-sgruszka@redhat.com>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.29]); Tue, 22 Jan 2019 12:38:52 +0000 (UTC)
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

commit a83150eaad42769e4d08b6e07956a489e40214ae upstream.

Driver works better for MT7630 without MCU calibration, which
looks like it can hangs the firmware. Vendor driver do not
perform it for MT7630 as well.

Signed-off-by: Felix Fietkau <nbd@nbd.name>
Signed-off-by: Stanislaw Gruszka <sgruszka@redhat.com>
---
 drivers/net/wireless/mediatek/mt76/mt76x0/mt76x0.h | 5 +++++
 drivers/net/wireless/mediatek/mt76/mt76x0/phy.c    | 3 +++
 2 files changed, 8 insertions(+)

diff --git a/drivers/net/wireless/mediatek/mt76/mt76x0/mt76x0.h b/drivers/net/wireless/mediatek/mt76/mt76x0/mt76x0.h
index 2187bafaf2e9..0057f69d0c36 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76x0/mt76x0.h
+++ b/drivers/net/wireless/mediatek/mt76/mt76x0/mt76x0.h
@@ -41,6 +41,11 @@ static inline bool is_mt7610e(struct mt76x02_dev *dev)
 
 void mt76x0_init_debugfs(struct mt76x02_dev *dev);
 
+static inline bool is_mt7630(struct mt76x02_dev *dev)
+{
+	return mt76_chip(&dev->mt76) == 0x7630;
+}
+
 /* Init */
 struct mt76x02_dev *
 mt76x0_alloc_device(struct device *pdev,
diff --git a/drivers/net/wireless/mediatek/mt76/mt76x0/phy.c b/drivers/net/wireless/mediatek/mt76/mt76x0/phy.c
index f99097e265aa..d598ddc632cc 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76x0/phy.c
+++ b/drivers/net/wireless/mediatek/mt76/mt76x0/phy.c
@@ -588,6 +588,9 @@ void mt76x0_phy_calibrate(struct mt76x02_dev *dev, bool power_on)
 	int is_5ghz = (chan->band == NL80211_BAND_5GHZ) ? 1 : 0;
 	u32 val, tx_alc, reg_val;
 
+	if (is_mt7630(dev))
+		return;
+
 	if (power_on) {
 		mt76x02_mcu_calibrate(dev, MCU_CAL_R, 0, false);
 		mt76x02_mcu_calibrate(dev, MCU_CAL_VCO, chan->hw_value,
-- 
1.9.3

