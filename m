Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from avasout08.plus.net ([212.159.14.20]:44688 "EHLO
	avasout08.plus.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751467Ab3A2XKr (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 29 Jan 2013 18:10:47 -0500
From: Andrew Wasielewski <andrew@wasielewski.co.uk>
To: linux-wireless@vger.kernel.org
Subject: WARNING: at drivers/net/wireless/p54/main.c:443 p54_work+0x66/0x80 [p54common]() (Not tainted)
Date: Tue, 29 Jan 2013 23:04:38 +0000
Message-ID: <1732818.7oJIpSJZSL@localhost.localdomain> (sfid-20130130_001051_330779_A102CB0F)
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Dear Wireless Developers,

I just had the following crash in p54common.  The "failed to update LEDs" messages continued until I rebooted - couldn't find a way to reload the stack.  O/S is ClearOS Community release 6.3.0 (kernel 2.6.32-279.19.1.v6.i686).  Hardware is LinkSys WUSB54G running in AP mode using hostapd, firmware isl3886usb.

Thanks,
Andrew

Jan 29 21:22:27 gateway kernel: ieee80211 phy0: failed to update LEDs (-12).
Jan 29 21:22:27 gateway kernel: ------------[ cut here ]------------
Jan 29 21:22:27 gateway kernel: WARNING: at drivers/net/wireless/p54/main.c:443 p54_work+0x66/0x80 [p54common]() (Not tainted)
Jan 29 21:22:27 gateway kernel: Hardware name:  
Jan 29 21:22:27 gateway kernel: Modules linked in: xt_IMQ imq bluetooth aes_i586 aes_generic xt_state nf_nat_h323 nf_conntrack_h323 nf_nat_pptp nf_
nat_proto_gre nf_nat_irc nf_nat_ftp ipt_MASQUERADE nf_conntrack_pptp nf_conntrack_proto_gre ecb ppp_mppe nf_conntrack_irc nf_conntrack_ftp ipt_REJE
CT ipt_LOG iptable_nat nf_nat nf_conntrack_ipv4 nf_conntrack nf_defrag_ipv4 iptable_mangle iptable_filter ip_tables ppp_synctty ppp_async ppp_gener
ic slhc bridge stp llc ipv6 ppdev parport_pc parport 8139too 8139cp mii arc4 p54usb p54common crc_ccitt mac80211 cfg80211 rfkill sg snd_intel8x0 snd_ac97_codec ac97_bus snd_seq snd_seq_device snd_pcm snd_timer snd soundcore snd_page_alloc forcedeth i2c_nforce2 ext4 mbcache jbd2 sd_mod crc_t10dif firewire_ohci firewire_core crc_itu_t ata_generic pata_acpi pata_amd nouveau ttm drm_kms_helper drm i2c_core mxm_wmi video output wmi dm_mirror dm_region_hash dm_log dm_mod [last unloaded: scsi_wait_scan]
Jan 29 21:22:27 gateway kernel: Pid: 678, comm: phy0 Not tainted 2.6.32-279.2.1.v6.i686 #1
Jan 29 21:22:27 gateway kernel: Call Trace:
Jan 29 21:22:27 gateway kernel: [<c0455c11>] ? warn_slowpath_common+0x81/0xc0
Jan 29 21:22:27 gateway kernel: [<f8f569a6>] ? p54_work+0x66/0x80 [p54common]
Jan 29 21:22:27 gateway kernel: [<f8f569a6>] ? p54_work+0x66/0x80 [p54common]
Jan 29 21:22:27 gateway kernel: [<f8f56940>] ? p54_work+0x0/0x80 [p54common]
Jan 29 21:22:27 gateway kernel: [<c0455c6b>] ? warn_slowpath_null+0x1b/0x20
Jan 29 21:22:27 gateway kernel: [<f8f569a6>] ? p54_work+0x66/0x80 [p54common]
Jan 29 21:22:27 gateway kernel: [<c047229b>] ? worker_thread+0x11b/0x230
Jan 29 21:22:27 gateway kernel: [<c0476a10>] ? autoremove_wake_function+0x0/0x40
Jan 29 21:22:27 gateway kernel: [<c0472180>] ? worker_thread+0x0/0x230
Jan 29 21:22:27 gateway kernel: [<c04767d4>] ? kthread+0x74/0x80
Jan 29 21:22:27 gateway kernel: [<c0476760>] ? kthread+0x0/0x80
Jan 29 21:22:27 gateway kernel: [<c0409fff>] ? kernel_thread_helper+0x7/0x10
Jan 29 21:22:27 gateway kernel: ---[ end trace d4e1cfe2fc6a5534 ]---
Jan 29 21:22:30 gateway kernel: ieee80211 phy0: failed to update LEDs (-12).
Jan 29 21:22:34 gateway kernel: ieee80211 phy0: failed to update LEDs (-12).
Jan 29 21:22:37 gateway kernel: ieee80211 phy0: failed to update LEDs (-12).
Jan 29 21:22:45 gateway kernel: ieee80211 phy0: failed to update LEDs (-12).
Jan 29 21:22:45 gateway kernel: ieee80211 phy0: failed to update LEDs (-12).
Jan 29 21:22:45 gateway kernel: ieee80211 phy0: failed to update LEDs (-12).
Jan 29 21:22:46 gateway kernel: ieee80211 phy0: failed to update LEDs (-12).

