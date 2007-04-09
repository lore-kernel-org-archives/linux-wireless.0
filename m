Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([66.187.233.31]:53844 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753127AbXDIMEK (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 9 Apr 2007 08:04:10 -0400
Subject: Re: [PATCH] mac80211: Report correct wireless statistics
From: Dan Williams <dcbw@redhat.com>
To: Michael Wu <flamingice@sourmilk.net>
Cc: Larry Finger <larry.finger@lwfinger.net>,
	John Linville <linville@tuxdriver.com>,
	Michael Buesch <mb@bu3sch.de>, Bcm43xx-dev@lists.berlios.de,
	linux-wireless@vger.kernel.org, Jiri Benc <jbenc@suse.cz>
In-Reply-To: <200704090043.34436.flamingice@sourmilk.net>
References: <461877ea.cyxM3SSnr6WhYkjX%Larry.Finger@lwfinger.net>
	 <200704082031.59934.flamingice@sourmilk.net>
	 <4619B90E.1030403@lwfinger.net>
	 <200704090043.34436.flamingice@sourmilk.net>
Content-Type: text/plain
Date: Mon, 09 Apr 2007 08:07:08 -0400
Message-Id: <1176120428.2693.12.camel@localhost.localdomain>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, 2007-04-09 at 00:43 -0400, Michael Wu wrote:
> On Sunday 08 April 2007 23:54, Larry Finger wrote:
> > Why would I want to do this?
> Did it fix the output?
> 
> > If the community agrees on anything, it is 
> > that the signal is given in dBm (i.e. a negative number) and that the rssi
> > is a positive number.
> Nope. dBm doesn't have to be negative, though it often is since most wireless 
> hardware isn't that powerful. RSSI is simply a number that's bigger for 
> stronger signals. It could be dBm, but it doesn't have to be. If you want a 
> stronger definition of RSSI, look at RCPI.
> 
> > The firmware in the bcm43xx chips return a quantity 
> > that looks like an rssi with a received packet, and
> > bcm43xx_rssi_postprocess turns that into a quantity that looks like dBm.
> > Your patch reverses those designations and mixes up the two quantities.
> > Again I ask "Why"?
> >
> Because of the naming/use of the statistics in mac80211 and WE. Signal ends up 
> getting assigned to (struct iw_quality).qual, which is actually just an 
> arbitrary link quality indicator, not dBm. Anything you care about can be put 
> there. (r)ssi gets assigned to (struct iw_quality).level, which is RSSI. WE 
> allows that and noise to be specified in either arbitrary units or dBm or 
> RCPI.
> 
> Yes, I did reverse your conventions, but it makes more sense this way. (R)SSI 
> is always valid to assign to (struct iw_quality).level and signal ((struct 
> iw_quality).qual) is quite arbitrary and cannot be specified in specific 
> units.
> 
> Signal should be probably be renamed to qual to make it more clear that it is 
> arbitrary.

In WE, qual is arbitrary within a few limits:

a) qual _must_ change on a linear scale
b) a valid max_qual.qual must be set
c) qual must fall within the bounds of [0, max_qual.qual] inclusive

If you report 'level' in dBm, you must set the IW_QUAL_DBM flag.
Otherwise, 'level' _may_ be assumed to be RSSI.  If 'level' is dBm,
max_qual.level must be 0.  If 'level' is RSSI, max_qual.level must be
greater than 0, and level must fall within the bounds of [0,
max_qual.level] inclusive.  Replace 'level' with 'noise' here for the
rules for noise.

I don't particularly care if level/noise is RSSI _as long as_ you give
the max RSSI for your part.  Different radio parts have different max
RSSI values, and if you're writing a driver you sure better know them or
figure some reasonable ones out by experimentation.  RSSI is entirely
vendor defined and does _not_ conform to any rules.  Therefore we need
the max RSSI to get usable signal strength reports from your part.

I know that 0 dBm isn't actually the upper bound, but in practice most
people aren't going to get parts that go above that.  0 dBm should be
considered a _limitation_ of WEXT that we obviously fix with
cfg80211/nl80211 when we bring some sanity to signal strength reporting.

Again, if you report level in RSSI, you must provide the max RSSI for
your part in max_qual.level.

Dan


