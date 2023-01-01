Return-Path: <linux-wireless-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BD16CC4332F
	for <linux-wireless@archiver.kernel.org>; Sun,  1 Jan 2023 11:46:14 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229643AbjAALqN (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Sun, 1 Jan 2023 06:46:13 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34208 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229447AbjAALqM (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Sun, 1 Jan 2023 06:46:12 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 435CCD93
        for <linux-wireless@vger.kernel.org>; Sun,  1 Jan 2023 03:46:11 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id EEC7EB8090B
        for <linux-wireless@vger.kernel.org>; Sun,  1 Jan 2023 11:46:09 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5F239C433D2;
        Sun,  1 Jan 2023 11:46:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1672573568;
        bh=VYhRbY7cPKP6LEeCVyo51WYxTYD1TuXOBHYonHhlyrY=;
        h=From:To:Cc:Subject:Date:From;
        b=EYGxJp2Mm98Lla2ivqtK0Vt5iQVTMaIY0ezViLzBSM+lHcdt9Ha43ZhCdsCCnAJHb
         m5VY24BR/qd2xPZk7OoeiMTB323UIhzpwoeb2T/KEnRM//pviu+yx1ka/ACt1wiDlm
         ZKU5sZljn7g+cwZ3nVbE6AbdfahNk6rzr0N74JSLGHrA/aoOyGR/ASkfuCV20HQUJJ
         XqYfAn6Y5QeKxbzOnmuHUvxNXbiJ3FSIfOEku8jHg7Zlo8niFOhQw2TfIX+9EtXze+
         8WW3qeQ6YJeovhBtQXmYZLRTWKGlXGYd4QZAR6v39CY2RexTDE2VEHPd94jNjPGGnM
         qyS1lA4a1D/JA==
From:   Lorenzo Bianconi <lorenzo@kernel.org>
To:     nbd@nbd.name
Cc:     lorenzo.bianconi@redhat.com, linux-wireless@vger.kernel.org
Subject: [PATCH] wifi: mt76: mt7996: fix memory leak in mt7996_mcu_exit
Date:   Sun,  1 Jan 2023 12:43:52 +0100
Message-Id: <b8d40805542e6df12692ec5774150a4098618425.1672573369.git.lorenzo@kernel.org>
X-Mailer: git-send-email 2.38.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Always purge mcu skb queues in mt7996_mcu_exit routine even if
mt7996_firmware_state fails.

Fixes: 98686cd21624 ("wifi: mt76: mt7996: add driver for MediaTek Wi-Fi 7 (802.11be) devices")
Signed-off-by: Lorenzo Bianconi <lorenzo@kernel.org>
---
 drivers/net/wireless/mediatek/mt76/mt7996/mcu.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/net/wireless/mediatek/mt76/mt7996/mcu.c b/drivers/net/wireless/mediatek/mt76/mt7996/mcu.c
index 79a4d314ebd7..af6d80655471 100644
--- a/drivers/net/wireless/mediatek/mt76/mt7996/mcu.c
+++ b/drivers/net/wireless/mediatek/mt76/mt7996/mcu.c
@@ -2454,13 +2454,14 @@ void mt7996_mcu_exit(struct mt7996_dev *dev)
 	__mt76_mcu_restart(&dev->mt76);
 	if (mt7996_firmware_state(dev, false)) {
 		dev_err(dev->mt76.dev, "Failed to exit mcu\n");
-		return;
+		goto out;
 	}
 
 	mt76_wr(dev, MT_TOP_LPCR_HOST_BAND(0), MT_TOP_LPCR_HOST_FW_OWN);
 	if (dev->hif2)
 		mt76_wr(dev, MT_TOP_LPCR_HOST_BAND(1),
 			MT_TOP_LPCR_HOST_FW_OWN);
+out:
 	skb_queue_purge(&dev->mt76.mcu.res_q);
 }
 
-- 
2.38.1

