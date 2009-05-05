Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ew0-f224.google.com ([209.85.219.224]:41201 "EHLO
	mail-ew0-f224.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752012AbZEESrF convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 5 May 2009 14:47:05 -0400
Received: by ewy24 with SMTP id 24so5263763ewy.37
        for <linux-wireless@vger.kernel.org>; Tue, 05 May 2009 11:47:04 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1241499867.4816.18.camel@maxim-laptop>
References: <1241499867.4816.18.camel@maxim-laptop>
From: "Luis R. Rodriguez" <mcgrof@gmail.com>
Date: Tue, 5 May 2009 11:46:48 -0700
Message-ID: <43e72e890905051146n48bdad57s9db40a6e016cb81b@mail.gmail.com>
Subject: Re: [BUG] Crda oopses the system
To: Maxim Levitsky <maximlevitsky@gmail.com>
Cc: iwlwifi maling list <ipw3945-devel@lists.sourceforge.net>,
	linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, May 4, 2009 at 10:04 PM, Maxim Levitsky <maximlevitsky@gmail.co=
m> wrote:
> Here what I see:
>
>
>> May =C2=A04 16:35:14 maxim-laptop kernel: [16939.109054] Process crd=
a (pid: 29344, threadinfo ffff88007deaa000, task ffff880067369600)
>> May =C2=A04 16:35:14 maxim-laptop kernel: [16939.109058] Stack:
>> May =C2=A04 16:35:14 maxim-laptop kernel: [16939.109061] =C2=A000000=
00000000034 ffff88003fb8a640 0000000000000000 ffff8800634f5c20
>> May =C2=A04 16:35:14 maxim-laptop kernel: [16939.109069] =C2=A0ffff8=
8007deaba28 ffffffffa00eb3d0 000004f87deab9c8 ffff88003fb8a640
>> May =C2=A04 16:35:14 maxim-laptop kernel: [16939.109077] =C2=A000000=
00000000000 ffff8800634f5c24 ffff8800634f5c2c ffff8800634f5c34
>> May =C2=A04 16:35:14 maxim-laptop kernel: [16939.109086] Call Trace:
>> May =C2=A04 16:35:14 maxim-laptop kernel: [16939.109091] =C2=A0[<fff=
fffffa00eb3d0>] nl80211_set_reg+0x100/0x2b0 [cfg80211]
>> May =C2=A04 16:35:14 maxim-laptop kernel: [16939.109107] =C2=A0[<fff=
fffff803e697f>] ? nla_parse+0xef/0x110
>> May =C2=A04 16:35:14 maxim-laptop kernel: [16939.109118] =C2=A0[<fff=
fffff80513716>] genl_rcv_msg+0x1b6/0x1f0
>> May =C2=A04 16:35:14 maxim-laptop kernel: [16939.109126] =C2=A0[<fff=
fffff80513560>] ? genl_rcv_msg+0x0/0x1f0
>> May =C2=A04 16:35:14 maxim-laptop kernel: [16939.109132] =C2=A0[<fff=
fffff80512d49>] netlink_rcv_skb+0x89/0xb0
>> May =C2=A04 16:35:14 maxim-laptop kernel: [16939.109140] =C2=A0[<fff=
fffff80513547>] genl_rcv+0x27/0x40
>> May =C2=A04 16:35:14 maxim-laptop kernel: [16939.109146] =C2=A0[<fff=
fffff805128a9>] ? netlink_sendmsg+0x159/0x300
>> May =C2=A04 16:35:14 maxim-laptop kernel: [16939.109153] =C2=A0[<fff=
fffff80512734>] netlink_unicast+0x2c4/0x2e0
>> May =C2=A04 16:35:14 maxim-laptop kernel: [16939.109161] =C2=A0[<fff=
fffff804f356e>] ? __alloc_skb+0x6e/0x150
>> May =C2=A04 16:35:14 maxim-laptop kernel: [16939.109169] =C2=A0[<fff=
fffff8051294e>] netlink_sendmsg+0x1fe/0x300
>> May =C2=A04 16:35:14 maxim-laptop kernel: [16939.109176] =C2=A0[<fff=
fffff804ea607>] sock_sendmsg+0x127/0x140
>> May =C2=A04 16:35:14 maxim-laptop kernel: [16939.109183] =C2=A0[<fff=
fffff8025be50>] ? autoremove_wake_function+0x0/0x40
>> May =C2=A04 16:35:14 maxim-laptop kernel: [16939.109193] =C2=A0[<fff=
fffff8029f986>] ? get_page_from_freelist+0x3b6/0x650
>> May =C2=A04 16:35:14 maxim-laptop kernel: [16939.109201] =C2=A0[<fff=
fffff80299985>] ? find_lock_page+0x25/0x70
>> May =C2=A04 16:35:14 maxim-laptop kernel: [16939.109208] =C2=A0[<fff=
fffff804e924b>] ? move_addr_to_kernel+0x2b/0x40
>> May =C2=A04 16:35:14 maxim-laptop kernel: [16939.109214] =C2=A0[<fff=
fffff804f4b8c>] ? verify_iovec+0x3c/0xd0
>> May =C2=A04 16:35:14 maxim-laptop kernel: [16939.109221] =C2=A0[<fff=
fffff804ea7a9>] sys_sendmsg+0x189/0x320
>> May =C2=A04 16:35:14 maxim-laptop kernel: [16939.109228] =C2=A0[<fff=
fffff804eb635>] ? move_addr_to_user+0x65/0x80
>> May =C2=A04 16:35:14 maxim-laptop kernel: [16939.109235] =C2=A0[<fff=
fffff802b1651>] ? handle_mm_fault+0x1e1/0x830
>> May =C2=A04 16:35:14 maxim-laptop kernel: [16939.109243] =C2=A0[<fff=
fffff803d8f21>] ? __up_read+0x91/0xb0
>> May =C2=A04 16:35:14 maxim-laptop kernel: [16939.109252] =C2=A0[<fff=
fffff8020bf2b>] system_call_fastpath+0x16/0x1b
>> May =C2=A04 16:35:14 maxim-laptop kernel: [16939.109261] Code: a1 00=
 00 00 0f be 50 39 0f be 70 38 48 c7 c7 70 07 0f a0 31 c0 e8 15 da 49 e=
0 e9 55 fe ff ff 0f 0b eb fe 0f 0b eb fe 0f 0b eb fe <0f> 0b eb fe 48 8=
b 35 e5 38 01 00 4c 89 e7 e8 05 f9 ff ff 49 89
>> May =C2=A04 16:35:14 maxim-laptop kernel: [16939.109329] RIP =C2=A0[=
<ffffffffa00e4f58>] set_regdom+0x428/0x4c0 [cfg80211]
>> May =C2=A04 16:35:14 maxim-laptop kernel: [16939.109344] =C2=A0RSP <=
ffff88007deab978>
>> May =C2=A04 16:35:14 maxim-laptop kernel: [16939.109350] ---[ end tr=
ace 695815cef5ce0efe ]---
>>
>
> This happens @ my university where APs send country code, and thus NM=
 calls crda to apply it.
> (I already applied it in initscripts)
>
> intel 3945 device, iwlwifi.git commit
> #5a94b6d38100b7056a5a347e5c51359d924d305d

Please use wireless-testing.

  Luis
--
To unsubscribe from this list: send the line "unsubscribe linux-wireles=
s" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
