Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from myrna.kimmina.net ([194.29.232.114]:64249 "EHLO
	myrna.kimmina.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752562AbYAGSC0 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 7 Jan 2008 13:02:26 -0500
Received: from email.kimmina.net (194-29-232-115.ipberlin.com [194.29.232.115] (may be forged))
	by myrna.kimmina.net (8.12.11.20060614/8.12.11) with ESMTP id m07Hkpx8015988
	for <linux-wireless@vger.kernel.org>; Mon, 7 Jan 2008 18:46:51 +0100 (CET)
Received: from [10.0.68.5] (e178115034.adsl.alicedsl.de [85.178.115.34])
	by email.kimmina.net (8.12.11/8.11.6) with ESMTP id m07JwZcV025826
	for <linux-wireless@vger.kernel.org>; Mon, 7 Jan 2008 20:58:36 +0100 (CET)
Message-ID: <47826588.6090106@spitzner.org> (sfid-20080107_180230_013300_5EDA75A1)
Date: Mon, 07 Jan 2008 18:46:48 +0100
From: Ralph Spitzner <rasp@spitzner.org>
MIME-Version: 1.0
To: linux-wireless@vger.kernel.org
Subject: ath5k
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Following the Procedures described under:
http://linuxwireless.org/en/developers/Documentation/git-guide
or
http://linuxwireless.org/en/users/Download

While trying to insert the ath5k module I get :
--------------------------------------------------------------------

root@meepmeep:~# insmod ath5k.ko
root@meepmeep:~# BUG: unable to handle kernel paging request at virtual 
address fffffdd0
printing eip: d0c74071 *pde = 00981067 *pte = 00000000
Oops: 0000 [#1]
Modules linked in: ath5k snd_seq_dummy snd_seq_oss snd_seq_midi_event 
snd_seq snd_seq_device snd_pcm_oss snd_mixer_oss ipv6 xt_tcpudp 
iptable_filter ip_tables x_tables lp parport_pc parport pcspkr psmouse 
pcmcia battery ac power_supply mac80211 evdev e1000 cfg80211 
yenta_socket rsrc_nonstatic pcmcia_core video output thermal serio_raw 
processor intel_agp button agpgart ata_generic
i2c_i801 snd_intel8x0 snd_ac97_codec ac97_bus snd_pcm snd_timer iTCO_wdt 
shpchp snd iTCO_vendor_support soundcore snd_page_alloc
Pid: 3029, comm: ifconfig Not tainted (2.6.24-rc7 #2)
EIP: 0060:[<d0c74071>] EFLAGS: 00010246 CPU: 0
EIP is at ieee80211_generic_frame_duration+0x21/0x70 [mac80211]
EAX: c61e4160 EBX: c61e4160 ECX: 0000000a EDX: 00000000
ESI: 00000000 EDI: 0000000a EBP: 000003e8 ESP: c621fdd4
  DS: 007b ES: 007b FS: 0000 GS: 0033 SS: 0068
Process ifconfig (pid: 3029, ti=c621e000 task=cf95eaa0 task.ti=c621e000)
Stack: d0d8e39b 00000002 0000876c 00000000 cdb7b000 d0d8ac67 0000000a 
da63f324
        00000031 c61e4160 00000000 d0d8fe44 c61e4fac 00000000 00000000 
00000003
        00000002 00000002 00000014 00000000 d0d8fe20 c61e4ea0 00000001 
00000003
Call Trace:
  [<d0d8e39b>] ath5k_hw_rfgain+0x4b/0x80 [ath5k]
  [<d0d8ac67>] ath5k_hw_reset+0xaa7/0xeb0 [ath5k]
  [<d0d83766>] ath5k_init+0x46/0x110 [ath5k]
  [<d0c60bcc>] ieee80211_open+0x19c/0x4c0 [mac80211]
  [<c0141513>] find_lock_page+0x23/0x80
  [<c06ab95c>] dev_open+0x4c/0x80
  [<c06aa639>] dev_change_flags+0x149/0x1c0
  [<c06a9063>] __dev_get_by_name+0x73/0x90
  [<c06f14d1>] devinet_ioctl+0x521/0x6c0
  [<c06a9063>] __dev_get_by_name+0x73/0x90
  [<c069de4f>] sock_ioctl+0xcf/0x230
  [<c069dd80>] sock_ioctl+0x0/0x230
  [<c016aa8f>] do_ioctl+0x1f/0x70
  [<c016ab3c>] vfs_ioctl+0x5c/0x260
  [<c016ada8>] sys_ioctl+0x68/0x80
  [<c0104002>] syscall_call+0x7/0xb
  [<c0720000>] rpcb_decode_getaddr+0x80/0xe0
  =======================
Code: 5d c3 90 8d b4 26 00 00 00 00 83 ec 14 89 5c 24 08 89 c3 89 74 24 
0c 89 d6 89 7c 24 10 89 cf 8b 4c 24 18 83 78 0c 02 74 31 31 d2 <8b> 86 
d0 fd ff ff 89 14 24 89 fa 83 e0 08 89 44 24 04 89 d8 e8
EIP: [<d0c74071>] ieee80211_generic_frame_duration+0x21/0x70 [mac80211] 
SS:ESP 0068:c621fdd4
---[ end trace e300ba2872bb83af ]---


--------------------------------------------------------------------


The machine is a IBM/Lenovo Thinkpad T42 with an Atheros AR5212
MiniPCI card running 2.6.24-rc7 from git.
Any Ideas on this ?
(The only strange thing I've noticed so far, is that it takes
ages to initialize the PCMCIA stuff [yenta] so it maybe thinking
the card is on PCMCIA instead of PCI {!?})


Regards
	-rasp





-- 
Man sollte mehr koennen, als man macht.
  Nicht mehr machen, als man kann
	-B.Brecht
