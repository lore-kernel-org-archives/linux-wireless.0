Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from dhost002-1.dex002.intermedia.net ([64.78.21.6]:43078 "EHLO
	dhost002-1.dex002.intermedia.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755399AbXFHO5j (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 8 Jun 2007 10:57:39 -0400
From: "Jouni Malinen" <jkm@devicescape.com>
Date: Fri, 8 Jun 2007 07:58:21 -0700
To: Jiri Benc <jbenc@suse.cz>
Cc: Michael Wu <flamingice@sourmilk.net>,
	Larry Finger <larry.finger@lwfinger.net>,
	linux-wireless@vger.kernel.org
Subject: Re: [PATCH V3] mac80211: Set low initial rate in rc80211_simple
Message-ID: <20070608145821.GD14078@devicescape.com>
References: <200706072205.27902.flamingice@sourmilk.net> <20070608112146.2df3608c@griffin.suse.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20070608112146.2df3608c@griffin.suse.cz>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, Jun 08, 2007 at 11:21:46AM +0200, Jiri Benc wrote:
> On Thu, 7 Jun 2007 22:05:21 -0700, Michael Wu wrote:
> > On Thursday 07 June 2007 20:49, Larry Finger wrote:
> > > Does mode->rates[0].flags automatically have IEEE80211_RATE_SUPPORTED set?
> > > That wasn't clear to me.
> > >
> > Yes. (see ieee80211_prepare_rates)
> 
> No :-) In theory, you can use PRISM2_HOSTAPD_SET_RATE_SETS ioctl to
> disable the lowest available rate. Yes, that's deprecated and bad thing
> to do; but unfortunately, it can be done with the current code.

There are some odd cases, where disabling the lowest supported rate may
even be required due to regulatory rules.. Regardless of whether it is
considered bad thing or not in general, I would hope that this
functionality remains and all rate control algorithms prepare to handle
such an anomaly.

> Larry's patch is IMHO correct.

Agreed.

-- 
Jouni Malinen                                            PGP id EFC895FA
