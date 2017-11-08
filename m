Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:50626 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751352AbdKHKlj (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 8 Nov 2017 05:41:39 -0500
Date: Wed, 8 Nov 2017 11:41:36 +0100
From: Stanislaw Gruszka <sgruszka@redhat.com>
To: Richard Genoud <richard.genoud@gmail.com>
Cc: Helmut Schaa <helmut.schaa@googlemail.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        linux-wireless@vger.kernel.org
Subject: Re: Soft lockup in rt2x00usb_work_rxdone()
Message-ID: <20171108104136.GB2641@redhat.com> (sfid-20171108_114206_451956_03DC97A3)
References: <1509983829.10974.2.camel@gmail.com>
 <20171107085327.GA11380@redhat.com>
 <CACQ1gAi6XtjCHPji3BP71jDG7srg+BshesviasXiSqnw2zs9_Q@mail.gmail.com>
 <20171107101320.GA12140@redhat.com>
 <1510053227.24015.3.camel@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
In-Reply-To: <1510053227.24015.3.camel@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, Nov 07, 2017 at 12:13:47PM +0100, Richard Genoud wrote:
> Le mardi 07 novembre 2017 à 11:13 +0100, Stanislaw Gruszka a écrit :
> > On Tue, Nov 07, 2017 at 11:06:39AM +0100, Richard Genoud wrote:
> > > > 3 short articles how to configure and use ftrace are here:
> > > > https://lwn.net/Articles/365835/
> > > > https://lwn.net/Articles/366796/
> > > > https://lwn.net/Articles/370423/
> > > > 
> > > 
> > > I tried with ftrace, but I don't think there's a way to dump the
> > > trace
> > > when there's a soft lock-up
> > > (I can't do anything after the unbind, even the heartbeat led
> > > stopped blinking).
> > > I saw the /proc/sys/kernel/ftrace_dump_on_oops file, but there's no
> > > /proc/sys/kernel/ftrace_dump_on_soft_lock-up file :)
> > 
> > You should configure function trace with rt2x* functions. After that
> > start tracing, unbind the device, then stop tracing and provide trace
> > output.
> Here is another trace, with rt2* as function filter.
> (sorry for the noise)
> 
> Dumping ftrace buffer:
> ---------------------------------
> CPU:0 [LOST 3606923 EVENTS]
>  0)   0.000 us    |      } /* rt2x00usb_clear_entry */
>  0)   0.000 us    |    } /* rt2x00lib_rxdone */
>  0)   0.000 us    |    rt2x00queue_get_entry();
>  0)               |    rt2x00lib_rxdone() {
>  0)   0.000 us    |      rt2x00queue_index_inc();
>  0)               |      rt2x00usb_clear_entry() {
>  0)               |        rt2x00usb_kick_rx_entry() {

We do that only if: 

        if (test_bit(DEVICE_STATE_PRESENT, &rt2x00dev->flags) &&
            test_bit(DEVICE_STATE_ENABLED_RADIO, &rt2x00dev->flags))
                rt2x00dev->ops->lib->clear_entry(entry);

so looks like DEVICE_STATE_PRESENT is not cleared. That mean
usb driver do not call disconnect callback on unbind. That seems
to be usb driver bug. Anyway please provide requested traces,
so I will see what happen.

Stanislaw
