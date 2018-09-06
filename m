Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx3-rdu2.redhat.com ([66.187.233.73]:45244 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1728096AbeIFNy6 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 6 Sep 2018 09:54:58 -0400
From: Stanislaw Gruszka <sgruszka@redhat.com>
To: linux-wireless@vger.kernel.org
Cc: Lorenzo Bianconi <lorenzo.bianconi@redhat.com>,
        Felix Fietkau <nbd@nbd.name>,
        linux-mediatek@lists.infradead.org
Subject: [PATCH 34/42] mt76x0: do not free/alloc buffers during suspend/resume
Date: Thu,  6 Sep 2018 11:18:50 +0200
Message-Id: <1536225538-16454-35-git-send-email-sgruszka@redhat.com> (sfid-20180906_112034_267414_FB9AAF8E)
In-Reply-To: <1536225538-16454-1-git-send-email-sgruszka@redhat.com>
References: <1536225538-16454-1-git-send-email-sgruszka@redhat.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Lorenzo Bianconi <lorenzo.bianconi@redhat.com>

Do not free/alloc {tx,rx} buffers during suspend/resume phases
but use the ones previously allocated during hw probe.
Move {tx,rx}/mcu buffers allocation from mt76x0_init_hardware routine
to mt76x0_register_device

Signed-off-by: Lorenzo Bianconi <lorenzo.bianconi@redhat.com>
Signed-off-by: Stanislaw Gruszka <sgruszka@redhat.com>
---
 drivers/net/wireless/mediatek/mt76/mt76x0/init.c | 12 +++++---
 drivers/net/wireless/mediatek/mt76/mt76x0/mcu.c  |  6 ----
 drivers/net/wireless/mediatek/mt76/mt76x0/usb.c  | 38 ++++++++++++++++++------
 3 files changed, 37 insertions(+), 19 deletions(-)

diff --git a/drivers/net/wireless/mediatek/mt76/mt76x0/init.c b/drivers/net/wireless/mediatek/mt76/mt76x0/init.c
index deceece52492..8f4b3197ab95 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76x0/init.c
+++ b/drivers/net/wireless/mediatek/mt76/mt76x0/init.c
@@ -408,10 +408,6 @@ int mt76x0_init_hardware(struct mt76x0_dev *dev)
 	if (ret)
 		return ret;
 
-	ret = mt76u_alloc_queues(&dev->mt76);
-	if (ret < 0)
-		return ret;
-
 	mt76x0_init_mac_registers(dev);
 
 	if (!mt76_poll_msec(dev, MT_MAC_STATUS,
@@ -614,6 +610,14 @@ int mt76x0_register_device(struct mt76x0_dev *dev)
 	struct wiphy *wiphy = hw->wiphy;
 	int ret;
 
+	ret = mt76u_mcu_init_rx(mdev);
+	if (ret < 0)
+		return ret;
+
+	ret = mt76u_alloc_queues(mdev);
+	if (ret < 0)
+		return ret;
+
 	ret = mt76x0_init_hardware(dev);
 	if (ret)
 		return ret;
diff --git a/drivers/net/wireless/mediatek/mt76/mt76x0/mcu.c b/drivers/net/wireless/mediatek/mt76/mt76x0/mcu.c
index 7be2835f3b4f..29c0b3978af7 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76x0/mcu.c
+++ b/drivers/net/wireless/mediatek/mt76/mt76x0/mcu.c
@@ -387,11 +387,5 @@ int mt76x0_mcu_init(struct mt76x0_dev *dev)
 
 int mt76x0_mcu_cmd_init(struct mt76x0_dev *dev)
 {
-	int ret;
-
-	ret = mt76u_mcu_init_rx(&dev->mt76);
-	if (ret)
-		return ret;
-
 	return mt76x0_mcu_function_select(dev, Q_SELECT, 1);
 }
diff --git a/drivers/net/wireless/mediatek/mt76/mt76x0/usb.c b/drivers/net/wireless/mediatek/mt76/mt76x0/usb.c
index 09b544890450..fc8884c38f7e 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76x0/usb.c
+++ b/drivers/net/wireless/mediatek/mt76/mt76x0/usb.c
@@ -124,29 +124,49 @@ static void mt76x0_disconnect(struct usb_interface *usb_intf)
 	ieee80211_free_hw(dev->mt76.hw);
 }
 
-static int mt76x0_suspend(struct usb_interface *usb_intf, pm_message_t state)
+static int __maybe_unused mt76x0_suspend(struct usb_interface *usb_intf,
+					 pm_message_t state)
 {
 	struct mt76x0_dev *dev = usb_get_intfdata(usb_intf);
+	struct mt76_usb *usb = &dev->mt76.usb;
 
-	mt76x0_cleanup(dev);
+	mt76u_stop_queues(&dev->mt76);
+	mt76x0_mac_stop(dev);
+	usb_kill_urb(usb->mcu.res.urb);
 
 	return 0;
 }
 
-static int mt76x0_resume(struct usb_interface *usb_intf)
+static int __maybe_unused mt76x0_resume(struct usb_interface *usb_intf)
 {
 	struct mt76x0_dev *dev = usb_get_intfdata(usb_intf);
+	struct mt76_usb *usb = &dev->mt76.usb;
 	int ret;
 
-	ret = mt76x0_init_hardware(dev);
-	if (ret) {
-		mt76x0_cleanup(dev);
-		return ret;
-	}
+	reinit_completion(&usb->mcu.cmpl);
+	ret = mt76u_submit_buf(&dev->mt76, USB_DIR_IN,
+			       MT_EP_IN_CMD_RESP,
+			       &usb->mcu.res, GFP_KERNEL,
+			       mt76u_mcu_complete_urb,
+			       &usb->mcu.cmpl);
+	if (ret < 0)
+		goto err;
 
-	set_bit(MT76_STATE_INITIALIZED, &dev->mt76.state);
+	ret = mt76u_submit_rx_buffers(&dev->mt76);
+	if (ret < 0)
+		goto err;
+
+	tasklet_enable(&usb->rx_tasklet);
+	tasklet_enable(&usb->tx_tasklet);
+
+	ret = mt76x0_init_hardware(dev);
+	if (ret)
+		goto err;
 
 	return 0;
+err:
+	mt76x0_cleanup(dev);
+	return ret;
 }
 
 MODULE_DEVICE_TABLE(usb, mt76x0_device_table);
-- 
2.7.5
