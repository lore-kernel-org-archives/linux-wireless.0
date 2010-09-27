Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from ext.lri.fr ([129.175.15.4]:37940 "EHLO ext.lri.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757299Ab0I0XBk (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 27 Sep 2010 19:01:40 -0400
Date: Tue, 28 Sep 2010 01:01:37 +0200
From: Ignacy Gawedzki <i@lri.fr>
To: Christian Lamparter <chunkeey@googlemail.com>
Cc: linux-wireless@vger.kernel.org
Subject: Re: A few questions about modifications in carl9170
Message-ID: <20100927230137.GA5702@qubit.lri.fr>
References: <20100927132957.GA2977@qubit.lri.fr>
 <201009271737.16603.chunkeey@googlemail.com>
 <20100927160557.GA5121@qubit.lri.fr>
 <201009271936.22261.chunkeey@googlemail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <201009271936.22261.chunkeey@googlemail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, Sep 27, 2010 at 07:36:21PM +0200, thus spake Christian Lamparter:
> Sure, but why when you have a monotonic 40 MHz timer?

Glad to know there is such a thing, then. =)

> (It isn't so much what you do in the firmware, as long as you don't put
> printk into the drivers hot-paths)
> 
> > > (Haven't seen the WARN before, kernel/workqueue.c code has changed a lot
> > > and flush_cpu_workqueue is no more...)
> > 
> > OK, I'll stick with the latest wireless-testing then.  BTW, I noticed that the
> > FW API is 1.8.8.2, while driver API in wireless-testing is still 1.8.8.1.
> Actually, the firmware is already at 1.8.8.3-pre. But it shouldn't matter if
> what API "version" you are using, as long as the firmware descriptors and
> command interface structs are the same.

Okay, I thought these API versions were there to be checked by the driver
somehow for conformance.

> > Having some stability issues with this combination, I reverted the last few
> > commits in the FW's git back to API 1.8.8.1.  Are these different numbers
> > nevertheless compatible with each other?
> "Stability issues"? Again, a "vague" and stretchy term. Do you have "Oops" -
> reports or something like that? 

Yeah, sorry for the vagueness, I promise I'll grab as much info as possible
upon next encounter of such a thing.  As I remember it, it's mainly a matter
of the module getting suck somehow (and attempts to unload it getting stuck as
well) and the card not being detected upon subsequent insertions anymore.

I just tried the whole setup with the latest wireless-testing sources and your
patch on the firmware.  So far, so good, the problems I had previously are not
showing up.  I'm now just adapting your proposition to support rollover and
conversion of the measurement to nanoseconds.

One last question about your patch.  If a frame transmission fails altogether,
i.e. the maximum attempts have been made and no ACK has been received
whatsoever, will the driver get a tx_status with the overall timer spent
serving that frame anyway (read: that's what I actually want)?

Great thanks for your help.

Kind regards,

Ignacy

-- 
/* This is not a comment */
