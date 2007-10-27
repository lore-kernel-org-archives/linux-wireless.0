Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from fk-out-0910.google.com ([209.85.128.185]:14484 "EHLO
	fk-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751736AbXJ0LZP (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 27 Oct 2007 07:25:15 -0400
Received: by fk-out-0910.google.com with SMTP id z23so1035387fkz
        for <linux-wireless@vger.kernel.org>; Sat, 27 Oct 2007 04:25:14 -0700 (PDT)
To: "John W. Linville" <linville@tuxdriver.com>
Subject: [PATCH 12/21] rt2x00: Input-polldev requires input device
Date: Sat, 27 Oct 2007 13:40:25 +0200
Cc: rt2400-devel@lists.sourceforge.net, linux-wireless@vger.kernel.org
References: <200710271334.34192.IvDoorn@gmail.com>
In-Reply-To: <200710271334.34192.IvDoorn@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Message-Id: <200710271340.25324.IvDoorn@gmail.com> (sfid-20071027_124113_171763_1167ACE7)
From: Ivo van Doorn <ivdoorn@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

input-polldev requires a correctly allocated
and initialized input device to be set for the
input_polled_dev->input field.
Failure to do that will prevent correct polling
of the device.

Signed-off-by: Ivo van Doorn <IvDoorn@gmail.com>
---
 drivers/net/wireless/rt2x00/rt2x00rfkill.c |   35 ++++++++++++++++++++++++---
 1 files changed, 31 insertions(+), 4 deletions(-)

diff --git a/drivers/net/wireless/rt2x00/rt2x00rfkill.c b/drivers/net/wireless/rt2x00/rt2x00rfkill.c
index a0f8b8e..db513f1 100644
--- a/drivers/net/wireless/rt2x00/rt2x00rfkill.c
+++ b/drivers/net/wireless/rt2x00/rt2x00rfkill.c
@@ -68,8 +68,10 @@ static void rt2x00rfkill_poll(struct input_polled_dev *poll_dev)
 	struct rt2x00_dev *rt2x00dev = poll_dev->private;
 	int state = rt2x00dev->ops->lib->rfkill_poll(rt2x00dev);
 
-	if (rt2x00dev->rfkill->state != state)
+	if (rt2x00dev->rfkill->state != state) {
 		input_report_key(poll_dev->input, KEY_WLAN, 1);
+		input_report_key(poll_dev->input, KEY_WLAN, 0);
+	}
 }
 
 int rt2x00rfkill_register(struct rt2x00_dev *rt2x00dev)
@@ -114,7 +116,7 @@ int rt2x00rfkill_allocate(struct rt2x00_dev *rt2x00dev)
 	rt2x00dev->rfkill = rfkill_allocate(device, RFKILL_TYPE_WLAN);
 	if (!rt2x00dev->rfkill) {
 		ERROR(rt2x00dev, "Failed to allocate rfkill handler.\n");
-		return -ENOMEM;
+		goto exit;
 	}
 
 	rt2x00dev->rfkill->name = rt2x00dev->ops->name;
@@ -125,15 +127,39 @@ int rt2x00rfkill_allocate(struct rt2x00_dev *rt2x00dev)
 	rt2x00dev->poll_dev = input_allocate_polled_device();
 	if (!rt2x00dev->poll_dev) {
 		ERROR(rt2x00dev, "Failed to allocate polled device.\n");
-		rfkill_free(rt2x00dev->rfkill);
-		return -ENOMEM;
+		goto exit_free_rfkill;
 	}
 
 	rt2x00dev->poll_dev->private = rt2x00dev;
 	rt2x00dev->poll_dev->poll = rt2x00rfkill_poll;
 	rt2x00dev->poll_dev->poll_interval = RFKILL_POLL_INTERVAL;
 
+	rt2x00dev->poll_dev->input = input_allocate_device();
+	if (!rt2x00dev->poll_dev->input) {
+		ERROR(rt2x00dev, "Failed to allocate input device.\n");
+		goto exit_free_polldev;
+	}
+
+	rt2x00dev->poll_dev->input->name = rt2x00dev->ops->name;
+	rt2x00dev->poll_dev->input->phys = wiphy_name(rt2x00dev->hw->wiphy);
+	rt2x00dev->poll_dev->input->id.bustype = BUS_HOST;
+	rt2x00dev->poll_dev->input->id.vendor = 0x1814;
+	rt2x00dev->poll_dev->input->id.product = rt2x00dev->chip.rt;
+	rt2x00dev->poll_dev->input->id.version = rt2x00dev->chip.rev;
+	rt2x00dev->poll_dev->input->dev.parent = device;
+	rt2x00dev->poll_dev->input->evbit[0] = BIT(EV_KEY);
+	set_bit(KEY_WLAN, rt2x00dev->poll_dev->input->keybit);
+
 	return 0;
+
+exit_free_polldev:
+	input_free_polled_device(rt2x00dev->poll_dev);
+
+exit_free_rfkill:
+	rfkill_free(rt2x00dev->rfkill);
+
+exit:
+	return -ENOMEM;
 }
 
 void rt2x00rfkill_free(struct rt2x00_dev *rt2x00dev)
@@ -141,6 +167,7 @@ void rt2x00rfkill_free(struct rt2x00_dev *rt2x00dev)
 	if (!test_bit(CONFIG_SUPPORT_HW_BUTTON, &rt2x00dev->flags))
 		return;
 
+	input_free_device(rt2x00dev->poll_dev->input);
 	input_free_polled_device(rt2x00dev->poll_dev);
 	rfkill_free(rt2x00dev->rfkill);
 }
-- 
1.5.3.4

