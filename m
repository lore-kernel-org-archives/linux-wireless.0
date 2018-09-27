Return-Path: <SRS0=euQo=MJ=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D6585C43382
	for <linux-wireless@archiver.kernel.org>; Thu, 27 Sep 2018 08:37:44 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 88BFB21580
	for <linux-wireless@archiver.kernel.org>; Thu, 27 Sep 2018 08:37:44 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 88BFB21580
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=redhat.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-wireless-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727171AbeI0Oyt (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Thu, 27 Sep 2018 10:54:49 -0400
Received: from mx1.redhat.com ([209.132.183.28]:47200 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727154AbeI0Oyt (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 27 Sep 2018 10:54:49 -0400
Received: from smtp.corp.redhat.com (int-mx11.intmail.prod.int.phx2.redhat.com [10.5.11.26])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 64A0886641;
        Thu, 27 Sep 2018 08:37:43 +0000 (UTC)
Received: from localhost (unknown [10.43.2.6])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 05EB830912F5;
        Thu, 27 Sep 2018 08:37:42 +0000 (UTC)
From:   Stanislaw Gruszka <sgruszka@redhat.com>
To:     Felix Fietkau <nbd@nbd.name>
Cc:     linux-wireless@vger.kernel.org,
        Lorenzo Bianconi <lorenzo.bianconi@redhat.com>
Subject: [RFC 3/4] mt76: allow to identify bus
Date:   Thu, 27 Sep 2018 10:37:29 +0200
Message-Id: <1538037450-18949-4-git-send-email-sgruszka@redhat.com>
In-Reply-To: <1538037450-18949-1-git-send-email-sgruszka@redhat.com>
References: <1538037450-18949-1-git-send-email-sgruszka@redhat.com>
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.26
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.26]); Thu, 27 Sep 2018 08:37:43 +0000 (UTC)
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
index f2dd4d87e355..b0e6215c67ec 100644
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
index de7785c4f6af..a7fc5db39b31 100644
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

