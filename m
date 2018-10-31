Return-Path: <SRS0=7415=NL=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4F369C0044C
	for <linux-wireless@archiver.kernel.org>; Wed, 31 Oct 2018 07:33:04 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 0EAF620840
	for <linux-wireless@archiver.kernel.org>; Wed, 31 Oct 2018 07:33:04 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 0EAF620840
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=redhat.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-wireless-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726201AbeJaQ37 (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Wed, 31 Oct 2018 12:29:59 -0400
Received: from mx1.redhat.com ([209.132.183.28]:60268 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725955AbeJaQ37 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 31 Oct 2018 12:29:59 -0400
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id CA6814E91C;
        Wed, 31 Oct 2018 07:33:02 +0000 (UTC)
Received: from localhost (ovpn-204-170.brq.redhat.com [10.40.204.170])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 89ABB1001914;
        Wed, 31 Oct 2018 07:32:59 +0000 (UTC)
From:   Stanislaw Gruszka <sgruszka@redhat.com>
To:     Felix Fietkau <nbd@nbd.name>
Cc:     Lorenzo Bianconi <lorenzo.bianconi@redhat.com>,
        linux-wireless@vger.kernel.org
Subject: [PATCH] mt76x0: do not overwrite other MT_BBP(AGC, 8) fields
Date:   Wed, 31 Oct 2018 08:32:58 +0100
Message-Id: <1540971178-16407-1-git-send-email-sgruszka@redhat.com>
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.38]); Wed, 31 Oct 2018 07:33:02 +0000 (UTC)
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

MT_BBP(AGC, 8) register has values depend on band in
mt76x0_bbp_switch_tab, so we should not overwrite other fields
than MT_BBP_AGC_GAIN when setting gain.

This can fix performance issues when connecting to 2.4GHz AP.

Fixes: 4636a2544c3b ("mt76x0: phy: align channel gain logic to mt76x2 one")
Signed-off-by: Stanislaw Gruszka <sgruszka@redhat.com>
---
 drivers/net/wireless/mediatek/mt76/mt76x0/phy.c | 4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff --git a/drivers/net/wireless/mediatek/mt76/mt76x0/phy.c b/drivers/net/wireless/mediatek/mt76/mt76x0/phy.c
index ba98814ae47d..88dd0aa7e877 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76x0/phy.c
+++ b/drivers/net/wireless/mediatek/mt76/mt76x0/phy.c
@@ -690,10 +690,8 @@ static void mt76x0_phy_temp_sensor(struct mt76x02_dev *dev)
 static void mt76x0_phy_set_gain_val(struct mt76x02_dev *dev)
 {
 	u8 gain = dev->cal.agc_gain_cur[0] - dev->cal.agc_gain_adjust;
-	u32 val = 0x122c << 16 | 0xf2;
 
-	mt76_wr(dev, MT_BBP(AGC, 8),
-		val | FIELD_PREP(MT_BBP_AGC_GAIN, gain));
+	mt76_rmw_field(dev, MT_BBP(AGC, 8), MT_BBP_AGC_GAIN, gain);
 
 	if ((dev->mt76.chandef.chan->flags & IEEE80211_CHAN_RADAR) &&
 	    !is_mt7630(dev))
-- 
2.7.5

