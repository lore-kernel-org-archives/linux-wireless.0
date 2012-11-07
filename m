Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from ebb05.tieto.com ([131.207.168.36]:42887 "EHLO ebb05.tieto.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750910Ab2KGNmT convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 7 Nov 2012 08:42:19 -0500
From: <Janusz.Dziedzic@tieto.com>
To: <linux-wireless@vger.kernel.org>
CC: <arik@wizery.com>
Date: Wed, 7 Nov 2012 15:42:15 +0200
Subject: [PATCH 1/2] wlcore: add power callback for SPI
Message-ID: <3078A9B976EF864C8DDD0C499FFD07912383D6479F@EXMB01.eu.tieto.com> (sfid-20121107_144233_914057_F5AB1716)
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Add power callback also for SPI.
This will also fix a dump:

[  143.111602] Unable to handle kernel NULL pointer dereference at
virtual address 00000000
[  143.150573] pgd = dda58000
[  143.153472] [00000000] *pgd=9d812831, *pte=00000000, *ppte=00000000
[  143.181091] Internal error: Oops: 80000007 [#1] PREEMPT ARM
[  143.186981] Modules linked in: wlcore_spi(+) wl12xx wlcore mac80211
cfg80211 atmel_mxt pvrsrvkm ipv6
[  143.196655] CPU: 0    Not tainted  (3.5.3-00240-g17ca7c0-dirty #7)
[  143.203186] PC is at 0x0
[  143.206024] LR is at wl12xx_set_power_on+0x24/0xb0 [wlcore]
[  143.211883] pc : [<00000000>]    lr : [<bf162620>]    psr: 60000013
[  143.211883] sp : ddf23db0  ip : 00000002  fp : 00000000
[  143.223968] r10: 00000000  r9 : 00000000  r8 : dddae1a8
[  143.229522] r7 : 00000001  r6 : dddaeb5a  r5 : dddad8e0  r4 : dddad8e0
[  143.236389] r3 : 00000000  r2 : 00000000  r1 : 00000001  r0 : ddfef808
[  143.243255] Flags: nZCv  IRQs on  FIQs on  Mode SVC_32  ISA ARM  Segment user
[  143.250732] Control: 10c5387d  Table: 9da58019  DAC: 00000015
[  143.256774] Process insmod (pid: 442, stack limit = 0xddf222e8)
[  143.263000] Stack: (0xddf23db0 to 0xddf24000)
[  143.267578] 3da0:                                     dddad8e0
dddaeb70 00000008 dddad8e0
[  143.276153] 3dc0: 00000000 bf175ff8 ddfefa50 dddad8e0 ddfef808
c02bd12c 00000000 bf194f24
[  143.284729] 3de0: 00000000 c02be138 c02be124 c02bcf78 c02be318
ddfef808 c02bd12c 00000000
[  143.293304] 3e00: 00000000 c02bb968 de4038d8 dd8bed54 ddfef808
ddfef83c ddfef808 c02bd208
[  143.301879] 3e20: ddfef808 c06a8af0 ddfef808 c02bc394 ddfef808
ddfef810 de700c00 c02bb24c
[  143.310485] 3e40: ddfef810 00000000 00000000 de700c00 00000000
c0259ad4 ddfef800 ddfef800
[  143.319091] 3e60: 00000001 0000001c de700c00 00000000 ddf22000
00000000 00000000 c02be670
[  143.327636] 3e80: 00000000 dda62cc0 c067ea30 00000020 de700c00
bf19a730 de46bb08 00000000
[  143.336212] 3ea0: 00000000 bf19a8a5 00000400 00000000 00000000
00000000 de700c00 de700c34
[  143.344787] 3ec0: bf19a98c bf19a98c c000d804 c030bb5c c030bb44
c02bcf78 00000000 de700c00
[  143.353363] 3ee0: de700c34 bf19a98c 00000000 c02bd108 bf19a98c
c02bd0a0 00000000 c02bb9e8
[  143.361907] 3f00: de46baa8 de53fed0 bf19a98c dd9ff600 c06afb18
c02bc0d0 bf19a8f7 00000000
[  143.370483] 3f20: 00000000 bf19a98c bf19c000 00000000 00000000
c000d804 00000000 c02bd724
[  143.379089] 3f40: bf19a9c4 bf19c000 00000000 00000000 c000d804
c000863c 00000000 00000001
[  143.387664] 3f60: bf19a9c4 b6f7e2f0 00000000 bf19a9c4 b6f7e2f0
00000000 0002dc66 c000d804
[  143.396270] 3f80: ddf22000 c006b5d8 b6d80000 0002dc66 b6f7e2f0
00000000 00000000 00022db8
[  143.404876] 3fa0: 00000080 c000d660 00000000 00000000 b6d80000
0002dc66 b6f7e2f0 b6d80000
[  143.413513] 3fc0: 00000000 00000000 00022db8 00000080 00022d10
0002dc66 b6f7e2f0 00000000
[  143.422088] 3fe0: b6eee200 beaa68d8 b6f74ae4 b6eee210 60000010
b6d80000 fa0e0000 0e000061
[  143.430969] [<bf162620>] (wl12xx_set_power_on+0x24/0xb0 [wlcore])
from [<bf175ff8>] (wlcore_probe+0x3b4/0x678 [wlcore])
[  143.442474] [<bf175ff8>] (wlcore_probe+0x3b4/0x678 [wlcore]) from
[<c02be138>] (platform_drv_probe+0x14/0x18)
[  143.452880] [<c02be138>] (platform_drv_probe+0x14/0x18) from
[<c02bcf78>] (driver_probe_device+0xc8/0x1f0)
[  143.463012] [<c02bcf78>] (driver_probe_device+0xc8/0x1f0) from
[<c02bb968>] (bus_for_each_drv+0x48/0x80)
[  143.472961] [<c02bb968>] (bus_for_each_drv+0x48/0x80) from
[<c02bd208>] (device_attach+0x78/0xa4)
[  143.482269] [<c02bd208>] (device_attach+0x78/0xa4) from
[<c02bc394>] (bus_probe_device+0x28/0x9c)
[  143.491577] [<c02bc394>] (bus_probe_device+0x28/0x9c) from
[<c02bb24c>] (device_add+0x3d8/0x554)
[  143.500823] [<c02bb24c>] (device_add+0x3d8/0x554) from [<c02be670>]
(platform_device_add+0x104/0x160)
[  143.510528] [<c02be670>] (platform_device_add+0x104/0x160) from
[<bf19a730>] (wl1271_probe+0x140/0x19c [wlcore_spi])
[  143.521636] [<bf19a730>] (wl1271_probe+0x140/0x19c [wlcore_spi])
from [<c030bb5c>] (spi_drv_probe+0x18/0x1c)
[  143.531982] [<c030bb5c>] (spi_drv_probe+0x18/0x1c) from
[<c02bcf78>] (driver_probe_device+0xc8/0x1f0)
[  143.541687] [<c02bcf78>] (driver_probe_device+0xc8/0x1f0) from
[<c02bd108>] (__driver_attach+0x68/0x8c)
[  143.551544] [<c02bd108>] (__driver_attach+0x68/0x8c) from
[<c02bb9e8>] (bus_for_each_dev+0x48/0x74)
[  143.561065] [<c02bb9e8>] (bus_for_each_dev+0x48/0x74) from
[<c02bc0d0>] (bus_add_driver+0xa8/0x224)
[  143.570587] [<c02bc0d0>] (bus_add_driver+0xa8/0x224) from
[<c02bd724>] (driver_register+0xa0/0x12c)
[  143.580108] [<c02bd724>] (driver_register+0xa0/0x12c) from
[<c000863c>] (do_one_initcall+0x98/0x16c)
[  143.589721] [<c000863c>] (do_one_initcall+0x98/0x16c) from
[<c006b5d8>] (sys_init_module+0x70/0x18c)
[  143.599395] [<c006b5d8>] (sys_init_module+0x70/0x18c) from
[<c000d660>] (ret_fast_syscall+0x0/0x3c)
[  143.608886] Code: bad PC value
[  144.454803] ---[ end trace ba1722c65a7fd00a ]---

Signed-off-by: Janusz Dziedzic <janusz.dziedzic@tieto.com>
---
 drivers/net/wireless/ti/wlcore/spi.c |   10 ++++++++++
 1 file changed, 10 insertions(+)

diff --git a/drivers/net/wireless/ti/wlcore/spi.c b/drivers/net/wireless/ti/wlcore/spi.c
index a519bc3..368d250 100644
--- a/drivers/net/wireless/ti/wlcore/spi.c
+++ b/drivers/net/wireless/ti/wlcore/spi.c
@@ -316,11 +316,21 @@ static int __must_check wl12xx_spi_raw_write(struct device *child, int addr,
 	return 0;
 }
 
+static int wl12xx_spi_power(struct device *child, bool enable)
+{
+	struct wl1271 *wl = dev_get_drvdata(child);
+	if (wl->set_power)
+		wl->set_power(enable);
+
+	return 0;
+}
+
 static struct wl1271_if_operations spi_ops = {
 	.read		= wl12xx_spi_raw_read,
 	.write		= wl12xx_spi_raw_write,
 	.reset		= wl12xx_spi_reset,
 	.init		= wl12xx_spi_init,
+	.power		= wl12xx_spi_power,
 	.set_block_size = NULL,
 };
 
-- 
1.7.9.5
