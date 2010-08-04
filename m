Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from charlotte.tuxdriver.com ([70.61.120.58]:47466 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758637Ab0HDTom (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 4 Aug 2010 15:44:42 -0400
Date: Wed, 4 Aug 2010 15:34:42 -0400
From: "John W. Linville" <linville@tuxdriver.com>
To: Dan Williams <dcbw@redhat.com>
Cc: Johannes Berg <johannes@sipsolutions.net>,
	linux-wireless@vger.kernel.org
Subject: Re: [wt PATCH 0/5] libertas: make association work again
Message-ID: <20100804193442.GR17666@tuxdriver.com>
References: <1280470034.14523.4.camel@dcbw.foobar.com>
 <1280471706.3710.5.camel@jlt3.sipsolutions.net>
 <1280900467.2665.6.camel@dcbw.foobar.com>
 <1280907989.3768.0.camel@jlt3.sipsolutions.net>
 <1280949346.11056.1.camel@dcbw.foobar.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1280949346.11056.1.camel@dcbw.foobar.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, Aug 04, 2010 at 02:15:46PM -0500, Dan Williams wrote:
> On Wed, 2010-08-04 at 09:46 +0200, Johannes Berg wrote:
> > On Wed, 2010-08-04 at 00:41 -0500, Dan Williams wrote:
> > > On Fri, 2010-07-30 at 08:35 +0200, Johannes Berg wrote:
> > > > On Thu, 2010-07-29 at 23:07 -0700, Dan Williams wrote:
> > > > > This series makes libertas actually associate with APs after the
> > > > > cfg80211 conversion.  There was a pretty big TODO where if cfg80211
> > > > > didn't pass in the BSSID of the AP to associate with, then libertas
> > > > > would fail because the firmware really, really, really wants a BSSID.
> > > > > So lets do a scan to find that BSSID.  The other notable change is
> > > > > a fix to make sure all supported rates are included in the firmware's
> > > > > association request, lack of which caused some APs to deny the attempt.
> > > > 
> > > > I'm a bit tempted to say we could use the connect logic in cfg80211 to
> > > > provide this? cfg80211 _already_ provides this if the hardware wants
> > > > auth()/assoc() rather than connect() calls, so it seems fairly simple to
> > > > also (optionally) do it here?
> > > 
> > > Yeah, I thought about that too.  Do you want me to work on that now
> > > instead of letting this patch through?  I can revert the relevant bits
> > > of this later if that's acceptable too.
> > 
> > Either way works for me since I don't care about any cruft in
> > libertas ;)
> 
> John, if you don't mind applying this patch I'll work on generic
> scan-before-connect support in cfg80211 in a further patch series.

OK...which of these need to be in 2.6.36?

John
-- 
John W. Linville		Someday the world will need a hero, and you
linville@tuxdriver.com			might be all we have.  Be ready.
