Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:32271 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758148Ab3GZM2W (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 26 Jul 2013 08:28:22 -0400
Message-ID: <1374841699.6580.21.camel@gandalf.local.home> (sfid-20130726_142827_536017_84BE83C7)
Subject: Re: Help adding trace events to xHCI
From: Steven Rostedt <rostedt@goodmis.org>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: Sarah Sharp <sarah.a.sharp@linux.intel.com>,
	Xenia Ragiadakou <burzalodowa@gmail.com>,
	OPW Kernel Interns List <opw-kernel-interns@googlegroups.com>,
	linux-usb@vger.kernel.org, linux-wireless@vger.kernel.org,
	Kalle Valo <kvalo@qca.qualcomm.com>
Date: Fri, 26 Jul 2013 08:28:19 -0400
In-Reply-To: <1374830340.8248.43.camel@jlt4.sipsolutions.net>
References: <51DB0257.1010709@gmail.com> <20130711162002.GA5240@xanatos>
	 (sfid-20130711_182013_255578_2722BE3F) <1373562533.8201.33.camel@jlt4.sipsolutions.net>
	 <1373570955.17876.58.camel@gandalf.local.home>
	 <1374830340.8248.43.camel@jlt4.sipsolutions.net>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, 2013-07-26 at 11:19 +0200, Johannes Berg wrote:

> My original though here was that we should be able to reserve (maximum)
> space on the per-CPU buffer, and then relinquish some of it after the
> tracepoint was written to the data, but I never had the time to check if
> that was possible to implement. It would make it a little inefficient at
> page boundaries, but that seems OK given that our maximum size is only
> ~100 bytes or so now.
> 

Yes that would be trivial to implement. If the max buffer is ~100 bytes,
allocate 256 byte buffers per cpu. Also have a per cpu index, and then
have something like this:


	index = local_add_return(this_cpu_ptr(trace_index), len);

	if (index >= MAX_BUF) {
		/* write tracepoint with failed buffer */
		local_sub(this_cpu_ptr(trace_index));
		return;
	}

	index -= len;

	memcpy(this_cpu_ptr(trace_buf) + index, string, len);

	/* write tracepoint with trace_buf */

	local_sub(this_cpu_ptr(trace_index), len);


This way the trace_buf will work like a stack allocator. The
local_add_return() will reserve the space in the buffer such that if an
interrupt were to come in, it would allocate after that space. The check
for MAX_BUF tests for the case that the buffer was too big and had to
bail. Still trace that event to let the user (yourself) know you need a
bigger buffer.

-- Steve


