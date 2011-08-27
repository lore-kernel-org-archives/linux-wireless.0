Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from lo.gmane.org ([80.91.229.12]:53660 "EHLO lo.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751780Ab1H0WkJ (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sat, 27 Aug 2011 18:40:09 -0400
Received: from list by lo.gmane.org with local (Exim 4.69)
	(envelope-from <glkwg-linux-wireless@m.gmane.org>)
	id 1QxRXs-0006wo-NC
	for linux-wireless@vger.kernel.org; Sun, 28 Aug 2011 00:40:08 +0200
Received: from 69-196-174-66.dsl.teksavvy.com ([69.196.174.66])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-wireless@vger.kernel.org>; Sun, 28 Aug 2011 00:40:08 +0200
Received: from dennisn by 69-196-174-66.dsl.teksavvy.com with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-wireless@vger.kernel.org>; Sun, 28 Aug 2011 00:40:08 +0200
To: linux-wireless@vger.kernel.org
From: Dennis Nezic <dennisn@dennisn.dyndns.org>
Subject: Re: Vague wifi fail with ipw2200
Date: Sat, 27 Aug 2011 18:39:56 -0400
Message-ID: <20110827183956.55c8a750.dennisn@dennisn.dyndns.org> (sfid-20110828_004014_167165_B337EB6C)
References: <20110820151402.605226e7.dennisn@dennisn.dyndns.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sat, 20 Aug 2011 15:14:02 -0400, Dennis Nezic wrote:
> For that last long while, I have been having strange vague wifi fails
> every few days -- my ipw2200 ad-hoc server would suddenly become very
> unresponsive -- instead of the usual stable 0.6ms pings, they would
> fluctuate wildly from a minimum of about 2ms to 10ms, even though the
> connection wasn't being used. More seriously/substantially, iwconfig
> would show the "Tx excessive retries" to be steadily increasing -- and
> drastically increasing with more usage -- 10-100 retries per second
> under heavy usage. I have tried playing with the "Retry limit" "RTS
> thr" and "Fragrment thr" values a bit, and with a fixed bitrate, but
> they didn't seem to have any significant effect -- the connection
> would still inevitably reach this turbulence and ultimately fail,
> forcing me to restart it.
> 
> I don't think it's simply a noisy environment, although there are
> about 10 other access points around here, none of which shares my
> channel 1 at the moment. (There's one on 2, one on 3.) Because that
> wouldn't explain why the connection becomes stable and fast after I
> restart the wifi interface.
> 
> I'm guessing it's something to do with the driver?

So, my ipw2200 pcie wifi card has two wires/antennas, Main and Aux, and
(don't ask) my Main one is connected to a good thick antenna (which
can sustain rather high ~2MB/s bandwidth), but my Aux one is cut (but
can still sustain low ~30KB/s bandwidth).

I first noticed something suspicious and coherent when I tried setting
the module option antenna=1 (1=Main, 3=Aux, 0=both(default)) ... it
seemed more stable -- BUT, it too (especially when being used heavily)
would eventually slow down to a crawl/halt, and lead to the incessant
increase of "Tx excessive retries".

I then tried with the module option antenna=3(Aux), and it immediately
was slow/crawling, BUT it would eventually speed up.

So, I think either the firmware or the kernel module (which one?) is
overriding my antenna option (ie. during high traffic). This shouldn't
be allowed.

I ended up disconnecting my Aux antenna physically, and my connection
(FINALLY!!) seems to have stabilized ... to date, it hasn't slowed down
to the crawling (Aux-antenna) speed. There are a few "retry" packets,
but they are relatively few and not out of control. (Before, after the
first hiccup/slowdown was encountered, they would constantly begin
accumulating, unless I restarted the interface.)

