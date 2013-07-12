Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine02.qualcomm.com ([199.106.114.251]:10401 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750973Ab3GLE0I (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 12 Jul 2013 00:26:08 -0400
From: Kalle Valo <kvalo@qca.qualcomm.com>
To: Sarah Sharp <sarah.a.sharp@linux.intel.com>
CC: Johannes Berg <johannes@sipsolutions.net>,
	Xenia Ragiadakou <burzalodowa@gmail.com>,
	OPW Kernel Interns List <opw-kernel-interns@googlegroups.com>,
	<linux-usb@vger.kernel.org>, <linux-wireless@vger.kernel.org>,
	Steven Rostedt <rostedt@goodmis.org>
Subject: Re: Help adding trace events to xHCI
References: <51DB0257.1010709@gmail.com> <20130711162002.GA5240@xanatos>
	<1373562533.8201.33.camel@jlt4.sipsolutions.net>
	<20130711190035.GD5240@xanatos>
Date: Fri, 12 Jul 2013 07:25:59 +0300
In-Reply-To: <20130711190035.GD5240@xanatos> (Sarah Sharp's message of "Thu,
	11 Jul 2013 12:00:35 -0700")
Message-ID: <87y59c4d60.fsf@kamboji.qca.qualcomm.com> (sfid-20130712_062613_538231_7952CA00)
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Sarah Sharp <sarah.a.sharp@linux.intel.com> writes:

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

Instead of individual trace points for command I would recommend to
consider just pushing the whole command buffer to the trace point and
parse the command in trace-cmd plugin in user space. Kernel code would
be simpler that way.

-- 
Kalle Valo
