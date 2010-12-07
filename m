Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pw0-f46.google.com ([209.85.160.46]:39038 "EHLO
	mail-pw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755307Ab0LGLCg (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 7 Dec 2010 06:02:36 -0500
Received: by pwj3 with SMTP id 3so2100669pwj.19
        for <linux-wireless@vger.kernel.org>; Tue, 07 Dec 2010 03:02:36 -0800 (PST)
From: Sujith <m.sujith@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Message-ID: <19710.5162.363700.175729@gargle.gargle.HOWL>
Date: Tue, 7 Dec 2010 16:32:02 +0530
To: linville@tuxdriver.com
CC: linux-wireless@vger.kernel.org
Subject: [PATCH 3/3] ath9k_htc: Fix panic on FW download failure
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Sujith Manoharan <Sujith.Manoharan@atheros.com>

Use the correct error condition exit in case firmware download
fails for some reason. Not doing so results in a panic:

usb 1-3: ath9k_htc: Transferred FW: ar9271.fw, size: 51280
usb 1-3: ath9k_htc: Firmware - ar9271.fw download failed
usb 1-3: ath9k_htc: Target is unresponsive
Failed to initialize the device
INFO: trying to register non-static key.
the code is fine but needs lockdep annotation.
turning off the locking correctness validator.
Pid: 2823, comm: insmod Tainted: G        W   2.6.37-rc4-wl #11
Call Trace:
[<ffffffff81090d7e>] __lock_acquire+0xe3e/0x1d00
[<ffffffff813a9f14>] ? restore_args+0x0/0x30
[<ffffffff81058af1>] ? vprintk+0x321/0x500
[<ffffffff81092290>] lock_acquire+0xa0/0x190
[<ffffffffa02a0eac>] ? usb_kill_anchored_urbs+0x1c/0x80 [usbcore]
[<ffffffff813a8ea8>] _raw_spin_lock_irq+0x48/0x60
[<ffffffffa02a0eac>] ? usb_kill_anchored_urbs+0x1c/0x80 [usbcore]
[<ffffffff813a53fd>] ? printk+0x3c/0x3f
[<ffffffffa02a0eac>] usb_kill_anchored_urbs+0x1c/0x80 [usbcore]
[<ffffffffa0055388>] ath9k_hif_usb_dealloc_urbs+0x18/0x40 [ath9k_htc]
[<ffffffffa00557d7>] ath9k_hif_usb_probe+0x227/0x3d0 [ath9k_htc]
[<ffffffffa02a56ac>] usb_probe_interface+0x10c/0x210 [usbcore]
[<ffffffff812ae826>] driver_probe_device+0x96/0x1c0
[<ffffffff812ae9f3>] __driver_attach+0xa3/0xb0
[<ffffffff812ae950>] ? __driver_attach+0x0/0xb0
[<ffffffff812ad6ae>] bus_for_each_dev+0x5e/0x90
[<ffffffff812ae4c9>] driver_attach+0x19/0x20
[<ffffffff812ae038>] bus_add_driver+0x168/0x320
[<ffffffff812aec71>] driver_register+0x71/0x140
[<ffffffff811fc338>] ? __raw_spin_lock_init+0x38/0x70
[<ffffffffa02a438c>] usb_register_driver+0xdc/0x190 [usbcore]
[<ffffffffa0063000>] ? ath9k_htc_init+0x0/0x4f [ath9k_htc]
[<ffffffffa005599e>] ath9k_hif_usb_init+0x1e/0x20 [ath9k_htc]
[<ffffffffa006302b>] ath9k_htc_init+0x2b/0x4f [ath9k_htc]
[<ffffffff8100212f>] do_one_initcall+0x3f/0x180
[<ffffffff8109ef9b>] sys_init_module+0xbb/0x200
[<ffffffff8100bf52>] system_call_fastpath+0x16/0x1b

Signed-off-by: Sujith Manoharan <Sujith.Manoharan@atheros.com>
---
 drivers/net/wireless/ath/ath9k/hif_usb.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/hif_usb.c b/drivers/net/wireless/ath/ath9k/hif_usb.c
index cc1e5b3..45d4b24 100644
--- a/drivers/net/wireless/ath/ath9k/hif_usb.c
+++ b/drivers/net/wireless/ath/ath9k/hif_usb.c
@@ -885,9 +885,9 @@ static int ath9k_hif_usb_dev_init(struct hif_device_usb *hif_dev, u32 drv_info)
 
 	return 0;
 
-err_fw_download:
-	ath9k_hif_usb_dealloc_urbs(hif_dev);
 err_urb:
+	ath9k_hif_usb_dealloc_urbs(hif_dev);
+err_fw_download:
 	release_firmware(hif_dev->firmware);
 err_fw_req:
 	hif_dev->firmware = NULL;
-- 
1.7.3.2

