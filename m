Return-Path: <SRS0=BJpU=RT=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0A6A6C43381
	for <linux-wireless@archiver.kernel.org>; Sat, 16 Mar 2019 14:33:07 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id CAB0421903
	for <linux-wireless@archiver.kernel.org>; Sat, 16 Mar 2019 14:33:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1552746786;
	bh=GZaECBoPKosqiXBJI07rJFrURoQxvYGG/l7uSPERc9g=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:List-ID:From;
	b=gBCi++6JAUeAv2pxdAgDiCLO08g0Rt2kpNp5n7eB03uaVMiQquyiA+cnmbEoHFfHD
	 eF03fBltjbtVkjt+n+PQUhx+fGjsAkBYgVjV6SIy2n3GKq0V3SKimyIeCkkgY2XfpV
	 8HRw91hLvT70DQZby7eaJXfMG9lnrQlEEBKiluCQ=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726861AbfCPOdF (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Sat, 16 Mar 2019 10:33:05 -0400
Received: from mail.kernel.org ([198.145.29.99]:56566 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726064AbfCPOdF (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Sat, 16 Mar 2019 10:33:05 -0400
Received: from localhost.localdomain (unknown [151.66.48.245])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 9EFB9218D0;
        Sat, 16 Mar 2019 14:33:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1552746784;
        bh=GZaECBoPKosqiXBJI07rJFrURoQxvYGG/l7uSPERc9g=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=vW9wUScvfgfZAbAGVUE+Q+evI0SlfKI3/sY2vwIzw6KPs2SNCiy8d/qDcBrpQIsMw
         NQwffID20+ECOqDEWpQzih1HIdcaI95CPRAPBcTJg/qcW7Ut/A3uwFdvUeULXZuos9
         VzWoFBlA1kg/UPxI1Vxb1wsBsP/Abu9dgMrhzhDg=
From:   Lorenzo Bianconi <lorenzo@kernel.org>
To:     nbd@nbd.name
Cc:     linux-wireless@vger.kernel.org, lorenzo.bianconi@redhat.com,
        sgruszka@redhat.com
Subject: [PATCH] mt7603: remove mt7603_mcu_init routine
Date:   Sat, 16 Mar 2019 15:32:53 +0100
Message-Id: <de62eeed41d63ee5444f7039592323750165f992.1552739522.git.lorenzo@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <cover.1552739522.git.lorenzo@kernel.org>
References: <cover.1552739522.git.lorenzo@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Remove mt7603_mcu_init since mcu.mutex has been already initialized
in mt76_mmio_init. Run mt7603_load_firmware directly in
mt7603_init_hardware

Signed-off-by: Lorenzo Bianconi <lorenzo@kernel.org>
---
 drivers/net/wireless/mediatek/mt76/mt7603/init.c   |  2 +-
 drivers/net/wireless/mediatek/mt76/mt7603/mcu.c    | 10 +---------
 drivers/net/wireless/mediatek/mt76/mt7603/mt7603.h |  2 +-
 3 files changed, 3 insertions(+), 11 deletions(-)

diff --git a/drivers/net/wireless/mediatek/mt76/mt7603/init.c b/drivers/net/wireless/mediatek/mt76/mt7603/init.c
index d54dda67d036..e17b6b89dfe2 100644
--- a/drivers/net/wireless/mediatek/mt76/mt7603/init.c
+++ b/drivers/net/wireless/mediatek/mt76/mt7603/init.c
@@ -282,7 +282,7 @@ mt7603_init_hardware(struct mt7603_dev *dev)
 		mt76_poll(dev, MT_PSE_RTA, MT_PSE_RTA_BUSY, 0, 5000);
 	}
 
-	ret = mt7603_mcu_init(dev);
+	ret = mt7603_load_firmware(dev);
 	if (ret)
 		return ret;
 
diff --git a/drivers/net/wireless/mediatek/mt76/mt7603/mcu.c b/drivers/net/wireless/mediatek/mt76/mt7603/mcu.c
index d06905ea8cc6..57481012ee47 100644
--- a/drivers/net/wireless/mediatek/mt76/mt7603/mcu.c
+++ b/drivers/net/wireless/mediatek/mt76/mt7603/mcu.c
@@ -170,8 +170,7 @@ mt7603_mcu_restart(struct mt7603_dev *dev)
 				   MCU_Q_NA);
 }
 
-static int
-mt7603_load_firmware(struct mt7603_dev *dev)
+int mt7603_load_firmware(struct mt7603_dev *dev)
 {
 	const struct firmware *fw;
 	const struct mt7603_fw_trailer *hdr;
@@ -269,13 +268,6 @@ mt7603_load_firmware(struct mt7603_dev *dev)
 	return ret;
 }
 
-int mt7603_mcu_init(struct mt7603_dev *dev)
-{
-	mutex_init(&dev->mt76.mmio.mcu.mutex);
-
-	return mt7603_load_firmware(dev);
-}
-
 void mt7603_mcu_exit(struct mt7603_dev *dev)
 {
 	mt7603_mcu_restart(dev);
diff --git a/drivers/net/wireless/mediatek/mt76/mt7603/mt7603.h b/drivers/net/wireless/mediatek/mt76/mt7603/mt7603.h
index 8bd00b97066a..b65348ea4868 100644
--- a/drivers/net/wireless/mediatek/mt76/mt7603/mt7603.h
+++ b/drivers/net/wireless/mediatek/mt76/mt7603/mt7603.h
@@ -176,7 +176,7 @@ void mt7603_unregister_device(struct mt7603_dev *dev);
 int mt7603_eeprom_init(struct mt7603_dev *dev);
 int mt7603_dma_init(struct mt7603_dev *dev);
 void mt7603_dma_cleanup(struct mt7603_dev *dev);
-int mt7603_mcu_init(struct mt7603_dev *dev);
+int mt7603_load_firmware(struct mt7603_dev *dev);
 void mt7603_init_debugfs(struct mt7603_dev *dev);
 
 static inline void mt7603_irq_enable(struct mt7603_dev *dev, u32 mask)
-- 
2.20.1

