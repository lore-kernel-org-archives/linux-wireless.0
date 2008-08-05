Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([66.187.233.31]:41944 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750929AbYHEV6w (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 5 Aug 2008 17:58:52 -0400
Subject: Re: [PATCH 01/19] orinoco: Add ESSID specific scanning for Agere fw
From: Dan Williams <dcbw@redhat.com>
To: Pavel Roskin <proski@gnu.org>
Cc: kilroyd@googlemail.com, linux-wireless@vger.kernel.org,
	orinoco-devel@lists.sourceforge.net,
	David Kilroy <kilroyd@gmail.com>,
	Jean Tourrilhes <jt@hpl.hp.com>
In-Reply-To: <1217970944.2908.11.camel@dv>
References: <1217672073-7094-1-git-send-email-kilroyd@gmail.com>
	 <1217672073-7094-2-git-send-email-kilroyd@gmail.com>
	 <1217825304.10989.20.camel@dv>
	 <1217864060.3139.10.camel@localhost.localdomain>
	 <1217970944.2908.11.camel@dv>
Content-Type: text/plain
Date: Tue, 05 Aug 2008 17:55:49 -0400
Message-Id: <1217973349.30531.1.camel@localhost.localdomain> (sfid-20080805_235855_026403_94C2D41A)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, 2008-08-05 at 17:15 -0400, Pavel Roskin wrote:
> On Mon, 2008-08-04 at 11:34 -0400, Dan Williams wrote:
> 
> > Maybe the wireless-tools breakage you're experiencing is causing this to
> > fail on x86-64?  Are you using 64-bit wireless-tools and a 64-bit
> > kernel, or 32-bit wireless tools with a 64-bit kernel?
> 
> I'm using 64-bit kernel with 64-bit userspace.
> 
> If I use 32-bit kernel with 32-bit userspace, essid filtering works, but
> only to a degree.  Old scan results are cached somewhere, so if I scan
> with essid and then without essid, I get filtered results.  Likewise, If
> I don't use filtering the first time, but use it the second time, I get
> unfiltered results.

Scanning for a specific SSID never has "filtered" the results, nor
should it.  It just probe-scans the requested SSID and return any new
results in with the cached ones.  You requested an SSID scan, thus you
must know the SSID, thus you can do the filtering yourself?

Dan


