Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from sabertooth01.qualcomm.com ([65.197.215.72]:18020 "EHLO
	sabertooth01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S964972Ab3GLS7e (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 12 Jul 2013 14:59:34 -0400
From: Kalle Valo <kvalo@qca.qualcomm.com>
To: Sarah Sharp <sarah.a.sharp@linux.intel.com>
CC: Johannes Berg <johannes@sipsolutions.net>,
	Xenia Ragiadakou <burzalodowa@gmail.com>,
	OPW Kernel Interns List <opw-kernel-interns@googlegroups.com>,
	<linux-usb@vger.kernel.org>, <linux-wireless@vger.kernel.org>,
	Steven Rostedt <rostedt@goodmis.org>,
	<linux-trace-users@vger.kernel.org>
Subject: Re: Help adding trace events to xHCI
References: <51DB0257.1010709@gmail.com> <20130711162002.GA5240@xanatos>
	<1373562533.8201.33.camel@jlt4.sipsolutions.net>
	<20130711190035.GD5240@xanatos>
	<87y59c4d60.fsf@kamboji.qca.qualcomm.com>
	<20130712164104.GA15531@xanatos>
Date: Fri, 12 Jul 2013 21:59:18 +0300
In-Reply-To: <20130712164104.GA15531@xanatos> (Sarah Sharp's message of "Fri,
	12 Jul 2013 09:41:04 -0700")
Message-ID: <878v1b4nax.fsf@kamboji.qca.qualcomm.com> (sfid-20130712_205940_209960_246582B3)
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Sarah Sharp <sarah.a.sharp@linux.intel.com> writes:

> On Fri, Jul 12, 2013 at 07:25:59AM +0300, Kalle Valo wrote:
>
>> Instead of individual trace points for command I would recommend to
>> consider just pushing the whole command buffer to the trace point and
>> parse the command in trace-cmd plugin in user space. Kernel code would
>> be simpler that way.
>
> Thanks for the suggestion.  I'm not familiar with all the userspace
> tools for trace events, so I didn't know about the command parser.  Is
> there documentation or a list of resources for all the userspace trace
> event plugins?  If so, can you give us a pointer to it?

For ath6kl I started writing (but did not finish yet) a simple python
plugin for trace-cmd. I really like the idea of implementing of
implementing the parser with python, it's so much faster and more
convenient. I haven't published the plugin yet so that's not going to
help you right now.

But trace-cmd documentation about python plugins should give some ideas
how to use python:

https://git.kernel.org/cgit/linux/kernel/git/rostedt/trace-cmd.git/tree/Documentation/README.PythonPlugin

And as usual, Johannes is a good source of information ;)

-- 
Kalle Valo
