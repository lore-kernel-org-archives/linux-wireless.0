Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([66.187.233.31]:55292 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1030283AbXDQOWF (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 17 Apr 2007 10:22:05 -0400
Subject: Re: [PATCH] ieee80211-crypt: Make some TKIP and CCMP error logging  conditional on IEEE80211_DEBUG_DROP
From: Dan Williams <dcbw@redhat.com>
To: "John W. Linville" <linville@tuxdriver.com>
Cc: Larry Finger <larry.finger@lwfinger.net>,
	Michael Buesch <mb@bu3sch.de>, Andreas Schwab <schwab@suse.de>,
	linux-wireless@vger.kernel.org, Bcm43xx-dev@lists.berlios.de
In-Reply-To: <20070417131222.GA8633@tuxdriver.com>
References: <461a68c9.Nx0/XQSxDR1PJhM4%Larry.Finger@lwfinger.net>
	 <jeirbwfb55.fsf@sykes.suse.de> <4623C561.4030201@lwfinger.net>
	 <200704162237.01280.mb@bu3sch.de> <462413AE.9020200@lwfinger.net>
	 <20070417131222.GA8633@tuxdriver.com>
Content-Type: text/plain
Date: Tue, 17 Apr 2007 10:25:08 -0400
Message-Id: <1176819909.26202.33.camel@localhost.localdomain>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, 2007-04-17 at 09:12 -0400, John W. Linville wrote:
> On Mon, Apr 16, 2007 at 07:24:14PM -0500, Larry Finger wrote:
> > Michael Buesch wrote:
> > > On Monday 16 April 2007 20:50, Larry Finger wrote:
> 
> > >> @@ -229,6 +229,7 @@ void free_ieee80211(struct net_device *d
> > >>
> > >>   static int debug = 0;
> > >>   u32 ieee80211_debug_level = 0;
> > >> +EXPORT_SYMBOL_GPL(ieee80211_debug_level);
> > > 
> > > We don't use the _GPL suffix in mac80211.
> > 
> > Upon inspection, neither does most of ieee80211. It is now changed.
> 
> You are strongly encouraged to use the _GPL version for new symbol
> exports, especially those which are fundamentally internal to
> in-kernel subsystems and/or have no reasonable usage by drivers.
> FWIW, this symbol would seem to fulfill both of those criteria.
> 
> If you do not object, I would prefer the _GPL version of the patch.

What's the rationale for mac80211 _not_ using _GPL exports? I thought
most new exports were pretty much required to be _GPL (otherwise
somebody would NAK it) unless it was really, really necessary that they
weren't.

Dan


