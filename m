Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:53268 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755275Ab3APXaw (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 16 Jan 2013 18:30:52 -0500
Message-ID: <1358379078.15012.68.camel@jlt4.sipsolutions.net> (sfid-20130117_003059_677298_30E135E5)
Subject: Re: [RFC] Fixes for problems with off-channel powersave
From: Johannes Berg <johannes@sipsolutions.net>
To: Seth Forshee <seth.forshee@canonical.com>
Cc: linux-wireless@vger.kernel.org
Date: Thu, 17 Jan 2013 00:31:18 +0100
In-Reply-To: <1357668645-5101-1-git-send-email-seth.forshee@canonical.com>
References: <1357668645-5101-1-git-send-email-seth.forshee@canonical.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Seth,

> When testing with iperf I've been observing very significant problems
> with throughput and packet loss during software scans. Throughput often
> drops to the point where iperf is reporting 0 bits/sec for several
> seconds, and packet loss commonly gets over 20%. 

Ouch.

One caveat up front: While I'm somewhat familiar with the SW scan code,
we have "HW" scan, so I'm not really completely into the details.

> I started investigating
> and discovered the following problems:
> 
>  1. It seems that drivers are responsible for ensuring that PM is set in
>     frame control when powersave is enabled. However drivers are unaware
>     of off-channel powersave, so when the scan is suspended frames may
>     be transmitted that cause the AP to think we've exited powersave. As
>     a result the AP may attempt to deliver frames while we are
>     off-channel.

Hm, yeah, this is a problem. I've kinda always known this... 802.11mb
(or -2012) clarified that in (most?) management frames at least it
doesn't matter.

>  2. There's no flushing of the hardware queues after queueing the
>     nullfunc frame to enable off-channel powersave before going
>     off-channel, so it's possible to go off-channel before the frame is
>     transmitted.

Yep. And to make matters worse, flush() is broken. If the driver has
queues stopped while being asked to flush, it will probably enable
queues and I'm pretty sure we'll give it more frames while it's
flushing.

>  3. There's no flush of pending frames prior to queueing the nullfunc
>     frame to enable powersave. That frame is sent at a high priority,
>     and drivers supporting QoS may have lower-priority frames queued
>     with PM cleared. Those frames will be sent after the nullfunc, and
>     the AP may try to deliver frames while we are off-channel.

Yeah...

>  4. During a scan we won't process beacon frames from our associated AP,
>     which prevents PS-Poll from starting when the scan is suspended.
>     Even if we process the beacons we won't start PS-Poll unless
>     powersave is actually enabled, which isn't the case during a scan.

Uh oh.. yeah, ok, but this gets really really complicated. I truly hate
the powersave code. One of these days I'm just going to rip it out ;-)

> It turns out that fixing problem #1 (i.e. patch 2) probably isn't
> necessary with the other changes, as no frames should be sent while
> off-channel PS is enabled. Does this still seem like a problem worth
> fixing?

Hmm. Probably not then. It just makes the API and driver implementation
more complex, no?

johannes

