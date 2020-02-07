Return-Path: <SRS0=CI53=33=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 053DCC352A2
	for <linux-wireless@archiver.kernel.org>; Fri,  7 Feb 2020 10:30:00 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id C5DAA21741
	for <linux-wireless@archiver.kernel.org>; Fri,  7 Feb 2020 10:29:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1581071399;
	bh=5c4EpVBKe3uGXU7QW4D7mViUzoLH/FX3fIIokBfvgwQ=;
	h=From:To:Cc:Subject:Date:List-ID:From;
	b=x58I91tWYH4wv3nLQC6ayTUMBqJvzN9NR8KudzzRG8VPbqgmwbGatdohnfLtidjGP
	 GgDyvD7PRz1/s3UowXGdfx+CeGT/KJxvo2hFK8ZiVQ9JPw2zFaBCHJwri8vgItnZCQ
	 r6WKgT9b+yRVF3XGH5usEPh6CEknLEY33GdVG4vw=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726827AbgBGK37 (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Fri, 7 Feb 2020 05:29:59 -0500
Received: from mail.kernel.org ([198.145.29.99]:37452 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726587AbgBGK36 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 7 Feb 2020 05:29:58 -0500
Received: from localhost.localdomain.com (nat-pool-mxp-t.redhat.com [149.6.153.186])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 3C27B2082E;
        Fri,  7 Feb 2020 10:29:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1581071398;
        bh=5c4EpVBKe3uGXU7QW4D7mViUzoLH/FX3fIIokBfvgwQ=;
        h=From:To:Cc:Subject:Date:From;
        b=bxrUnugtGP0+aYyqEoUnAVqg4h7inhZ8/1EhBHBLI4VW3AVup14b8VgSDJD++eY3u
         iOcONIsVciP+QD/0EDffM4lY4trNEoB21JqiD9+aTnV47fAUgISxfXVCaseScUGoig
         wZaZicsevYDHXOiZT1p5JJrWoUMedbPN+jl+W79Y=
From:   Lorenzo Bianconi <lorenzo@kernel.org>
To:     kvalo@codeaurora.org
Cc:     nbd@nbd.name, lorenzo.bianconi@redhat.com,
        linux-wireless@vger.kernel.org, ryder.lee@mediatek.com
Subject: [PATCH wireless-drivers] mt76: mt7615: fix max_nss in mt7615_eeprom_parse_hw_cap
Date:   Fri,  7 Feb 2020 11:29:51 +0100
Message-Id: <ca9137b43b2baa1a292922868004369d055a93e4.1581071232.git.lorenzo@kernel.org>
X-Mailer: git-send-email 2.21.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Fix u8 cast reading max_nss from MT_TOP_STRAP_STA register in
mt7615_eeprom_parse_hw_cap routine

Fixes: acf5457fd99db ("mt76: mt7615: read {tx,rx} mask from eeprom")
Signed-off-by: Lorenzo Bianconi <lorenzo@kernel.org>
---
 drivers/net/wireless/mediatek/mt76/mt7615/eeprom.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/net/wireless/mediatek/mt76/mt7615/eeprom.c b/drivers/net/wireless/mediatek/mt76/mt7615/eeprom.c
index eccad4987ac8..17e277bf39e0 100644
--- a/drivers/net/wireless/mediatek/mt76/mt7615/eeprom.c
+++ b/drivers/net/wireless/mediatek/mt76/mt7615/eeprom.c
@@ -92,8 +92,9 @@ static int mt7615_check_eeprom(struct mt76_dev *dev)
 
 static void mt7615_eeprom_parse_hw_cap(struct mt7615_dev *dev)
 {
-	u8 val, *eeprom = dev->mt76.eeprom.data;
+	u8 *eeprom = dev->mt76.eeprom.data;
 	u8 tx_mask, rx_mask, max_nss;
+	u32 val;
 
 	val = FIELD_GET(MT_EE_NIC_WIFI_CONF_BAND_SEL,
 			eeprom[MT_EE_WIFI_CONF]);
-- 
2.21.1

