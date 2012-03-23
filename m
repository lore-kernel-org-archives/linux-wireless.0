Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga09.intel.com ([134.134.136.24]:36580 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759894Ab2CWUeL (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 23 Mar 2012 16:34:11 -0400
Date: Fri, 23 Mar 2012 13:34:04 -0700
From: Sarah Sharp <sarah.a.sharp@linux.intel.com>
To: Larry Finger <Larry.Finger@lwfinger.net>
Cc: jerome huang <jerome.syno@gmail.com>,
	"Xu, Andiry" <Andiry.Xu@amd.com>, linux-usb@vger.kernel.org,
	linux-wireless@vger.kernel.org
Subject: Re: rt8192cu on USB3
Message-ID: <20120323203404.GD5207@xanatos> (sfid-20120323_213419_661440_4AB17FFA)
References: <CAHaq0gKxw9Lir2bB__jNmmZPzbgq7Ky6v9Ps2RVexbnRjd8a2g@mail.gmail.com>
 <4F585BA9.6020903@amd.com>
 <2A76B9D36150BE4293842BC2FE8FF165016A31@SCYBEXDAG04.amd.com>
 <CAHaq0g+hXKdCaMm8dXiQhzqCsjAa0vihd2YE3gbw-xrMrxmOgw@mail.gmail.com>
 <CAHaq0gJRr5p2d=P_J9+NQ0=PqaCu6NLSwJ_LSjFn7HffkX-Odg@mail.gmail.com>
 <4F58F2D0.5060805@lwfinger.net>
 <CAHaq0gKSSgYX19BH92Pg+gXifSEmjvubc_nd5brO8QeLCpr1yA@mail.gmail.com>
 <4F59800B.80407@lwfinger.net>
 <20120322223107.GA8877@xanatos>
 <4F6BDEDF.2020907@lwfinger.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <4F6BDEDF.2020907@lwfinger.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, Mar 22, 2012 at 09:24:31PM -0500, Larry Finger wrote:
> On 03/22/2012 05:31 PM, Sarah Sharp wrote:
> 
> >Larry, if the driver doesn't cancel an URB that the device doesn't
> >respond to, then it will just be left on the endpoint ring.  If the
> >driver then tries to queue new transfers to that same endpoint, but the
> >device keeps NAKing the uncancelled transfer, then the endpoint ring
> >would fill up with unanswered transfers.
> >
> >Perhaps some userspace or kernel portion is forgetting to cancel URBs
> >before moving onto the next thing?  You said you moved to asynchronous
> >transfers, so maybe the problem lies there?
> 
> The writes have always been asynchronous and reads are synchronous.
> The only change was to convert the firmware uploading writes from
> 32-bits at a time into block writes of 1000+ 32-bit words.

Yeah, that's going to cause the out-of-room warning under xHCI.  That
should be fixed in the 3.4-rc1 kernel though.

> Would xhci be worse that ohci or ehci in terms of the device not
> responding to URBs? We only see problems with USB3.0 hubs, never
> with 2.0 or 1.1.

That's because EHCI handles arbitrarily large transfers, and xHCI didn't
until now.

> I am looking into changing the writes to be synchronous. That should
> clear up any problems.

Yeah, your problem probably was in the bulk large transfer, not the
unfinished canceled URBs.  I would suggest getting your reporters to
just try 3.4-rc1 and see if it helps before doing too much work to debug
this.

Sarah Sharp
