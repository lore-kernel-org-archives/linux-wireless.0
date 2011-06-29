Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nm10.bullet.mail.bf1.yahoo.com ([98.139.212.169]:41868 "HELO
	nm10.bullet.mail.bf1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1753750Ab1F2J2F convert rfc822-to-8bit
	(ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 29 Jun 2011 05:28:05 -0400
Message-ID: <1309339683.73960.YahooMailRC@web161214.mail.bf1.yahoo.com> (sfid-20110629_112809_830082_A0646A99)
Date: Wed, 29 Jun 2011 02:28:03 -0700 (PDT)
From: Joerg Pommnitz <pommnitz@yahoo.com>
Subject: ath5k crash (NULL pointer access) when changing ANI
To: linux-wireless@vger.kernel.org, ath5k-devel@lists.ath5k.org
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hello all,
ath5k will immediately crash when issuing the following command:

echo 2 > /sys/class/ieee80211/phy0/device/ani/ani_mode

The crash log looks like this:

[   66.425365] BUG: unable to handle kernel NULL pointer dereference at 00000100
[   66.425652] IP: [<e08e3008>] ath5k_ani_init+0xe/0x399 [ath5k]
[   66.425856] *pdpt = 000000001f105001 *pde = 000000001cfff067 *pte = 
0000000000000000 

[   66.425856] Oops: 0000 [#1] SMP 
[   66.425856] last sysfs file: 
/sys/devices/pci0000:00/0000:00:1e.0/0000:01:00.0/ani/ani_mode
[   66.425856] Modules linked in: arc4 ath5k ath mac80211 cfg80211 i2c_i801 
e1000 e100 i2c_core iTCO_wdt rfkill mii serio_raw iTCO_vendor_support ipv6 uas 
usb_storage [last unloaded: scsi_wait_scan]
[   66.425856] 
[   66.425856] Pid: 758, comm: bash Not tainted 2.6.38.7-30.fc15.i686.PAE #1  
[   66.425856] EIP: 0060:[<e08e3008>] EFLAGS: 00010282 CPU: 0
[   66.425856] EIP is at ath5k_ani_init+0xe/0x399 [ath5k]
[   66.425856] EAX: 00000000 EBX: dc6d82c0 ECX: 00000028 EDX: 00000002
[   66.425856] ESI: df08e000 EDI: 00000002 EBP: dc08bf20 ESP: dc08bf04
[   66.425856]  DS: 007b ES: 007b FS: 00d8 GS: 00e0 SS: 0068
[   66.425856] Process bash (pid: 758, ti=dc08a000 task=df249920 
task.ti=dc08a000)
[   66.425856] Stack:
[   66.425856]  00000000 00000000 dc6d82c0 df08e000 dc6d82c0 df08e000 00000002 
dc08bf30
[   66.425856]  e08e389e e08e3870 00000002 dc08bf44 c067f51e 00000002 c0827d7c 
ffffffed
[   66.425856]  dc08bf70 c0535901 00000002 b7695000 c0827d7c dc6b4454 de103068 
dc3ed5d0
[   66.425856] Call Trace:
[   66.425856]  [<e08e389e>] ath5k_attr_store_ani_mode+0x2e/0x35 [ath5k]
[   66.425856]  [<e08e3870>] ? ath5k_attr_store_ani_mode+0x0/0x35 [ath5k]
[   66.425856]  [<c067f51e>] dev_attr_store+0x24/0x29
[   66.425856]  [<c0535901>] sysfs_write_file+0xc3/0xee
[   66.425856]  [<c04ede4e>] vfs_write+0x8f/0xd7
[   66.425856]  [<c053583e>] ? sysfs_write_file+0x0/0xee
[   66.425856]  [<c04ee010>] sys_write+0x42/0x63
[   66.425856]  [<c040969f>] sysenter_do_call+0x12/0x28
[   66.425856] Code: 35 00 00 81 fa c8 00 00 00 76 10 8b 80 ec 00 00 00 05 50 35 
00 00 e8 08 f2 ff ff 5d c3 55 89 e5 57 56 53 83 ec 10 3e 8d 74 26 00 

[   66.425856]  b8 00 01 00 00 01 89 c3 89 d6 0f 86 72 03 00 00 8b 90 ec 00 
[   66.425856] EIP: [<e08e3008>] ath5k_ani_init+0xe/0x399 [ath5k] SS:ESP 
0068:dc08bf04
[   66.425856] CR2: 0000000000000100
[   66.440753] ---[ end trace c4184f758b4246d0 ]---

BTW, is there any documentation about the different values in "ani_mode"?

 -- 
Regards 
Joerg 
