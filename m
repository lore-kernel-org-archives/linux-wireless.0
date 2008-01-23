Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from ns2.lanforge.com ([66.165.47.211]:42669 "EHLO ns2.lanforge.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751775AbYAWDmX (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 22 Jan 2008 22:42:23 -0500
Received: from [192.168.100.224] (static-71-121-249-218.sttlwa.dsl-w.verizon.net [71.121.249.218])
	(authenticated bits=0)
	by ns2.lanforge.com (8.13.4/8.13.4) with ESMTP id m0N2x2og009393
	for <linux-wireless@vger.kernel.org>; Tue, 22 Jan 2008 18:59:03 -0800
Message-ID: <4796AD76.7020304@candelatech.com> (sfid-20080123_034226_608588_BE8E556B)
Date: Tue, 22 Jan 2008 18:59:02 -0800
From: Ben Greear <greearb@candelatech.com>
MIME-Version: 1.0
To: linux-wireless@vger.kernel.org
Subject: b43 bug on card removal
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

I cloned wireless-2.6 and am using the 'everything' branch.
I have some other networking patches applied as well, but nothing
directly wireless related.
I updated git earlier today and booted it up on a laptop with
a built-in ath5k and a cardbus b43 NIC.

Looks like I still need to get firmware installed...not sure if that
causes the next oops or not.

I just pulled git again, and tried the removal with the new kernel.
The panic is different this time (see second set of traces below)



Jan 22 17:50:20 nx5000 kernel: b43-phy1 ERROR: Firmware file "b43/ucode5.fw" not found or load failed.
Jan 22 17:50:20 nx5000 kernel: b43-phy1 ERROR: You must go to http://linuxwireless.org/en/users/Drivers/b43#devicefir mware and download the latest firmware (version 4).
Jan 22 17:50:20 nx5000 firmware.sh[2934]: Cannot find  firmware file 'b43/ucode5.fw'
Jan 22 17:50:28 nx5000 kernel: ip_tables: (C) 2000-2006 Netfilter Core Team
Jan 22 17:50:29 nx5000 kernel: nf_conntrack version 0.5.0 (8192 buckets, 32768 max)
Jan 22 17:52:23 nx5000 kernel: pccard: card ejected from slot 1
Jan 22 17:52:23 nx5000 kernel: ACPI: PCI interrupt for device 0000:03:00.0 disabled
Jan 22 17:52:31 nx5000 kernel: list_add corruption. prev->next should be next (df3c0e94), but was 00000001. (prev=de4 f9600).
Jan 22 17:52:31 nx5000 kernel: ------------[ cut here ]------------
Jan 22 17:52:31 nx5000 kernel: kernel BUG at /mnt/ghome/greearb/git/wireless-2.6/lib/list_debug.c:33!
Jan 22 17:52:31 nx5000 kernel: invalid opcode: 0000 [#1] PREEMPT SMP
Jan 22 17:52:31 nx5000 kernel: Modules linked in: rfkill_input 8021q redirdev macvlan pktgen rfcomm l2cap bluetooth a utofs4 sunrpc xirc2ps_cs ipv6 cpufreq_ondemand acpi_cpufreq loop snd_intel8x0 snd_intel8x0m snd_seq_dummy snd_ac97_co dec ac97_bus snd_seq_oss snd_seq_midi_event snd_seq snd_seq_device snd_pcm_oss snd_mixer_oss snd_pcm arc4 snd_timer b 43 ecb rfkill input_polldev blkcipher tifm_7xx1 firewire_ohci firewire_core snd smsc_ircc2 tifm_core ath5k mac80211 c fg80211 video irda iTCO_wdt crc_itu_t iTCO_vendor_support output battery b44 mii ac parport_pc soundcore parport snd_ page_alloc sr_mod crc_ccitt joydev button pcspkr serio_raw sg floppy cdrom dm_snapshot dm_zero dm_mirror dm_mod ata_g eneric 
ata_piix pata_acpi libata sd_mod scsi_mod ext3 jbd mbcache uhci_hcd ohci_hcd ssb ehci_hcd
Jan 22 17:52:31 nx5000 kernel:
Jan 22 17:52:31 nx5000 kernel: Pid: 2928, comm: ipolldevd Not tainted (2.6.24-rc8 #1)
Jan 22 17:52:31 nx5000 kernel: EIP: 0060:[<c04f7721>] EFLAGS: 00010292 CPU: 0
Jan 22 17:52:31 nx5000 kernel: EIP is at __list_add+0x48/0x5c
Jan 22 17:52:31 nx5000 kernel: EAX: 00000061 EBX: de524f40 ECX: de524000 EDX: 00000001
Jan 22 17:52:31 nx5000 kernel: ESI: 00000001 EDI: de0f06a0 EBP: df3f3f60 ESP: de524f24
Jan 22 17:52:31 nx5000 kernel:  DS: 007b ES: 007b FS: 00d8 GS: 0000 SS: 0068
Jan 22 17:52:31 nx5000 kernel: Process ipolldevd (pid: 2928, ti=de524000 task=de0f06a0 task.ti=de524000)
Jan 22 17:52:31 nx5000 kernel: Stack: c06ce997 df3c0e94 00000001 de4f9600 df3c0e88 df3c0e88 c0622b89 00000246
Jan 22 17:52:31 nx5000 kernel:        c0623cd2 c0429305 df3c0e88 df3f3f74 df3c0e88 c0622a8d c0622573 dea86800
Jan 22 17:52:31 nx5000 kernel:        e02bb7c9 ffffffff c043cea4 00000000 df3c0e80 df3f3f60 df3f3f74 df3f3f74
Jan 22 17:52:31 nx5000 kernel: Call Trace:
Jan 22 17:52:31 nx5000 kernel:  [<c0622b89>] __mutex_lock_slowpath+0x24/0x7f
Jan 22 17:52:31 nx5000 kernel:  [<c0623cd2>] _spin_unlock_irq+0x18/0x2c
Jan 22 17:52:31 nx5000 kernel:  [<c0429305>] finish_task_switch+0x1d/0x82
Jan 22 17:52:31 nx5000 kernel:  [<c0622a8d>] mutex_lock+0x21/0x24
Jan 22 17:52:31 nx5000 kernel:  [<c0622573>] schedule+0x657/0x671
Jan 22 17:52:31 nx5000 kernel:  [<e02bb7c9>] b43_rfkill_poll+0x1e/0xe5 [b43]
Jan 22 17:52:31 nx5000 kernel:  [<c043cea4>] queue_delayed_work_on+0x8e/0x9a
Jan 22 17:52:31 nx5000 kernel:  [<e029909d>] input_polled_device_work+0x0/0x24 [input_polldev]
Jan 22 17:52:31 nx5000 kernel:  [<e02990a9>] input_polled_device_work+0xc/0x24 [input_polldev]
Jan 22 17:52:31 nx5000 kernel:  [<c043c7fb>] run_workqueue+0x77/0xfc
Jan 22 17:52:31 nx5000 kernel:  [<c043fd16>] prepare_to_wait+0x24/0x3f
Jan 22 17:52:31 nx5000 kernel:  [<c043d0a9>] worker_thread+0x0/0xc7
Jan 22 17:52:31 nx5000 kernel:  [<c043d163>] worker_thread+0xba/0xc7
Jan 22 17:52:31 nx5000 kernel:  [<c043fbcc>] autoremove_wake_function+0x0/0x35
Jan 22 17:52:31 nx5000 kernel:  [<c043fafc>] kthread+0x38/0x60
Jan 22 17:52:31 nx5000 kernel:  [<c043fac4>] kthread+0x0/0x60
Jan 22 17:52:31 nx5000 kernel:  [<c0405da3>] kernel_thread_helper+0x7/0x10
Jan 22 17:52:31 nx5000 kernel:  =======================
Jan 22 17:52:31 nx5000 kernel: Code: 47 e9 6c c0 e8 33 7a f3 ff 0f 0b eb fe 8b 32 39 ce 74 1c 89 54 24 0c 89 74 24 08  89 4c 24 04 c7 04 24 97 e9 6c c0 e8 11 7a f3 ff <0f> 0b eb fe 89 59 04 89 0b 89 43 04 89 18 83 c4 10 5b 5e c3 8b
Jan 22 17:52:31 nx5000 kernel: EIP: [<c04f7721>] __list_add+0x48/0x5c SS:ESP 0068:de524f24
Jan 22 17:52:31 nx5000 kernel: ---[ end trace 67c9aa1fe405439a ]---


ADDRCONF(NETDEV_UP): ath0: link is not ready
input: b43-phy1 as /class/input/input9
b43-phy1 ERROR: Firmware file "b43/ucode5.fw" not found or load failed.
b43-phy1 ERROR: You must go to http://linuxwireless.org/en/users/Drivers/b43#devicefirmware and download the latest firmware (version 4).
ip_tables: (C) 2000-2006 Netfilter Core Team
nf_conntrack version 0.5.0 (8192 buckets, 32768 max)
pccard: card ejected from slot 1
ACPI: PCI interrupt for device 0000:03:00.0 disabled
BUG: unable to handle kernel NULL pointer dereference at virtual address 00000020
printing eip: c04f7703 *pde = 00000000
Oops: 0000 [#1] PREEMPT SMP
Modules linked in: rfkill_input 8021q redirdev macvlan pktgen rfcomm l2cap bluetooth autofs4 sunrpc xirc2ps_cs ipv6 cpufreq_ondemand acpi_cpufreq loop snd_intel8x0m snd_intel8x0 snd_seq_dummy snd_ac97_codec ac97_bus snd_seq_oss snd_seq_midi_event snd_seq snd_seq_device snd_pcm_oss snd_mixer_oss snd_pcm arc4 snd_timer ecb b43 blkcipher tifm_7xx1 rfkill smsc_ircc2 input_polldev snd ath5k mac80211 firewire_ohci irda battery firewire_core video tifm_core cfg80211 crc_itu_t output b44 mii ac iTCO_wdt soundcore parport_pc serio_raw iTCO_vendor_support snd_page_alloc crc_ccitt parport pcspkr joydev button sr_mod sg floppy cdrom dm_snapshot dm_zero dm_mirror dm_mod ata_generic ata_piix pata_acpi libata sd_mod scsi_mod 
ext3 jbd mbcache uhci_hcd ohci_hcd ssb ehci_hcd

Pid: 2910, comm: ipolldevd Not tainted (2.6.24-rc8 #2)
EIP: 0060:[<c04f7703>] EFLAGS: 00010246 CPU: 0
EIP is at __list_add+0x2a/0x5c
EAX: 00000020 EBX: de8cff40 ECX: debb1e94 EDX: 00000020
ESI: debb1e88 EDI: de10ad40 EBP: debd8cc0 ESP: de8cff24
  DS: 007b ES: 007b FS: 00d8 GS: 0000 SS: 0068
Process ipolldevd (pid: 2910, ti=de8cf000 task=de10ad40 task.ti=de8cf000)
Stack: 000f00d8 ffffff10 c0623b46 00000060 debb1e88 debb1e88 c0622b89 00000246
        c0623cd2 c0429305 debb1e88 debd8cd4 debb1e88 c0622a8d c0622573 de458800
        e02a612d ffffffff c043cea4 00000000 debb1e80 debd8cc0 debd8cd4 debd8cd4
Call Trace:
  [<c0623b46>] _spin_lock+0x43/0x5a
  [<c0622b89>] __mutex_lock_slowpath+0x24/0x7f
  [<c0623cd2>] _spin_unlock_irq+0x18/0x2c
  [<c0429305>] finish_task_switch+0x1d/0x82
  [<c0622a8d>] mutex_lock+0x21/0x24
  [<c0622573>] schedule+0x657/0x671
  [<e02a612d>] b43_rfkill_poll+0x1e/0xe5 [b43]
  [<c043cea4>] queue_delayed_work_on+0x8e/0x9a
  [<e020e09d>] input_polled_device_work+0x0/0x24 [input_polldev]
  [<e020e0a9>] input_polled_device_work+0xc/0x24 [input_polldev]
  [<c043c7fb>] run_workqueue+0x77/0xfc
  [<c043fd16>] prepare_to_wait+0x24/0x3f
  [<c043d0a9>] worker_thread+0x0/0xc7
  [<c043d163>] worker_thread+0xba/0xc7
  [<c043fbcc>] autoremove_wake_function+0x0/0x35
  [<c043fafc>] kthread+0x38/0x60
  [<c043fac4>] kthread+0x0/0x60
  [<c0405da3>] kernel_thread_helper+0x7/0x10
  =======================
Code: c3 56 53 89 c3 83 ec 10 8b 41 04 39 d0 74 1c 89 4c 24 0c 89 54 24 04 89 44 24 08 c7 04 24 47 e9 6c c0 e8 33 7a f3 ff 0f 0b eb fe <8b> 32 39 ce 74 1c 89 54 24 0c 89 74 24 08 89 4c 24 04 c7 04 24
EIP: [<c04f7703>] __list_add+0x2a/0x5c SS:ESP 0068:de8cff24
---[ end trace 3b65bee42eeeb7ca ]---
note: ipolldevd[2910] exited with preempt_count 1



-- 
Ben Greear <greearb@candelatech.com>
Candela Technologies Inc  http://www.candelatech.com

