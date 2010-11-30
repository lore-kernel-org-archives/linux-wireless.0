Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:12972 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752479Ab0K3NtS (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 30 Nov 2010 08:49:18 -0500
Date: Tue, 30 Nov 2010 14:49:04 +0100
From: Stanislaw Gruszka <sgruszka@redhat.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: Wey-Yi Guy <wey-yi.w.guy@intel.com>,
	Intel Linux Wireless <ilw@linux.intel.com>,
	linux-wireless@vger.kernel.org
Subject: Re: Microcode SW error detected on current wireless-testing
Message-ID: <20101130134903.GB3074@redhat.com>
References: <20101130130148.GA3074@redhat.com>
 <1291123016.3624.17.camel@jlt3.sipsolutions.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1291123016.3624.17.camel@jlt3.sipsolutions.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, Nov 30, 2010 at 02:16:56PM +0100, Johannes Berg wrote:
> On Tue, 2010-11-30 at 14:01 +0100, Stanislaw Gruszka wrote:
> > Hi
> > 
> > Today pull on wireless testing caused this on my 4965 device (100%
> > reproducible on my system, yesterday w-t does not have this).
> > 
> > iwlagn 0000:40:00.0: Microcode SW error detected.  Restarting 0x82000000.
> > iwlagn 0000:40:00.0: Loaded firmware version: 228.61.2.24
> 
> > Is Intel aware of that problem? Should I bisect it?
> 
> I haven't seen it, but 4965 ... we can't really test that on an ongoing
> basis any more... I'd guess dbbf1755b09eef8ff6dd21c8dafe1606f051ce12 is
> the problem, seems the only recent thing that actually changed 4965.

Yes, it is dbbf1755, after revert that commit microcode error disappears.

Stanislaw
