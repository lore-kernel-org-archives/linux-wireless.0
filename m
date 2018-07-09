Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pl0-f66.google.com ([209.85.160.66]:45478 "EHLO
        mail-pl0-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932956AbeGIVFK (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 9 Jul 2018 17:05:10 -0400
Subject: Re: INFO: rcu detected stall in llcp_sock_sendmsg
To: Dmitry Vyukov <dvyukov@google.com>,
        syzbot <syzbot+e9f364d3b15ce41d8451@syzkaller.appspotmail.com>,
        Samuel Ortiz <sameo@linux.intel.com>,
        David Miller <davem@davemloft.net>,
        linux-wireless@vger.kernel.org, netdev <netdev@vger.kernel.org>
Cc: LKML <linux-kernel@vger.kernel.org>,
        Petr Mladek <pmladek@suse.com>,
        Steven Rostedt <rostedt@goodmis.org>,
        Sergey Senozhatsky <sergey.senozhatsky@gmail.com>,
        syzkaller-bugs <syzkaller-bugs@googlegroups.com>
References: <0000000000000cc1f0057096efe6@google.com>
 <CACT4Y+Zc+UKpGwEEMfKOsZ1s+AAFYFrVmjO0-u7NNjODRiJ7tg@mail.gmail.com>
From: Eric Dumazet <eric.dumazet@gmail.com>
Message-ID: <6e2e4cfa-2cde-ec28-933d-1ee17c8b1da9@gmail.com> (sfid-20180709_230535_491023_87AF2B83)
Date: Mon, 9 Jul 2018 14:05:08 -0700
MIME-Version: 1.0
In-Reply-To: <CACT4Y+Zc+UKpGwEEMfKOsZ1s+AAFYFrVmjO0-u7NNjODRiJ7tg@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>



On 07/09/2018 01:50 PM, Dmitry Vyukov wrote:
> On Mon, Jul 9, 2018 at 10:34 PM, syzbot
> <syzbot+e9f364d3b15ce41d8451@syzkaller.appspotmail.com> wrote:
>> Hello,
>>
>> syzbot found the following crash on:
>>
>> HEAD commit:    1e4b044d2251 Linux 4.18-rc4
>> git tree:       upstream
>> console output: https://syzkaller.appspot.com/x/log.txt?x=1414c2c2400000
>> kernel config:  https://syzkaller.appspot.com/x/.config?x=25856fac4e580aa7
>> dashboard link: https://syzkaller.appspot.com/bug?extid=e9f364d3b15ce41d8451
>> compiler:       gcc (GCC) 8.0.1 20180413 (experimental)
>>
>> Unfortunately, I don't have any reproducer for this crash yet.
>>
>> IMPORTANT: if you fix the bug, please add the following tag to the commit:
>> Reported-by: syzbot+e9f364d3b15ce41d8451@syzkaller.appspotmail.com
> 
> Looks like the problem is actually in nfc, so +nfc maintainers.

Note this issue was discussed before, maybe we should patch NFC without waiting for nfc maintainer.

----------------------------------------------------

On 06/25/2018 10:12 PM, Sergey Senozhatsky wrote:
> On (06/26/18 07:07), Dmitry Vyukov wrote:
> [..]
>>>  #include <net/nfc/nfc.h>
>>> @@ -755,7 +756,8 @@ int nfc_llcp_send_ui_frame(struct nfc_llcp_sock *sock, u8 ssap, u8 dsap,
>>>                 pdu = nfc_alloc_send_skb(sock->dev, &sock->sk, MSG_DONTWAIT,
>>>                                          frag_len + LLCP_HEADER_SIZE, &err);
>>>                 if (pdu == NULL) {
>>> -                       pr_err("Could not allocate PDU\n");
>>> +                       pr_err_ratelimited("Could not allocate PDU\n");
>>> +                       cond_resched();
>>>                         continue;
>>>                 }
>>
>>
>> But this thread is still in an infinite (unkillable?) loop? If yes, we
>> are waiting for the next syzbot report 
>
> The loop is still infinite, correct, but we have a preemption point now.
> Sure, net people can come with a much better solution, I'll be happy to
> scratch my patch.
>

This can not be the right solution, think about current thread being real time,
cond_resched() might be a nop.

We should probably not loop at all, or not use MSG_DONTWAIT.

(And remove this useless "Could not allocate PDU" message)

NFC maintainers should really take a look at this.
