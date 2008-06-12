Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from an-out-0708.google.com ([209.85.132.251]:21187 "EHLO
	an-out-0708.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750894AbYFLQZi (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 12 Jun 2008 12:25:38 -0400
Received: by an-out-0708.google.com with SMTP id d40so880498and.103
        for <linux-wireless@vger.kernel.org>; Thu, 12 Jun 2008 09:25:37 -0700 (PDT)
Message-ID: <5ff0631c0806120925m1e00482du5175c9b9a2f7f4dd@mail.gmail.com> (sfid-20080612_182544_336088_BE80596E)
Date: Thu, 12 Jun 2008 18:25:35 +0200
From: "Nicolas Deschildre" <ndeschildre@gmail.com>
To: linux-wireless@vger.kernel.org
Subject: [OOPS] rt2x00: unplugging an rt73 device oops at usb_kill_urb+0x14/0xd0
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

I tried the wireless compatibilty stack from the 5 June.
When unplugging a RT73 device from its USB slot, I get the following oops :

[  703.840132] usb 3-3: USB disconnect, address 2
[  703.840623] phy1 -> rt2x00usb_vendor_request: Error - Vendor
Request 0x07 failed for offset 0x3040 with error -19.
[  703.840636] phy1 -> rt2x00usb_vendor_request: Error - Vendor
Request 0x06 failed for offset 0x3040 with error -19.
[  703.840646] phy1 -> rt2x00usb_vendor_request: Error - Vendor
Request 0x06 failed for offset 0x3028 with error -19.
[  703.840655] phy1 -> rt2x00usb_vendor_request: Error - Vendor
Request 0x06 failed for offset 0x3064 with error -19.
[  703.840663] phy1 -> rt2x00usb_vendor_request: Error - Vendor
Request 0x0c failed for offset 0x0000 with error -19.
[  703.840699] BUG: unable to handle kernel paging request at virtual
address f0000182
[  703.840706] printing eip: e089fee4 *pde = 00000000
[  703.840714] Oops: 0000 [#1] SMP
[  703.840720] Modules linked in: rt2500usb rt73usb crc_itu_t
rt2x00usb af_packet arc4 ecb blkcipher rt2500pci rt2x00pci rt2x00lib
rfkill input_polldev mac80211 cfg80211 eeprom_93cx6 ipv6 rfcomm l2cap
bluetooth ppdev powernow_k8 cpufreq_userspace cpufreq_powersave
cpufreq_conservative cpufreq_ondemand cpufreq_stats freq_table sbs
dock sbshc iptable_filter ip_tables x_tables lp joydev pcmcia evdev
parport_pc parport snd_intel8x0 snd_ac97_codec ac97_bus snd_pcm_oss
snd_mixer_oss psmouse serio_raw snd_pcm video output battery container
ac snd_seq_dummy yenta_socket rsrc_nonstatic pcmcia_core snd_seq_oss
snd_seq_midi snd_rawmidi pcspkr wmi_acer snd_seq_midi_event snd_seq
k8temp button snd_timer snd_seq_device snd soundcore snd_page_alloc
shpchp pci_hotplug amd64_agp agpgart i2c_nforce2 i2c_core ext3 jbd
mbcache sg sr_mod cdrom sd_mod pata_amd ata_generic pata_acpi 8139too
8139cp mii libata scsi_mod ehci_hcd ohci_hcd usbcore thermal processor
fan fbcon tileblit font bitblit softcursor fuse
[  703.840836]
[  703.840841] Pid: 1439, comm: khubd Not tainted (2.6.24-19-generic #1)
[  703.840847] EIP: 0060:[<e089fee4>] EFLAGS: 00010286 CPU: 0
[  703.840896] EIP is at usb_kill_urb+0x14/0xd0 [usbcore]
[  703.840901] EAX: 00000000 EBX: f000015a ECX: 00000282 EDX: ddf60000
[  703.840907] ESI: 00000002 EDI: deb98e40 EBP: deb98e40 ESP: ddf61e10
[  703.840913]  DS: 007b ES: 007b FS: 00d8 GS: 0000 SS: 0068
[  703.840918] Process khubd (pid: 1439, ti=ddf60000 task=dde5f140
task.ti=ddf60000)
[  703.840923] Stack: 00000000 00000040 0000000c ddf61e8c ded74e00
00000028 00000002 e0c30796
[  703.840936]        00000000 00000000 00000000 00000000 000001f4
ddf61e8c ded74e00 deb98180
[  703.840947]        e0c22dd8 00003064 ddf61e8c 00000004 000001f4
00000287 c01a5201 00000003
[  703.840959] Call Trace:
[  703.840991]  [<e0c30796>] rt2x00usb_disable_radio+0x96/0xc0 [rt2x00usb]
[  703.841038]  [<e0c22dd8>] rt73usb_set_device_state+0xe18/0x1050 [rt73usb]
[  703.841071]  [<c01a5201>] find_inode+0x31/0x60
[  703.841133]  [<e0c12482>] rt2x00lib_disable_radio+0x52/0x80 [rt2x00lib]
[  703.841154]  [<e0c124bd>] rt2x00lib_remove_dev+0xd/0x40 [rt2x00lib]
[  703.841173]  [<e0c309b0>] rt2x00usb_disconnect+0x20/0x60 [rt2x00usb]
[  703.841202]  [<e08a36b0>] usb_unbind_interface+0x50/0xb0 [usbcore]
[  703.841267]  [<c0282644>] __device_release_driver+0x64/0xa0
[  703.841287]  [<c0282ab3>] device_release_driver+0x23/0x40
[  703.841300]  [<c0281f1b>] bus_remove_device+0x4b/0x70
[  703.841313]  [<c02804f5>] device_del+0x135/0x250
[  703.841342]  [<e08a07f0>] usb_disable_device+0x80/0xf0 [usbcore]
[  703.841402]  [<e089c3d8>] usb_disconnect+0x98/0x130 [usbcore]
[  703.841485]  [<e089d857>] hub_thread+0x447/0xcb0 [usbcore]
[  703.841633]  [<c0140c20>] autoremove_wake_function+0x0/0x40
[  703.841676]  [<e089d410>] hub_thread+0x0/0xcb0 [usbcore]
[  703.841721]  [<c0140962>] kthread+0x42/0x70
[  703.841728]  [<c0140920>] kthread+0x0/0x70
[  703.841743]  [<c0105677>] kernel_thread_helper+0x7/0x10
[  703.841776]  =======================
[  703.841780] Code: 8b 48 2c b2 d5 85 c9 74 e7 b2 98 e9 67 fe ff ff
8d b4 26 00 00 00 00 56 53 89 c3 83 ec 14 e8 54 af a7 df 85 db 0f 84
ad 00 00 00 <8b> 43 28 85 c0 0f 84 a2 00 00 00 8b 43 2c 85 c0 0f 84 97
00 00
[  703.841832] EIP: [<e089fee4>] usb_kill_urb+0x14/0xd0 [usbcore]
SS:ESP 0068:ddf61e10

Thanks,

Nicolas
