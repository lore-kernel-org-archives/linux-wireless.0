Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-vw0-f46.google.com ([209.85.212.46]:64981 "EHLO
	mail-vw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752285Ab2BUIVA (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 21 Feb 2012 03:21:00 -0500
Received: by vbjk17 with SMTP id k17so4010723vbj.19
        for <linux-wireless@vger.kernel.org>; Tue, 21 Feb 2012 00:20:59 -0800 (PST)
MIME-Version: 1.0
Date: Tue, 21 Feb 2012 16:20:59 +0800
Message-ID: <CAHPDcRvkopS0-5bXRpULEYvo9KBt=Mrp9o4ssoRdbVgia9qE1w@mail.gmail.com> (sfid-20120221_092104_421007_951FE1F7)
Subject: Kernel panic after reboot with wifi enabled
From: Yingang Fu <yingang.fu@gmail.com>
To: linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

hi, all

My platform equipped with a wl1271 wireless chip. The system crashed
randomly with following error messages when reboot the system
with wifi enabled.

>From the log, i found that there is a sdio_bus_remove function call in
the stack.
 I'm confused about that.
Does anybody know what happened to my driver?

Thanks
Yingang


<7>[    7.651404] ---proximity--- once = 0 	 now = 0
<6>[    8.621547] compass 5-001e: hmc5883_selftest: selftest
result(771, 757, 725)
<7>[    9.040450] alsps_int occur
<7>[    9.040844] als 5-001d: enter alsps_isr irq= 0x1 data= 0x8
<7>[    9.040881] light  adc = 8 	 once = 0 	 now = 389
<7>[   10.372657] Sensor ambient disable
<7>[   10.372943] Sensor proximity disabled
<1>[   15.507212] BUG: unable to handle kernel paging request at 0a36203e
<1>[   15.507354] IP: [<fb84b796>] cleanup_module+0x102/0x270 [wl12xx_sdio]
<4>[   15.507528] *pde = 00000000
<0>[   15.507645] Oops: 0000 [#1] PREEMPT SMP
<0>[   15.507806] last sysfs file:
/sys/devices/virtual/usb_composite/rndis/enable
<4>[   15.508026] Modules linked in: wl12xx_sdio(+) wl12xx mac80211
cfg80211 compat btwilink st_drv
<4>[   15.508380]
<4>[   15.508444] Pid: 1554, comm: WifiService Not tainted 2.6.35.3+ #1 /
<4>[   15.508645] EIP: 0060:[<fb84b796>] EFLAGS: 00010207 CPU: 0
<4>[   15.508827] EIP is at cleanup_module+0x102/0x270 [wl12xx_sdio]
<4>[   15.509015] EAX: 0a36203a EBX: e0bf0fe0 ECX: e0a22f30 EDX: ffffffed
<4>[   15.509211] ESI: 0a36203a EDI: f5a2a000 EBP: e0acde58 ESP: e0acde3c
<4>[   15.509408]  DS: 007b ES: 007b FS: 00d8 GS: 003b SS: 0068
<0>[   15.509581] Process WifiService (pid: 1554, ti=e0acc000
task=e0ac0b40 task.ti=e0acc000)
<0>[   15.509823] Stack:
<4>[   15.509895]  e0acde50 c15d827e 00000000 e0bf02e0 fb84bcd8
f5a2a000 f5a2a004 e0acde88
<4>[   15.510214] <0> c15e1b15 00000000 e0a2b0c0 f625ebd0 00000000
f5a2a004 fb84bd20 00000000
<4>[   15.510565] <0> f5a2a004 fb84bd30 00000001 e0acdeb8 c14b5a9e
00000001 f625f0f4 f625f154
<0>[   15.510941] Call Trace:
<4>[   15.511042]  [<c15d827e>] ? mmc_release_host+0xbe/0x110
<4>[   15.511221]  [<c15e1b15>] ? sdio_bus_probe+0xf5/0x1b0
<4>[   15.511398]  [<c14b5a9e>] ? driver_probe_device+0x17e/0x350
<4>[   15.511585]  [<c12358d5>] ? sub_preempt_count+0x85/0xc0
<4>[   15.511762]  [<c14b5cf1>] ? __driver_attach+0x81/0x90
<4>[   15.511958]  [<c14b4af3>] ? bus_for_each_dev+0x53/0x80
<4>[   15.512157]  [<c14b55be>] ? driver_attach+0x1e/0x20
<4>[   15.512347]  [<c14b5c70>] ? __driver_attach+0x0/0x90
<4>[   15.512543]  [<c14b5132>] ? bus_add_driver+0xf2/0x2e0
<4>[   15.512716]  [<c1423a52>] ? kset_find_obj+0x52/0x80
<4>[   15.512882]  [<c15e1e20>] ? sdio_bus_remove+0x0/0x1a0
<4>[   15.513052]  [<c14b5ea4>] ? driver_register+0x74/0x130
<4>[   15.513226]  [<c12ae840>] ? trace_module_notify+0x30/0x310
<4>[   15.513409]  [<c15e1cec>] ? sdio_register_driver+0x1c/0x20
<4>[   15.513593]  [<fb84e00d>] ? init_module+0xd/0xf [wl12xx_sdio]
<4>[   15.513783]  [<c1201042>] ? do_one_initcall+0x32/0x190
<4>[   15.513956]  [<c126ddca>] ? blocking_notifier_call_chain+0x6a/0x80
<4>[   15.514160]  [<fb84e000>] ? init_module+0x0/0xf [wl12xx_sdio]
<4>[   15.514352]  [<c128415b>] ? sys_init_module+0x9b/0x1e0
<4>[   15.514525]  [<c142d57c>] ? trace_hardirqs_on_thunk+0xc/0x10
<4>[   15.514713]  [<c1833ad9>] ? syscall_call+0x7/0xb
<4>[   15.514873]  [<c1830000>] ? schedule+0x6e0/0xd30
<0>[   15.515024] Code: 07 83 88 40 01 00 00 02 e8 78 38 cc c5 3d 00
f0 ff ff 89 c6 76 15 89 44 24 04 c7 04 24 70 ba 84 fb e8 5f 3d fe c5
e9 5d 01 00 00 <8b> 40 04 b9 20 b0 81 fb 89 43 18 8b 56 0c 89 53 1c 8b
56 10 89
<0>[   15.516443] EIP: [<fb84b796>] cleanup_module+0x102/0x270
[wl12xx_sdio] SS:ESP 0068:e0acde3c
<0>[   15.516736] CR2: 000000000a36203e
<4>[   15.517314] ---[ end trace 68884dc2973a7575 ]---
<0>[   15.527301] Kernel panic - not syncing: Fatal exception
<4>[   15.532511] Pid: 1554, comm: WifiService Tainted: G      D
2.6.35.3+ #1
<4>[   15.539412] Call Trace:
<4>[   15.541877]  [<c182f50d>] ? printk+0x1d/0x1f
<4>[   15.546123]  [<c182f484>] panic+0x64/0xd0
<4>[   15.550113]  [<c1206823>] oops_end+0x83/0x90
<4>[   15.554405]  [<c122c2b6>] no_context+0xc6/0x1f0
<4>[   15.558905]  [<c122c470>] __bad_area_nosemaphore+0x90/0x130
<4>[   15.564479]  [<c18332f3>] ? _raw_spin_unlock_irqrestore+0x23/0x50
<4>[   15.570554]  [<c14bec77>] ? __pm_runtime_idle+0x67/0xd0
<4>[   15.575784]  [<c122c570>] bad_area+0x40/0x50
<4>[   15.580029]  [<c122c7b0>] ? do_page_fault+0x0/0x2c0
<4>[   15.584919]  [<c122ca3e>] do_page_fault+0x28e/0x2c0
<4>[   15.589776]  [<c136210b>] ? sysfs_addrm_finish+0x1b/0x170
<4>[   15.595198]  [<c1361718>] ? sysfs_new_dirent+0x68/0x100
<4>[   15.600376]  [<c122c7b0>] ? do_page_fault+0x0/0x2c0
<4>[   15.605267]  [<c122c7b0>] ? do_page_fault+0x0/0x2c0
<4>[   15.610118]  [<c183414b>] error_code+0x6b/0x70
<4>[   15.614576]  [<c122c7b0>] ? do_page_fault+0x0/0x2c0
<4>[   15.619411]  [<fb84b796>] ? cleanup_module+0x102/0x270 [wl12xx_sdio]
<4>[   15.625780]  [<c15d827e>] ? mmc_release_host+0xbe/0x110
<4>[   15.630991]  [<c15e1b15>] sdio_bus_probe+0xf5/0x1b0
<4>[   15.635836]  [<c14b5a9e>] driver_probe_device+0x17e/0x350
<4>[   15.641242]  [<c12358d5>] ? sub_preempt_count+0x85/0xc0
<4>[   15.646438]  [<c14b5cf1>] __driver_attach+0x81/0x90
<4>[   15.651318]  [<c14b4af3>] bus_for_each_dev+0x53/0x80
<4>[   15.656279]  [<c14b55be>] driver_attach+0x1e/0x20
<4>[   15.660970]  [<c14b5c70>] ? __driver_attach+0x0/0x90
<4>[   15.665914]  [<c14b5132>] bus_add_driver+0xf2/0x2e0
<4>[   15.670780]  [<c1423a52>] ? kset_find_obj+0x52/0x80
<4>[   15.675662]  [<c15e1e20>] ? sdio_bus_remove+0x0/0x1a0
<4>[   15.680693]  [<c14b5ea4>] driver_register+0x74/0x130
<4>[   15.685662]  [<c12ae840>] ? trace_module_notify+0x30/0x310
<4>[   15.691137]  [<c15e1cec>] sdio_register_driver+0x1c/0x20
<4>[   15.696433]  [<fb84e00d>] init_module+0xd/0xf [wl12xx_sdio]
<4>[   15.702014]  [<c1201042>] do_one_initcall+0x32/0x190
<4>[   15.706949]  [<c126ddca>] ? blocking_notifier_call_chain+0x6a/0x80
<4>[   15.713133]  [<fb84e000>] ? init_module+0x0/0xf [wl12xx_sdio]
<4>[   15.718863]  [<c128415b>] sys_init_module+0x9b/0x1e0
<4>[   15.723826]  [<c142d57c>] ? trace_hardirqs_on_thunk+0xc/0x10
<4>[   15.729476]  [<c1833ad9>] syscall_call+0x7/0xb
<4>[   15.733912]  [<c1830000>] ? schedule+0x6e0/0xd30
<6>[   15.738519] Acquire ownership - eMMC owner: 1, IA req: 1, SCU req: 0
<6>[   15.745110] sdhci_pci_power_up_host: host controller power up is done
