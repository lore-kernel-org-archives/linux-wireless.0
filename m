Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from av12-1-sn2.hy.skanova.net ([81.228.8.185]:49358 "EHLO
	av12-1-sn2.hy.skanova.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753001AbXJKX3U (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 11 Oct 2007 19:29:20 -0400
Received: from smtp4-2-sn2.hy.skanova.net (smtp4-2-sn2.hy.skanova.net [81.228.8.93])
	by av12-1-sn2.hy.skanova.net (Postfix) with ESMTP id CAE8B38563
	for <linux-wireless@vger.kernel.org>; Fri, 12 Oct 2007 01:00:33 +0200 (CEST)
Received: from visigoth.unternet.org (81-235-183-151-no20.tbcn.telia.com [81.235.183.151])
	by smtp4-2-sn2.hy.skanova.net (Postfix) with ESMTP id A4E3B37E45
	for <linux-wireless@vger.kernel.org>; Fri, 12 Oct 2007 01:00:33 +0200 (CEST)
Received: from [192.168.1.124] (helo=ostrogoth)
	by visigoth.unternet.org with esmtp (Exim 4.63)
	(envelope-from <lkml-f@unternet.org>)
	id 1Ig6xT-0002hG-DU
	for linux-wireless@vger.kernel.org; Fri, 12 Oct 2007 00:56:47 +0200
Date: Fri, 12 Oct 2007 01:00:30 +0200
From: Frank de Lange <lkml-f@unternet.org>
To: linux-wireless@vger.kernel.org
Subject: [Oops]  EIP is at ath5k_hw_reset+0x391/0xc82 [ath5k] (2.6.23,
	latest wireless git)
Message-ID: <20071011230030.GA6725@unternet.org> (sfid-20071012_002923_658660_082A5203)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Just got an Atheros-based card from eBay, stuffed it into my Thinkpad
T23 (ignoring the complaints about two ethernet cards being installed)
and got myself this Oops:

BUG: unable to handle kernel NULL pointer dereference at virtual address
00000000
 printing eip:
f0a3322d
*pde = 00000000
Oops: 0000 [#1]
PREEMPT
Modules linked in: autofs4 ipv6 speedstep_ich speedstep_lib
cpufreq_stats cpufreq_conservative cpufreq_userspace cpufreq_powersave
cpufreq_ondemand freq_table sbs bay dock nfs lockd sunrpc lp arc4 ecb
blkcipher rc80211_simple snd_intel8x0 snd_ac97_codec ac97_bus
snd_pcm_oss snd_mixer_oss snd_pcm battery ac pcmcia firmware_class video
backlight output snd_seq_dummy irtty_sir sir_dev nsc_ircc irda
snd_seq_oss crc_ccitt ath5k parport_pc parport snd_seq_midi mac80211
yenta_socket rsrc_nonstatic snd_rawmidi snd_seq_midi_event cfg80211
button pcmcia_core snd_seq psmouse snd_timer snd_seq_device iTCO_wdt
serio_raw snd intel_agp agpgart soundcore snd_page_alloc pcspkr evdev
ext3 jbd mbcache sg sr_mod cdrom sd_mod piix ide_core ata_generic
ata_piix floppy libata scsi_mod uhci_hcd e100 mii usbcore thermal
processor fan fuse
CPU:    0
   Not tainted VLI
EFLAGS: 00010246   (2.6.23-t23-01 #3)
EIP is at ath5k_hw_reset+0x391/0xc82 [ath5k]
eax: 00000000   ebx: ed6d4f74   ecx: 485683ff   edx: 00000005
esi: 00000000   edi: 00000000   ebp: edbe4800   esp: eccf6b44
ds: 007b   es: 007b   fs: 0000  gs: 0033  ss: 0068
Process NetworkManager (pid: 4593, ti=eccf6000 task=edfbf500
task.ti=eccf6000)
Stack: ed6d4e00 c01abccd f0a2d4bf ed6d4e00 ed6d4f74 ed6d6cec 00000000
00000001
       00000241 00000003 00000001 00000002 00000014 ed6d4e00 00000000
00000000
       00000000 f0a2d683 00000be6 ed6d4e00 edb26000 00001002 ed6d4e08
f0a2d9c1
Call Trace:
__delay+0x6/0x7
ath_stoprecv+0x2f/0x143 [ath5k]
ath_stop_locked+0xb0/0xc4 [ath5k]
ath_init+0x6e/0xf5 [ath5k]
ieee80211_open+0x1d5/0x3ab [mac80211]
dev_open+0x2d/0x66
dev_change_flags+0x9d/0x150
rtnl_setlink+0x0/0xea
do_setlink+0x1b7/0x281
rtnl_setlink+0x0/0xea
rtnl_setlink+0xd0/0xea
netlink_dump_start+0x104/0x126
rtnetlink_rcv_msg+0x18f/0x1a9
rtnl_dump_ifinfo+0x0/0x7d
netlink_run_queue+0x5c/0xd2
rtnetlink_rcv_msg+0x0/0x1a9
rtnetlink_rcv+0x25/0x3d
netlink_data_ready+0x12/0x4b
netlink_sendskb+0x19/0x2f
netlink_sendmsg+0x236/0x242
sock_sendmsg+0xbb/0xd3
autoremove_wake_function+0x0/0x35
autoremove_wake_function+0x0/0x35
__kfree_skb+0xa1/0xf6
unix_stream_recvmsg+0x3ef/0x49f
verify_iovec+0x3e/0x70
sys_sendmsg+0x194/0x1f9
sys_recvmsg+0x1be/0x1d2
netlink_insert+0x110/0x11a
move_addr_to_user+0x39/0x50
sys_getsockname+0x91/0xa2
sock_init_data+0x51/0x145
sock_setsockopt+0x4d4/0x4ec
d_alloc+0x1b/0x170
d_instantiate+0x40/0x5b
sock_attach_fd+0x53/0xae
sys_socketcall+0x223/0x242
sysenter_past_esp+0x5f/0x85
 =======================
Code: fc ff 00 00 03 5d 08 c7 44 24 04 00 00 00 00 0f b6 46 1c 89 04 24
89 e8 e8 65 cf ff ff 89 da 0f b7 c0 e8 b0 a3 77 cf ff 44 24 40 <0f> b7
07 83 c6 14 39 44 24 40 72 b4 83 7d 48 01 76 4f 66 83 7d
SS:ESP 0068:eccf6b44

This Oopsed within NetworkManager but it also crashes/burns when
activated manually. Setting parameters with iwconfig does not bring it
down but ifconfig'ing it up does...

Card is known as 02:02.0 Ethernet controller: Atheros Communications,
Inc. AR2413 802.11bg NIC (rev 01), it is an Askey AR2413A (802.11b/g)
FCC ID:PPD-AR5BMB5 IC:4104A-AR5BMB5

Madwifi (with evil closed HAL code) works on the same card (with
somewhat weak reception which is annoying as I got an Atheros-based card
to get a better radio than the Broadcom-based ones I have lying
around...)

More info available on request...

Cheers//Frank
-- 
   WWWWW      ________________________
  ## o o\    /     Frank de Lange     \
  }#   \|   /                          \
   \ `--| _/     <Hacker for Hire>      \
    `---'  \       +46-734352015        /
            \    frank@unternet.org    /
             `------------------------'
  [ "Omnis enim res, quae dando non deficit, dum habetur
     et non datur, nondum habetur, quomodo habenda est."  ]
