Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([66.187.233.31]:48690 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751935AbXJVRVl (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 22 Oct 2007 13:21:41 -0400
Subject: Re: [PATCH] move wlan_*_association_work from header to c file
From: Dan Williams <dcbw@redhat.com>
To: Holger Schurig <hs4233@mail.mn-solutions.de>
Cc: linux-wireless@vger.kernel.org, libertas-dev@lists.infradead.org
In-Reply-To: <1192466593.15225.28.camel@localhost.localdomain>
References: <200710111151.06989.hs4233@mail.mn-solutions.de>
	 <200710151628.43425.hs4233@mail.mn-solutions.de>
	 <1192459352.12009.25.camel@localhost.localdomain>
	 <200710151649.26864.hs4233@mail.mn-solutions.de>
	 <1192466593.15225.28.camel@localhost.localdomain>
Content-Type: text/plain
Date: Mon, 22 Oct 2007 13:20:20 -0400
Message-Id: <1193073620.4325.7.camel@localhost.localdomain> (sfid-20071022_182144_739900_8D70519A)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, 2007-10-15 at 12:43 -0400, Dan Williams wrote:
> On Mon, 2007-10-15 at 16:49 +0200, Holger Schurig wrote:
> > > I assume you've been running it for a few days or so?
> > 
> > No. I just made this patch 6 hours ago.
> > 
> > I've used it so far only with WEP and no encryption at all, 
> > always as STA (no ad-hoc, no wpa-supplicant).
> > 
> > After all, the patch was created using "perl -pi -e" :-)
> > 
> > 
> > So far I found two quirks:
> > 
> > a) it's no longer /lib/modules/libertas/parameters/libertas_debug 
> > but /lib/modules/libertas/parameters/lbs_debug. As this is an 
> > ABI change, we might not want it.
> 
> Should keep ABI compat here.
> 
> > b) it's no longer <debugfs>/libertas_wireless/XXXX but 
> > <debugfs>/lbs_wireless/XXXX. Also an ABI change.
> 
> Should keep ABI compat here.
> 
> > 
> > I could make a "take 2" patch, but because of the size of the 
> > patch and the hassle to export it in an external git tree I'd 
> > rather create a fixup patch. But let's see what you un-earth.
> 
> Yeah, I'll keep looking through it.

So, I think the debugfs thing is fine to keep in sync with the driver
prefix.  But for now, lets keep the module name the same.  Can you
repost (with a link since it's so huge)?

I ran the driver for a while and nothing appears to have regressed
horribly from light testing a few large transfers.  Seems OK to push
into 2.6.25 to me.

Dan

