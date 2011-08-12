Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:13595 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751130Ab1HLMDI (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 12 Aug 2011 08:03:08 -0400
From: Stanislaw Gruszka <sgruszka@redhat.com>
To: "John W. Linville" <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org, Ivo van Doorn <IvDoorn@gmail.com>,
	Gertjan van Wingerde <gwingerde@gmail.com>,
	Helmut Schaa <helmut.schaa@googlemail.com>,
	Stanislaw Gruszka <sgruszka@redhat.com>, stable@kernel.org
Subject: [PATCH] rt2x00: do not drop usb dev reference counter on suspend
Date: Fri, 12 Aug 2011 14:02:04 +0200
Message-Id: <1313150524-13290-1-git-send-email-sgruszka@redhat.com> (sfid-20110812_140314_509819_9D9A107E)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

When hibernating ->resume may not be called by usb core, but disconnect
and probe instead, so we do not increase the counter after decreasing
it in ->supend. As a result we free memory early, and get crash when
unplugging usb dongle.

BUG: unable to handle kernel paging request at 6b6b6b9f
IP: [<c06909b0>] driver_sysfs_remove+0x10/0x30
*pdpt = 0000000034f21001 *pde = 0000000000000000
Pid: 20, comm: khubd Not tainted 3.1.0-rc1-wl+ #20 LENOVO 6369CTO/6369CTO
EIP: 0060:[<c06909b0>] EFLAGS: 00010202 CPU: 1
EIP is at driver_sysfs_remove+0x10/0x30
EAX: 6b6b6b6b EBX: f52bba34 ECX: 00000000 EDX: 6b6b6b6b
ESI: 6b6b6b6b EDI: c0a0ea20 EBP: f61c9e68 ESP: f61c9e64
 DS: 007b ES: 007b FS: 00d8 GS: 00e0 SS: 0068
Process khubd (pid: 20, ti=f61c8000 task=f6138270 task.ti=f61c8000)
Call Trace:
 [<c06909ef>] __device_release_driver+0x1f/0xa0
 [<c0690b20>] device_release_driver+0x20/0x40
 [<c068fd64>] bus_remove_device+0x84/0xe0
 [<c068e12a>] ? device_remove_attrs+0x2a/0x80
 [<c068e267>] device_del+0xe7/0x170
 [<c06d93d4>] usb_disconnect+0xd4/0x180
 [<c06d9d61>] hub_thread+0x691/0x1600
 [<c0473260>] ? wake_up_bit+0x30/0x30
 [<c0442a39>] ? complete+0x49/0x60
 [<c06d96d0>] ? hub_disconnect+0xd0/0xd0
 [<c06d96d0>] ? hub_disconnect+0xd0/0xd0
 [<c0472eb4>] kthread+0x74/0x80
 [<c0472e40>] ? kthread_worker_fn+0x150/0x150
 [<c0809b3e>] kernel_thread_helper+0x6/0x10

Cc: stable@kernel.org
Signed-off-by: Stanislaw Gruszka <sgruszka@redhat.com>
---
 drivers/net/wireless/rt2x00/rt2x00usb.c |   14 +-------------
 1 files changed, 1 insertions(+), 13 deletions(-)

diff --git a/drivers/net/wireless/rt2x00/rt2x00usb.c b/drivers/net/wireless/rt2x00/rt2x00usb.c
index 7fbb55c..1e31050 100644
--- a/drivers/net/wireless/rt2x00/rt2x00usb.c
+++ b/drivers/net/wireless/rt2x00/rt2x00usb.c
@@ -871,18 +871,8 @@ int rt2x00usb_suspend(struct usb_interface *usb_intf, pm_message_t state)
 {
 	struct ieee80211_hw *hw = usb_get_intfdata(usb_intf);
 	struct rt2x00_dev *rt2x00dev = hw->priv;
-	int retval;
-
-	retval = rt2x00lib_suspend(rt2x00dev, state);
-	if (retval)
-		return retval;
 
-	/*
-	 * Decrease usbdev refcount.
-	 */
-	usb_put_dev(interface_to_usbdev(usb_intf));
-
-	return 0;
+	return rt2x00lib_suspend(rt2x00dev, state);
 }
 EXPORT_SYMBOL_GPL(rt2x00usb_suspend);
 
@@ -891,8 +881,6 @@ int rt2x00usb_resume(struct usb_interface *usb_intf)
 	struct ieee80211_hw *hw = usb_get_intfdata(usb_intf);
 	struct rt2x00_dev *rt2x00dev = hw->priv;
 
-	usb_get_dev(interface_to_usbdev(usb_intf));
-
 	return rt2x00lib_resume(rt2x00dev);
 }
 EXPORT_SYMBOL_GPL(rt2x00usb_resume);
-- 
1.7.1

