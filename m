Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([144.76.43.152]:51746 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753100Ab3GKRJH (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 11 Jul 2013 13:09:07 -0400
Message-ID: <1373562533.8201.33.camel@jlt4.sipsolutions.net> (sfid-20130711_190912_645256_788C2D87)
Subject: Re: Help adding trace events to xHCI
From: Johannes Berg <johannes@sipsolutions.net>
To: Sarah Sharp <sarah.a.sharp@linux.intel.com>
Cc: Xenia Ragiadakou <burzalodowa@gmail.com>,
	OPW Kernel Interns List <opw-kernel-interns@googlegroups.com>,
	linux-usb@vger.kernel.org, linux-wireless@vger.kernel.org,
	Kalle Valo <kvalo@qca.qualcomm.com>,
	Steven Rostedt <rostedt@goodmis.org>
Date: Thu, 11 Jul 2013 19:08:53 +0200
In-Reply-To: <20130711162002.GA5240@xanatos> (sfid-20130711_182013_255578_2722BE3F)
References: <51DB0257.1010709@gmail.com> <20130711162002.GA5240@xanatos>
	 (sfid-20130711_182013_255578_2722BE3F)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

[also adding Steven, he's the tracing expert after all :-)]

Hi Xenia, Sarah, all,

> (Mentors and wireless folks, we're struggling a bit with adding trace
> events to the xHCI USB host controller driver.  I'm trying to look at
> the ath6kl driver trace events as an example.  We could use some help
> and/or advice.)

Those were in turn modelled on mac80211, cfg80211 and/or iwlwifi, I
think; might be worth also looking there. In general though, it's all
pretty similar.

> > lets say that we want the tracepoint function to have the prototype:
> > 
> > void trace_cmd_address_device(const char *fmt, ...).

I'm not sure this is possible. I think we (wireless) do this with

void trace_cmd_address_device(struct va_format *vaf)

instead only.

Note that there's no easy way to dynamically allocate the right amount
of space in the ringbuffer, or at least I haven't found one. We
therefore have a static size, which is somewhat inefficient.


> The ath driver defines a new trace event class, ath6kl_log_event.
> Various types of tracepoints, like trace_ath6kl_log_warn, use that event
> class.  Wrappers like ath6kl_warn() call those trace points, passing it
> a struct va_format on the stack:
> 
> int ath6kl_warn(const char *fmt, ...)
> {
>         struct va_format vaf = {
>                 .fmt = fmt,
>         };
>         va_list args;
>         int ret;
> 
>         va_start(args, fmt);
>         vaf.va = &args;
>         ret = ath6kl_printk(KERN_WARNING, "%pV", &vaf);

Note also on older kernels you used to have to do va_copy() here because
"%pV" didn't do it by itself. Guess you don't care though, but I
sometimes have to worry about backporting :-)

> int xhci_debug_address(const char *fmt, ...)

This confuses me somewhat -- why is it called "xhci_debug_address()"
when it takes arbitrary parameters? Where's the "address" part?

> DEFINE_EVENT(xhci_log_event, xhci_dbg_address,
>              TP_PROTO(struct va_format *vaf),
>              TP_ARGS(vaf)
> );
> 
> DECLARE_EVENT_CLASS(xhci_log_event,
>         TP_PROTO(struct va_format *vaf),
>         TP_ARGS(vaf),
>         TP_STRUCT__entry(
>                 __dynamic_array(char, msg, ATH6KL_MSG_MAX)

Should probably not be ATH6KL_MSG_MAX :-)

And this is what I talked about before -- it always allocates the max in
the ringbuffer even for really short messages.


> And then code in xhci_address_device() in drivers/usb/host/xhci.c can do
> things like:
> 
> xhci_debug_address(xhci, "Bad Slot ID %d\n", udev->slot_id);

Otherwise this looks about right (you have an xhci argument you didn't
declare above, but this is obviously pseudo-code only)

> And we can define similar trace event classes for the various xHCI
> commands or ring debugging, so that we can enable or disable trace
> points individually for different parts of the xHCI driver.

I think it'd be worth (also) doing more specific tracepoints instead
though.

I don't really know what xhci does, but I suppose it has register
read/write, maybe packet (urb?) submissions etc. so something like the
iwlwifi_io system in drivers/net/wireless/iwlwifi/iwl-devtrace.h might
(also) be (more) useful. In iwlwifi I have tracing for
 * IO accesses & interrupt notifications/reasons
 * commands and TX packets submitted to the device
 * notifications/RX packets received from the device
 * previously existing debug messages

The message tracing was really more of an after-thought in iwlwifi (and
ath6kl as well I guess) because we already had a lot of debug messages
and capturing it all together can be useful.

However, tracing all the debug messages is actually fairly expensive, I
think in part because of the string formatting and in part because of
the always-max allocations in the ringbuffer.


> > That would have worked if the tracepoint was just :
> > 
> > void trace_cmd_address_device(const char *fmt, ...)
> > {
> >           if (trace event cmd_address_device is enabled) do {
> >                     (void(*)(const char *fmt, ...)) callback ((const
> > char *)&fmt);
> >           }
> > }

I'm not really sure what the whole "callback()" part is about?

Are you trying to use the "tracepoint is enabled" to do something
unrelated to the tracing? I'm guessing that's _possible_, but I wouldn't
recommend it.


> I'm actually wondering if the call to ath6kl_printk is somehow necessary
> in order to be able to pass arguments on the stack.

I don't think it is, but formatting the messages *only* for tracing
seems a bit odd?

Hth,
johannes

