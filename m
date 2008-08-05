Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from c60.cesmail.net ([216.154.195.49]:14791 "EHLO c60.cesmail.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755373AbYHEWsN (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 5 Aug 2008 18:48:13 -0400
Subject: Re: [PATCH 01/19] orinoco: Add ESSID specific scanning for Agere fw
From: Pavel Roskin <proski@gnu.org>
To: Dan Williams <dcbw@redhat.com>
Cc: kilroyd@googlemail.com, linux-wireless@vger.kernel.org,
	orinoco-devel@lists.sourceforge.net,
	David Kilroy <kilroyd@gmail.com>,
	Jean Tourrilhes <jt@hpl.hp.com>
In-Reply-To: <1217973349.30531.1.camel@localhost.localdomain>
References: <1217672073-7094-1-git-send-email-kilroyd@gmail.com>
	 <1217672073-7094-2-git-send-email-kilroyd@gmail.com>
	 <1217825304.10989.20.camel@dv>
	 <1217864060.3139.10.camel@localhost.localdomain>
	 <1217970944.2908.11.camel@dv>
	 <1217973349.30531.1.camel@localhost.localdomain>
Content-Type: text/plain
Date: Tue, 05 Aug 2008 18:48:11 -0400
Message-Id: <1217976491.2908.36.camel@dv> (sfid-20080806_004818_377674_813EB53D)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, 2008-08-05 at 17:55 -0400, Dan Williams wrote:
> On Tue, 2008-08-05 at 17:15 -0400, Pavel Roskin wrote:

> > If I use 32-bit kernel with 32-bit userspace, essid filtering works, but
> > only to a degree.  Old scan results are cached somewhere, so if I scan
> > with essid and then without essid, I get filtered results.  Likewise, If
> > I don't use filtering the first time, but use it the second time, I get
> > unfiltered results.
> 
> Scanning for a specific SSID never has "filtered" the results, nor
> should it.  It just probe-scans the requested SSID and return any new
> results in with the cached ones.  You requested an SSID scan, thus you
> must know the SSID, thus you can do the filtering yourself?

Perhaps I used a wrong word.  If requesting a scan, I expect to get
results from a scan with the parameters I supplied.  If the scan results
are from a scan with different parameters, I don't want them.  I'd
rather see the driver return EAGAIN than results of a scan with
different parameters.

The userspace is welcome to keep a pool of all APs found by any scans,
but I don't think drivers should do it.

I believe it was discussed before.  If there was any decision how we
want drivers to behave, let's stick with it.

-- 
Regards,
Pavel Roskin
