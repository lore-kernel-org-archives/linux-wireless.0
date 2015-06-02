Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx4.wp.pl ([212.77.101.12]:54131 "EHLO mx4.wp.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751380AbbFBTLm (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 2 Jun 2015 15:11:42 -0400
From: Jakub Kicinski <moorray3@wp.pl>
To: Kalle Valo <kvalo@codeaurora.org>
Cc: linux-wireless <linux-wireless@vger.kernel.org>,
	Jakub Kicinski <kubakici@wp.pl>
Subject: [PATCH 3/4] mt7601u: don't cleanup device second time after .resume()
Date: Tue,  2 Jun 2015 21:11:27 +0200
Message-Id: <1433272288-6450-3-git-send-email-moorray3@wp.pl> (sfid-20150602_211147_137460_06B70566)
In-Reply-To: <1433272288-6450-1-git-send-email-moorray3@wp.pl>
References: <1433272288-6450-1-git-send-email-moorray3@wp.pl>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Jakub Kicinski <kubakici@wp.pl>

Make sure .disconnect() doesn't cleanup the device if
.resume() failed.  This may happen when device is removed
during suspend.

Signed-off-by: Jakub Kicinski <kubakici@wp.pl>
---
 drivers/net/wireless/mediatek/mt7601u/init.c | 3 +++
 drivers/net/wireless/mediatek/mt7601u/usb.c  | 9 ++++++++-
 2 files changed, 11 insertions(+), 1 deletion(-)

diff --git a/drivers/net/wireless/mediatek/mt7601u/init.c b/drivers/net/wireless/mediatek/mt7601u/init.c
index 1fc86e865c8c..45eb0796a2e5 100644
--- a/drivers/net/wireless/mediatek/mt7601u/init.c
+++ b/drivers/net/wireless/mediatek/mt7601u/init.c
@@ -427,6 +427,9 @@ err:
 
 void mt7601u_cleanup(struct mt7601u_dev *dev)
 {
+	if (!test_and_clear_bit(MT7601U_STATE_INITIALIZED, &dev->state))
+		return;
+
 	mt7601u_stop_hardware(dev);
 	mt7601u_dma_cleanup(dev);
 	mt7601u_mcu_cmd_deinit(dev);
diff --git a/drivers/net/wireless/mediatek/mt7601u/usb.c b/drivers/net/wireless/mediatek/mt7601u/usb.c
index 99e2b3997bfa..54dba4001865 100644
--- a/drivers/net/wireless/mediatek/mt7601u/usb.c
+++ b/drivers/net/wireless/mediatek/mt7601u/usb.c
@@ -338,8 +338,15 @@ static int mt7601u_suspend(struct usb_interface *usb_intf, pm_message_t state)
 static int mt7601u_resume(struct usb_interface *usb_intf)
 {
 	struct mt7601u_dev *dev = usb_get_intfdata(usb_intf);
+	int ret;
+
+	ret = mt7601u_init_hardware(dev);
+	if (ret)
+		return ret;
+
+	set_bit(MT7601U_STATE_INITIALIZED, &dev->state);
 
-	return mt7601u_init_hardware(dev);
+	return 0;
 }
 
 MODULE_DEVICE_TABLE(usb, mt7601u_device_table);
-- 
2.1.0

