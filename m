Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:42746 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S964791AbdKGKNY (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 7 Nov 2017 05:13:24 -0500
Date: Tue, 7 Nov 2017 11:13:22 +0100
From: Stanislaw Gruszka <sgruszka@redhat.com>
To: Richard Genoud <richard.genoud@gmail.com>
Cc: Helmut Schaa <helmut.schaa@googlemail.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        linux-wireless@vger.kernel.org
Subject: Re: Soft lockup in rt2x00usb_work_rxdone()
Message-ID: <20171107101320.GA12140@redhat.com> (sfid-20171107_111602_667784_D3027694)
References: <1509983829.10974.2.camel@gmail.com>
 <20171107085327.GA11380@redhat.com>
 <CACQ1gAi6XtjCHPji3BP71jDG7srg+BshesviasXiSqnw2zs9_Q@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <CACQ1gAi6XtjCHPji3BP71jDG7srg+BshesviasXiSqnw2zs9_Q@mail.gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


On Tue, Nov 07, 2017 at 11:06:39AM +0100, Richard Genoud wrote:
> > 3 short articles how to configure and use ftrace are here:
> > https://lwn.net/Articles/365835/
> > https://lwn.net/Articles/366796/
> > https://lwn.net/Articles/370423/
> >
> I tried with ftrace, but I don't think there's a way to dump the trace
> when there's a soft lock-up
> (I can't do anything after the unbind, even the heartbeat led stopped blinking).
> I saw the /proc/sys/kernel/ftrace_dump_on_oops file, but there's no
> /proc/sys/kernel/ftrace_dump_on_soft_lock-up file :)

You should configure function trace with rt2x* functions. After that
start tracing, unbind the device, then stop tracing and provide trace
output.

Thanks
Stanislaw
