Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([66.187.233.31]:55219 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750870AbXLDRQm (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 4 Dec 2007 12:16:42 -0500
Subject: Re: questions regarding removing the depencency on CONFIG_IEEE80211
From: Dan Williams <dcbw@redhat.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: "John W. Linville" <linville@tuxdriver.com>,
	Holger Schurig <hs4233@mail.mn-solutions.de>,
	linux-wireless@vger.kernel.org
In-Reply-To: <1196787568.10274.26.camel@johannes.berg>
References: <200712041140.07516.hs4233@mail.mn-solutions.de>
	 <200712041153.24896.hs4233@mail.mn-solutions.de>
	 <1196780198.26155.17.camel@localhost.localdomain>
	 <20071204152538.GF19911@tuxdriver.com>
	 <1196782188.26155.49.camel@localhost.localdomain>
	 (sfid-20071204_153556_825699_9BDA6661)  <1196787568.10274.26.camel@johannes.berg>
Content-Type: text/plain
Date: Tue, 04 Dec 2007 12:10:19 -0500
Message-Id: <1196788219.7894.3.camel@localhost.localdomain> (sfid-20071204_171646_455336_AB0ED1D2)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, 2007-12-04 at 17:59 +0100, Johannes Berg wrote:
> > I was thinking about lib80211 this morning too; specifically the code
> > that everyone has to write to convert local BSS entries into WEXT scan
> > results.  The problem is that drivers have different ideas of what a BSS
> > is.  I think the _first_ thing to do is to define a BSS structure (I
> > used the ipw2x00 bss structure in libertas when doing this) that all the
> > fullmac drivers can use (airo, atmel, libertas, orinoco, etc).  Then,
> > each driver can fill out that structure from it's internal scan result,
> > and hand that off to the lib80211 bss list handling code.  We could have
> > a help that these driver's get_scan calls to convert the internal list
> > into WEXT scan results.  The important thing is getting these drivers to
> > fill out the common bss structure when their firmware returns a scan
> > result.  We could even make the lib80211 code handle scan result aging
> > internally.  Could have helper functions to allocate and dispose of the
> > bss list instead of having to duplicate that code in every driver (it's
> > already in airo & libertas, and I posted a patch that dupes it again for
> > orinoco).
> 
> Sounds good though I think this in particular is cfg80211 functionality
> because over time that will want to export scan results via nl80211 too.

Good point; that might be a great way to move forward and start getting
cfg80211 functionality into the fullmac drivers.

Dan


