Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:12136 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932179Ab3GZOFn (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 26 Jul 2013 10:05:43 -0400
Message-ID: <1374847540.6580.26.camel@gandalf.local.home> (sfid-20130726_160547_926731_EA782230)
Subject: Re: Help adding trace events to xHCI
From: Steven Rostedt <rostedt@goodmis.org>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: Sarah Sharp <sarah.a.sharp@linux.intel.com>,
	Xenia Ragiadakou <burzalodowa@gmail.com>,
	OPW Kernel Interns List <opw-kernel-interns@googlegroups.com>,
	linux-usb@vger.kernel.org, linux-wireless@vger.kernel.org,
	Kalle Valo <kvalo@qca.qualcomm.com>
Date: Fri, 26 Jul 2013 10:05:40 -0400
In-Reply-To: <1374846358.8248.53.camel@jlt4.sipsolutions.net>
References: <51DB0257.1010709@gmail.com> <20130711162002.GA5240@xanatos>
	 (sfid-20130711_182013_255578_2722BE3F) <1373562533.8201.33.camel@jlt4.sipsolutions.net>
	 <1373570955.17876.58.camel@gandalf.local.home>
	 <1374830340.8248.43.camel@jlt4.sipsolutions.net>
	 <1374841699.6580.21.camel@gandalf.local.home>
	 <1374844013.8248.47.camel@jlt4.sipsolutions.net>
	 <1374844649.6580.24.camel@gandalf.local.home>
	 <1374846358.8248.53.camel@jlt4.sipsolutions.net>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, 2013-07-26 at 15:45 +0200, Johannes Berg wrote:

> Well, right now I can live with allocation 110 bytes for each
> tracepoint, this would just optimise it down. If I was in the middle of
> writing one such event while an interrupt came in, I'd not be able to
> reduce the ring-buffer allocation again. I doubt that an interrupt would
> come in much of the time between allocating the new event and
> deallocating it partially. The more difficult question would seem to be
> whether or not we can reliably detect an interrupt having written
> another event.
> 

Hmm, you may be convincing me ;-)

As it just allocates the "max" anyway, this feature will actually help.

Don't worry about the detection of interrupt, it already does that with
the discard event. It wouldn't be that hard to extend that into a
reduction too.

-- Steve


