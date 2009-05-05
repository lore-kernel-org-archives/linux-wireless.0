Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-bw0-f174.google.com ([209.85.218.174]:33123 "EHLO
	mail-bw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751332AbZEEFEd (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 5 May 2009 01:04:33 -0400
Received: by bwz22 with SMTP id 22so947238bwz.37
        for <linux-wireless@vger.kernel.org>; Mon, 04 May 2009 22:04:32 -0700 (PDT)
Subject: [BUG] Crda oopses the system
From: Maxim Levitsky <maximlevitsky@gmail.com>
To: iwlwifi maling list <ipw3945-devel@lists.sourceforge.net>
Cc: linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain
Date: Tue, 05 May 2009 08:04:27 +0300
Message-Id: <1241499867.4816.18.camel@maxim-laptop>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Here what I see:


> May  4 16:35:14 maxim-laptop kernel: [16939.109054] Process crda (pid: 29344, threadinfo ffff88007deaa000, task ffff880067369600)
> May  4 16:35:14 maxim-laptop kernel: [16939.109058] Stack:
> May  4 16:35:14 maxim-laptop kernel: [16939.109061]  0000000000000034 ffff88003fb8a640 0000000000000000 ffff8800634f5c20
> May  4 16:35:14 maxim-laptop kernel: [16939.109069]  ffff88007deaba28 ffffffffa00eb3d0 000004f87deab9c8 ffff88003fb8a640
> May  4 16:35:14 maxim-laptop kernel: [16939.109077]  0000000000000000 ffff8800634f5c24 ffff8800634f5c2c ffff8800634f5c34
> May  4 16:35:14 maxim-laptop kernel: [16939.109086] Call Trace:
> May  4 16:35:14 maxim-laptop kernel: [16939.109091]  [<ffffffffa00eb3d0>] nl80211_set_reg+0x100/0x2b0 [cfg80211]
> May  4 16:35:14 maxim-laptop kernel: [16939.109107]  [<ffffffff803e697f>] ? nla_parse+0xef/0x110
> May  4 16:35:14 maxim-laptop kernel: [16939.109118]  [<ffffffff80513716>] genl_rcv_msg+0x1b6/0x1f0
> May  4 16:35:14 maxim-laptop kernel: [16939.109126]  [<ffffffff80513560>] ? genl_rcv_msg+0x0/0x1f0
> May  4 16:35:14 maxim-laptop kernel: [16939.109132]  [<ffffffff80512d49>] netlink_rcv_skb+0x89/0xb0
> May  4 16:35:14 maxim-laptop kernel: [16939.109140]  [<ffffffff80513547>] genl_rcv+0x27/0x40
> May  4 16:35:14 maxim-laptop kernel: [16939.109146]  [<ffffffff805128a9>] ? netlink_sendmsg+0x159/0x300
> May  4 16:35:14 maxim-laptop kernel: [16939.109153]  [<ffffffff80512734>] netlink_unicast+0x2c4/0x2e0
> May  4 16:35:14 maxim-laptop kernel: [16939.109161]  [<ffffffff804f356e>] ? __alloc_skb+0x6e/0x150
> May  4 16:35:14 maxim-laptop kernel: [16939.109169]  [<ffffffff8051294e>] netlink_sendmsg+0x1fe/0x300
> May  4 16:35:14 maxim-laptop kernel: [16939.109176]  [<ffffffff804ea607>] sock_sendmsg+0x127/0x140
> May  4 16:35:14 maxim-laptop kernel: [16939.109183]  [<ffffffff8025be50>] ? autoremove_wake_function+0x0/0x40
> May  4 16:35:14 maxim-laptop kernel: [16939.109193]  [<ffffffff8029f986>] ? get_page_from_freelist+0x3b6/0x650
> May  4 16:35:14 maxim-laptop kernel: [16939.109201]  [<ffffffff80299985>] ? find_lock_page+0x25/0x70
> May  4 16:35:14 maxim-laptop kernel: [16939.109208]  [<ffffffff804e924b>] ? move_addr_to_kernel+0x2b/0x40
> May  4 16:35:14 maxim-laptop kernel: [16939.109214]  [<ffffffff804f4b8c>] ? verify_iovec+0x3c/0xd0
> May  4 16:35:14 maxim-laptop kernel: [16939.109221]  [<ffffffff804ea7a9>] sys_sendmsg+0x189/0x320
> May  4 16:35:14 maxim-laptop kernel: [16939.109228]  [<ffffffff804eb635>] ? move_addr_to_user+0x65/0x80
> May  4 16:35:14 maxim-laptop kernel: [16939.109235]  [<ffffffff802b1651>] ? handle_mm_fault+0x1e1/0x830
> May  4 16:35:14 maxim-laptop kernel: [16939.109243]  [<ffffffff803d8f21>] ? __up_read+0x91/0xb0
> May  4 16:35:14 maxim-laptop kernel: [16939.109252]  [<ffffffff8020bf2b>] system_call_fastpath+0x16/0x1b
> May  4 16:35:14 maxim-laptop kernel: [16939.109261] Code: a1 00 00 00 0f be 50 39 0f be 70 38 48 c7 c7 70 07 0f a0 31 c0 e8 15 da 49 e0 e9 55 fe ff ff 0f 0b eb fe 0f 0b eb fe 0f 0b eb fe <0f> 0b eb fe 48 8b 35 e5 38 01 00 4c 89 e7 e8 05 f9 ff ff 49 89 
> May  4 16:35:14 maxim-laptop kernel: [16939.109329] RIP  [<ffffffffa00e4f58>] set_regdom+0x428/0x4c0 [cfg80211]
> May  4 16:35:14 maxim-laptop kernel: [16939.109344]  RSP <ffff88007deab978>
> May  4 16:35:14 maxim-laptop kernel: [16939.109350] ---[ end trace 695815cef5ce0efe ]---
> 

This happens @ my university where APs send country code, and thus NM calls crda to apply it.
(I already applied it in initscripts)

intel 3945 device, iwlwifi.git commit 
#5a94b6d38100b7056a5a347e5c51359d924d305d

Best regards,
	Maxim Levitsky

