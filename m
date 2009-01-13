Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ew0-f17.google.com ([209.85.219.17]:56649 "EHLO
	mail-ew0-f17.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754265AbZAMWAQ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 13 Jan 2009 17:00:16 -0500
Received: by ewy10 with SMTP id 10so305330ewy.13
        for <linux-wireless@vger.kernel.org>; Tue, 13 Jan 2009 14:00:14 -0800 (PST)
MIME-Version: 1.0
Date: Wed, 14 Jan 2009 00:00:13 +0200
Message-ID: <eb3ff54b0901131400x64a4812fje2ee233c37546c1e@mail.gmail.com> (sfid-20090113_230022_885680_78F4243B)
Subject: [PATCH] rt2x00: fix a wrong parameter for __test_and_clear_bit() in
	rt2x00rfkill_free().
From: Rami Rosen <ramirose@gmail.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org, rt2400-devel@lists.sourceforge.net,
	IvDoorn@gmail.com
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

When running modprobe rt73usb, and then rmmod rt73usb, and then
iwconfig, the wlan0 device does not disappear. When repeating this
process again, we get a kernel Oops errors and "BUG: unable to handle
kernel paging request..." message in the kernel log.

The reason for this is that there is an error in rt2x00rfkill_free(),
which is called in the process of removing the device
(rt2x00lib_remove_dev() in rt2x00dev.c).
rt2x00rfkill_free() clears the RFKILL_STATE_ALLOCATED bit , which is
bit number 1 () in rt2x00dev->flags instead of in
rt2x00dev->rfkill_state. As a result, when checking the
DEVICE_STATE_REGISTERED_HW bit (bit number 1 in rt2x00dev->flags) in
rt2x00lib_remove_hw() it is **unset**, and we wrongly **don't** call
ieee80211_unregister_hw().

This patch corrects this: the parameter for __test_and_clear_bit() in
rt2x00rfkill_free() should be &rt2x00dev->rfkill_state and not
&rt2x00dev->flags.

Signed-off-by: Rami Rosen <ramirose@gmail.com>

---
(wireless-testing).

diff --git a/drivers/net/wireless/rt2x00/rt2x00rfkill.c
b/drivers/net/wireless/rt2x00/rt2x00rfkill.c
index 0b089ec..735a22d 100644
--- a/drivers/net/wireless/rt2x00/rt2x00rfkill.c
+++ b/drivers/net/wireless/rt2x00/rt2x00rfkill.c
@@ -118,7 +118,7 @@ void rt2x00rfkill_allocate(struct rt2x00_dev *rt2x00dev)

 void rt2x00rfkill_free(struct rt2x00_dev *rt2x00dev)
 {
-	if (!__test_and_clear_bit(RFKILL_STATE_ALLOCATED, &rt2x00dev->flags))
+	if (!__test_and_clear_bit(RFKILL_STATE_ALLOCATED, &rt2x00dev->rfkill_state))
 		return;

 	input_free_polled_device(rt2x00dev->rfkill_poll_dev);
