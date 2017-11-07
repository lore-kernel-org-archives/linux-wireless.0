Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-lf0-f53.google.com ([209.85.215.53]:56188 "EHLO
        mail-lf0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753688AbdKGLNv (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 7 Nov 2017 06:13:51 -0500
Message-ID: <1510053227.24015.3.camel@gmail.com> (sfid-20171107_121542_814615_D21C0429)
Subject: Re: Soft lockup in rt2x00usb_work_rxdone()
From: Richard Genoud <richard.genoud@gmail.com>
To: Stanislaw Gruszka <sgruszka@redhat.com>
Cc: Helmut Schaa <helmut.schaa@googlemail.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        linux-wireless@vger.kernel.org
Date: Tue, 07 Nov 2017 12:13:47 +0100
In-Reply-To: <20171107101320.GA12140@redhat.com>
References: <1509983829.10974.2.camel@gmail.com>
         <20171107085327.GA11380@redhat.com>
         <CACQ1gAi6XtjCHPji3BP71jDG7srg+BshesviasXiSqnw2zs9_Q@mail.gmail.com>
         <20171107101320.GA12140@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Le mardi 07 novembre 2017 à 11:13 +0100, Stanislaw Gruszka a écrit :
> On Tue, Nov 07, 2017 at 11:06:39AM +0100, Richard Genoud wrote:
> > > 3 short articles how to configure and use ftrace are here:
> > > https://lwn.net/Articles/365835/
> > > https://lwn.net/Articles/366796/
> > > https://lwn.net/Articles/370423/
> > > 
> > 
> > I tried with ftrace, but I don't think there's a way to dump the
> > trace
> > when there's a soft lock-up
> > (I can't do anything after the unbind, even the heartbeat led
> > stopped blinking).
> > I saw the /proc/sys/kernel/ftrace_dump_on_oops file, but there's no
> > /proc/sys/kernel/ftrace_dump_on_soft_lock-up file :)
> 
> You should configure function trace with rt2x* functions. After that
> start tracing, unbind the device, then stop tracing and provide trace
> output.
Here is another trace, with rt2* as function filter.
(sorry for the noise)

Dumping ftrace buffer:
---------------------------------
CPU:0 [LOST 3606923 EVENTS]
 0)   0.000 us    |      } /* rt2x00usb_clear_entry */
 0)   0.000 us    |    } /* rt2x00lib_rxdone */
 0)   0.000 us    |    rt2x00queue_get_entry();
 0)               |    rt2x00lib_rxdone() {
 0)   0.000 us    |      rt2x00queue_index_inc();
 0)               |      rt2x00usb_clear_entry() {
 0)               |        rt2x00usb_kick_rx_entry() {
 0)               |          rt2x00lib_dmastart() {
 0)   0.000 us    |            rt2x00queue_index_inc();
 0)   0.000 us    |          }
 0)               |          rt2x00lib_dmadone() {
 0)   0.000 us    |            rt2x00queue_index_inc();
 0)   0.000 us    |          }
 0)   0.000 us    |        }
 0)   0.000 us    |      }
 0)   0.000 us    |    }
 0)   0.000 us    |    rt2x00queue_get_entry();
 0)               |    rt2x00lib_rxdone() {
 0)   0.000 us    |      rt2x00queue_index_inc();
 0)               |      rt2x00usb_clear_entry() {
 0)               |        rt2x00usb_kick_rx_entry() {
 0)               |          rt2x00lib_dmastart() {
 0)   0.000 us    |            rt2x00queue_index_inc();
 0)   0.000 us    |          }
 0)               |          rt2x00lib_dmadone() {
 0)   0.000 us    |            rt2x00queue_index_inc();
 0)   0.000 us    |          }
 0)   0.000 us    |        }
 0)   0.000 us    |      }
 0)   0.000 us    |    }
 0)   0.000 us    |    rt2x00queue_get_entry();
 0)               |    rt2x00lib_rxdone() {
 0)   0.000 us    |      rt2x00queue_index_inc();
 0)               |      rt2x00usb_clear_entry() {
 0)               |        rt2x00usb_kick_rx_entry() {
 0)               |          rt2x00lib_dmastart() {
 0)   0.000 us    |            rt2x00queue_index_inc();
 0)   0.000 us    |          }
 0)               |          rt2x00lib_dmadone() {
 0)   0.000 us    |            rt2x00queue_index_inc();
 0)   0.000 us    |          }
 0)   0.000 us    |        }
 0)   0.000 us    |      }
 0)   0.000 us    |    }

> 
> Thanks
> Stanislaw
