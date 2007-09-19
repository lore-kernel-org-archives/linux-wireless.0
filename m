Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from main.gmane.org ([80.91.229.2]:42212 "EHLO ciao.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751482AbXISGTY (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 19 Sep 2007 02:19:24 -0400
Received: from list by ciao.gmane.org with local (Exim 4.43)
	id 1IXsu3-0002Yx-8l
	for linux-wireless@vger.kernel.org; Wed, 19 Sep 2007 08:19:15 +0200
Received: from 80.169.182.16 ([80.169.182.16])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-wireless@vger.kernel.org>; Wed, 19 Sep 2007 08:19:15 +0200
Received: from marcus by 80.169.182.16 with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-wireless@vger.kernel.org>; Wed, 19 Sep 2007 08:19:15 +0200
To: linux-wireless@vger.kernel.org
From: Marcus Better <marcus@better.se>
Subject: Re: rt2500 suspend problems
Date: Wed, 19 Sep 2007 08:16:58 +0200
Message-ID: <fcqf0s$n2a$1@sea.gmane.org>
References: <fc85aq$uu6$1@sea.gmane.org> <1189594257.6161.45.camel@johannes.berg> <fc8goi$abd$1@sea.gmane.org> <efe7343f0709120403s23d673bascec8e27ddcc1ad87@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Luis Correia wrote:
> Try to use the rt2x00.git repo, available at:
> git://git.kernel.org/pub/scm/linux/kernel/git/ivd/rt2x00.git

I now tried with current wireless-dev everything branch (2.6.23-rc6). The
driver doesn't work at all, instead I get the BUG below at startup (not
sure whether on driver load or interface activation). 

Sep 19 08:01:42 better kernel: BUG: unable to handle kernel paging request
at virtual address 5205fea9
Sep 19 08:01:42 better kernel:  printing eip:
Sep 19 08:01:42 better kernel: 5205fea9
Sep 19 08:01:42 better kernel: *pde = 00000000
Sep 19 08:01:42 better kernel: Oops: 0000 [#1]
Sep 19 08:01:42 better kernel: PREEMPT 
Sep 19 08:01:42 better kernel: Modules linked in: ppdev parport_pc lp
parport ipv6 acpi_cpufreq cpufreq_ondemand cpufreq_powersave cpufreq_stats
freq_table cpufreq_conservative cpufreq_userspace firewire_sbp2 loop arc4
ecb blkcipher rc80211_simple pcmcia firmware_class mousedev rt2500pci
rt2x00pci rt2x00lib rfkill input_polldev mac80211 cfg80211 sdhci
yenta_socket rsrc_nonstatic snd_hda_intel eeprom_93cx6 mmc_core snd_pcm
snd_timer snd pcmcia_core psmouse serio_raw pcspkr evdev rtc video output
i2c_piix4 ati_agp soundcore snd_page_alloc sky2 battery ac button ext3 jbd
mbcache usbhid hid dm_mirror dm_snapshot dm_mod ehci_hcd ohci_hcd
firewire_ohci firewire_core crc_itu_t usbcore thermal processor fan
Sep 19 08:01:42 better kernel: CPU:    0
Sep 19 08:01:42 better kernel: EIP:    0060:[<5205fea9>]    Not tainted VLI
Sep 19 08:01:42 better kernel: EFLAGS: 00210297   (2.6.23-rc6-lg #1)
Sep 19 08:01:42 better kernel: EIP is at 0x5205fea9
Sep 19 08:01:42 better kernel: eax: 5205fea9   ebx: 00000000   ecx: f7a45cb4  
edx: 00000001
Sep 19 08:01:42 better kernel: esi: dfdb3600   edi: 00000001   ebp: dfdb3610  
esp: f7a45dd4
Sep 19 08:01:42 better kernel: ds: 007b   es: 007b   fs: 0000  gs: 0033  ss:
0068
Sep 19 08:01:42 better kernel: Process wpa_supplicant (pid: 4237,
ti=f7a44000 task=f615bab0 task.ti=f7a44000)
Sep 19 08:01:42 better kernel: Stack: f8dc9033 00000000 dfdb3600 f7e9fda0
ffffff97 f8dc9458 f8e4c842 f7c558ec 
Sep 19 08:01:42 better kernel:        f7e9fda0 00000004 f7e9fda0 00000000
f8e46f5d f7e9fda0 f7c55800 dfdb589c 
Sep 19 08:01:42 better kernel:        dfdb58d0 00000000 dfdb58d0 f8e45a8d
0000002c f7f32440 f7f32484 f7a1ff44 
Sep 19 08:01:42 better kernel: Call Trace:
Sep 19 08:01:42 better kernel:  [<f8dc9033>] rfkill_toggle_radio+0x33/0x70
[rfkill]
Sep 19 08:01:42 better kernel:  [<f8dc9458>] rfkill_register+0x48/0xf0
[rfkill]
Sep 19 08:01:42 better kernel:  [<f8e4c842>]
rt2x00pci_initialize+0x132/0x1b0 [rt2x00pci]
Sep 19 08:01:42 better kernel:  [<f8e46f5d>] rt2x00rfkill_register+0x2d/0xc0
[rt2x00lib]
Sep 19 08:01:42 better kernel:  [<f8e45a8d>]
rt2x00lib_initialize+0x13d/0x160 [rt2x00lib]
Sep 19 08:01:42 better kernel:  [<f8e464ed>] rt2x00mac_start+0x2d/0x60
[rt2x00lib]
Sep 19 08:01:42 better kernel:  [<f8e46ae9>]
rt2x00mac_add_interface+0x29/0xd0 [rt2x00lib]
Sep 19 08:01:42 better kernel:  [<f8ed50ae>] ieee80211_open+0x20e/0x490
[mac80211]
Sep 19 08:01:42 better kernel:  [<c02518bf>] find_lock_page+0x1f/0xf0
Sep 19 08:01:42 better kernel:  [<c03adda3>] dev_open+0x33/0x80
Sep 19 08:01:42 better kernel:  [<c03ac122>] dev_change_flags+0x82/0x1b0
Sep 19 08:01:42 better kernel:  [<c03eebb1>] devinet_ioctl+0x521/0x6c0
Sep 19 08:01:42 better kernel:  [<c025d629>] __do_fault+0x189/0x370
Sep 19 08:01:42 better kernel:  [<c03ab9bf>] __dev_get_by_name+0x6f/0x90
Sep 19 08:01:42 better kernel:  [<c03a073f>] sock_ioctl+0xbf/0x230
Sep 19 08:01:42 better kernel:  [<c03a0680>] sock_ioctl+0x0/0x230
Sep 19 08:01:42 better kernel:  [<c027e08b>] do_ioctl+0x2b/0x90
Sep 19 08:01:42 better kernel:  [<c027e14c>] vfs_ioctl+0x5c/0x290
Sep 19 08:01:42 better kernel:  [<c027e3f2>] sys_ioctl+0x72/0x90
Sep 19 08:01:42 better kernel:  [<c020413e>] sysenter_past_esp+0x5f/0x85
Sep 19 08:01:42 better kernel:  [<c0410000>] packet_rcv_spkt+0x80/0x1b0
Sep 19 08:01:42 better kernel:  =======================
Sep 19 08:01:42 better kernel: Code:  Bad EIP value.
Sep 19 08:01:42 better kernel: EIP: [<5205fea9>] 0x5205fea9 SS:ESP
0068:f7a45dd4

Suspend to RAM aborts with the following:

Sep 19 07:59:10 better kernel: Stopping tasks ... done.
Sep 19 07:59:10 better kernel: Suspending console(s)
Sep 19 07:59:10 better kernel: phy0 -> rt2x00rfkill_toggle_radio: Info -
Hardware button pressed, disabling radio.
Sep 19 07:59:10 better kernel: ACPI handle has no context!
Sep 19 07:59:10 better kernel: phy0 -> rt2x00lib_suspend: Notice - Going to
sleep.
Sep 19 07:59:10 better kernel: phy0 -> rt2x00rfkill_toggle_radio: Info -
Hardware button pressed, disabling radio.
Sep 19 07:59:10 better kernel: phy0 -> rt2500pci_set_state: Notice - Device
failed to enter state 1, current device state: bbp 3 and rf 3.
Sep 19 07:59:10 better kernel: pci_device_suspend():
rt2x00pci_suspend+0x0/0x70 [rt2x00pci]() returns -16
Sep 19 07:59:10 better kernel: suspend_device(): pci_device_suspend+0x0/0x6
() returns -16
Sep 19 07:59:10 better kernel: Could not suspend device 0000:08:02.0:
error -16

Marcus


