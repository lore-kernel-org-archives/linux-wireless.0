Return-Path: <SRS0=EqeY=MQ=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 27809C64EBD
	for <linux-wireless@archiver.kernel.org>; Thu,  4 Oct 2018 10:05:18 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id EE55020652
	for <linux-wireless@archiver.kernel.org>; Thu,  4 Oct 2018 10:05:17 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org EE55020652
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=redhat.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-wireless-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728222AbeJDQ5s (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Thu, 4 Oct 2018 12:57:48 -0400
Received: from mx1.redhat.com ([209.132.183.28]:57322 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728213AbeJDQ5r (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 4 Oct 2018 12:57:47 -0400
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 880A2300206A;
        Thu,  4 Oct 2018 10:05:15 +0000 (UTC)
Received: from localhost (unknown [10.43.2.45])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 63E51600C5;
        Thu,  4 Oct 2018 10:05:12 +0000 (UTC)
From:   Stanislaw Gruszka <sgruszka@redhat.com>
To:     Felix Fietkau <nbd@nbd.name>
Cc:     linux-wireless@vger.kernel.org,
        Lorenzo Bianconi <lorenzo.bianconi@redhat.com>
Subject: [PATCH 3/5] mt76: allow to identify bus
Date:   Thu,  4 Oct 2018 12:04:53 +0200
Message-Id: <1538647495-15213-4-git-send-email-sgruszka@redhat.com>
In-Reply-To: <1538647495-15213-1-git-send-email-sgruszka@redhat.com>
References: <1538647495-15213-1-git-send-email-sgruszka@redhat.com>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.47]); Thu, 04 Oct 2018 10:05:15 +0000 (UTC)
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Add helpers to identify bus type.

Signed-off-by: Stanislaw Gruszka <sgruszka@redhat.com>
---
 drivers/net/wireless/mediatek/mt76/mmio.c | 1 +
 drivers/net/wireless/mediatek/mt76/mt76.h | 9 +++++++++
 drivers/net/wireless/mediatek/mt76/usb.c  | 1 +
 3 files changed, 11 insertions(+)

diff --git a/drivers/net/wireless/mediatek/mt76/mmio.c b/drivers/net/wireless/mediatek/mt76/mmio.c
index 30a5d928e655..1d6bbce76041 100644
--- a/drivers/net/wireless/mediatek/mt76/mmio.c
+++ b/drivers/net/wireless/mediatek/mt76/mmio.c
@@ -79,6 +79,7 @@ void mt76_mmio_init(struct mt76_dev *dev, void __iomem *regs)
 		.copy = mt76_mmio_copy,
 		.wr_rp = mt76_mmio_wr_rp,
 		.rd_rp = mt76_mmio_rd_rp,
+		.type = MT76_BUS_MMIO,
 	};
 
 	dev->bus = &mt76_mmio_ops;
diff --git a/drivers/net/wireless/mediatek/mt76/mt76.h b/drivers/net/wireless/mediatek/mt76/mt76.h
index f723a07cab29..3bfa7f5e3513 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76.h
+++ b/drivers/net/wireless/mediatek/mt76/mt76.h
@@ -38,6 +38,11 @@ struct mt76_reg_pair {
 	u32 value;
 };
 
+enum mt76_bus_type {
+	MT76_BUS_MMIO,
+	MT76_BUS_USB,
+};
+
 struct mt76_bus_ops {
 	u32 (*rr)(struct mt76_dev *dev, u32 offset);
 	void (*wr)(struct mt76_dev *dev, u32 offset, u32 val);
@@ -48,8 +53,12 @@ struct mt76_bus_ops {
 		     const struct mt76_reg_pair *rp, int len);
 	int (*rd_rp)(struct mt76_dev *dev, u32 base,
 		     struct mt76_reg_pair *rp, int len);
+	enum mt76_bus_type type;
 };
 
+#define mt76_is_usb(dev) ((dev)->mt76.bus->type == MT76_BUS_USB)
+#define mt76_is_mmio(dev) ((dev)->mt76.bus->type == MT76_BUS_MMIO)
+
 enum mt76_txq_id {
 	MT_TXQ_VO = IEEE80211_AC_VO,
 	MT_TXQ_VI = IEEE80211_AC_VI,
diff --git a/drivers/net/wireless/mediatek/mt76/usb.c b/drivers/net/wireless/mediatek/mt76/usb.c
index 6b643ea701e3..cccb143e57b0 100644
--- a/drivers/net/wireless/mediatek/mt76/usb.c
+++ b/drivers/net/wireless/mediatek/mt76/usb.c
@@ -862,6 +862,7 @@ int mt76u_init(struct mt76_dev *dev,
 		.copy = mt76u_copy,
 		.wr_rp = mt76u_wr_rp,
 		.rd_rp = mt76u_rd_rp,
+		.type = MT76_BUS_USB,
 	};
 	struct mt76_usb *usb = &dev->usb;
 
-- 
1.9.3

