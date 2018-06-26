Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:36318 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S965216AbeFZORP (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 26 Jun 2018 10:17:15 -0400
Date: Tue, 26 Jun 2018 10:17:12 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: Eric Dumazet <eric.dumazet@gmail.com>
Cc: Sergey Senozhatsky <sergey.senozhatsky.work@gmail.com>,
        Dmitry Vyukov <dvyukov@google.com>,
        Samuel Ortiz <sameo@linux.intel.com>,
        "David S. Miller" <davem@davemloft.net>,
        Petr Mladek <pmladek@suse.com>,
        syzkaller-bugs <syzkaller-bugs@googlegroups.com>,
        linux-wireless@vger.kernel.org, netdev <netdev@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        syzbot <syzbot+d29d18215e477cfbfbdd@syzkaller.appspotmail.com>,
        Sergey Senozhatsky <sergey.senozhatsky@gmail.com>
Subject: Re: [PATCH] NFC: llcp: fix nfc_llcp_send_ui_frame() lockup
Message-ID: <20180626101712.0fe57ba1@gandalf.local.home> (sfid-20180626_161731_526284_15308FE4)
In-Reply-To: <8c410102-43ab-dfdb-0d71-2ee5951e1af8@gmail.com>
References: <20180626044119.30118-1-sergey.senozhatsky@gmail.com>
        <CACT4Y+ZvLqzEwXgdB25MrmAS_j2_HsS8NFaJaMojzMV3prXypg@mail.gmail.com>
        <20180626051221.GC31439@jagdpanzerIV>
        <8c410102-43ab-dfdb-0d71-2ee5951e1af8@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, 25 Jun 2018 23:44:22 -0700
Eric Dumazet <eric.dumazet@gmail.com> wrote:

> > The loop is still infinite, correct, but we have a preemption point now.
> > Sure, net people can come with a much better solution, I'll be happy to
> > scratch my patch.
> >   
> 
> This can not be the right solution, think about current thread being real time,
> cond_resched() might be a nop.

Good point! Bah, as one of the RT maintainers, I should have noticed
that too :-p

I'm losing my touch.

-- Steve


> 
> We should probably not loop at all, or not use MSG_DONTWAIT.
> 
> (And remove this useless "Could not allocate PDU" message)
> 
> NFC maintainers should really take a look at this.
