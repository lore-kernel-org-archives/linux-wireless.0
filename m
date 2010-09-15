Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-bw0-f46.google.com ([209.85.214.46]:37109 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751685Ab0IOHec convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 15 Sep 2010 03:34:32 -0400
Received: by bwz11 with SMTP id 11so250556bwz.19
        for <linux-wireless@vger.kernel.org>; Wed, 15 Sep 2010 00:34:30 -0700 (PDT)
From: Helmut Schaa <helmut.schaa@googlemail.com>
To: linux-wireless@vger.kernel.org
Subject: ath9k_htc - kernel BUG on USB unplug
Date: Wed, 15 Sep 2010 09:33:39 +0200
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="us-ascii"
Message-Id: <201009150933.39692.helmut.schaa@googlemail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi,

not sure if this is a known bug but I just ran into this while unplugging a
ath9k_htc device (with current wireless-testing):

Helmut

Sep 15 09:13:50 helmutmobil kernel: usb 2-6: USB disconnect, address 2
Sep 15 09:13:50 helmutmobil kernel: ------------[ cut here ]------------
Sep 15 09:13:50 helmutmobil kernel: kernel BUG at kernel/workqueue.c:2853!
Sep 15 09:13:50 helmutmobil kernel: invalid opcode: 0000 [#1] PREEMPT SMP 
Sep 15 09:13:50 helmutmobil kernel: last sysfs file: /sys/devices/pci0000:00/0000:00:1c.1/0000:10:00.0/ieee80211/phy0/rfkill4/uevent
Sep 15 09:13:50 helmutmobil kernel: CPU 1 
Sep 15 09:13:50 helmutmobil kernel: Modules linked in: ath9k_htc ath9k_common ath9k_hw ath md5 ip6t_LOG xt_tcpudp xt_pkttype xt_physdev ipt_LOG xt_limit aes_generic af_packet rfcomm sco bridge stp llc bnep l2cap snd_pcm_oss snd_mixer_oss snd_seq snd_seq_device edd nls_utf8 cifs ip6t_REJECT nf_conntrack_ipv6 ip6table_raw xt_NOTRACK ipt_REJECT xt_state iptable_raw iptable_filter ip6table_mangle nf_conntrack_netbios_ns nf_conntrack_ipv4 nf_conntrack nf_defrag_ipv4 ip_tables ip6table_filter ip6_tables x_tables ipv6 cpufreq_conservative cpufreq_userspace cpufreq_powersave acpi_cpufreq mperf fuse ext2 loop dm_mod arc4 ecb iwlagn snd_hda_codec_analog tpm_infineon iwlcore snd_hda_intel mac80211 usbhid snd_hda_codec hid snd_hwdep sdhci_pci pcmcia sdhci snd_pcm sierra mmc_core sr_mod snd_timer ohci1394 yenta_socket usbserial cfg80211 snd cdrom hp_wmi pcmcia_rsrc ieee1394 led_class btusb serio_raw sg pcmcia_core joydev e1000e tpm_tis soundcore iTCO_wdt snd_page_alloc iTCO_vendor_support tpm container wmi tpm_bios bluetooth batt
Sep 15 09:13:50 helmutmobil kernel: ery ac rfkill ext4 mbcache jbd2 crc16 sd_mod uhci_hcd ata_piix ehci_hcd rtc_cmos rtc_core libahci usbcore rtc_lib fan processor ata_generic libata scsi_mod thermal
Sep 15 09:13:50 helmutmobil kernel:
Sep 15 09:13:50 helmutmobil kernel: Pid: 299, comm: khubd Not tainted 2.6.36-rc3-wl-default+ #115 30C9/HP Compaq 2510p Notebook PC
Sep 15 09:13:50 helmutmobil kernel: RIP: 0010:[<ffffffff810513bd>]  [<ffffffff810513bd>] destroy_workqueue+0xdc/0x172
Sep 15 09:13:50 helmutmobil kernel: RSP: 0018:ffff88003731db70  EFLAGS: 00010286
Sep 15 09:13:50 helmutmobil kernel: RAX: ffff88007a5af580 RBX: ffff880079213980 RCX: ffff88003731db60
Sep 15 09:13:50 helmutmobil kernel: RDX: 000000000000003c RSI: ffff880079213980 RDI: 0000000000000002
Sep 15 09:13:50 helmutmobil kernel: RBP: ffff88003731db90 R08: 0000000000000000 R09: 0000000000000286
Sep 15 09:13:50 helmutmobil kernel: R10: 0000000000000003 R11: ffff88004b875b68 R12: 0000000000000002
Sep 15 09:13:50 helmutmobil kernel: R13: ffffffff81664230 R14: 0000000000000002 R15: ffffffffa050d9d0
Sep 15 09:13:50 helmutmobil kernel: FS:  0000000000000000(0000) GS:ffff880001900000(0000) knlGS:0000000000000000
Sep 15 09:13:50 helmutmobil kernel: CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
Sep 15 09:13:50 helmutmobil kernel: CR2: 00007f377fa618f0 CR3: 0000000001612000 CR4: 00000000000006e0
Sep 15 09:13:50 helmutmobil kernel: DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
Sep 15 09:13:50 helmutmobil kernel: DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
Sep 15 09:13:50 helmutmobil kernel: Process khubd (pid: 299, threadinfo ffff88003731c000, task ffff880078400980)
Sep 15 09:13:50 helmutmobil kernel: Stack:
Sep 15 09:13:50 helmutmobil kernel: ffff88004b870480 ffff88004b871b80 ffff88004b870480 ffff88007b150888
Sep 15 09:13:50 helmutmobil kernel: <0> ffff88003731dbb0 ffffffffa0446133 ffff88003731dbb0 ffff8800495a0000
Sep 15 09:13:50 helmutmobil kernel: <0> ffff88003731dbe0 ffffffffa050cd68 ffff88003731dbd0 ffff88007b772dc0
Sep 15 09:13:50 helmutmobil kernel: Call Trace:
Sep 15 09:13:50 helmutmobil kernel: [<ffffffffa0446133>] ieee80211_unregister_hw+0xe7/0x110 [mac80211]
Sep 15 09:13:50 helmutmobil kernel: [<ffffffffa050cd68>] ath9k_htc_disconnect_device+0x46/0x7c [ath9k_htc]
Sep 15 09:13:50 helmutmobil kernel: [<ffffffffa050686e>] ath9k_htc_hw_deinit+0x12/0x14 [ath9k_htc]
Sep 15 09:13:50 helmutmobil kernel: [<ffffffffa05076dc>] ath9k_hif_usb_disconnect+0x42/0x114 [ath9k_htc]
Sep 15 09:13:50 helmutmobil kernel: [<ffffffff8124784e>] ? __pm_runtime_get+0x15/0x1e
Sep 15 09:13:50 helmutmobil kernel: [<ffffffffa00e97a1>] usb_unbind_interface+0x69/0x13c [usbcore]
Sep 15 09:13:50 helmutmobil kernel: [<ffffffff81241a7a>] __device_release_driver+0x76/0xcc
Sep 15 09:13:50 helmutmobil kernel: [<ffffffff81241aee>] device_release_driver+0x1e/0x2b
Sep 15 09:13:50 helmutmobil kernel: [<ffffffff81241639>] bus_remove_device+0x80/0x91
Sep 15 09:13:50 helmutmobil kernel: [<ffffffff8123f2a5>] device_del+0x130/0x17f
Sep 15 09:13:50 helmutmobil kernel: [<ffffffffa00e7a16>] usb_disable_device+0x81/0xf8 [usbcore]
Sep 15 09:13:50 helmutmobil kernel: [<ffffffffa00e17ad>] usb_disconnect+0x8e/0xf6 [usbcore]
Sep 15 09:13:50 helmutmobil kernel: [<ffffffffa00e2dd4>] hub_thread+0x483/0xdfc [usbcore]
Sep 15 09:13:50 helmutmobil kernel: [<ffffffff81054c81>] ? autoremove_wake_function+0x0/0x34
Sep 15 09:13:50 helmutmobil kernel: [<ffffffffa00e2951>] ? hub_thread+0x0/0xdfc [usbcore]
Sep 15 09:13:50 helmutmobil kernel: [<ffffffff810547dc>] kthread+0x7d/0x85
Sep 15 09:13:50 helmutmobil kernel: [<ffffffff810038a4>] kernel_thread_helper+0x4/0x10
Sep 15 09:13:50 helmutmobil kernel: [<ffffffff8105475f>] ? kthread+0x0/0x85
Sep 15 09:13:50 helmutmobil kernel: [<ffffffff810038a0>] ? kernel_thread_helper+0x0/0x10
Sep 15 09:13:50 helmutmobil kernel: Code: e9 84 00 00 00 48 89 de 44 89 f7 e8 b4 d6 ff ff 31 d2 83 7c 10 18 00 74 02 0f 0b 48 83 c2 04 48 83 fa 3c 75 ed 83 78 54 00 74 02 <0f> 0b 48 8d 50 60 48 39 50 60 74 02 0f 0b 8b 03 83 e0 02 83 f8 
Sep 15 09:13:50 helmutmobil kernel: RIP  [<ffffffff810513bd>] destroy_workqueue+0xdc/0x172
Sep 15 09:13:50 helmutmobil kernel: RSP <ffff88003731db70>
Sep 15 09:13:50 helmutmobil kernel: ---[ end trace ac55c0fbc23c74a5 ]---

