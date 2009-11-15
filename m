Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from hogsmeade.leitwerk.net ([217.28.96.50]:39469 "EHLO
	hogsmeade.leitwerk.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752673AbZKONDw (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 15 Nov 2009 08:03:52 -0500
From: Simon Raffeiner <sturmflut@lieberbiber.de>
To: users@rt2x00.serialmonkey.com, linux-wireless@vger.kernel.org
Subject: Kernel Bug using current rt2x00usb and an RT2070L device
Date: Sun, 15 Nov 2009 14:03:56 +0100
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="us-ascii"
Message-Id: <200911151403.56479.sturmflut@lieberbiber.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi lists,

I built the current compat-wireless on a stock Ubuntu 2.6.31-14-generic kernel (Ubuntu 9.10 Karmic Koala), plugged in my Sitecom WL-608v1 USB adapter (USB ID 0df6:003f) and hit the following kernel Bug:

[ 3097.169534] ------------[ cut here ]------------                                    
[ 3097.169538] kernel BUG at /home/sturmflut/compat-wireless-2.6/drivers/net/wireless/rt2x00/rt2x00usb.c:86!                                                                  
[ 3097.169541] invalid opcode: 0000 [#1] SMP                                           
[ 3097.169544] last sysfs file: /sys/devices/pci0000:00/0000:00:18.3/temp1_input       
[ 3097.169546] CPU 0                                                                   
[ 3097.169547] Modules linked in: rt2800usb(+) rt2800lib rt2x00usb rt2x00lib led_class mac80211 cfg80211 crc_ccitt nls_cp437 nls_utf8 xt_multiport iptable_filter ip_tables x_tables binfmt_misc ppdev kvm_amd kvm nfs lockd nfs_acl auth_rpcgss sunrpc cifs snd_hda_codec_atihdmi snd_hda_codec_realtek snd_hda_intel snd_hda_codec snd_hwdep snd_pcm_oss snd_mixer_oss snd_pcm snd_seq_dummy snd_seq_oss snd_seq_midi snd_rawmidi snd_seq_midi_event snd_seq snd_timer snd_seq_device sbp2 snd soundcore snd_page_alloc fglrx(P) psmouse amd64_edac_mod edac_core i2c_nforce2 serio_raw k8temp lp parport raid10 raid456 raid6_pq async_xor async_memcpy async_tx xor raid1 raid0 multipath linear usbhid forcedeth ohci1394 ieee1394                                                                        
[ 3097.169585] Pid: 20262, comm: modprobe Tainted: P           2.6.31-14-generic #48-Ubuntu                                                                                   
[ 3097.169587] RIP: 0010:[<ffffffffa05e9894>]  [<ffffffffa05e9894>] rt2x00usb_vendor_req_buff_lock+0x144/0x150 [rt2x00usb]                                                    
[ 3097.169596] RSP: 0018:ffff88008590fb48  EFLAGS: 00010246                            
[ 3097.169597] RAX: 0000000000000001 RBX: ffff8800b51a5160 RCX: 0000000000000580       
[ 3097.169599] RDX: 00000000000000c0 RSI: 0000000000000007 RDI: ffff8800b51a5160       
[ 3097.169601] RBP: ffff88008590fb98 R08: 00000000000001f4 R09: 0000000000000004       
[ 3097.169603] R10: 0000000000000000 R11: 00000000ffffffff R12: 0000000000000004       
[ 3097.169605] R13: 00000000000000c0 R14: 0000000000000580 R15: 0000000000000007       
[ 3097.169607] FS:  00007f5cf10d16f0(0000) GS:ffff880028022000(0000) knlGS:00000000f72e1700                                                                                   
[ 3097.169609] CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b                       
[ 3097.169611] CR2: 00007f5cf10f5000 CR3: 000000008598a000 CR4: 00000000000006f0       
[ 3097.169613] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000       
[ 3097.169615] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400       
[ 3097.169617] Process modprobe (pid: 20262, threadinfo ffff88008590e000, task ffff880099132d60)                                                                              
[ 3097.169619] Stack:                                                                  
[ 3097.169620]  ffff8800b51a5160 ffff8800b51a5430 ffff8800b51a5160 ffff88008590fbd4    
[ 3097.169623] <0> 0000000000000040 0000000000000000 ffff88008590fc24 ffff8800b51a5160 
[ 3097.169626] <0> 0000000040000000 0000000000000580 ffff88008590fc08 ffffffffa05e990e 
[ 3097.169629] Call Trace:                                                             
[ 3097.169634]  [<ffffffffa05e990e>] rt2x00usb_regbusy_read+0x6e/0x100 [rt2x00usb]     
[ 3097.169639]  [<ffffffffa05f0f93>] rt2800_read_eeprom_efuse+0xa3/0x140 [rt2800lib]   
[ 3097.169643]  [<ffffffffa05f85f8>] rt2800usb_probe_hw+0x28/0xd0 [rt2800usb]          
[ 3097.169649]  [<ffffffffa05deb49>] rt2x00lib_probe_dev+0x79/0x3e0 [rt2x00lib]        
[ 3097.169654]  [<ffffffff8106a893>] ? round_jiffies+0x13/0x20                         
[ 3097.169657]  [<ffffffff8111634f>] ? __kmalloc+0x19f/0x1d0                           
[ 3097.169661]  [<ffffffffa05ea0ba>] ? rt2x00usb_probe+0xda/0x1e4 [rt2x00usb]          
[ 3097.169664]  [<ffffffffa05ea0ce>] rt2x00usb_probe+0xee/0x1e4 [rt2x00usb]            
[ 3097.169669]  [<ffffffff813a25ed>] ? usb_autopm_do_device+0x7d/0x120                 
[ 3097.169672]  [<ffffffff813a2e71>] usb_probe_interface+0xb1/0x190                    
[ 3097.169675]  [<ffffffff81320d74>] really_probe+0x64/0x160
[ 3097.169677]  [<ffffffff81320e93>] driver_probe_device+0x23/0x30
[ 3097.169680]  [<ffffffff81320f33>] __driver_attach+0x93/0xa0
[ 3097.169682]  [<ffffffff81320ea0>] ? __driver_attach+0x0/0xa0
[ 3097.169685]  [<ffffffff81320258>] bus_for_each_dev+0x68/0x90
[ 3097.169688]  [<ffffffff81320bf9>] driver_attach+0x19/0x20
[ 3097.169691]  [<ffffffff8132050d>] bus_add_driver+0xcd/0x2a0
[ 3097.169693]  [<ffffffff81321228>] driver_register+0x78/0x140
[ 3097.169697]  [<ffffffff8127834a>] ? __up_read+0x9a/0xc0
[ 3097.169700]  [<ffffffff813a22c8>] usb_register_driver+0xb8/0x130
[ 3097.169703]  [<ffffffffa03a4000>] ? rt2800usb_init+0x0/0x20 [rt2800usb]
[ 3097.169707]  [<ffffffffa03a401e>] rt2800usb_init+0x1e/0x20 [rt2800usb]
[ 3097.169711]  [<ffffffff8100a047>] do_one_initcall+0x37/0x1a0
[ 3097.169715]  [<ffffffff81091b67>] sys_init_module+0xd7/0x230
[ 3097.169719]  [<ffffffff81012002>] system_call_fastpath+0x16/0x1b
[ 3097.169720] Code: 00 00 41 0f b7 ce 41 0f b6 f7 ba 40 00 00 00 48 89 df 44 89 24 24 44 89 44 24 08 45 31 c0 e8 24 fd ff ff 41 89 c6 e9 44 ff ff ff <0f> 0b eb fe 0f 1f 84 00 00 00 00 00 55 b8 ed ff ff ff 48 89 e5
[ 3097.169745] RIP  [<ffffffffa05e9894>] rt2x00usb_vendor_req_buff_lock+0x144/0x150 [rt2x00usb]
[ 3097.169749]  RSP <ffff88008590fb48>
[ 3097.169752] ---[ end trace cbda2d531f936fa4 ]---


The RT2070L is a stripped-down RT3070 variant without 802.11n support.

-- 
OpenPGP/GnuPG Key: 0xB2204FA0 @ subkeys.pgp.net
