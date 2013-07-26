Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([144.76.43.152]:58333 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753006Ab3GZJQL (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 26 Jul 2013 05:16:11 -0400
Message-ID: <1374830164.8248.40.camel@jlt4.sipsolutions.net> (sfid-20130726_111625_739565_749F0ED0)
Subject: Re: Help adding trace events to xHCI
From: Johannes Berg <johannes@sipsolutions.net>
To: Sarah Sharp <sarah.a.sharp@linux.intel.com>
Cc: Xenia Ragiadakou <burzalodowa@gmail.com>,
	OPW Kernel Interns List <opw-kernel-interns@googlegroups.com>,
	linux-usb@vger.kernel.org, linux-wireless@vger.kernel.org,
	Kalle Valo <kvalo@qca.qualcomm.com>,
	Steven Rostedt <rostedt@goodmis.org>
Date: Fri, 26 Jul 2013 11:16:04 +0200
In-Reply-To: <20130711190035.GD5240@xanatos>
References: <51DB0257.1010709@gmail.com> <20130711162002.GA5240@xanatos>
	 <1373562533.8201.33.camel@jlt4.sipsolutions.net>
	 <20130711190035.GD5240@xanatos>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

[sorry for the late response!]

> Yes, that does look inefficient.  Would it make sense to add a couple
> different trace event classes for different sized buffers, and call
> those trace classes conditionally, based on the size of the formatted
> string?  Or would that be too much of a mess.

I don't see a way you could even do that, since you'd have to print the
string to decide which event to use, but then at the time you'd have
done most of the work already, so that'd just penalise the
tracing-disabled case, I think.

> Either way, it's only inefficient when trace events are turned on.  We
> don't expect xHCI debugging to be enabled by users very often.  I do
> expect that there will be a lot of debugging when it gets turned on.
> Can userspace increase the size of the ring buffer?  How much space do
> we have by default?

I don't know, I think it's dynamic up to some maximum.

> > > int xhci_debug_address(const char *fmt, ...)
> > 
> > This confuses me somewhat -- why is it called "xhci_debug_address()"
> > when it takes arbitrary parameters? Where's the "address" part?
> 
> It's debugging the xHCI Address command output.  Depending on the status
> of the command, we print different statement in the xHCI code.  E.g. we
> print when the command times out, or finishes with an error status
> because there was a USB transfer error on the bus.
> 
> We can work on better names later. :)

I was thinking less about the names and more about the semantics of the
tracing. It might be worth, for example, to not print different
statements in the tracepoint but instead add the (partial) command and
its status, and have a tracing plugin that post-processes it into a
better string. But I'm not familiar enough with xHCI to say whether
that's possible or not.

For example, in iwlwifi, I can trace the communication with the device,
so you'd have the actual command I send over the PCIe bus to the device,
and the response I'm getting from the firmware running in the device.
Those are just binary blobs in the trace, but I can post-process to
print their contents.

> > I don't really know what xhci does, but I suppose it has register
> > read/write, maybe packet (urb?) submissions etc. so something like the
> > iwlwifi_io system in drivers/net/wireless/iwlwifi/iwl-devtrace.h might
> > (also) be (more) useful. In iwlwifi I have tracing for
> >  * IO accesses & interrupt notifications/reasons
> >  * commands and TX packets submitted to the device
> >  * notifications/RX packets received from the device
> >  * previously existing debug messages
> 
> My initial list of specific trace points was something like:
> 
> 1. xHCI host initialization and shutdown
> 
> 2. xHCI memory allocation (dynamic ring resizing, structure alloc, etc)
> 
> 3. A few individual xHCI host controller command tracepoints:
>    * status only for all completed commands
>    * Address Device command status and output
>    * Configure Endpoint and Evaluate Context output
>    * individual trace points for other xHCI commands
> 
> 4. Tracepoints for all USB transfer types:
>    * Control TX output (only for non-successful transfers)
>    * Bulk TX
>    * Interrupt TX
>    * Isoc TX
> 
> 5. URB cancellation
> 
> And probably more.  Basically, I want to be able to control what gets
> printed, based on where I think the xHCI bug might be.  Does that sound
> reasonable?

You'd have to explain xHCI to me in more detail :-)

Some of these are driver things only, right? Like memory allocation,
etc. Those would make sense as separate tracepoints I think. For the
communication with the device, I've found for our device that having
just partial information usually isn't very useful unless there's a very
specific bug like having the wrong bit set in some command, so I'm
recording all of that without much differentiation.

I think I'd not split it as detailed as you suggested, but rather have a
tracepoint for the xHCI host controller command submission and another
one for status, and similarly two (or need just one maybe?) for the
different transfer types.

Btw, a good thing for something like this is to use multiple trace
systems, like in iwlwifi or mac80211 for example, we #define
TRACE_SYSTEM multiple times so you can record sets of tracepoints more
easily and don't have to select a bunch of single ones.

> > However, tracing all the debug messages is actually fairly expensive, I
> > think in part because of the string formatting and in part because of
> > the always-max allocations in the ringbuffer.
> 
> So are there parts of the driver that don't have the debug messages go
> through the trace events code, in order to not fill up the ring buffer?

Very very few, but the debug messages have two ways of showing up:
 * tracing (all of them all the time)
 * printk (selected per debug 'level' or 'functional subsystem')

> > > I'm actually wondering if the call to ath6kl_printk is somehow necessary
> > > in order to be able to pass arguments on the stack.
> > 
> > I don't think it is, but formatting the messages *only* for tracing
> > seems a bit odd?
> 
> Why is it odd?

Well, it's just a feeling really, but if I think about where it comes
from it seems that you might be able to build more detailed tracepoints
(though you don't want to overdo it!) that get the input data, instead
of formatting it.

Let me make an example. In iwlwifi (sorry, but that's what I'm really
familiar with ...) I have device commands, and get a status response
(possibly with more data) for each of them. The status can be an empty
response (just 'ok'), or with a 32-bit status field, or with more
information.

I could now do something like this:

 if (cmd->len == 4)
     trace_msg("empty response for cmd %d", cmd->id);
 else /* must be >= 8 due to alignment etc. */
     trace_msg("response with status %d for cmd %d", cmd->status,
cmd->id);

Instead though, what I did is this:

 trace_status(cmd->len, (void *)cmd);

which will just put the binary data coming from the device there, so I
can analyse it later.

johannes

