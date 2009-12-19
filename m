Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-gx0-f211.google.com ([209.85.217.211]:46824 "EHLO
	mail-gx0-f211.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751194AbZLSP1T (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 19 Dec 2009 10:27:19 -0500
Received: by gxk3 with SMTP id 3so2864515gxk.1
        for <linux-wireless@vger.kernel.org>; Sat, 19 Dec 2009 07:27:19 -0800 (PST)
MIME-Version: 1.0
Date: Sat, 19 Dec 2009 10:27:18 -0500
Message-ID: <bfff2faa0912190727jc7fa067gf46425d1cd443698@mail.gmail.com>
Subject: modprobe fail and subsequent crash on rmmod ath9k D-Link DWA 652
From: Russ Adams <russ.adams@gmail.com>
To: linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hello all,

Environment:

I'm running 2.6.32 with a set of patches provided by Arch Linux:
ftp://ftp.archlinux.org/other/kernel26/patch-2.6.32.1-1-ARCH.bz2.  The
patches appear mostly cosmetic, with some changes applied to ext4.

Hardware:

I have a D-Link DWA 652 which reports as an AR5008 in lspci -vnn.  The
card is functional in kernel 2.6.28. (I'm using it to post this email)

The ath9k list indicated that the problem in rmmod may be in the
mac80211b module.

Here's the sequence of events:

% sudo modprobe ath9k # no pertinent dmesg output

% iwconfig # wlan0 not present
lo        no wireless extensions.

eth0      no wireless extensions.

% sudo rmmod ath9k # not sure why it's telling me "Killed" here
Killed

% dmesg | less
...
...
BUG: unable to handle kernel NULL pointer dereference at 0000000c
IP: [<c116de6a>] kref_put+0x1a/0x60
*pde = 00000000
Oops: 0002 [#1] PREEMPT SMP
last sysfs file:
/sys/devices/LNXSYSTM:00/LNXSYBUS:00/PNP0C0A:00/power_supply/BAT0/energy_full
Modules linked in: ipv6 fan nls_cp437 hid_microsoft vfat fat
snd_seq_dummy firewire_ohci mmc_block snd_seq_oss firewire_core
snd_seq_midi_event snd_seq snd_seq_device snd_pcm_oss sdhci_pci
snd_intel8x0 radeon snd_intel8x0m crc_itu_t ttm snd_ac97_codec sdhci
drm_kms_helper snd_pcm drm i2c_algo_bit snd_timer intel_agp
snd_mixer_oss video snd ac97_bus joydev iTCO_wdt i2c_core
iTCO_vendor_support soundcore shpchp output dell_laptop ac battery
button psmouse snd_page_alloc agpgart pci_hotplug processor thermal
dcdbas serio_raw evdev usbhid pcspkr sg hid rtc_cmos rtc_core rtc_lib
ext3 jbd mbcache ath9k(-) mac80211 ath cfg80211 rfkill led_class b44
ssb mmc_core pcmcia ipw2100 yenta_socket rsrc_nonstatic libipw
uhci_hcd mii lib80211 pcmcia_core sr_mod sd_mod cdrom ehci_hcd usbcore
ata_piix ata_generic pata_acpi libata scsi_mod

Pid: 2089, comm: rmmod Tainted: G        W  (2.6.32-ARCH #1) Inspiron
9200
EIP: 0060:[<c116de6a>] EFLAGS: 00010202 CPU: 0
EIP is at kref_put+0x1a/0x60
EAX: 0000000c EBX: 0000000c ECX: f70ce360 EDX: f8444410
ESI: f8444410 EDI: f732108c EBP: f70ce260 ESP: f559fec4
 DS: 007b ES: 007b FS: 00d8 GS: 00e0 SS: 0068
Process rmmod (pid: 2089, ti=f559e000 task=f54edd50 task.ti=f559e000)
Stack:
 f70ce260 f84ef8b0 f843814d f70cea54 f70cea54 f70cea54 f84cc40d f70cea54
<0> f84ef8b0 f732108c f84ef8e4 f84cc4d8 f7321000 c11832f6 f7321058 c11f631d
<0> f7321058 f84ef8b0 c11f6407 f84ef880 f84ef8b0 c13c4c80 c11f55eb f84ef880
Call Trace:
 [<f843814d>] ? ieee80211_unregister_hw+0x5d/0xd0 [mac80211]
 [<f84cc40d>] ? ath_detach+0x5d/0x120 [ath9k]
 [<f84cc4d8>] ? ath_cleanup+0x8/0x30 [ath9k]
 [<c11832f6>] ? pci_device_remove+0x16/0x40
 [<c11f631d>] ? __device_release_driver+0x4d/0xb0
 [<c11f6407>] ? driver_detach+0x87/0x90
 [<c11f55eb>] ? bus_remove_driver+0x5b/0xa0
 [<c118353b>] ? pci_unregister_driver+0x2b/0x80
 [<f84d431c>] ? ath9k_exit+0x8/0x31 [ath9k]
 [<c1070ef0>] ? sys_delete_module+0x190/0x240
 [<c10c6b47>] ? remove_vma+0x37/0x50
 [<c1025a92>] ? do_page_fault+0x102/0x300
 [<c1003913>] ? sysenter_do_call+0x12/0x28
Code: 00 c7 00 01 00 00 00 0f ae f0 89 f6 c3 8d 74 26 00 83 ec 08 85
d2 89 1c 24 89 c3 89 74 24 04 89 d6 74 39 81 fa a0 86 0d c1 74 20 <3e>
ff 0b 0f 94 c2 31 c0 84 d2 74 09 89 d8 ff d6 b8 01 00 00 00
EIP: [<c116de6a>] kref_put+0x1a/0x60 SS:ESP 0068:f559fec4
CR2: 000000000000000c
---[ end trace a7919e7f17c0a727 ]---

Please advise.  Thank you!

Russ Adams
