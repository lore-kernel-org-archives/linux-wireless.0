Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-yw0-f46.google.com ([209.85.213.46]:54855 "EHLO
	mail-yw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756496Ab2GQTc4 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 17 Jul 2012 15:32:56 -0400
Received: by yhmm54 with SMTP id m54so784867yhm.19
        for <linux-wireless@vger.kernel.org>; Tue, 17 Jul 2012 12:32:55 -0700 (PDT)
Message-ID: <5005BDE3.8040308@lwfinger.net> (sfid-20120717_213300_612081_14483215)
Date: Tue, 17 Jul 2012 14:32:51 -0500
From: Larry Finger <Larry.Finger@lwfinger.net>
MIME-Version: 1.0
To: Johannes Berg <johannes@sipsolutions.net>
CC: Stefan Lippers-Hollmann <s.L-H@gmx.de>,
	John Linville <linville@tuxdriver.com>,
	linux-wireless <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH 3.5] b43: fix crash with OpenFWWF
References: <1342537949.8139.24.camel@jlt3.sipsolutions.net> <201207171753.17336.s.L-H@gmx.de>
In-Reply-To: <201207171753.17336.s.L-H@gmx.de>
Content-Type: text/plain; charset=UTF-8; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 07/17/2012 10:53 AM, Stefan Lippers-Hollmann wrote:
> Hi
>
> On Tuesday 17 July 2012, Johannes Berg wrote:
>> From: Johannes Berg <johannes.berg@intel.com>
>>
>> b43 with open firmware crashes mac80211 because
>> it changes the number of queues at runtime which,
>> while it was never really supported, now crashes
>> mac80211 due to the new hardware queue logic.
>>
>> Fix this by detecting open vs. proprietary fw
>> earlier and registering with mac80211 with the
>> right number of queues.
> […]
>
> Just for completeness' sake, this patch also requires "mac80211: fix
> crash with single-queue drivers"[1] and avoids the following
> 3.4 --> 3.5 regression in mainline (tested on v3.5-rc7-25-ge5254a6,
> current linux.git as of now):
>
> [    8.386729] b43-pci-bridge 0000:02:00.0: enabling device (0000 -> 0002)
> [    8.386794] b43-pci-bridge 0000:02:00.0: setting latency timer to 64
> [    8.386899] ssb: Found chip with id 0x4306, rev 0x03 and package 0x00
> [    8.386911] ssb: Core 0 found: ChipCommon (cc 0x800, rev 0x04, vendor 0x4243)
> [    8.386923] ssb: Core 1 found: IEEE 802.11 (cc 0x812, rev 0x05, vendor 0x4243)
> [    8.386934] ssb: Core 2 found: PCMCIA (cc 0x80D, rev 0x02, vendor 0x4243)
> [    8.386944] ssb: Core 3 found: V90 (cc 0x807, rev 0x02, vendor 0x4243)
> [    8.386955] ssb: Core 4 found: PCI (cc 0x804, rev 0x09, vendor 0x4243)
> [    8.391430] ssb: Sonics Silicon Backplane found on PCI device 0000:02:00.0
> […]
> [    8.771929] cfg80211: Calling CRDA to update world regulatory domain
> [    9.359492] b43-phy0: Broadcom 4306 WLAN found (core revision 5)
> [    9.376528] Broadcom 43xx driver loaded [ Features: PMNLS ]
> [   10.069906] cfg80211: World regulatory domain updated:
> [   10.069928] cfg80211:   (start_freq - end_freq @ bandwidth), (max_antenna_gain, max_eirp)
> [   10.069936] cfg80211:   (2402000 KHz - 2472000 KHz @ 40000 KHz), (300 mBi, 2000 mBm)
> [   10.069943] cfg80211:   (2457000 KHz - 2482000 KHz @ 20000 KHz), (300 mBi, 2000 mBm)
> [   10.069949] cfg80211:   (2474000 KHz - 2494000 KHz @ 20000 KHz), (300 mBi, 2000 mBm)
> [   10.069956] cfg80211:   (5170000 KHz - 5250000 KHz @ 40000 KHz), (300 mBi, 2000 mBm)
> [   10.069962] cfg80211:   (5735000 KHz - 5835000 KHz @ 40000 KHz), (300 mBi, 2000 mBm)
> [   10.226906] ieee80211 phy0: Selected rate control algorithm 'minstrel_ht'
> [   10.227869] Registered led device: b43-phy0::tx
> [   10.227924] Registered led device: b43-phy0::rx
> [   10.227979] Registered led device: b43-phy0::radio
> [   10.304598] cfg80211: Calling CRDA for country: DE
> [   10.357706] cfg80211: Regulatory domain changed to country: DE
> [   10.357727] cfg80211:   (start_freq - end_freq @ bandwidth), (max_antenna_gain, max_eirp)
> [   10.357734] cfg80211:   (2400000 KHz - 2483500 KHz @ 40000 KHz), (N/A, 2000 mBm)
> [   10.357741] cfg80211:   (5150000 KHz - 5250000 KHz @ 40000 KHz), (N/A, 2000 mBm)
> [   10.357746] cfg80211:   (5250000 KHz - 5350000 KHz @ 40000 KHz), (N/A, 2000 mBm)
> [   10.357752] cfg80211:   (5470000 KHz - 5725000 KHz @ 40000 KHz), (N/A, 2698 mBm)
> […]
> [   20.504102] b43-phy0: Loading OpenSource firmware version 410.31754
> [   20.504118] b43-phy0: Hardware crypto acceleration not supported by firmware
> [   20.504123] b43-phy0: QoS not supported by firmware
> [   20.554909] ------------[ cut here ]------------
> [   20.555059] WARNING: at /tmp/buildd/linux-aptosid-3.5~rc7/debian/build/source_i386_none/net/mac80211/iface.c:162 ieee80211_check_queues+0x66/0x104 [mac80211]()
> [   20.555190] Hardware name: Amilo D-Series
> [   20.555195] Modules linked in: arc4 b43 bcma mac80211 cfg80211 joydev rfkill rng_core ssb mmc_core snd_via82xx snd_ac97_codec ac97_bus snd_mpu401_uart snd_rawmidi snd_seq_device pcmcia via686a psmouse snd_pcm snd_page_alloc snd_timer snd soundcore gameport evdev pcspkr serio_raw microcode shpchp pci_hotplug i2c_viapro yenta_socket pcmcia_rsrc via_agp pcmcia_core battery parport_pc parport ac button processor ext3 mbcache jbd sr_mod sd_mod cdrom crc_t10dif firewire_ohci ata_generic firewire_core pata_acpi tulip crc_itu_t floppy pata_via libata uhci_hcd ehci_hcd usbcore scsi_mod usb_common thermal [last unloaded: scsi_wait_scan]
> [   20.555374] Pid: 1668, comm: wpa_supplicant Not tainted 3.5-rc7-aptosid-686 #1
> [   20.555380] Call Trace:
> [   20.555408]  [<c0125c32>] ? warn_slowpath_common+0x7c/0x8f
> [   20.555482]  [<cff41920>] ? ieee80211_check_queues+0x66/0x104 [mac80211]
> [   20.555554]  [<cff41920>] ? ieee80211_check_queues+0x66/0x104 [mac80211]
> [   20.555565]  [<c0125c60>] ? warn_slowpath_null+0x1b/0x1f
> [   20.555594]  [<cff41920>] ? ieee80211_check_queues+0x66/0x104 [mac80211]
> [   20.555625]  [<cff43050>] ? ieee80211_do_open+0x258/0x4ad [mac80211]
> [   20.555638]  [<c013d8fe>] ? notifier_call_chain+0x20/0x42
> [   20.555651]  [<c0311ecd>] ? __dev_open+0x84/0xb8
> [   20.555660]  [<c0311e40>] ? dev_set_rx_mode+0x18/0x21
> [   20.555670]  [<c03120ad>] ? __dev_change_flags+0x93/0x108
> [   20.555683]  [<c01c1baa>] ? full_name_hash+0x13/0x3c
> [   20.555692]  [<c0312181>] ? dev_change_flags+0x10/0x3b
> [   20.555705]  [<c03538c3>] ? devinet_ioctl+0x21d/0x4f2
> [   20.555729]  [<c030e531>] ? dev_name_hash.isra.69+0x1b/0x2c
> [   20.555741]  [<c03010c5>] ? sock_ioctl+0x1ce/0x1f8
> [   20.555749]  [<c0300ef7>] ? sock_fasync+0x68/0x68
> [   20.555765]  [<c01c62d8>] ? vfs_ioctl+0x18/0x21
> [   20.555775]  [<c01c6d70>] ? do_vfs_ioctl+0x3f3/0x433
> [   20.555791]  [<c01bbed9>] ? fget_light+0x28/0x78
> [   20.555803]  [<c0302fc9>] ? sys_recvmsg+0x49/0x52
> [   20.555813]  [<c030344e>] ? sys_socketcall+0x26a/0x2c2
> [   20.555822]  [<c01c6df0>] ? sys_ioctl+0x40/0x60
> [   20.555839]  [<c03bd1df>] ? sysenter_do_call+0x12/0x28
> [   20.555846] ---[ end trace 937b8f4eefd318a5 ]---
> [   20.669180] b43-phy0: Loading OpenSource firmware version 410.31754
> [   20.669197] b43-phy0: Hardware crypto acceleration not supported by firmware
> [   20.669202] b43-phy0: QoS not supported by firmware
>
> After applying both patches to kernel 3.5, b43 && OpenFWWF 5.2 are
> working fine again; b43 with Broadcom's proprietary firmware was not
> affected.

The patch works here on current (3.5-rc7) wireless-testing without WARN or oops 
on my PPC.

Larry

