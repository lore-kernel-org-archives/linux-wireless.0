Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mms1.broadcom.com ([216.31.210.17]:2822 "EHLO mms1.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755158Ab3IYKLU (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 25 Sep 2013 06:11:20 -0400
From: "Arend van Spriel" <arend@broadcom.com>
To: "John W. Linville" <linville@tuxdriver.com>
cc: linux-wireless <linux-wireless@vger.kernel.org>,
	"Arend van Spriel" <arend@broadcom.com>, stable@vger.kernel.org
Subject: [PATCH for-3.12 1/3] brcmfmac: obtain platform data upon module
 initialization
Date: Wed, 25 Sep 2013 12:11:01 +0200
Message-ID: <1380103864-10447-2-git-send-email-arend@broadcom.com> (sfid-20130925_121135_879900_166091D0)
In-Reply-To: <1380103864-10447-1-git-send-email-arend@broadcom.com>
References: <1380103864-10447-1-git-send-email-arend@broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The driver uses platform_driver_probe() to obtain platform data
if any. However, that function is placed in the .init section so
it must be called upon driver module initialization.

The problem was reported by Fenguang Wu resulting in a kernel
oops because the .init section was already freed.

[   48.966342] Switched to clocksource tsc
[   48.970002] kernel tried to execute NX-protected page - exploit attempt? (uid: 0)
[   48.970851] BUG: unable to handle kernel paging request at ffffffff82196446
[   48.970957] IP: [<ffffffff82196446>] classes_init+0x26/0x26
[   48.970957] PGD 1e76067 PUD 1e77063 PMD f388063 PTE 8000000002196163
[   48.970957] Oops: 0011 [#1]
[   48.970957] CPU: 0 PID: 17 Comm: kworker/0:1 Not tainted 3.11.0-rc7-00444-gc52dd7f #23
[   48.970957] Workqueue: events brcmf_driver_init
[   48.970957] task: ffff8800001d2000 ti: ffff8800001d4000 task.ti: ffff8800001d4000
[   48.970957] RIP: 0010:[<ffffffff82196446>]  [<ffffffff82196446>] classes_init+0x26/0x26
[   48.970957] RSP: 0000:ffff8800001d5d40  EFLAGS: 00000286
[   48.970957] RAX: 0000000000000001 RBX: ffffffff820c5620 RCX: 0000000000000000
[   48.970957] RDX: 0000000000000001 RSI: ffffffff816f7380 RDI: ffffffff820c56c0
[   48.970957] RBP: ffff8800001d5d50 R08: ffff8800001d2508 R09: 0000000000000002
[   48.970957] R10: 0000000000000000 R11: 0001f7ce298c5620 R12: ffff8800001c76b0
[   48.970957] R13: ffffffff81e91d40 R14: 0000000000000000 R15: ffff88000e0ce300
[   48.970957] FS:  0000000000000000(0000) GS:ffffffff81e84000(0000) knlGS:0000000000000000
[   48.970957] CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
[   48.970957] CR2: ffffffff82196446 CR3: 0000000001e75000 CR4: 00000000000006b0
[   48.970957] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
[   48.970957] DR3: 0000000000000000 DR6: 0000000000000000 DR7: 0000000000000000
[   48.970957] Stack:
[   48.970957]  ffffffff816f7df8 ffffffff820c5620 ffff8800001d5d60 ffffffff816eeec9
[   48.970957]  ffff8800001d5de0 ffffffff81073dc5 ffffffff81073d68 ffff8800001d5db8
[   48.970957]  0000000000000086 ffffffff820c5620 ffffffff824f7fd0 0000000000000000
[   48.970957] Call Trace:
[   48.970957]  [<ffffffff816f7df8>] ? brcmf_sdio_init+0x18/0x70
[   48.970957]  [<ffffffff816eeec9>] brcmf_driver_init+0x9/0x10
[   48.970957]  [<ffffffff81073dc5>] process_one_work+0x1d5/0x480
[   48.970957]  [<ffffffff81073d68>] ? process_one_work+0x178/0x480
[   48.970957]  [<ffffffff81074188>] worker_thread+0x118/0x3a0
[   48.970957]  [<ffffffff81074070>] ? process_one_work+0x480/0x480
[   48.970957]  [<ffffffff8107aa17>] kthread+0xe7/0xf0
[   48.970957]  [<ffffffff810829f7>] ? finish_task_switch.constprop.57+0x37/0xd0
[   48.970957]  [<ffffffff8107a930>] ? __kthread_parkme+0x80/0x80
[   48.970957]  [<ffffffff81a6923a>] ret_from_fork+0x7a/0xb0
[   48.970957]  [<ffffffff8107a930>] ? __kthread_parkme+0x80/0x80
[   48.970957] Code: cc cc cc cc cc cc cc cc cc cc cc cc cc cc cc cc cc cc cc cc cc cc cc cc cc cc cc cc cc cc cc cc cc cc cc cc cc
cc cc cc cc cc cc <cc> cc cc cc cc cc cc cc cc cc cc cc cc cc cc cc cc cc cc cc cc
[   48.970957] RIP  [<ffffffff82196446>] classes_init+0x26/0x26
[   48.970957]  RSP <ffff8800001d5d40>
[   48.970957] CR2: ffffffff82196446
[   48.970957] ---[ end trace 62980817cd525f14 ]---

Cc: <stable@vger.kernel.org> # 3.10.x, 3.11.x
Reported-by: Fengguang Wu <fengguang.wu@intel.com>
Reviewed-by: Hante Meuleman <meuleman@broadcom.com>
Reviewed-by: Pieter-Paul Giesberts <pieterpg@broadcom.com>
Tested-by: Fengguang Wu <fengguang.wu@intel.com>
Signed-off-by: Arend van Spriel <arend@broadcom.com>
---
 .../net/wireless/brcm80211/brcmfmac/bcmsdh_sdmmc.c |   28 +++++++++-----------
 drivers/net/wireless/brcm80211/brcmfmac/dhd_bus.h  |    3 ++-
 .../net/wireless/brcm80211/brcmfmac/dhd_linux.c    |   14 +++++-----
 drivers/net/wireless/brcm80211/brcmfmac/usb.c      |    2 +-
 4 files changed, 24 insertions(+), 23 deletions(-)

diff --git a/drivers/net/wireless/brcm80211/brcmfmac/bcmsdh_sdmmc.c b/drivers/net/wireless/brcm80211/brcmfmac/bcmsdh_sdmmc.c
index 64f4a2b..c3462b7 100644
--- a/drivers/net/wireless/brcm80211/brcmfmac/bcmsdh_sdmmc.c
+++ b/drivers/net/wireless/brcm80211/brcmfmac/bcmsdh_sdmmc.c
@@ -464,8 +464,6 @@ static struct sdio_driver brcmf_sdmmc_driver = {
 
 static int brcmf_sdio_pd_probe(struct platform_device *pdev)
 {
-	int ret;
-
 	brcmf_dbg(SDIO, "Enter\n");
 
 	brcmfmac_sdio_pdata = pdev->dev.platform_data;
@@ -473,11 +471,7 @@ static int brcmf_sdio_pd_probe(struct platform_device *pdev)
 	if (brcmfmac_sdio_pdata->power_on)
 		brcmfmac_sdio_pdata->power_on();
 
-	ret = sdio_register_driver(&brcmf_sdmmc_driver);
-	if (ret)
-		brcmf_err("sdio_register_driver failed: %d\n", ret);
-
-	return ret;
+	return 0;
 }
 
 static int brcmf_sdio_pd_remove(struct platform_device *pdev)
@@ -500,6 +494,15 @@ static struct platform_driver brcmf_sdio_pd = {
 	}
 };
 
+void brcmf_sdio_register(void)
+{
+	int ret;
+
+	ret = sdio_register_driver(&brcmf_sdmmc_driver);
+	if (ret)
+		brcmf_err("sdio_register_driver failed: %d\n", ret);
+}
+
 void brcmf_sdio_exit(void)
 {
 	brcmf_dbg(SDIO, "Enter\n");
@@ -510,18 +513,13 @@ void brcmf_sdio_exit(void)
 		sdio_unregister_driver(&brcmf_sdmmc_driver);
 }
 
-void brcmf_sdio_init(void)
+void __init brcmf_sdio_init(void)
 {
 	int ret;
 
 	brcmf_dbg(SDIO, "Enter\n");
 
 	ret = platform_driver_probe(&brcmf_sdio_pd, brcmf_sdio_pd_probe);
-	if (ret == -ENODEV) {
-		brcmf_dbg(SDIO, "No platform data available, registering without.\n");
-		ret = sdio_register_driver(&brcmf_sdmmc_driver);
-	}
-
-	if (ret)
-		brcmf_err("driver registration failed: %d\n", ret);
+	if (ret == -ENODEV)
+		brcmf_dbg(SDIO, "No platform data available.\n");
 }
diff --git a/drivers/net/wireless/brcm80211/brcmfmac/dhd_bus.h b/drivers/net/wireless/brcm80211/brcmfmac/dhd_bus.h
index f7c1985..74156f8 100644
--- a/drivers/net/wireless/brcm80211/brcmfmac/dhd_bus.h
+++ b/drivers/net/wireless/brcm80211/brcmfmac/dhd_bus.h
@@ -156,10 +156,11 @@ extern int brcmf_bus_start(struct device *dev);
 #ifdef CONFIG_BRCMFMAC_SDIO
 extern void brcmf_sdio_exit(void);
 extern void brcmf_sdio_init(void);
+extern void brcmf_sdio_register(void);
 #endif
 #ifdef CONFIG_BRCMFMAC_USB
 extern void brcmf_usb_exit(void);
-extern void brcmf_usb_init(void);
+extern void brcmf_usb_register(void);
 #endif
 
 #endif				/* _BRCMF_BUS_H_ */
diff --git a/drivers/net/wireless/brcm80211/brcmfmac/dhd_linux.c b/drivers/net/wireless/brcm80211/brcmfmac/dhd_linux.c
index e067aec..40e7f85 100644
--- a/drivers/net/wireless/brcm80211/brcmfmac/dhd_linux.c
+++ b/drivers/net/wireless/brcm80211/brcmfmac/dhd_linux.c
@@ -1231,21 +1231,23 @@ u32 brcmf_get_chip_info(struct brcmf_if *ifp)
 	return bus->chip << 4 | bus->chiprev;
 }
 
-static void brcmf_driver_init(struct work_struct *work)
+static void brcmf_driver_register(struct work_struct *work)
 {
-	brcmf_debugfs_init();
-
 #ifdef CONFIG_BRCMFMAC_SDIO
-	brcmf_sdio_init();
+	brcmf_sdio_register();
 #endif
 #ifdef CONFIG_BRCMFMAC_USB
-	brcmf_usb_init();
+	brcmf_usb_register();
 #endif
 }
-static DECLARE_WORK(brcmf_driver_work, brcmf_driver_init);
+static DECLARE_WORK(brcmf_driver_work, brcmf_driver_register);
 
 static int __init brcmfmac_module_init(void)
 {
+	brcmf_debugfs_init();
+#ifdef CONFIG_BRCMFMAC_SDIO
+	brcmf_sdio_init();
+#endif
 	if (!schedule_work(&brcmf_driver_work))
 		return -EBUSY;
 
diff --git a/drivers/net/wireless/brcm80211/brcmfmac/usb.c b/drivers/net/wireless/brcm80211/brcmfmac/usb.c
index 39e01a7..f4aea47 100644
--- a/drivers/net/wireless/brcm80211/brcmfmac/usb.c
+++ b/drivers/net/wireless/brcm80211/brcmfmac/usb.c
@@ -1539,7 +1539,7 @@ void brcmf_usb_exit(void)
 	brcmf_release_fw(&fw_image_list);
 }
 
-void brcmf_usb_init(void)
+void brcmf_usb_register(void)
 {
 	brcmf_dbg(USB, "Enter\n");
 	INIT_LIST_HEAD(&fw_image_list);
-- 
1.7.10.4


