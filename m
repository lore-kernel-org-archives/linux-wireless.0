Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-bw0-f213.google.com ([209.85.218.213]:34790 "EHLO
	mail-bw0-f213.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757015AbZFWUBK (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 23 Jun 2009 16:01:10 -0400
Received: by bwz9 with SMTP id 9so316401bwz.37
        for <linux-wireless@vger.kernel.org>; Tue, 23 Jun 2009 13:01:11 -0700 (PDT)
Received: from rz by localhost.localdomain with local (Exim 4.69)
	(envelope-from <rz@linux-m68k.org>)
	id 1MJAKN-0001AZ-Lf
	for linux-wireless@vger.kernel.org; Tue, 23 Jun 2009 20:02:39 +0200
Date: Tue, 23 Jun 2009 20:02:39 +0200
From: Richard Zidlicky <rz@linux-m68k.org>
To: linux-wireless@vger.kernel.org
Subject: rt2x00 / rt73usb kernel crashes, memory corruption?
Message-ID: <20090623180239.GB3914@linux-m68k.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi,

More testing revealed that rt73usb has some other quite serious problem that appears
completely independent of the previous rate related problem - happens both with automatic
and fixed rates.

After enabling "onboot" for the rt73usb driver the kernel crashes about 1 in 5 times 
during boot - apparently after something tries to send out some kind of router queries. 
Logs show very often "wlan0: no ipv6 routers" or somesuch after the Ooops, however
sometimes it also crashes way later during the boot.
Once it survives the boot it seems to run very stable.

So far seen roughly 3 kinds of ooopses which make not much sense for me, other than memory
corruption. 
The value "000d5a0b" appears in a prominent place in almost all of these oopses somewhere - might 
be some value that the driver wanted to store to a specific location but ended up corrupting
random memory?
Any idea where in the wlan code this value comes from/belongs to?

$ lsusb 
Bus 005 Device 002: ID 148f:2573 Ralink Technology, Corp. RT2501USB Wireless Adapter

$ dmesg
[   29.478747] phy0 -> rt73usb_validate_eeprom: EEPROM recovery - NIC: 0xffef
[   29.478750] phy0 -> rt73usb_validate_eeprom: EEPROM recovery - Led: 0xe000
[   29.478752] phy0 -> rt73usb_validate_eeprom: EEPROM recovery - RSSI OFFSET A: 0x0000
[   29.479125] phy0 -> rt2x00_set_chip: Info - Chipset detected - rt: 1300, rf: 0002, rev: 0002573a.
[   29.479267] PM: Adding info for No Bus:phy0
[   29.770912] phy0: Selected rate control algorithm 'minstrel'
[   29.771130] PM: Adding info for No Bus:wlan0
[   29.771435] PM: Adding info for No Bus:rt73usb-phy0::radio
[   29.771515] Registered led device: rt73usb-phy0::radio
[   29.771531] PM: Adding info for No Bus:rt73usb-phy0::assoc
[   29.771546] Registered led device: rt73usb-phy0::assoc
[   29.771564] PM: Adding info for No Bus:rt73usb-phy0::quality
[   29.771580] Registered led device: rt73usb-phy0::quality
[   29.772219] usbcore: registered new interface driver rt73usb
[   29.905175] usbcore: registered new interface driver rt2500usb
[   42.956365] rt73usb 5-3:1.0: firmware: requesting rt73.bin
[   42.981638] phy0 -> rt2x00lib_request_firmware: Info - Firmware detected - version: 1.7.
[   43.056513] phy0 -> rt2x00mac_conf_tx: Info - Configured TX queue 0 - CWmin: 5, CWmax: 10, Aifs: 2, TXop: 0.
[   43.058510] phy0 -> rt2x00mac_conf_tx: Info - Configured TX queue 1 - CWmin: 5, CWmax: 10, Aifs: 2, TXop: 0.
[   43.060510] phy0 -> rt2x00mac_conf_tx: Info - Configured TX queue 2 - CWmin: 5, CWmax: 10, Aifs: 2, TXop: 0.
[   43.062510] phy0 -> rt2x00mac_conf_tx: Info - Configured TX queue 3 - CWmin: 5, CWmax: 10, Aifs: 2, TXop: 0.

ifcfg-wlan0:
# Please read /usr/share/doc/initscripts-*/sysconfig.txt
# for the documentation of these parameters.
USERCTL=yes
PEERDNS=yes
IPV6INIT=no
GATEWAY=10.42.44.1
TYPE=Wireless
DEVICE=wlan0
BOOTPROTO=none
NETMASK=255.255.255.0
IPADDR=10.42.44.1
ESSID=xxx-xxx
MODE=Ad-Hoc
RATE=18M
NM_CONTROLLED=yes          ## thats a lie because I killed network manager completely
HWADDR=00:23:cd:c0:5d:4c
ONBOOT=yes
CHANNEL=1



Example ooops bellow.

Richard


Jun 23 16:19:49 localhost rpc.statd[2457]: Version 1.1.4 Starting
Jun 23 16:19:49 localhost kernel: [   41.617557] BUG: unable to handle kernel paging request at 000d5a0b
Jun 23 16:19:49 localhost kernel: [   41.617690] IP: [<c0452d72>] m_show+0x78/0x122
Jun 23 16:19:49 localhost kernel: [   41.617772] *pde = 00000000 
Jun 23 16:19:49 localhost kernel: [   41.617845] Oops: 0000 [#1] SMP 
Jun 23 16:19:49 localhost kernel: [   41.617942] last sysfs file: /sys/devices/system/cpu/cpu1/cache/index2/shared_cpu_map
Jun 23 16:19:49 localhost kernel: [   41.618003] Modules linked in: ipv6 binfmt_misc nls_utf8 isofs loop dm_multipath uinput rt2500usb arc4 ecb snd_hda_codec_realtek xt_multiport snd_hda_intel nf_conntrack_ipv4 snd_hda_codec rt73usb nf_defrag_ipv4 crc_itu_t snd_hwdep snd_seq_dummy xt_state rt2x00usb snd_seq_oss rt2x00lib nf_conntrack snd_seq_midi_event snd_seq xt_tcpudp led_class snd_seq_device ipt_LOG input_polldev xt_limit mac80211 snd_pcm_oss snd_mixer_oss iptable_filter ip_tables snd_pcm x_tables snd_timer ppdev snd parport_pc cfg80211 iTCO_wdt intel_agp parport r8169 soundcore iTCO_vendor_support snd_page_alloc mii rtc_cmos i2c_i801 thermal agpgart pcspkr button i2c_core ata_generic pata_acpi sha256_generic cbc aes_i586 aes_generic dm_crypt dm_snapshot dm_zero dm_mirror dm_region_hash dm_log dm_mod ehci_hcd [last unloaded: processor]
Jun 23 16:19:49 localhost kernel: [   41.618003] 
Jun 23 16:19:49 localhost kernel: [   41.618003] Pid: 2478, comm: lsmod Not tainted (2.6.30v2 #3) To Be Filled By O.E.M.
Jun 23 16:19:49 localhost kernel: [   41.618003] EIP: 0060:[<c0452d72>] EFLAGS: 00010282 CPU: 0
Jun 23 16:19:49 localhost kernel: [   41.618003] EIP is at m_show+0x78/0x122
Jun 23 16:19:49 localhost kernel: [   41.618003] EAX: 00000000 EBX: 000d5a0b ECX: f6188000 EDX: 00000001
Jun 23 16:19:49 localhost kernel: [   41.618003] ESI: f8b9bb7c EDI: f6a61300 EBP: f61b3f08 ESP: f61b3eec
Jun 23 16:19:49 localhost kernel: [   41.618003]  DS: 007b ES: 007b FS: 00d8 GS: 0033 SS: 0068
Jun 23 16:19:49 localhost kernel: [   41.618003] Process lsmod (pid: 2478, ti=f61b2000 task=f61511b0 task.ti=f61b2000)
Jun 23 16:19:49 localhost kernel: [   41.618003] Stack:
Jun 23 16:19:49 localhost kernel: [   41.618003]  f8b9bb80 f8b9bcb4 f6a61300 f6187000 c0707e90 f6a61300 000003dc f61b3f48
Jun 23 16:19:49 localhost kernel: [   41.618003]  c04bcb96 00000400 b7f26000 f6b75f00 f6a61328 00000000 f8b9bb80 00001000
Jun 23 16:19:49 localhost kernel: [   41.618003]  00000018 00000000 00000017 00000000 fffffffb f708e580 c04bc90c f61b3f6c
Jun 23 16:19:49 localhost kernel: [   41.618003] Call Trace:
Jun 23 16:19:49 localhost kernel: [   41.618003]  [<c04bcb96>] ? seq_read+0x28a/0x356
Jun 23 16:19:49 localhost kernel: [   41.618003]  [<c04bc90c>] ? seq_read+0x0/0x356
Jun 23 16:19:49 localhost kernel: [   41.618003]  [<c04dbbf5>] ? proc_reg_read+0x60/0x74
Jun 23 16:19:49 localhost kernel: [   41.618003]  [<c04dbb95>] ? proc_reg_read+0x0/0x74
Jun 23 16:19:49 localhost kernel: [   41.618003]  [<c04a8665>] ? vfs_read+0x87/0x12b
Jun 23 16:19:49 localhost kernel: [   41.618003]  [<c04a87a2>] ? sys_read+0x3b/0x60
Jun 23 16:19:49 localhost kernel: [   41.618003]  [<c04031dd>] ? syscall_call+0x7/0xb
Jun 23 16:19:49 localhost kernel: [   41.618003] Code: 00 00 05 34 01 00 00 89 45 e8 83 c4 1c eb 1c 8b 43 08 83 c0 0c 50 68 74 8d 7f c0 57 e8 30 9a 06 00 8b 1b ba 01 00 00 00 83 c4 0c <8b> 03 0f 18 00 90 3b 5d e8 75 d9 83 be d4 00 00 00 00 74 10 83 
Jun 23 16:19:49 localhost kernel: [   41.618003] EIP: [<c0452d72>] m_show+0x78/0x122 SS:ESP 0068:f61b3eec
Jun 23 16:19:49 localhost kernel: [   41.618003] CR2: 00000000000d5a0b
Jun 23 16:19:49 localhost kernel: [   41.623658] ---[ end trace af974b5571f7be2d ]---
