Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([66.187.233.31]:41428 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750806AbYHFNje (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 6 Aug 2008 09:39:34 -0400
Subject: Re: [PATCH 01/19] orinoco: Add ESSID specific scanning for Agere fw
From: Dan Williams <dcbw@redhat.com>
To: Pavel Roskin <proski@gnu.org>
Cc: kilroyd@googlemail.com, linux-wireless@vger.kernel.org,
	orinoco-devel@lists.sourceforge.net,
	David Kilroy <kilroyd@gmail.com>,
	Jean Tourrilhes <jt@hpl.hp.com>
In-Reply-To: <1217976491.2908.36.camel@dv>
References: <1217672073-7094-1-git-send-email-kilroyd@gmail.com>
	 <1217672073-7094-2-git-send-email-kilroyd@gmail.com>
	 <1217825304.10989.20.camel@dv>
	 <1217864060.3139.10.camel@localhost.localdomain>
	 <1217970944.2908.11.camel@dv>
	 <1217973349.30531.1.camel@localhost.localdomain>
	 <1217976491.2908.36.camel@dv>
Content-Type: text/plain
Date: Wed, 06 Aug 2008 09:13:34 -0400
Message-Id: <1218028414.16977.5.camel@localhost.localdomain> (sfid-20080806_153937_214599_9108F0A4)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, 2008-08-05 at 18:48 -0400, Pavel Roskin wrote:
> On Tue, 2008-08-05 at 17:55 -0400, Dan Williams wrote:
> > On Tue, 2008-08-05 at 17:15 -0400, Pavel Roskin wrote:
> 
> > > If I use 32-bit kernel with 32-bit userspace, essid filtering works, but
> > > only to a degree.  Old scan results are cached somewhere, so if I scan
> > > with essid and then without essid, I get filtered results.  Likewise, If
> > > I don't use filtering the first time, but use it the second time, I get
> > > unfiltered results.
> > 
> > Scanning for a specific SSID never has "filtered" the results, nor
> > should it.  It just probe-scans the requested SSID and return any new
> > results in with the cached ones.  You requested an SSID scan, thus you
> > must know the SSID, thus you can do the filtering yourself?
> 
> Perhaps I used a wrong word.  If requesting a scan, I expect to get
> results from a scan with the parameters I supplied.  If the scan results
> are from a scan with different parameters, I don't want them.  I'd
> rather see the driver return EAGAIN than results of a scan with
> different parameters.

I'm not quite sure what you mean here.  You mean to say that if you
request a specific SSID scan, and the driver does not find that SSID,
that it should return EAGAIN?  I think that would be overloading EAGAIN
too much, since for scans EAGAIN means "I'm not done with your scan
request yet".

> The userspace is welcome to keep a pool of all APs found by any scans,
> but I don't think drivers should do it.

Drivers need to keep a reasonably complete list of APs internally for
association anyway.  You don't want to have to do a full scan just to
associate if you have results from 10 seconds ago that are still valid.
Furthermore, drivers need to keep cached results so that two processes
can request results of a scan after the scan is complete.  The previous
situation where the driver would clear the scan list whenever GIWSCAN
was called just sucked because then two processes would race for the
results after an IWSCAN event and one would get nothing.

A scan is a global result, not a result specific to the request.  Thus,
since any process can read the results, and since only one process is
privy to the details of how the scan was performed with WEXT, you have
to return a complete list of results for each call to GIWSCAN.

Honestly, I don't think it's that much of a problem for the userspace
process that actually requested the scan to keep it's scan parameters
around and filter the results that come back using those parameters.

Dan

