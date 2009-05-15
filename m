Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx2.redhat.com ([66.187.237.31]:50983 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753232AbZEOXPE (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 15 May 2009 19:15:04 -0400
Subject: Re: Scan while TX/RX'ing a lot of data
From: Dan Williams <dcbw@redhat.com>
To: Holger Schurig <hs4233@mail.mn-solutions.de>
Cc: linux-wireless@vger.kernel.org,
	"Luis R. Rodriguez" <mcgrof@gmail.com>, Aeolus.Yang@atheros.com,
	Senthil Balasubramanian <senthilkumar@atheros.com>,
	Gaurav.Jauhar@atheros.com
In-Reply-To: <200905151011.50915.hs4233@mail.mn-solutions.de>
References: <43e72e890905141052o1f072bc5m4bc5922327617f8b@mail.gmail.com>
	 <1242327298.4227.25.camel@localhost.localdomain>
	 <200905151011.50915.hs4233@mail.mn-solutions.de>
Content-Type: text/plain
Date: Fri, 15 May 2009 19:15:53 -0400
Message-Id: <1242429353.10933.32.camel@localhost.localdomain>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, 2009-05-15 at 10:11 +0200, Holger Schurig wrote:
> On Thursday 14 May 2009 20:54:58 Dan Williams wrote:
> > Libertas splits scans up into 3 parts with a short return to
> > the operating channel between each part.  There's nothing that
> > requires cfg80211 for that to work...
> 
> Hey, it's up-to 4 channels (MRVDRV_MAX_CHANNELS_PER_SCAN).
> 
> Yeah, I had to implement this "stuttering scan" because the 
> firmware that I had access to cannot send 
> power-save-null-packets to the AP. Without that, I could not 
> notify to the current AP that I'm away, and if the AP has data 
> for me, which I don't ack for more than 1000ms, then the AP 
> might have disassociated me in the mean-time.
> 
> 
> So basically I changed the scanning into a state-machine. I get a 
> list of channels to scan (e.g. "all channels", if the request 
> comes from WEXT). The a scan-worker calls the logic of the 
> state-machine. The state-machine does it's work and either 
> re-schedules the workqueue. Or, if every channel has been 
> visitied, it emits the SIOCGIWSCAN event.
> 
> It a bit more complicated, because one can force a full scan 
> (e.g. when initially associating).
> 
> 
> > Something I've tossed around for a while is counting traffic
> > on the device and if its over a certain bitrate for a period
> > of time, postpone the scan for a while.  But after a certain
> > amount of time, there's going to be a scan no matter what.
> 
> Traffic could for example modify the time for delays between 
> re-schedules of the scan-state-machine.
> 
> 
> > Secondarily, scanning is a tradeoff between better roaming
> > latency and continuous high throughput.
> 
> Kind of a QoS thingy?
> 
> 
> > If you don't scan, 
> > you have no idea what's around, and when you move and the
> > current AP becomes marginal, you *have* to take the hit no
> > matter what, so you can scan and find a new AP to associate
> > with.
> 
> TeX does it's layouting by minimizing (calculated) uglyness. 
> Maybe a background-scan-decision can be done on (calculated) 
> urgentness?  E.g. if background scan is enabled at all, the 
> urgentness of background scan increases in time. "Huge" amount 

Well, what does "background scan" mean?  mac80211 will obviously accept
beacons from APs on the same channel and happily add them to the scan
list.  But a background scan would imply that the card itself is taking
over the decision about when to jump around and scan, basically the same
thing NM is doing, right?  When would the card/stack decided to
background scan, and what channels would it background scan on?  If it
doesn't do more or less all passive channels, then it wouldn't be that
useful for figuring out the site survey data.

Dan


