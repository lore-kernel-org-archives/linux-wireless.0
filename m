Return-Path: <SRS0=JKVC=45=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 35708C10DCE
	for <linux-wireless@archiver.kernel.org>; Thu, 12 Mar 2020 16:03:16 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 01679206FA
	for <linux-wireless@archiver.kernel.org>; Thu, 12 Mar 2020 16:03:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1584028996;
	bh=0u8kOuKU6XvmSCkVMurvFE9OJhBA+da2cLQp8IE3acQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:List-ID:From;
	b=sEVfudpMNCZxGn4pzynj68Iy3gdz2roqvDyZbqQenQ6Ease14MwAnb8yvRdLw2NPL
	 +3rOqCekhjL+F890p6PrP0jolgDx4dsQDvzXi1arwnQhQeaV+GunLo3jky51u20/B6
	 MSpLqfCfoKF/KJ0Rsjt00YY9zfwmOI9bTzHk3Lx8=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727958AbgCLQDP (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Thu, 12 Mar 2020 12:03:15 -0400
Received: from mail.kernel.org ([198.145.29.99]:57306 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727798AbgCLQDO (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 12 Mar 2020 12:03:14 -0400
Received: from lore-desk-wlan.redhat.com (unknown [151.48.128.122])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 0B5E32072F;
        Thu, 12 Mar 2020 16:03:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1584028994;
        bh=0u8kOuKU6XvmSCkVMurvFE9OJhBA+da2cLQp8IE3acQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=L5MDtvZULuEoxHF21Oq8sOKrF60W/2lseYUt7PJSDyh3qH1zHseQ1kOhKYMxAMU4H
         fI3IAIiOEiq8ntgT6Ij/rU+j6WvVLWy272Itnkt6xNKIz3fsz7oKCbTzuqWj3UCLTR
         uG0Vt9y7n0FA9P19/CovOANS3GtNKiMiIxcb4+nQ=
From:   Lorenzo Bianconi <lorenzo@kernel.org>
To:     nbd@nbd.name
Cc:     lorenzo.bianconi@redhat.com, sean.wang@mediatek.com,
        ryder.lee@mediatek.com, linux-wireless@vger.kernel.org
Subject: [PATCH v3 16/25] mt76: mt7615: add mt7663e support to mt7615_{driver,firmware}_own
Date:   Thu, 12 Mar 2020 17:02:26 +0100
Message-Id: <f83881a8270b5699acd205dc1e99d9e3af8caefb.1584028319.git.lorenzo@kernel.org>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <cover.1584028319.git.lorenzo@kernel.org>
References: <cover.1584028319.git.lorenzo@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Extend mt7615_driver_own and mt7615_firmware_own in order to reuse
them adding mt7663e support to mt7615 driver

Co-developed-by: Sean Wang <sean.wang@mediatek.com>
Signed-off-by: Sean Wang <sean.wang@mediatek.com>
Co-developed-by: Ryder Lee <ryder.lee@mediatek.com>
Signed-off-by: Ryder Lee <ryder.lee@mediatek.com>
Signed-off-by: Lorenzo Bianconi <lorenzo@kernel.org>
---
 drivers/net/wireless/mediatek/mt76/mt7615/mcu.c | 13 +++++++++----
 1 file changed, 9 insertions(+), 4 deletions(-)

diff --git a/drivers/net/wireless/mediatek/mt76/mt7615/mcu.c b/drivers/net/wireless/mediatek/mt76/mt7615/mcu.c
index 4ce3d248182c..9d044f23340e 100644
--- a/drivers/net/wireless/mediatek/mt76/mt7615/mcu.c
+++ b/drivers/net/wireless/mediatek/mt76/mt7615/mcu.c
@@ -1175,11 +1175,13 @@ static void mt7622_trigger_hif_int(struct mt7615_dev *dev, bool en)
 
 static int mt7615_driver_own(struct mt7615_dev *dev)
 {
-	mt76_wr(dev, MT_CFG_LPCR_HOST, MT_CFG_LPCR_HOST_DRV_OWN);
+	u32 addr;
+
+	addr = is_mt7663(&dev->mt76) ? MT_CONN_HIF_ON_LPCTL : MT_CFG_LPCR_HOST;
+	mt76_wr(dev, addr, MT_CFG_LPCR_HOST_DRV_OWN);
 
 	mt7622_trigger_hif_int(dev, true);
-	if (!mt76_poll_msec(dev, MT_CFG_LPCR_HOST,
-			    MT_CFG_LPCR_HOST_FW_OWN, 0, 3000)) {
+	if (!mt76_poll_msec(dev, addr, MT_CFG_LPCR_HOST_FW_OWN, 0, 3000)) {
 		dev_err(dev->mt76.dev, "Timeout for driver own\n");
 		return -EIO;
 	}
@@ -1190,9 +1192,12 @@ static int mt7615_driver_own(struct mt7615_dev *dev)
 
 static int mt7615_firmware_own(struct mt7615_dev *dev)
 {
+	u32 addr;
+
+	addr = is_mt7663(&dev->mt76) ? MT_CONN_HIF_ON_LPCTL : MT_CFG_LPCR_HOST;
 	mt7622_trigger_hif_int(dev, true);
 
-	mt76_wr(dev, MT_CFG_LPCR_HOST, MT_CFG_LPCR_HOST_FW_OWN);
+	mt76_wr(dev, addr, MT_CFG_LPCR_HOST_FW_OWN);
 
 	if (is_mt7622(&dev->mt76) &&
 	    !mt76_poll_msec(dev, MT_CFG_LPCR_HOST,
-- 
2.24.1

