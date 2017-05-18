Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-oi0-f45.google.com ([209.85.218.45]:33580 "EHLO
        mail-oi0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1756088AbdERTDp (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 18 May 2017 15:03:45 -0400
Received: by mail-oi0-f45.google.com with SMTP id w10so66514509oif.0
        for <linux-wireless@vger.kernel.org>; Thu, 18 May 2017 12:03:45 -0700 (PDT)
Subject: Re: crash in r8723bs
To: Stefan Assmann <sassmann@kpanic.de>
References: <9b9d08fb-cbcd-5c12-feb8-5434a20cbd94@kpanic.de>
Cc: linux-wireless <linux-wireless@vger.kernel.org>
From: Larry Finger <Larry.Finger@lwfinger.net>
Message-ID: <8780fd64-329f-2a42-4bcd-10abf60976fc@lwfinger.net> (sfid-20170518_210351_529719_71D7DA6D)
Date: Thu, 18 May 2017 14:03:42 -0500
MIME-Version: 1.0
In-Reply-To: <9b9d08fb-cbcd-5c12-feb8-5434a20cbd94@kpanic.de>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 05/17/2017 10:05 AM, Stefan Assmann wrote:
> Hi Larry,
> 
> the rtl8723bs made it into staging, awesome.
> I built a kernel to test it but it goes down the drain pretty quickly
> on modprobe. Going forward who should I discuss bugs with?
> 
> Here's what's going on atm.
> 
>    Stefan
> 
> [  125.244195] r8723bs: module is from the staging directory, the quality is unknown, you have been warned.
> [  125.262538] RTL8723BS: module init start
> [  125.269377] RTL8723BS: rtl8723bs v4.3.5.5_12290.20140916_BTCOEX20140507-4E40
> [  125.275955] RTL8723BS: rtl8723bs BT-Coex version = BTCOEX20140507-4E40
> [  125.350236] pnetdev = e421c800
> [  125.444211] RTL8723BS: rtw_ndev_init(wlan0)
> [  125.451896] ------------[ cut here ]------------
> [  125.459543] kernel BUG at net/wireless/core.h:111!
> [  125.466098] invalid opcode: 0000 [#1] SMP
> [  125.472524] Modules linked in: r8723bs(C+) cfg80211 rfkill hid_logitech_hidpp mmc_block crc32c_intel hid_logitech_dj i2c_hid sdhci_acpi sdhci mmc_core
> [  125.485622] CPU: 1 PID: 456 Comm: modprobe Tainted: G         C      4.12.0-rc1+ #1
> [  125.492260] Hardware name: AXDIA International GmbH Wintab Gen 8/Type2 - Board Product Name, BIOS AD890.1.02.022 09/25/2014
> [  125.505696] task: f5b46480 task.stack: e4724000
> [  125.512515] EIP: cfg80211_netdev_notifier_call+0x4f0/0x6b0 [cfg80211]
> [  125.519329] EFLAGS: 00010246 CPU: 1
> [  125.526049] EAX: 00000000 EBX: f5a88400 ECX: e4725ce8 EDX: 00000010
> [  125.532748] ESI: 00000000 EDI: ffffffed EBP: e4725c94 ESP: e4725bcc
> [  125.539356]  DS: 007b ES: 007b FS: 00d8 GS: 00e0 SS: 0068
> [  125.545890] CR0: 80050033 CR2: b7648a70 CR3: 24111000 CR4: 001006d0
> [  125.552462] Call Trace:
> [  125.558947]  ? smp_apic_timer_interrupt+0x38/0x50
> [  125.565407]  ? ida_get_new_above+0xdd/0x2c0
> [  125.571792]  ? inetdev_event+0x33/0x4e0
> [  125.578163]  notifier_call_chain+0x4e/0x70
> [  125.584546]  raw_notifier_call_chain+0x11/0x20
> [  125.590908]  call_netdevice_notifiers_info+0x2a/0x60
> [  125.597268]  register_netdevice+0x213/0x4d0
> [  125.603564]  register_netdev+0x17/0x30
> [  125.609807]  rtw_drv_register_netdev+0x5a/0x90 [r8723bs]
> [  125.616013]  rtw_drv_init+0x1e8/0x220 [r8723bs]
> [  125.622122]  sdio_bus_probe+0xe0/0x100 [mmc_core]
> [  125.628166]  driver_probe_device+0x249/0x430
> [  125.634174]  __driver_attach+0xd9/0xe0
> [  125.640086]  ? unbind_store+0x100/0x100
> [  125.645894]  ? driver_probe_device+0x430/0x430
> [  125.651662]  bus_for_each_dev+0x57/0xa0
> [  125.657354]  driver_attach+0x19/0x20
> [  125.662972]  ? driver_probe_device+0x430/0x430
> [  125.668553]  bus_add_driver+0x15f/0x250
> [  125.674041]  ? 0xf7f7f000
> [  125.679435]  driver_register+0x56/0xd0
> [  125.684795]  ? 0xf7f7f000
> [  125.690097]  sdio_register_driver+0x1b/0x20 [mmc_core]
> [  125.695440]  rtw_drv_entry+0x52/0x1000 [r8723bs]
> [  125.700729]  do_one_initcall+0x46/0x170
> [  125.705981]  ? kvfree+0x45/0x50
> [  125.711172]  ? kmem_cache_alloc_trace+0x155/0x1c0
> [  125.716317]  ? do_init_module+0x21/0x1c7
> [  125.721414]  ? do_init_module+0x21/0x1c7
> [  125.726431]  do_init_module+0x50/0x1c7
> [  125.731411]  load_module+0x2170/0x2780
> [  125.736349]  ? kernel_read_file+0x28f/0x2c0
> [  125.741262]  SyS_finit_module+0xa7/0xe0
> [  125.746217]  do_fast_syscall_32+0x6c/0x130
> [  125.751535]  entry_SYSENTER_32+0x4e/0x7c
> [  125.756495] EIP: 0xb77d8cc9
> [  125.761445] EFLAGS: 00000246 CPU: 1
> [  125.766417] EAX: ffffffda EBX: 00000006 ECX: 800459da EDX: 00000000
> [  125.771486] ESI: 81c08f60 EDI: 81c094e8 EBP: 81c081d8 ESP: bfaf1b4c
> [  125.776599]  DS: 007b ES: 007b FS: 0000 GS: 0033 SS: 007b
> [  125.781752] Code: ff b9 01 00 00 00 ba 03 00 00 00 83 a8 a4 fe ff ff 01 6a 00 2d 58 01 00 00 e8 4d 1e 5d d5 58 e9 97 fb ff ff 8d b4 26 00 00 00 00 <0f> 0b 8d b6 00 00 00 00 0f ff e9 5f fb ff ff 90 80 7b 38 00 0f
> [  125.797796] EIP: cfg80211_netdev_notifier_call+0x4f0/0x6b0 [cfg80211] SS:ESP: 0068:e4725bcc
> [  125.803343] ---[ end trace 7ffc5b2894f962d1 ]---

The best place to discuss this is in the linux-wireless ML, which is Cc'd here.

The BUG is triggered by a NULL value for the struct wiphy object. I have no idea 
why that is happening on your machine. Have you tried the driver at 
http://github.com/hadess/rtl8723bs.git? It may give the same result, but if not, 
then that would help a lot.

Larry
