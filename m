Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx3-rdu2.redhat.com ([66.187.233.73]:44102 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1732086AbeGaOVq (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 31 Jul 2018 10:21:46 -0400
From: Stanislaw Gruszka <sgruszka@redhat.com>
To: linux-wireless@vger.kernel.org
Cc: Lorenzo Bianconi <lorenzo.bianconi@redhat.com>,
        Felix Fietkau <nbd@nbd.name>,
        Hans Ulli Kroll <ulli.kroll@googlemail.com>,
        Jakub Kicinski <kubakici@wp.pl>,
        Michal Schmidt <mschmidt@redhat.com>,
        linux-mediatek@lists.infradead.org,
        Stanislaw Gruszka <sgruszka@redhat.com>
Subject: [PATCH v3 13/14] mt76x0: disable HW before probe
Date: Tue, 31 Jul 2018 14:41:03 +0200
Message-Id: <1533040864-9026-14-git-send-email-sgruszka@redhat.com> (sfid-20180731_144144_603617_1AD21183)
In-Reply-To: <1533040864-9026-1-git-send-email-sgruszka@redhat.com>
References: <1533040864-9026-1-git-send-email-sgruszka@redhat.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Disable HW before probe, otherwise after reboot we will fail
to initialize MCU.

Signed-off-by: Stanislaw Gruszka <sgruszka@redhat.com>
---
 drivers/net/wireless/mediatek/mt76/mt76x0/init.c   | 2 +-
 drivers/net/wireless/mediatek/mt76/mt76x0/mt76x0.h | 1 +
 drivers/net/wireless/mediatek/mt76/mt76x0/usb.c    | 4 ++++
 3 files changed, 6 insertions(+), 1 deletion(-)

diff --git a/drivers/net/wireless/mediatek/mt76/mt76x0/init.c b/drivers/net/wireless/mediatek/mt76/mt76x0/init.c
index b65b76d80906..7cdb3e740522 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76x0/init.c
+++ b/drivers/net/wireless/mediatek/mt76/mt76x0/init.c
@@ -62,7 +62,7 @@
 		dev_err(dev->mt76.dev, "Error: PLL and XTAL check failed!\n");
 }
 
-static void mt76x0_chip_onoff(struct mt76x0_dev *dev, bool enable, bool reset)
+void mt76x0_chip_onoff(struct mt76x0_dev *dev, bool enable, bool reset)
 {
 	u32 val;
 
diff --git a/drivers/net/wireless/mediatek/mt76/mt76x0/mt76x0.h b/drivers/net/wireless/mediatek/mt76/mt76x0/mt76x0.h
index 49b82a23533c..9e60fcb14687 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76x0/mt76x0.h
+++ b/drivers/net/wireless/mediatek/mt76/mt76x0/mt76x0.h
@@ -288,6 +288,7 @@ int mt76x0_burst_write_regs(struct mt76x0_dev *dev, u32 offset,
 int mt76x0_init_hardware(struct mt76x0_dev *dev);
 int mt76x0_register_device(struct mt76x0_dev *dev);
 void mt76x0_cleanup(struct mt76x0_dev *dev);
+void mt76x0_chip_onoff(struct mt76x0_dev *dev, bool enable, bool reset);
 
 int mt76x0_mac_start(struct mt76x0_dev *dev);
 void mt76x0_mac_stop(struct mt76x0_dev *dev);
diff --git a/drivers/net/wireless/mediatek/mt76/mt76x0/usb.c b/drivers/net/wireless/mediatek/mt76/mt76x0/usb.c
index 0871fdef59c3..7a635cdcbae0 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76x0/usb.c
+++ b/drivers/net/wireless/mediatek/mt76/mt76x0/usb.c
@@ -283,6 +283,10 @@ static int mt76x0_probe(struct usb_interface *usb_intf,
 	ret = mt76x0_assign_pipes(usb_intf, dev);
 	if (ret)
 		goto err;
+
+	/* Disable the HW, otherwise MCU fail to initalize on hot reboot */
+	mt76x0_chip_onoff(dev, false, false);
+
 	ret = mt76x0_wait_asic_ready(dev);
 	if (ret)
 		goto err;
-- 
1.9.3
