Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from vwp2514.webpack.hosteurope.de ([87.230.42.24]:60779 "EHLO
	vwp2514.webpack.hosteurope.de" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758051Ab1GKQT0 convert rfc822-to-8bit
	(ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 11 Jul 2011 12:19:26 -0400
Subject: kernel NULL pointer dereference in lbs_set_11d_domain_info
 (3.0-rc6)
From: Sven Neumann <s.neumann@raumfeld.com>
To: libertas-dev@lists.infradead.org, linux-wireless@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 11 Jul 2011 17:59:41 +0200
Message-ID: <1310399981.11331.4.camel@sven> (sfid-20110711_181931_503671_E45099A0)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi,

we are using a PXA device and I am observing sporadic crashes after
resume from suspend with 3.0-rc6:


[ 1296.027645] PM: resume of devices complete after 296.440 msecs
[ 1296.284633] Restarting tasks ... 
[ 1296.320276] done.
[ 1296.421618] mmc0: new SDIO card at address 0001
[ 1297.312570] libertas_sdio mmc0:0001:1: (unregistered net_device): 00:19:88:11:db:67, fw 9.70.7p0, cap 0x00000303
[ 1297.333727] Unable to handle kernel NULL pointer dereference at virtual address 00000008
[ 1297.346369] pgd = c0004000
[ 1297.353249] [00000008] *pgd=00000000
[ 1297.358973] Internal error: Oops: 17 [#1] PREEMPT
[ 1297.363655] Modules linked in: eeti_ts libertas_sdio libertas pxamci ds2760_battery w1_ds2760 w1_gpio wire
[ 1297.373310] CPU: 0    Tainted: G        W    (3.0.0-rc6 #1)
[ 1297.378930] PC is at lbs_set_11d_domain_info+0x28/0x1e4 [libertas]
[ 1297.385101] LR is at lbs_set_11d_domain_info+0x24/0x1e4 [libertas]
[ 1297.391246] pc : [<bf01d864>]    lr : [<bf01d860>]    psr: 40000013
[ 1297.391258] sp : c6551c18  ip : 00000000  fp : 00000002
[ 1297.402648] r10: 0000000e  r9 : 000001f8  r8 : c66c80e0
[ 1297.407835] r7 : 00000000  r6 : 00000036  r5 : bf023b60  r4 : 00000000
[ 1297.414315] r3 : fffffefe  r2 : 00000000  r1 : ffffffc8  r0 : c6551d38
[ 1297.420804] Flags: nZcv  IRQs on  FIQs on  Mode SVC_32  ISA ARM  Segment kernel
[ 1297.428065] Control: 0000397f  Table: a6580018  DAC: 00000035
[ 1297.433779] Process kworker/u:2 (pid: 1615, stack limit = 0xc6550278)
[ 1297.440178] Stack: (0xc6551c18 to 0xc6552000)
[ 1297.444507] 1c00:                                                       c608edc0 c6395b9c
[ 1297.452636] 1c20: c66c8170 c66c8260 c6551c9c 00001c38 00000000 00000000 00000000 00000000
[ 1297.460768] 1c40: 00000000 00000000 00000000 00000000 00000000 00000000 00000000 00000000
[ 1297.468900] 1c60: 00000000 00000000 00000000 00000000 00000000 00000000 00000000 00000000
[ 1297.477034] 1c80: 00000000 00000000 00000000 00000000 00000000 00000000 00000000 00000000
[ 1297.485166] 1ca0: 00000000 00000000 00000000 00000000 00000000 00000000 00000000 00000000
[ 1297.493300] 1cc0: 00000000 00000000 00000000 00000000 00000000 00000000 00000000 00000000
[ 1297.501432] 1ce0: 00000000 00000000 00000000 00000000 00000000 00000000 00000000 00000000
[ 1297.509565] 1d00: 00000000 00000000 00000000 00000000 00000000 00000000 00000000 00000000
[ 1297.517699] 1d20: 00000000 00000000 00000000 00000000 00000000 00000000 c66c8188 bf023c5c
[ 1297.525832] 1d40: bf023b60 00000036 00000000 c66c80e0 000001f8 0000000e 00000002 c03b714c
[ 1297.533964] 1d60: 00000000 00000024 00000000 c022f684 0000000e 00000000 00000002 00000000
[ 1297.542099] 1d80: 00000002 c6551d9c c03b3fd4 00000000 c66c80e0 c66c8000 c66c8180 00000000
[ 1297.550232] 1da0: c6637a00 c6664900 00000000 c03b4008 c66c80e0 bf0238d4 c65b9000 c66c8260
[ 1297.558365] 1dc0: 00000000 c05951d0 0000fedc c65b9000 c66c8260 00000000 c05951d0 0000fedc
[ 1297.566499] 1de0: c6637a00 c6664900 c6551e30 bf01b17c c03f30d4 c66c8260 c6436400 bf020e64
[ 1297.574631] 1e00: c6551e30 c65e0000 c66c8260 bf02cbd8 bf02d39c c6551e38 c6551e34 00000001
[ 1297.582763] 1e20: 00000000 c6664908 00000000 c6664910 00000000 c669d600 c669da40 00000000
[ 1297.590896] 1e40: 0000000b 00000000 00000000 00000000 bf02d3fc c6664900 bf02d980 00000000
[ 1297.599029] 1e60: 00000000 c6664910 00000000 c02bccdc c6664910 00000000 c6664908 c6664908
[ 1297.607163] 1e80: bf02d980 c0231380 c6664910 00000000 c02314e8 c6664908 c6551ea0 c0230868
[ 1297.615296] 1ea0: c6065d08 c6430c94 c6664908 c6664908 c6664908 c666493c 00000001 c02315c4
[ 1297.623428] 1ec0: c6664900 c6664908 c6436000 c0230690 00000000 c022f5ec 00000000 c6437008
[ 1297.631561] 1ee0: 00000000 00000021 c6437000 c01e7fc4 c051a676 c6664900 c6664908 c6436000
[ 1297.639694] 1f00: 00000001 c6437000 00000001 c6437000 c6551f37 c02bcb10 00000000 00000000
[ 1297.647827] 1f20: 00000000 c02bc024 00000000 c6551f37 90ff8000 07000000 000002f5 c6436000
[ 1297.655960] 1f40: 00000000 c6436180 00061a80 c04959e0 c02b6708 00000000 c6055e45 c02b69cc
[ 1297.664094] 1f60: c6436180 c6431d80 00000012 00000089 c6055e00 c0071b28 c05d4eb8 c6431d80
[ 1297.672226] 1f80: c05d4eb8 c05d4eb8 00000089 c6550000 c6431d90 c05d4eb8 c6431d90 c0072310
[ 1297.680358] 1fa0: c6043f14 c6551fd4 c6043f14 c6431d80 c00720e8 00000000 00000000 00000000
[ 1297.688491] 1fc0: 00000000 c007804c c004a8fc 00000000 c6431d80 00000000 c6551fd8 c6551fd8
[ 1297.696624] 1fe0: 00000000 c6043f14 c0077fcc c004a8fc 00000013 c004a8fc 9a01d173 d1302a00
[ 1297.704835] [<bf01d864>] (lbs_set_11d_domain_info+0x28/0x1e4 [libertas]) from [<c03b714c>] (wiphy_update_regulatory+0x4d0/0x4f4)
[ 1297.716344] [<c03b714c>] (wiphy_update_regulatory+0x4d0/0x4f4) from [<c03b4008>] (wiphy_register+0x354/0x420)
[ 1297.726221] [<c03b4008>] (wiphy_register+0x354/0x420) from [<bf01b17c>] (lbs_cfg_register+0x80/0x164 [libertas])
[ 1297.736402] [<bf01b17c>] (lbs_cfg_register+0x80/0x164 [libertas]) from [<bf020e64>] (lbs_start_card+0x20/0x88 [libertas])
[ 1297.747342] [<bf020e64>] (lbs_start_card+0x20/0x88 [libertas]) from [<bf02cbd8>] (if_sdio_probe+0x898/0x9c0 [libertas_sdio])
[ 1297.758515] [<bf02cbd8>] (if_sdio_probe+0x898/0x9c0 [libertas_sdio]) from [<c02bccdc>] (sdio_bus_probe+0xcc/0xe8)
[ 1297.768727] [<c02bccdc>] (sdio_bus_probe+0xcc/0xe8) from [<c0231380>] (driver_probe_device+0xb4/0x198)
[ 1297.777982] [<c0231380>] (driver_probe_device+0xb4/0x198) from [<c0230868>] (bus_for_each_drv+0x4c/0x8c)
[ 1297.787406] [<c0230868>] (bus_for_each_drv+0x4c/0x8c) from [<c02315c4>] (device_attach+0x60/0x80)
[ 1297.796226] [<c02315c4>] (device_attach+0x60/0x80) from [<c0230690>] (bus_probe_device+0x28/0x54)
[ 1297.805069] [<c0230690>] (bus_probe_device+0x28/0x54) from [<c022f5ec>] (device_add+0x408/0x58c)
[ 1297.813809] [<c022f5ec>] (device_add+0x408/0x58c) from [<c02bcb10>] (sdio_add_func+0x38/0x54)
[ 1297.822291] [<c02bcb10>] (sdio_add_func+0x38/0x54) from [<c02bc024>] (mmc_attach_sdio+0x218/0x2d8)
[ 1297.831224] [<c02bc024>] (mmc_attach_sdio+0x218/0x2d8) from [<c02b69cc>] (mmc_rescan+0x2c4/0x350)
[ 1297.840068] [<c02b69cc>] (mmc_rescan+0x2c4/0x350) from [<c0071b28>] (process_one_work+0x264/0x3cc)
[ 1297.848988] [<c0071b28>] (process_one_work+0x264/0x3cc) from [<c0072310>] (worker_thread+0x228/0x460)
[ 1297.858167] [<c0072310>] (worker_thread+0x228/0x460) from [<c007804c>] (kthread+0x80/0x88)
[ 1297.866395] [<c007804c>] (kthread+0x80/0x88) from [<c004a8fc>] (kernel_thread_exit+0x0/0x8)
[ 1297.874705] Code: e59f11b4 e58d2008 eb47209f e59f31ac (e5d42008) 
[ 1297.889933] ---[ end trace e7fb9c417d5ba83a ]---


Any ideas what broke here?


Sven


-- 
Sven Neumann
Head of RAUMFELD Software Development

Lautsprecher Teufel GmbH | Bülowstr. 66 | 10783 Berlin | Germany
Tel: +49 (0)30-300 930 153 | s.neumann@raumfeld.com

