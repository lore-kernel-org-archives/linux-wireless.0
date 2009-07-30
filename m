Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx75.mail.ru ([94.100.176.90]:57676 "EHLO mx75.mail.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752579AbZG3UJn (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 30 Jul 2009 16:09:43 -0400
Subject: Re: rt2x00: rt73usb doesn't receive PS Poll frames in the AP mode
From: Igor Perminov <igor.perminov@inbox.ru>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless@vger.kernel.org
In-Reply-To: <1248794724.8113.12.camel@johannes.local>
References: <1248784603.29068.44.camel@sunlight>
	 <1248787142.8113.10.camel@johannes.local>
	 <1248790678.29068.94.camel@sunlight>
	 <1248794724.8113.12.camel@johannes.local>
Content-Type: text/plain
Date: Fri, 31 Jul 2009 00:09:41 +0400
Message-Id: <1248984581.29068.265.camel@sunlight>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, 28/07/2009 at 17:25 +0200, Johannes Berg wrote:
> On Tue, 2009-07-28 at 18:17 +0400, Igor Perminov wrote:
> 
> > And in case we introduce the FIF_PSPOLL flag, what the exact semantics
> > will it have? When the FIF_CONTROL flag is passed to a driver, but the
> > FIF_PSPOLL one isn't, should the driver filter out PS Poll frames (a) or
> > not (b)?
> 
> Like all filter flags, FIF_PSPOLL would mean "give us PSPOLL frames
> please", so (b).

And one more question.

How will a driver behave in case a device has no a separate hardware
filter for PS Poll frames? I.e. what value should the driver return from
configure_filter in total_flags?

In case there is one common filter for all control frames, it's an easy
thing. If FIF_CONTROL or FIF_PSPOLL are passed to driver's
configure_filter in total_flags, both of them should be set there and
the filter should be configured to pass through all control frames.

And suppose a device has two filters: one for ACK frames and one for all
other control frames.
Suppose FIF_CONTROL is passed in total_flags only. In that case the
driver sets FIF_PSPOLL there and configures both filters to pass through
frames. Right?
And what if FIF_PSPOLL is passed in total_flags only? In that case the
ACK filter should be configured to filter out ACK frames (otherwise it
would have performance overhead at least). And the second filter is
configured to pass through frames only (i.e. all control frames except
for ACK). So, the driver will receive not only PS Poll control frames,
but some others.
The question here is: should the driver set FIF_CONTROL in total_flags
or not in that case?

Igor


