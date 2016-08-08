Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mo4-p00-ob.smtp.rzone.de ([81.169.146.220]:56694 "EHLO
	mo4-p00-ob.smtp.rzone.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752345AbcHHV34 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 8 Aug 2016 17:29:56 -0400
From: "H. Nikolaus Schaller" <hns@goldelico.com>
Content-Type: text/plain; charset=us-ascii
Subject: [BUG] 4.8-rc1: wlcore: NULL pointer dereference in wlcore_op_get_expected_throughput
Date: Mon, 8 Aug 2016 23:26:38 +0200
Message-Id: <4FEB5780-826B-49C3-81E9-D361CD12DD4A@goldelico.com> (sfid-20160808_232959_664351_C51374E0)
Cc: LKML <linux-kernel@vger.kernel.org>,
	Discussions about the Letux Kernel
	<letux-kernel@openphoenux.org>
To: linux-wireless@vger.kernel.org
Mime-Version: 1.0 (Mac OS X Mail 9.3 \(3124\))
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Here is what I see in 4.8-rc1 on Pyra device after typing "poweroff".
I hope someone knows what it means.

BR and thanks,
Nikolaus

root@letux:~# poweroff

Broadcast message from root@letux (pts/0) (Mon Aug  8 21:19:21 2016):

The system is going down for system halt NOW!

xinit: unexpected signal 15
[info] Using makefile-style concurrent boot in runlevel 0.
[....] Stopping ISC DHCP server: dhcpd failed!
[....] Stopping bluetooth: /usr/sbin/bluetoothd. ok 
[....] Stopping automount.... ok 
[....] Not running dhcpcd because /etc/network/interfaces ... failed!
[....] defines some interfaces that will use a DHCP client ... failed!
[....] Shutting down ALSA...done.
[....] Asking all remaining processes to terminate...done.
[....] All processes ended within 1 seconds...done.
[....] Stopping enhanced syslogd: rsyslogd. ok 
[....] Deconfiguring network interfaces...SIOCDELRT: No such process
Device "usb0" does not exist.
Cannot find device "usb0"
done.
[info] Saving the system clock.
[info] Hardware Clock updated to Mon Aug  8 21:19:30 UTC 2016.
[....] Unmounting temporary filesystems...done.
[....] Deactivating swap...done.
[....] Unmounting local filesystems...done.
[  613.196751] EXT4-fs (mmcblk1p2): re-mounted. Opts: (null)
[info] Will now halt.
[  615.348870] wlan0: deauthenticating from 00:12:bf:7d:ce:e6 by local choice (Reason: 3=DEAUTH_LEAVING)
[  615.589721] Unable to handle kernel NULL pointer dereference at virtual address 00000a2a
[  615.598249] pgd = ec3a4000
[  615.601220] [00000a2a] *pgd=ab60f835, *pte=00000000, *ppte=00000000
[  615.607868] Internal error: Oops: 17 [#1] PREEMPT SMP ARM
[  615.613551] Modules linked in: hci_uart bnep bluetooth autofs4 usb_f_ecm usb_f_rndis u_ether libcomposite configfs ipv6 cdc_ether usbnet cdc_acm arc4 wl18xx wlcore mac80211 omapdrm cfg80211 drm_kms_helper cfbfillrect syscopyarea cfbimgblt sysfillrect sysimgblt fb_sys_fops cfbcopyarea snd_soc_omap_hdmi_audio panel_mipi_debug drm dwc3 connector_hdmi encoder_tpd12s015 w2cbw003_bluetooth snd_soc_omap_abe_twl6040 snd_soc_twl6040 wwan_on_off leds_gpio omapdss pwm_omap_dmtimer pwm_bl ehci_omap wlcore_sdio dwc3_omap leds_is31fl319x snd_soc_ts3a225e gpio_twl6040 bq27xxx_battery_i2c tsc2007 bq27xxx_battery leds_tca6507 crtouch_mt bq2429x_charger twl6040_vibra ina2xx palmas_pwrbutton palmas_gpadc as5013 tca8418_keypad usb3503 bma150 bmg160_i2c bno055 bmg160_core input_polldev snd_soc_omap_mcpdm snd_soc_omap_mcbsp snd_soc_omap snd_pcm_dmaengine [last unloaded: g_ether]
[  615.694303] CPU: 0 PID: 3788 Comm: halt Tainted: G    B   W       4.8.0-rc1-letux+ #655
[  615.702727] Hardware name: Generic OMAP5 (Flattened Device Tree)
[  615.709052] task: eb2564c0 task.stack: ec456000
[  615.713913] PC is at wlcore_op_get_expected_throughput+0x14/0x20 [wlcore]
[  615.721357] LR is at sta_set_sinfo+0xc18/0x1110 [mac80211]
[  615.727145] pc : [<bf4de050>]    lr : [<bf40cf20>]    psr: a00f0013
[  615.727145] sp : ec457c48  ip : 00000000  fp : 400f0013
[  615.739237] r10: ec414620  r9 : eb604b30  r8 : eb604c90
[  615.744735] r7 : c0b02554  r6 : bf4815c4  r5 : bf4de03c  r4 : ec823400
[  615.751613] r3 : 00000000  r2 : 00000000  r1 : 000000c8  r0 : 000003e8
[  615.758492] Flags: NzCv  IRQs on  FIQs on  Mode SVC_32  ISA ARM  Segment none
[  615.766008] Control: 10c5387d  Table: ac3a406a  DAC: 00000051
[  615.772062] Process halt (pid: 3788, stack limit = 0xec456218)
[  615.778208] Stack: (0xec457c48 to 0xec458000)
[  615.782806] 7c40:                   00000001 00000000 bf40d540 c0a76630 eb604f3c bf40d540
[  615.791434] 7c60: ec414620 00000000 00000000 eb604a8c eb604c90 00000000 00000001 eb604800
[  615.800049] 7c80: ec823400 ec45a600 ec45a600 ec414b2c 00000001 ec414b94 00000000 bf40d540
[  615.808682] 7ca0: 00000000 00000003 ec457cb0 ec414b94 ec457cb8 bf40d75c eb604808 eb604808
[  615.817308] 7cc0: 00000000 ec45a600 00000000 ec414620 ec45ac50 ec457d1e 000000c0 00000003
[  615.825940] 7ce0: ffffffff bf4629e8 00000001 ec457d1e ec45a600 ec457d60 ec457d1e 00000001
[  615.834563] 7d00: bf38707c bf386c94 00000003 bf4680cc ec457d1e 00000000 ec45a67c 00c00000
[  615.843178] 7d20: 12000000 e6ce7dbf efbeadde 12000000 e6ce7dbf 00030000 00000001 ec892bd4
[  615.851801] 7d40: ec45a000 c0b02554 ec4142a0 bf38707c bf386c94 00000003 ffffffff bf352b58
[  615.860428] 7d60: ec892bd4 00000000 00000000 00000003 ec45a648 ec45a608 ec414000 ec414000
[  615.869051] 7d80: ec414000 ec45a000 00000003 bf3590c0 00000000 00000003 00000000 ec45a000
[  615.877674] 7da0: ec414000 ec45a648 ec45a608 ec414000 ec414000 00000009 ec96cc0c 00000000
[  615.886300] 7dc0: ffffffff bf31cba8 ec45a608 ec4142a0 ec45a000 bf31cd70 00000000 00000000
[  615.894918] 7de0: c06d0594 c06da874 c0b98444 fffffff7 00000000 00000009 ec457e3c bf47bb38
[  615.903540] 7e00: ec96cc0c 00000000 ffffffff c0152df8 ec45a000 ec457e58 00001042 00001003
[  615.912162] 7e20: 00000000 c0152e40 00000000 00000009 ec457e3c c0620eb4 00000009 ec45a000
[  615.920786] 7e40: c062b690 c0620fd0 ec45a04c ec45a000 00000001 c0621134 ec45a04c ec45a04c
[  615.929410] 7e60: c062b690 c062b97c ec45a000 00001003 ec45a150 ec45a000 00000000 c062ba38
[  615.938027] 7e80: ec8f7600 00000000 ec96cc00 ec45a000 00000000 c0697f8c 00000000 beabc47c
[  615.946652] 7ea0: 00000020 00000000 6e616c77 00000030 00000000 00000000 00001042 8202a8c0
[  615.955275] 7ec0: 00000000 00000000 00000000 00008914 ed5014a0 beabc47c c0b90c80 ed501480
[  615.963900] 7ee0: 00000003 00000000 00000001 c0609a30 beabc47c ed5014a0 eb34b140 c026560c
[  615.972524] 7f00: 00000003 c0264ac4 0000c000 c02654a4 600f0013 c135c654 c08a43f4 eb2dccb4
[  615.981145] 7f20: ec456000 00000000 00000003 eb34b140 ec456000 00000000 00000001 c0271cd8
[  615.989769] 7f40: 00000000 00000000 c0271a44 c0255308 c0b03bc0 00000000 ed501480 c0609684
[  615.998389] 7f60: ed813710 00000000 eb34b140 eb34b140 beabc47c 00008914 00000003 00000000
[  616.007012] 7f80: 00000001 c026560c 00001042 beabc47c 00000000 beabc49c 00000036 c0107204
[  616.015636] 7fa0: ec456000 c0107060 beabc47c 00000000 00000003 00008914 beabc47c 00001042
[  616.024253] 7fc0: beabc47c 00000000 beabc49c 00000036 000230f0 00023100 00000003 00000001
[  616.032875] 7fe0: 00023054 beabc44c 0001135b b6e83206 a00f0030 00000003 00000000 00000000
[  616.041894] [<bf4de050>] (wlcore_op_get_expected_throughput [wlcore]) from [<bf40cf20>] (sta_set_sinfo+0xc18/0x1110 [mac80211])
[  616.054542] [<bf40cf20>] (sta_set_sinfo [mac80211]) from [<bf40d540>] (__sta_info_destroy_part2+0x128/0x194 [mac80211])
[  616.066426] [<bf40d540>] (__sta_info_destroy_part2 [mac80211]) from [<bf40d75c>] (__sta_info_flush+0xf8/0x13c [mac80211])
[  616.078513] [<bf40d75c>] (__sta_info_flush [mac80211]) from [<bf4629e8>] (ieee80211_set_disassoc+0x168/0x2f8 [mac80211])
[  616.090512] [<bf4629e8>] (ieee80211_set_disassoc [mac80211]) from [<bf4680cc>] (ieee80211_mgd_deauth+0x3dc/0x9fc [mac80211])
[  616.102861] [<bf4680cc>] (ieee80211_mgd_deauth [mac80211]) from [<bf352b58>] (cfg80211_mlme_deauth+0x1f4/0x458 [cfg80211])
[  616.114978] [<bf352b58>] (cfg80211_mlme_deauth [cfg80211]) from [<bf3590c0>] (cfg80211_disconnect+0xa0/0x4a4 [cfg80211])
[  616.126880] [<bf3590c0>] (cfg80211_disconnect [cfg80211]) from [<bf31cba8>] (cfg80211_leave+0x28/0x34 [cfg80211])
[  616.138137] [<bf31cba8>] (cfg80211_leave [cfg80211]) from [<bf31cd70>] (cfg80211_netdev_notifier_call+0x1bc/0x84c [cfg80211])
[  616.150287] [<bf31cd70>] (cfg80211_netdev_notifier_call [cfg80211]) from [<c0152df8>] (notifier_call_chain+0x40/0x68)
[  616.161479] [<c0152df8>] (notifier_call_chain) from [<c0152e40>] (raw_notifier_call_chain+0x14/0x1c)
[  616.171111] [<c0152e40>] (raw_notifier_call_chain) from [<c0620eb4>] (call_netdevice_notifiers+0xc/0x14)
[  616.181108] [<c0620eb4>] (call_netdevice_notifiers) from [<c0620fd0>] (__dev_close_many+0x48/0xb8)
[  616.190551] [<c0620fd0>] (__dev_close_many) from [<c0621134>] (__dev_close+0x20/0x34)
[  616.198806] [<c0621134>] (__dev_close) from [<c062b97c>] (__dev_change_flags+0x8c/0x130)
[  616.207347] [<c062b97c>] (__dev_change_flags) from [<c062ba38>] (dev_change_flags+0x18/0x48)
[  616.216255] [<c062ba38>] (dev_change_flags) from [<c0697f8c>] (devinet_ioctl+0x338/0x704)
[  616.224883] [<c0697f8c>] (devinet_ioctl) from [<c0609a30>] (sock_ioctl+0x288/0x2d8)
[  616.232959] [<c0609a30>] (sock_ioctl) from [<c0264ac4>] (vfs_ioctl+0x20/0x34)
[  616.240482] [<c0264ac4>] (vfs_ioctl) from [<c02654a4>] (do_vfs_ioctl+0x854/0x970)
[  616.248369] [<c02654a4>] (do_vfs_ioctl) from [<c026560c>] (SyS_ioctl+0x4c/0x74)
[  616.256078] [<c026560c>] (SyS_ioctl) from [<c0107060>] (ret_fast_syscall+0x0/0x1c)
[  616.264075] Code: e3a010c8 e5d02098 e3a00ffa e0233291 (e5d33a2a) 
[  616.272268] ---[ end trace 00ab29170ed628ed ]---
Segmentation fault
[....] startpar: service(s) skipped, program is not configured: dhcpcd ... (warning).
INIT: no more processes left in this runlevel

