Return-Path: <SRS0=rthY=NG=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1A47BECDE44
	for <linux-wireless@archiver.kernel.org>; Fri, 26 Oct 2018 12:01:43 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id E18E82084D
	for <linux-wireless@archiver.kernel.org>; Fri, 26 Oct 2018 12:01:42 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org E18E82084D
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=redhat.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-wireless-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727641AbeJZUib (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Fri, 26 Oct 2018 16:38:31 -0400
Received: from mx1.redhat.com ([209.132.183.28]:55572 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727469AbeJZUib (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 26 Oct 2018 16:38:31 -0400
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id D7F9630A3155;
        Fri, 26 Oct 2018 12:01:40 +0000 (UTC)
Received: from localhost (unknown [10.40.205.86])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 31BDA6146F;
        Fri, 26 Oct 2018 12:01:40 +0000 (UTC)
From:   Stanislaw Gruszka <sgruszka@redhat.com>
To:     Felix Fietkau <nbd@nbd.name>
Cc:     Lorenzo Bianconi <lorenzo.bianconi@redhat.com>,
        linux-wireless@vger.kernel.org
Subject: [PATCH 4/4] mt76: remove wait argument from mt76x02_mcu_set_radio_state
Date:   Fri, 26 Oct 2018 14:00:29 +0200
Message-Id: <1540555229-28582-5-git-send-email-sgruszka@redhat.com>
In-Reply-To: <1540555229-28582-1-git-send-email-sgruszka@redhat.com>
References: <1540555229-28582-1-git-send-email-sgruszka@redhat.com>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.43]); Fri, 26 Oct 2018 12:01:41 +0000 (UTC)
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Remove wait argument from mt76x02_mcu_set_radio_state and newer wait
for response when sending CMD_POWER_SAVING_OP mcu command.
Note this change behaviour for PCIe devices, but the change is in
align with vendor driver.

Signed-off-by: Stanislaw Gruszka <sgruszka@redhat.com>
---
 drivers/net/wireless/mediatek/mt76/mt76x02_mcu.c     | 6 ++----
 drivers/net/wireless/mediatek/mt76/mt76x02_mcu.h     | 3 +--
 drivers/net/wireless/mediatek/mt76/mt76x2/pci_init.c | 2 +-
 drivers/net/wireless/mediatek/mt76/mt76x2/pci_phy.c  | 2 +-
 drivers/net/wireless/mediatek/mt76/mt76x2/usb_init.c | 2 +-
 drivers/net/wireless/mediatek/mt76/mt76x2/usb_mcu.c  | 2 +-
 6 files changed, 7 insertions(+), 10 deletions(-)

diff --git a/drivers/net/wireless/mediatek/mt76/mt76x02_mcu.c b/drivers/net/wireless/mediatek/mt76/mt76x02_mcu.c
index 964befc525f3..e91d4deaa8c0 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76x02_mcu.c
+++ b/drivers/net/wireless/mediatek/mt76/mt76x02_mcu.c
@@ -151,8 +151,7 @@ int mt76x02_mcu_function_select(struct mt76x02_dev *dev, enum mcu_function func,
 }
 EXPORT_SYMBOL_GPL(mt76x02_mcu_function_select);
 
-int mt76x02_mcu_set_radio_state(struct mt76x02_dev *dev, bool on,
-				bool wait_resp)
+int mt76x02_mcu_set_radio_state(struct mt76x02_dev *dev, bool on)
 {
 	struct {
 		__le32 mode;
@@ -162,8 +161,7 @@ int mt76x02_mcu_set_radio_state(struct mt76x02_dev *dev, bool on,
 		.level = cpu_to_le32(0),
 	};
 
-	return mt76_mcu_send_msg(dev, CMD_POWER_SAVING_OP, &msg, sizeof(msg),
-				 wait_resp);
+	return mt76_mcu_send_msg(dev, CMD_POWER_SAVING_OP, &msg, sizeof(msg), false);
 }
 EXPORT_SYMBOL_GPL(mt76x02_mcu_set_radio_state);
 
diff --git a/drivers/net/wireless/mediatek/mt76/mt76x02_mcu.h b/drivers/net/wireless/mediatek/mt76/mt76x02_mcu.h
index 5cbf0e7c118c..7e4004120102 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76x02_mcu.h
+++ b/drivers/net/wireless/mediatek/mt76/mt76x02_mcu.h
@@ -102,8 +102,7 @@ int mt76x02_mcu_msg_send(struct mt76_dev *mdev, int cmd, const void *data,
 			 int len, bool wait_resp);
 int mt76x02_mcu_function_select(struct mt76x02_dev *dev, enum mcu_function func,
 				u32 val);
-int mt76x02_mcu_set_radio_state(struct mt76x02_dev *dev, bool on,
-				bool wait_resp);
+int mt76x02_mcu_set_radio_state(struct mt76x02_dev *dev, bool on);
 void mt76x02_set_ethtool_fwver(struct mt76x02_dev *dev,
 			       const struct mt76x02_fw_header *h);
 
diff --git a/drivers/net/wireless/mediatek/mt76/mt76x2/pci_init.c b/drivers/net/wireless/mediatek/mt76/mt76x2/pci_init.c
index f6e8af6432c1..9163481e778c 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76x2/pci_init.c
+++ b/drivers/net/wireless/mediatek/mt76/mt76x2/pci_init.c
@@ -297,7 +297,7 @@ void mt76x2_stop_hardware(struct mt76x02_dev *dev)
 {
 	cancel_delayed_work_sync(&dev->cal_work);
 	cancel_delayed_work_sync(&dev->mac_work);
-	mt76x02_mcu_set_radio_state(dev, false, true);
+	mt76x02_mcu_set_radio_state(dev, false);
 	mt76x2_mac_stop(dev, false);
 }
 
diff --git a/drivers/net/wireless/mediatek/mt76/mt76x2/pci_phy.c b/drivers/net/wireless/mediatek/mt76/mt76x2/pci_phy.c
index 59ef7931df50..da7cd40f56ff 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76x2/pci_phy.c
+++ b/drivers/net/wireless/mediatek/mt76/mt76x2/pci_phy.c
@@ -305,7 +305,7 @@ int mt76x2_phy_start(struct mt76x02_dev *dev)
 {
 	int ret;
 
-	ret = mt76x02_mcu_set_radio_state(dev, true, true);
+	ret = mt76x02_mcu_set_radio_state(dev, true);
 	if (ret)
 		return ret;
 
diff --git a/drivers/net/wireless/mediatek/mt76/mt76x2/usb_init.c b/drivers/net/wireless/mediatek/mt76/mt76x2/usb_init.c
index a7d591610f16..2e690ef5f2fc 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76x2/usb_init.c
+++ b/drivers/net/wireless/mediatek/mt76/mt76x2/usb_init.c
@@ -300,7 +300,7 @@ void mt76x2u_stop_hw(struct mt76x02_dev *dev)
 
 void mt76x2u_cleanup(struct mt76x02_dev *dev)
 {
-	mt76x02_mcu_set_radio_state(dev, false, false);
+	mt76x02_mcu_set_radio_state(dev, false);
 	mt76x2u_stop_hw(dev);
 	mt76u_queues_deinit(&dev->mt76);
 	mt76u_mcu_deinit(&dev->mt76);
diff --git a/drivers/net/wireless/mediatek/mt76/mt76x2/usb_mcu.c b/drivers/net/wireless/mediatek/mt76/mt76x2/usb_mcu.c
index ca9037af804c..45a95ee3a415 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76x2/usb_mcu.c
+++ b/drivers/net/wireless/mediatek/mt76/mt76x2/usb_mcu.c
@@ -262,5 +262,5 @@ int mt76x2u_mcu_init(struct mt76x02_dev *dev)
 	if (err < 0)
 		return err;
 
-	return mt76x02_mcu_set_radio_state(dev, true, false);
+	return mt76x02_mcu_set_radio_state(dev, true);
 }
-- 
2.7.5

