Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pl0-f67.google.com ([209.85.160.67]:41369 "EHLO
        mail-pl0-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751025AbeFZHAi (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 26 Jun 2018 03:00:38 -0400
Date: Tue, 26 Jun 2018 16:00:33 +0900
From: Sergey Senozhatsky <sergey.senozhatsky.work@gmail.com>
To: Eric Dumazet <eric.dumazet@gmail.com>
Cc: Sergey Senozhatsky <sergey.senozhatsky.work@gmail.com>,
        Dmitry Vyukov <dvyukov@google.com>,
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
Message-ID: <20180626070033.GA25715@jagdpanzerIV> (sfid-20180626_090107_411164_0497F065)
References: <20180626044119.30118-1-sergey.senozhatsky@gmail.com>
 <CACT4Y+ZvLqzEwXgdB25MrmAS_j2_HsS8NFaJaMojzMV3prXypg@mail.gmail.com>
 <20180626051221.GC31439@jagdpanzerIV>
 <8c410102-43ab-dfdb-0d71-2ee5951e1af8@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <8c410102-43ab-dfdb-0d71-2ee5951e1af8@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On (06/25/18 23:44), Eric Dumazet wrote:
> > The loop is still infinite, correct, but we have a preemption point now.
> > Sure, net people can come with a much better solution, I'll be happy to
> > scratch my patch.
> > 
> 
> This can not be the right solution, think about current thread being real time,
> cond_resched() might be a nop.
> NFC maintainers should really take a look at this.

I'm all for it.

	-ss
