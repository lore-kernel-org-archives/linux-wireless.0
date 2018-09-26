Return-Path: <SRS0=mZ/2=MI=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.6 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8F444C43382
	for <linux-wireless@archiver.kernel.org>; Wed, 26 Sep 2018 19:51:16 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id ED5C52147D
	for <linux-wireless@archiver.kernel.org>; Wed, 26 Sep 2018 19:51:15 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (1024-bit key) header.d=nbd.name header.i=@nbd.name header.b="QG+9FmlY"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org ED5C52147D
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=nbd.name
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-wireless-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727108AbeI0CFr (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Wed, 26 Sep 2018 22:05:47 -0400
Received: from nbd.name ([46.4.11.11]:58730 "EHLO nbd.name"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726032AbeI0CFr (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 26 Sep 2018 22:05:47 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nbd.name;
         s=20160729; h=Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To:
        MIME-Version:Content-Type:Content-Transfer-Encoding:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:In-Reply-To:References:List-Id:List-Help:List-Unsubscribe:
        List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=VEqDt3Wc9Qh0dMBoehbPohljQ5qT2v1tZCA0I3vxZgE=; b=QG+9FmlYnRu3BWoUK8aboh8PjJ
        b7Pd4MzprIiLdZyRPmVU5NmXBVMGKJJvynk12WVRqAMEqeoQ0ilK4ANxv3IBMgGJ94LpfcFzAI21n
        eFd8LxwmkU4bZQfpsVQrPH+cOf76ymRdrddxqttDfItqkYhak+01QXH+3rQcw/HVcY6o=;
Received: by maeck.lan (Postfix, from userid 501)
        id 06E023A9ACCE; Wed, 26 Sep 2018 21:51:10 +0200 (CEST)
From:   Felix Fietkau <nbd@nbd.name>
To:     linux-wireless@vger.kernel.org
Cc:     sgruszka@redhat.com, lorenzo.bianconi@redhat.com
Subject: [PATCH] mt76x2: disable WLAN core before probe
Date:   Wed, 26 Sep 2018 21:51:10 +0200
Message-Id: <20180926195110.78473-1-nbd@nbd.name>
X-Mailer: git-send-email 2.17.0
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

If the WLAN core is still active during initialization, it might cause
the MCU or DMA to hang. This can happen during soft reboot, so disable
the core + clock early to avoid this issue.

Signed-off-by: Felix Fietkau <nbd@nbd.name>
---
 drivers/net/wireless/mediatek/mt76/mt76x2_init_common.c | 4 ++++
 drivers/net/wireless/mediatek/mt76/mt76x2_pci.c         | 1 +
 2 files changed, 5 insertions(+)

diff --git a/drivers/net/wireless/mediatek/mt76/mt76x2_init_common.c b/drivers/net/wireless/mediatek/mt76/mt76x2_init_common.c
index d13da7ad86ee..abf535da0c78 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76x2_init_common.c
+++ b/drivers/net/wireless/mediatek/mt76/mt76x2_init_common.c
@@ -39,6 +39,9 @@ void mt76x2_reset_wlan(struct mt76x2_dev *dev, bool enable)
 {
 	u32 val;
 
+	if (!enable)
+		goto out;
+
 	val = mt76_rr(dev, MT_WLAN_FUN_CTRL);
 
 	val &= ~MT_WLAN_FUN_CTRL_FRC_WL_ANT_SEL;
@@ -54,6 +57,7 @@ void mt76x2_reset_wlan(struct mt76x2_dev *dev, bool enable)
 	mt76_wr(dev, MT_WLAN_FUN_CTRL, val);
 	udelay(20);
 
+out:
 	mt76x2_set_wlan_state(dev, enable);
 }
 EXPORT_SYMBOL_GPL(mt76x2_reset_wlan);
diff --git a/drivers/net/wireless/mediatek/mt76/mt76x2_pci.c b/drivers/net/wireless/mediatek/mt76/mt76x2_pci.c
index e66f047ea448..26cfda24ce08 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76x2_pci.c
+++ b/drivers/net/wireless/mediatek/mt76/mt76x2_pci.c
@@ -53,6 +53,7 @@ mt76pci_probe(struct pci_dev *pdev, const struct pci_device_id *id)
 		return -ENOMEM;
 
 	mt76_mmio_init(&dev->mt76, pcim_iomap_table(pdev)[0]);
+	mt76x2_reset_wlan(dev, false);
 
 	dev->mt76.rev = mt76_rr(dev, MT_ASIC_VERSION);
 	dev_info(dev->mt76.dev, "ASIC revision: %08x\n", dev->mt76.rev);
-- 
2.17.0

