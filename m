Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from static-ip-62-75-166-246.inaddr.intergenia.de ([62.75.166.246]:41052
	"EHLO vs166246.vserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755913AbXJMP1K (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 13 Oct 2007 11:27:10 -0400
From: Michael Buesch <mb@bu3sch.de>
To: bcm43xx-dev@lists.berlios.de
Subject: Re: b43 with upstream-davem stacktrace
Date: Sat, 13 Oct 2007 17:26:14 +0200
Cc: Christian Hoffmann <email@christianhoffmann.info>,
	linux-wireless@vger.kernel.org
References: <200710131823.33420.email@christianhoffmann.info>
In-Reply-To: <200710131823.33420.email@christianhoffmann.info>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Message-Id: <200710131726.14289.mb@bu3sch.de> (sfid-20071013_162714_205094_D26CE64D)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Saturday 13 October 2007 18:23:33 Christian Hoffmann wrote:
> Hi all,
> 
> I tried (I think) latest b43 driver on a bcm4318. It works quite well, but on 
> a series of connect/reconnect I had attached stack in dmesg.
> 
> Any idea?
> 
> Chris
> 
> FYI (normal dmesg output)
> b43-phy0: Broadcom 4318 WLAN found
> b43-phy0 debug: Found PHY: Analog 3, Type 2, Revision 7
> b43-phy0 debug: Found Radio: Manuf 0x17F, Version 0x2050, Revision 8
> b43-phy0 debug: Loading firmware version 351.126 (2006-07-29 05:54:02)
> Registered led device: b43-phy0:tx
> Registered led device: b43-phy0:rx
> b43-phy0 debug: Chip initialized
> b43-phy0 debug: 32-bit DMA initialized
> b43-phy0 debug: Wireless interface started
> b43-phy0 debug: Adding Interface type 2
> 

I also saw this sometimes, but I have absolutely no idea how that happens.
Someone any idea?


> b43-phy0 debug: Loading firmware version 351.126 (2006-07-29 05:54:02)
> Registered led device: b43-phy0:tx
> Registered led device: b43-phy0:rx
> general protection fault: 0000 [1] SMP
> CPU 0
> Modules linked in: eeprom ircomm_tty ircomm af_packet snd_pcm_oss
> snd_mixer_oss snd_seq snd_seq_device radeon drm cpufreq_conservative
> cpufreq_userspace cpufreq _powersave powernow_k8 pcmcia snd_atiixp_modem
> arc4 snd_atiixp ecb blkcipher rc8 0211_simple snd_ac97_codec yenta_socket
> ac97_bus snd_pcm rsrc_nonstatic snd_time r snd pcmcia_core b43
> firmware_class parport_pc ohci1394 ide_cd ssb rfkill mac80 211 rtc_cmos
> irda crc_ccitt rtc_core k8temp rtc_lib cfg80211 led_class tifm_7xx1 output
> battery ac parport ieee1394 button cdrom tifm_core container soundcore s
> nd_page_alloc tg3 hwmon joydev input_polldev i2c_piix4 serio_raw ide_disk
> ehci_h cd ohci_hcd usbcore radeonfb fb_ddc i2c_algo_bit i2c_core edd ext3
> mbcache jbd f an atiixp ide_core thermal processor
> Pid: 2295, comm: NetworkManager Not tainted 2.6.23-rc9-default #1
> RIP: 0010:[<ffffffff802f38aa>]  [<ffffffff802f38aa>] strcmp+0x0/0x1a
> RSP: 0018:ffff810078fe5740  EFLAGS: 00010283
> RAX: ffff81007d1f5f70 RBX: ffff81007d1f5f40 RCX: ffffffff80418988
> RDX: ffffffff881ed3d0 RSI: ffffffff8048498b RDI: 66355f306e616c77
> RBP: ffff81007da723a8 R08: 0000000000000000 R09: 0000000000000000
> R10: ffffffff881ed3a0 R11: ffffffff803921b5 R12: ffff81007da72000
> R13: 0000000000000001 R14: 0000000000000000 R15: 66355f306e616c77
> FS:  0000000040800950(0063) GS:ffffffff804fc000(0000)
> knlGS:0000000000000000 CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> CR2: 0000000000616278 CR3: 0000000079556000 CR4: 00000000000006e0
> DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
> DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
> Process NetworkManager (pid: 2295, threadinfo ffff810078fe4000, task
> ffff810079f be040)
> Stack:  ffffffff803861f8 ffff81007da723a8 ffff81007da723a8 0000000000000000
>  ffffffff881ec218 ffff81007da72000 ffff81007da7240a ffff81007da723a0
>  ffffffff882da4ba ffff810078fe57f8 0000000000000000 ffff81007d5802e0
> Call Trace:
>  [<ffffffff803861f8>] led_trigger_set_default+0x3a/0x77
>  [<ffffffff881ec218>] :led_class:led_classdev_register+0xb9/0x10d
>  [<ffffffff882da4ba>] :b43:b43_register_led+0x83/0xb6
>  [<ffffffff882da750>] :b43:b43_leds_init+0x263/0x293
>  [<ffffffff8828501d>] :ssb:ssb_pci_switch_core+0x40/0x4b
>  [<ffffffff882cae47>] :b43:b43_chip_init+0x56c/0x8d6
>  [<ffffffff882cb435>] :b43:b43_wireless_core_init+0x284/0x766
>  [<ffffffff882cc585>] :b43:b43_start+0x2e/0x6d
>  [<ffffffff8824d8e9>] :mac80211:ieee80211_open+0x1b6/0x39d
>  [<ffffffff8039704a>] dev_open+0x2f/0x67
>  [<ffffffff80395c8a>] dev_change_flags+0xaa/0x161
>  [<ffffffff8039db81>] do_setlink+0x279/0x34b
>  [<ffffffff8039e60b>] rtnetlink_rcv_msg+0x0/0x1dc
>  [<ffffffff8039edcf>] rtnl_setlink+0xf5/0x116
>  [<ffffffff803ab484>] netlink_run_queue+0x68/0xf7
>  [<ffffffff8039e587>] rtnetlink_rcv+0x28/0x43
>  [<ffffffff803aba04>] netlink_data_ready+0x12/0x50
>  [<ffffffff803aa6fa>] netlink_sendskb+0x23/0x3c
>  [<ffffffff803ab9df>] netlink_sendmsg+0x2ac/0x2bf
>  [<ffffffff80391845>] memcpy_fromiovec+0x36/0x66
>  [<ffffffff8038a98c>] sock_sendmsg+0xea/0x107
>  [<ffffffff8024699f>] autoremove_wake_function+0x0/0x2e
>  [<ffffffff8024699f>] autoremove_wake_function+0x0/0x2e
>  [<ffffffff8024699f>] autoremove_wake_function+0x0/0x2e
>  [<ffffffff8038abc0>] sys_sendmsg+0x217/0x28a
>  [<ffffffff803aa9b8>] netlink_insert+0x13c/0x14b
>  [<ffffffff8038bb35>] sys_getsockname+0x9c/0xb2
>  [<ffffffff8020bc8e>] system_call+0x7e/0x83
>
>
> Code: 8a 17 88 d0 2a 06 48 ff c6 84 c0 75 09 84 d2 74 05 48 ff c7
> RIP  [<ffffffff802f38aa>] strcmp+0x0/0x1a
>  RSP <ffff810078fe5740>
> (none):~ #

-- 
Greetings Michael.
