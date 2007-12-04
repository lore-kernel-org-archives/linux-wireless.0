Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([66.187.233.31]:50971 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752889AbXLDPfx (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 4 Dec 2007 10:35:53 -0500
Subject: Re: questions regarding removing the depencency on CONFIG_IEEE80211
From: Dan Williams <dcbw@redhat.com>
To: "John W. Linville" <linville@tuxdriver.com>
Cc: Holger Schurig <hs4233@mail.mn-solutions.de>,
	linux-wireless@vger.kernel.org
In-Reply-To: <20071204152538.GF19911@tuxdriver.com>
References: <200712041140.07516.hs4233@mail.mn-solutions.de>
	 <200712041153.24896.hs4233@mail.mn-solutions.de>
	 <1196780198.26155.17.camel@localhost.localdomain>
	 <20071204152538.GF19911@tuxdriver.com>
Content-Type: text/plain
Date: Tue, 04 Dec 2007 10:29:48 -0500
Message-Id: <1196782188.26155.49.camel@localhost.localdomain> (sfid-20071204_153556_825699_9BDA6661)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, 2007-12-04 at 10:25 -0500, John W. Linville wrote:
> On Tue, Dec 04, 2007 at 09:56:38AM -0500, Dan Williams wrote:
> > On Tue, 2007-12-04 at 11:53 +0100, Holger Schurig wrote:
> > > 7. escape_ssid()
> > > 
> > > This code from ieee80211 is used in various debug messages.
> > > Should I re-implement this locally in the driver?
> > 
> > Part of the _point_ of depending on ieee80211 was so that we wouldn't
> > have a lot of pointless code duplication.  Like this.
> 
> ACK
> 
> We've been talking about a new component for this kind of
> shared generic 802.11 code for some time.  In my head I call it
> "lib80211". :-)
> 
> Maybe it is time to start it?  The header of a thousand bytes start
> with a single char... :-)

I was thinking about lib80211 this morning too; specifically the code
that everyone has to write to convert local BSS entries into WEXT scan
results.  The problem is that drivers have different ideas of what a BSS
is.  I think the _first_ thing to do is to define a BSS structure (I
used the ipw2x00 bss structure in libertas when doing this) that all the
fullmac drivers can use (airo, atmel, libertas, orinoco, etc).  Then,
each driver can fill out that structure from it's internal scan result,
and hand that off to the lib80211 bss list handling code.  We could have
a help that these driver's get_scan calls to convert the internal list
into WEXT scan results.  The important thing is getting these drivers to
fill out the common bss structure when their firmware returns a scan
result.  We could even make the lib80211 code handle scan result aging
internally.  Could have helper functions to allocate and dispose of the
bss list instead of having to duplicate that code in every driver (it's
already in airo & libertas, and I posted a patch that dupes it again for
orinoco).

It might mean more memory usage for these drivers because not all of
them need all the fields in the common BSS structure.  It may mean
slightly more CPU time used to convert the driver's internal BSS
representation into the common BSS structure.  But that is pretty small
in both cases and I think the benefits outweigh the drawbacks in this
regard.

Each fullmac driver right now is it's own little box, with quite a lot
of duplicated code floating around.  We need to start replacing that
duplicated code/functionality with common stuff for maintainability and
sanity :)

Dan


