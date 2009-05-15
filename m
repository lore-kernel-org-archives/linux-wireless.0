Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx51.mymxserver.com ([85.199.173.110]:17399 "EHLO
	mx51.mymxserver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760005AbZEOIMY (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 15 May 2009 04:12:24 -0400
From: Holger Schurig <hs4233@mail.mn-solutions.de>
To: linux-wireless@vger.kernel.org
Subject: Re: Scan while TX/RX'ing a lot of data
Date: Fri, 15 May 2009 10:11:50 +0200
Cc: Dan Williams <dcbw@redhat.com>,
	"Luis R. Rodriguez" <mcgrof@gmail.com>, Aeolus.Yang@atheros.com,
	Senthil Balasubramanian <senthilkumar@atheros.com>,
	Gaurav.Jauhar@atheros.com
References: <43e72e890905141052o1f072bc5m4bc5922327617f8b@mail.gmail.com> <1242327298.4227.25.camel@localhost.localdomain>
In-Reply-To: <1242327298.4227.25.camel@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Message-Id: <200905151011.50915.hs4233@mail.mn-solutions.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thursday 14 May 2009 20:54:58 Dan Williams wrote:
> Libertas splits scans up into 3 parts with a short return to
> the operating channel between each part.  There's nothing that
> requires cfg80211 for that to work...

Hey, it's up-to 4 channels (MRVDRV_MAX_CHANNELS_PER_SCAN).

Yeah, I had to implement this "stuttering scan" because the 
firmware that I had access to cannot send 
power-save-null-packets to the AP. Without that, I could not 
notify to the current AP that I'm away, and if the AP has data 
for me, which I don't ack for more than 1000ms, then the AP 
might have disassociated me in the mean-time.


So basically I changed the scanning into a state-machine. I get a 
list of channels to scan (e.g. "all channels", if the request 
comes from WEXT). The a scan-worker calls the logic of the 
state-machine. The state-machine does it's work and either 
re-schedules the workqueue. Or, if every channel has been 
visitied, it emits the SIOCGIWSCAN event.

It a bit more complicated, because one can force a full scan 
(e.g. when initially associating).


> Something I've tossed around for a while is counting traffic
> on the device and if its over a certain bitrate for a period
> of time, postpone the scan for a while.  But after a certain
> amount of time, there's going to be a scan no matter what.

Traffic could for example modify the time for delays between 
re-schedules of the scan-state-machine.


> Secondarily, scanning is a tradeoff between better roaming
> latency and continuous high throughput.

Kind of a QoS thingy?


> If you don't scan, 
> you have no idea what's around, and when you move and the
> current AP becomes marginal, you *have* to take the hit no
> matter what, so you can scan and find a new AP to associate
> with.

TeX does it's layouting by minimizing (calculated) uglyness. 
Maybe a background-scan-decision can be done on (calculated) 
urgentness?  E.g. if background scan is enabled at all, the 
urgentness of background scan increases in time. "Huge" amount 
of traffic decreases the urgentness. And only if urgentness 
get's to some level we do the background scan for the next n 
channels. Throw in the possibility of of a full-scan and a sane 
user-space and this scheme might actually work.



Also, I think that the background-scan stuff belongs more or less 
in the "let roaming not suck" department. I wonder where the 
GSOC people are now ...
