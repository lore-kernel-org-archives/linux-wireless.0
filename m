Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:40485 "EHLO sipsolutions.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1033092AbbKEQG7 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 5 Nov 2015 11:06:59 -0500
Message-ID: <1446739615.2540.6.camel@sipsolutions.net> (sfid-20151105_170813_967791_21DF5872)
Subject: Re: Configurable scan dwell time?
From: Johannes Berg <johannes@sipsolutions.net>
To: Ben Greear <greearb@candelatech.com>,
	Michal Kazior <michal.kazior@tieto.com>
Cc: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Date: Thu, 05 Nov 2015 17:06:55 +0100
In-Reply-To: <563B7D63.1010203@candelatech.com>
References: <563A9B8C.3060503@candelatech.com>
	 <CA+BoTQnYrFSLkdBgcMgnuJPvPeSjuu9oB68KkU7jRMEH5iFE2A@mail.gmail.com>
	 <1446710205.2540.1.camel@sipsolutions.net>
	 <563B7D63.1010203@candelatech.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, 2015-11-05 at 08:01 -0800, Ben Greear wrote:

> My issue is that APs can be set to beacon at longer beacon times, and
> then passive scanning at ~110ms intervals is not going to find the APs
> very often (and with bad luck, technically it could *never* find the AP
> due to scanning at unlucky periodic intervals).

Which is probably why hardly anyone ever uses longer beacon intervals
(also the added latency with powersave, of course)

> So, when I know that I am doing passive scan, I would like the option
> to set the dwell time larger.
> 
> And, for active scanning, maybe 33ms is a lot longer that is actually
> needed?

There are some (WFA?) requirements to answer within 30ms, but not
faster, so I think that's the reason for this value.

> I read through some of your comments from before.  I think we could
> treat this as a hint to the driver, and it could ignore it as needed.
> 
> Firmware implementations I'm aware of are already limited in a million
> different ways, and of course if someone cared, they could propagate
> the dwell time into the firmware if they cared.
> 

The thing though is that there are now use cases in the standard(s)
that want/require doing this. So just adding it as a hint will run the
risk of userspace (like wpa_s) using this "hint" for implementing newer
spec functionality, testing on ath9k and hwsim and declaring that it
works :-) And then we're stuck with this feature being used/advertised
on older devices where it doesn't actually work.

Now, having those standard use cases is actually a good argument *for*
adding them in the standard API, but I think we need to be more careful
around these issues - perhaps having drivers indicate that they support
it, maybe even with valid ranges, etc.

johannes
