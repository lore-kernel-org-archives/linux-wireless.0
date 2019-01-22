Return-Path: <SRS0=0pM2=P6=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C176CC282C4
	for <linux-wireless@archiver.kernel.org>; Tue, 22 Jan 2019 12:38:42 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 8E36E20870
	for <linux-wireless@archiver.kernel.org>; Tue, 22 Jan 2019 12:38:42 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728391AbfAVMil (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Tue, 22 Jan 2019 07:38:41 -0500
Received: from mx1.redhat.com ([209.132.183.28]:2515 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728209AbfAVMil (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 22 Jan 2019 07:38:41 -0500
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 6EEFDA85F;
        Tue, 22 Jan 2019 12:38:41 +0000 (UTC)
Received: from localhost (unknown [10.43.2.219])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 0D2F05C219;
        Tue, 22 Jan 2019 12:38:40 +0000 (UTC)
From:   Stanislaw Gruszka <sgruszka@redhat.com>
To:     stable@vger.kernel.org
Cc:     Felix Fietkau <nbd@nbd.name>, linux-wireless@vger.kernel.org,
        Lorenzo Bianconi <lorenzo.bianconi@redhat.com>
Subject: [PATCH 4.20.x 1/7] mt76x0: do not overwrite other MT_BBP(AGC, 8) fields
Date:   Tue, 22 Jan 2019 13:38:31 +0100
Message-Id: <1548160717-4059-2-git-send-email-sgruszka@redhat.com>
In-Reply-To: <1548160717-4059-1-git-send-email-sgruszka@redhat.com>
References: <1548160717-4059-1-git-send-email-sgruszka@redhat.com>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.29]); Tue, 22 Jan 2019 12:38:41 +0000 (UTC)
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

commit b983a5b900627faa49cf37e101d65b56e941c740 upstream.

MT_BBP(AGC, 8) register has values depend on band in
mt76x0_bbp_switch_tab, so we should not overwrite other fields
than MT_BBP_AGC_GAIN when setting gain.

This can fix performance issues when connecting to 2.4GHz AP.

Fixes: 4636a2544c3b ("mt76x0: phy: align channel gain logic to mt76x2 one")
Acked-by: Lorenzo Bianconi <lorenzo.bianconi@redhat.com>
Signed-off-by: Felix Fietkau <nbd@nbd.name>
Signed-off-by: Stanislaw Gruszka <sgruszka@redhat.com>
---
 drivers/net/wireless/mediatek/mt76/mt76x0/phy.c | 4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff --git a/drivers/net/wireless/mediatek/mt76/mt76x0/phy.c b/drivers/net/wireless/mediatek/mt76/mt76x0/phy.c
index cf024950e0ed..1af2a1227924 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76x0/phy.c
+++ b/drivers/net/wireless/mediatek/mt76/mt76x0/phy.c
@@ -817,10 +817,8 @@ static void mt76x0_temp_sensor(struct mt76x02_dev *dev)
 static void mt76x0_phy_set_gain_val(struct mt76x02_dev *dev)
 {
 	u8 gain = dev->cal.agc_gain_cur[0] - dev->cal.agc_gain_adjust;
-	u32 val = 0x122c << 16 | 0xf2;
 
-	mt76_wr(dev, MT_BBP(AGC, 8),
-		val | FIELD_PREP(MT_BBP_AGC_GAIN, gain));
+	mt76_rmw_field(dev, MT_BBP(AGC, 8), MT_BBP_AGC_GAIN, gain);
 }
 
 static void
-- 
1.9.3

