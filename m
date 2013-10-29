Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-lb0-f178.google.com ([209.85.217.178]:39879 "EHLO
	mail-lb0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751339Ab3J2Kia (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 29 Oct 2013 06:38:30 -0400
Received: by mail-lb0-f178.google.com with SMTP id o14so3789403lbi.23
        for <linux-wireless@vger.kernel.org>; Tue, 29 Oct 2013 03:38:29 -0700 (PDT)
MIME-Version: 1.0
Date: Tue, 29 Oct 2013 11:38:29 +0100
Message-ID: <CAEk6gTD-PkwaRNDs0b9wkE3s91pOPGr1P-+yQyTny3PqjjjFCg@mail.gmail.com> (sfid-20131029_113834_579685_D6C1F992)
Subject: ath6kl USB driver loading problem
From: Drasko DRASKOVIC <drasko.draskovic@gmail.com>
To: linux-wireless@vger.kernel.org, ath6kl-devel@qualcomm.com
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi all,
I have a USB dongle that uses ath6kl driver. I have a Cyclone5 Altera
socfpga Linux, kernel version 3.8, and during the boot I am facing
following problem:
usb 1-1: new high-speed USB device number 2 using dwc_otg
INFO: rcu_sched self-detected stall on CPU { 0}  (t=2100 jiffies
g=4294967038 c=4294967037 q=12)
[<800154f4>] (unwind_backtrace+0x0/0xf8) from [<80080044>]
(rcu_check_callbacks+0x388/0x860)
[<80080044>] (rcu_check_callbacks+0x388/0x860) from [<80031ea0>]
(update_process_times+0x38/0x68)
[<80031ea0>] (update_process_times+0x38/0x68) from [<80063000>]
(tick_sched_timer+0x5c/0x1f0)
[<80063000>] (tick_sched_timer+0x5c/0x1f0) from [<80046b14>]
(__run_hrtimer+0x84/0x1b4)
[<80046b14>] (__run_hrtimer+0x84/0x1b4) from [<80047480>]
(hrtimer_interrupt+0x108/0x2d4)
[<80047480>] (hrtimer_interrupt+0x108/0x2d4) from [<80014458>]
(twd_handler+0x40/0x4c)
[<80014458>] (twd_handler+0x40/0x4c) from [<8007a148>]
(handle_percpu_devid_irq+0x5c/0x144)
[<8007a148>] (handle_percpu_devid_irq+0x5c/0x144) from [<800773a0>]
(generic_handle_irq+0x20/0x30)
[<800773a0>] (generic_handle_irq+0x20/0x30) from [<8000f294>]
(handle_IRQ+0x38/0x94)
[<8000f294>] (handle_IRQ+0x38/0x94) from [<80081a78>]
(__ipipe_do_sync_stage+0x218/0x22c)
[<80081a78>] (__ipipe_do_sync_stage+0x218/0x22c) from [<80081be8>]
(ipipe_unstall_root+0x38/0x40)
[<80081be8>] (ipipe_unstall_root+0x38/0x40) from [<8002a5c8>]
(__do_softirq+0x7c/0x224)
[<8002a5c8>] (__do_softirq+0x7c/0x224) from [<8002aa44>] (irq_exit+0x4c/0x54)
[<8002aa44>] (irq_exit+0x4c/0x54) from [<8000f298>] (handle_IRQ+0x3c/0x94)
[<8000f298>] (handle_IRQ+0x3c/0x94) from [<80081a78>]
(__ipipe_do_sync_stage+0x218/0x22c)
[<80081a78>] (__ipipe_do_sync_stage+0x218/0x22c) from [<80081be8>]
(ipipe_unstall_root+0x38/0x40)
[<80081be8>] (ipipe_unstall_root+0x38/0x40) from [<803e2530>]
(__netdev_alloc_frag+0x110/0x154)
[<803e2530>] (__netdev_alloc_frag+0x110/0x154) from [<803e4c80>]
(__netdev_alloc_skb+0x40/0xe0)
[<803e4c80>] (__netdev_alloc_skb+0x40/0xe0) from [<8036824c>]
(ath6kl_usb_post_recv_transfers.constprop.6+0x1c/0x118)
[<8036824c>] (ath6kl_usb_post_recv_transfers.constprop.6+0x1c/0x118)
from [<80368468>] (ath6kl_usb_power_on+0x1c/0x40)
[<80368468>] (ath6kl_usb_power_on+0x1c/0x40) from [<80366de4>]
(ath6kl_core_init+0xa0/0x42c)
[<80366de4>] (ath6kl_core_init+0xa0/0x42c) from [<80367f6c>]
(ath6kl_usb_probe+0x478/0x5a8)
[<80367f6c>] (ath6kl_usb_probe+0x478/0x5a8) from [<803766b8>]
(usb_probe_interface+0xc8/0x190)
[<803766b8>] (usb_probe_interface+0xc8/0x190) from [<802bd8c4>]
(driver_probe_device+0x6c/0x1f8)
[<802bd8c4>] (driver_probe_device+0x6c/0x1f8) from [<802bc000>]
(bus_for_each_drv+0x44/0x8c)
[<802bc000>] (bus_for_each_drv+0x44/0x8c) from [<802bd82c>]
(device_attach+0x74/0x80)
[<802bd82c>] (device_attach+0x74/0x80) from [<802bcebc>]
(bus_probe_device+0x84/0xa8)
[<802bcebc>] (bus_probe_device+0x84/0xa8) from [<802bb710>]
(device_add+0x4c0/0x58c)
[<802bb710>] (device_add+0x4c0/0x58c) from [<80375554>]
(usb_set_configuration+0x550/0x774)
[<80375554>] (usb_set_configuration+0x550/0x774) from [<8037d320>]
(generic_probe+0x2c/0x70)
[<8037d320>] (generic_probe+0x2c/0x70) from [<80375834>]
(usb_probe_device+0x14/0x18)
[<80375834>] (usb_probe_device+0x14/0x18) from [<802bd8c4>]
(driver_probe_device+0x6c/0x1f8)
[<802bd8c4>] (driver_probe_device+0x6c/0x1f8) from [<802bc000>]
(bus_for_each_drv+0x44/0x8c)
[<802bc000>] (bus_for_each_drv+0x44/0x8c) from [<802bd82c>]
(device_attach+0x74/0x80)
[<802bd82c>] (device_attach+0x74/0x80) from [<802bcebc>]
(bus_probe_device+0x84/0xa8)
[<802bcebc>] (bus_probe_device+0x84/0xa8) from [<802bb710>]
(device_add+0x4c0/0x58c)
[<802bb710>] (device_add+0x4c0/0x58c) from [<8036e8d0>]
(usb_new_device+0x11c/0x17c)
[<8036e8d0>] (usb_new_device+0x11c/0x17c) from [<8036f41c>]
(hub_thread+0xaec/0x1208)
[<8036f41c>] (hub_thread+0xaec/0x1208) from [<80042a94>] (kthread+0xa4/0xb0)
[<80042a94>] (kthread+0xa4/0xb0) from [<8000e400>] (ret_from_fork+0x18/0x38)


Any idea why it come to this?

Best regards,
Drasko
