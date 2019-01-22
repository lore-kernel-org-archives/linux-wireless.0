Return-Path: <SRS0=0pM2=P6=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8536BC282C5
	for <linux-wireless@archiver.kernel.org>; Tue, 22 Jan 2019 12:38:52 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 519552085A
	for <linux-wireless@archiver.kernel.org>; Tue, 22 Jan 2019 12:38:52 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728445AbfAVMiv (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Tue, 22 Jan 2019 07:38:51 -0500
Received: from mx1.redhat.com ([209.132.183.28]:45408 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728209AbfAVMiv (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 22 Jan 2019 07:38:51 -0500
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 54E58C073D71;
        Tue, 22 Jan 2019 12:38:51 +0000 (UTC)
Received: from localhost (unknown [10.43.2.219])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 1E3BD67641;
        Tue, 22 Jan 2019 12:38:44 +0000 (UTC)
From:   Stanislaw Gruszka <sgruszka@redhat.com>
To:     stable@vger.kernel.org
Cc:     Felix Fietkau <nbd@nbd.name>, linux-wireless@vger.kernel.org,
        Lorenzo Bianconi <lorenzo.bianconi@redhat.com>
Subject: [PATCH 4.20.x 4/7] mt76x02: assure we update gain after scan
Date:   Tue, 22 Jan 2019 13:38:34 +0100
Message-Id: <1548160717-4059-5-git-send-email-sgruszka@redhat.com>
In-Reply-To: <1548160717-4059-1-git-send-email-sgruszka@redhat.com>
References: <1548160717-4059-1-git-send-email-sgruszka@redhat.com>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.32]); Tue, 22 Jan 2019 12:38:51 +0000 (UTC)
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

commit 4784a3cc3fffd0ba5ef6c7a23980ae0318fc1369 upstream.

Assure that after we initialize dev->cal.low_gain to -1 this
will cause update gain calibration. Otherwise this might or
might not happen depending on value of second bit of low_gain
and values read from registers in mt76x02_phy_adjust_vga_gain().

Signed-off-by: Felix Fietkau <nbd@nbd.name>
Signed-off-by: Stanislaw Gruszka <sgruszka@redhat.com>
---
 drivers/net/wireless/mediatek/mt76/mt76x0/main.c | 5 ++++-
 drivers/net/wireless/mediatek/mt76/mt76x0/phy.c  | 3 ++-
 2 files changed, 6 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/mediatek/mt76/mt76x0/main.c b/drivers/net/wireless/mediatek/mt76/mt76x0/main.c
index 205c3afe2aeb..4126ac5d9a8a 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76x0/main.c
+++ b/drivers/net/wireless/mediatek/mt76/mt76x0/main.c
@@ -139,8 +139,11 @@ void mt76x0_sw_scan_complete(struct ieee80211_hw *hw,
 
 	clear_bit(MT76_SCANNING, &dev->mt76.state);
 
-	if (dev->cal.gain_init_done)
+	if (dev->cal.gain_init_done) {
+		/* Restore AGC gain and resume calibration after scanning. */
+		dev->cal.low_gain = -1;
 		ieee80211_queue_delayed_work(hw, &dev->cal_work, 0);
+	}
 }
 EXPORT_SYMBOL_GPL(mt76x0_sw_scan_complete);
 
diff --git a/drivers/net/wireless/mediatek/mt76/mt76x0/phy.c b/drivers/net/wireless/mediatek/mt76/mt76x0/phy.c
index 771e54b39abf..f99097e265aa 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76x0/phy.c
+++ b/drivers/net/wireless/mediatek/mt76/mt76x0/phy.c
@@ -834,7 +834,8 @@ static void mt76x0_phy_set_gain_val(struct mt76x02_dev *dev)
 	low_gain = (dev->cal.avg_rssi_all > mt76x02_get_rssi_gain_thresh(dev)) +
 		   (dev->cal.avg_rssi_all > mt76x02_get_low_rssi_gain_thresh(dev));
 
-	gain_change = (dev->cal.low_gain & 2) ^ (low_gain & 2);
+	gain_change = dev->cal.low_gain < 0 ||
+		      (dev->cal.low_gain & 2) ^ (low_gain & 2);
 	dev->cal.low_gain = low_gain;
 
 	if (!gain_change) {
-- 
1.9.3

