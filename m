Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from c60.cesmail.net ([216.154.195.49]:17851 "EHLO c60.cesmail.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754248AbYHFNsX (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 6 Aug 2008 09:48:23 -0400
Subject: Re: [PATCH 01/19] orinoco: Add ESSID specific scanning for Agere fw
From: Pavel Roskin <proski@gnu.org>
To: Dan Williams <dcbw@redhat.com>
Cc: kilroyd@googlemail.com, linux-wireless@vger.kernel.org,
	orinoco-devel@lists.sourceforge.net,
	David Kilroy <kilroyd@gmail.com>,
	Jean Tourrilhes <jt@hpl.hp.com>
In-Reply-To: <1218028414.16977.5.camel@localhost.localdomain>
References: <1217672073-7094-1-git-send-email-kilroyd@gmail.com>
	 <1217672073-7094-2-git-send-email-kilroyd@gmail.com>
	 <1217825304.10989.20.camel@dv>
	 <1217864060.3139.10.camel@localhost.localdomain>
	 <1217970944.2908.11.camel@dv>
	 <1217973349.30531.1.camel@localhost.localdomain>
	 <1217976491.2908.36.camel@dv>
	 <1218028414.16977.5.camel@localhost.localdomain>
Content-Type: text/plain
Date: Wed, 06 Aug 2008 09:48:05 -0400
Message-Id: <1218030485.27785.7.camel@ct> (sfid-20080806_154827_229366_656B13BA)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 2008-08-06 at 09:13 -0400, Dan Williams wrote:
> On Tue, 2008-08-05 at 18:48 -0400, Pavel Roskin wrote:
> > > Scanning for a specific SSID never has "filtered" the results, nor
> > > should it.  It just probe-scans the requested SSID and return any new
> > > results in with the cached ones.  You requested an SSID scan, thus you
> > > must know the SSID, thus you can do the filtering yourself?
> > 
> > Perhaps I used a wrong word.  If requesting a scan, I expect to get
> > results from a scan with the parameters I supplied.  If the scan results
> > are from a scan with different parameters, I don't want them.  I'd
> > rather see the driver return EAGAIN than results of a scan with
> > different parameters.
> 
> I'm not quite sure what you mean here.  You mean to say that if you
> request a specific SSID scan, and the driver does not find that SSID,
> that it should return EAGAIN?  I think that would be overloading EAGAIN
> too much, since for scans EAGAIN means "I'm not done with your scan
> request yet".

I mean, if we request a scan with some parameters, and the cached
results were received with different parameters, and real scanning is
impossible now for whatever reason, then return empty results and EAGAIN
code.

Anyway, we should have a policy for all drivers, so let's stick to that
policy.

-- 
Regards,
Pavel Roskin
