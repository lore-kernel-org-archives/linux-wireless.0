Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-bw0-f46.google.com ([209.85.214.46]:55571 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751024Ab0KQNGy convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 17 Nov 2010 08:06:54 -0500
Received: by bwz15 with SMTP id 15so1575093bwz.19
        for <linux-wireless@vger.kernel.org>; Wed, 17 Nov 2010 05:06:53 -0800 (PST)
From: Helmut Schaa <helmut.schaa@googlemail.com>
To: linux-wireless@vger.kernel.org
Subject: mac80211 oops with AP vlan interfaces
Date: Wed, 17 Nov 2010 14:05:50 +0100
Cc: Johannes Berg <johannes@sipsolutions.net>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="us-ascii"
Message-Id: <201011171405.50553.helmut.schaa@googlemail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi,

I get the following oops when removing an AP mode VLAN interface with an
associated wifi client (not sure if it also happens without associated
clients).

The problem is that ieee80211_do_stop clears sdata->bss while
ieee80211_teardown_sdata (which is called afterwards) tries to free all
associated keys which relies on the bss pointer being correct.

>From key.c:

137         if (sdata->vif.type == NL80211_IFTYPE_AP_VLAN)
138                 sdata = container_of(sdata->bss,
139                                      struct ieee80211_sub_if_data,
140                                      u.ap);

Since sdata->bss isn't set here anymore container_of gives us an invalid
pointer and we pass an invalid sdata pointer to the driver.

Any ideas how to fix that? I thought about simply adding a sdata pointer to
the vlan interface struct instead of relying on the bss pointer.

Thanks,
Helmut

[  233.560000] CPU 0 Unable to handle kernel paging request at virtual address 00000195, epc == 80ea1660, ra == 80ea164c
[  233.580000] Oops[#1]:
[  233.580000] Cpu 0
[  233.580000] $ 0   : 00000000 00000001 80ebb7a8 ffffffe4
[  233.580000] $ 4   : 819a7a8c 00000000 00000000 00000000
[  233.580000] $ 8   : 00000034 800043bc 00000001 0000000a
[  233.580000] $12   : 000000cd 00000005 00000000 2160ec00
[  233.580000] $16   : 00000000 808e9190 8180fd00 00000130
[  233.580000] $20   : 00000001 801e92e4 80132d3c 00200200
[  233.580000] $24   : 00000000 00000000                  
[  233.580000] $28   : 819a6000 819a7a48 80335990 80ea164c
[  233.580000] Hi    : 0000ea60
[  233.580000] Lo    : 00000005
[  233.580000] epc   : 80ea1660 rt2x00mac_set_key+0x84/0x1a8 [rt2x00lib]
[  233.580000]     Tainted: G        W 
[  233.580000] ra    : 80ea164c rt2x00mac_set_key+0x70/0x1a8 [rt2x00lib]
[  233.580000] Status: 1000e403    KERNEL EXL IE 
[  233.580000] Cause : 00800008
[  233.580000] BadVA : 00000195
[  233.580000] PrId  : 0001964c (MIPS 24Kc)
[  233.580000] Modules linked in: rt2800pci rt2800lib rt2x00soc rt2x00pci rt2x00lib mac80211 eeprom_93cx6 crc_itu_t crc_ccitt cfg80211 compat arc4 aes_generic deflate ecb cbc
[  233.580000] Process hostapd (pid: 1188, threadinfo=819a6000, task=808e7128, tls=00000000)
[  233.580000] Stack : 80335990 81471d20 801b22f8 81451000 00000000 00000000 00000000 00000000
[  233.580000]         00000000 00000000 00000000 00000000 00000000 00000000 00000000 00000000
[  233.580000]         00000000 800c11f0 808e9000 00000000 80eeac40 819a7b80 8180f200 80f1bb30
[  233.580000]         00000068 808e9000 80eeaae0 80eeac40 808e9190 8180f200 808e9000 80eeaae0
[  233.580000]         80eeac40 80f1bbd0 819a7ae4 800054c0 00000000 800191d4 80eeac34 80f1bcd4
[  233.580000]         ...
[  233.580000] Call Trace:
[  233.580000] [<80ea1660>] rt2x00mac_set_key+0x84/0x1a8 [rt2x00lib]
[  233.580000] [<80f1bb30>] ieee80211_key_disable_hw_accel+0x84/0xfc [mac80211]
[  233.580000] [<80f1bbd0>] __ieee80211_key_destroy+0x28/0x98 [mac80211]
[  233.580000] [<80f1bcd4>] ieee80211_free_keys+0x50/0x88 [mac80211]
[  233.580000] [<80f0fff4>] ieee80211_teardown_sdata+0x54/0x148 [mac80211]
[  233.580000] [<80137e5c>] rollback_registered_many+0x298/0x35c
[  233.580000] [<8013801c>] unregister_netdevice_queue+0x88/0xbc
[  233.580000] [<80f14318>] ieee80211_del_iface+0x10/0x20 [mac80211]
[  233.580000] [<8190d340>] nl_doit_wrapper+0x108/0x150 [compat]
[  233.580000] [<80154660>] genl_rcv_msg+0x1e8/0x22c
[  233.580000] [<80153354>] netlink_rcv_skb+0x6c/0xec
[  233.580000] [<80154460>] genl_rcv+0x30/0x48
[  233.580000] [<80152efc>] netlink_unicast+0x248/0x328
[  233.580000] [<801539b0>] netlink_sendmsg+0x288/0x2c8
[  233.580000] [<80124ca0>] sock_sendmsg+0x88/0xb8
[  233.580000] [<80125288>] sys_sendmsg+0x188/0x204
[  233.580000] [<80002544>] stack_done+0x20/0x3c
[  233.580000] 
[  233.580000] 
[  233.580000] Code: 8e420004  083a859d  afa0001c <92630065> 8c420008  2442ffff  00431024  afa2001c  0c3a9639 
