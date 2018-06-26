Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pg0-f65.google.com ([74.125.83.65]:43126 "EHLO
        mail-pg0-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751448AbeFZGoZ (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 26 Jun 2018 02:44:25 -0400
Subject: Re: [PATCH] NFC: llcp: fix nfc_llcp_send_ui_frame() lockup
To: Sergey Senozhatsky <sergey.senozhatsky.work@gmail.com>,
        Dmitry Vyukov <dvyukov@google.com>
Cc: Samuel Ortiz <sameo@linux.intel.com>,
        "David S. Miller" <davem@davemloft.net>,
        Steven Rostedt <rostedt@goodmis.org>,
        Petr Mladek <pmladek@suse.com>,
        syzkaller-bugs <syzkaller-bugs@googlegroups.com>,
        linux-wireless@vger.kernel.org, netdev <netdev@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        syzbot <syzbot+d29d18215e477cfbfbdd@syzkaller.appspotmail.com>,
        Sergey Senozhatsky <sergey.senozhatsky@gmail.com>
References: <20180626044119.30118-1-sergey.senozhatsky@gmail.com>
 <CACT4Y+ZvLqzEwXgdB25MrmAS_j2_HsS8NFaJaMojzMV3prXypg@mail.gmail.com>
 <20180626051221.GC31439@jagdpanzerIV>
From: Eric Dumazet <eric.dumazet@gmail.com>
Message-ID: <8c410102-43ab-dfdb-0d71-2ee5951e1af8@gmail.com> (sfid-20180626_084445_698478_0413C805)
Date: Mon, 25 Jun 2018 23:44:22 -0700
MIME-Version: 1.0
In-Reply-To: <20180626051221.GC31439@jagdpanzerIV>
Content-Type: text/plain; charset=utf-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>



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
>> are waiting for the next syzbot report ;)
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
