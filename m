Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:17283 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758825Ab3GZNRb (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 26 Jul 2013 09:17:31 -0400
Message-ID: <1374844649.6580.24.camel@gandalf.local.home> (sfid-20130726_151743_769785_899D1C94)
Subject: Re: Help adding trace events to xHCI
From: Steven Rostedt <rostedt@goodmis.org>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: Sarah Sharp <sarah.a.sharp@linux.intel.com>,
	Xenia Ragiadakou <burzalodowa@gmail.com>,
	OPW Kernel Interns List <opw-kernel-interns@googlegroups.com>,
	linux-usb@vger.kernel.org, linux-wireless@vger.kernel.org,
	Kalle Valo <kvalo@qca.qualcomm.com>
Date: Fri, 26 Jul 2013 09:17:29 -0400
In-Reply-To: <1374844013.8248.47.camel@jlt4.sipsolutions.net>
References: <51DB0257.1010709@gmail.com> <20130711162002.GA5240@xanatos>
	 (sfid-20130711_182013_255578_2722BE3F) <1373562533.8201.33.camel@jlt4.sipsolutions.net>
	 <1373570955.17876.58.camel@gandalf.local.home>
	 <1374830340.8248.43.camel@jlt4.sipsolutions.net>
	 <1374841699.6580.21.camel@gandalf.local.home>
	 <1374844013.8248.47.camel@jlt4.sipsolutions.net>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, 2013-07-26 at 15:06 +0200, Johannes Berg wrote:
> On Fri, 2013-07-26 at 08:28 -0400, Steven Rostedt wrote:

> Ah, yes, that'd work. I was considering putting it into the trace event
> handling itself so I don't have to allocate those buffers and put the
> handling into every tracepoint, but I don't know how that'd work with
> interrupts coming in.

If you create helper functions, it shouldn't be too hard.

> 
> If we assume that interrupts coming in in the middle of a tracepoint
> should be rare, we could do something like
> 
>  * allocate max buffer in on the tracing ringbuffer page
>  * write data into it
>  * if no interrupt came in, reduce reservation
> 
> but I'm not sure how to implement step 3 :)
> 

It's possible to reduce the ring buffer, it's just not implemented. I'm
not sure I want to do that either. Interrupts coming in is not so rare
as it can be any interrupt being traced. This means your tracepoints
will likely waste a lot of buffer space if you are tracing interrupts as
well.

That said, I can probably implement a reduce feature of the ring buffer
if needed.

-- Steve


