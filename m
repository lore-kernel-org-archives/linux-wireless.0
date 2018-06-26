Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pg0-f66.google.com ([74.125.83.66]:35881 "EHLO
        mail-pg0-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750923AbeFZEWN (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 26 Jun 2018 00:22:13 -0400
Date: Tue, 26 Jun 2018 13:22:08 +0900
From: Sergey Senozhatsky <sergey.senozhatsky.work@gmail.com>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: Sergey Senozhatsky <sergey.senozhatsky.work@gmail.com>,
        syzbot <syzbot+d29d18215e477cfbfbdd@syzkaller.appspotmail.com>,
        linux-kernel@vger.kernel.org, pmladek@suse.com,
        sergey.senozhatsky@gmail.com, syzkaller-bugs@googlegroups.com,
        Samuel Ortiz <sameo@linux.intel.com>,
        "David S. Miller" <davem@davemloft.net>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org
Subject: Re: INFO: rcu detected stall in vprintk_emit
Message-ID: <20180626042208.GA31439@jagdpanzerIV> (sfid-20180626_062257_730863_1A0D7454)
References: <000000000000720530056f7f9b63@google.com>
 <20180626014924.GB11229@jagdpanzerIV>
 <20180625225937.43aee76c@vmware.local.home>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20180625225937.43aee76c@vmware.local.home>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On (06/25/18 22:59), Steven Rostedt wrote:
> > Or ratelimited error reporting and cond_resched()
> > [that would be option B]:
> 
> I don't think this is a printk() issue per se, so I think Option B is
> the only option. You should not get stuck in an infinite loop if we run
> short on memory. Perhaps we could have an Option C which would exit
> this loop gracefully with some kind of error. But I haven't looked at
> the surrounding code to be sure if that is possible.

Agree. I like Option B - an endless loop is the root cause, at the same
time filling up logbuf with useless data is useless. Can't tell if Option C
is feasible, up to networking people.

	-ss
