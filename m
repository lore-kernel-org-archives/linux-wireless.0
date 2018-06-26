Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pg0-f67.google.com ([74.125.83.67]:44354 "EHLO
        mail-pg0-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750907AbeFZFM0 (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 26 Jun 2018 01:12:26 -0400
Date: Tue, 26 Jun 2018 14:12:21 +0900
From: Sergey Senozhatsky <sergey.senozhatsky.work@gmail.com>
To: Dmitry Vyukov <dvyukov@google.com>
Cc: Sergey Senozhatsky <sergey.senozhatsky.work@gmail.com>,
        Samuel Ortiz <sameo@linux.intel.com>,
        "David S. Miller" <davem@davemloft.net>,
        Steven Rostedt <rostedt@goodmis.org>,
        Petr Mladek <pmladek@suse.com>,
        syzkaller-bugs <syzkaller-bugs@googlegroups.com>,
        linux-wireless@vger.kernel.org, netdev <netdev@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        syzbot <syzbot+d29d18215e477cfbfbdd@syzkaller.appspotmail.com>,
        Sergey Senozhatsky <sergey.senozhatsky@gmail.com>
Subject: Re: [PATCH] NFC: llcp: fix nfc_llcp_send_ui_frame() lockup
Message-ID: <20180626051221.GC31439@jagdpanzerIV> (sfid-20180626_071245_533817_41E2A7D4)
References: <20180626044119.30118-1-sergey.senozhatsky@gmail.com>
 <CACT4Y+ZvLqzEwXgdB25MrmAS_j2_HsS8NFaJaMojzMV3prXypg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <CACT4Y+ZvLqzEwXgdB25MrmAS_j2_HsS8NFaJaMojzMV3prXypg@mail.gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On (06/26/18 07:07), Dmitry Vyukov wrote:
[..]
> >  #include <net/nfc/nfc.h>
> > @@ -755,7 +756,8 @@ int nfc_llcp_send_ui_frame(struct nfc_llcp_sock *sock, u8 ssap, u8 dsap,
> >                 pdu = nfc_alloc_send_skb(sock->dev, &sock->sk, MSG_DONTWAIT,
> >                                          frag_len + LLCP_HEADER_SIZE, &err);
> >                 if (pdu == NULL) {
> > -                       pr_err("Could not allocate PDU\n");
> > +                       pr_err_ratelimited("Could not allocate PDU\n");
> > +                       cond_resched();
> >                         continue;
> >                 }
> 
> 
> But this thread is still in an infinite (unkillable?) loop? If yes, we
> are waiting for the next syzbot report ;)

The loop is still infinite, correct, but we have a preemption point now.
Sure, net people can come with a much better solution, I'll be happy to
scratch my patch.

	-ss
