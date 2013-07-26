Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([144.76.43.152]:58972 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757038Ab3GZNHC (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 26 Jul 2013 09:07:02 -0400
Message-ID: <1374844013.8248.47.camel@jlt4.sipsolutions.net> (sfid-20130726_150713_085042_D4A940CC)
Subject: Re: Help adding trace events to xHCI
From: Johannes Berg <johannes@sipsolutions.net>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: Sarah Sharp <sarah.a.sharp@linux.intel.com>,
	Xenia Ragiadakou <burzalodowa@gmail.com>,
	OPW Kernel Interns List <opw-kernel-interns@googlegroups.com>,
	linux-usb@vger.kernel.org, linux-wireless@vger.kernel.org,
	Kalle Valo <kvalo@qca.qualcomm.com>
Date: Fri, 26 Jul 2013 15:06:53 +0200
In-Reply-To: <1374841699.6580.21.camel@gandalf.local.home>
References: <51DB0257.1010709@gmail.com> <20130711162002.GA5240@xanatos>
	 (sfid-20130711_182013_255578_2722BE3F) <1373562533.8201.33.camel@jlt4.sipsolutions.net>
	 <1373570955.17876.58.camel@gandalf.local.home>
	 <1374830340.8248.43.camel@jlt4.sipsolutions.net>
	 <1374841699.6580.21.camel@gandalf.local.home>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, 2013-07-26 at 08:28 -0400, Steven Rostedt wrote:

> > My original though here was that we should be able to reserve (maximum)
> > space on the per-CPU buffer, and then relinquish some of it after the
> > tracepoint was written to the data, but I never had the time to check if
> > that was possible to implement. It would make it a little inefficient at
> > page boundaries, but that seems OK given that our maximum size is only
> > ~100 bytes or so now.

> Yes that would be trivial to implement. If the max buffer is ~100 bytes,
> allocate 256 byte buffers per cpu. Also have a per cpu index, and then
> have something like this:
> 
>  [snip]

Ah, yes, that'd work. I was considering putting it into the trace event
handling itself so I don't have to allocate those buffers and put the
handling into every tracepoint, but I don't know how that'd work with
interrupts coming in.

If we assume that interrupts coming in in the middle of a tracepoint
should be rare, we could do something like

 * allocate max buffer in on the tracing ringbuffer page
 * write data into it
 * if no interrupt came in, reduce reservation

but I'm not sure how to implement step 3 :)

johannes

