Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ew0-f207.google.com ([209.85.219.207]:42724 "EHLO
	mail-ew0-f207.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758688AbZKETWA convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 5 Nov 2009 14:22:00 -0500
Received: by ewy3 with SMTP id 3so331579ewy.37
        for <linux-wireless@vger.kernel.org>; Thu, 05 Nov 2009 11:22:05 -0800 (PST)
From: Ivo van Doorn <ivdoorn@gmail.com>
To: John Linville <linville@tuxdriver.com>
Subject: [PATCH] rt2x00: Don't queue ieee80211 work after USB removal
Date: Thu, 5 Nov 2009 20:22:03 +0100
Cc: users@rt2x00.serialmonkey.com, linux-wireless@vger.kernel.org,
	Sean Cross <sean@chumby.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Message-Id: <200911052022.03491.IvDoorn@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Sean Cross <sean@chumby.com>

This prevents the rt2x00 driver from queueing ieee80211 work after the  
USB card has been removed, preventing a kernel panic.

Signed-off-by: Sean Cross <sean@chumby.com>
Signed-off-by: Ivo van Doorn <IvDoorn@gmail.com>
---
diff --git a/drivers/net/wireless/rt2x00/rt2x00dev.c b/drivers/net/wireless/rt2x00/rt2x00dev.c
index 71761b3..73bbec5 100644
--- a/drivers/net/wireless/rt2x00/rt2x00dev.c
+++ b/drivers/net/wireless/rt2x00/rt2x00dev.c
@@ -815,6 +815,8 @@ int rt2x00lib_probe_dev(struct rt2x00_dev *rt2x00dev)
 
 	mutex_init(&rt2x00dev->csr_mutex);
 
+	set_bit(DEVICE_STATE_PRESENT, &rt2x00dev->flags);
+
 	/*
 	 * Make room for rt2x00_intf inside the per-interface
 	 * structure ieee80211_vif.
@@ -871,8 +873,6 @@ int rt2x00lib_probe_dev(struct rt2x00_dev *rt2x00dev)
 	rt2x00leds_register(rt2x00dev);
 	rt2x00debug_register(rt2x00dev);
 
-	set_bit(DEVICE_STATE_PRESENT, &rt2x00dev->flags);
-
 	return 0;
 
 exit:
diff --git a/drivers/net/wireless/rt2x00/rt2x00link.c b/drivers/net/wireless/rt2x00/rt2x00link.c
index c64db0b..c708d0b 100644
--- a/drivers/net/wireless/rt2x00/rt2x00link.c
+++ b/drivers/net/wireless/rt2x00/rt2x00link.c
@@ -362,8 +362,9 @@ void rt2x00link_start_tuner(struct rt2x00_dev *rt2x00dev)
 
 	rt2x00link_reset_tuner(rt2x00dev, false);
 
-	ieee80211_queue_delayed_work(rt2x00dev->hw,
-				     &link->work, LINK_TUNE_INTERVAL);
+	if (test_bit(DEVICE_STATE_PRESENT, &rt2x00dev->flags))
+		ieee80211_queue_delayed_work(rt2x00dev->hw,
+					     &link->work, LINK_TUNE_INTERVAL);
 }
 
 void rt2x00link_stop_tuner(struct rt2x00_dev *rt2x00dev)
@@ -469,8 +470,10 @@ static void rt2x00link_tuner(struct work_struct *work)
 	 * Increase tuner counter, and reschedule the next link tuner run.
 	 */
 	link->count++;
-	ieee80211_queue_delayed_work(rt2x00dev->hw,
-				     &link->work, LINK_TUNE_INTERVAL);
+
+	if (test_bit(DEVICE_STATE_PRESENT, &rt2x00dev->flags))
+		ieee80211_queue_delayed_work(rt2x00dev->hw,
+					     &link->work, LINK_TUNE_INTERVAL);
 }
 
 void rt2x00link_register(struct rt2x00_dev *rt2x00dev)
diff --git a/drivers/net/wireless/rt2x00/rt2x00usb.c b/drivers/net/wireless/rt2x00/rt2x00usb.c
index 5015448..f02b48a 100644
--- a/drivers/net/wireless/rt2x00/rt2x00usb.c
+++ b/drivers/net/wireless/rt2x00/rt2x00usb.c
@@ -47,6 +47,8 @@ int rt2x00usb_vendor_request(struct rt2x00_dev *rt2x00dev,
 	    (requesttype == USB_VENDOR_REQUEST_IN) ?
 	    usb_rcvctrlpipe(usb_dev, 0) : usb_sndctrlpipe(usb_dev, 0);
 
+	if (!test_bit(DEVICE_STATE_PRESENT, &rt2x00dev->flags))
+		return -ENODEV;
 
 	for (i = 0; i < REGISTER_BUSY_COUNT; i++) {
 		status = usb_control_msg(usb_dev, pipe, request, requesttype,
@@ -60,8 +62,10 @@ int rt2x00usb_vendor_request(struct rt2x00_dev *rt2x00dev,
 		 * -ENODEV: Device has disappeared, no point continuing.
 		 * All other errors: Try again.
 		 */
-		else if (status == -ENODEV)
+		else if (status == -ENODEV) {
+			clear_bit(DEVICE_STATE_PRESENT, &rt2x00dev->flags);
 			break;
+		}
 	}
 
 	ERROR(rt2x00dev,
@@ -161,6 +165,9 @@ int rt2x00usb_regbusy_read(struct rt2x00_dev *rt2x00dev,
 {
 	unsigned int i;
 
+	if (!test_bit(DEVICE_STATE_PRESENT, &rt2x00dev->flags))
+		return -ENODEV;
+
 	for (i = 0; i < REGISTER_BUSY_COUNT; i++) {
 		rt2x00usb_register_read_lock(rt2x00dev, offset, reg);
 		if (!rt2x00_get_field32(*reg, field))
