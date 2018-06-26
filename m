Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pl0-f67.google.com ([209.85.160.67]:39534 "EHLO
        mail-pl0-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750960AbeFZFHf (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 26 Jun 2018 01:07:35 -0400
Date: Tue, 26 Jun 2018 14:07:31 +0900
From: Sergey Senozhatsky <sergey.senozhatsky.work@gmail.com>
To: Dmitry Vyukov <dvyukov@google.com>
Cc: Steven Rostedt <rostedt@goodmis.org>,
        Sergey Senozhatsky <sergey.senozhatsky.work@gmail.com>,
        syzbot <syzbot+d29d18215e477cfbfbdd@syzkaller.appspotmail.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Petr Mladek <pmladek@suse.com>,
        Sergey Senozhatsky <sergey.senozhatsky@gmail.com>,
        syzkaller-bugs <syzkaller-bugs@googlegroups.com>,
        Samuel Ortiz <sameo@linux.intel.com>,
        "David S. Miller" <davem@davemloft.net>,
        linux-wireless@vger.kernel.org, netdev <netdev@vger.kernel.org>
Subject: Re: INFO: rcu detected stall in vprintk_emit
Message-ID: <20180626050731.GB31439@jagdpanzerIV> (sfid-20180626_070749_786590_20C19F57)
References: <000000000000720530056f7f9b63@google.com>
 <20180626014924.GB11229@jagdpanzerIV>
 <20180625225937.43aee76c@vmware.local.home>
 <CACT4Y+YWFhUk9cdpSR5+yR3+D6mNFUz2WwRcHULCNpj0-4qXyg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <CACT4Y+YWFhUk9cdpSR5+yR3+D6mNFUz2WwRcHULCNpj0-4qXyg@mail.gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On (06/26/18 07:03), Dmitry Vyukov wrote:
> > I don't think this is a printk() issue per se, so I think Option B is
> > the only option. You should not get stuck in an infinite loop if we run
> > short on memory. Perhaps we could have an Option C which would exit
> > this loop gracefully with some kind of error. But I haven't looked at
> > the surrounding code to be sure if that is possible.
> 
> I suspect this is not even OOM.

Could be. But at the same time it stalls RCU, so OOM at some point
becomes realistic.

	-ss
