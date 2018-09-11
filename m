Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-io0-f195.google.com ([209.85.223.195]:46047 "EHLO
        mail-io0-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726816AbeIKK0W (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 11 Sep 2018 06:26:22 -0400
Received: by mail-io0-f195.google.com with SMTP id e12-v6so2562252iok.12
        for <linux-wireless@vger.kernel.org>; Mon, 10 Sep 2018 22:28:49 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20180402020413.GD3795@jagdpanzerIV>
References: <001a113fe6c0a6ec650568c7384f@google.com> <CACT4Y+YxuvQLZjWau99-7i8dmtxtjnpX6uteabF5rorYMj5v1w@mail.gmail.com>
 <20180402015422.GA3795@jagdpanzerIV> <20180402020413.GD3795@jagdpanzerIV>
From: Dmitry Vyukov <dvyukov@google.com>
Date: Tue, 11 Sep 2018 07:28:27 +0200
Message-ID: <CACT4Y+ZJJG7hPjkV+gcsvisBk=-9-8JjX4D51AFRcWZkce9KsQ@mail.gmail.com> (sfid-20180911_072902_458862_6301A222)
Subject: Re: INFO: rcu detected stall in vprintk_func
To: Sergey Senozhatsky <sergey.senozhatsky.work@gmail.com>
Cc: syzbot <syzbot+3f28bd18291266ec826b@syzkaller.appspotmail.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Petr Mladek <pmladek@suse.com>,
        Steven Rostedt <rostedt@goodmis.org>,
        Sergey Senozhatsky <sergey.senozhatsky@gmail.com>,
        syzkaller-bugs <syzkaller-bugs@googlegroups.com>,
        Samuel Ortiz <sameo@linux.intel.com>,
        David Miller <davem@davemloft.net>,
        linux-wireless@vger.kernel.org, netdev <netdev@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, Apr 2, 2018 at 4:04 AM, Sergey Senozhatsky
<sergey.senozhatsky.work@gmail.com> wrote:
> On (04/02/18 10:54), Sergey Senozhatsky wrote:
>> > > If you forward the report, please keep this part and the footer.
>> > >
>> > > llcp: nfc_llcp_send_ui_frame: Could not allocate PDU
>> > > llcp: nfc_llcp_send_ui_frame: Could not allocate PDU
>> > > llcp: nfc_llcp_send_ui_frame: Could not allocate PDU
>> > > llcp: nfc_llcp_send_ui_frame: Could not allocate PDU
>
> [..]
>
>> diff --git a/net/nfc/llcp_core.c b/net/nfc/llcp_core.c
>> index ef4026a23e80..a309a27581da 100644
>> --- a/net/nfc/llcp_core.c
>> +++ b/net/nfc/llcp_core.c
>> @@ -1386,7 +1386,7 @@ static void nfc_llcp_recv_agf(struct nfc_llcp_local *local, struct sk_buff *skb)
>>
>>               new_skb = nfc_alloc_recv_skb(pdu_len, GFP_KERNEL);
>>               if (new_skb == NULL) {
>> -                     pr_err("Could not allocate PDU\n");
>> +                     pr_err_ratelimited("Could not allocate PDU\n");
>>                       return;
>>               }
>
> And of course I ended up patching the wrong function...
> What I actually meant was:
>
> ---
>
> diff --git a/net/nfc/llcp_commands.c b/net/nfc/llcp_commands.c
> index 2ceefa183cee..2f3becb709b8 100644
> --- a/net/nfc/llcp_commands.c
> +++ b/net/nfc/llcp_commands.c
> @@ -755,7 +755,7 @@ int nfc_llcp_send_ui_frame(struct nfc_llcp_sock *sock, u8 ssap, u8 dsap,
>                 pdu = nfc_alloc_send_skb(sock->dev, &sock->sk, MSG_DONTWAIT,
>                                          frag_len + LLCP_HEADER_SIZE, &err);
>                 if (pdu == NULL) {
> -                       pr_err("Could not allocate PDU\n");
> +                       pr_err_ratelimited("Could not allocate PDU\n");
>                         continue;
>                 }
>


This is a duplicate of:

https://syzkaller.appspot.com/bug?id=ff33bd26f9147a02c60039098b063219df1ac131

#syz dup: INFO: rcu detected stall in llcp_sock_sendmsg
