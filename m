Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-oi0-f67.google.com ([209.85.218.67]:43574 "EHLO
        mail-oi0-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754070AbeASL2Z (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 19 Jan 2018 06:28:25 -0500
MIME-Version: 1.0
In-Reply-To: <87d1269mes.fsf@kamboji.qca.qualcomm.com>
References: <70aa931f-2f02-dd26-c98b-695d1321f71b@molgen.mpg.de> <87d1269mes.fsf@kamboji.qca.qualcomm.com>
From: Andrey Ryabinin <ryabinin.a.a@gmail.com>
Date: Fri, 19 Jan 2018 14:28:24 +0300
Message-ID: <CAPAsAGz1pihgiBML7CExjKgFkVC5SLkN=+183gJJOFGv29Fd-A@mail.gmail.com> (sfid-20180119_122831_660032_2C0DC2F1)
Subject: Re: UBSAN: Undefined behaviour in drivers/net/wireless/ath/ath10k/mac.c:3092:53:
 signed integer overflow
To: Kalle Valo <kvalo@codeaurora.org>
Cc: Paul Menzel <pmenzel+linux-ath10k@molgen.mpg.de>,
        ath10k@lists.infradead.org, LKML <linux-kernel@vger.kernel.org>,
        Mario Limonciello <mario.limonciello@dell.com>,
        it+linux-ath10k@molgen.mpg.de,
        linux-wireless <linux-wireless@vger.kernel.org>,
        Felix Fietkau <nbd@openwrt.org>,
        Johannes Berg <johannes.berg@intel.com>,
        Michal Kazior <michal.kazior@tieto.com>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

2018-01-19 13:24 GMT+03:00 Kalle Valo <kvalo@codeaurora.org>:
> Adding linux-wireless.
>
> For linux-wireless the full report is here:
>
> https://lkml.kernel.org/r/70aa931f-2f02-dd26-c98b-695d1321f71b@molgen.mpg=
.de
>
> Paul Menzel <pmenzel+linux-ath10k@molgen.mpg.de> writes:
>
>> I enabled the undefined behavior sanitizer, and built Linus=E2=80=99 mas=
ter
>> branch under Ubuntu 16.04 with gcc (Ubuntu 5.4.0-6ubuntu1~16.04.5)
>> 5.4.0 20160609.
>
> As you just recently enabled UBSAN I guess I can assume that this isn't
> a new regression but instead the bug is an old issue?
>
> Can you reproduce the problem easily? That would help with testing
> patches.
>
>> =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D
>> [  960.737730] UBSAN: Undefined behaviour in
>> drivers/net/wireless/ath/ath10k/mac.c:3092:53
>
> This line is from ath10k_update_channel_list():
>
>                         ch->max_antenna_gain =3D channel->max_antenna_gai=
n * 2;
>
>> [  960.737733] signed integer overflow:
>> [  960.737735] 2147483647 * 2 cannot be represented in type 'int'
>
> 2147483647 is MAX_INT but I can't immeaditely figure out where that's
> coming from. Maybe unitialised stack somewhere?
>

It comes from wiphy_register(), where INT_MAX assigned to channels[i].orig_=
mag.
See c4a9fafc77a5 ("cfg80211: fix antenna gain handling")

Later ->orig_mag copied into ->max_antenna_gain in resotre_custom_reg_setti=
ngs()
And finally ath10k_update_channel_list() multiplies ->max_antenna_gain by 2
( since commit 02256930d9b8 ("ath10k: use proper tx power unit") ).



>> [  960.737738] CPU: 1 PID: 2663 Comm: crda Not tainted 4.15.0-rc6+ #36
>> [  960.737739] Hardware name: Dell Inc. XPS 13 9360/0839Y6, BIOS 2.4.2
>> 11/21/2017
>> [  960.737740] Call Trace:
>> [  960.737749]  dump_stack+0x70/0xb2
>> [  960.737753]  ubsan_epilogue+0x9/0x40
>> [  960.737758]  handle_overflow+0xce/0xf0
>> [  960.737762]  ? ecryptfs_decode_and_decrypt_filename+0x104/0x530
>> [  960.737764]  ? __kmalloc+0x265/0x370
>> [  960.737774]  ath10k_regd_update+0x39d/0x5f0 [ath10k_core]
>> [  960.737782]  ath10k_reg_notifier+0x114/0x180 [ath10k_core]
>> [  960.737802]  set_regdom+0x275/0x910 [cfg80211]
>> [  960.737821]  nl80211_set_reg+0x19c/0x630 [cfg80211]
>> [  960.737826]  genl_family_rcv_msg+0x2c4/0x610
>> [  960.737830]  ? radix_tree_next_chunk+0x9f/0x570
>> [  960.737832]  genl_rcv_msg+0x5d/0xe0
>> [  960.737835]  ? __alloc_skb+0x82/0x260
>> [  960.737838]  ? genl_family_rcv_msg+0x610/0x610
>> [  960.737840]  netlink_rcv_skb+0xd5/0x130
>> [  960.737842]  genl_rcv+0x24/0x40
>> [  960.737844]  netlink_unicast+0x1cc/0x300
>> [  960.737847]  netlink_sendmsg+0x29a/0x5f0
>> [  960.737850]  sock_sendmsg+0x4c/0xa0
>> [  960.737853]  ___sys_sendmsg+0x30e/0x440
>> [  960.737857]  ? pagevec_lru_move_fn+0xc3/0x130
>> [  960.737859]  ? trace_event_raw_event_mm_lru_activate+0x100/0x100
>> [  960.737862]  ? __lru_cache_add+0x6a/0xb0
>> [  960.737865]  ? __sys_sendmsg+0x51/0x90
>> [  960.737868]  __sys_sendmsg+0x51/0x90
>> [  960.737872]  entry_SYSCALL_64_fastpath+0x1e/0x81
>
