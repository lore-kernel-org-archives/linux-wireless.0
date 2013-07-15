Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.openrapids.net ([64.15.138.104]:43669 "EHLO
	blackscsi.openrapids.net" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1755996Ab3GOMzt (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 15 Jul 2013 08:55:49 -0400
Date: Mon, 15 Jul 2013 08:55:46 -0400
From: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
To: Mark Wielaard <mjw@redhat.com>
Cc: Sarah Sharp <sarah.a.sharp@linux.intel.com>,
	Kalle Valo <kvalo@qca.qualcomm.com>,
	Johannes Berg <johannes@sipsolutions.net>,
	Xenia Ragiadakou <burzalodowa@gmail.com>,
	OPW Kernel Interns List <opw-kernel-interns@googlegroups.com>,
	linux-usb@vger.kernel.org, linux-wireless@vger.kernel.org,
	Steven Rostedt <rostedt@goodmis.org>,
	linux-trace-users@vger.kernel.org, lttng-dev@lists.lttng.org
Subject: Re: Help adding trace events to xHCI
Message-ID: <20130715125546.GA16263@Krystal> (sfid-20130715_145555_215008_835193D7)
References: <51DB0257.1010709@gmail.com> <20130711162002.GA5240@xanatos> <1373562533.8201.33.camel@jlt4.sipsolutions.net> <20130711190035.GD5240@xanatos> <87y59c4d60.fsf@kamboji.qca.qualcomm.com> <20130712164104.GA15531@xanatos> <20130712170827.GA18819@Krystal> <20130712193531.GA6954@toonder.wildebeest.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20130712193531.GA6954@toonder.wildebeest.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

* Mark Wielaard (mjw@redhat.com) wrote:
> Hi Mathieu,
> 
> On Fri, Jul 12, 2013 at 01:08:28PM -0400, Mathieu Desnoyers wrote:
> > * Sarah Sharp (sarah.a.sharp@linux.intel.com) wrote:
> > > Thanks for the suggestion.  I'm not familiar with all the userspace
> > > tools for trace events, so I didn't know about the command parser.  Is
> > > there documentation or a list of resources for all the userspace trace
> > > event plugins?  If so, can you give us a pointer to it?
> > 
> > You might want to try out LTTng-UST. It provides TRACEPOINT_EVENT() and
> > tracepoint() for user-space instrumentation. See:
> > 
> > - https://lttng.org/files/doc/man-pages/man3/lttng-ust.3.html
> 
> Is that build on the <sys/sdt.h> ust probe points as embedded in glibc
> for example that gdb and systemtap use to access user space trace
> points?

LTTng-UST tracepoints are not built on sdt.h, but they can optionally
emit sdt.h instrumentation. All you need to do is run:

./configure --with-sdt

when configuring lttng-ust, and after a make install, sdt.h
STAP_PROBEV() will be emitted whenever a lttng-ust tracepoint() macro is
used in the system.

> Can tools use lttng-ust and <sys/sdt.h> tracepoints
> interchangeably by parsing the ELF notes described in
> http://sourceware.org/systemtap/wiki/UserSpaceProbeImplementation

Since lttng-ust tracepoints emit sdt.h instrumentation, yes. However,
please note that the reverse is not possible: sdt.h instrumentation does
not allow tracing with LTTng-UST.

Thanks,

Mathieu

> 
> Thanks,
> 
> Mark

-- 
Mathieu Desnoyers
EfficiOS Inc.
http://www.efficios.com
