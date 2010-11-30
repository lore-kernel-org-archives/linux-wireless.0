Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:51682 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752481Ab0K3OJn (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 30 Nov 2010 09:09:43 -0500
Subject: Re: Microcode SW error detected on current wireless-testing
From: Johannes Berg <johannes@sipsolutions.net>
To: Stanislaw Gruszka <sgruszka@redhat.com>
Cc: Wey-Yi Guy <wey-yi.w.guy@intel.com>,
	Intel Linux Wireless <ilw@linux.intel.com>,
	linux-wireless@vger.kernel.org
In-Reply-To: <20101130134903.GB3074@redhat.com>
References: <20101130130148.GA3074@redhat.com>
	 <1291123016.3624.17.camel@jlt3.sipsolutions.net>
	 <20101130134903.GB3074@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 30 Nov 2010 15:09:38 +0100
Message-ID: <1291126178.3624.19.camel@jlt3.sipsolutions.net>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, 2010-11-30 at 14:49 +0100, Stanislaw Gruszka wrote:

> > > iwlagn 0000:40:00.0: Microcode SW error detected.  Restarting 0x82000000.
> > > iwlagn 0000:40:00.0: Loaded firmware version: 228.61.2.24
> > 
> > > Is Intel aware of that problem? Should I bisect it?
> > 
> > I haven't seen it, but 4965 ... we can't really test that on an ongoing
> > basis any more... I'd guess dbbf1755b09eef8ff6dd21c8dafe1606f051ce12 is
> > the problem, seems the only recent thing that actually changed 4965.
> 
> Yes, it is dbbf1755, after revert that commit microcode error disappears.

Can you revert only the iwl-4965.c bit of it and try that?

johannes

