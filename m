Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from relay2.web4ce.cz ([93.190.48.82]:60462 "EHLO relay2.web4ce.cz"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751093Ab2LOTeG (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sat, 15 Dec 2012 14:34:06 -0500
Received: from [81.0.202.202] (msrv3.web4ce.cz [93.190.49.98])
	by relay2.web4ce.cz (Postfix) with ESMTP id 4030B221640
	for <linux-wireless@vger.kernel.org>; Sat, 15 Dec 2012 20:28:10 +0100 (CET)
Message-ID: <50CCCF49.7040108@berycz.net> (sfid-20121215_203414_159427_09044913)
Date: Sat, 15 Dec 2012 20:28:09 +0100
From: Martin Beran <info@berycz.net>
MIME-Version: 1.0
To: linux-wireless@vger.kernel.org
Subject: bugreport atheros ar8162
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hello,
I just installed debian (testing) on my new laptop and I cannot join wifi... I asked on freenode.net #linux-wireless and 
was refered to post bug here.
I'm really a noob, but I will try to help with testing or anything, if you want.

Lenovo IdeaPad G780
Linux my-name 3.2.0-4-amd64 #1 SMP Debian 3.2.32-1 x86_64 GNU/Linux
installed all compat-wireless-2012-12-14-p.tar.bz2

03:00.0 Network controller: Broadcom Corporation BCM4313 802.11b/g/n Wireless LAN Controller (rev 01)
     Subsystem: Broadcom Corporation Device 0587
     Flags: bus master, fast devsel, latency 0, IRQ 17
     Memory at d3800000 (64-bit, non-prefetchable) [size=16K]
     Capabilities: <access denied>
     Kernel driver in use: bcma-pci-bridge

dmesg: (sorry for the all dmesg, but I have no idea what's important)
f/0x28
[   25.087977]  [<ffffffff812ad78e>] ? netlink_unicast+0xe6/0x14e
[   25.087979]  [<ffffffff812ada6a>] ? netlink_sendmsg+0x274/0x2ac
[   25.087981]  [<ffffffff8127d181>] ? sock_sendmsg+0xc1/0xde
[   25.087983]  [<ffffffff8127d060>] ? sock_recvmsg+0xcd/0xec
[   25.087985]  [<ffffffff8127d181>] ? sock_sendmsg+0xc1/0xde
[   25.087987]  [<ffffffff810f1edd>] ? mem_cgroup_update_page_stat+0x17/0xd4
[   25.087989]  [<ffffffff8134b7ff>] ? _cond_resched+0x7/0x1c
[   25.087991]  [<ffffffff810363d8>] ? should_resched+0x5/0x23
[   25.087993]  [<ffffffff8134b7ff>] ? _cond_resched+0x7/0x1c
[   25.087995]  [<ffffffff812864d8>] ? copy_from_user+0x18/0x30
[   25.087996]  [<ffffffff810363d8>] ? should_resched+0x5/0x23
[   25.087998]  [<ffffffff8127d416>] ? __sys_sendmsg+0x1e8/0x288
[   25.088000]  [<ffffffff810cdb5d>] ? pte_offset_kernel+0x16/0x35
[   25.088002]  [<ffffffff810fadc7>] ? fget_light+0x5f/0x73
[   25.088004]  [<ffffffff8127ea24>] ? sys_sendto+0x108/0x137
[   25.088006]  [<ffffffff811099f1>] ? dput+0xe2/0xee
[   25.088008]  [<ffffffff810fadc7>] ? fget_light+0x5f/0x73
[   25.088010]  [<ffffffff8127ed49>] ? sys_sendmsg+0x39/0x58
[   25.088012]  [<ffffffff81351ad2>] ? system_call_fastpath+0x16/0x1b
[   25.088557] BUG: scheduling while atomic: NetworkManager/2660/0x00000200
[   25.088606] Modules linked in: lp(+) parport rfcomm(O) bnep(O) binfmt_misc uinput nfsd nfs nfs_acl auth_rpcgss 
fscache lockd sunrpc loop b43(O) arc4 ssb(O) mmc_core rng_core pcmcia pcmcia_core brcmsmac(O) cordic brcmutil(O) 
mac80211(O) btusb(O) cfg80211(O) bluetooth(O) uvcvideo videodev rts5139(C) v4l2_compat_ioctl32 joydev media 
snd_hda_codec_hdmi acpi_cpufreq snd_hda_codec_conexant mperf coretemp processor i2c_algo_bit ideapad_laptop iTCO_wdt 
iTCO_vendor_support bcma(O) battery snd_hda_intel snd_hda_codec psmouse ac snd_hwdep power_supply serio_raw snd_pcm 
sparse_keymap i2c_i801 evdev pcspkr video button i2c_core rfkill snd_page_alloc snd_seq snd_seq_device snd_timer snd 
compat(O) crc32c_intel ghash_clmulni_intel soundcore aesni_intel aes_x86_64 aes_generic cryptd ext4 crc16 jbd2 mbcache 
usbhid hid sg sr_mod cdrom sd_mod crc_t10dif ehci_hcd ahci libahci libata scsi_mod xhci_hcd usbcore usb_common thermal 
thermal_sys [last unloaded: scsi_wait_scan]
[   25.088638] Pid: 2660, comm: NetworkManager Tainted: G         C O 3.2.0-4-amd64 #1 Debian 3.2.32-1
[   25.088639] Call Trace:
[   25.088641]  [<ffffffff81346112>] ? __schedule_bug+0x3e/0x52
[   25.088643]  [<ffffffff8134b27d>] ? __schedule+0x85/0x5c3
[   25.088645]  [<ffffffff8134c399>] ? schedule_hrtimeout_range_clock+0xc0/0x103
[   25.088647]  [<ffffffff81061d7e>] ? update_rmtp+0x62/0x62
[   25.088649]  [<ffffffff810625af>] ? hrtimer_start_expires+0x13/0x15
[   25.088651]  [<ffffffff810519b2>] ? usleep_range+0x39/0x3e
[   25.088655]  [<ffffffffa0482a6d>] ? wlc_lcnphy_rx_iq_cal.constprop.10+0x576/0x9b8 [brcmsmac]
[   25.088660]  [<ffffffffa0483a52>] ? wlc_lcnphy_periodic_cal+0xc0/0x1ae [brcmsmac]
[   25.088663]  [<ffffffffa028fd43>] ? bcma_host_pci_write16+0x11/0x2a [bcma]
[   25.088667]  [<ffffffffa048565f>] ? wlc_phy_init_lcnphy+0xf88/0xf97 [brcmsmac]
[   25.088671]  [<ffffffffa04846d7>] ? wlc_phy_txpower_recalc_target_lcnphy+0x5a/0x5a [brcmsmac]
[   25.088675]  [<ffffffffa047d596>] ? wlc_phy_init+0xe6/0x137 [brcmsmac]
[   25.088679]  [<ffffffffa0473908>] ? brcms_b_bsinit.isra.58+0x120/0x248 [brcmsmac]
[   25.088684]  [<ffffffffa047830c>] ? brcms_c_init+0x83d/0xc41 [brcmsmac]
[   25.088688]  [<ffffffffa0476da3>] ? brcms_c_up+0x26e/0x37e [brcmsmac]
[   25.088692]  [<ffffffffa046f972>] ? brcms_ops_start+0x73/0xb3 [brcmsmac]
[   25.088697]  [<ffffffffa041f4fd>] ? ieee80211_do_open+0x11e/0x5de [mac80211]
[   25.088699]  [<ffffffff8128f6a2>] ? __dev_open+0x8b/0xcc
[   25.088701]  [<ffffffff8128f8ad>] ? __dev_change_flags+0x9d/0x118
[   25.088703]  [<ffffffff8128f98b>] ? dev_change_flags+0x12/0x42
[   25.088705]  [<ffffffff8129966d>] ? do_setlink+0x2ac/0x74d
[   25.088707]  [<ffffffff8129a517>] ? rtnl_newlink+0x24e/0x467
[   25.088709]  [<ffffffff8129a375>] ? rtnl_newlink+0xac/0x467
[   25.088711]  [<ffffffff810eb80e>] ? kmem_cache_alloc_node_trace+0x96/0x10a
[   25.088713]  [<ffffffff8134bfe0>] ? mutex_lock+0xd/0x2d
[   25.088715]  [<ffffffff810709c1>] ? arch_local_irq_save+0x11/0x17
[   25.088717]  [<ffffffff81299e00>] ? rtnl_dellink+0x87/0x10a
[   25.088718]  [<ffffffff81299e8f>] ? __rtnl_unlock+0xc/0xc
[   25.088720]  [<ffffffff812adc57>] ? netlink_rcv_skb+0x36/0x7a
[   25.088722]  [<ffffffff8129927d>] ? rtnetlink_rcv+0x1f/0x28
[   25.088724]  [<ffffffff812ad78e>] ? netlink_unicast+0xe6/0x14e
[   25.088726]  [<ffffffff812ada6a>] ? netlink_sendmsg+0x274/0x2ac
[   25.088728]  [<ffffffff8127d181>] ? sock_sendmsg+0xc1/0xde
[   25.088730]  [<ffffffff8127d060>] ? sock_recvmsg+0xcd/0xec
[   25.088732]  [<ffffffff8127d181>] ? sock_sendmsg+0xc1/0xde
[   25.088734]  [<ffffffff810f1edd>] ? mem_cgroup_update_page_stat+0x17/0xd4
[   25.088737]  [<ffffffff8134b7ff>] ? _cond_resched+0x7/0x1c
[   25.088738]  [<ffffffff810363d8>] ? should_resched+0x5/0x23
[   25.088740]  [<ffffffff8134b7ff>] ? _cond_resched+0x7/0x1c
[   25.088742]  [<ffffffff812864d8>] ? copy_from_user+0x18/0x30
[   25.088744]  [<ffffffff810363d8>] ? should_resched+0x5/0x23
[   25.088746]  [<ffffffff8127d416>] ? __sys_sendmsg+0x1e8/0x288
[   25.088748]  [<ffffffff810cdb5d>] ? pte_offset_kernel+0x16/0x35
[   25.088750]  [<ffffffff810fadc7>] ? fget_light+0x5f/0x73
[   25.088752]  [<ffffffff8127ea24>] ? sys_sendto+0x108/0x137
[   25.088753]  [<ffffffff811099f1>] ? dput+0xe2/0xee
[   25.088755]  [<ffffffff810fadc7>] ? fget_light+0x5f/0x73
[   25.088757]  [<ffffffff8127ed49>] ? sys_sendmsg+0x39/0x58
[   25.088760]  [<ffffffff81351ad2>] ? system_call_fastpath+0x16/0x1b
[   25.089367] BUG: scheduling while atomic: NetworkManager/2660/0x00000200
[   25.089417] Modules linked in: lp(+) parport rfcomm(O) bnep(O) binfmt_misc uinput nfsd nfs nfs_acl auth_rpcgss 
fscache lockd sunrpc loop b43(O) arc4 ssb(O) mmc_core rng_core pcmcia pcmcia_core brcmsmac(O) cordic brcmutil(O) 
mac80211(O) btusb(O) cfg80211(O) bluetooth(O) uvcvideo videodev rts5139(C) v4l2_compat_ioctl32 joydev media 
snd_hda_codec_hdmi acpi_cpufreq snd_hda_codec_conexant mperf coretemp processor i2c_algo_bit ideapad_laptop iTCO_wdt 
iTCO_vendor_support bcma(O) battery snd_hda_intel snd_hda_codec psmouse ac snd_hwdep power_supply serio_raw snd_pcm 
sparse_keymap i2c_i801 evdev pcspkr video button i2c_core rfkill snd_page_alloc snd_seq snd_seq_device snd_timer snd 
compat(O) crc32c_intel ghash_clmulni_intel soundcore aesni_intel aes_x86_64 aes_generic cryptd ext4 crc16 jbd2 mbcache 
usbhid hid sg sr_mod cdrom sd_mod crc_t10dif ehci_hcd ahci libahci libata scsi_mod xhci_hcd usbcore usb_common thermal 
thermal_sys [last unloaded: scsi_wait_scan]
[   25.089518] Pid: 2660, comm: NetworkManager Tainted: G         C O 3.2.0-4-amd64 #1 Debian 3.2.32-1
[   25.089520] Call Trace:
[   25.089523]  [<ffffffff81346112>] ? __schedule_bug+0x3e/0x52
[   25.089526]  [<ffffffff8134b27d>] ? __schedule+0x85/0x5c3
[   25.089529]  [<ffffffff8134c399>] ? schedule_hrtimeout_range_clock+0xc0/0x103
[   25.089533]  [<ffffffff81061d7e>] ? update_rmtp+0x62/0x62
[   25.089536]  [<ffffffff810625af>] ? hrtimer_start_expires+0x13/0x15
[   25.089539]  [<ffffffff810519b2>] ? usleep_range+0x39/0x3e
[   25.089545]  [<ffffffffa0482a25>] ? wlc_lcnphy_rx_iq_cal.constprop.10+0x52e/0x9b8 [brcmsmac]
[   25.089550]  [<ffffffffa0483a52>] ? wlc_lcnphy_periodic_cal+0xc0/0x1ae [brcmsmac]
[   25.089554]  [<ffffffffa028fd43>] ? bcma_host_pci_write16+0x11/0x2a [bcma]
[   25.089560]  [<ffffffffa048565f>] ? wlc_phy_init_lcnphy+0xf88/0xf97 [brcmsmac]
[   25.089565]  [<ffffffffa04846d7>] ? wlc_phy_txpower_recalc_target_lcnphy+0x5a/0x5a [brcmsmac]
[   25.089571]  [<ffffffffa047d596>] ? wlc_phy_init+0xe6/0x137 [brcmsmac]
[   25.089576]  [<ffffffffa0473908>] ? brcms_b_bsinit.isra.58+0x120/0x248 [brcmsmac]
[   25.089582]  [<ffffffffa047830c>] ? brcms_c_init+0x83d/0xc41 [brcmsmac]
[   25.089587]  [<ffffffffa0476da3>] ? brcms_c_up+0x26e/0x37e [brcmsmac]
[   25.089592]  [<ffffffffa046f972>] ? brcms_ops_start+0x73/0xb3 [brcmsmac]
[   25.089598]  [<ffffffffa041f4fd>] ? ieee80211_do_open+0x11e/0x5de [mac80211]
[   25.089602]  [<ffffffff8128f6a2>] ? __dev_open+0x8b/0xcc
[   25.089605]  [<ffffffff8128f8ad>] ? __dev_change_flags+0x9d/0x118
[   25.089608]  [<ffffffff8128f98b>] ? dev_change_flags+0x12/0x42
[   25.089611]  [<ffffffff8129966d>] ? do_setlink+0x2ac/0x74d
[   25.089614]  [<ffffffff8129a517>] ? rtnl_newlink+0x24e/0x467
[   25.089617]  [<ffffffff8129a375>] ? rtnl_newlink+0xac/0x467
[   25.089621]  [<ffffffff810eb80e>] ? kmem_cache_alloc_node_trace+0x96/0x10a
[   25.089624]  [<ffffffff8134bfe0>] ? mutex_lock+0xd/0x2d
[   25.089627]  [<ffffffff810709c1>] ? arch_local_irq_save+0x11/0x17
[   25.089630]  [<ffffffff81299e00>] ? rtnl_dellink+0x87/0x10a
[   25.089632]  [<ffffffff81299e8f>] ? __rtnl_unlock+0xc/0xc
[   25.089636]  [<ffffffff812adc57>] ? netlink_rcv_skb+0x36/0x7a
[   25.089638]  [<ffffffff8129927d>] ? rtnetlink_rcv+0x1f/0x28
[   25.089642]  [<ffffffff812ad78e>] ? netlink_unicast+0xe6/0x14e
[   25.089645]  [<ffffffff812ada6a>] ? netlink_sendmsg+0x274/0x2ac
[   25.089648]  [<ffffffff8127d181>] ? sock_sendmsg+0xc1/0xde
[   25.089651]  [<ffffffff8127d060>] ? sock_recvmsg+0xcd/0xec
[   25.089654]  [<ffffffff8127d181>] ? sock_sendmsg+0xc1/0xde
[   25.089658]  [<ffffffff810f1edd>] ? mem_cgroup_update_page_stat+0x17/0xd4
[   25.089661]  [<ffffffff8134b7ff>] ? _cond_resched+0x7/0x1c
[   25.089664]  [<ffffffff810363d8>] ? should_resched+0x5/0x23
[   25.089667]  [<ffffffff8134b7ff>] ? _cond_resched+0x7/0x1c
[   25.089670]  [<ffffffff812864d8>] ? copy_from_user+0x18/0x30
[   25.089673]  [<ffffffff810363d8>] ? should_resched+0x5/0x23
[   25.089676]  [<ffffffff8127d416>] ? __sys_sendmsg+0x1e8/0x288
[   25.089679]  [<ffffffff810cdb5d>] ? pte_offset_kernel+0x16/0x35
[   25.089682]  [<ffffffff810fadc7>] ? fget_light+0x5f/0x73
[   25.089685]  [<ffffffff8127ea24>] ? sys_sendto+0x108/0x137
[   25.089688]  [<ffffffff811099f1>] ? dput+0xe2/0xee
[   25.089691]  [<ffffffff810fadc7>] ? fget_light+0x5f/0x73
[   25.089694]  [<ffffffff8127ed49>] ? sys_sendmsg+0x39/0x58
[   25.089698]  [<ffffffff81351ad2>] ? system_call_fastpath+0x16/0x1b
[   25.090113] BUG: scheduling while atomic: NetworkManager/2660/0x00000200
[   25.090162] Modules linked in: lp(+) parport rfcomm(O) bnep(O) binfmt_misc uinput nfsd nfs nfs_acl auth_rpcgss 
fscache lockd sunrpc loop b43(O) arc4 ssb(O) mmc_core rng_core pcmcia pcmcia_core brcmsmac(O) cordic brcmutil(O) 
mac80211(O) btusb(O) cfg80211(O) bluetooth(O) uvcvideo videodev rts5139(C) v4l2_compat_ioctl32 joydev media 
snd_hda_codec_hdmi acpi_cpufreq snd_hda_codec_conexant mperf coretemp processor i2c_algo_bit ideapad_laptop iTCO_wdt 
iTCO_vendor_support bcma(O) battery snd_hda_intel snd_hda_codec psmouse ac snd_hwdep power_supply serio_raw snd_pcm 
sparse_keymap i2c_i801 evdev pcspkr video button i2c_core rfkill snd_page_alloc snd_seq snd_seq_device snd_timer snd 
compat(O) crc32c_intel ghash_clmulni_intel soundcore aesni_intel aes_x86_64 aes_generic cryptd ext4 crc16 jbd2 mbcache 
usbhid hid sg sr_mod cdrom sd_mod crc_t10dif ehci_hcd ahci libahci libata scsi_mod xhci_hcd usbcore usb_common thermal 
thermal_sys [last unloaded: scsi_wait_scan]
[   25.090250] Pid: 2660, comm: NetworkManager Tainted: G         C O 3.2.0-4-amd64 #1 Debian 3.2.32-1
[   25.090252] Call Trace:
[   25.090255]  [<ffffffff81346112>] ? __schedule_bug+0x3e/0x52
[   25.090258]  [<ffffffff8134b27d>] ? __schedule+0x85/0x5c3
[   25.090261]  [<ffffffff8134c399>] ? schedule_hrtimeout_range_clock+0xc0/0x103
[   25.090264]  [<ffffffff81061d7e>] ? update_rmtp+0x62/0x62
[   25.090267]  [<ffffffff810625af>] ? hrtimer_start_expires+0x13/0x15
[   25.090271]  [<ffffffff810519b2>] ? usleep_range+0x39/0x3e
[   25.090276]  [<ffffffffa0482a6d>] ? wlc_lcnphy_rx_iq_cal.constprop.10+0x576/0x9b8 [brcmsmac]
[   25.090282]  [<ffffffffa0483a52>] ? wlc_lcnphy_periodic_cal+0xc0/0x1ae [brcmsmac]
[   25.090286]  [<ffffffffa028fd43>] ? bcma_host_pci_write16+0x11/0x2a [bcma]
[   25.090292]  [<ffffffffa048565f>] ? wlc_phy_init_lcnphy+0xf88/0xf97 [brcmsmac]
[   25.090297]  [<ffffffffa04846d7>] ? wlc_phy_txpower_recalc_target_lcnphy+0x5a/0x5a [brcmsmac]
[   25.090303]  [<ffffffffa047d596>] ? wlc_phy_init+0xe6/0x137 [brcmsmac]
[   25.090308]  [<ffffffffa0473908>] ? brcms_b_bsinit.isra.58+0x120/0x248 [brcmsmac]
[   25.090314]  [<ffffffffa047830c>] ? brcms_c_init+0x83d/0xc41 [brcmsmac]
[   25.090320]  [<ffffffffa0476da3>] ? brcms_c_up+0x26e/0x37e [brcmsmac]
[   25.090324]  [<ffffffffa046f972>] ? brcms_ops_start+0x73/0xb3 [brcmsmac]
[   25.090331]  [<ffffffffa041f4fd>] ? ieee80211_do_open+0x11e/0x5de [mac80211]
[   25.090334]  [<ffffffff8128f6a2>] ? __dev_open+0x8b/0xcc
[   25.090337]  [<ffffffff8128f8ad>] ? __dev_change_flags+0x9d/0x118
[   25.090340]  [<ffffffff8128f98b>] ? dev_change_flags+0x12/0x42
[   25.090343]  [<ffffffff8129966d>] ? do_setlink+0x2ac/0x74d
[   25.090346]  [<ffffffff8129a517>] ? rtnl_newlink+0x24e/0x467
[   25.090349]  [<ffffffff8129a375>] ? rtnl_newlink+0xac/0x467
[   25.090353]  [<ffffffff810eb80e>] ? kmem_cache_alloc_node_trace+0x96/0x10a
[   25.090356]  [<ffffffff8134bfe0>] ? mutex_lock+0xd/0x2d
[   25.090359]  [<ffffffff810709c1>] ? arch_local_irq_save+0x11/0x17
[   25.090362]  [<ffffffff81299e00>] ? rtnl_dellink+0x87/0x10a
[   25.090365]  [<ffffffff81299e8f>] ? __rtnl_unlock+0xc/0xc
[   25.090368]  [<ffffffff812adc57>] ? netlink_rcv_skb+0x36/0x7a
[   25.090371]  [<ffffffff8129927d>] ? rtnetlink_rcv+0x1f/0x28
[   25.090374]  [<ffffffff812ad78e>] ? netlink_unicast+0xe6/0x14e
[   25.090377]  [<ffffffff812ada6a>] ? netlink_sendmsg+0x274/0x2ac
[   25.090381]  [<ffffffff8127d181>] ? sock_sendmsg+0xc1/0xde
[   25.090384]  [<ffffffff8127d060>] ? sock_recvmsg+0xcd/0xec
[   25.090387]  [<ffffffff8127d181>] ? sock_sendmsg+0xc1/0xde
[   25.090390]  [<ffffffff810f1edd>] ? mem_cgroup_update_page_stat+0x17/0xd4
[   25.090393]  [<ffffffff8134b7ff>] ? _cond_resched+0x7/0x1c
[   25.090396]  [<ffffffff810363d8>] ? should_resched+0x5/0x23
[   25.090399]  [<ffffffff8134b7ff>] ? _cond_resched+0x7/0x1c
[   25.090402]  [<ffffffff812864d8>] ? copy_from_user+0x18/0x30
[   25.090405]  [<ffffffff810363d8>] ? should_resched+0x5/0x23
[   25.090408]  [<ffffffff8127d416>] ? __sys_sendmsg+0x1e8/0x288
[   25.090411]  [<ffffffff810cdb5d>] ? pte_offset_kernel+0x16/0x35
[   25.090414]  [<ffffffff810fadc7>] ? fget_light+0x5f/0x73
[   25.090417]  [<ffffffff8127ea24>] ? sys_sendto+0x108/0x137
[   25.090420]  [<ffffffff811099f1>] ? dput+0xe2/0xee
[   25.090423]  [<ffffffff810fadc7>] ? fget_light+0x5f/0x73
[   25.090426]  [<ffffffff8127ed49>] ? sys_sendmsg+0x39/0x58
[   25.090430]  [<ffffffff81351ad2>] ? system_call_fastpath+0x16/0x1b
[   25.090913] BUG: scheduling while atomic: NetworkManager/2660/0x00000200
[   25.090962] Modules linked in: lp(+) parport rfcomm(O) bnep(O) binfmt_misc uinput nfsd nfs nfs_acl auth_rpcgss 
fscache lockd sunrpc loop b43(O) arc4 ssb(O) mmc_core rng_core pcmcia pcmcia_core brcmsmac(O) cordic brcmutil(O) 
mac80211(O) btusb(O) cfg80211(O) bluetooth(O) uvcvideo videodev rts5139(C) v4l2_compat_ioctl32 joydev media 
snd_hda_codec_hdmi acpi_cpufreq snd_hda_codec_conexant mperf coretemp processor i2c_algo_bit ideapad_laptop iTCO_wdt 
iTCO_vendor_support bcma(O) battery snd_hda_intel snd_hda_codec psmouse ac snd_hwdep power_supply serio_raw snd_pcm 
sparse_keymap i2c_i801 evdev pcspkr video button i2c_core rfkill snd_page_alloc snd_seq snd_seq_device snd_timer snd 
compat(O) crc32c_intel ghash_clmulni_intel soundcore aesni_intel aes_x86_64 aes_generic cryptd ext4 crc16 jbd2 mbcache 
usbhid hid sg sr_mod cdrom sd_mod crc_t10dif ehci_hcd ahci libahci libata scsi_mod xhci_hcd usbcore usb_common thermal 
thermal_sys [last unloaded: scsi_wait_scan]
[   25.090995] Pid: 2660, comm: NetworkManager Tainted: G         C O 3.2.0-4-amd64 #1 Debian 3.2.32-1
[   25.090996] Call Trace:
[   25.090998]  [<ffffffff81346112>] ? __schedule_bug+0x3e/0x52
[   25.091000]  [<ffffffff8134b27d>] ? __schedule+0x85/0x5c3
[   25.091002]  [<ffffffff8134c399>] ? schedule_hrtimeout_range_clock+0xc0/0x103
[   25.091004]  [<ffffffff81061d7e>] ? update_rmtp+0x62/0x62
[   25.091006]  [<ffffffff810625af>] ? hrtimer_start_expires+0x13/0x15
[   25.091008]  [<ffffffff810519b2>] ? usleep_range+0x39/0x3e
[   25.091012]  [<ffffffffa0482a25>] ? wlc_lcnphy_rx_iq_cal.constprop.10+0x52e/0x9b8 [brcmsmac]
[   25.091017]  [<ffffffffa0483a52>] ? wlc_lcnphy_periodic_cal+0xc0/0x1ae [brcmsmac]
[   25.091020]  [<ffffffffa028fd43>] ? bcma_host_pci_write16+0x11/0x2a [bcma]
[   25.091024]  [<ffffffffa048565f>] ? wlc_phy_init_lcnphy+0xf88/0xf97 [brcmsmac]
[   25.091028]  [<ffffffffa04846d7>] ? wlc_phy_txpower_recalc_target_lcnphy+0x5a/0x5a [brcmsmac]
[   25.091032]  [<ffffffffa047d596>] ? wlc_phy_init+0xe6/0x137 [brcmsmac]
[   25.091037]  [<ffffffffa0473908>] ? brcms_b_bsinit.isra.58+0x120/0x248 [brcmsmac]
[   25.091041]  [<ffffffffa047830c>] ? brcms_c_init+0x83d/0xc41 [brcmsmac]
[   25.091045]  [<ffffffffa0476da3>] ? brcms_c_up+0x26e/0x37e [brcmsmac]
[   25.091049]  [<ffffffffa046f972>] ? brcms_ops_start+0x73/0xb3 [brcmsmac]
[   25.091054]  [<ffffffffa041f4fd>] ? ieee80211_do_open+0x11e/0x5de [mac80211]
[   25.091056]  [<ffffffff8128f6a2>] ? __dev_open+0x8b/0xcc
[   25.091058]  [<ffffffff8128f8ad>] ? __dev_change_flags+0x9d/0x118
[   25.091060]  [<ffffffff8128f98b>] ? dev_change_flags+0x12/0x42
[   25.091062]  [<ffffffff8129966d>] ? do_setlink+0x2ac/0x74d
[   25.091064]  [<ffffffff8129a517>] ? rtnl_newlink+0x24e/0x467
[   25.091066]  [<ffffffff8129a375>] ? rtnl_newlink+0xac/0x467
[   25.091069]  [<ffffffff810eb80e>] ? kmem_cache_alloc_node_trace+0x96/0x10a
[   25.091071]  [<ffffffff8134bfe0>] ? mutex_lock+0xd/0x2d
[   25.091072]  [<ffffffff810709c1>] ? arch_local_irq_save+0x11/0x17
[   25.091074]  [<ffffffff81299e00>] ? rtnl_dellink+0x87/0x10a
[   25.091076]  [<ffffffff81299e8f>] ? __rtnl_unlock+0xc/0xc
[   25.091078]  [<ffffffff812adc57>] ? netlink_rcv_skb+0x36/0x7a
[   25.091080]  [<ffffffff8129927d>] ? rtnetlink_rcv+0x1f/0x28
[   25.091082]  [<ffffffff812ad78e>] ? netlink_unicast+0xe6/0x14e
[   25.091084]  [<ffffffff812ada6a>] ? netlink_sendmsg+0x274/0x2ac
[   25.091086]  [<ffffffff8127d181>] ? sock_sendmsg+0xc1/0xde
[   25.091088]  [<ffffffff8127d060>] ? sock_recvmsg+0xcd/0xec
[   25.091090]  [<ffffffff8127d181>] ? sock_sendmsg+0xc1/0xde
[   25.091092]  [<ffffffff810f1edd>] ? mem_cgroup_update_page_stat+0x17/0xd4
[   25.091094]  [<ffffffff8134b7ff>] ? _cond_resched+0x7/0x1c
[   25.091096]  [<ffffffff810363d8>] ? should_resched+0x5/0x23
[   25.091098]  [<ffffffff8134b7ff>] ? _cond_resched+0x7/0x1c
[   25.091100]  [<ffffffff812864d8>] ? copy_from_user+0x18/0x30
[   25.091101]  [<ffffffff810363d8>] ? should_resched+0x5/0x23
[   25.091103]  [<ffffffff8127d416>] ? __sys_sendmsg+0x1e8/0x288
[   25.091105]  [<ffffffff810cdb5d>] ? pte_offset_kernel+0x16/0x35
[   25.091107]  [<ffffffff810fadc7>] ? fget_light+0x5f/0x73
[   25.091109]  [<ffffffff8127ea24>] ? sys_sendto+0x108/0x137
[   25.091111]  [<ffffffff811099f1>] ? dput+0xe2/0xee
[   25.091113]  [<ffffffff810fadc7>] ? fget_light+0x5f/0x73
[   25.091115]  [<ffffffff8127ed49>] ? sys_sendmsg+0x39/0x58
[   25.091117]  [<ffffffff81351ad2>] ? system_call_fastpath+0x16/0x1b
[   25.091661] BUG: scheduling while atomic: NetworkManager/2660/0x00000200
[   25.091710] Modules linked in: lp(+) parport rfcomm(O) bnep(O) binfmt_misc uinput nfsd nfs nfs_acl auth_rpcgss 
fscache lockd sunrpc loop b43(O) arc4 ssb(O) mmc_core rng_core pcmcia pcmcia_core brcmsmac(O) cordic brcmutil(O) 
mac80211(O) btusb(O) cfg80211(O) bluetooth(O) uvcvideo videodev rts5139(C) v4l2_compat_ioctl32 joydev media 
snd_hda_codec_hdmi acpi_cpufreq snd_hda_codec_conexant mperf coretemp processor i2c_algo_bit ideapad_laptop iTCO_wdt 
iTCO_vendor_support bcma(O) battery snd_hda_intel snd_hda_codec psmouse ac snd_hwdep power_supply serio_raw snd_pcm 
sparse_keymap i2c_i801 evdev pcspkr video button i2c_core rfkill snd_page_alloc snd_seq snd_seq_device snd_timer snd 
compat(O) crc32c_intel ghash_clmulni_intel soundcore aesni_intel aes_x86_64 aes_generic cryptd ext4 crc16 jbd2 mbcache 
usbhid hid sg sr_mod cdrom sd_mod crc_t10dif ehci_hcd ahci libahci libata scsi_mod xhci_hcd usbcore usb_common thermal 
thermal_sys [last unloaded: scsi_wait_scan]
[   25.091742] Pid: 2660, comm: NetworkManager Tainted: G         C O 3.2.0-4-amd64 #1 Debian 3.2.32-1
[   25.091744] Call Trace:
[   25.091745]  [<ffffffff81346112>] ? __schedule_bug+0x3e/0x52
[   25.091747]  [<ffffffff8134b27d>] ? __schedule+0x85/0x5c3
[   25.091749]  [<ffffffff8134c399>] ? schedule_hrtimeout_range_clock+0xc0/0x103
[   25.091751]  [<ffffffff81061d7e>] ? update_rmtp+0x62/0x62
[   25.091753]  [<ffffffff810625af>] ? hrtimer_start_expires+0x13/0x15
[   25.091756]  [<ffffffff810519b2>] ? usleep_range+0x39/0x3e
[   25.091760]  [<ffffffffa0482a6d>] ? wlc_lcnphy_rx_iq_cal.constprop.10+0x576/0x9b8 [brcmsmac]
[   25.091764]  [<ffffffffa0483a52>] ? wlc_lcnphy_periodic_cal+0xc0/0x1ae [brcmsmac]
[   25.091767]  [<ffffffffa028fd43>] ? bcma_host_pci_write16+0x11/0x2a [bcma]
[   25.091771]  [<ffffffffa048565f>] ? wlc_phy_init_lcnphy+0xf88/0xf97 [brcmsmac]
[   25.091775]  [<ffffffffa04846d7>] ? wlc_phy_txpower_recalc_target_lcnphy+0x5a/0x5a [brcmsmac]
[   25.091780]  [<ffffffffa047d596>] ? wlc_phy_init+0xe6/0x137 [brcmsmac]
[   25.091784]  [<ffffffffa0473908>] ? brcms_b_bsinit.isra.58+0x120/0x248 [brcmsmac]
[   25.091788]  [<ffffffffa047830c>] ? brcms_c_init+0x83d/0xc41 [brcmsmac]
[   25.091793]  [<ffffffffa0476da3>] ? brcms_c_up+0x26e/0x37e [brcmsmac]
[   25.091796]  [<ffffffffa046f972>] ? brcms_ops_start+0x73/0xb3 [brcmsmac]
[   25.091801]  [<ffffffffa041f4fd>] ? ieee80211_do_open+0x11e/0x5de [mac80211]
[   25.091804]  [<ffffffff8128f6a2>] ? __dev_open+0x8b/0xcc
[   25.091805]  [<ffffffff8128f8ad>] ? __dev_change_flags+0x9d/0x118
[   25.091807]  [<ffffffff8128f98b>] ? dev_change_flags+0x12/0x42
[   25.091809]  [<ffffffff8129966d>] ? do_setlink+0x2ac/0x74d
[   25.091811]  [<ffffffff8129a517>] ? rtnl_newlink+0x24e/0x467
[   25.091813]  [<ffffffff8129a375>] ? rtnl_newlink+0xac/0x467
[   25.091816]  [<ffffffff810eb80e>] ? kmem_cache_alloc_node_trace+0x96/0x10a
[   25.091818]  [<ffffffff8134bfe0>] ? mutex_lock+0xd/0x2d
[   25.091819]  [<ffffffff810709c1>] ? arch_local_irq_save+0x11/0x17
[   25.091821]  [<ffffffff81299e00>] ? rtnl_dellink+0x87/0x10a
[   25.091823]  [<ffffffff81299e8f>] ? __rtnl_unlock+0xc/0xc
[   25.091825]  [<ffffffff812adc57>] ? netlink_rcv_skb+0x36/0x7a
[   25.091827]  [<ffffffff8129927d>] ? rtnetlink_rcv+0x1f/0x28
[   25.091829]  [<ffffffff812ad78e>] ? netlink_unicast+0xe6/0x14e
[   25.091831]  [<ffffffff812ada6a>] ? netlink_sendmsg+0x274/0x2ac
[   25.091833]  [<ffffffff8127d181>] ? sock_sendmsg+0xc1/0xde
[   25.091835]  [<ffffffff8127d060>] ? sock_recvmsg+0xcd/0xec
[   25.091837]  [<ffffffff8127d181>] ? sock_sendmsg+0xc1/0xde
[   25.091839]  [<ffffffff810f1edd>] ? mem_cgroup_update_page_stat+0x17/0xd4
[   25.091841]  [<ffffffff8134b7ff>] ? _cond_resched+0x7/0x1c
[   25.091843]  [<ffffffff810363d8>] ? should_resched+0x5/0x23
[   25.091845]  [<ffffffff8134b7ff>] ? _cond_resched+0x7/0x1c
[   25.091847]  [<ffffffff812864d8>] ? copy_from_user+0x18/0x30
[   25.091849]  [<ffffffff810363d8>] ? should_resched+0x5/0x23
[   25.091851]  [<ffffffff8127d416>] ? __sys_sendmsg+0x1e8/0x288
[   25.091852]  [<ffffffff810cdb5d>] ? pte_offset_kernel+0x16/0x35
[   25.091855]  [<ffffffff810fadc7>] ? fget_light+0x5f/0x73
[   25.091857]  [<ffffffff8127ea24>] ? sys_sendto+0x108/0x137
[   25.091858]  [<ffffffff811099f1>] ? dput+0xe2/0xee
[   25.091860]  [<ffffffff810fadc7>] ? fget_light+0x5f/0x73
[   25.091862]  [<ffffffff8127ed49>] ? sys_sendmsg+0x39/0x58
[   25.091864]  [<ffffffff81351ad2>] ? system_call_fastpath+0x16/0x1b
[   25.092451] BUG: scheduling while atomic: NetworkManager/2660/0x00000200
[   25.092499] Modules linked in: lp(+) parport rfcomm(O) bnep(O) binfmt_misc uinput nfsd nfs nfs_acl auth_rpcgss 
fscache lockd sunrpc loop b43(O) arc4 ssb(O) mmc_core rng_core pcmcia pcmcia_core brcmsmac(O) cordic brcmutil(O) 
mac80211(O) btusb(O) cfg80211(O) bluetooth(O) uvcvideo videodev rts5139(C) v4l2_compat_ioctl32 joydev media 
snd_hda_codec_hdmi acpi_cpufreq snd_hda_codec_conexant mperf coretemp processor i2c_algo_bit ideapad_laptop iTCO_wdt 
iTCO_vendor_support bcma(O) battery snd_hda_intel snd_hda_codec psmouse ac snd_hwdep power_supply serio_raw snd_pcm 
sparse_keymap i2c_i801 evdev pcspkr video button i2c_core rfkill snd_page_alloc snd_seq snd_seq_device snd_timer snd 
compat(O) crc32c_intel ghash_clmulni_intel soundcore aesni_intel aes_x86_64 aes_generic cryptd ext4 crc16 jbd2 mbcache 
usbhid hid sg sr_mod cdrom sd_mod crc_t10dif ehci_hcd ahci libahci libata scsi_mod xhci_hcd usbcore usb_common thermal 
thermal_sys [last unloaded: scsi_wait_scan]
[   25.092531] Pid: 2660, comm: NetworkManager Tainted: G         C O 3.2.0-4-amd64 #1 Debian 3.2.32-1
[   25.092533] Call Trace:
[   25.092534]  [<ffffffff81346112>] ? __schedule_bug+0x3e/0x52
[   25.092536]  [<ffffffff8134b27d>] ? __schedule+0x85/0x5c3
[   25.092538]  [<ffffffff8134c399>] ? schedule_hrtimeout_range_clock+0xc0/0x103
[   25.092540]  [<ffffffff81061d7e>] ? update_rmtp+0x62/0x62
[   25.092542]  [<ffffffff810625af>] ? hrtimer_start_expires+0x13/0x15
[   25.092544]  [<ffffffff810519b2>] ? usleep_range+0x39/0x3e
[   25.092549]  [<ffffffffa0482a25>] ? wlc_lcnphy_rx_iq_cal.constprop.10+0x52e/0x9b8 [brcmsmac]
[   25.092553]  [<ffffffffa0483a52>] ? wlc_lcnphy_periodic_cal+0xc0/0x1ae [brcmsmac]
[   25.092556]  [<ffffffffa028fd43>] ? bcma_host_pci_write16+0x11/0x2a [bcma]
[   25.092560]  [<ffffffffa048565f>] ? wlc_phy_init_lcnphy+0xf88/0xf97 [brcmsmac]
[   25.092564]  [<ffffffffa04846d7>] ? wlc_phy_txpower_recalc_target_lcnphy+0x5a/0x5a [brcmsmac]
[   25.092568]  [<ffffffffa047d596>] ? wlc_phy_init+0xe6/0x137 [brcmsmac]
[   25.092573]  [<ffffffffa0473908>] ? brcms_b_bsinit.isra.58+0x120/0x248 [brcmsmac]
[   25.092577]  [<ffffffffa047830c>] ? brcms_c_init+0x83d/0xc41 [brcmsmac]
[   25.092581]  [<ffffffffa0476da3>] ? brcms_c_up+0x26e/0x37e [brcmsmac]
[   25.092585]  [<ffffffffa046f972>] ? brcms_ops_start+0x73/0xb3 [brcmsmac]
[   25.092590]  [<ffffffffa041f4fd>] ? ieee80211_do_open+0x11e/0x5de [mac80211]
[   25.092592]  [<ffffffff8128f6a2>] ? __dev_open+0x8b/0xcc
[   25.092594]  [<ffffffff8128f8ad>] ? __dev_change_flags+0x9d/0x118
[   25.092596]  [<ffffffff8128f98b>] ? dev_change_flags+0x12/0x42
[   25.092598]  [<ffffffff8129966d>] ? do_setlink+0x2ac/0x74d
[   25.092600]  [<ffffffff8129a517>] ? rtnl_newlink+0x24e/0x467
[   25.092602]  [<ffffffff8129a375>] ? rtnl_newlink+0xac/0x467
[   25.092605]  [<ffffffff810eb80e>] ? kmem_cache_alloc_node_trace+0x96/0x10a
[   25.092606]  [<ffffffff8134bfe0>] ? mutex_lock+0xd/0x2d
[   25.092608]  [<ffffffff810709c1>] ? arch_local_irq_save+0x11/0x17
[   25.092610]  [<ffffffff81299e00>] ? rtnl_dellink+0x87/0x10a
[   25.092612]  [<ffffffff81299e8f>] ? __rtnl_unlock+0xc/0xc
[   25.092614]  [<ffffffff812adc57>] ? netlink_rcv_skb+0x36/0x7a
[   25.092615]  [<ffffffff8129927d>] ? rtnetlink_rcv+0x1f/0x28
[   25.092617]  [<ffffffff812ad78e>] ? netlink_unicast+0xe6/0x14e
[   25.092619]  [<ffffffff812ada6a>] ? netlink_sendmsg+0x274/0x2ac
[   25.092622]  [<ffffffff8127d181>] ? sock_sendmsg+0xc1/0xde
[   25.092623]  [<ffffffff8127d060>] ? sock_recvmsg+0xcd/0xec
[   25.092625]  [<ffffffff8127d181>] ? sock_sendmsg+0xc1/0xde
[   25.092628]  [<ffffffff810f1edd>] ? mem_cgroup_update_page_stat+0x17/0xd4
[   25.092630]  [<ffffffff8134b7ff>] ? _cond_resched+0x7/0x1c
[   25.092631]  [<ffffffff810363d8>] ? should_resched+0x5/0x23
[   25.092634]  [<ffffffff8134b7ff>] ? _cond_resched+0x7/0x1c
[   25.092635]  [<ffffffff812864d8>] ? copy_from_user+0x18/0x30
[   25.092637]  [<ffffffff810363d8>] ? should_resched+0x5/0x23
[   25.092639]  [<ffffffff8127d416>] ? __sys_sendmsg+0x1e8/0x288
[   25.092641]  [<ffffffff810cdb5d>] ? pte_offset_kernel+0x16/0x35
[   25.092643]  [<ffffffff810fadc7>] ? fget_light+0x5f/0x73
[   25.092645]  [<ffffffff8127ea24>] ? sys_sendto+0x108/0x137
[   25.092647]  [<ffffffff811099f1>] ? dput+0xe2/0xee
[   25.092649]  [<ffffffff810fadc7>] ? fget_light+0x5f/0x73
[   25.092650]  [<ffffffff8127ed49>] ? sys_sendmsg+0x39/0x58
[   25.092653]  [<ffffffff81351ad2>] ? system_call_fastpath+0x16/0x1b
[   25.093199] BUG: scheduling while atomic: NetworkManager/2660/0x00000200
[   25.093248] Modules linked in: lp(+) parport rfcomm(O) bnep(O) binfmt_misc uinput nfsd nfs nfs_acl auth_rpcgss 
fscache lockd sunrpc loop b43(O) arc4 ssb(O) mmc_core rng_core pcmcia pcmcia_core brcmsmac(O) cordic brcmutil(O) 
mac80211(O) btusb(O) cfg80211(O) bluetooth(O) uvcvideo videodev rts5139(C) v4l2_compat_ioctl32 joydev media 
snd_hda_codec_hdmi acpi_cpufreq snd_hda_codec_conexant mperf coretemp processor i2c_algo_bit ideapad_laptop iTCO_wdt 
iTCO_vendor_support bcma(O) battery snd_hda_intel snd_hda_codec psmouse ac snd_hwdep power_supply serio_raw snd_pcm 
sparse_keymap i2c_i801 evdev pcspkr video button i2c_core rfkill snd_page_alloc snd_seq snd_seq_device snd_timer snd 
compat(O) crc32c_intel ghash_clmulni_intel soundcore aesni_intel aes_x86_64 aes_generic cryptd ext4 crc16 jbd2 mbcache 
usbhid hid sg sr_mod cdrom sd_mod crc_t10dif ehci_hcd ahci libahci libata scsi_mod xhci_hcd usbcore usb_common thermal 
thermal_sys [last unloaded: scsi_wait_scan]
[   25.093281] Pid: 2660, comm: NetworkManager Tainted: G         C O 3.2.0-4-amd64 #1 Debian 3.2.32-1
[   25.093282] Call Trace:
[   25.093284]  [<ffffffff81346112>] ? __schedule_bug+0x3e/0x52
[   25.093286]  [<ffffffff8134b27d>] ? __schedule+0x85/0x5c3
[   25.093288]  [<ffffffff8134c399>] ? schedule_hrtimeout_range_clock+0xc0/0x103
[   25.093290]  [<ffffffff81061d7e>] ? update_rmtp+0x62/0x62
[   25.093291]  [<ffffffff810625af>] ? hrtimer_start_expires+0x13/0x15
[   25.093294]  [<ffffffff810519b2>] ? usleep_range+0x39/0x3e
[   25.093298]  [<ffffffffa0482a6d>] ? wlc_lcnphy_rx_iq_cal.constprop.10+0x576/0x9b8 [brcmsmac]
[   25.093302]  [<ffffffffa0483a52>] ? wlc_lcnphy_periodic_cal+0xc0/0x1ae [brcmsmac]
[   25.093305]  [<ffffffffa028fd43>] ? bcma_host_pci_write16+0x11/0x2a [bcma]
[   25.093309]  [<ffffffffa048565f>] ? wlc_phy_init_lcnphy+0xf88/0xf97 [brcmsmac]
[   25.093313]  [<ffffffffa04846d7>] ? wlc_phy_txpower_recalc_target_lcnphy+0x5a/0x5a [brcmsmac]
[   25.093318]  [<ffffffffa047d596>] ? wlc_phy_init+0xe6/0x137 [brcmsmac]
[   25.093322]  [<ffffffffa0473908>] ? brcms_b_bsinit.isra.58+0x120/0x248 [brcmsmac]
[   25.093326]  [<ffffffffa047830c>] ? brcms_c_init+0x83d/0xc41 [brcmsmac]
[   25.093344]  [<ffffffffa0476da3>] ? brcms_c_up+0x26e/0x37e [brcmsmac]
[   25.093350]  [<ffffffffa046f972>] ? brcms_ops_start+0x73/0xb3 [brcmsmac]
[   25.093357]  [<ffffffffa041f4fd>] ? ieee80211_do_open+0x11e/0x5de [mac80211]
[   25.093360]  [<ffffffff8128f6a2>] ? __dev_open+0x8b/0xcc
[   25.093362]  [<ffffffff8128f8ad>] ? __dev_change_flags+0x9d/0x118
[   25.093365]  [<ffffffff8128f98b>] ? dev_change_flags+0x12/0x42
[   25.093367]  [<ffffffff8129966d>] ? do_setlink+0x2ac/0x74d
[   25.093370]  [<ffffffff8129a517>] ? rtnl_newlink+0x24e/0x467
[   25.093373]  [<ffffffff8129a375>] ? rtnl_newlink+0xac/0x467
[   25.093378]  [<ffffffff810eb80e>] ? kmem_cache_alloc_node_trace+0x96/0x10a
[   25.093381]  [<ffffffff8134bfe0>] ? mutex_lock+0xd/0x2d
[   25.093384]  [<ffffffff810709c1>] ? arch_local_irq_save+0x11/0x17
[   25.093387]  [<ffffffff81299e00>] ? rtnl_dellink+0x87/0x10a
[   25.093403]  [<ffffffff81299e8f>] ? __rtnl_unlock+0xc/0xc
[   25.093406]  [<ffffffff812adc57>] ? netlink_rcv_skb+0x36/0x7a
[   25.093409]  [<ffffffff8129927d>] ? rtnetlink_rcv+0x1f/0x28
[   25.093412]  [<ffffffff812ad78e>] ? netlink_unicast+0xe6/0x14e
[   25.093415]  [<ffffffff812ada6a>] ? netlink_sendmsg+0x274/0x2ac
[   25.093418]  [<ffffffff8127d181>] ? sock_sendmsg+0xc1/0xde
[   25.093421]  [<ffffffff8127d060>] ? sock_recvmsg+0xcd/0xec
[   25.093425]  [<ffffffff8127d181>] ? sock_sendmsg+0xc1/0xde
[   25.093428]  [<ffffffff810f1edd>] ? mem_cgroup_update_page_stat+0x17/0xd4
[   25.093431]  [<ffffffff8134b7ff>] ? _cond_resched+0x7/0x1c
[   25.093434]  [<ffffffff810363d8>] ? should_resched+0x5/0x23
[   25.093437]  [<ffffffff8134b7ff>] ? _cond_resched+0x7/0x1c
[   25.093440]  [<ffffffff812864d8>] ? copy_from_user+0x18/0x30
[   25.093443]  [<ffffffff810363d8>] ? should_resched+0x5/0x23
[   25.093446]  [<ffffffff8127d416>] ? __sys_sendmsg+0x1e8/0x288
[   25.093449]  [<ffffffff810cdb5d>] ? pte_offset_kernel+0x16/0x35
[   25.093453]  [<ffffffff810fadc7>] ? fget_light+0x5f/0x73
[   25.093456]  [<ffffffff8127ea24>] ? sys_sendto+0x108/0x137
[   25.093459]  [<ffffffff811099f1>] ? dput+0xe2/0xee
[   25.093462]  [<ffffffff810fadc7>] ? fget_light+0x5f/0x73
[   25.093465]  [<ffffffff8127ed49>] ? sys_sendmsg+0x39/0x58
[   25.093468]  [<ffffffff81351ad2>] ? system_call_fastpath+0x16/0x1b
[   25.093987] BUG: scheduling while atomic: NetworkManager/2660/0x00000200
[   25.094036] Modules linked in: lp(+) parport rfcomm(O) bnep(O) binfmt_misc uinput nfsd nfs nfs_acl auth_rpcgss 
fscache lockd sunrpc loop b43(O) arc4 ssb(O) mmc_core rng_core pcmcia pcmcia_core brcmsmac(O) cordic brcmutil(O) 
mac80211(O) btusb(O) cfg80211(O) bluetooth(O) uvcvideo videodev rts5139(C) v4l2_compat_ioctl32 joydev media 
snd_hda_codec_hdmi acpi_cpufreq snd_hda_codec_conexant mperf coretemp processor i2c_algo_bit ideapad_laptop iTCO_wdt 
iTCO_vendor_support bcma(O) battery snd_hda_intel snd_hda_codec psmouse ac snd_hwdep power_supply serio_raw snd_pcm 
sparse_keymap i2c_i801 evdev pcspkr video button i2c_core rfkill snd_page_alloc snd_seq snd_seq_device snd_timer snd 
compat(O) crc32c_intel ghash_clmulni_intel soundcore aesni_intel aes_x86_64 aes_generic cryptd ext4 crc16 jbd2 mbcache 
usbhid hid sg sr_mod cdrom sd_mod crc_t10dif ehci_hcd ahci libahci libata scsi_mod xhci_hcd usbcore usb_common thermal 
thermal_sys [last unloaded: scsi_wait_scan]
[   25.094105] Pid: 2660, comm: NetworkManager Tainted: G         C O 3.2.0-4-amd64 #1 Debian 3.2.32-1
[   25.094108] Call Trace:
[   25.094110]  [<ffffffff81346112>] ? __schedule_bug+0x3e/0x52
[   25.094114]  [<ffffffff8134b27d>] ? __schedule+0x85/0x5c3
[   25.094117]  [<ffffffff8134c399>] ? schedule_hrtimeout_range_clock+0xc0/0x103
[   25.094120]  [<ffffffff81061d7e>] ? update_rmtp+0x62/0x62
[   25.094123]  [<ffffffff810625af>] ? hrtimer_start_expires+0x13/0x15
[   25.094127]  [<ffffffff810519b2>] ? usleep_range+0x39/0x3e
[   25.094132]  [<ffffffffa0482a25>] ? wlc_lcnphy_rx_iq_cal.constprop.10+0x52e/0x9b8 [brcmsmac]
[   25.094138]  [<ffffffffa0483a52>] ? wlc_lcnphy_periodic_cal+0xc0/0x1ae [brcmsmac]
[   25.094142]  [<ffffffffa028fd43>] ? bcma_host_pci_write16+0x11/0x2a [bcma]
[   25.094148]  [<ffffffffa048565f>] ? wlc_phy_init_lcnphy+0xf88/0xf97 [brcmsmac]
[   25.094153]  [<ffffffffa04846d7>] ? wlc_phy_txpower_recalc_target_lcnphy+0x5a/0x5a [brcmsmac]
[   25.094159]  [<ffffffffa047d596>] ? wlc_phy_init+0xe6/0x137 [brcmsmac]
[   25.094164]  [<ffffffffa0473908>] ? brcms_b_bsinit.isra.58+0x120/0x248 [brcmsmac]
[   25.094170]  [<ffffffffa047830c>] ? brcms_c_init+0x83d/0xc41 [brcmsmac]
[   25.094175]  [<ffffffffa0476da3>] ? brcms_c_up+0x26e/0x37e [brcmsmac]
[   25.094180]  [<ffffffffa046f972>] ? brcms_ops_start+0x73/0xb3 [brcmsmac]
[   25.094186]  [<ffffffffa041f4fd>] ? ieee80211_do_open+0x11e/0x5de [mac80211]
[   25.094190]  [<ffffffff8128f6a2>] ? __dev_open+0x8b/0xcc
[   25.094193]  [<ffffffff8128f8ad>] ? __dev_change_flags+0x9d/0x118
[   25.094196]  [<ffffffff8128f98b>] ? dev_change_flags+0x12/0x42
[   25.094199]  [<ffffffff8129966d>] ? do_setlink+0x2ac/0x74d
[   25.094202]  [<ffffffff8129a517>] ? rtnl_newlink+0x24e/0x467
[   25.094205]  [<ffffffff8129a375>] ? rtnl_newlink+0xac/0x467
[   25.094209]  [<ffffffff810eb80e>] ? kmem_cache_alloc_node_trace+0x96/0x10a
[   25.094212]  [<ffffffff8134bfe0>] ? mutex_lock+0xd/0x2d
[   25.094215]  [<ffffffff810709c1>] ? arch_local_irq_save+0x11/0x17
[   25.094218]  [<ffffffff81299e00>] ? rtnl_dellink+0x87/0x10a
[   25.094221]  [<ffffffff81299e8f>] ? __rtnl_unlock+0xc/0xc
[   25.094224]  [<ffffffff812adc57>] ? netlink_rcv_skb+0x36/0x7a
[   25.094227]  [<ffffffff8129927d>] ? rtnetlink_rcv+0x1f/0x28
[   25.094230]  [<ffffffff812ad78e>] ? netlink_unicast+0xe6/0x14e
[   25.094233]  [<ffffffff812ada6a>] ? netlink_sendmsg+0x274/0x2ac
[   25.094237]  [<ffffffff8127d181>] ? sock_sendmsg+0xc1/0xde
[   25.094240]  [<ffffffff8127d060>] ? sock_recvmsg+0xcd/0xec
[   25.094243]  [<ffffffff8127d181>] ? sock_sendmsg+0xc1/0xde
[   25.094246]  [<ffffffff810f1edd>] ? mem_cgroup_update_page_stat+0x17/0xd4
[   25.094250]  [<ffffffff8134b7ff>] ? _cond_resched+0x7/0x1c
[   25.094253]  [<ffffffff810363d8>] ? should_resched+0x5/0x23
[   25.094256]  [<ffffffff8134b7ff>] ? _cond_resched+0x7/0x1c
[   25.094259]  [<ffffffff812864d8>] ? copy_from_user+0x18/0x30
[   25.094262]  [<ffffffff810363d8>] ? should_resched+0x5/0x23
[   25.094265]  [<ffffffff8127d416>] ? __sys_sendmsg+0x1e8/0x288
[   25.094268]  [<ffffffff810cdb5d>] ? pte_offset_kernel+0x16/0x35
[   25.094271]  [<ffffffff810fadc7>] ? fget_light+0x5f/0x73
[   25.094274]  [<ffffffff8127ea24>] ? sys_sendto+0x108/0x137
[   25.094277]  [<ffffffff811099f1>] ? dput+0xe2/0xee
[   25.094280]  [<ffffffff810fadc7>] ? fget_light+0x5f/0x73
[   25.094284]  [<ffffffff8127ed49>] ? sys_sendmsg+0x39/0x58
[   25.094287]  [<ffffffff81351ad2>] ? system_call_fastpath+0x16/0x1b
[   25.094736] BUG: scheduling while atomic: NetworkManager/2660/0x00000200
[   25.094785] Modules linked in: lp(+) parport rfcomm(O) bnep(O) binfmt_misc uinput nfsd nfs nfs_acl auth_rpcgss 
fscache lockd sunrpc loop b43(O) arc4 ssb(O) mmc_core rng_core pcmcia pcmcia_core brcmsmac(O) cordic brcmutil(O) 
mac80211(O) btusb(O) cfg80211(O) bluetooth(O) uvcvideo videodev rts5139(C) v4l2_compat_ioctl32 joydev media 
snd_hda_codec_hdmi acpi_cpufreq snd_hda_codec_conexant mperf coretemp processor i2c_algo_bit ideapad_laptop iTCO_wdt 
iTCO_vendor_support bcma(O) battery snd_hda_intel snd_hda_codec psmouse ac snd_hwdep power_supply serio_raw snd_pcm 
sparse_keymap i2c_i801 evdev pcspkr video button i2c_core rfkill snd_page_alloc snd_seq snd_seq_device snd_timer snd 
compat(O) crc32c_intel ghash_clmulni_intel soundcore aesni_intel aes_x86_64 aes_generic cryptd ext4 crc16 jbd2 mbcache 
usbhid hid sg sr_mod cdrom sd_mod crc_t10dif ehci_hcd ahci libahci libata scsi_mod xhci_hcd usbcore usb_common thermal 
thermal_sys [last unloaded: scsi_wait_scan]
[   25.094818] Pid: 2660, comm: NetworkManager Tainted: G         C O 3.2.0-4-amd64 #1 Debian 3.2.32-1
[   25.094819] Call Trace:
[   25.094821]  [<ffffffff81346112>] ? __schedule_bug+0x3e/0x52
[   25.094823]  [<ffffffff8134b27d>] ? __schedule+0x85/0x5c3
[   25.094825]  [<ffffffff8134c399>] ? schedule_hrtimeout_range_clock+0xc0/0x103
[   25.094827]  [<ffffffff81061d7e>] ? update_rmtp+0x62/0x62
[   25.094829]  [<ffffffff810625af>] ? hrtimer_start_expires+0x13/0x15
[   25.094831]  [<ffffffff810519b2>] ? usleep_range+0x39/0x3e
[   25.094835]  [<ffffffffa0482a6d>] ? wlc_lcnphy_rx_iq_cal.constprop.10+0x576/0x9b8 [brcmsmac]
[   25.094840]  [<ffffffffa0483a52>] ? wlc_lcnphy_periodic_cal+0xc0/0x1ae [brcmsmac]
[   25.094843]  [<ffffffffa028fd43>] ? bcma_host_pci_write16+0x11/0x2a [bcma]
[   25.094847]  [<ffffffffa048565f>] ? wlc_phy_init_lcnphy+0xf88/0xf97 [brcmsmac]
[   25.094851]  [<ffffffffa04846d7>] ? wlc_phy_txpower_recalc_target_lcnphy+0x5a/0x5a [brcmsmac]
[   25.094855]  [<ffffffffa047d596>] ? wlc_phy_init+0xe6/0x137 [brcmsmac]
[   25.094860]  [<ffffffffa0473908>] ? brcms_b_bsinit.isra.58+0x120/0x248 [brcmsmac]
[   25.094864]  [<ffffffffa047830c>] ? brcms_c_init+0x83d/0xc41 [brcmsmac]
[   25.094868]  [<ffffffffa0476da3>] ? brcms_c_up+0x26e/0x37e [brcmsmac]
[   25.094872]  [<ffffffffa046f972>] ? brcms_ops_start+0x73/0xb3 [brcmsmac]
[   25.094877]  [<ffffffffa041f4fd>] ? ieee80211_do_open+0x11e/0x5de [mac80211]
[   25.094879]  [<ffffffff8128f6a2>] ? __dev_open+0x8b/0xcc
[   25.094881]  [<ffffffff8128f8ad>] ? __dev_change_flags+0x9d/0x118
[   25.094883]  [<ffffffff8128f98b>] ? dev_change_flags+0x12/0x42
[   25.094885]  [<ffffffff8129966d>] ? do_setlink+0x2ac/0x74d
[   25.094887]  [<ffffffff8129a517>] ? rtnl_newlink+0x24e/0x467
[   25.094889]  [<ffffffff8129a375>] ? rtnl_newlink+0xac/0x467
[   25.094892]  [<ffffffff810eb80e>] ? kmem_cache_alloc_node_trace+0x96/0x10a
[   25.094893]  [<ffffffff8134bfe0>] ? mutex_lock+0xd/0x2d
[   25.094895]  [<ffffffff810709c1>] ? arch_local_irq_save+0x11/0x17
[   25.094897]  [<ffffffff81299e00>] ? rtnl_dellink+0x87/0x10a
[   25.094899]  [<ffffffff81299e8f>] ? __rtnl_unlock+0xc/0xc
[   25.094901]  [<ffffffff812adc57>] ? netlink_rcv_skb+0x36/0x7a
[   25.094903]  [<ffffffff8129927d>] ? rtnetlink_rcv+0x1f/0x28
[   25.094905]  [<ffffffff812ad78e>] ? netlink_unicast+0xe6/0x14e
[   25.094907]  [<ffffffff812ada6a>] ? netlink_sendmsg+0x274/0x2ac
[   25.094909]  [<ffffffff8127d181>] ? sock_sendmsg+0xc1/0xde
[   25.094911]  [<ffffffff8127d060>] ? sock_recvmsg+0xcd/0xec
[   25.094913]  [<ffffffff8127d181>] ? sock_sendmsg+0xc1/0xde
[   25.094915]  [<ffffffff810f1edd>] ? mem_cgroup_update_page_stat+0x17/0xd4
[   25.094917]  [<ffffffff8134b7ff>] ? _cond_resched+0x7/0x1c
[   25.094919]  [<ffffffff810363d8>] ? should_resched+0x5/0x23
[   25.094921]  [<ffffffff8134b7ff>] ? _cond_resched+0x7/0x1c
[   25.094923]  [<ffffffff812864d8>] ? copy_from_user+0x18/0x30
[   25.094924]  [<ffffffff810363d8>] ? should_resched+0x5/0x23
[   25.094926]  [<ffffffff8127d416>] ? __sys_sendmsg+0x1e8/0x288
[   25.094928]  [<ffffffff810cdb5d>] ? pte_offset_kernel+0x16/0x35
[   25.094930]  [<ffffffff810fadc7>] ? fget_light+0x5f/0x73
[   25.094932]  [<ffffffff8127ea24>] ? sys_sendto+0x108/0x137
[   25.094934]  [<ffffffff811099f1>] ? dput+0xe2/0xee
[   25.094936]  [<ffffffff810fadc7>] ? fget_light+0x5f/0x73
[   25.094938]  [<ffffffff8127ed49>] ? sys_sendmsg+0x39/0x58
[   25.094940]  [<ffffffff81351ad2>] ? system_call_fastpath+0x16/0x1b
[   25.095528] BUG: scheduling while atomic: NetworkManager/2660/0x00000200
[   25.095576] Modules linked in: lp(+) parport rfcomm(O) bnep(O) binfmt_misc uinput nfsd nfs nfs_acl auth_rpcgss 
fscache lockd sunrpc loop b43(O) arc4 ssb(O) mmc_core rng_core pcmcia pcmcia_core brcmsmac(O) cordic brcmutil(O) 
mac80211(O) btusb(O) cfg80211(O) bluetooth(O) uvcvideo videodev rts5139(C) v4l2_compat_ioctl32 joydev media 
snd_hda_codec_hdmi acpi_cpufreq snd_hda_codec_conexant mperf coretemp processor i2c_algo_bit ideapad_laptop iTCO_wdt 
iTCO_vendor_support bcma(O) battery snd_hda_intel snd_hda_codec psmouse ac snd_hwdep power_supply serio_raw snd_pcm 
sparse_keymap i2c_i801 evdev pcspkr video button i2c_core rfkill snd_page_alloc snd_seq snd_seq_device snd_timer snd 
compat(O) crc32c_intel ghash_clmulni_intel soundcore aesni_intel aes_x86_64 aes_generic cryptd ext4 crc16 jbd2 mbcache 
usbhid hid sg sr_mod cdrom sd_mod crc_t10dif ehci_hcd ahci libahci libata scsi_mod xhci_hcd usbcore usb_common thermal 
thermal_sys [last unloaded: scsi_wait_scan]
[   25.095608] Pid: 2660, comm: NetworkManager Tainted: G         C O 3.2.0-4-amd64 #1 Debian 3.2.32-1
[   25.095610] Call Trace:
[   25.095611]  [<ffffffff81346112>] ? __schedule_bug+0x3e/0x52
[   25.095613]  [<ffffffff8134b27d>] ? __schedule+0x85/0x5c3
[   25.095615]  [<ffffffff8134c399>] ? schedule_hrtimeout_range_clock+0xc0/0x103
[   25.095617]  [<ffffffff81061d7e>] ? update_rmtp+0x62/0x62
[   25.095619]  [<ffffffff810625af>] ? hrtimer_start_expires+0x13/0x15
[   25.095622]  [<ffffffff810519b2>] ? usleep_range+0x39/0x3e
[   25.095626]  [<ffffffffa0482a25>] ? wlc_lcnphy_rx_iq_cal.constprop.10+0x52e/0x9b8 [brcmsmac]
[   25.095630]  [<ffffffffa0483a52>] ? wlc_lcnphy_periodic_cal+0xc0/0x1ae [brcmsmac]
[   25.095633]  [<ffffffffa028fd43>] ? bcma_host_pci_write16+0x11/0x2a [bcma]
[   25.095637]  [<ffffffffa048565f>] ? wlc_phy_init_lcnphy+0xf88/0xf97 [brcmsmac]
[   25.095641]  [<ffffffffa04846d7>] ? wlc_phy_txpower_recalc_target_lcnphy+0x5a/0x5a [brcmsmac]
[   25.095646]  [<ffffffffa047d596>] ? wlc_phy_init+0xe6/0x137 [brcmsmac]
[   25.095650]  [<ffffffffa0473908>] ? brcms_b_bsinit.isra.58+0x120/0x248 [brcmsmac]
[   25.095654]  [<ffffffffa047830c>] ? brcms_c_init+0x83d/0xc41 [brcmsmac]
[   25.095659]  [<ffffffffa0476da3>] ? brcms_c_up+0x26e/0x37e [brcmsmac]
[   25.095662]  [<ffffffffa046f972>] ? brcms_ops_start+0x73/0xb3 [brcmsmac]
[   25.095667]  [<ffffffffa041f4fd>] ? ieee80211_do_open+0x11e/0x5de [mac80211]
[   25.095669]  [<ffffffff8128f6a2>] ? __dev_open+0x8b/0xcc
[   25.095671]  [<ffffffff8128f8ad>] ? __dev_change_flags+0x9d/0x118
[   25.095673]  [<ffffffff8128f98b>] ? dev_change_flags+0x12/0x42
[   25.095675]  [<ffffffff8129966d>] ? do_setlink+0x2ac/0x74d
[   25.095677]  [<ffffffff8129a517>] ? rtnl_newlink+0x24e/0x467
[   25.095679]  [<ffffffff8129a375>] ? rtnl_newlink+0xac/0x467
[   25.095682]  [<ffffffff810eb80e>] ? kmem_cache_alloc_node_trace+0x96/0x10a
[   25.095683]  [<ffffffff8134bfe0>] ? mutex_lock+0xd/0x2d
[   25.095685]  [<ffffffff810709c1>] ? arch_local_irq_save+0x11/0x17
[   25.095687]  [<ffffffff81299e00>] ? rtnl_dellink+0x87/0x10a
[   25.095689]  [<ffffffff81299e8f>] ? __rtnl_unlock+0xc/0xc
[   25.095691]  [<ffffffff812adc57>] ? netlink_rcv_skb+0x36/0x7a
[   25.095692]  [<ffffffff8129927d>] ? rtnetlink_rcv+0x1f/0x28
[   25.095694]  [<ffffffff812ad78e>] ? netlink_unicast+0xe6/0x14e
[   25.095696]  [<ffffffff812ada6a>] ? netlink_sendmsg+0x274/0x2ac
[   25.095699]  [<ffffffff8127d181>] ? sock_sendmsg+0xc1/0xde
[   25.095700]  [<ffffffff8127d060>] ? sock_recvmsg+0xcd/0xec
[   25.095702]  [<ffffffff8127d181>] ? sock_sendmsg+0xc1/0xde
[   25.095705]  [<ffffffff810f1edd>] ? mem_cgroup_update_page_stat+0x17/0xd4
[   25.095707]  [<ffffffff8134b7ff>] ? _cond_resched+0x7/0x1c
[   25.095708]  [<ffffffff810363d8>] ? should_resched+0x5/0x23
[   25.095711]  [<ffffffff8134b7ff>] ? _cond_resched+0x7/0x1c
[   25.095712]  [<ffffffff812864d8>] ? copy_from_user+0x18/0x30
[   25.095714]  [<ffffffff810363d8>] ? should_resched+0x5/0x23
[   25.095716]  [<ffffffff8127d416>] ? __sys_sendmsg+0x1e8/0x288
[   25.095718]  [<ffffffff810cdb5d>] ? pte_offset_kernel+0x16/0x35
[   25.095720]  [<ffffffff810fadc7>] ? fget_light+0x5f/0x73
[   25.095722]  [<ffffffff8127ea24>] ? sys_sendto+0x108/0x137
[   25.095724]  [<ffffffff811099f1>] ? dput+0xe2/0xee
[   25.095726]  [<ffffffff810fadc7>] ? fget_light+0x5f/0x73
[   25.095728]  [<ffffffff8127ed49>] ? sys_sendmsg+0x39/0x58
[   25.095730]  [<ffffffff81351ad2>] ? system_call_fastpath+0x16/0x1b
[   25.096276] BUG: scheduling while atomic: NetworkManager/2660/0x00000200
[   25.096324] Modules linked in: lp(+) parport rfcomm(O) bnep(O) binfmt_misc uinput nfsd nfs nfs_acl auth_rpcgss 
fscache lockd sunrpc loop b43(O) arc4 ssb(O) mmc_core rng_core pcmcia pcmcia_core brcmsmac(O) cordic brcmutil(O) 
mac80211(O) btusb(O) cfg80211(O) bluetooth(O) uvcvideo videodev rts5139(C) v4l2_compat_ioctl32 joydev media 
snd_hda_codec_hdmi acpi_cpufreq snd_hda_codec_conexant mperf coretemp processor i2c_algo_bit ideapad_laptop iTCO_wdt 
iTCO_vendor_support bcma(O) battery snd_hda_intel snd_hda_codec psmouse ac snd_hwdep power_supply serio_raw snd_pcm 
sparse_keymap i2c_i801 evdev pcspkr video button i2c_core rfkill snd_page_alloc snd_seq snd_seq_device snd_timer snd 
compat(O) crc32c_intel ghash_clmulni_intel soundcore aesni_intel aes_x86_64 aes_generic cryptd ext4 crc16 jbd2 mbcache 
usbhid hid sg sr_mod cdrom sd_mod crc_t10dif ehci_hcd ahci libahci libata scsi_mod xhci_hcd usbcore usb_common thermal 
thermal_sys [last unloaded: scsi_wait_scan]
[   25.096357] Pid: 2660, comm: NetworkManager Tainted: G         C O 3.2.0-4-amd64 #1 Debian 3.2.32-1
[   25.096358] Call Trace:
[   25.096360]  [<ffffffff81346112>] ? __schedule_bug+0x3e/0x52
[   25.096362]  [<ffffffff8134b27d>] ? __schedule+0x85/0x5c3
[   25.096364]  [<ffffffff8134c399>] ? schedule_hrtimeout_range_clock+0xc0/0x103
[   25.096366]  [<ffffffff81061d7e>] ? update_rmtp+0x62/0x62
[   25.096368]  [<ffffffff810625af>] ? hrtimer_start_expires+0x13/0x15
[   25.096370]  [<ffffffff810519b2>] ? usleep_range+0x39/0x3e
[   25.096374]  [<ffffffffa0482a6d>] ? wlc_lcnphy_rx_iq_cal.constprop.10+0x576/0x9b8 [brcmsmac]
[   25.096378]  [<ffffffffa0483a52>] ? wlc_lcnphy_periodic_cal+0xc0/0x1ae [brcmsmac]
[   25.096381]  [<ffffffffa028fd43>] ? bcma_host_pci_write16+0x11/0x2a [bcma]
[   25.096385]  [<ffffffffa048565f>] ? wlc_phy_init_lcnphy+0xf88/0xf97 [brcmsmac]
[   25.096389]  [<ffffffffa04846d7>] ? wlc_phy_txpower_recalc_target_lcnphy+0x5a/0x5a [brcmsmac]
[   25.096394]  [<ffffffffa047d596>] ? wlc_phy_init+0xe6/0x137 [brcmsmac]
[   25.096398]  [<ffffffffa0473908>] ? brcms_b_bsinit.isra.58+0x120/0x248 [brcmsmac]
[   25.096402]  [<ffffffffa047830c>] ? brcms_c_init+0x83d/0xc41 [brcmsmac]
[   25.096407]  [<ffffffffa0476da3>] ? brcms_c_up+0x26e/0x37e [brcmsmac]
[   25.096410]  [<ffffffffa046f972>] ? brcms_ops_start+0x73/0xb3 [brcmsmac]
[   25.096415]  [<ffffffffa041f4fd>] ? ieee80211_do_open+0x11e/0x5de [mac80211]
[   25.096418]  [<ffffffff8128f6a2>] ? __dev_open+0x8b/0xcc
[   25.096419]  [<ffffffff8128f8ad>] ? __dev_change_flags+0x9d/0x118
[   25.096421]  [<ffffffff8128f98b>] ? dev_change_flags+0x12/0x42
[   25.096423]  [<ffffffff8129966d>] ? do_setlink+0x2ac/0x74d
[   25.096425]  [<ffffffff8129a517>] ? rtnl_newlink+0x24e/0x467
[   25.096427]  [<ffffffff8129a375>] ? rtnl_newlink+0xac/0x467
[   25.096430]  [<ffffffff810eb80e>] ? kmem_cache_alloc_node_trace+0x96/0x10a
[   25.096432]  [<ffffffff8134bfe0>] ? mutex_lock+0xd/0x2d
[   25.096433]  [<ffffffff810709c1>] ? arch_local_irq_save+0x11/0x17
[   25.096435]  [<ffffffff81299e00>] ? rtnl_dellink+0x87/0x10a
[   25.096437]  [<ffffffff81299e8f>] ? __rtnl_unlock+0xc/0xc
[   25.096439]  [<ffffffff812adc57>] ? netlink_rcv_skb+0x36/0x7a
[   25.096441]  [<ffffffff8129927d>] ? rtnetlink_rcv+0x1f/0x28
[   25.096443]  [<ffffffff812ad78e>] ? netlink_unicast+0xe6/0x14e
[   25.096445]  [<ffffffff812ada6a>] ? netlink_sendmsg+0x274/0x2ac
[   25.096447]  [<ffffffff8127d181>] ? sock_sendmsg+0xc1/0xde
[   25.096449]  [<ffffffff8127d060>] ? sock_recvmsg+0xcd/0xec
[   25.096451]  [<ffffffff8127d181>] ? sock_sendmsg+0xc1/0xde
[   25.096453]  [<ffffffff810f1edd>] ? mem_cgroup_update_page_stat+0x17/0xd4
[   25.096455]  [<ffffffff8134b7ff>] ? _cond_resched+0x7/0x1c
[   25.096457]  [<ffffffff810363d8>] ? should_resched+0x5/0x23
[   25.096459]  [<ffffffff8134b7ff>] ? _cond_resched+0x7/0x1c
[   25.096461]  [<ffffffff812864d8>] ? copy_from_user+0x18/0x30
[   25.096462]  [<ffffffff810363d8>] ? should_resched+0x5/0x23
[   25.096464]  [<ffffffff8127d416>] ? __sys_sendmsg+0x1e8/0x288
[   25.096466]  [<ffffffff810cdb5d>] ? pte_offset_kernel+0x16/0x35
[   25.096468]  [<ffffffff810fadc7>] ? fget_light+0x5f/0x73
[   25.096470]  [<ffffffff8127ea24>] ? sys_sendto+0x108/0x137
[   25.096472]  [<ffffffff811099f1>] ? dput+0xe2/0xee
[   25.096474]  [<ffffffff810fadc7>] ? fget_light+0x5f/0x73
[   25.096476]  [<ffffffff8127ed49>] ? sys_sendmsg+0x39/0x58
[   25.096478]  [<ffffffff81351ad2>] ? system_call_fastpath+0x16/0x1b
[   25.097067] BUG: scheduling while atomic: NetworkManager/2660/0x00000200
[   25.097116] Modules linked in: lp(+) parport rfcomm(O) bnep(O) binfmt_misc uinput nfsd nfs nfs_acl auth_rpcgss 
fscache lockd sunrpc loop b43(O) arc4 ssb(O) mmc_core rng_core pcmcia pcmcia_core brcmsmac(O) cordic brcmutil(O) 
mac80211(O) btusb(O) cfg80211(O) bluetooth(O) uvcvideo videodev rts5139(C) v4l2_compat_ioctl32 joydev media 
snd_hda_codec_hdmi acpi_cpufreq snd_hda_codec_conexant mperf coretemp processor i2c_algo_bit ideapad_laptop iTCO_wdt 
iTCO_vendor_support bcma(O) battery snd_hda_intel snd_hda_codec psmouse ac snd_hwdep power_supply serio_raw snd_pcm 
sparse_keymap i2c_i801 evdev pcspkr video button i2c_core rfkill snd_page_alloc snd_seq snd_seq_device snd_timer snd 
compat(O) crc32c_intel ghash_clmulni_intel soundcore aesni_intel aes_x86_64 aes_generic cryptd ext4 crc16 jbd2 mbcache 
usbhid hid sg sr_mod cdrom sd_mod crc_t10dif ehci_hcd ahci libahci libata scsi_mod xhci_hcd usbcore usb_common thermal 
thermal_sys [last unloaded: scsi_wait_scan]
[   25.097148] Pid: 2660, comm: NetworkManager Tainted: G         C O 3.2.0-4-amd64 #1 Debian 3.2.32-1
[   25.097149] Call Trace:
[   25.097151]  [<ffffffff81346112>] ? __schedule_bug+0x3e/0x52
[   25.097153]  [<ffffffff8134b27d>] ? __schedule+0x85/0x5c3
[   25.097155]  [<ffffffff8134c399>] ? schedule_hrtimeout_range_clock+0xc0/0x103
[   25.097157]  [<ffffffff81061d7e>] ? update_rmtp+0x62/0x62
[   25.097159]  [<ffffffff810625af>] ? hrtimer_start_expires+0x13/0x15
[   25.097161]  [<ffffffff810519b2>] ? usleep_range+0x39/0x3e
[   25.097165]  [<ffffffffa0482a25>] ? wlc_lcnphy_rx_iq_cal.constprop.10+0x52e/0x9b8 [brcmsmac]
[   25.097170]  [<ffffffffa0483a52>] ? wlc_lcnphy_periodic_cal+0xc0/0x1ae [brcmsmac]
[   25.097173]  [<ffffffffa028fd43>] ? bcma_host_pci_write16+0x11/0x2a [bcma]
[   25.097177]  [<ffffffffa048565f>] ? wlc_phy_init_lcnphy+0xf88/0xf97 [brcmsmac]
[   25.097181]  [<ffffffffa04846d7>] ? wlc_phy_txpower_recalc_target_lcnphy+0x5a/0x5a [brcmsmac]
[   25.097185]  [<ffffffffa047d596>] ? wlc_phy_init+0xe6/0x137 [brcmsmac]
[   25.097189]  [<ffffffffa0473908>] ? brcms_b_bsinit.isra.58+0x120/0x248 [brcmsmac]
[   25.097194]  [<ffffffffa047830c>] ? brcms_c_init+0x83d/0xc41 [brcmsmac]
[   25.097198]  [<ffffffffa0476da3>] ? brcms_c_up+0x26e/0x37e [brcmsmac]
[   25.097202]  [<ffffffffa046f972>] ? brcms_ops_start+0x73/0xb3 [brcmsmac]
[   25.097207]  [<ffffffffa041f4fd>] ? ieee80211_do_open+0x11e/0x5de [mac80211]
[   25.097209]  [<ffffffff8128f6a2>] ? __dev_open+0x8b/0xcc
[   25.097211]  [<ffffffff8128f8ad>] ? __dev_change_flags+0x9d/0x118
[   25.097213]  [<ffffffff8128f98b>] ? dev_change_flags+0x12/0x42
[   25.097215]  [<ffffffff8129966d>] ? do_setlink+0x2ac/0x74d
[   25.097217]  [<ffffffff8129a517>] ? rtnl_newlink+0x24e/0x467
[   25.097219]  [<ffffffff8129a375>] ? rtnl_newlink+0xac/0x467
[   25.097221]  [<ffffffff810eb80e>] ? kmem_cache_alloc_node_trace+0x96/0x10a
[   25.097223]  [<ffffffff8134bfe0>] ? mutex_lock+0xd/0x2d
[   25.097225]  [<ffffffff810709c1>] ? arch_local_irq_save+0x11/0x17
[   25.097227]  [<ffffffff81299e00>] ? rtnl_dellink+0x87/0x10a
[   25.097228]  [<ffffffff81299e8f>] ? __rtnl_unlock+0xc/0xc
[   25.097230]  [<ffffffff812adc57>] ? netlink_rcv_skb+0x36/0x7a
[   25.097232]  [<ffffffff8129927d>] ? rtnetlink_rcv+0x1f/0x28
[   25.097234]  [<ffffffff812ad78e>] ? netlink_unicast+0xe6/0x14e
[   25.097236]  [<ffffffff812ada6a>] ? netlink_sendmsg+0x274/0x2ac
[   25.097238]  [<ffffffff8127d181>] ? sock_sendmsg+0xc1/0xde
[   25.097240]  [<ffffffff8127d060>] ? sock_recvmsg+0xcd/0xec
[   25.097242]  [<ffffffff8127d181>] ? sock_sendmsg+0xc1/0xde
[   25.097244]  [<ffffffff810f1edd>] ? mem_cgroup_update_page_stat+0x17/0xd4
[   25.097247]  [<ffffffff8134b7ff>] ? _cond_resched+0x7/0x1c
[   25.097248]  [<ffffffff810363d8>] ? should_resched+0x5/0x23
[   25.097250]  [<ffffffff8134b7ff>] ? _cond_resched+0x7/0x1c
[   25.097252]  [<ffffffff812864d8>] ? copy_from_user+0x18/0x30
[   25.097254]  [<ffffffff810363d8>] ? should_resched+0x5/0x23
[   25.097256]  [<ffffffff8127d416>] ? __sys_sendmsg+0x1e8/0x288
[   25.097258]  [<ffffffff810cdb5d>] ? pte_offset_kernel+0x16/0x35
[   25.097260]  [<ffffffff810fadc7>] ? fget_light+0x5f/0x73
[   25.097262]  [<ffffffff8127ea24>] ? sys_sendto+0x108/0x137
[   25.097263]  [<ffffffff811099f1>] ? dput+0xe2/0xee
[   25.097265]  [<ffffffff810fadc7>] ? fget_light+0x5f/0x73
[   25.097267]  [<ffffffff8127ed49>] ? sys_sendmsg+0x39/0x58
[   25.097270]  [<ffffffff81351ad2>] ? system_call_fastpath+0x16/0x1b
[   25.097851] BUG: scheduling while atomic: NetworkManager/2660/0x00000200
[   25.097904] Modules linked in: lp(+) parport rfcomm(O) bnep(O) binfmt_misc uinput nfsd nfs nfs_acl auth_rpcgss 
fscache lockd sunrpc loop b43(O) arc4 ssb(O) mmc_core rng_core pcmcia pcmcia_core brcmsmac(O) cordic brcmutil(O) 
mac80211(O) btusb(O) cfg80211(O) bluetooth(O) uvcvideo videodev rts5139(C) v4l2_compat_ioctl32 joydev media 
snd_hda_codec_hdmi acpi_cpufreq snd_hda_codec_conexant mperf coretemp processor i2c_algo_bit ideapad_laptop iTCO_wdt 
iTCO_vendor_support bcma(O) battery snd_hda_intel snd_hda_codec psmouse ac snd_hwdep power_supply serio_raw snd_pcm 
sparse_keymap i2c_i801 evdev pcspkr video button i2c_core rfkill snd_page_alloc snd_seq snd_seq_device snd_timer snd 
compat(O) crc32c_intel ghash_clmulni_intel soundcore aesni_intel aes_x86_64 aes_generic cryptd ext4 crc16 jbd2 mbcache 
usbhid hid sg sr_mod cdrom sd_mod crc_t10dif ehci_hcd ahci libahci libata scsi_mod xhci_hcd usbcore usb_common thermal 
thermal_sys [last unloaded: scsi_wait_scan]
[   25.097991] Pid: 2660, comm: NetworkManager Tainted: G         C O 3.2.0-4-amd64 #1 Debian 3.2.32-1
[   25.097994] Call Trace:
[   25.097998]  [<ffffffff81346112>] ? __schedule_bug+0x3e/0x52
[   25.098002]  [<ffffffff8134b27d>] ? __schedule+0x85/0x5c3
[   25.098005]  [<ffffffff8134c399>] ? schedule_hrtimeout_range_clock+0xc0/0x103
[   25.098008]  [<ffffffff81061d7e>] ? update_rmtp+0x62/0x62
[   25.098011]  [<ffffffff810625af>] ? hrtimer_start_expires+0x13/0x15
[   25.098015]  [<ffffffff810519b2>] ? usleep_range+0x39/0x3e
[   25.098022]  [<ffffffffa0482a6d>] ? wlc_lcnphy_rx_iq_cal.constprop.10+0x576/0x9b8 [brcmsmac]
[   25.098028]  [<ffffffffa0483a52>] ? wlc_lcnphy_periodic_cal+0xc0/0x1ae [brcmsmac]
[   25.098033]  [<ffffffffa028fd43>] ? bcma_host_pci_write16+0x11/0x2a [bcma]
[   25.098039]  [<ffffffffa048565f>] ? wlc_phy_init_lcnphy+0xf88/0xf97 [brcmsmac]
[   25.098044]  [<ffffffffa04846d7>] ? wlc_phy_txpower_recalc_target_lcnphy+0x5a/0x5a [brcmsmac]
[   25.098051]  [<ffffffffa047d596>] ? wlc_phy_init+0xe6/0x137 [brcmsmac]
[   25.098057]  [<ffffffffa0473908>] ? brcms_b_bsinit.isra.58+0x120/0x248 [brcmsmac]
[   25.098063]  [<ffffffffa047830c>] ? brcms_c_init+0x83d/0xc41 [brcmsmac]
[   25.098069]  [<ffffffffa0476da3>] ? brcms_c_up+0x26e/0x37e [brcmsmac]
[   25.098073]  [<ffffffffa046f972>] ? brcms_ops_start+0x73/0xb3 [brcmsmac]
[   25.098079]  [<ffffffffa041f4fd>] ? ieee80211_do_open+0x11e/0x5de [mac80211]
[   25.098082]  [<ffffffff8128f6a2>] ? __dev_open+0x8b/0xcc
[   25.098084]  [<ffffffff8128f8ad>] ? __dev_change_flags+0x9d/0x118
[   25.098086]  [<ffffffff8128f98b>] ? dev_change_flags+0x12/0x42
[   25.098088]  [<ffffffff8129966d>] ? do_setlink+0x2ac/0x74d
[   25.098090]  [<ffffffff8129a517>] ? rtnl_newlink+0x24e/0x467
[   25.098092]  [<ffffffff8129a375>] ? rtnl_newlink+0xac/0x467
[   25.098095]  [<ffffffff810eb80e>] ? kmem_cache_alloc_node_trace+0x96/0x10a
[   25.098097]  [<ffffffff8134bfe0>] ? mutex_lock+0xd/0x2d
[   25.098099]  [<ffffffff810709c1>] ? arch_local_irq_save+0x11/0x17
[   25.098101]  [<ffffffff81299e00>] ? rtnl_dellink+0x87/0x10a
[   25.098103]  [<ffffffff81299e8f>] ? __rtnl_unlock+0xc/0xc
[   25.098105]  [<ffffffff812adc57>] ? netlink_rcv_skb+0x36/0x7a
[   25.098107]  [<ffffffff8129927d>] ? rtnetlink_rcv+0x1f/0x28
[   25.098109]  [<ffffffff812ad78e>] ? netlink_unicast+0xe6/0x14e
[   25.098111]  [<ffffffff812ada6a>] ? netlink_sendmsg+0x274/0x2ac
[   25.098114]  [<ffffffff8127d181>] ? sock_sendmsg+0xc1/0xde
[   25.098116]  [<ffffffff8127d060>] ? sock_recvmsg+0xcd/0xec
[   25.098118]  [<ffffffff8127d181>] ? sock_sendmsg+0xc1/0xde
[   25.098120]  [<ffffffff810f1edd>] ? mem_cgroup_update_page_stat+0x17/0xd4
[   25.098123]  [<ffffffff8134b7ff>] ? _cond_resched+0x7/0x1c
[   25.098126]  [<ffffffff810363d8>] ? should_resched+0x5/0x23
[   25.098129]  [<ffffffff8134b7ff>] ? _cond_resched+0x7/0x1c
[   25.098132]  [<ffffffff812864d8>] ? copy_from_user+0x18/0x30
[   25.098135]  [<ffffffff810363d8>] ? should_resched+0x5/0x23
[   25.098138]  [<ffffffff8127d416>] ? __sys_sendmsg+0x1e8/0x288
[   25.098141]  [<ffffffff810cdb5d>] ? pte_offset_kernel+0x16/0x35
[   25.098145]  [<ffffffff810fadc7>] ? fget_light+0x5f/0x73
[   25.098148]  [<ffffffff8127ea24>] ? sys_sendto+0x108/0x137
[   25.098151]  [<ffffffff811099f1>] ? dput+0xe2/0xee
[   25.098154]  [<ffffffff810fadc7>] ? fget_light+0x5f/0x73
[   25.098157]  [<ffffffff8127ed49>] ? sys_sendmsg+0x39/0x58
[   25.098160]  [<ffffffff81351ad2>] ? system_call_fastpath+0x16/0x1b
[   25.098643] BUG: scheduling while atomic: NetworkManager/2660/0x00000200
[   25.098697] Modules linked in: lp(+) parport rfcomm(O) bnep(O) binfmt_misc uinput nfsd nfs nfs_acl auth_rpcgss 
fscache lockd sunrpc loop b43(O) arc4 ssb(O) mmc_core rng_core pcmcia pcmcia_core brcmsmac(O) cordic brcmutil(O) 
mac80211(O) btusb(O) cfg80211(O) bluetooth(O) uvcvideo videodev rts5139(C) v4l2_compat_ioctl32 joydev media 
snd_hda_codec_hdmi acpi_cpufreq snd_hda_codec_conexant mperf coretemp processor i2c_algo_bit ideapad_laptop iTCO_wdt 
iTCO_vendor_support bcma(O) battery snd_hda_intel snd_hda_codec psmouse ac snd_hwdep power_supply serio_raw snd_pcm 
sparse_keymap i2c_i801 evdev pcspkr video button i2c_core rfkill snd_page_alloc snd_seq snd_seq_device snd_timer snd 
compat(O) crc32c_intel ghash_clmulni_intel soundcore aesni_intel aes_x86_64 aes_generic cryptd ext4 crc16 jbd2 mbcache 
usbhid hid sg sr_mod cdrom sd_mod crc_t10dif ehci_hcd ahci libahci libata scsi_mod xhci_hcd usbcore usb_common thermal 
thermal_sys [last unloaded: scsi_wait_scan]
[   25.098745] Pid: 2660, comm: NetworkManager Tainted: G         C O 3.2.0-4-amd64 #1 Debian 3.2.32-1
[   25.098747] Call Trace:
[   25.098750]  [<ffffffff81346112>] ? __schedule_bug+0x3e/0x52
[   25.098753]  [<ffffffff8134b27d>] ? __schedule+0x85/0x5c3
[   25.098756]  [<ffffffff8134c399>] ? schedule_hrtimeout_range_clock+0xc0/0x103
[   25.098759]  [<ffffffff81061d7e>] ? update_rmtp+0x62/0x62
[   25.098762]  [<ffffffff810625af>] ? hrtimer_start_expires+0x13/0x15
[   25.098765]  [<ffffffff810519b2>] ? usleep_range+0x39/0x3e
[   25.098772]  [<ffffffffa0482a25>] ? wlc_lcnphy_rx_iq_cal.constprop.10+0x52e/0x9b8 [brcmsmac]
[   25.098778]  [<ffffffffa0483a52>] ? wlc_lcnphy_periodic_cal+0xc0/0x1ae [brcmsmac]
[   25.098783]  [<ffffffffa028fd43>] ? bcma_host_pci_write16+0x11/0x2a [bcma]
[   25.098789]  [<ffffffffa048565f>] ? wlc_phy_init_lcnphy+0xf88/0xf97 [brcmsmac]
[   25.098795]  [<ffffffffa04846d7>] ? wlc_phy_txpower_recalc_target_lcnphy+0x5a/0x5a [brcmsmac]
[   25.098802]  [<ffffffffa047d596>] ? wlc_phy_init+0xe6/0x137 [brcmsmac]
[   25.098809]  [<ffffffffa0473908>] ? brcms_b_bsinit.isra.58+0x120/0x248 [brcmsmac]
[   25.098816]  [<ffffffffa047830c>] ? brcms_c_init+0x83d/0xc41 [brcmsmac]
[   25.098822]  [<ffffffffa0476da3>] ? brcms_c_up+0x26e/0x37e [brcmsmac]
[   25.098827]  [<ffffffffa046f972>] ? brcms_ops_start+0x73/0xb3 [brcmsmac]
[   25.098835]  [<ffffffffa041f4fd>] ? ieee80211_do_open+0x11e/0x5de [mac80211]
[   25.098838]  [<ffffffff8128f6a2>] ? __dev_open+0x8b/0xcc
[   25.098841]  [<ffffffff8128f8ad>] ? __dev_change_flags+0x9d/0x118
[   25.098844]  [<ffffffff8128f98b>] ? dev_change_flags+0x12/0x42
[   25.098847]  [<ffffffff8129966d>] ? do_setlink+0x2ac/0x74d
[   25.098850]  [<ffffffff8129a517>] ? rtnl_newlink+0x24e/0x467
[   25.098853]  [<ffffffff8129a375>] ? rtnl_newlink+0xac/0x467
[   25.098857]  [<ffffffff810eb80e>] ? kmem_cache_alloc_node_trace+0x96/0x10a
[   25.098859]  [<ffffffff8134bfe0>] ? mutex_lock+0xd/0x2d
[   25.098862]  [<ffffffff810709c1>] ? arch_local_irq_save+0x11/0x17
[   25.098864]  [<ffffffff81299e00>] ? rtnl_dellink+0x87/0x10a
[   25.098867]  [<ffffffff81299e8f>] ? __rtnl_unlock+0xc/0xc
[   25.098870]  [<ffffffff812adc57>] ? netlink_rcv_skb+0x36/0x7a
[   25.098873]  [<ffffffff8129927d>] ? rtnetlink_rcv+0x1f/0x28
[   25.098875]  [<ffffffff812ad78e>] ? netlink_unicast+0xe6/0x14e
[   25.098878]  [<ffffffff812ada6a>] ? netlink_sendmsg+0x274/0x2ac
[   25.098882]  [<ffffffff8127d181>] ? sock_sendmsg+0xc1/0xde
[   25.098884]  [<ffffffff8127d060>] ? sock_recvmsg+0xcd/0xec
[   25.098887]  [<ffffffff8127d181>] ? sock_sendmsg+0xc1/0xde
[   25.098890]  [<ffffffff810f1edd>] ? mem_cgroup_update_page_stat+0x17/0xd4
[   25.098894]  [<ffffffff8134b7ff>] ? _cond_resched+0x7/0x1c
[   25.098896]  [<ffffffff810363d8>] ? should_resched+0x5/0x23
[   25.098899]  [<ffffffff8134b7ff>] ? _cond_resched+0x7/0x1c
[   25.098902]  [<ffffffff812864d8>] ? copy_from_user+0x18/0x30
[   25.098904]  [<ffffffff810363d8>] ? should_resched+0x5/0x23
[   25.098907]  [<ffffffff8127d416>] ? __sys_sendmsg+0x1e8/0x288
[   25.098910]  [<ffffffff810cdb5d>] ? pte_offset_kernel+0x16/0x35
[   25.098913]  [<ffffffff810fadc7>] ? fget_light+0x5f/0x73
[   25.098916]  [<ffffffff8127ea24>] ? sys_sendto+0x108/0x137
[   25.098918]  [<ffffffff811099f1>] ? dput+0xe2/0xee
[   25.098921]  [<ffffffff810fadc7>] ? fget_light+0x5f/0x73
[   25.098924]  [<ffffffff8127ed49>] ? sys_sendmsg+0x39/0x58
[   25.098927]  [<ffffffff81351ad2>] ? system_call_fastpath+0x16/0x1b
[   25.099394] BUG: scheduling while atomic: NetworkManager/2660/0x00000200
[   25.099448] Modules linked in: lp(+) parport rfcomm(O) bnep(O) binfmt_misc uinput nfsd nfs nfs_acl auth_rpcgss 
fscache lockd sunrpc loop b43(O) arc4 ssb(O) mmc_core rng_core pcmcia pcmcia_core brcmsmac(O) cordic brcmutil(O) 
mac80211(O) btusb(O) cfg80211(O) bluetooth(O) uvcvideo videodev rts5139(C) v4l2_compat_ioctl32 joydev media 
snd_hda_codec_hdmi acpi_cpufreq snd_hda_codec_conexant mperf coretemp processor i2c_algo_bit ideapad_laptop iTCO_wdt 
iTCO_vendor_support bcma(O) battery snd_hda_intel snd_hda_codec psmouse ac snd_hwdep power_supply serio_raw snd_pcm 
sparse_keymap i2c_i801 evdev pcspkr video button i2c_core rfkill snd_page_alloc snd_seq snd_seq_device snd_timer snd 
compat(O) crc32c_intel ghash_clmulni_intel soundcore aesni_intel aes_x86_64 aes_generic cryptd ext4 crc16 jbd2 mbcache 
usbhid hid sg sr_mod cdrom sd_mod crc_t10dif ehci_hcd ahci libahci libata scsi_mod xhci_hcd usbcore usb_common thermal 
thermal_sys [last unloaded: scsi_wait_scan]
[   25.099496] Pid: 2660, comm: NetworkManager Tainted: G         C O 3.2.0-4-amd64 #1 Debian 3.2.32-1
[   25.099497] Call Trace:
[   25.099500]  [<ffffffff81346112>] ? __schedule_bug+0x3e/0x52
[   25.099503]  [<ffffffff8134b27d>] ? __schedule+0x85/0x5c3
[   25.099506]  [<ffffffff8134c399>] ? schedule_hrtimeout_range_clock+0xc0/0x103
[   25.099509]  [<ffffffff81061d7e>] ? update_rmtp+0x62/0x62
[   25.099511]  [<ffffffff810625af>] ? hrtimer_start_expires+0x13/0x15
[   25.099515]  [<ffffffff810519b2>] ? usleep_range+0x39/0x3e
[   25.099521]  [<ffffffffa0482a6d>] ? wlc_lcnphy_rx_iq_cal.constprop.10+0x576/0x9b8 [brcmsmac]
[   25.099528]  [<ffffffffa0483a52>] ? wlc_lcnphy_periodic_cal+0xc0/0x1ae [brcmsmac]
[   25.099532]  [<ffffffffa028fd43>] ? bcma_host_pci_write16+0x11/0x2a [bcma]
[   25.099538]  [<ffffffffa048565f>] ? wlc_phy_init_lcnphy+0xf88/0xf97 [brcmsmac]
[   25.099544]  [<ffffffffa04846d7>] ? wlc_phy_txpower_recalc_target_lcnphy+0x5a/0x5a [brcmsmac]
[   25.099551]  [<ffffffffa047d596>] ? wlc_phy_init+0xe6/0x137 [brcmsmac]
[   25.099557]  [<ffffffffa0473908>] ? brcms_b_bsinit.isra.58+0x120/0x248 [brcmsmac]
[   25.099564]  [<ffffffffa047830c>] ? brcms_c_init+0x83d/0xc41 [brcmsmac]
[   25.099570]  [<ffffffffa0476da3>] ? brcms_c_up+0x26e/0x37e [brcmsmac]
[   25.099576]  [<ffffffffa046f972>] ? brcms_ops_start+0x73/0xb3 [brcmsmac]
[   25.099583]  [<ffffffffa041f4fd>] ? ieee80211_do_open+0x11e/0x5de [mac80211]
[   25.099587]  [<ffffffff8128f6a2>] ? __dev_open+0x8b/0xcc
[   25.099589]  [<ffffffff8128f8ad>] ? __dev_change_flags+0x9d/0x118
[   25.099592]  [<ffffffff8128f98b>] ? dev_change_flags+0x12/0x42
[   25.099595]  [<ffffffff8129966d>] ? do_setlink+0x2ac/0x74d
[   25.099598]  [<ffffffff8129a517>] ? rtnl_newlink+0x24e/0x467
[   25.099600]  [<ffffffff8129a375>] ? rtnl_newlink+0xac/0x467
[   25.099605]  [<ffffffff810eb80e>] ? kmem_cache_alloc_node_trace+0x96/0x10a
[   25.099607]  [<ffffffff8134bfe0>] ? mutex_lock+0xd/0x2d
[   25.099610]  [<ffffffff810709c1>] ? arch_local_irq_save+0x11/0x17
[   25.099612]  [<ffffffff81299e00>] ? rtnl_dellink+0x87/0x10a
[   25.099615]  [<ffffffff81299e8f>] ? __rtnl_unlock+0xc/0xc
[   25.099618]  [<ffffffff812adc57>] ? netlink_rcv_skb+0x36/0x7a
[   25.099620]  [<ffffffff8129927d>] ? rtnetlink_rcv+0x1f/0x28
[   25.099623]  [<ffffffff812ad78e>] ? netlink_unicast+0xe6/0x14e
[   25.099626]  [<ffffffff812ada6a>] ? netlink_sendmsg+0x274/0x2ac
[   25.099629]  [<ffffffff8127d181>] ? sock_sendmsg+0xc1/0xde
[   25.099632]  [<ffffffff8127d060>] ? sock_recvmsg+0xcd/0xec
[   25.099635]  [<ffffffff8127d181>] ? sock_sendmsg+0xc1/0xde
[   25.099638]  [<ffffffff810f1edd>] ? mem_cgroup_update_page_stat+0x17/0xd4
[   25.099641]  [<ffffffff8134b7ff>] ? _cond_resched+0x7/0x1c
[   25.099644]  [<ffffffff810363d8>] ? should_resched+0x5/0x23
[   25.099647]  [<ffffffff8134b7ff>] ? _cond_resched+0x7/0x1c
[   25.099650]  [<ffffffff812864d8>] ? copy_from_user+0x18/0x30
[   25.099652]  [<ffffffff810363d8>] ? should_resched+0x5/0x23
[   25.099655]  [<ffffffff8127d416>] ? __sys_sendmsg+0x1e8/0x288
[   25.099658]  [<ffffffff810cdb5d>] ? pte_offset_kernel+0x16/0x35
[   25.099661]  [<ffffffff810fadc7>] ? fget_light+0x5f/0x73
[   25.099663]  [<ffffffff8127ea24>] ? sys_sendto+0x108/0x137
[   25.099666]  [<ffffffff811099f1>] ? dput+0xe2/0xee
[   25.099669]  [<ffffffff810fadc7>] ? fget_light+0x5f/0x73
[   25.099672]  [<ffffffff8127ed49>] ? sys_sendmsg+0x39/0x58
[   25.099675]  [<ffffffff81351ad2>] ? system_call_fastpath+0x16/0x1b
[   25.100186] BUG: scheduling while atomic: NetworkManager/2660/0x00000200
[   25.100240] Modules linked in: lp(+) parport rfcomm(O) bnep(O) binfmt_misc uinput nfsd nfs nfs_acl auth_rpcgss 
fscache lockd sunrpc loop b43(O) arc4 ssb(O) mmc_core rng_core pcmcia pcmcia_core brcmsmac(O) cordic brcmutil(O) 
mac80211(O) btusb(O) cfg80211(O) bluetooth(O) uvcvideo videodev rts5139(C) v4l2_compat_ioctl32 joydev media 
snd_hda_codec_hdmi acpi_cpufreq snd_hda_codec_conexant mperf coretemp processor i2c_algo_bit ideapad_laptop iTCO_wdt 
iTCO_vendor_support bcma(O) battery snd_hda_intel snd_hda_codec psmouse ac snd_hwdep power_supply serio_raw snd_pcm 
sparse_keymap i2c_i801 evdev pcspkr video button i2c_core rfkill snd_page_alloc snd_seq snd_seq_device snd_timer snd 
compat(O) crc32c_intel ghash_clmulni_intel soundcore aesni_intel aes_x86_64 aes_generic cryptd ext4 crc16 jbd2 mbcache 
usbhid hid sg sr_mod cdrom sd_mod crc_t10dif ehci_hcd ahci libahci libata scsi_mod xhci_hcd usbcore usb_common thermal 
thermal_sys [last unloaded: scsi_wait_scan]
[   25.100288] Pid: 2660, comm: NetworkManager Tainted: G         C O 3.2.0-4-amd64 #1 Debian 3.2.32-1
[   25.100289] Call Trace:
[   25.100292]  [<ffffffff81346112>] ? __schedule_bug+0x3e/0x52
[   25.100295]  [<ffffffff8134b27d>] ? __schedule+0x85/0x5c3
[   25.100298]  [<ffffffff8134c399>] ? schedule_hrtimeout_range_clock+0xc0/0x103
[   25.100301]  [<ffffffff81061d7e>] ? update_rmtp+0x62/0x62
[   25.100303]  [<ffffffff810625af>] ? hrtimer_start_expires+0x13/0x15
[   25.100307]  [<ffffffff810519b2>] ? usleep_range+0x39/0x3e
[   25.100313]  [<ffffffffa0482a25>] ? wlc_lcnphy_rx_iq_cal.constprop.10+0x52e/0x9b8 [brcmsmac]
[   25.100319]  [<ffffffffa0483a52>] ? wlc_lcnphy_periodic_cal+0xc0/0x1ae [brcmsmac]
[   25.100324]  [<ffffffffa028fd43>] ? bcma_host_pci_write16+0x11/0x2a [bcma]
[   25.100330]  [<ffffffffa048565f>] ? wlc_phy_init_lcnphy+0xf88/0xf97 [brcmsmac]
[   25.100336]  [<ffffffffa04846d7>] ? wlc_phy_txpower_recalc_target_lcnphy+0x5a/0x5a [brcmsmac]
[   25.100343]  [<ffffffffa047d596>] ? wlc_phy_init+0xe6/0x137 [brcmsmac]
[   25.100349]  [<ffffffffa0473908>] ? brcms_b_bsinit.isra.58+0x120/0x248 [brcmsmac]
[   25.100355]  [<ffffffffa047830c>] ? brcms_c_init+0x83d/0xc41 [brcmsmac]
[   25.100362]  [<ffffffffa0476da3>] ? brcms_c_up+0x26e/0x37e [brcmsmac]
[   25.100367]  [<ffffffffa046f972>] ? brcms_ops_start+0x73/0xb3 [brcmsmac]
[   25.100374]  [<ffffffffa041f4fd>] ? ieee80211_do_open+0x11e/0x5de [mac80211]
[   25.100378]  [<ffffffff8128f6a2>] ? __dev_open+0x8b/0xcc
[   25.100381]  [<ffffffff8128f8ad>] ? __dev_change_flags+0x9d/0x118
[   25.100384]  [<ffffffff8128f98b>] ? dev_change_flags+0x12/0x42
[   25.100386]  [<ffffffff8129966d>] ? do_setlink+0x2ac/0x74d
[   25.100389]  [<ffffffff8129a517>] ? rtnl_newlink+0x24e/0x467
[   25.100392]  [<ffffffff8129a375>] ? rtnl_newlink+0xac/0x467
[   25.100396]  [<ffffffff810eb80e>] ? kmem_cache_alloc_node_trace+0x96/0x10a
[   25.100398]  [<ffffffff8134bfe0>] ? mutex_lock+0xd/0x2d
[   25.100401]  [<ffffffff810709c1>] ? arch_local_irq_save+0x11/0x17
[   25.100404]  [<ffffffff81299e00>] ? rtnl_dellink+0x87/0x10a
[   25.100406]  [<ffffffff81299e8f>] ? __rtnl_unlock+0xc/0xc
[   25.100409]  [<ffffffff812adc57>] ? netlink_rcv_skb+0x36/0x7a
[   25.100412]  [<ffffffff8129927d>] ? rtnetlink_rcv+0x1f/0x28
[   25.100415]  [<ffffffff812ad78e>] ? netlink_unicast+0xe6/0x14e
[   25.100418]  [<ffffffff812ada6a>] ? netlink_sendmsg+0x274/0x2ac
[   25.100421]  [<ffffffff8127d181>] ? sock_sendmsg+0xc1/0xde
[   25.100423]  [<ffffffff8127d060>] ? sock_recvmsg+0xcd/0xec
[   25.100426]  [<ffffffff8127d181>] ? sock_sendmsg+0xc1/0xde
[   25.100430]  [<ffffffff810f1edd>] ? mem_cgroup_update_page_stat+0x17/0xd4
[   25.100433]  [<ffffffff8134b7ff>] ? _cond_resched+0x7/0x1c
[   25.100435]  [<ffffffff810363d8>] ? should_resched+0x5/0x23
[   25.100438]  [<ffffffff8134b7ff>] ? _cond_resched+0x7/0x1c
[   25.100441]  [<ffffffff812864d8>] ? copy_from_user+0x18/0x30
[   25.100443]  [<ffffffff810363d8>] ? should_resched+0x5/0x23
[   25.100446]  [<ffffffff8127d416>] ? __sys_sendmsg+0x1e8/0x288
[   25.100449]  [<ffffffff810cdb5d>] ? pte_offset_kernel+0x16/0x35
[   25.100452]  [<ffffffff810fadc7>] ? fget_light+0x5f/0x73
[   25.100455]  [<ffffffff8127ea24>] ? sys_sendto+0x108/0x137
[   25.100458]  [<ffffffff811099f1>] ? dput+0xe2/0xee
[   25.100460]  [<ffffffff810fadc7>] ? fget_light+0x5f/0x73
[   25.100463]  [<ffffffff8127ed49>] ? sys_sendmsg+0x39/0x58
[   25.100466]  [<ffffffff81351ad2>] ? system_call_fastpath+0x16/0x1b
[   25.100935] BUG: scheduling while atomic: NetworkManager/2660/0x00000200
[   25.100989] Modules linked in: lp(+) parport rfcomm(O) bnep(O) binfmt_misc uinput nfsd nfs nfs_acl auth_rpcgss 
fscache lockd sunrpc loop b43(O) arc4 ssb(O) mmc_core rng_core pcmcia pcmcia_core brcmsmac(O) cordic brcmutil(O) 
mac80211(O) btusb(O) cfg80211(O) bluetooth(O) uvcvideo videodev rts5139(C) v4l2_compat_ioctl32 joydev media 
snd_hda_codec_hdmi acpi_cpufreq snd_hda_codec_conexant mperf coretemp processor i2c_algo_bit ideapad_laptop iTCO_wdt 
iTCO_vendor_support bcma(O) battery snd_hda_intel snd_hda_codec psmouse ac snd_hwdep power_supply serio_raw snd_pcm 
sparse_keymap i2c_i801 evdev pcspkr video button i2c_core rfkill snd_page_alloc snd_seq snd_seq_device snd_timer snd 
compat(O) crc32c_intel ghash_clmulni_intel soundcore aesni_intel aes_x86_64 aes_generic cryptd ext4 crc16 jbd2 mbcache 
usbhid hid sg sr_mod cdrom sd_mod crc_t10dif ehci_hcd ahci libahci libata scsi_mod xhci_hcd usbcore usb_common thermal 
thermal_sys [last unloaded: scsi_wait_scan]
[   25.101037] Pid: 2660, comm: NetworkManager Tainted: G         C O 3.2.0-4-amd64 #1 Debian 3.2.32-1
[   25.101038] Call Trace:
[   25.101041]  [<ffffffff81346112>] ? __schedule_bug+0x3e/0x52
[   25.101044]  [<ffffffff8134b27d>] ? __schedule+0x85/0x5c3
[   25.101047]  [<ffffffff8134c399>] ? schedule_hrtimeout_range_clock+0xc0/0x103
[   25.101050]  [<ffffffff81061d7e>] ? update_rmtp+0x62/0x62
[   25.101053]  [<ffffffff810625af>] ? hrtimer_start_expires+0x13/0x15
[   25.101056]  [<ffffffff810519b2>] ? usleep_range+0x39/0x3e
[   25.101062]  [<ffffffffa0482a6d>] ? wlc_lcnphy_rx_iq_cal.constprop.10+0x576/0x9b8 [brcmsmac]
[   25.101069]  [<ffffffffa0483a52>] ? wlc_lcnphy_periodic_cal+0xc0/0x1ae [brcmsmac]
[   25.101073]  [<ffffffffa028fd43>] ? bcma_host_pci_write16+0x11/0x2a [bcma]
[   25.101079]  [<ffffffffa048565f>] ? wlc_phy_init_lcnphy+0xf88/0xf97 [brcmsmac]
[   25.101085]  [<ffffffffa04846d7>] ? wlc_phy_txpower_recalc_target_lcnphy+0x5a/0x5a [brcmsmac]
[   25.101092]  [<ffffffffa047d596>] ? wlc_phy_init+0xe6/0x137 [brcmsmac]
[   25.101098]  [<ffffffffa0473908>] ? brcms_b_bsinit.isra.58+0x120/0x248 [brcmsmac]
[   25.101104]  [<ffffffffa047830c>] ? brcms_c_init+0x83d/0xc41 [brcmsmac]
[   25.101111]  [<ffffffffa0476da3>] ? brcms_c_up+0x26e/0x37e [brcmsmac]
[   25.101116]  [<ffffffffa046f972>] ? brcms_ops_start+0x73/0xb3 [brcmsmac]
[   25.101123]  [<ffffffffa041f4fd>] ? ieee80211_do_open+0x11e/0x5de [mac80211]
[   25.101127]  [<ffffffff8128f6a2>] ? __dev_open+0x8b/0xcc
[   25.101130]  [<ffffffff8128f8ad>] ? __dev_change_flags+0x9d/0x118
[   25.101133]  [<ffffffff8128f98b>] ? dev_change_flags+0x12/0x42
[   25.101135]  [<ffffffff8129966d>] ? do_setlink+0x2ac/0x74d
[   25.101138]  [<ffffffff8129a517>] ? rtnl_newlink+0x24e/0x467
[   25.101141]  [<ffffffff8129a375>] ? rtnl_newlink+0xac/0x467
[   25.101145]  [<ffffffff810eb80e>] ? kmem_cache_alloc_node_trace+0x96/0x10a
[   25.101147]  [<ffffffff8134bfe0>] ? mutex_lock+0xd/0x2d
[   25.101150]  [<ffffffff810709c1>] ? arch_local_irq_save+0x11/0x17
[   25.101152]  [<ffffffff81299e00>] ? rtnl_dellink+0x87/0x10a
[   25.101155]  [<ffffffff81299e8f>] ? __rtnl_unlock+0xc/0xc
[   25.101158]  [<ffffffff812adc57>] ? netlink_rcv_skb+0x36/0x7a
[   25.101161]  [<ffffffff8129927d>] ? rtnetlink_rcv+0x1f/0x28
[   25.101164]  [<ffffffff812ad78e>] ? netlink_unicast+0xe6/0x14e
[   25.101167]  [<ffffffff812ada6a>] ? netlink_sendmsg+0x274/0x2ac
[   25.101170]  [<ffffffff8127d181>] ? sock_sendmsg+0xc1/0xde
[   25.101172]  [<ffffffff8127d060>] ? sock_recvmsg+0xcd/0xec
[   25.101175]  [<ffffffff8127d181>] ? sock_sendmsg+0xc1/0xde
[   25.101179]  [<ffffffff810f1edd>] ? mem_cgroup_update_page_stat+0x17/0xd4
[   25.101182]  [<ffffffff8134b7ff>] ? _cond_resched+0x7/0x1c
[   25.101184]  [<ffffffff810363d8>] ? should_resched+0x5/0x23
[   25.101188]  [<ffffffff8134b7ff>] ? _cond_resched+0x7/0x1c
[   25.101190]  [<ffffffff812864d8>] ? copy_from_user+0x18/0x30
[   25.101193]  [<ffffffff810363d8>] ? should_resched+0x5/0x23
[   25.101196]  [<ffffffff8127d416>] ? __sys_sendmsg+0x1e8/0x288
[   25.101198]  [<ffffffff810cdb5d>] ? pte_offset_kernel+0x16/0x35
[   25.101201]  [<ffffffff810fadc7>] ? fget_light+0x5f/0x73
[   25.101204]  [<ffffffff8127ea24>] ? sys_sendto+0x108/0x137
[   25.101207]  [<ffffffff811099f1>] ? dput+0xe2/0xee
[   25.101210]  [<ffffffff810fadc7>] ? fget_light+0x5f/0x73
[   25.101212]  [<ffffffff8127ed49>] ? sys_sendmsg+0x39/0x58
[   25.101216]  [<ffffffff81351ad2>] ? system_call_fastpath+0x16/0x1b
[   25.101756] BUG: scheduling while atomic: NetworkManager/2660/0x00000200
[   25.103001] Modules linked in: lp(+) parport rfcomm(O) bnep(O) binfmt_misc uinput nfsd nfs nfs_acl auth_rpcgss 
fscache lockd sunrpc loop b43(O) arc4 ssb(O) mmc_core rng_core pcmcia pcmcia_core brcmsmac(O) cordic brcmutil(O) 
mac80211(O) btusb(O) cfg80211(O) bluetooth(O) uvcvideo videodev rts5139(C) v4l2_compat_ioctl32 joydev media 
snd_hda_codec_hdmi acpi_cpufreq snd_hda_codec_conexant mperf coretemp processor i2c_algo_bit ideapad_laptop iTCO_wdt 
iTCO_vendor_support bcma(O) battery snd_hda_intel snd_hda_codec psmouse ac snd_hwdep power_supply serio_raw snd_pcm 
sparse_keymap i2c_i801 evdev pcspkr video button i2c_core rfkill snd_page_alloc snd_seq snd_seq_device snd_timer snd 
compat(O) crc32c_intel ghash_clmulni_intel soundcore aesni_intel aes_x86_64 aes_generic cryptd ext4 crc16 jbd2 mbcache 
usbhid hid sg sr_mod cdrom sd_mod crc_t10dif ehci_hcd ahci libahci libata scsi_mod xhci_hcd usbcore usb_common thermal 
thermal_sys [last unloaded: scsi_wait_scan]
[   25.103037] Pid: 2660, comm: NetworkManager Tainted: G         C O 3.2.0-4-amd64 #1 Debian 3.2.32-1
[   25.103038] Call Trace:
[   25.103041]  [<ffffffff81346112>] ? __schedule_bug+0x3e/0x52
[   25.103044]  [<ffffffff8134b27d>] ? __schedule+0x85/0x5c3
[   25.103046]  [<ffffffff8134c399>] ? schedule_hrtimeout_range_clock+0xc0/0x103
[   25.103048]  [<ffffffff81061d7e>] ? update_rmtp+0x62/0x62
[   25.103050]  [<ffffffff810625af>] ? hrtimer_start_expires+0x13/0x15
[   25.103052]  [<ffffffff810519b2>] ? usleep_range+0x39/0x3e
[   25.103058]  [<ffffffffa0482a25>] ? wlc_lcnphy_rx_iq_cal.constprop.10+0x52e/0x9b8 [brcmsmac]
[   25.103063]  [<ffffffffa0483a52>] ? wlc_lcnphy_periodic_cal+0xc0/0x1ae [brcmsmac]
[   25.103066]  [<ffffffffa028fd43>] ? bcma_host_pci_write16+0x11/0x2a [bcma]
[   25.103070]  [<ffffffffa048565f>] ? wlc_phy_init_lcnphy+0xf88/0xf97 [brcmsmac]
[   25.103075]  [<ffffffffa04846d7>] ? wlc_phy_txpower_recalc_target_lcnphy+0x5a/0x5a [brcmsmac]
[   25.103080]  [<ffffffffa047d596>] ? wlc_phy_init+0xe6/0x137 [brcmsmac]
[   25.103084]  [<ffffffffa0473908>] ? brcms_b_bsinit.isra.58+0x120/0x248 [brcmsmac]
[   25.103089]  [<ffffffffa047830c>] ? brcms_c_init+0x83d/0xc41 [brcmsmac]
[   25.103094]  [<ffffffffa0476da3>] ? brcms_c_up+0x26e/0x37e [brcmsmac]
[   25.103097]  [<ffffffffa046f972>] ? brcms_ops_start+0x73/0xb3 [brcmsmac]
[   25.103103]  [<ffffffffa041f4fd>] ? ieee80211_do_open+0x11e/0x5de [mac80211]
[   25.103106]  [<ffffffff8128f6a2>] ? __dev_open+0x8b/0xcc
[   25.103107]  [<ffffffff8128f8ad>] ? __dev_change_flags+0x9d/0x118
[   25.103110]  [<ffffffff8128f98b>] ? dev_change_flags+0x12/0x42
[   25.103111]  [<ffffffff8129966d>] ? do_setlink+0x2ac/0x74d
[   25.103114]  [<ffffffff8129a517>] ? rtnl_newlink+0x24e/0x467
[   25.103115]  [<ffffffff8129a375>] ? rtnl_newlink+0xac/0x467
[   25.103118]  [<ffffffff810eb80e>] ? kmem_cache_alloc_node_trace+0x96/0x10a
[   25.103120]  [<ffffffff8134bfe0>] ? mutex_lock+0xd/0x2d
[   25.103122]  [<ffffffff810709c1>] ? arch_local_irq_save+0x11/0x17
[   25.103124]  [<ffffffff81299e00>] ? rtnl_dellink+0x87/0x10a
[   25.103126]  [<ffffffff81299e8f>] ? __rtnl_unlock+0xc/0xc
[   25.103128]  [<ffffffff812adc57>] ? netlink_rcv_skb+0x36/0x7a
[   25.103129]  [<ffffffff8129927d>] ? rtnetlink_rcv+0x1f/0x28
[   25.103131]  [<ffffffff812ad78e>] ? netlink_unicast+0xe6/0x14e
[   25.103134]  [<ffffffff812ada6a>] ? netlink_sendmsg+0x274/0x2ac
[   25.103136]  [<ffffffff8127d181>] ? sock_sendmsg+0xc1/0xde
[   25.103138]  [<ffffffff8127d060>] ? sock_recvmsg+0xcd/0xec
[   25.103140]  [<ffffffff8127d181>] ? sock_sendmsg+0xc1/0xde
[   25.103142]  [<ffffffff810f1edd>] ? mem_cgroup_update_page_stat+0x17/0xd4
[   25.103144]  [<ffffffff8134b7ff>] ? _cond_resched+0x7/0x1c
[   25.103146]  [<ffffffff810363d8>] ? should_resched+0x5/0x23
[   25.103148]  [<ffffffff8134b7ff>] ? _cond_resched+0x7/0x1c
[   25.103150]  [<ffffffff812864d8>] ? copy_from_user+0x18/0x30
[   25.103152]  [<ffffffff810363d8>] ? should_resched+0x5/0x23
[   25.103154]  [<ffffffff8127d416>] ? __sys_sendmsg+0x1e8/0x288
[   25.103156]  [<ffffffff810cdb5d>] ? pte_offset_kernel+0x16/0x35
[   25.103158]  [<ffffffff810fadc7>] ? fget_light+0x5f/0x73
[   25.103160]  [<ffffffff8127ea24>] ? sys_sendto+0x108/0x137
[   25.103162]  [<ffffffff811099f1>] ? dput+0xe2/0xee
[   25.103163]  [<ffffffff810fadc7>] ? fget_light+0x5f/0x73
[   25.103165]  [<ffffffff8127ed49>] ? sys_sendmsg+0x39/0x58
[   25.103168]  [<ffffffff81351ad2>] ? system_call_fastpath+0x16/0x1b
[   25.103417] BUG: scheduling while atomic: NetworkManager/2660/0x00000200
[   25.103466] Modules linked in: lp(+) parport rfcomm(O) bnep(O) binfmt_misc uinput nfsd nfs nfs_acl auth_rpcgss 
fscache lockd sunrpc loop b43(O) arc4 ssb(O) mmc_core rng_core pcmcia pcmcia_core brcmsmac(O) cordic brcmutil(O) 
mac80211(O) btusb(O) cfg80211(O) bluetooth(O) uvcvideo videodev rts5139(C) v4l2_compat_ioctl32 joydev media 
snd_hda_codec_hdmi acpi_cpufreq snd_hda_codec_conexant mperf coretemp processor i2c_algo_bit ideapad_laptop iTCO_wdt 
iTCO_vendor_support bcma(O) battery snd_hda_intel snd_hda_codec psmouse ac snd_hwdep power_supply serio_raw snd_pcm 
sparse_keymap i2c_i801 evdev pcspkr video button i2c_core rfkill snd_page_alloc snd_seq snd_seq_device snd_timer snd 
compat(O) crc32c_intel ghash_clmulni_intel soundcore aesni_intel aes_x86_64 aes_generic cryptd ext4 crc16 jbd2 mbcache 
usbhid hid sg sr_mod cdrom sd_mod crc_t10dif ehci_hcd ahci libahci libata scsi_mod xhci_hcd usbcore usb_common thermal 
thermal_sys [last unloaded: scsi_wait_scan]
[   25.103498] Pid: 2660, comm: NetworkManager Tainted: G         C O 3.2.0-4-amd64 #1 Debian 3.2.32-1
[   25.103500] Call Trace:
[   25.103501]  [<ffffffff81346112>] ? __schedule_bug+0x3e/0x52
[   25.103503]  [<ffffffff8134b27d>] ? __schedule+0x85/0x5c3
[   25.103505]  [<ffffffff8134c399>] ? schedule_hrtimeout_range_clock+0xc0/0x103
[   25.103507]  [<ffffffff81061d7e>] ? update_rmtp+0x62/0x62
[   25.103509]  [<ffffffff810625af>] ? hrtimer_start_expires+0x13/0x15
[   25.103512]  [<ffffffff810519b2>] ? usleep_range+0x39/0x3e
[   25.103516]  [<ffffffffa0482a6d>] ? wlc_lcnphy_rx_iq_cal.constprop.10+0x576/0x9b8 [brcmsmac]
[   25.103521]  [<ffffffffa0483a52>] ? wlc_lcnphy_periodic_cal+0xc0/0x1ae [brcmsmac]
[   25.103524]  [<ffffffffa028fd43>] ? bcma_host_pci_write16+0x11/0x2a [bcma]
[   25.103528]  [<ffffffffa048565f>] ? wlc_phy_init_lcnphy+0xf88/0xf97 [brcmsmac]
[   25.103532]  [<ffffffffa04846d7>] ? wlc_phy_txpower_recalc_target_lcnphy+0x5a/0x5a [brcmsmac]
[   25.103537]  [<ffffffffa047d596>] ? wlc_phy_init+0xe6/0x137 [brcmsmac]
[   25.103541]  [<ffffffffa0473908>] ? brcms_b_bsinit.isra.58+0x120/0x248 [brcmsmac]
[   25.103546]  [<ffffffffa047830c>] ? brcms_c_init+0x83d/0xc41 [brcmsmac]
[   25.103550]  [<ffffffffa0476da3>] ? brcms_c_up+0x26e/0x37e [brcmsmac]
[   25.103554]  [<ffffffffa046f972>] ? brcms_ops_start+0x73/0xb3 [brcmsmac]
[   25.103559]  [<ffffffffa041f4fd>] ? ieee80211_do_open+0x11e/0x5de [mac80211]
[   25.103562]  [<ffffffff8128f6a2>] ? __dev_open+0x8b/0xcc
[   25.103564]  [<ffffffff8128f8ad>] ? __dev_change_flags+0x9d/0x118
[   25.103566]  [<ffffffff8128f98b>] ? dev_change_flags+0x12/0x42
[   25.103567]  [<ffffffff8129966d>] ? do_setlink+0x2ac/0x74d
[   25.103570]  [<ffffffff8129a517>] ? rtnl_newlink+0x24e/0x467
[   25.103571]  [<ffffffff8129a375>] ? rtnl_newlink+0xac/0x467
[   25.103574]  [<ffffffff810eb80e>] ? kmem_cache_alloc_node_trace+0x96/0x10a
[   25.103576]  [<ffffffff8134bfe0>] ? mutex_lock+0xd/0x2d
[   25.103578]  [<ffffffff810709c1>] ? arch_local_irq_save+0x11/0x17
[   25.103579]  [<ffffffff81299e00>] ? rtnl_dellink+0x87/0x10a
[   25.103581]  [<ffffffff81299e8f>] ? __rtnl_unlock+0xc/0xc
[   25.103584]  [<ffffffff812adc57>] ? netlink_rcv_skb+0x36/0x7a
[   25.103586]  [<ffffffff8129927d>] ? rtnetlink_rcv+0x1f/0x28
[   25.103588]  [<ffffffff812ad78e>] ? netlink_unicast+0xe6/0x14e
[   25.103591]  [<ffffffff812ada6a>] ? netlink_sendmsg+0x274/0x2ac
[   25.103594]  [<ffffffff8127d181>] ? sock_sendmsg+0xc1/0xde
[   25.103597]  [<ffffffff8127d060>] ? sock_recvmsg+0xcd/0xec
[   25.103600]  [<ffffffff8127d181>] ? sock_sendmsg+0xc1/0xde
[   25.103602]  [<ffffffff810f1edd>] ? mem_cgroup_update_page_stat+0x17/0xd4
[   25.103605]  [<ffffffff8134b7ff>] ? _cond_resched+0x7/0x1c
[   25.103607]  [<ffffffff810363d8>] ? should_resched+0x5/0x23
[   25.103610]  [<ffffffff8134b7ff>] ? _cond_resched+0x7/0x1c
[   25.103612]  [<ffffffff812864d8>] ? copy_from_user+0x18/0x30
[   25.103614]  [<ffffffff810363d8>] ? should_resched+0x5/0x23
[   25.103617]  [<ffffffff8127d416>] ? __sys_sendmsg+0x1e8/0x288
[   25.103619]  [<ffffffff810cdb5d>] ? pte_offset_kernel+0x16/0x35
[   25.103622]  [<ffffffff810fadc7>] ? fget_light+0x5f/0x73
[   25.103624]  [<ffffffff8127ea24>] ? sys_sendto+0x108/0x137
[   25.103627]  [<ffffffff811099f1>] ? dput+0xe2/0xee
[   25.103629]  [<ffffffff810fadc7>] ? fget_light+0x5f/0x73
[   25.103632]  [<ffffffff8127ed49>] ? sys_sendmsg+0x39/0x58
[   25.103635]  [<ffffffff81351ad2>] ? system_call_fastpath+0x16/0x1b
[   25.104224] BUG: scheduling while atomic: NetworkManager/2660/0x00000200
[   25.104276] Modules linked in: lp(+) parport rfcomm(O) bnep(O) binfmt_misc uinput nfsd nfs nfs_acl auth_rpcgss 
fscache lockd sunrpc loop b43(O) arc4 ssb(O) mmc_core rng_core pcmcia pcmcia_core brcmsmac(O) cordic brcmutil(O) 
mac80211(O) btusb(O) cfg80211(O) bluetooth(O) uvcvideo videodev rts5139(C) v4l2_compat_ioctl32 joydev media 
snd_hda_codec_hdmi acpi_cpufreq snd_hda_codec_conexant mperf coretemp processor i2c_algo_bit ideapad_laptop iTCO_wdt 
iTCO_vendor_support bcma(O) battery snd_hda_intel snd_hda_codec psmouse ac snd_hwdep power_supply serio_raw snd_pcm 
sparse_keymap i2c_i801 evdev pcspkr video button i2c_core rfkill snd_page_alloc snd_seq snd_seq_device snd_timer snd 
compat(O) crc32c_intel ghash_clmulni_intel soundcore aesni_intel aes_x86_64 aes_generic cryptd ext4 crc16 jbd2 mbcache 
usbhid hid sg sr_mod cdrom sd_mod crc_t10dif ehci_hcd ahci libahci libata scsi_mod xhci_hcd usbcore usb_common thermal 
thermal_sys [last unloaded: scsi_wait_scan]
[   25.104325] Pid: 2660, comm: NetworkManager Tainted: G         C O 3.2.0-4-amd64 #1 Debian 3.2.32-1
[   25.104327] Call Trace:
[   25.104330]  [<ffffffff81346112>] ? __schedule_bug+0x3e/0x52
[   25.104334]  [<ffffffff8134b27d>] ? __schedule+0x85/0x5c3
[   25.104337]  [<ffffffff8134c399>] ? schedule_hrtimeout_range_clock+0xc0/0x103
[   25.104340]  [<ffffffff81061d7e>] ? update_rmtp+0x62/0x62
[   25.104342]  [<ffffffff810625af>] ? hrtimer_start_expires+0x13/0x15
[   25.104346]  [<ffffffff810519b2>] ? usleep_range+0x39/0x3e
[   25.104353]  [<ffffffffa0482a25>] ? wlc_lcnphy_rx_iq_cal.constprop.10+0x52e/0x9b8 [brcmsmac]
[   25.104359]  [<ffffffffa0483a52>] ? wlc_lcnphy_periodic_cal+0xc0/0x1ae [brcmsmac]
[   25.104365]  [<ffffffffa028fd43>] ? bcma_host_pci_write16+0x11/0x2a [bcma]
[   25.104371]  [<ffffffffa048565f>] ? wlc_phy_init_lcnphy+0xf88/0xf97 [brcmsmac]
[   25.104378]  [<ffffffffa04846d7>] ? wlc_phy_txpower_recalc_target_lcnphy+0x5a/0x5a [brcmsmac]
[   25.104385]  [<ffffffffa047d596>] ? wlc_phy_init+0xe6/0x137 [brcmsmac]
[   25.104392]  [<ffffffffa0473908>] ? brcms_b_bsinit.isra.58+0x120/0x248 [brcmsmac]
[   25.104399]  [<ffffffffa047830c>] ? brcms_c_init+0x83d/0xc41 [brcmsmac]
[   25.104406]  [<ffffffffa0476da3>] ? brcms_c_up+0x26e/0x37e [brcmsmac]
[   25.104411]  [<ffffffffa046f972>] ? brcms_ops_start+0x73/0xb3 [brcmsmac]
[   25.104420]  [<ffffffffa041f4fd>] ? ieee80211_do_open+0x11e/0x5de [mac80211]
[   25.104423]  [<ffffffff8128f6a2>] ? __dev_open+0x8b/0xcc
[   25.104426]  [<ffffffff8128f8ad>] ? __dev_change_flags+0x9d/0x118
[   25.104429]  [<ffffffff8128f98b>] ? dev_change_flags+0x12/0x42
[   25.104432]  [<ffffffff8129966d>] ? do_setlink+0x2ac/0x74d
[   25.104435]  [<ffffffff8129a517>] ? rtnl_newlink+0x24e/0x467
[   25.104437]  [<ffffffff8129a375>] ? rtnl_newlink+0xac/0x467
[   25.104441]  [<ffffffff810eb80e>] ? kmem_cache_alloc_node_trace+0x96/0x10a
[   25.104444]  [<ffffffff8134bfe0>] ? mutex_lock+0xd/0x2d
[   25.104447]  [<ffffffff810709c1>] ? arch_local_irq_save+0x11/0x17
[   25.104449]  [<ffffffff81299e00>] ? rtnl_dellink+0x87/0x10a
[   25.104452]  [<ffffffff81299e8f>] ? __rtnl_unlock+0xc/0xc
[   25.104455]  [<ffffffff812adc57>] ? netlink_rcv_skb+0x36/0x7a
[   25.104458]  [<ffffffff8129927d>] ? rtnetlink_rcv+0x1f/0x28
[   25.104461]  [<ffffffff812ad78e>] ? netlink_unicast+0xe6/0x14e
[   25.104464]  [<ffffffff812ada6a>] ? netlink_sendmsg+0x274/0x2ac
[   25.104467]  [<ffffffff8127d181>] ? sock_sendmsg+0xc1/0xde
[   25.104470]  [<ffffffff8127d060>] ? sock_recvmsg+0xcd/0xec
[   25.104473]  [<ffffffff8127d181>] ? sock_sendmsg+0xc1/0xde
[   25.104476]  [<ffffffff810f1edd>] ? mem_cgroup_update_page_stat+0x17/0xd4
[   25.104480]  [<ffffffff8134b7ff>] ? _cond_resched+0x7/0x1c
[   25.104482]  [<ffffffff810363d8>] ? should_resched+0x5/0x23
[   25.104485]  [<ffffffff8134b7ff>] ? _cond_resched+0x7/0x1c
[   25.104488]  [<ffffffff812864d8>] ? copy_from_user+0x18/0x30
[   25.104491]  [<ffffffff810363d8>] ? should_resched+0x5/0x23
[   25.104494]  [<ffffffff8127d416>] ? __sys_sendmsg+0x1e8/0x288
[   25.104497]  [<ffffffff810cdb5d>] ? pte_offset_kernel+0x16/0x35
[   25.104500]  [<ffffffff810fadc7>] ? fget_light+0x5f/0x73
[   25.104503]  [<ffffffff8127ea24>] ? sys_sendto+0x108/0x137
[   25.104505]  [<ffffffff811099f1>] ? dput+0xe2/0xee
[   25.104508]  [<ffffffff810fadc7>] ? fget_light+0x5f/0x73
[   25.104511]  [<ffffffff8127ed49>] ? sys_sendmsg+0x39/0x58
[   25.104514]  [<ffffffff81351ad2>] ? system_call_fastpath+0x16/0x1b
[   25.104985] BUG: scheduling while atomic: NetworkManager/2660/0x00000200
[   25.105036] Modules linked in: lp(+) parport rfcomm(O) bnep(O) binfmt_misc uinput nfsd nfs nfs_acl auth_rpcgss 
fscache lockd sunrpc loop b43(O) arc4 ssb(O) mmc_core rng_core pcmcia pcmcia_core brcmsmac(O) cordic brcmutil(O) 
mac80211(O) btusb(O) cfg80211(O) bluetooth(O) uvcvideo videodev rts5139(C) v4l2_compat_ioctl32 joydev media 
snd_hda_codec_hdmi acpi_cpufreq snd_hda_codec_conexant mperf coretemp processor i2c_algo_bit ideapad_laptop iTCO_wdt 
iTCO_vendor_support bcma(O) battery snd_hda_intel snd_hda_codec psmouse ac snd_hwdep power_supply serio_raw snd_pcm 
sparse_keymap i2c_i801 evdev pcspkr video button i2c_core rfkill snd_page_alloc snd_seq snd_seq_device snd_timer snd 
compat(O) crc32c_intel ghash_clmulni_intel soundcore aesni_intel aes_x86_64 aes_generic cryptd ext4 crc16 jbd2 mbcache 
usbhid hid sg sr_mod cdrom sd_mod crc_t10dif ehci_hcd ahci libahci libata scsi_mod xhci_hcd usbcore usb_common thermal 
thermal_sys [last unloaded: scsi_wait_scan]
[   25.105085] Pid: 2660, comm: NetworkManager Tainted: G         C O 3.2.0-4-amd64 #1 Debian 3.2.32-1
[   25.105087] Call Trace:
[   25.105090]  [<ffffffff81346112>] ? __schedule_bug+0x3e/0x52
[   25.105093]  [<ffffffff8134b27d>] ? __schedule+0x85/0x5c3
[   25.105096]  [<ffffffff8134c399>] ? schedule_hrtimeout_range_clock+0xc0/0x103
[   25.105098]  [<ffffffff81061d7e>] ? update_rmtp+0x62/0x62
[   25.105101]  [<ffffffff810625af>] ? hrtimer_start_expires+0x13/0x15
[   25.105105]  [<ffffffff810519b2>] ? usleep_range+0x39/0x3e
[   25.105112]  [<ffffffffa0482a6d>] ? wlc_lcnphy_rx_iq_cal.constprop.10+0x576/0x9b8 [brcmsmac]
[   25.105119]  [<ffffffffa0483a52>] ? wlc_lcnphy_periodic_cal+0xc0/0x1ae [brcmsmac]
[   25.105124]  [<ffffffffa028fd43>] ? bcma_host_pci_write16+0x11/0x2a [bcma]
[   25.105131]  [<ffffffffa048565f>] ? wlc_phy_init_lcnphy+0xf88/0xf97 [brcmsmac]
[   25.105138]  [<ffffffffa04846d7>] ? wlc_phy_txpower_recalc_target_lcnphy+0x5a/0x5a [brcmsmac]
[   25.105145]  [<ffffffffa047d596>] ? wlc_phy_init+0xe6/0x137 [brcmsmac]
[   25.105151]  [<ffffffffa0473908>] ? brcms_b_bsinit.isra.58+0x120/0x248 [brcmsmac]
[   25.105158]  [<ffffffffa047830c>] ? brcms_c_init+0x83d/0xc41 [brcmsmac]
[   25.105165]  [<ffffffffa0476da3>] ? brcms_c_up+0x26e/0x37e [brcmsmac]
[   25.105171]  [<ffffffffa046f972>] ? brcms_ops_start+0x73/0xb3 [brcmsmac]
[   25.105179]  [<ffffffffa041f4fd>] ? ieee80211_do_open+0x11e/0x5de [mac80211]
[   25.105182]  [<ffffffff8128f6a2>] ? __dev_open+0x8b/0xcc
[   25.105185]  [<ffffffff8128f8ad>] ? __dev_change_flags+0x9d/0x118
[   25.105188]  [<ffffffff8128f98b>] ? dev_change_flags+0x12/0x42
[   25.105190]  [<ffffffff8129966d>] ? do_setlink+0x2ac/0x74d
[   25.105194]  [<ffffffff8129a517>] ? rtnl_newlink+0x24e/0x467
[   25.105196]  [<ffffffff8129a375>] ? rtnl_newlink+0xac/0x467
[   25.105200]  [<ffffffff810eb80e>] ? kmem_cache_alloc_node_trace+0x96/0x10a
[   25.105203]  [<ffffffff8134bfe0>] ? mutex_lock+0xd/0x2d
[   25.105206]  [<ffffffff810709c1>] ? arch_local_irq_save+0x11/0x17
[   25.105209]  [<ffffffff81299e00>] ? rtnl_dellink+0x87/0x10a
[   25.105211]  [<ffffffff81299e8f>] ? __rtnl_unlock+0xc/0xc
[   25.105214]  [<ffffffff812adc57>] ? netlink_rcv_skb+0x36/0x7a
[   25.105217]  [<ffffffff8129927d>] ? rtnetlink_rcv+0x1f/0x28
[   25.105220]  [<ffffffff812ad78e>] ? netlink_unicast+0xe6/0x14e
[   25.105223]  [<ffffffff812ada6a>] ? netlink_sendmsg+0x274/0x2ac
[   25.105226]  [<ffffffff8127d181>] ? sock_sendmsg+0xc1/0xde
[   25.105229]  [<ffffffff8127d060>] ? sock_recvmsg+0xcd/0xec
[   25.105232]  [<ffffffff8127d181>] ? sock_sendmsg+0xc1/0xde
[   25.105235]  [<ffffffff810f1edd>] ? mem_cgroup_update_page_stat+0x17/0xd4
[   25.105239]  [<ffffffff8134b7ff>] ? _cond_resched+0x7/0x1c
[   25.105241]  [<ffffffff810363d8>] ? should_resched+0x5/0x23
[   25.105244]  [<ffffffff8134b7ff>] ? _cond_resched+0x7/0x1c
[   25.105247]  [<ffffffff812864d8>] ? copy_from_user+0x18/0x30
[   25.105249]  [<ffffffff810363d8>] ? should_resched+0x5/0x23
[   25.105253]  [<ffffffff8127d416>] ? __sys_sendmsg+0x1e8/0x288
[   25.105256]  [<ffffffff810cdb5d>] ? pte_offset_kernel+0x16/0x35
[   25.105259]  [<ffffffff810fadc7>] ? fget_light+0x5f/0x73
[   25.105262]  [<ffffffff8127ea24>] ? sys_sendto+0x108/0x137
[   25.105265]  [<ffffffff811099f1>] ? dput+0xe2/0xee
[   25.105267]  [<ffffffff810fadc7>] ? fget_light+0x5f/0x73
[   25.105270]  [<ffffffff8127ed49>] ? sys_sendmsg+0x39/0x58
[   25.105274]  [<ffffffff81351ad2>] ? system_call_fastpath+0x16/0x1b
[   25.109090] brcmsmac bcma0:0: brcms_ops_bss_info_changed: qos enabled: false (implement)
[   25.109160] brcmsmac bcma0:0: brcms_ops_config: change power-save mode: false (implement)
[   25.110461] ADDRCONF(NETDEV_UP): wlan0: link is not ready
[   25.419389] lp: driver loaded but no devices found
[   25.513164] brcmsmac bcma0:0: phyerr 0x20, rate 0xa
[   25.537999] ppdev: user-space parallel port driver
[   27.078410] drm: Unknown symbol ktime_get_monotonic_offset (err 0)
[   27.231365] wlan0: authenticate with 20:2b:c1:9a:a8:e0
[   27.237825] wlan0: send auth to 20:2b:c1:9a:a8:e0 (try 1/3)
[   27.239389] wlan0: authenticated
[   27.243034] wlan0: associate with 20:2b:c1:9a:a8:e0 (try 1/3)
[   27.246782] wlan0: RX AssocResp from 20:2b:c1:9a:a8:e0 (capab=0x411 status=0 aid=1)
[   27.247257] brcmsmac bcma0:0: brcmsmac: brcms_ops_bss_info_changed: associated
[   27.247261] brcmsmac bcma0:0: brcms_ops_bss_info_changed: arp filtering: enabled true, count 0 (implement)
[   27.247264] brcmsmac bcma0:0: brcms_ops_bss_info_changed: qos enabled: true (implement)
[   27.247271] wlan0: associated
[   27.247886] ADDRCONF(NETDEV_CHANGE): wlan0: link becomes ready
[   27.247964] cfg80211: Calling CRDA for country: CZ
[   27.250547] cfg80211: Regulatory domain changed to country: CZ
[   27.250550] cfg80211:   (start_freq - end_freq @ bandwidth), (max_antenna_gain, max_eirp)
[   27.250552] cfg80211:   (2400000 KHz - 2483500 KHz @ 40000 KHz), (N/A, 2000 mBm)
[   27.250553] cfg80211:   (5150000 KHz - 5250000 KHz @ 40000 KHz), (N/A, 2301 mBm)
[   27.250555] cfg80211:   (5250000 KHz - 5350000 KHz @ 40000 KHz), (N/A, 2000 mBm)
[   27.250557] cfg80211:   (5470000 KHz - 5725000 KHz @ 40000 KHz), (N/A, 2698 mBm)
[   34.031660] wlan0: deauthenticated from 20:2b:c1:9a:a8:e0 (Reason: 15)
[   34.031687] brcmsmac bcma0:0: brcmsmac: brcms_ops_bss_info_changed: disassociated
[   34.031693] brcmsmac bcma0:0: brcms_ops_bss_info_changed: arp filtering: enabled false, count 0 (implement)
[   34.031696] brcmsmac bcma0:0: brcms_ops_bss_info_changed: qos enabled: false (implement)
[   34.033166] cfg80211: Calling CRDA to update world regulatory domain
[   34.037744] cfg80211: World regulatory domain updated:
[   34.037749] cfg80211:   (start_freq - end_freq @ bandwidth), (max_antenna_gain, max_eirp)
[   34.037755] cfg80211:   (2402000 KHz - 2472000 KHz @ 40000 KHz), (300 mBi, 2000 mBm)
[   34.037760] cfg80211:   (2457000 KHz - 2482000 KHz @ 20000 KHz), (300 mBi, 2000 mBm)
[   34.037764] cfg80211:   (2474000 KHz - 2494000 KHz @ 20000 KHz), (300 mBi, 2000 mBm)
[   34.037768] cfg80211:   (5170000 KHz - 5250000 KHz @ 40000 KHz), (300 mBi, 2000 mBm)
[   34.037772] cfg80211:   (5735000 KHz - 5835000 KHz @ 40000 KHz), (300 mBi, 2000 mBm)
[   34.999134] wlan0: authenticate with 20:2b:c1:9a:a8:e0
[   35.002097] wlan0: send auth to 20:2b:c1:9a:a8:e0 (try 1/3)
[   35.005903] wlan0: authenticated
[   35.006496] wlan0: associate with 20:2b:c1:9a:a8:e0 (try 1/3)
[   35.011046] wlan0: RX AssocResp from 20:2b:c1:9a:a8:e0 (capab=0x411 status=0 aid=1)
[   35.011499] brcmsmac bcma0:0: brcmsmac: brcms_ops_bss_info_changed: associated
[   35.011507] brcmsmac bcma0:0: brcms_ops_bss_info_changed: arp filtering: enabled true, count 0 (implement)
[   35.011512] brcmsmac bcma0:0: brcms_ops_bss_info_changed: qos enabled: true (implement)
[   35.011526] wlan0: associated
[   35.012565] cfg80211: Calling CRDA for country: CZ
[   35.018021] cfg80211: Regulatory domain changed to country: CZ
[   35.018026] cfg80211:   (start_freq - end_freq @ bandwidth), (max_antenna_gain, max_eirp)
[   35.018031] cfg80211:   (2400000 KHz - 2483500 KHz @ 40000 KHz), (N/A, 2000 mBm)
[   35.018036] cfg80211:   (5150000 KHz - 5250000 KHz @ 40000 KHz), (N/A, 2301 mBm)
[   35.018039] cfg80211:   (5250000 KHz - 5350000 KHz @ 40000 KHz), (N/A, 2000 mBm)
[   35.018043] cfg80211:   (5470000 KHz - 5725000 KHz @ 40000 KHz), (N/A, 2698 mBm)
[   42.042736] wlan0: deauthenticated from 20:2b:c1:9a:a8:e0 (Reason: 15)
[   42.042776] brcmsmac bcma0:0: brcmsmac: brcms_ops_bss_info_changed: disassociated
[   42.042785] brcmsmac bcma0:0: brcms_ops_bss_info_changed: arp filtering: enabled false, count 0 (implement)
[   42.042789] brcmsmac bcma0:0: brcms_ops_bss_info_changed: qos enabled: false (implement)
[   42.044171] cfg80211: Calling CRDA to update world regulatory domain
[   42.049362] cfg80211: World regulatory domain updated:
[   42.049368] cfg80211:   (start_freq - end_freq @ bandwidth), (max_antenna_gain, max_eirp)
[   42.049373] cfg80211:   (2402000 KHz - 2472000 KHz @ 40000 KHz), (300 mBi, 2000 mBm)
[   42.049378] cfg80211:   (2457000 KHz - 2482000 KHz @ 20000 KHz), (300 mBi, 2000 mBm)
[   42.049382] cfg80211:   (2474000 KHz - 2494000 KHz @ 20000 KHz), (300 mBi, 2000 mBm)
[   42.049386] cfg80211:   (5170000 KHz - 5250000 KHz @ 40000 KHz), (300 mBi, 2000 mBm)
[   42.049390] cfg80211:   (5735000 KHz - 5835000 KHz @ 40000 KHz), (300 mBi, 2000 mBm)
[   43.010168] wlan0: authenticate with 20:2b:c1:9a:a8:e0
[   43.013152] wlan0: send auth to 20:2b:c1:9a:a8:e0 (try 1/3)
[   43.014662] wlan0: authenticated
[   43.017716] wlan0: associate with 20:2b:c1:9a:a8:e0 (try 1/3)
[   43.021425] wlan0: RX AssocResp from 20:2b:c1:9a:a8:e0 (capab=0x411 status=0 aid=1)
[   43.022014] brcmsmac bcma0:0: brcmsmac: brcms_ops_bss_info_changed: associated
[   43.022022] brcmsmac bcma0:0: brcms_ops_bss_info_changed: arp filtering: enabled true, count 0 (implement)
[   43.022027] brcmsmac bcma0:0: brcms_ops_bss_info_changed: qos enabled: true (implement)
[   43.022039] wlan0: associated
[   43.023051] cfg80211: Calling CRDA for country: CZ
[   43.028223] cfg80211: Regulatory domain changed to country: CZ
[   43.028229] cfg80211:   (start_freq - end_freq @ bandwidth), (max_antenna_gain, max_eirp)
[   43.028234] cfg80211:   (2400000 KHz - 2483500 KHz @ 40000 KHz), (N/A, 2000 mBm)
[   43.028238] cfg80211:   (5150000 KHz - 5250000 KHz @ 40000 KHz), (N/A, 2301 mBm)
[   43.028242] cfg80211:   (5250000 KHz - 5350000 KHz @ 40000 KHz), (N/A, 2000 mBm)
[   43.028245] cfg80211:   (5470000 KHz - 5725000 KHz @ 40000 KHz), (N/A, 2698 mBm)
[   50.041772] wlan0: deauthenticated from 20:2b:c1:9a:a8:e0 (Reason: 15)
[   50.041810] brcmsmac bcma0:0: brcmsmac: brcms_ops_bss_info_changed: disassociated
[   50.041820] brcmsmac bcma0:0: brcms_ops_bss_info_changed: arp filtering: enabled false, count 0 (implement)
[   50.041825] brcmsmac bcma0:0: brcms_ops_bss_info_changed: qos enabled: false (implement)
[   50.043352] cfg80211: Calling CRDA to update world regulatory domain
[   50.047820] cfg80211: World regulatory domain updated:
[   50.047825] cfg80211:   (start_freq - end_freq @ bandwidth), (max_antenna_gain, max_eirp)
[   50.047831] cfg80211:   (2402000 KHz - 2472000 KHz @ 40000 KHz), (300 mBi, 2000 mBm)
[   50.047835] cfg80211:   (2457000 KHz - 2482000 KHz @ 20000 KHz), (300 mBi, 2000 mBm)
[   50.047839] cfg80211:   (2474000 KHz - 2494000 KHz @ 20000 KHz), (300 mBi, 2000 mBm)
[   50.047843] cfg80211:   (5170000 KHz - 5250000 KHz @ 40000 KHz), (300 mBi, 2000 mBm)
[   50.047847] cfg80211:   (5735000 KHz - 5835000 KHz @ 40000 KHz), (300 mBi, 2000 mBm)
[   51.009531] wlan0: authenticate with 20:2b:c1:9a:a8:e0
[   51.012510] wlan0: send auth to 20:2b:c1:9a:a8:e0 (try 1/3)
[   51.014035] wlan0: authenticated
[   51.016892] wlan0: associate with 20:2b:c1:9a:a8:e0 (try 1/3)
[   51.020717] wlan0: RX AssocResp from 20:2b:c1:9a:a8:e0 (capab=0x411 status=0 aid=1)
[   51.021353] brcmsmac bcma0:0: brcmsmac: brcms_ops_bss_info_changed: associated
[   51.021358] brcmsmac bcma0:0: brcms_ops_bss_info_changed: arp filtering: enabled true, count 0 (implement)
[   51.021361] brcmsmac bcma0:0: brcms_ops_bss_info_changed: qos enabled: true (implement)
[   51.021370] wlan0: associated
[   51.022370] cfg80211: Calling CRDA for country: CZ
[   51.026021] cfg80211: Regulatory domain changed to country: CZ
[   51.026023] cfg80211:   (start_freq - end_freq @ bandwidth), (max_antenna_gain, max_eirp)
[   51.026025] cfg80211:   (2400000 KHz - 2483500 KHz @ 40000 KHz), (N/A, 2000 mBm)
[   51.026027] cfg80211:   (5150000 KHz - 5250000 KHz @ 40000 KHz), (N/A, 2301 mBm)
[   51.026029] cfg80211:   (5250000 KHz - 5350000 KHz @ 40000 KHz), (N/A, 2000 mBm)
[   51.026030] cfg80211:   (5470000 KHz - 5725000 KHz @ 40000 KHz), (N/A, 2698 mBm)
[   51.173701] wlan0: deauthenticating from 20:2b:c1:9a:a8:e0 by local choice (reason=3)
[   51.180744] brcmsmac bcma0:0: brcmsmac: brcms_ops_bss_info_changed: disassociated
[   51.180759] brcmsmac bcma0:0: brcms_ops_bss_info_changed: arp filtering: enabled false, count 0 (implement)
[   51.180764] brcmsmac bcma0:0: brcms_ops_bss_info_changed: qos enabled: false (implement)
[   51.183359] cfg80211: Calling CRDA to update world regulatory domain
[   51.189151] cfg80211: World regulatory domain updated:
[   51.189156] cfg80211:   (start_freq - end_freq @ bandwidth), (max_antenna_gain, max_eirp)
[   51.189162] cfg80211:   (2402000 KHz - 2472000 KHz @ 40000 KHz), (300 mBi, 2000 mBm)
[   51.189167] cfg80211:   (2457000 KHz - 2482000 KHz @ 20000 KHz), (300 mBi, 2000 mBm)
[   51.189171] cfg80211:   (2474000 KHz - 2494000 KHz @ 20000 KHz), (300 mBi, 2000 mBm)
[   51.189175] cfg80211:   (5170000 KHz - 5250000 KHz @ 40000 KHz), (300 mBi, 2000 mBm)
[   51.189179] cfg80211:   (5735000 KHz - 5835000 KHz @ 40000 KHz), (300 mBi, 2000 mBm)
[   56.179650] wlan0: authenticate with 20:2b:c1:9a:a8:e0
[   56.182686] wlan0: send auth to 20:2b:c1:9a:a8:e0 (try 1/3)
[   56.184225] wlan0: authenticated
[   56.187201] wlan0: associate with 20:2b:c1:9a:a8:e0 (try 1/3)
[   56.191100] wlan0: RX AssocResp from 20:2b:c1:9a:a8:e0 (capab=0x411 status=0 aid=1)
[   56.191725] brcmsmac bcma0:0: brcmsmac: brcms_ops_bss_info_changed: associated
[   56.191729] brcmsmac bcma0:0: brcms_ops_bss_info_changed: arp filtering: enabled true, count 0 (implement)
[   56.191731] brcmsmac bcma0:0: brcms_ops_bss_info_changed: qos enabled: true (implement)
[   56.191734] wlan0: associated
[   56.192166] cfg80211: Calling CRDA for country: CZ
[   56.197076] cfg80211: Regulatory domain changed to country: CZ
[   56.197082] cfg80211:   (start_freq - end_freq @ bandwidth), (max_antenna_gain, max_eirp)
[   56.197087] cfg80211:   (2400000 KHz - 2483500 KHz @ 40000 KHz), (N/A, 2000 mBm)
[   56.197092] cfg80211:   (5150000 KHz - 5250000 KHz @ 40000 KHz), (N/A, 2301 mBm)
[   56.197095] cfg80211:   (5250000 KHz - 5350000 KHz @ 40000 KHz), (N/A, 2000 mBm)
[   56.197099] cfg80211:   (5470000 KHz - 5725000 KHz @ 40000 KHz), (N/A, 2698 mBm)
[   62.725768] wlan0: deauthenticated from 20:2b:c1:9a:a8:e0 (Reason: 15)
[   62.725803] brcmsmac bcma0:0: brcmsmac: brcms_ops_bss_info_changed: disassociated
[   62.725810] brcmsmac bcma0:0: brcms_ops_bss_info_changed: arp filtering: enabled false, count 0 (implement)
[   62.725814] brcmsmac bcma0:0: brcms_ops_bss_info_changed: qos enabled: false (implement)
[   62.726543] cfg80211: Calling CRDA to update world regulatory domain
[   62.730426] cfg80211: World regulatory domain updated:
[   62.730428] cfg80211:   (start_freq - end_freq @ bandwidth), (max_antenna_gain, max_eirp)
[   62.730431] cfg80211:   (2402000 KHz - 2472000 KHz @ 40000 KHz), (300 mBi, 2000 mBm)
[   62.730432] cfg80211:   (2457000 KHz - 2482000 KHz @ 20000 KHz), (300 mBi, 2000 mBm)
[   62.730434] cfg80211:   (2474000 KHz - 2494000 KHz @ 20000 KHz), (300 mBi, 2000 mBm)
[   62.730436] cfg80211:   (5170000 KHz - 5250000 KHz @ 40000 KHz), (300 mBi, 2000 mBm)
[   62.730437] cfg80211:   (5735000 KHz - 5835000 KHz @ 40000 KHz), (300 mBi, 2000 mBm)
[   63.691527] wlan0: authenticate with 20:2b:c1:9a:a8:e0
[   63.694453] wlan0: send auth to 20:2b:c1:9a:a8:e0 (try 1/3)
[   63.695975] wlan0: authenticated
[   63.698957] wlan0: associate with 20:2b:c1:9a:a8:e0 (try 1/3)
[   63.702838] wlan0: RX AssocResp from 20:2b:c1:9a:a8:e0 (capab=0x411 status=0 aid=1)
[   63.703440] brcmsmac bcma0:0: brcmsmac: brcms_ops_bss_info_changed: associated
[   63.703448] brcmsmac bcma0:0: brcms_ops_bss_info_changed: arp filtering: enabled true, count 0 (implement)
[   63.703452] brcmsmac bcma0:0: brcms_ops_bss_info_changed: qos enabled: true (implement)
[   63.703464] wlan0: associated
[   63.704470] cfg80211: Calling CRDA for country: CZ
[   63.709686] cfg80211: Regulatory domain changed to country: CZ
[   63.709692] cfg80211:   (start_freq - end_freq @ bandwidth), (max_antenna_gain, max_eirp)
[   63.709697] cfg80211:   (2400000 KHz - 2483500 KHz @ 40000 KHz), (N/A, 2000 mBm)
[   63.709701] cfg80211:   (5150000 KHz - 5250000 KHz @ 40000 KHz), (N/A, 2301 mBm)
[   63.709705] cfg80211:   (5250000 KHz - 5350000 KHz @ 40000 KHz), (N/A, 2000 mBm)
[   63.709709] cfg80211:   (5470000 KHz - 5725000 KHz @ 40000 KHz), (N/A, 2698 mBm)
[   70.038621] wlan0: deauthenticated from 20:2b:c1:9a:a8:e0 (Reason: 15)
[   70.038660] brcmsmac bcma0:0: brcmsmac: brcms_ops_bss_info_changed: disassociated
[   70.038668] brcmsmac bcma0:0: brcms_ops_bss_info_changed: arp filtering: enabled false, count 0 (implement)
[   70.038673] brcmsmac bcma0:0: brcms_ops_bss_info_changed: qos enabled: false (implement)
[   70.039394] cfg80211: Calling CRDA to update world regulatory domain
[   70.044898] cfg80211: World regulatory domain updated:
[   70.044903] cfg80211:   (start_freq - end_freq @ bandwidth), (max_antenna_gain, max_eirp)
[   70.044908] cfg80211:   (2402000 KHz - 2472000 KHz @ 40000 KHz), (300 mBi, 2000 mBm)
[   70.044913] cfg80211:   (2457000 KHz - 2482000 KHz @ 20000 KHz), (300 mBi, 2000 mBm)
[   70.044917] cfg80211:   (2474000 KHz - 2494000 KHz @ 20000 KHz), (300 mBi, 2000 mBm)
[   70.044921] cfg80211:   (5170000 KHz - 5250000 KHz @ 40000 KHz), (300 mBi, 2000 mBm)
[   70.044925] cfg80211:   (5735000 KHz - 5835000 KHz @ 40000 KHz), (300 mBi, 2000 mBm)
[   71.003418] wlan0: authenticate with 20:2b:c1:9a:a8:e0
[   71.006399] wlan0: send auth to 20:2b:c1:9a:a8:e0 (try 1/3)
[   71.010353] wlan0: authenticated
[   71.010925] wlan0: associate with 20:2b:c1:9a:a8:e0 (try 1/3)
[   71.014803] wlan0: RX AssocResp from 20:2b:c1:9a:a8:e0 (capab=0x411 status=0 aid=1)
[   71.015390] brcmsmac bcma0:0: brcmsmac: brcms_ops_bss_info_changed: associated
[   71.015398] brcmsmac bcma0:0: brcms_ops_bss_info_changed: arp filtering: enabled true, count 0 (implement)
[   71.015403] brcmsmac bcma0:0: brcms_ops_bss_info_changed: qos enabled: true (implement)
[   71.015413] wlan0: associated
[   71.016422] cfg80211: Calling CRDA for country: CZ
[   71.021613] cfg80211: Regulatory domain changed to country: CZ
[   71.021619] cfg80211:   (start_freq - end_freq @ bandwidth), (max_antenna_gain, max_eirp)
[   71.021624] cfg80211:   (2400000 KHz - 2483500 KHz @ 40000 KHz), (N/A, 2000 mBm)
[   71.021628] cfg80211:   (5150000 KHz - 5250000 KHz @ 40000 KHz), (N/A, 2301 mBm)
[   71.021632] cfg80211:   (5250000 KHz - 5350000 KHz @ 40000 KHz), (N/A, 2000 mBm)
[   71.021636] cfg80211:   (5470000 KHz - 5725000 KHz @ 40000 KHz), (N/A, 2698 mBm)
[   72.117750] usb 1-2: new high-speed USB device number 2 using xhci_hcd
[   72.134913] xhci_hcd 0000:00:14.0: WARN: short transfer on control ep
[   72.135532] xhci_hcd 0000:00:14.0: WARN: short transfer on control ep
[   72.136175] xhci_hcd 0000:00:14.0: WARN: short transfer on control ep
[   72.137195] xhci_hcd 0000:00:14.0: WARN: short transfer on control ep
[   72.137221] usb 1-2: New USB device found, idVendor=0951, idProduct=1654
[   72.137226] usb 1-2: New USB device strings: Mfr=1, Product=2, SerialNumber=3
[   72.137230] usb 1-2: Product: DT R500
[   72.137233] usb 1-2: Manufacturer: Kingston
[   72.137236] usb 1-2: SerialNumber: 0018F30C9EBFBC10C1170012
[   72.137458] usb 1-2: ep 0x81 - rounding interval to 32768 microframes, ep desc says 0 microframes
[   72.137466] usb 1-2: ep 0x2 - rounding interval to 32768 microframes, ep desc says 0 microframes
[   72.195008] usbcore: registered new interface driver uas
[   72.205392] Initializing USB Mass Storage driver...
[   72.205653] scsi7 : usb-storage 1-2:1.0
[   72.205782] usbcore: registered new interface driver usb-storage
[   72.205783] USB Mass Storage support registered.
[   73.244035] scsi 7:0:0:0: Direct-Access     Kingston DT R500          PMAP PQ: 0 ANSI: 0 CCS
[   73.245743] sd 7:0:0:0: Attached scsi generic sg3 type 0
[   75.479869] sd 7:0:0:0: [sdc] 31244288 512-byte logical blocks: (15.9 GB/14.8 GiB)
[   75.480106] sd 7:0:0:0: [sdc] Write Protect is off
[   75.480115] sd 7:0:0:0: [sdc] Mode Sense: 23 00 00 00
[   75.480356] sd 7:0:0:0: [sdc] No Caching mode page present
[   75.480365] sd 7:0:0:0: [sdc] Assuming drive cache: write through
[   75.482047] sd 7:0:0:0: [sdc] No Caching mode page present
[   75.482054] sd 7:0:0:0: [sdc] Assuming drive cache: write through
[   75.515543]  sdc: sdc1
[   75.516691] sd 7:0:0:0: [sdc] No Caching mode page present
[   75.516698] sd 7:0:0:0: [sdc] Assuming drive cache: write through
[   75.516702] sd 7:0:0:0: [sdc] Attached SCSI removable disk
[   77.862754] wlan0: deauthenticated from 20:2b:c1:9a:a8:e0 (Reason: 15)
[   77.862794] brcmsmac bcma0:0: brcmsmac: brcms_ops_bss_info_changed: disassociated
[   77.862803] brcmsmac bcma0:0: brcms_ops_bss_info_changed: arp filtering: enabled false, count 0 (implement)
[   77.862808] brcmsmac bcma0:0: brcms_ops_bss_info_changed: qos enabled: false (implement)
[   77.863604] cfg80211: Calling CRDA to update world regulatory domain
[   77.868951] cfg80211: World regulatory domain updated:
[   77.868956] cfg80211:   (start_freq - end_freq @ bandwidth), (max_antenna_gain, max_eirp)
[   77.868962] cfg80211:   (2402000 KHz - 2472000 KHz @ 40000 KHz), (300 mBi, 2000 mBm)
[   77.868967] cfg80211:   (2457000 KHz - 2482000 KHz @ 20000 KHz), (300 mBi, 2000 mBm)
[   77.868971] cfg80211:   (2474000 KHz - 2494000 KHz @ 20000 KHz), (300 mBi, 2000 mBm)
[   77.868975] cfg80211:   (5170000 KHz - 5250000 KHz @ 40000 KHz), (300 mBi, 2000 mBm)
[   77.868978] cfg80211:   (5735000 KHz - 5835000 KHz @ 40000 KHz), (300 mBi, 2000 mBm)
[   78.830865] wlan0: authenticate with 20:2b:c1:9a:a8:e0
[   78.833836] wlan0: send auth to 20:2b:c1:9a:a8:e0 (try 1/3)
[   78.835323] wlan0: authenticated
[   78.838322] wlan0: associate with 20:2b:c1:9a:a8:e0 (try 1/3)
[   78.842178] wlan0: RX AssocResp from 20:2b:c1:9a:a8:e0 (capab=0x411 status=0 aid=1)
[   78.842763] brcmsmac bcma0:0: brcmsmac: brcms_ops_bss_info_changed: associated
[   78.842771] brcmsmac bcma0:0: brcms_ops_bss_info_changed: arp filtering: enabled true, count 0 (implement)
[   78.842775] brcmsmac bcma0:0: brcms_ops_bss_info_changed: qos enabled: true (implement)
[   78.842786] wlan0: associated
[   78.843803] cfg80211: Calling CRDA for country: CZ
[   78.848970] cfg80211: Regulatory domain changed to country: CZ
[   78.848976] cfg80211:   (start_freq - end_freq @ bandwidth), (max_antenna_gain, max_eirp)
[   78.848981] cfg80211:   (2400000 KHz - 2483500 KHz @ 40000 KHz), (N/A, 2000 mBm)
[   78.848986] cfg80211:   (5150000 KHz - 5250000 KHz @ 40000 KHz), (N/A, 2301 mBm)
[   78.848991] cfg80211:   (5250000 KHz - 5350000 KHz @ 40000 KHz), (N/A, 2000 mBm)
[   78.848996] cfg80211:   (5470000 KHz - 5725000 KHz @ 40000 KHz), (N/A, 2698 mBm)
[   80.141531] wlan0: deauthenticating from 20:2b:c1:9a:a8:e0 by local choice (reason=3)
[   80.148905] brcmsmac bcma0:0: brcmsmac: brcms_ops_bss_info_changed: disassociated
[   80.148916] brcmsmac bcma0:0: brcms_ops_bss_info_changed: arp filtering: enabled false, count 0 (implement)
[   80.148921] brcmsmac bcma0:0: brcms_ops_bss_info_changed: qos enabled: false (implement)
[   80.149619] cfg80211: Calling CRDA to update world regulatory domain
[   80.155258] cfg80211: World regulatory domain updated:
[   80.155264] cfg80211:   (start_freq - end_freq @ bandwidth), (max_antenna_gain, max_eirp)
[   80.155270] cfg80211:   (2402000 KHz - 2472000 KHz @ 40000 KHz), (300 mBi, 2000 mBm)
[   80.155274] cfg80211:   (2457000 KHz - 2482000 KHz @ 20000 KHz), (300 mBi, 2000 mBm)
[   80.155278] cfg80211:   (2474000 KHz - 2494000 KHz @ 20000 KHz), (300 mBi, 2000 mBm)
[   80.155282] cfg80211:   (5170000 KHz - 5250000 KHz @ 40000 KHz), (300 mBi, 2000 mBm)
[   80.155286] cfg80211:   (5735000 KHz - 5835000 KHz @ 40000 KHz), (300 mBi, 2000 mBm)
[   97.754045] wlan0: authenticate with 20:2b:c1:9a:a8:e0
[   97.757035] wlan0: send auth to 20:2b:c1:9a:a8:e0 (try 1/3)
[   97.758479] wlan0: authenticated
[   97.761565] wlan0: associate with 20:2b:c1:9a:a8:e0 (try 1/3)
[   97.765352] wlan0: RX AssocResp from 20:2b:c1:9a:a8:e0 (capab=0x411 status=0 aid=1)
[   97.765829] brcmsmac bcma0:0: brcmsmac: brcms_ops_bss_info_changed: associated
[   97.765837] brcmsmac bcma0:0: brcms_ops_bss_info_changed: arp filtering: enabled true, count 0 (implement)
[   97.765841] brcmsmac bcma0:0: brcms_ops_bss_info_changed: qos enabled: true (implement)
[   97.765852] wlan0: associated
[   97.766884] cfg80211: Calling CRDA for country: CZ
[   97.772168] cfg80211: Regulatory domain changed to country: CZ
[   97.772174] cfg80211:   (start_freq - end_freq @ bandwidth), (max_antenna_gain, max_eirp)
[   97.772179] cfg80211:   (2400000 KHz - 2483500 KHz @ 40000 KHz), (N/A, 2000 mBm)
[   97.772183] cfg80211:   (5150000 KHz - 5250000 KHz @ 40000 KHz), (N/A, 2301 mBm)
[   97.772187] cfg80211:   (5250000 KHz - 5350000 KHz @ 40000 KHz), (N/A, 2000 mBm)
[   97.772191] cfg80211:   (5470000 KHz - 5725000 KHz @ 40000 KHz), (N/A, 2698 mBm)
[  104.012855] wlan0: deauthenticated from 20:2b:c1:9a:a8:e0 (Reason: 15)
[  104.012893] brcmsmac bcma0:0: brcmsmac: brcms_ops_bss_info_changed: disassociated
[  104.012902] brcmsmac bcma0:0: brcms_ops_bss_info_changed: arp filtering: enabled false, count 0 (implement)
[  104.012907] brcmsmac bcma0:0: brcms_ops_bss_info_changed: qos enabled: false (implement)
[  104.014293] cfg80211: Calling CRDA to update world regulatory domain
[  104.019629] cfg80211: World regulatory domain updated:
[  104.019635] cfg80211:   (start_freq - end_freq @ bandwidth), (max_antenna_gain, max_eirp)
[  104.019641] cfg80211:   (2402000 KHz - 2472000 KHz @ 40000 KHz), (300 mBi, 2000 mBm)
[  104.019645] cfg80211:   (2457000 KHz - 2482000 KHz @ 20000 KHz), (300 mBi, 2000 mBm)
[  104.019649] cfg80211:   (2474000 KHz - 2494000 KHz @ 20000 KHz), (300 mBi, 2000 mBm)
[  104.019653] cfg80211:   (5170000 KHz - 5250000 KHz @ 40000 KHz), (300 mBi, 2000 mBm)
[  104.019657] cfg80211:   (5735000 KHz - 5835000 KHz @ 40000 KHz), (300 mBi, 2000 mBm)
[  104.977989] wlan0: authenticate with 20:2b:c1:9a:a8:e0
[  104.981092] wlan0: send auth to 20:2b:c1:9a:a8:e0 (try 1/3)
[  104.982636] wlan0: authenticated
[  104.985635] wlan0: associate with 20:2b:c1:9a:a8:e0 (try 1/3)
[  104.991011] wlan0: RX AssocResp from 20:2b:c1:9a:a8:e0 (capab=0x411 status=0 aid=1)
[  104.991571] brcmsmac bcma0:0: brcmsmac: brcms_ops_bss_info_changed: associated
[  104.991578] brcmsmac bcma0:0: brcms_ops_bss_info_changed: arp filtering: enabled true, count 0 (implement)
[  104.991583] brcmsmac bcma0:0: brcms_ops_bss_info_changed: qos enabled: true (implement)
[  104.991595] wlan0: associated
[  104.992602] cfg80211: Calling CRDA for country: CZ
[  104.997980] cfg80211: Regulatory domain changed to country: CZ
[  104.997985] cfg80211:   (start_freq - end_freq @ bandwidth), (max_antenna_gain, max_eirp)
[  104.997990] cfg80211:   (2400000 KHz - 2483500 KHz @ 40000 KHz), (N/A, 2000 mBm)
[  104.997994] cfg80211:   (5150000 KHz - 5250000 KHz @ 40000 KHz), (N/A, 2301 mBm)
[  104.997998] cfg80211:   (5250000 KHz - 5350000 KHz @ 40000 KHz), (N/A, 2000 mBm)
[  104.998002] cfg80211:   (5470000 KHz - 5725000 KHz @ 40000 KHz), (N/A, 2698 mBm)
[  112.010938] wlan0: deauthenticated from 20:2b:c1:9a:a8:e0 (Reason: 15)
[  112.010976] brcmsmac bcma0:0: brcmsmac: brcms_ops_bss_info_changed: disassociated
[  112.010985] brcmsmac bcma0:0: brcms_ops_bss_info_changed: arp filtering: enabled false, count 0 (implement)
[  112.010990] brcmsmac bcma0:0: brcms_ops_bss_info_changed: qos enabled: false (implement)
[  112.011764] cfg80211: Calling CRDA to update world regulatory domain
[  112.017106] cfg80211: World regulatory domain updated:
[  112.017111] cfg80211:   (start_freq - end_freq @ bandwidth), (max_antenna_gain, max_eirp)
[  112.017117] cfg80211:   (2402000 KHz - 2472000 KHz @ 40000 KHz), (300 mBi, 2000 mBm)
[  112.017121] cfg80211:   (2457000 KHz - 2482000 KHz @ 20000 KHz), (300 mBi, 2000 mBm)
[  112.017125] cfg80211:   (2474000 KHz - 2494000 KHz @ 20000 KHz), (300 mBi, 2000 mBm)
[  112.017129] cfg80211:   (5170000 KHz - 5250000 KHz @ 40000 KHz), (300 mBi, 2000 mBm)
[  112.017133] cfg80211:   (5735000 KHz - 5835000 KHz @ 40000 KHz), (300 mBi, 2000 mBm)
[  112.977331] wlan0: authenticate with 20:2b:c1:9a:a8:e0
[  112.980316] wlan0: send auth to 20:2b:c1:9a:a8:e0 (try 1/3)
[  112.981816] wlan0: authenticated
[  112.984840] wlan0: associate with 20:2b:c1:9a:a8:e0 (try 1/3)
[  112.988657] wlan0: RX AssocResp from 20:2b:c1:9a:a8:e0 (capab=0x411 status=0 aid=1)
[  112.989223] brcmsmac bcma0:0: brcmsmac: brcms_ops_bss_info_changed: associated
[  112.989231] brcmsmac bcma0:0: brcms_ops_bss_info_changed: arp filtering: enabled true, count 0 (implement)
[  112.989236] brcmsmac bcma0:0: brcms_ops_bss_info_changed: qos enabled: true (implement)
[  112.989248] wlan0: associated
[  112.990257] cfg80211: Calling CRDA for country: CZ
[  112.995530] cfg80211: Regulatory domain changed to country: CZ
[  112.995536] cfg80211:   (start_freq - end_freq @ bandwidth), (max_antenna_gain, max_eirp)
[  112.995541] cfg80211:   (2400000 KHz - 2483500 KHz @ 40000 KHz), (N/A, 2000 mBm)
[  112.995545] cfg80211:   (5150000 KHz - 5250000 KHz @ 40000 KHz), (N/A, 2301 mBm)
[  112.995549] cfg80211:   (5250000 KHz - 5350000 KHz @ 40000 KHz), (N/A, 2000 mBm)
[  112.995552] cfg80211:   (5470000 KHz - 5725000 KHz @ 40000 KHz), (N/A, 2698 mBm)
[  117.490387] FAT-fs (sdc1): utf8 is not a recommended IO charset for FAT filesystems, filesystem will be case sensitive!
[  120.017034] wlan0: deauthenticated from 20:2b:c1:9a:a8:e0 (Reason: 15)
[  120.017099] brcmsmac bcma0:0: brcmsmac: brcms_ops_bss_info_changed: disassociated
[  120.017109] brcmsmac bcma0:0: brcms_ops_bss_info_changed: arp filtering: enabled false, count 0 (implement)
[  120.017116] brcmsmac bcma0:0: brcms_ops_bss_info_changed: qos enabled: false (implement)
[  120.019523] cfg80211: Calling CRDA to update world regulatory domain
[  120.024854] cfg80211: World regulatory domain updated:
[  120.024859] cfg80211:   (start_freq - end_freq @ bandwidth), (max_antenna_gain, max_eirp)
[  120.024865] cfg80211:   (2402000 KHz - 2472000 KHz @ 40000 KHz), (300 mBi, 2000 mBm)
[  120.024869] cfg80211:   (2457000 KHz - 2482000 KHz @ 20000 KHz), (300 mBi, 2000 mBm)
[  120.024873] cfg80211:   (2474000 KHz - 2494000 KHz @ 20000 KHz), (300 mBi, 2000 mBm)
[  120.024877] cfg80211:   (5170000 KHz - 5250000 KHz @ 40000 KHz), (300 mBi, 2000 mBm)
[  120.024881] cfg80211:   (5735000 KHz - 5835000 KHz @ 40000 KHz), (300 mBi, 2000 mBm)
[  120.984614] wlan0: authenticate with 20:2b:c1:9a:a8:e0
[  120.987522] wlan0: send auth to 20:2b:c1:9a:a8:e0 (try 1/3)
[  120.989110] wlan0: authenticated
[  120.992042] wlan0: associate with 20:2b:c1:9a:a8:e0 (try 1/3)
[  120.995897] wlan0: RX AssocResp from 20:2b:c1:9a:a8:e0 (capab=0x411 status=0 aid=1)
[  120.996467] brcmsmac bcma0:0: brcmsmac: brcms_ops_bss_info_changed: associated
[  120.996474] brcmsmac bcma0:0: brcms_ops_bss_info_changed: arp filtering: enabled true, count 0 (implement)
[  120.996479] brcmsmac bcma0:0: brcms_ops_bss_info_changed: qos enabled: true (implement)
[  120.996490] wlan0: associated
[  120.997502] cfg80211: Calling CRDA for country: CZ
[  121.002890] cfg80211: Regulatory domain changed to country: CZ
[  121.002896] cfg80211:   (start_freq - end_freq @ bandwidth), (max_antenna_gain, max_eirp)
[  121.002901] cfg80211:   (2400000 KHz - 2483500 KHz @ 40000 KHz), (N/A, 2000 mBm)
[  121.002905] cfg80211:   (5150000 KHz - 5250000 KHz @ 40000 KHz), (N/A, 2301 mBm)
[  121.002908] cfg80211:   (5250000 KHz - 5350000 KHz @ 40000 KHz), (N/A, 2000 mBm)
[  121.002912] cfg80211:   (5470000 KHz - 5725000 KHz @ 40000 KHz), (N/A, 2698 mBm)
[  122.095963] wlan0: deauthenticating from 20:2b:c1:9a:a8:e0 by local choice (reason=3)
[  122.102802] brcmsmac bcma0:0: brcmsmac: brcms_ops_bss_info_changed: disassociated
[  122.102813] brcmsmac bcma0:0: brcms_ops_bss_info_changed: arp filtering: enabled false, count 0 (implement)
[  122.102818] brcmsmac bcma0:0: brcms_ops_bss_info_changed: qos enabled: false (implement)
[  122.104320] cfg80211: Calling CRDA to update world regulatory domain
[  122.109871] cfg80211: World regulatory domain updated:
[  122.109877] cfg80211:   (start_freq - end_freq @ bandwidth), (max_antenna_gain, max_eirp)
[  122.109882] cfg80211:   (2402000 KHz - 2472000 KHz @ 40000 KHz), (300 mBi, 2000 mBm)
[  122.109886] cfg80211:   (2457000 KHz - 2482000 KHz @ 20000 KHz), (300 mBi, 2000 mBm)
[  122.109890] cfg80211:   (2474000 KHz - 2494000 KHz @ 20000 KHz), (300 mBi, 2000 mBm)
[  122.109894] cfg80211:   (5170000 KHz - 5250000 KHz @ 40000 KHz), (300 mBi, 2000 mBm)
[  122.109898] cfg80211:   (5735000 KHz - 5835000 KHz @ 40000 KHz), (300 mBi, 2000 mBm)
[  126.094946] wlan0: authenticate with 20:2b:c1:9a:a8:e0
[  126.097932] wlan0: send auth to 20:2b:c1:9a:a8:e0 (try 1/3)
[  126.099438] wlan0: authenticated
[  126.102381] wlan0: associate with 20:2b:c1:9a:a8:e0 (try 1/3)
[  126.106377] wlan0: RX AssocResp from 20:2b:c1:9a:a8:e0 (capab=0x411 status=0 aid=1)
[  126.106972] brcmsmac bcma0:0: brcmsmac: brcms_ops_bss_info_changed: associated
[  126.106979] brcmsmac bcma0:0: brcms_ops_bss_info_changed: arp filtering: enabled true, count 0 (implement)
[  126.106984] brcmsmac bcma0:0: brcms_ops_bss_info_changed: qos enabled: true (implement)
[  126.106993] wlan0: associated
[  126.108014] cfg80211: Calling CRDA for country: CZ
[  126.113260] cfg80211: Regulatory domain changed to country: CZ
[  126.113265] cfg80211:   (start_freq - end_freq @ bandwidth), (max_antenna_gain, max_eirp)
[  126.113270] cfg80211:   (2400000 KHz - 2483500 KHz @ 40000 KHz), (N/A, 2000 mBm)
[  126.113274] cfg80211:   (5150000 KHz - 5250000 KHz @ 40000 KHz), (N/A, 2301 mBm)
[  126.113278] cfg80211:   (5250000 KHz - 5350000 KHz @ 40000 KHz), (N/A, 2000 mBm)
[  126.113282] cfg80211:   (5470000 KHz - 5725000 KHz @ 40000 KHz), (N/A, 2698 mBm)
