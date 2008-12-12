Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from rv-out-0506.google.com ([209.85.198.231]:1119 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751515AbYLLXAC convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 12 Dec 2008 18:00:02 -0500
Received: by rv-out-0506.google.com with SMTP id k40so1587754rvb.1
        for <linux-wireless@vger.kernel.org>; Fri, 12 Dec 2008 15:00:01 -0800 (PST)
Message-ID: <69e28c910812121500n67e45a52lb589833d84413adf@mail.gmail.com> (sfid-20081213_000007_485116_5175B675)
Date: Sat, 13 Dec 2008 00:00:01 +0100
From: "=?ISO-8859-1?Q?Stefanik_G=E1bor?=" <netrolller.3d@gmail.com>
To: "Johannes Berg" <johannes@sipsolutions.net>
Subject: Re: [RFC 2/3] mac80211: Make use of the new F_TX_NOACK and F_TX_NOSEQ Radiotap TX flags
Cc: "John W. Linville" <linville@tuxdriver.com>,
	linux-wireless <linux-wireless@vger.kernel.org>
In-Reply-To: <1229122339.3565.18.camel@johannes.berg>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
References: <69e28c910812121432n6e84de41s94a887110051a1dd@mail.gmail.com>
	 <1229121558.3565.6.camel@johannes.berg>
	 <69e28c910812121443h1fae52e6uc88749d7e9baf529@mail.gmail.com>
	 <1229121947.3565.13.camel@johannes.berg>
	 <69e28c910812121451u25713c82o229a56006089edd6@mail.gmail.com>
	 <1229122339.3565.18.camel@johannes.berg>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, Dec 12, 2008 at 11:52 PM, Johannes Berg
<johannes@sipsolutions.net> wrote:
> On Fri, 2008-12-12 at 23:51 +0100, Stefanik G=E1bor wrote:
>
>> But if we redefine !ASSIGN_SEQ to mean "use the sequence number
>> supplied by userspace", we will need a new flag to distinguish betwe=
en
>> driver-level vs. stack-level sequence number assignments, which is
>> essentially the same as this patch. There is no way to switch betwee=
n
>> 3 states (control in driver, stack or userspace) using only one bit.
>
> Good point, I forgot about that. But that isn't true for no-ack :)
>
> johannes
>

By the way, here is a bit more about the oops:

It only seems to happen if I set TX_CTL_NO_ACK directly in
parse_tx_radiotap *and* add a printk to assign_seq that depends on
TX_CTL_NO_ACK. If I don't add the printk, no oops occurs, however it
seems that something unsets TX_CTL_NO_ACK after it is set in
parse_tx_radiotap.

And here is the log:
Dec 12 19:39:18 NR3DMain kernel: Oops: 0000 [#1] SMP
Dec 12 19:39:18 NR3DMain kernel: last sysfs file: /sys/module/rt73usb/s=
rcversion
Dec 12 19:39:18 NR3DMain kernel: Modules linked in: b43 zd1211rw
rtl8187(-) ath5k rt73usb rt2x00usb rt2x00lib mac80211 cfg80211
af_packet ocfs2_dlmfs ocfs2_dlm ocfs2_nodemanager configfs ipv6
snd_pcm_oss snd_mixer_oss snd_seq snd_seq_device rfkill_input bridge
stp bnep binfmt_misc microcode fuse ext3 jbd mbcache loop dm_mod
nvidiafb rfcomm input_polldev fb_ddc l2cap i2c_algo_bit crc_itu_t
vgastate arc4 snd_hda_intel snd_pcm ssb ecb snd_timer snd_page_alloc
pcmcia btusb rfkill nvidia(P) intel_agp snd_hwdep rtc_cmos i2c_i801
ohci1394 eeprom_93cx6 led_class agpgart r8169 rtc_core ahci iTCO_wdt
snd pcmcia_core ieee1394 sr_mod button i2c_core cdrom sky2 mii joydev
rtc_lib soundcore bluetooth iTCO_vendor_support sg sd_mod crc_t10dif
pata_acpi usbhid hid ata_generic ata_piix pata_jmicron ide_pci_generic
ide_core ehci_hcd uhci_hcd usbcore edd reiserfs fan pata_amd libata
scsi_mod thermal processor [last unloaded: cfg80211]
Dec 12 19:39:18 NR3DMain kernel:
Dec 12 19:39:18 NR3DMain kernel: Pid: 1874, comm: rmmod Tainted: P
      (2.6.28-rc6-wl-wireless12 #2) P5K Premium
Dec 12 19:39:18 NR3DMain kernel: EIP: 0060:[<f994a069>] EFLAGS: 0021020=
2 CPU: 0
Dec 12 19:39:18 NR3DMain kernel: EIP is at reg_device_remove+0x9/0x30 [=
cfg80211]
Dec 12 19:39:18 NR3DMain kernel: EAX: f3530040 EBX: f353000c ECX:
00000000 EDX: f1c24640
Dec 12 19:39:18 NR3DMain kernel: ESI: f3530000 EDI: f3530040 EBP:
f3d61e70 ESP: f3d61e70
Dec 12 19:39:18 NR3DMain kernel:  DS: 007b ES: 007b FS: 00d8 GS: 0033 S=
S: 0068
Dec 12 19:39:18 NR3DMain kernel: Process rmmod (pid: 1874, ti=3Df3d6000=
0
task=3Df0939900 task.ti=3Df3d60000)
Dec 12 19:39:18 NR3DMain kernel: Stack:
Dec 12 19:39:18 NR3DMain kernel:  f3d61e84 f9949239 f35301c0 f6adba00
00000000 f3d61e98 f995917d 00000003
Dec 12 19:39:18 NR3DMain kernel:  f3d61ea8 f35301c0 f3d61ea8 f8d57fb3
f6adba00 f6adba1c f3d61ec4 f99cce4b
Dec 12 19:39:18 NR3DMain kernel:  f8d5a700 f7786c00 f6adba94 f6adba1c
f8d5a734 f3d61ed8 c02bcb64 f6adba1c
Dec 12 19:39:18 NR3DMain kernel: Call Trace:
Dec 12 19:39:18 NR3DMain kernel:  [<f9949239>] ?
wiphy_unregister+0x39/0x80 [cfg80211]
Dec 12 19:39:18 NR3DMain kernel:  [<f995917d>] ?
ieee80211_unregister_hw+0xad/0xd0 [mac80211]
Dec 12 19:39:18 NR3DMain kernel:  [<f8d57fb3>] ?
rtl8187_disconnect+0x18/0x34 [rtl8187]
Dec 12 19:39:18 NR3DMain kernel:  [<f99cce4b>] ?
usb_unbind_interface+0x4b/0xf0 [usbcore]
Dec 12 19:39:18 NR3DMain kernel:  [<c02bcb64>] ?
__device_release_driver+0x74/0xb0
Dec 12 19:39:18 NR3DMain kernel:  [<c02bcc3f>] ? driver_detach+0x9f/0xb=
0
Dec 12 19:39:18 NR3DMain kernel:  [<c02bbd54>] ? bus_remove_driver+0x84=
/0xf0
Dec 12 19:39:18 NR3DMain kernel:  [<c02bd2e1>] ? driver_unregister+0x31=
/0x40
Dec 12 19:39:18 NR3DMain kernel:  [<f99ccc37>] ?
usb_deregister+0x97/0xb0 [usbcore]
Dec 12 19:39:18 NR3DMain kernel:  [<f8d57f99>] ? rtl8187_exit+0xd/0xf [=
rtl8187]
Dec 12 19:39:18 NR3DMain kernel:  [<c015ea93>] ? sys_delete_module+0x16=
3/0x250
Dec 12 19:39:18 NR3DMain kernel:  [<c018ec03>] ? do_munmap+0x223/0x280
Dec 12 19:39:18 NR3DMain kernel:  [<c0103f47>] ? sysenter_do_call+0x12/=
0x2f
Dec 12 19:39:18 NR3DMain kernel: Code: f7 e1 8b 45 d4 c1 ea 05 39 f2
0f 4e f2 89 70 14 e9 77 ff ff ff 8d b6 00 00 00 00 8d bc 27 00 00 00
00 8b 0d 08 29 95 f9 55 89 e5 <8b> 11 85 d2 74 04 39 c2 74 05 5d c3 8d
76 00 c7 01 00 00 00 00
Dec 12 19:39:18 NR3DMain kernel: EIP: [<f994a069>]
reg_device_remove+0x9/0x30 [cfg80211] SS:ESP 0068:f3d61e70
Dec 12 19:39:18 NR3DMain kernel: ---[ end trace 0a56f848902ec565 ]---
--
To unsubscribe from this list: send the line "unsubscribe linux-wireles=
s" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
