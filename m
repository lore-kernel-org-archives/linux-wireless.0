Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-lf0-f65.google.com ([209.85.215.65]:33414 "EHLO
        mail-lf0-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754203AbcIQJtI (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Sat, 17 Sep 2016 05:49:08 -0400
Received: by mail-lf0-f65.google.com with SMTP id l131so5973094lfl.0
        for <linux-wireless@vger.kernel.org>; Sat, 17 Sep 2016 02:49:07 -0700 (PDT)
MIME-Version: 1.0
From: Vidar Haarr <vidar@heidrunbryggeri.no>
Date: Sat, 17 Sep 2016 11:49:05 +0200
Message-ID: <CAJiC63F-O5KeCP+JZjW38uNDc=umXcOZVGma_SyiaTm70fGQ3A@mail.gmail.com> (sfid-20160917_114917_881420_6B07B4BB)
Subject: [athk9] beacon.c:642 ath9k_calculate_summary_state dump
To: linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi,

I'm seeing the message below spammed continously in journald, even
with 4.8-rc6. It's so bad that it throttles the CPU performance every
few seconds.

I found https://patchwork.kernel.org/patch/9247699/ which seems related.

I am not subscribed to linux-wireless.

First, here's some system info, then the stack trace at the bottom.
$ lspci
00:00.0 Host bridge: Intel Corporation 3rd Gen Core processor DRAM
Controller (rev 09)
00:02.0 VGA compatible controller: Intel Corporation 3rd Gen Core
processor Graphics Controller (rev 09)
00:14.0 USB controller: Intel Corporation 7 Series/C210 Series Chipset
Family USB xHCI Host Controller (rev 04)
00:16.0 Communication controller: Intel Corporation 7 Series/C210
Series Chipset Family MEI Controller #1 (rev 04)
00:1a.0 USB controller: Intel Corporation 7 Series/C210 Series Chipset
Family USB Enhanced Host Controller #2 (rev 04)
00:1b.0 Audio device: Intel Corporation 7 Series/C210 Series Chipset
Family High Definition Audio Controller (rev 04)
00:1c.0 PCI bridge: Intel Corporation 7 Series/C210 Series Chipset
Family PCI Express Root Port 1 (rev c4)
00:1c.1 PCI bridge: Intel Corporation 7 Series/C210 Series Chipset
Family PCI Express Root Port 2 (rev c4)
00:1d.0 USB controller: Intel Corporation 7 Series/C210 Series Chipset
Family USB Enhanced Host Controller #1 (rev 04)
00:1f.0 ISA bridge: Intel Corporation HM76 Express Chipset LPC
Controller (rev 04)
00:1f.2 SATA controller: Intel Corporation 7 Series Chipset Family
6-port SATA Controller [AHCI mode] (rev 04)
00:1f.3 SMBus: Intel Corporation 7 Series/C210 Series Chipset Family
SMBus Controller (rev 04)
02:00.0 Network controller: Qualcomm Atheros AR9462 Wireless Network
Adapter (rev 01)

$ sudo lshw -class network
[sudo] passord for folk:
  *-network
       description: Wireless interface
       product: AR9462 Wireless Network Adapter
       vendor: Qualcomm Atheros
       physical id: 0
       bus info: pci@0000:02:00.0
       logical name: wlan0
       version: 01
       serial: 24:ec:99:7f:0e:30
       width: 64 bits
       clock: 33MHz
       capabilities: pm msi pciexpress bus_master cap_list rom
ethernet physical wireless
       configuration: broadcast=yes driver=ath9k
driverversion=4.8.0-040800rc6-generic firmware=N/A ip=192.168.1.176
latency=0 link=yes multicast=yes wireless=IEEE 802.11
       resources: irq:17 memory:f0400000-f047ffff memory:f0480000-f048ffff

$ uname -a
Linux edbpc 4.8.0-040800rc6-generic #201609121119 SMP Mon Sep 12
15:21:03 UTC 2016 x86_64 x86_64 x86_64 GNU/Linux

rfkill list all
0: hci0: Bluetooth
    Soft blocked: no
    Hard blocked: no
1: phy0: Wireless LAN
    Soft blocked: no
    Hard blocked: no


sep. 17 11:38:36 edbpc kernel: WARNING: CPU: 0 PID: 1684 at
/home/kernel/COD/linux/drivers/net/wireless/ath/ath9k/beacon.c:642
ath9k_calculate_summary_state+0x135/0x390 [ath9k]
sep. 17 11:38:36 edbpc kernel: Modules linked in: fuse ctr ccm
binfmt_misc nls_utf8 nls_cp437 vfat fat intel_rapl
x86_pkg_temp_thermal intel_powerclamp coretemp snd_hda_codec_hdmi
snd_hda_codec_realtek snd_hda_codec_generic arc4 snd_hda_intel
snd_hda_codec snd_hda_core ath9k snd_hwdep ath9k_common ath9k_hw
snd_pcm ath kvm_intel snd_seq_midi uvcvideo snd_seq_midi_event
mac80211 kvm videobuf2_vmalloc snd_rawmidi irqbypass videobuf2_memops
snd_seq crct10dif_pclmul videobuf2_v4l2 crc32_pclmul videobuf2_core
snd_seq_device videodev ghash_clmulni_intel cryptd intel_cstate
cfg80211 media intel_rapl_perf snd_timer ath3k btusb btrtl btbcm
btintel efi_pstore bluetooth snd joydev rfkill efivars lpc_ich
serio_raw sg shpchp mei_me soundcore mfd_core mei evdev fujitsu_laptop
battery ac tpm_tis tpm_tis_core tpm lp parport loop efivarfs
sep. 17 11:38:36 edbpc kernel:  ip_tables x_tables autofs4 ext4 crc16
jbd2 fscrypto mbcache hid_generic usbhid hid uas usb_storage sd_mod
i915 ahci crc32c_intel libahci libata psmouse i2c_algo_bit scsi_mod
drm_kms_helper xhci_pci syscopyarea ehci_pci xhci_hcd sysfillrect
ehci_hcd sysimgblt fb_sys_fops usbcore drm usb_common fan thermal
video fjes button
sep. 17 11:38:36 edbpc kernel: CPU: 0 PID: 1684 Comm: kworker/u16:0
Tainted: G        W       4.8.0-040800rc6-generic #201609121119
sep. 17 11:38:36 edbpc kernel: Hardware name: FUJITSU LIFEBOOK
UH572/FJNBB31  , BIOS 2.15 07/29/2013
sep. 17 11:38:36 edbpc kernel: Workqueue: phy0 ieee80211_scan_work [mac80211]
sep. 17 11:38:36 edbpc kernel:  0000000000000286 00000000189cb902
ffffffffab33fb84 0000000000000000
sep. 17 11:38:36 edbpc kernel:  0000000000000000 ffffffffab07f69e
ffff96690ec45580 ffff96690ec46e10
sep. 17 11:38:36 edbpc kernel:  ffff96690ec74018 ffff96690ec74018
ffff966912773360 ffff966912773360
sep. 17 11:38:36 edbpc kernel: Call Trace:
sep. 17 11:38:36 edbpc kernel:  [<ffffffffab33fb84>] ? dump_stack+0x5c/0x78
sep. 17 11:38:36 edbpc kernel:  [<ffffffffab07f69e>] ? __warn+0xbe/0xe0
sep. 17 11:38:36 edbpc kernel:  [<ffffffffc0b7a0b5>] ?
ath9k_calculate_summary_state+0x135/0x390 [ath9k]
sep. 17 11:38:36 edbpc kernel:  [<ffffffffc0b7a332>] ?
ath_complete_reset+0x22/0x130 [ath9k]
sep. 17 11:38:36 edbpc kernel:  [<ffffffffc0b7a55e>] ?
ath_reset_internal+0x11e/0x1e0 [ath9k]
sep. 17 11:38:36 edbpc kernel:  [<ffffffffc0b7a656>] ?
ath_reset+0x36/0x50 [ath9k]
sep. 17 11:38:36 edbpc kernel:  [<ffffffffc0b82e5a>] ?
ath_chanctx_set_channel+0x13a/0x250 [ath9k]
sep. 17 11:38:36 edbpc kernel:  [<ffffffffc0b796c9>] ?
ath9k_config+0xb9/0x1e0 [ath9k]
sep. 17 11:38:36 edbpc kernel:  [<ffffffffc09a9d05>] ?
ieee80211_hw_config+0x85/0x3e0 [mac80211]
sep. 17 11:38:36 edbpc kernel:  [<ffffffffc09b52ed>] ?
__ieee80211_scan_completed+0xfd/0x470 [mac80211]
sep. 17 11:38:36 edbpc kernel:  [<ffffffffc09b5eeb>] ?
ieee80211_scan_work+0x7b/0x490 [mac80211]
sep. 17 11:38:36 edbpc kernel:  [<ffffffffab098ae4>] ?
process_one_work+0x184/0x4b0
sep. 17 11:38:36 edbpc kernel:  [<ffffffffab098e5d>] ? worker_thread+0x4d/0x480
sep. 17 11:38:36 edbpc kernel:  [<ffffffffab6188b1>] ? __schedule+0x261/0x720
sep. 17 11:38:36 edbpc kernel:  [<ffffffffab098e10>] ?
process_one_work+0x4b0/0x4b0
sep. 17 11:38:36 edbpc kernel:  [<ffffffffab09efbd>] ? kthread+0xcd/0xf0
sep. 17 11:38:36 edbpc kernel:  [<ffffffffab02c751>] ? __switch_to+0x2c1/0x7a0
sep. 17 11:38:36 edbpc kernel:  [<ffffffffab61d41f>] ? ret_from_fork+0x1f/0x40
sep. 17 11:38:36 edbpc kernel:  [<ffffffffab09eef0>] ?
kthread_create_on_node+0x1a0/0x1a0
sep. 17 11:38:36 edbpc kernel: ---[ end trace 4e47cb6784f0f49d ]---

-- 
Vidar
