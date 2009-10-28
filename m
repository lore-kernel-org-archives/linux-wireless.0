Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.ku-gbr.de ([81.3.11.18]:33733 "EHLO ku-gbr.de"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751874AbZJ1MDH (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 28 Oct 2009 08:03:07 -0400
Received: from dslc-082-082-171-091.pools.arcor-ip.net ([82.82.171.91]:36841 helo=zappa.doom)
	by mail.ku-gbr.de with esmtpsa (Exim 4.69 #1 (Debian))
	id 1N36YB-0004CH-H2
	for <linux-wireless@vger.kernel.org>; Wed, 28 Oct 2009 12:18:47 +0100
Received: from punzenstreichler ([10.10.0.18] helo=punzenstreichler.doom)
	by zappa.doom with esmtp (Exim 4.69)
	(envelope-from <konsti@ku-gbr.de>)
	id 1N36YB-0003f5-2X
	for linux-wireless@vger.kernel.org; Wed, 28 Oct 2009 12:18:47 +0100
Received: from konsti by punzenstreichler.doom with local (Exim 4.69)
	(envelope-from <konsti@ku-gbr.de>)
	id 1N36YB-0006eE-D7
	for linux-wireless@vger.kernel.org; Wed, 28 Oct 2009 12:18:47 +0100
Date: Wed, 28 Oct 2009 12:18:47 +0100
From: Konstantin Kletschke <konsti@ku-gbr.de>
To: linux-wireless@vger.kernel.org
Subject: BUG at workqueue.c:192, debian 2.6.30 AND
 compat-wireless-2009-10-28
Message-ID: <20091028111847.GA25553@punzenstreichler.doom>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Folks!

I use an ath9k in an Asus eeePC 1101HA.

Actually regardeless which stable Kernel I use, I get many disconnects from
my AP and receive strength is very low (-106dB) or I get no scan results. 

The Problem was solved with Kernel 2.6.32-rc3 but I need to use an vanilla
debian Kernel and put a compat-wireless packages among it. 

With this, regardeless if compat-wireless-2009-10-28 or
compat-wireless-2.6.32-rc5.tar.bz2 I get this while booting:

[    6.287660] kernel BUG at /build/buildd-linux-2.6_2.6.30-8-i386-Tm0Lt9/linux-2.6-2.6.30/debian/build/source_i386_none/kernel/workqueue.c:192!
[    6.287778] invalid opcode: 0000 [#1] SMP
[    6.287939] last sysfs file: /sys/devices/pci0000:00/0000:00:1b.0/sound/card0/pcmC0D0p/pcm_class
[    6.288005] Modules linked in: ath9k(+) snd_hda_codec_realtek ath9k_hw
mac80211 snd_hda_intel ath snd_hda_codec snd_hwdep snd_pcm joydev snd_seq
cfg80211 snd_timer rfkill_backport snd_seq_device i2c_isch uvcvideo
serio_raw snd eeepc_laptop videodev v4l1_compat led_class i2c_core psmouse
evdev atl1c wmi rfkill soundcore ac battery processor snd_page_alloc button
ext4 mbcache jbd2 crc16 usbhid hid sd_mod crc_t10dif ide_pci_generic
ide_core ata_generic pata_sch libata uhci_hcd video output scsi_mod
ehci_hcd usbcore thermal fan thermal_sys [last unloaded: scsi_wait_scan]
[    6.288005]
[    6.288005] Pid: 721, comm: modprobe Not tainted (2.6.30-2-686 #1) 1101HA
[    6.288005] EIP: 0060:[<c0134552>] EFLAGS: 00010213 CPU: 0
[    6.288005] EIP is at queue_work_on+0x1b/0x44
[    6.288005] EAX: ef507308 EBX: 00000000 ECX: ef507304 EDX: 00000000
[    6.288005] ESI: f7001d60 EDI: f71f9101 EBP: f71f89f4 ESP: ef7afe74
[    6.288005]  DS: 007b ES: 007b FS: 00d8 GS: 0033 SS: 0068
[    6.288005] Process modprobe (pid: 721, ti=ef7ae000 task=f70d2140 task.ti=ef7ae000)
[    6.288005] Stack:
[    6.288005]  f71f92ec 00000000 f883475c ef088000 ef088030 f71f8220 00000000 00000008
[    6.288005]  f8840f70 f71ee000 f71f89f4 dbc30001 f883a66c f883c978 ef7afec8 f71ee058
[    6.288005]  00000000 f8860000 f71f8220 c01ca4d0 dbc35001 081e1089 f8840ea8 f71ee000
[    6.288005] Call Trace:
[    6.288005]  [<f883475c>] ? ath_init_device+0x96e/0x9f2 [ath9k]
[    6.288005]  [<f883a66c>] ? ath_pci_probe+0x1e1/0x2e7 [ath9k]
[    6.288005]  [<c01ca4d0>] ? sysfs_do_create_link+0xab/0xed
[    6.288005]  [<c020f87d>] ? local_pci_probe+0xb/0xc
[    6.288005]  [<c02101f3>] ? pci_device_probe+0x41/0x63
[    6.288005]  [<c026d40a>] ? driver_probe_device+0x76/0xfe
[    6.288005]  [<c026d4d2>] ? __driver_attach+0x40/0x5b
[    6.288005]  [<c026ced6>] ? bus_for_each_dev+0x37/0x5f
[    6.288005]  [<c026d2f1>] ? driver_attach+0x11/0x13
[    6.288005]  [<c026d492>] ? __driver_attach+0x0/0x5b
[    6.288005]  [<c026c99b>] ? bus_add_driver+0x99/0x1bf
[    6.288005]  [<c026d6eb>] ? driver_register+0x87/0xe0
[    6.288005]  [<c0210528>] ? __pci_register_driver+0x33/0x8b
[    6.288005]  [<f8844000>] ? ath9k_init+0x0/0x3d [ath9k]
[    6.288005]  [<f8844020>] ? ath9k_init+0x20/0x3d [ath9k]
[    6.288005]  [<c010113e>] ? do_one_initcall+0x55/0x155
[    6.288005]  [<c0147311>] ? sys_init_module+0x87/0x187
[    6.288005]  [<c0102ff4>] ? sysenter_do_call+0x12/0x28
[    6.288005] Code: 0d 34 cf 43 c0 8b 00 03 04 8d 60 cd 43 c0 eb b2 56 89
d6 53 89 c3 f0 0f ba 29 00 19 c0 31 d2 85 c0 75 2c 8d 41 04 39 41 04 74 04
<0f> 0b eb fe 83 7e 10 00 89 ca 0f 45 1d 34 cf 43 c0 8b 06 03 04
[    6.288005] EIP: [<c0134552>] queue_work_on+0x1b/0x44 SS:ESP
0068:ef7afe74
[    6.299736] ---[ end trace 165efc44446b5942 ]---

What am I supposed to to now, to get this working?

Kind Regards, Konsti

-- 
GPG KeyID EF62FCEF
Fingerprint: 13C9 B16B 9844 EC15 CC2E  A080 1E69 3FDA EF62 FCEF
