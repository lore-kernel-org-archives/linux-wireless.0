Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.candelatech.com ([208.74.158.172]:36383 "EHLO
	ns3.lanforge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751896Ab0GES5r (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 5 Jul 2010 14:57:47 -0400
Message-ID: <4C322B26.7080701@candelatech.com>
Date: Mon, 05 Jul 2010 11:57:42 -0700
From: Ben Greear <greearb@candelatech.com>
MIME-Version: 1.0
To: Vasanthakumar Thiagarajan <vasanth@atheros.com>
CC: Vasanth Thiagarajan <Vasanth.Thiagarajan@atheros.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: Re: ath9k doesn't clean up virtual wifis on rmmod, and crashes.
References: <4C2ED806.9000105@candelatech.com> <20100703070259.GA15479@vasanth-laptop> <4C2F6681.7070202@candelatech.com> <20100704093535.GE5053@vasanth-laptop> <4C30AFD0.80100@candelatech.com>
In-Reply-To: <4C30AFD0.80100@candelatech.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

I ran the same test on wireless-testing, and it still crashes.

It appears that the patch you sent is already in wireless-testing,
so I did not apply it.

[root@atom ~]# uname -a
Linux atom 2.6.35-rc3-wl+ #1 SMP Mon Jul 5 11:36:08 PDT 2010 i686 i686 i386 GNU/Linux
[root@atom ~]# echo add > /debug/ath9k/phy0/wiphy
Jul  5 11:54:59 atom kernel: phy1: Selected rate control algorithm 'ath9k_rate_control'
[root@atom ~]# rmmod ath9k
BUG: unable to handle kernel NULL pointer dereference at 000000a4
IP: [<f8d455d6>] ath9k_hw_intrpend+0x6/0x49 [ath9k_hw]
*pde = 00000000
Oops: 0000 [#1] SMP
last sysfs file: /sys/devices/pci0000:00/0000:00:1e.0/0000:05:00.0/net/wlan1/flags
Modules linked in: xt_CT iptable_raw ipt_addrtype xt_DSCP xt_dscp xt_string xt_owner xt_NFQUEUE xt_mul]

Pid: 5817, comm: rmmod Not tainted 2.6.35-rc3-wl+ #1 To be filled by O.E.M./To Be Filled By O.E.M.
EIP: 0060:[<f8d455d6>] EFLAGS: 00010046 CPU: 0
EIP is at ath9k_hw_intrpend+0x6/0x49 [ath9k_hw]
EAX: 00000000 EBX: 00000000 ECX: c08de3bc EDX: f705ec78
ESI: f705ec78 EDI: 00000010 EBP: f4563e70 ESP: f4563e6c
  DS: 007b ES: 007b FS: 00d8 GS: 0033 SS: 0068
Process rmmod (pid: 5817, ti=f4562000 task=f4504550 task.ti=f4562000)
Stack:
  00000000 f4563e88 f8de3cb4 00000010 f6aab6c0 00000282 00000010 f4563ea8
<0> c046d228 f705ec78 00000282 c08de3bc 00000010 c08de380 f705ec78 f4563ebc
<0> c046d28f f705ec78 f7113000 f8f00000 f4563ed0 f8dea27f f7113000 f8def9a8
Call Trace:
  [<f8de3cb4>] ? ath_isr+0x25/0x189 [ath9k]
  [<c046d228>] ? __free_irq+0x11e/0x15e
  [<c046d28f>] ? free_irq+0x27/0x3a
  [<f8dea27f>] ? ath_pci_remove+0x2f/0x54 [ath9k]
  [<c05816da>] ? pci_device_remove+0x19/0x39
  [<c06036d6>] ? __device_release_driver+0x59/0x9d
  [<c0603781>] ? driver_detach+0x67/0x85
  [<c0602c9d>] ? bus_remove_driver+0x69/0x85
  [<c0603b92>] ? driver_unregister+0x4b/0x52
  [<c05818a9>] ? pci_unregister_driver+0x2d/0x6e
  [<f8dea171>] ? ath_pci_exit+0xd/0xf [ath9k]
  [<f8dec664>] ? ath9k_exit+0x8/0x2f [ath9k]
  [<c0455232>] ? sys_delete_module+0x16f/0x1c0
  [<c07458dc>] ? do_page_fault+0x26a/0x2c5
  [<c074590a>] ? do_page_fault+0x298/0x2c5
  [<c0402fdc>] ? sysenter_do_call+0x12/0x28
Code: 80 4b 06 10 31 c9 83 c4 68 89 c8 5b 5e 5f 5d c3 55 b9 0c 00 00 00 89 e5 53 8b 98 94 00 00 00 ff
EIP: [<f8d455d6>] ath9k_hw_intrpend+0x6/0x49 [ath9k_hw] SS:ESP 0068:f4563e6c
CR2: 00000000000000a4
---[ end trace 43bc6f57caff1689 ]---
Killed
Jul  5 1


-- 
Ben Greear <greearb@candelatech.com>
Candela Technologies Inc  http://www.candelatech.com
