Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga02.intel.com ([134.134.136.20]:14549 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S964825Ab3GLQlU (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 12 Jul 2013 12:41:20 -0400
Date: Fri, 12 Jul 2013 09:41:04 -0700
From: Sarah Sharp <sarah.a.sharp@linux.intel.com>
To: Kalle Valo <kvalo@qca.qualcomm.com>
Cc: Johannes Berg <johannes@sipsolutions.net>,
	Xenia Ragiadakou <burzalodowa@gmail.com>,
	OPW Kernel Interns List <opw-kernel-interns@googlegroups.com>,
	linux-usb@vger.kernel.org, linux-wireless@vger.kernel.org,
	Steven Rostedt <rostedt@goodmis.org>,
	linux-trace-users@vger.kernel.org
Subject: Re: Help adding trace events to xHCI
Message-ID: <20130712164104.GA15531@xanatos> (sfid-20130712_184125_455316_02C3716C)
References: <51DB0257.1010709@gmail.com>
 <20130711162002.GA5240@xanatos>
 <1373562533.8201.33.camel@jlt4.sipsolutions.net>
 <20130711190035.GD5240@xanatos>
 <87y59c4d60.fsf@kamboji.qca.qualcomm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <87y59c4d60.fsf@kamboji.qca.qualcomm.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, Jul 12, 2013 at 07:25:59AM +0300, Kalle Valo wrote:
> Sarah Sharp <sarah.a.sharp@linux.intel.com> writes:
> 
> > My initial list of specific trace points was something like:
> >
> > 1. xHCI host initialization and shutdown
> >
> > 2. xHCI memory allocation (dynamic ring resizing, structure alloc, etc)
> >
> > 3. A few individual xHCI host controller command tracepoints:
> >    * status only for all completed commands
> >    * Address Device command status and output
> >    * Configure Endpoint and Evaluate Context output
> >    * individual trace points for other xHCI commands
> >
> > 4. Tracepoints for all USB transfer types:
> >    * Control TX output (only for non-successful transfers)
> >    * Bulk TX
> >    * Interrupt TX
> >    * Isoc TX
> >
> > 5. URB cancellation
> >
> > And probably more.  Basically, I want to be able to control what gets
> > printed, based on where I think the xHCI bug might be.  Does that sound
> > reasonable?
> 
> Instead of individual trace points for command I would recommend to
> consider just pushing the whole command buffer to the trace point and
> parse the command in trace-cmd plugin in user space. Kernel code would
> be simpler that way.

Thanks for the suggestion.  I'm not familiar with all the userspace
tools for trace events, so I didn't know about the command parser.  Is
there documentation or a list of resources for all the userspace trace
event plugins?  If so, can you give us a pointer to it?

Sarah Sharp
