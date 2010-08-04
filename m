Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:40243 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757036Ab0HDHpR (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 4 Aug 2010 03:45:17 -0400
Subject: Re: [wt PATCH 0/5] libertas: make association work again
From: Johannes Berg <johannes@sipsolutions.net>
To: Dan Williams <dcbw@redhat.com>
Cc: "John W. Linville" <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org
In-Reply-To: <1280900467.2665.6.camel@dcbw.foobar.com>
References: <1280470034.14523.4.camel@dcbw.foobar.com>
	 <1280471706.3710.5.camel@jlt3.sipsolutions.net>
	 <1280900467.2665.6.camel@dcbw.foobar.com>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 04 Aug 2010 09:46:29 +0200
Message-ID: <1280907989.3768.0.camel@jlt3.sipsolutions.net>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 2010-08-04 at 00:41 -0500, Dan Williams wrote:
> On Fri, 2010-07-30 at 08:35 +0200, Johannes Berg wrote:
> > On Thu, 2010-07-29 at 23:07 -0700, Dan Williams wrote:
> > > This series makes libertas actually associate with APs after the
> > > cfg80211 conversion.  There was a pretty big TODO where if cfg80211
> > > didn't pass in the BSSID of the AP to associate with, then libertas
> > > would fail because the firmware really, really, really wants a BSSID.
> > > So lets do a scan to find that BSSID.  The other notable change is
> > > a fix to make sure all supported rates are included in the firmware's
> > > association request, lack of which caused some APs to deny the attempt.
> > 
> > I'm a bit tempted to say we could use the connect logic in cfg80211 to
> > provide this? cfg80211 _already_ provides this if the hardware wants
> > auth()/assoc() rather than connect() calls, so it seems fairly simple to
> > also (optionally) do it here?
> 
> Yeah, I thought about that too.  Do you want me to work on that now
> instead of letting this patch through?  I can revert the relevant bits
> of this later if that's acceptable too.

Either way works for me since I don't care about any cruft in
libertas ;)

johannes

