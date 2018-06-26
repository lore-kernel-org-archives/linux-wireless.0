Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pf0-f194.google.com ([209.85.192.194]:43696 "EHLO
        mail-pf0-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750873AbeFZFER (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 26 Jun 2018 01:04:17 -0400
Received: by mail-pf0-f194.google.com with SMTP id y8-v6so7518453pfm.10
        for <linux-wireless@vger.kernel.org>; Mon, 25 Jun 2018 22:04:17 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20180625225937.43aee76c@vmware.local.home>
References: <000000000000720530056f7f9b63@google.com> <20180626014924.GB11229@jagdpanzerIV>
 <20180625225937.43aee76c@vmware.local.home>
From: Dmitry Vyukov <dvyukov@google.com>
Date: Tue, 26 Jun 2018 07:03:56 +0200
Message-ID: <CACT4Y+YWFhUk9cdpSR5+yR3+D6mNFUz2WwRcHULCNpj0-4qXyg@mail.gmail.com> (sfid-20180626_070431_873592_32EE007F)
Subject: Re: INFO: rcu detected stall in vprintk_emit
To: Steven Rostedt <rostedt@goodmis.org>
Cc: Sergey Senozhatsky <sergey.senozhatsky.work@gmail.com>,
        syzbot <syzbot+d29d18215e477cfbfbdd@syzkaller.appspotmail.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Petr Mladek <pmladek@suse.com>,
        Sergey Senozhatsky <sergey.senozhatsky@gmail.com>,
        syzkaller-bugs <syzkaller-bugs@googlegroups.com>,
        Samuel Ortiz <sameo@linux.intel.com>,
        "David S. Miller" <davem@davemloft.net>,
        linux-wireless@vger.kernel.org, netdev <netdev@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, Jun 26, 2018 at 4:59 AM, Steven Rostedt <rostedt@goodmis.org> wrote:
> On Tue, 26 Jun 2018 10:49:24 +0900
> Sergey Senozhatsky <sergey.senozhatsky.work@gmail.com> wrote:
>
>> So we can try switching to ratelimited error reporting
>> [that would be option A]:
>>
>> ---
>>
>> diff --git a/net/nfc/llcp_commands.c b/net/nfc/llcp_commands.c
>> index 2ceefa183cee..2f3becb709b8 100644
>> --- a/net/nfc/llcp_commands.c
>> +++ b/net/nfc/llcp_commands.c
>> @@ -755,7 +755,7 @@ int nfc_llcp_send_ui_frame(struct nfc_llcp_sock *sock, u8 ssap, u8 dsap,
>>               pdu = nfc_alloc_send_skb(sock->dev, &sock->sk, MSG_DONTWAIT,
>>                                        frag_len + LLCP_HEADER_SIZE, &err);
>>               if (pdu == NULL) {
>> -                     pr_err("Could not allocate PDU\n");
>> +                     pr_err_ratelimited("Could not allocate PDU\n");
>>                       continue;
>>               }
>>
>> ---
>>
>>
>> Or ratelimited error reporting and cond_resched()
>> [that would be option B]:
>
> I don't think this is a printk() issue per se, so I think Option B is
> the only option. You should not get stuck in an infinite loop if we run
> short on memory. Perhaps we could have an Option C which would exit
> this loop gracefully with some kind of error. But I haven't looked at
> the surrounding code to be sure if that is possible.

I suspect this is not even OOM. This is probably some persistent
logical condition that makes the allocation function fail, either we
ask for too much, or socket in some bad state. Potentially this is
even triggerable remotely because there are some remove variables
involved in size calculation.
