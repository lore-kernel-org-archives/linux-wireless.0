Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from ra.tuxdriver.com ([70.61.120.52]:3014 "EHLO ra.tuxdriver.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754083AbXDQNPs (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 17 Apr 2007 09:15:48 -0400
Date: Tue, 17 Apr 2007 09:12:22 -0400
From: "John W. Linville" <linville@tuxdriver.com>
To: Larry Finger <larry.finger@lwfinger.net>
Cc: Michael Buesch <mb@bu3sch.de>, Andreas Schwab <schwab@suse.de>,
	linux-wireless@vger.kernel.org, Bcm43xx-dev@lists.berlios.de
Subject: Re: [PATCH] ieee80211-crypt: Make some TKIP and CCMP error logging conditional on IEEE80211_DEBUG_DROP
Message-ID: <20070417131222.GA8633@tuxdriver.com>
References: <461a68c9.Nx0/XQSxDR1PJhM4%Larry.Finger@lwfinger.net> <jeirbwfb55.fsf@sykes.suse.de> <4623C561.4030201@lwfinger.net> <200704162237.01280.mb@bu3sch.de> <462413AE.9020200@lwfinger.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <462413AE.9020200@lwfinger.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, Apr 16, 2007 at 07:24:14PM -0500, Larry Finger wrote:
> Michael Buesch wrote:
> > On Monday 16 April 2007 20:50, Larry Finger wrote:

> >> @@ -229,6 +229,7 @@ void free_ieee80211(struct net_device *d
> >>
> >>   static int debug = 0;
> >>   u32 ieee80211_debug_level = 0;
> >> +EXPORT_SYMBOL_GPL(ieee80211_debug_level);
> > 
> > We don't use the _GPL suffix in mac80211.
> 
> Upon inspection, neither does most of ieee80211. It is now changed.

You are strongly encouraged to use the _GPL version for new symbol
exports, especially those which are fundamentally internal to
in-kernel subsystems and/or have no reasonable usage by drivers.
FWIW, this symbol would seem to fulfill both of those criteria.

If you do not object, I would prefer the _GPL version of the patch.

John
-- 
John W. Linville
linville@tuxdriver.com
