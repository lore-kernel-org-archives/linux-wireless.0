Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:32491 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754117Ab0HER0e (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 5 Aug 2010 13:26:34 -0400
Subject: Re: [wt PATCH 0/5] libertas: make association work again
From: Dan Williams <dcbw@redhat.com>
To: "John W. Linville" <linville@tuxdriver.com>
Cc: Johannes Berg <johannes@sipsolutions.net>,
	linux-wireless@vger.kernel.org
In-Reply-To: <20100804193442.GR17666@tuxdriver.com>
References: <1280470034.14523.4.camel@dcbw.foobar.com>
	 <1280471706.3710.5.camel@jlt3.sipsolutions.net>
	 <1280900467.2665.6.camel@dcbw.foobar.com>
	 <1280907989.3768.0.camel@jlt3.sipsolutions.net>
	 <1280949346.11056.1.camel@dcbw.foobar.com>
	 <20100804193442.GR17666@tuxdriver.com>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 05 Aug 2010 12:27:50 -0500
Message-ID: <1281029270.32607.2.camel@dcbw.foobar.com>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 2010-08-04 at 15:34 -0400, John W. Linville wrote:
> On Wed, Aug 04, 2010 at 02:15:46PM -0500, Dan Williams wrote:
> > On Wed, 2010-08-04 at 09:46 +0200, Johannes Berg wrote:
> > > On Wed, 2010-08-04 at 00:41 -0500, Dan Williams wrote:
> > > > On Fri, 2010-07-30 at 08:35 +0200, Johannes Berg wrote:
> > > > > On Thu, 2010-07-29 at 23:07 -0700, Dan Williams wrote:
> > > > > > This series makes libertas actually associate with APs after the
> > > > > > cfg80211 conversion.  There was a pretty big TODO where if cfg80211
> > > > > > didn't pass in the BSSID of the AP to associate with, then libertas
> > > > > > would fail because the firmware really, really, really wants a BSSID.
> > > > > > So lets do a scan to find that BSSID.  The other notable change is
> > > > > > a fix to make sure all supported rates are included in the firmware's
> > > > > > association request, lack of which caused some APs to deny the attempt.
> > > > > 
> > > > > I'm a bit tempted to say we could use the connect logic in cfg80211 to
> > > > > provide this? cfg80211 _already_ provides this if the hardware wants
> > > > > auth()/assoc() rather than connect() calls, so it seems fairly simple to
> > > > > also (optionally) do it here?
> > > > 
> > > > Yeah, I thought about that too.  Do you want me to work on that now
> > > > instead of letting this patch through?  I can revert the relevant bits
> > > > of this later if that's acceptable too.
> > > 
> > > Either way works for me since I don't care about any cruft in
> > > libertas ;)
> > 
> > John, if you don't mind applying this patch I'll work on generic
> > scan-before-connect support in cfg80211 in a further patch series.
> 
> OK...which of these need to be in 2.6.36?

They should stick with the libertas cfg80211 bits, wherever they are.
If you've pushed whatever was in wireless-testing into 2.6.36, then this
latest series of 5 should go there too.

Dan

