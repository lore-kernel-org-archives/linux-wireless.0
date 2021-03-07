Return-Path: <SRS0=sdWG=IF=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-19.3 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0A6DBC433E0
	for <linux-wireless@archiver.kernel.org>; Sun,  7 Mar 2021 18:21:44 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id D46C46513D
	for <linux-wireless@archiver.kernel.org>; Sun,  7 Mar 2021 18:21:43 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231252AbhCGSVM (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Sun, 7 Mar 2021 13:21:12 -0500
Received: from mail.kernel.org ([198.145.29.99]:35600 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231159AbhCGSVK (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Sun, 7 Mar 2021 13:21:10 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 868F965186;
        Sun,  7 Mar 2021 18:21:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1615141270;
        bh=V+fOmAhqFRXLpQza7Zgx/IdpztHQYZeeV4NgnO/k47U=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=oYfDADlZfdEgjf7dQ2Xv4zPYvmyGoqMU5GBv+YMqqiUe+/veyOLQkxuM2WA/4NtHp
         iVzMWSHdA4YsqhqGjOs06pvRfJuf4iihV4XDmhWZVQQ48RqbqO6GFj0czmalvhO/SK
         FBJ/y/GtL+EJDp0IuLj+d2WXFWxeJhrBzmiw+fjBm1KEqPxQS6nSCC/TOlEO7QwfKR
         5W7R6G79G4cmvalORl0LtgM+5zyCtGbkYJ2ZJ2BebebWOKquCFeoynspH3oaQ8tr4j
         kNzKjZvzHIeBFOacuKPN2KRu8byIFjNuYYgIDp8eLqSyFaHKYp/IHnkHo9QFvei147
         V59iZ1GFhc88g==
From:   Lorenzo Bianconi <lorenzo@kernel.org>
To:     nbd@nbd.name
Cc:     linux-wireless@vger.kernel.org, lorenzo.bianconi@redhat.com,
        sean.wang@mediatek.com
Subject: [PATCH 3/7] mt76: mt7921: introduce mt7921_run_firmware utility routine.
Date:   Sun,  7 Mar 2021 19:20:47 +0100
Message-Id: <9a7bb378c10d7a7ef8379d3256967207be901853.1615140875.git.lorenzo@kernel.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <cover.1615140875.git.lorenzo@kernel.org>
References: <cover.1615140875.git.lorenzo@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

This is a preliminary patch to introduce chip reset for mt7921 devices.

Co-developed-by: Sean Wang <sean.wang@mediatek.com>
Signed-off-by: Sean Wang <sean.wang@mediatek.com>
Signed-off-by: Lorenzo Bianconi <lorenzo@kernel.org>
---
 .../net/wireless/mediatek/mt76/mt7921/mcu.c   | 32 +++++++++++--------
 .../wireless/mediatek/mt76/mt7921/mt7921.h    |  1 +
 2 files changed, 20 insertions(+), 13 deletions(-)

diff --git a/drivers/net/wireless/mediatek/mt76/mt7921/mcu.c b/drivers/net/wireless/mediatek/mt76/mt7921/mcu.c
index 1c686e4abd80..cbe35c76189e 100644
--- a/drivers/net/wireless/mediatek/mt76/mt7921/mcu.c
+++ b/drivers/net/wireless/mediatek/mt76/mt7921/mcu.c
@@ -928,6 +928,24 @@ int mt7921_mcu_fw_log_2_host(struct mt7921_dev *dev, u8 ctrl)
 				 sizeof(data), false);
 }
 
+int mt7921_run_firmware(struct mt7921_dev *dev)
+{
+	int err;
+
+	err = mt7921_driver_own(dev);
+	if (err)
+		return err;
+
+	err = mt7921_load_firmware(dev);
+	if (err)
+		return err;
+
+	set_bit(MT76_STATE_MCU_RUNNING, &dev->mphy.state);
+	mt7921_mcu_fw_log_2_host(dev, 1);
+
+	return 0;
+}
+
 int mt7921_mcu_init(struct mt7921_dev *dev)
 {
 	static const struct mt76_mcu_ops mt7921_mcu_ops = {
@@ -936,22 +954,10 @@ int mt7921_mcu_init(struct mt7921_dev *dev)
 		.mcu_parse_response = mt7921_mcu_parse_response,
 		.mcu_restart = mt7921_mcu_restart,
 	};
-	int ret;
 
 	dev->mt76.mcu_ops = &mt7921_mcu_ops;
 
-	ret = mt7921_driver_own(dev);
-	if (ret)
-		return ret;
-
-	ret = mt7921_load_firmware(dev);
-	if (ret)
-		return ret;
-
-	set_bit(MT76_STATE_MCU_RUNNING, &dev->mphy.state);
-	mt7921_mcu_fw_log_2_host(dev, 1);
-
-	return 0;
+	return mt7921_run_firmware(dev);
 }
 
 void mt7921_mcu_exit(struct mt7921_dev *dev)
diff --git a/drivers/net/wireless/mediatek/mt76/mt7921/mt7921.h b/drivers/net/wireless/mediatek/mt76/mt7921/mt7921.h
index 2979d06ee0ad..72dc2ba8fd40 100644
--- a/drivers/net/wireless/mediatek/mt76/mt7921/mt7921.h
+++ b/drivers/net/wireless/mediatek/mt76/mt7921/mt7921.h
@@ -220,6 +220,7 @@ void mt7921_eeprom_init_sku(struct mt7921_dev *dev);
 int mt7921_dma_init(struct mt7921_dev *dev);
 void mt7921_dma_prefetch(struct mt7921_dev *dev);
 void mt7921_dma_cleanup(struct mt7921_dev *dev);
+int mt7921_run_firmware(struct mt7921_dev *dev);
 int mt7921_mcu_init(struct mt7921_dev *dev);
 int mt7921_mcu_add_bss_info(struct mt7921_phy *phy,
 			    struct ieee80211_vif *vif, int enable);
-- 
2.29.2

