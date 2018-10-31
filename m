Return-Path: <SRS0=7415=NL=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 15009ECDE44
	for <linux-wireless@archiver.kernel.org>; Wed, 31 Oct 2018 13:11:34 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id D4F7820657
	for <linux-wireless@archiver.kernel.org>; Wed, 31 Oct 2018 13:11:33 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org D4F7820657
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=redhat.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-wireless-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729326AbeJaWJa (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Wed, 31 Oct 2018 18:09:30 -0400
Received: from mx1.redhat.com ([209.132.183.28]:38308 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729187AbeJaWJa (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 31 Oct 2018 18:09:30 -0400
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 4C4A62D7E3;
        Wed, 31 Oct 2018 13:11:32 +0000 (UTC)
Received: from localhost (unknown [10.40.205.83])
        by smtp.corp.redhat.com (Postfix) with ESMTP id A624110A0821;
        Wed, 31 Oct 2018 13:11:27 +0000 (UTC)
From:   Stanislaw Gruszka <sgruszka@redhat.com>
To:     Felix Fietkau <nbd@nbd.name>
Cc:     Lorenzo Bianconi <lorenzo.bianconi@redhat.com>,
        linux-wireless@vger.kernel.org
Subject: [PATCH v2] mt76x0: run calibration after scanning
Date:   Wed, 31 Oct 2018 14:11:26 +0100
Message-Id: <1540991486-1948-1-git-send-email-sgruszka@redhat.com>
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.30]); Wed, 31 Oct 2018 13:11:32 +0000 (UTC)
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

If we are associated and scanning is performed, sw_scan_complete callback
is done after we get back to operating channel, so we do not perform
queue cal work. Fix this queue cal work from sw_scan_complete().

We have to restore gain in MT_BBP(AGC, 8) register after scanning, as
it was multiple times modified by channel switch code. So queue cal work
without  any delay and reset dev->cal.low_gain to assure calibration
code will AGC gain value.

Note patch was not tested on mt76x2, but should work and be needed
fix as well.

Fixes: bbd10586f0df ("mt76x0: phy: do not run calibration during channel switch")
Signed-off-by: Stanislaw Gruszka <sgruszka@redhat.com>
---
v1 -> v2:
only queue cal work with 0 delay an reset dev->cal.low_gain 

 drivers/net/wireless/mediatek/mt76/mt76x02_util.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/drivers/net/wireless/mediatek/mt76/mt76x02_util.c b/drivers/net/wireless/mediatek/mt76/mt76x02_util.c
index 9f083008dbd4..747fd2c9ec45 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76x02_util.c
+++ b/drivers/net/wireless/mediatek/mt76/mt76x02_util.c
@@ -553,6 +553,12 @@ void mt76x02_sw_scan_complete(struct ieee80211_hw *hw,
 	clear_bit(MT76_SCANNING, &dev->mt76.state);
 	if (mt76_is_mmio(dev))
 		tasklet_enable(&dev->pre_tbtt_tasklet);
+
+	if (vif->bss_conf.assoc) {
+		/* Restore AGC gain and resume calibration after scanning. */
+		dev->cal.low_gain = -1;
+		ieee80211_queue_delayed_work(hw, &dev->cal_work, 0);
+	}
 }
 EXPORT_SYMBOL_GPL(mt76x02_sw_scan_complete);
 
-- 
2.7.5

