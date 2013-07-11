Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:9257 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750734Ab3GKT3R (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 11 Jul 2013 15:29:17 -0400
Message-ID: <1373570955.17876.58.camel@gandalf.local.home> (sfid-20130711_212921_903049_8D56EC4C)
Subject: Re: Help adding trace events to xHCI
From: Steven Rostedt <rostedt@goodmis.org>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: Sarah Sharp <sarah.a.sharp@linux.intel.com>,
	Xenia Ragiadakou <burzalodowa@gmail.com>,
	OPW Kernel Interns List <opw-kernel-interns@googlegroups.com>,
	linux-usb@vger.kernel.org, linux-wireless@vger.kernel.org,
	Kalle Valo <kvalo@qca.qualcomm.com>
Date: Thu, 11 Jul 2013 15:29:15 -0400
In-Reply-To: <1373562533.8201.33.camel@jlt4.sipsolutions.net>
References: <51DB0257.1010709@gmail.com> <20130711162002.GA5240@xanatos>
	 (sfid-20130711_182013_255578_2722BE3F) <1373562533.8201.33.camel@jlt4.sipsolutions.net>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, 2013-07-11 at 19:08 +0200, Johannes Berg wrote:

> > > lets say that we want the tracepoint function to have the prototype:
> > > 
> > > void trace_cmd_address_device(const char *fmt, ...).
> 
> I'm not sure this is possible. I think we (wireless) do this with
> 
> void trace_cmd_address_device(struct va_format *vaf)
> 
> instead only.
> 
> Note that there's no easy way to dynamically allocate the right amount
> of space in the ringbuffer, or at least I haven't found one. We
> therefore have a static size, which is somewhat inefficient.

Can you add a helper function? If these trace events can't nest (one in
interrupt context and another in normal context with interrupts
enabled), then you can just allocate a per-cpu buffer and store the
string in that, and then move the string into the buffer.

	vsnprintf(this_cpu_ptr(trace_buf), MAX_BUF_LEN, fmt, va);
	__assign_str(str, trace_buf);

You could even use the reg, unreg, methods for TRACE_EVENT_FN() that
will allocate the buffers when the tracepoint is created. This will mean
that you don't waste memory when not tracing.

-- Steve


