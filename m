Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga02.intel.com ([134.134.136.20]:17495 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755735Ab3GKQUF (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 11 Jul 2013 12:20:05 -0400
Date: Thu, 11 Jul 2013 09:20:02 -0700
From: Sarah Sharp <sarah.a.sharp@linux.intel.com>
To: Xenia Ragiadakou <burzalodowa@gmail.com>
Cc: OPW Kernel Interns List <opw-kernel-interns@googlegroups.com>,
	linux-usb@vger.kernel.org, linux-wireless@vger.kernel.org,
	Kalle Valo <kvalo@qca.qualcomm.com>
Subject: Help adding trace events to xHCI
Message-ID: <20130711162002.GA5240@xanatos> (sfid-20130711_182013_255578_2722BE3F)
References: <51DB0257.1010709@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <51DB0257.1010709@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, Jul 08, 2013 at 09:17:59PM +0300, Xenia Ragiadakou wrote:
> Hi Sarah,

Hi Xenia,

Comments below.

(Mentors and wireless folks, we're struggling a bit with adding trace
events to the xHCI USB host controller driver.  I'm trying to look at
the ath6kl driver trace events as an example.  We could use some help
and/or advice.)

> lets say that we want the tracepoint function to have the prototype:
> 
> void trace_cmd_address_device(const char *fmt, ...).
> 
> That internally will be implemented as:
> 
> void trace_cmd_address_device(const char *fmt, ...)
> {
>           if (trace event cmd_address_device is enabled) do {
>                     [...some other code will run here]
>                     (void(*)(const char *fmt, ...)) callback (fmt, '
> ' <-- we need to pass args here);
>           }
> }
> 
> callback will be the function that we actually intend to run and
> which we define when we define the trace_event. This function
> we want to create a string from fmt and the args and copy it
> into the ring buffer.
> 
> The only way to pass the args into this function is by doing
> the following:
> 
> Note: remember that the callback and tracepoint functions must
> have the same prototype.
> 
> void trace_cmd_address_device(void *ptr, const char *fmt, ...)
> {
>           if (trace event cmd_address_device is enabled) do {
>                     [...some other code will run here]
>                     va_list args;
>                     va_start(args, fmt);
>                     (void(*)(void *ptr, const char *fmt, ...))
> callback (args, fmt);
>                     va_end(args);
>           }
> }

Right, that looks pretty similar to what's defined in
drivers/net/wireless/ath/ath6kl/trace.h.  (Note that I'm working on the
very latest Linux kernel, so you may need to `git fetch` Greg KH's USB
tree, and rebase against the usb-next branch.)

> But, that cannot be done because the current tracing framework does not
> give a means to add code outside the callback.

I'm confused about why you need to add more code.  Here's how I
understand the code works, so please correct me if I misinterpreted the
code.

The ath driver defines a new trace event class, ath6kl_log_event.
Various types of tracepoints, like trace_ath6kl_log_warn, use that event
class.  Wrappers like ath6kl_warn() call those trace points, passing it
a struct va_format on the stack:

int ath6kl_warn(const char *fmt, ...)
{
        struct va_format vaf = {
                .fmt = fmt,
        };
        va_list args;
        int ret;

        va_start(args, fmt);
        vaf.va = &args;
        ret = ath6kl_printk(KERN_WARNING, "%pV", &vaf);
        trace_ath6kl_log_warn(&vaf);
        va_end(args);

        return ret;
}       
EXPORT_SYMBOL(ath6kl_warn);

trace_ath6kl_log_warn() uses the log event class:

DEFINE_EVENT(ath6kl_log_event, ath6kl_log_warn,
             TP_PROTO(struct va_format *vaf),
             TP_ARGS(vaf)
);

DECLARE_EVENT_CLASS(ath6kl_log_event,
        TP_PROTO(struct va_format *vaf),
        TP_ARGS(vaf),
        TP_STRUCT__entry(
                __dynamic_array(char, msg, ATH6KL_MSG_MAX)
        ),
        TP_fast_assign(
                WARN_ON_ONCE(vsnprintf(__get_dynamic_array(msg),
                                       ATH6KL_MSG_MAX,
                                       vaf->fmt,
                                       *vaf->va) >= ATH6KL_MSG_MAX);
        ),
        TP_printk("%s", __get_str(msg))
);

And then the code in files like drivers/net/wireless/ath6kl/cfg80211.c
can simply make what look like printk calls to ath6kl_warn:

ath6kl_warn("clear wmi ctrl data failed: %d\n", left);

I think that we can apply a similar technique to define trace events for
the xhci debugging that's printed when we're issuing a Set Address
command.  Something like:

int xhci_debug_address(const char *fmt, ...)
{
        struct va_format vaf = {
                .fmt = fmt,
        };
        va_list args;
        int ret;

        va_start(args, fmt);
        vaf.va = &args;
        ret = xhci_printk(KERN_WARNING, "%pV", &vaf);
        trace_xhci_dbg_address(&vaf);
        va_end(args);

        return ret;
}       
EXPORT_SYMBOL(xhci_debug_address);

DEFINE_EVENT(xhci_log_event, xhci_dbg_address,
             TP_PROTO(struct va_format *vaf),
             TP_ARGS(vaf)
);

DECLARE_EVENT_CLASS(xhci_log_event,
        TP_PROTO(struct va_format *vaf),
        TP_ARGS(vaf),
        TP_STRUCT__entry(
                __dynamic_array(char, msg, ATH6KL_MSG_MAX)
        ),
        TP_fast_assign(
                WARN_ON_ONCE(vsnprintf(__get_dynamic_array(msg),
                                       ATH6KL_MSG_MAX,
                                       vaf->fmt,
                                       *vaf->va) >= ATH6KL_MSG_MAX);
        ),
        TP_printk("%s", __get_str(msg))
);

And then code in xhci_address_device() in drivers/usb/host/xhci.c can do
things like:

xhci_debug_address(xhci, "Bad Slot ID %d\n", udev->slot_id);

And we can define similar trace event classes for the various xHCI
commands or ring debugging, so that we can enable or disable trace
points individually for different parts of the xHCI driver.

Xenia, if this all something you've tried already, I apologize. :)  I'm
just trying to understand how the trace event system works, and figure
out what the code should look like for the xHCI driver.

> The thing that i was trying to do, was to pass the pointer to the
> fmt on the stack.
> Something, like:
> 
> void trace_cmd_address_device(const char *fmt, ...)
> {
>           if (trace event cmd_address_device is enabled) do {
>                     [...some other code will run here]
>                     (void(*)(const char *fmt, ...)) callback ((const
> char *)&fmt);
>           }
> }
> 
> and then inside the callback to do:
> 
>                 va_list args;
>                 va_start(args, *(char **)fmt);
>                 vsnprintf(msg_string, mesg_max_len, *(char **)fmt, args);
>                 va_end(args);
> 
> That would have worked if the tracepoint was just :
> 
> void trace_cmd_address_device(const char *fmt, ...)
> {
>           if (trace event cmd_address_device is enabled) do {
>                     (void(*)(const char *fmt, ...)) callback ((const
> char *)&fmt);
>           }
> }
> 
> But when there are other function calls before the callback call, I don't
> no why but i cannot track anymore the position of the args following the
> fmt argumenent in the stack with the pointer to fmt.

I'm actually wondering if the call to ath6kl_printk is somehow necessary
in order to be able to pass arguments on the stack.  Perhaps you should
try defining a similar function for xHCI and see if that helps?

int ath6kl_printk(const char *level, const char *fmt, ...)
{
	struct va_format vaf;
	va_list args;
	int rtn;

	va_start(args, fmt);

	vaf.fmt = fmt;
	vaf.va = &args;

	rtn = printk("%sath6kl: %pV", level, &vaf);

	va_end(args);

	return rtn;
}
EXPORT_SYMBOL(ath6kl_printk);

> Anyway, something dirty like that will not enter the kernel but i will try
> to do stack debugging on an example program to see why that happens.

I would suggest just copy-pasting parts of the ath6kl trace code into
the xHCI driver, and changing one of the xhci_dbg() calls to use that
code, and see if it works.  If it doesn't work, send out an RFC patch
(using the Cc list I've used), and we'll try to figure out what's going
wrong.

Sarah Sharp
