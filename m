Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from omr-m08.mx.aol.com ([64.12.222.129]:31312 "EHLO
	omr-m08.mx.aol.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751285Ab3JURWD convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 21 Oct 2013 13:22:03 -0400
Received: from mtaomg-da04.r1000.mx.aol.com (mtaomg-da04.r1000.mx.aol.com [172.29.51.140])
	by omr-m08.mx.aol.com (Outbound Mail Relay) with ESMTP id 94A9B7012AE69
	for <linux-wireless@vger.kernel.org>; Mon, 21 Oct 2013 13:14:06 -0400 (EDT)
Received: from core-mob002a.r1000.mail.aol.com (core-mob002.r1000.mail.aol.com [172.29.194.197])
	by mtaomg-da04.r1000.mx.aol.com (OMAG/Core Interface) with ESMTP id 08A5DE000088
	for <linux-wireless@vger.kernel.org>; Mon, 21 Oct 2013 13:14:05 -0400 (EDT)
To: linux-wireless@vger.kernel.org
Subject: Updates to 3.8 kernel break b43 Wireless with 4331 chipset
MIME-Version: 1.0
From: andrewl733@aol.com
Content-Type: text/plain; charset="utf-8"; format=flowed
Message-Id: <8D09C98149E95D8-27D8-2CD34@Webmail-d105.sysops.aol.com> (sfid-20131021_192210_113216_661743A2)
Date: Mon, 21 Oct 2013 13:14:05 -0400 (EDT)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

I just reported this but to Mageia but it seems like it is more likely 
to be a Linux wireless bug.

I have a Macbook Pro 8,2 with Broadcom 4331 wireless chipset. The 
update from the original Mageia 3 kernel (their 3.8.13-1) to a newer 
Mageia 3 kernel with security and bug fixes (their 3.8.13.4-1) broke my 
b43 wireless.  After the update, I had the following symptoms:

-- Frequent disconnections from any wireless network.  Disconnections 
typically occur every 3-5 minutes.  To get the connection back, I have 
to disable and re-enable wireless in Gnome Network Settings (or Network 
Manager), or unload and reload b43 module in KDE.
-- Failure to see many access points.  The only way to connect is to 
configure as a "hidden" network

Unfortunately, when running the Mageia 3.8.13.4-1 kernel, there is no 
information in dmesg or in the syslog to show what is going on.  
iwconfig shows that I am still connected to the network.  ifconfig 
shows the connection is still "up". The Network Manager icon shows that 
I am still connected.  However, no traffic is passing in or out.

I knew this didn't happen when I first installed Mageia 3 several 
months ago and in fact, going back to the Mageia 3 Live DVD got rid of 
the problem. To troubleshoot, I decided to try the Mint 15 Live DVD (of 
course, I had to copy the b43 firmware into Mint).  Much to my 
surprise, I had the same problem with Mint.  But in Mint, unlike in 
Mageia, dmesg perhaps offers some clues as to what is going on. Every 
few minutes, I find a message which says, in effect, that the "b43 
firmware crashed".

>From Mint dmesg:

[  909.754038] b43-phy0 ERROR: Firmware watchdog: The firmware died!
[  909.754050] b43-phy0: Controller RESET (Firmware watchdog) ...
[  909.949810] ------------[ cut here ]------------
[  909.949839] WARNING: at 
/build/buildd/linux-3.8.0/drivers/net/wireless/b43/main.c:2574 
b43_chip_init+0x9b6/0x9d0 [b43]()
[  909.949844] Hardware name: MacBookPro8,2
[  909.949847] Modules linked in: arc4(F) b43 bcma mac80211 cfg80211 
ssb dm_crypt(F) parport_pc(F) ppdev(F) lp(F) parport(F) uvcvideo 
snd_hda_codec_hdmi videobuf2_vmalloc videobuf2_memops videobuf2_core 
videodev coretemp btusb snd_hda_codec_cirrus kvm_intel snd_hda_intel 
bcm5974 kvm snd_hda_codec snd_hwdep(F) snd_pcm(F) joydev(F) apple_gmux 
dm_multipath(F) bnep applesmc ghash_clmulni_intel(F) aesni_intel(F) 
scsi_dh(F) snd_page_alloc(F) snd_seq_midi(F) snd_seq_midi_event(F) 
apple_bl snd_rawmidi(F) aes_x86_64(F) xts(F) lrw(F) gf128mul(F) 
ablk_helper(F) cryptd(F) snd_seq(F) rfcomm mac_hid mei 
snd_seq_device(F) snd_timer(F) bluetooth input_polldev snd(F) 
soundcore(F) lpc_ich microcode(F) binfmt_misc(F) squashfs(F) 
overlayfs(F) nls_utf8 isofs(F) nls_iso8859_1(F) dm_raid45 xor(F) 
dm_mirror(F) dm_region_hash(F) dm_log(F) hid_generic hid_apple usbhid 
hid radeon firewire_ohci firewire_core crc_itu_t(F) i2c_algo_bit ttm 
tg3 drm_kms_helper sdhci_pci drm ptp sdhci pps_core video(F) [last 
unloaded: bcma]
[  909.949988] Pid: 3917, comm: kworker/u:1 Tainted: GF       W    
3.8.0-19-generic #29-Ubuntu
[  909.949992] Call Trace:
[  909.950006]  [<ffffffUpdates to 3.8 kernel break b43 Wireless with 
4331 chipsetff810587ef>] warn_slowpath_common+0x7f/0xc0
[  909.950014]  [<ffffffff8105884a>] warn_slowpath_null+0x1a/0x20
[  909.950028]  [<ffffffffa0585fc6>] b43_chip_init+0x9b6/0x9d0 [b43]
[  909.950041]  [<ffffffffa0586142>] b43_wireless_core_init+0x162/0x840 
[b43]
[  909.950054]  [<ffffffffa0586fb7>] b43_chip_reset+0x67/0x120 [b43]
[  909.950064]  [<ffffffff8107671c>] process_one_work+0x15c/0x4d0
[  909.950072]  [<I just reported this but to Mageia but it seems like 
it is more likely to be a Linux wireless bug.

I have a Macbook Pro 8,2 with Broadcom 4331 wireless chipset. The 
update from the original Mageia 3 kernel (their 3.8.13-1) to a newer 
Mageia 3 kernel with security and bug fixes (their 3.8.13.4-1) broke my 
b43 wireless.  After the update, I had the following symptoms:

-- Frequent disconnections from any wireless network.  Disconnections 
typically occur every 3-5 minutes.  To get the connection back, I have 
to disable and re-enable wireless in Gnome Network Settings (or Network 
Manager), or unload and reload b43 module in KDE.
-- Failure to see many access points.  The only way to connect is to 
configure as a "hidden" network

Unfortunately, when running the Mageia 3.8.13.4-1 kernel, there is no 
information in dmesg or in the syslog to show what is going on.  
iwconfig shows that I am still connected to the network.  ifconfig 
shows the coUpdates to 3.8 kernel break b43 Wireless with 4331 
chipsetnnection is still "up". The Network Manager icon shows that I am 
still connected.  However, no traffic is passing in or out.

I knew this didn't happen when I first installed Mageia 3 several 
months ago and in fact, going back to the Mageia 3 Live DVD got rid of 
the problem. To troubleshoot, I decided to try the Mint 15 Live DVD (of 
course, I had to copy the b43 firmware into Mint).  Much to my 
surprise, I had the same problem with Mint.  But in Mint, unlike in 
Mageia, dmesg perhaps offers some clues as to what is going on. Every 
few minutes, I find a message which says, in effect, that the "b43 
firmware crashed".

>From Mint dmesg:

[  909.754038] b43-phy0 ERROR: Firmware watchdog: The firmware died!
[  909.754050] b43-phy0: Controller RESET (Firmware watchdog) ...
[  909.949810] ------------[ cut here ]------------
[  909.949839] WARNING: at 
/build/buildd/linux-3.8.0/drivers/net/wireless/b43/main.c:2574 
b43_chip_init+0x9b6/0x9d0 [b43]()
[  909.949844] Hardware name: MacBookPro8,2
[  909.949847] Modules linked in: arc4(F) b43 bcma mac80211 cfg80211 
ssb dm_crypt(F) parport_pc(F) ppdev(F) lp(F) parport(F) uvcvideo 
snd_hda_codec_hdmi videobuf2_vmalloc videobuf2_memops videobuf2_core 
videodev coretemp btusb snd_hda_codec_cirrus kvm_intel snd_hda_intel 
bcm5974 kvm snd_hda_codec snd_hwdep(F) snd_pcm(F) joydev(F) apple_gmux 
dm_multipath(F) bnep applesmc ghash_clmulni_intel(F) aesni_intel(F) 
scsi_dh(F) snd_page_alloc(F) snd_seq_midi(F) snd_seq_midi_event(F) 
apple_bl snd_rawmidi(F) aes_x86_64(F) xts(F) lrw(F) gf128mul(F) 
ablk_helper(F) cryptd(F) snd_seq(F) rfcomm mac_hid mei 
snd_seq_device(F) snd_timer(F) bluetooth input_polldev snd(F) 
soundcore(F) lpc_ich microcode(F) binfmt_misc(F) squashfs(F) 
overlayfs(F) nls_utf8 isofs(F) nls_iso8859_1(F) dm_raid45 xor(F) 
dm_mirror(F) dm_region_hash(F) dm_log(F) hid_generic hid_apple usbhid 
hid radeon firewire_ohci firewire_core crc_itu_t(F) i2c_algo_bit ttm 
tg3 drm_kms_helper sdhci_pci drm ptp sdhci pps_core video(F) [last 
unloaded: bcma]
[  909.949988] Pid: 3917, comm: kworker/u:1 Tainted: GF       W    
3.8.0-19-generic #29-Ubuntu
[  909.949992] Call Trace:
[  909.950006]  [<ffffffff810587ef>] warn_slowpath_common+0x7f/0xc0
[  909.950014]  [<ffffffff8105884a>] warn_slowpath_null+0x1a/0x20
[  909.950028]  [<ffffffffa0585fc6>] b43_chip_init+0x9b6/0x9d0 [b43]
[  909.950041]  [<ffffffffa0586142>] b43_wireless_core_init+0x162/0x840 
[b43]
[  909.950054]  [<ffffffffa0586fb7>] b43_chip_reset+0x67/0x120 [b43]
[  909.950064]  [<ffffffff8107671c>] process_one_work+0x15c/0x4d0
[  909.950072]  [<ffffffff81077f7e>] worker_thread+0x16e/0x480
[  909.950080]  [<ffffffff81077e10>] ? manage_workers+0x2a0/0x2a0
[  909.950087]  [<ffffffff8107d2b0>] kthread+0xc0/0xd0
[  909.950094]  [<ffffffff8107d1f0>] ? 
kthread_create_on_node+0x120/0x120
[  909.950105]  [<ffffffff816d36ec>] ret_from_fork+0x7c/0xb0
[  909.950111]  [<ffffffff8107d1f0>] ? 
kthread_create_on_node+0x120/0x120
[  909.950117] ---[ endUpdates to 3.8 kernel break b43 Wireless with 
4331 chipset trace a14aa72aa3cdd697 ]---
[  909.950123] b43-phy0: Loading OpenSource firmware version 666.2535
[  909.950148] b43-phy0: Hardware crypto acceleration not supported by 
firmware
[  910.009859] b43-phy0: Controller restarted
[  970.655552] b43-phy0 ERROR: Firmware watchdog: The firmware died!
[  970.655564] b43-phy0: Controller RESET (Firmware watchdog) ...
[  970.851367] ------------[ cut here ]------------
[  970.851395] WARNING: at 
/build/buildd/linux-3.8.0/drivers/net/wireless/b43/main.c:2574 
b43_chip_init+0x9b6/0x9d0 [b43]()
[  970.851399] Hardware name: MacBookPro8,2
[  970.851403] Modules linked in: arc4(F) b43 bcma mac80211 cfg80211 
ssb dm_crypt(F) parport_pc(F) ppdev(F) lp(F) parport(F) uvcvideo 
snd_hda_codec_hdmi videobuf2_vmalloc videobuf2_memops videobuf2_core 
videodev coretemp btusb snd_hda_codec_cirrus kvm_intel snd_hda_intel 
bcm5974 kvm snd_hda_codec snd_hwdep(F) snd_pcm(F) joydev(F) apple_gmux 
dm_multipath(F) bnep applesmc ghash_clmulni_intel(F) aesni_intel(F) 
scsi_dh(F) snd_page_alloc(F) snd_seq_midi(F) snd_seq_midi_event(F) 
apple_bl snd_rawmidi(F) aes_x86_64(F) xts(F) lrw(F) gf128mul(F) 
ablk_helper(F) cryptd(F) snd_seq(F) rfcomm mac_hid mei 
snd_seq_device(F) snd_timer(F) bluetooth input_polldev snd(F) 
soundcore(F) lpc_ich microcode(F) binfmt_misc(F) squashfs(F) 
overlayfs(F) nls_utf8 isofs(F) nls_iso8859_1(F) dm_raid45 xor(F) 
dm_mirror(F) dm_region_hash(F) dm_log(F) hid_generic hid_apple usbhid 
hid radeon firewire_ohci firewire_core crc_itu_t(F) i2c_algo_bit ttm 
tg3 drm_kms_helper sdhci_pci drm ptp sdhci pps_core video(F) [last 
unloaded: bcma]
[  970.851543] Pid: 3917, comm: kworker/u:1 Tainted: GF       W    
3.8.0-19-generic #29-Ubuntu
[  970.851547] Call Trace:
[  970.851561]  [<ffffffff810587ef>] warn_slowpath_common+0x7f/0xc0
[  970.851568]  [<ffffffff8105884a>] warn_slowpath_null+0x1a/0x20
[  970.851582]  [<ffffffffa0585fc6>] b43_chip_init+0x9b6/0x9d0 [b43]
[  970.851595]  [<ffffffffa0586142>] b43_wireless_core_init+0x162/0x840 
[b43]
[  970.851608]  [<ffffffffa0586fb7>] b43_chip_reset+0x67/0x120 [b43]
[  970.851617]  [<ffffffff8107671c>] process_one_work+0x15c/0x4d0
[  970.851625]  [<ffffffff81077f7e>] worker_thread+0x16e/0x480
[  970.851633]  [<ffffffff81077e10>] ? manage_workers+0x2a0/0x2a0
[  970.851639]  [<ffffffff8107d2b0>] kthread+0xc0/0xd0
[  970.851646]  [<ffffffff8107d1f0>] ? 
kthread_create_on_node+0x120/0x120
[  970.851657]  [<ffffffff816d36ec>] ret_from_fork+0x7c/0xb0
[  970.851663]  [<ffffffff8107d1f0>] ? 
kthread_create_on_node+0x120/0x120
[  970.851668] ---[ end trace a14aa72aa3cdd698 ]---
[  970.851675] b43-phy0: Loading OpenSource firmware version 666.2535
[  970.851700] b43-phy0: Hardware crypto acceleration not supported by 
firmware
[  970.911468] b43-phy0: Controller restarted

Sometimes the wireless connection survives these glitches.  For 
instance, if I am listen to streaming Internet radio, I might not 
experience the sound cutting out (if it has buffered enough).  If I am 
trying to read my email during a disconnection, I get an error in my 
browser saying "Unable to resolve host". Eventually, the connection 
goes away and never comes back.

If you Google "b43 4331 3.8 kernel" or "b43 4331 disconnection" you 
will find lots of posts from people having trouble with the 4331 
broadcom chipset and the 3.8 (and maybe 3.9) kernel.

Bug 913341 – Kernel 3.8 breaks b43 wireless
https://bugzilla.redhat.com/show_bug.cgi?id=913341

14e4:4331 Broadcom BCM4331 unusable with Raring kernel 3.8.0-19
https://bugs.launchpad.net/ubuntu/+source/linux/+bug/1174347

Bug #1142385 “B43 Wireless Autoconnect Failure” : Bugs : “linux ...
https://bugs.launchpad.net/ubuntu/+source/linux/+bug/1142385

strange b43 problem // 3.9 regression? (Linux Wireless) - spinics.net
http://www.spinics.net/lists/linux-wireless/msg108825.html


For whatever reason, the 3.8 kernel originally included with Mageia 3 
does NOT have this problem (one disconnection seems to occur maybe once 
every few days) whereas with the updated kernel it occurs every few 
minutes.

Two days ago I managed to revert my Mac to the original Mageia 3 
kernel.  The wireless has stayed up for 48 hours so far without a 
glitch.
ffffffff81077f7e>] worker_thread+0x16e/0x480
[  909.950080]  [<ffffffff81077e10>] ? manage_workers+0x2a0/0x2a0
[  909.950087]  [<ffffffff8107d2b0>] kthread+0xc0/0xd0
[  909.950094]  [<ffffffff8107d1f0>] ? 
kthread_create_on_node+0x120/0x120
[  909.950105]  [<ffffffff816d36ec>] ret_from_fork+0x7c/0xb0
[  909.950111]  [<ffffffff8107d1f0>] ? 
kthread_create_on_node+0x120/0x120
[  909.950117] ---[ end trace a14aa72aa3cdd697 ]---
[  909.950123] b43-phy0: Loading OpenSource firmware version 666.2535
[  909.950148] b43-phy0: Hardware crypto acceleration not supported by 
firmware
[  910.009859] b43-phy0: Controller restarted
[  970.655552] b43-phy0 ERROR: Firmware watchdog: The firmware died!
[  970.655564] b43-phy0: Controller RESET (Firmware watchdog) ...
[  970.851367] ------------[ cut here ]------------
[  970.851395] WARNING: at 
/build/buildd/linux-3.8.0/drivers/net/wireless/b43/main.c:2574 
b43_chip_init+0x9b6/0x9d0 [b43]()
[  970.851399] Hardware name: MacBookPro8,2
[  970.851403] Modules linked in: arc4(F) b43 bcma mac80211 cfg80211 
ssb dm_crypt(F) parport_pc(F) ppdev(F) lp(F) parport(F) uvcvideo 
snd_hda_codec_hdmi videobuf2_vmalloc videobuf2_memops videobuf2_core 
videodev coretemp btusb snd_hda_codec_cirrus kvm_intel snd_hda_intel 
bcm5974 kvm snd_hda_codec snd_hwdep(F) snd_pcm(F) joydev(F) apple_gmux 
dm_multipath(F) bnep applesmc ghash_clmulni_intel(F) aesni_intel(F) 
scsi_dh(F) snd_page_alloc(F) snd_seq_midi(F) snd_seq_midi_event(F) 
apple_bl snd_rawmidi(F) aes_x86_64(F) xts(F) lrw(F) gf128mul(F) 
ablk_helper(F) cryptd(F) snd_seq(F) rfcomm mac_hid mei 
snd_seq_device(F) snd_timer(F) bluetooth input_polldev snd(F) 
soundcore(F) lpc_ich microcode(F) binfmt_misc(F) squashfs(F) 
overlayfs(F) nls_utf8 isofs(F) nls_iso8859_1(F) dm_raid45 xor(F) 
dm_mirror(F) dm_region_hash(F) dm_log(F) hid_generic hid_apple usbhid 
hid radeon firewire_ohci firewire_core crc_itu_t(F) i2c_algo_bit ttm 
tg3 drm_kms_helper sdhci_pci drm ptp sdhci pps_core video(F) [last 
unloaded: bcma]
[  970.851543] Pid: 3917, comm: kworker/u:1 Tainted: GF       W    
3.8.0-19-generic #29-Ubuntu
[  970.851547] Call Trace:
[  970.851561]  [<ffffffff810587ef>] warn_slowpath_common+0x7f/0xc0
[  970.851568]  [<ffffffff8105884a>] warn_slowpath_null+0x1a/0x20
[  970.851582]  [<ffffffffa0585fc6>] b43_chip_init+0x9b6/0x9d0 [b43]
[  970.851595]  [<ffffffffa0586142>] b43_wireless_core_init+0x162/0x840 
[b43]
[  970.851608]  [<ffffffffa0586fb7>] b43_chip_reset+0x67/0x120 [b43]
[  970.851617]  [<ffffffff8107671c>] process_one_work+0x15c/0x4d0
[  970.851625]  [<ffffffff81077f7e>] worker_thread+0x16e/0x480
[  970.851633]  [<ffffffff81077e10>] ? manage_workers+0x2a0/0x2a0
[  970.851639]  [<ffffffff8107d2b0>] kthread+0xc0/0xd0
[  970.851646]  [<ffffffff8107d1f0>] ? 
kthread_create_on_node+0x120/0x120
[  970.851657]  [<ffffffff816d36ec>] ret_from_fork+0x7c/0xb0
[  970.851663]  [<ffffffff8107d1f0>] ? 
kthread_create_on_node+0x120/0x120
[  970.851668] ---[ end trace a14aa72aa3cdd698 ]---
[  970.851675] b43-phy0: Loading OpenSource firmware version 666.2535
[  970.851700] b43-phy0: Hardware crypto acceleration not supported by 
firmware
[  970.911468] b43-phy0: Controller restarted

Sometimes the wireless connection survives these glitches.  For 
instance, if I am listen to streaming Internet radio, I might not 
experience the sound cutting out (if it has buffered enough).  If I am 
trying to read my email during a disconnection, I get an error in my 
browser saying "Unable to resolve host". Eventually, the connection 
goes away and never comes back.

If you Google "b43 4331 3.8 kernel" or "b43 4331 disconnection" you 
will find lots of posts from people having trouble with the 4331 
broadcom chipset and the 3.8 (and maybe 3.9) kernel.

Bug 913341 – Kernel 3.8 breaks b43 wireless
https://bugzilla.redhat.com/show_bug.cgi?id=913341

14e4:4331 Broadcom BCM4331 unusable with Raring kernel 3.8.0-19
https://bugs.launchpad.net/ubuntu/+source/linux/+bug/1174347

Bug #1142385 “B43 Wireless Autoconnect Failure” : Bugs : “linux ...
https://bugs.launchpad.net/ubuntu/+source/linux/+bug/1142385

strange b43 problem // 3.9 regression? (Linux Wireless) - spinics.net
http://www.spinics.net/lists/linux-wireless/msg108825.html


For whatever reason, the 3.8 kernel originally included with Mageia 3 
does NOT have this problem (one disconnection seems to occur maybe once 
every few days) whereas with the updated kernel it occurs every few 
minutes.

Two days ago I managed to revert my Mac to the original Mageia 3 
kernel.  The wireless has stayed up for 48 hours so far without a 
glitch.

-- Andrew


