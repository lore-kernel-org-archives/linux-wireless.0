Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:45237 "EHLO sipsolutions.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1947158AbcBRUVq (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 18 Feb 2016 15:21:46 -0500
Message-ID: <1455826903.2084.27.camel@sipsolutions.net> (sfid-20160218_212150_673300_7B36D81C)
Subject: Re: Rate Control Tuning/Information
From: Johannes Berg <johannes@sipsolutions.net>
To: Todd Efflam <todd.efflam@gmail.com>, linux-wireless@vger.kernel.org
Date: Thu, 18 Feb 2016 21:21:43 +0100
In-Reply-To: <CAHWMYyDphLy2KGKuCKq-R9t6NVyjSF18WpA-emc9eZcSY30mZg@mail.gmail.com> (sfid-20160212_013210_211514_10210198)
References: <CAHWMYyDphLy2KGKuCKq-R9t6NVyjSF18WpA-emc9eZcSY30mZg@mail.gmail.com>
	 (sfid-20160212_013210_211514_10210198)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi,

> We're currently trying to tune the rate control algorithm (minstrel)
> with our video encoding quality.  We're using a udp network so
> ideally
> the two will match up and we won't be trying to encode at too high of
> a quality when our data rate is decreased.
> 
> In doing so, I have a couple of questions:
> a) Is it possible to change the timing between rate changes?  We'd
> like to not change in the middle of encoding a video frame and give
> our encoding enough time to create a frame that will fit in the
> current data rate.

I don't think that's something you can control today, and I'm not sure
how that would work anyhow - if the situation changes quickly you'd
want rate control to change quickly too. Otherwise it has to be over-
conservative which also leads to bad performance.

> b) Is there a better way to get the current data rate than using
> iwconfig?  Or possibly an interrupt for when the data rate is changed
> so we can change our encoding quality to match it as soon as
> possible?

You should probably use the equivalent of "iw wlan0 station dump" or
so. There's no event for this today though.

> c) If the above aren't possible, is the best way to manually change
> the data rate by configuring the kernel to not use rate control and
> send rate change requests via something like "echo 'index' >
> /sys/kernel/debug/ieee80211/phy0/rc/fixed_rate_idx" (posted here:
> http://unix.stackexchange.com/questions/182520/disable-rate-control-
> in-linux-wireless-driver).

This is possible, but I can't recommend it - you have no good way of
tuning that short of implementing rate control yourself...

Also, if you pick a too high rate and get lots of retries, you also
lose because the frames will get retransmitted and you'll miss the
decoder deadline for them.

You might want to turn down retransmissions, or better yet give your
frames deadlines (must be sent within X ms), though I don't think any
driver supports this right now.

Ideally, we'd add a much richer socket API that lets you control some
of these parameters.

johannes
