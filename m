Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-lf0-f54.google.com ([209.85.215.54]:51888 "EHLO
        mail-lf0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752233AbdKHLHT (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 8 Nov 2017 06:07:19 -0500
Message-ID: <1510139235.10467.1.camel@gmail.com> (sfid-20171108_120736_029706_45BF1342)
Subject: Re: Soft lockup in rt2x00usb_work_rxdone()
From: Richard Genoud <richard.genoud@gmail.com>
To: Stanislaw Gruszka <sgruszka@redhat.com>
Cc: Helmut Schaa <helmut.schaa@googlemail.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        linux-wireless@vger.kernel.org
Date: Wed, 08 Nov 2017 12:07:15 +0100
In-Reply-To: <20171108103729.GA2641@redhat.com>
References: <1509983829.10974.2.camel@gmail.com>
         <20171107085327.GA11380@redhat.com>
         <CACQ1gAi6XtjCHPji3BP71jDG7srg+BshesviasXiSqnw2zs9_Q@mail.gmail.com>
         <20171107101320.GA12140@redhat.com> <1510052483.24015.1.camel@gmail.com>
         <20171108103729.GA2641@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Le mercredi 08 novembre 2017 à 11:37 +0100, Stanislaw Gruszka a écrit :
> On Tue, Nov 07, 2017 at 12:01:23PM +0100, Richard Genoud wrote:
> > Le mardi 07 novembre 2017 à 11:13 +0100, Stanislaw Gruszka a
> > écrit :
> > > On Tue, Nov 07, 2017 at 11:06:39AM +0100, Richard Genoud wrote:
> > > > > 3 short articles how to configure and use ftrace are here:
> > > > > https://lwn.net/Articles/365835/
> > > > > https://lwn.net/Articles/366796/
> > > > > https://lwn.net/Articles/370423/
> > > > > 
> > > > 
> > > > I tried with ftrace, but I don't think there's a way to dump
> > > > the
> > > > trace
> > > > when there's a soft lock-up
> > > > (I can't do anything after the unbind, even the heartbeat led
> > > > stopped blinking).
> > > > I saw the /proc/sys/kernel/ftrace_dump_on_oops file, but
> > > > there's no
> > > > /proc/sys/kernel/ftrace_dump_on_soft_lock-up file :)
> > > 
> > > You should configure function trace with rt2x* functions. After
> > > that
> > > start tracing, unbind the device, then stop tracing and provide
> > > trace
> > > output.
> > 
> > Ok, I found a way to display the trace (after the unbind, the board
> > is
> > frozen and I can't type anything).
> > Adding
> > CONFIG_SOFTLOCKUP_DETECTOR=y
> > CONFIG_BOOTPARAM_SOFTLOCKUP_PANIC=y
> > along with echo 1 > /proc/sys/kernel/ftrace_dump_on_oops does the
> > trick
> 
> No, that not I wanted you to do. Please remove those options and just
> do
> below on tracing directory.
> 
> echo 0 > tracing_on 
> cat trace >  /dev/null
> echo "function_graph" > current_tracer 
> echo "rt2*" > set_ftrace_filter 
> echo 1 > tracing_on
> echo 1-2.2 > /sys/bus/usb/drivers/usb/unbind
> echo 0 > tracing_on
> cat trace > ~/trace.txt

Well, there's clearly a misunderstanding here :
After the command "echo 1-2.2 > /sys/bus/usb/drivers/usb/unbind"
I can't type *anything*
The only thing I can do is plug off the board.
This command never returns, so I can't stop the tracing...

Or I missed something ?

(maybe if there was more than one CPU on the board, I could do
something, but that's not the case)

> 
> and provide trace.txt to me (can be in private email if big).
> 
> Thanks
> Stanislaw

Thanks,
Richard.
