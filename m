Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([144.76.43.152]:58352 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753006Ab3GZJTG (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 26 Jul 2013 05:19:06 -0400
Message-ID: <1374830340.8248.43.camel@jlt4.sipsolutions.net> (sfid-20130726_111913_073880_77474BA9)
Subject: Re: Help adding trace events to xHCI
From: Johannes Berg <johannes@sipsolutions.net>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: Sarah Sharp <sarah.a.sharp@linux.intel.com>,
	Xenia Ragiadakou <burzalodowa@gmail.com>,
	OPW Kernel Interns List <opw-kernel-interns@googlegroups.com>,
	linux-usb@vger.kernel.org, linux-wireless@vger.kernel.org,
	Kalle Valo <kvalo@qca.qualcomm.com>
Date: Fri, 26 Jul 2013 11:19:00 +0200
In-Reply-To: <1373570955.17876.58.camel@gandalf.local.home>
References: <51DB0257.1010709@gmail.com> <20130711162002.GA5240@xanatos>
	 (sfid-20130711_182013_255578_2722BE3F) <1373562533.8201.33.camel@jlt4.sipsolutions.net>
	 <1373570955.17876.58.camel@gandalf.local.home>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, 2013-07-11 at 15:29 -0400, Steven Rostedt wrote:

> > Note that there's no easy way to dynamically allocate the right amount
> > of space in the ringbuffer, or at least I haven't found one. We
> > therefore have a static size, which is somewhat inefficient.
> 
> Can you add a helper function? If these trace events can't nest (one in
> interrupt context and another in normal context with interrupts
> enabled), then you can just allocate a per-cpu buffer and store the
> string in that, and then move the string into the buffer.

In my situation personally, I can't, because I can have them in
interrupt and regular context (with interrupts enabled).

My original though here was that we should be able to reserve (maximum)
space on the per-CPU buffer, and then relinquish some of it after the
tracepoint was written to the data, but I never had the time to check if
that was possible to implement. It would make it a little inefficient at
page boundaries, but that seems OK given that our maximum size is only
~100 bytes or so now.

johannes

