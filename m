Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx2.redhat.com ([66.187.237.31]:37337 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750974AbZBVPej (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sun, 22 Feb 2009 10:34:39 -0500
Subject: Re: Signal quality strange since commit 708c57cf1709fb95
From: Dan Williams <dcbw@redhat.com>
To: Larry Finger <Larry.Finger@lwfinger.net>
Cc: John Linville <linville@tuxdriver.com>,
	Johannes Berg <johannes@sipsolutions.net>,
	wireless <linux-wireless@vger.kernel.org>
In-Reply-To: <49A05E35.70904@lwfinger.net>
References: <49A01922.1090106@lwfinger.net>
	 <1235241867.3284.44.camel@localhost>  <49A05E35.70904@lwfinger.net>
Content-Type: text/plain
Date: Sun, 22 Feb 2009 10:32:52 -0500
Message-Id: <1235316773.28069.6.camel@localhost> (sfid-20090222_163442_284249_F9B80BEB)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sat, 2009-02-21 at 14:04 -0600, Larry Finger wrote:
> Dan Williams wrote:
> > On Sat, 2009-02-21 at 09:09 -0600, Larry Finger wrote:
> >> I admit that I didn't follow the discussion of reporting signal quality very
> >> closely; however since commit 708c57cf1709fb95, all of my wireless devices (b43,
> >> p54usb, rtl8187) are reporting link quality as XX/70 rather than XX/100. I doubt
> >> that this was an intended consequence of that patch. If the SIOCGIWRANGE ioctl
> >> is now more correct, what changes are needed in the drivers to restore the old
> >> behavior? Having written the qual calculation for 2 drivers, I understand the
> >> uselessness of this number, but I also know the uproar such a change will cause
> >> in the user community.
> > 
> > Intended.  It doesn't matter what the /X number is; it's simply the
> > upper bound of what the # before the / will be.  Quality is in the range
> > of [0 ... max_qual.qual].  You should be able to divide quality /
> > max_qual.qual and get a reasonable number to use for pretty UI display.
> > 
> > Many drivers used to use something other than 100 for max quality, and
> > many still do:
> > 
> > airo.c:		range->max_qual.qual = airo_get_max_quality(&cap_rid);
> > hostap/hostap_ioctl.c:		range->max_qual.qual = 70; /* what is correct max? This was not
> > hostap/hostap_ioctl.c:		range->max_qual.qual = 92; /* 0 .. 92 */
> > netwave_cs.c:	range->max_qual.qual = 255;
> > orinoco/wext.c:		range->max_qual.qual = 0x8b - 0x2f;
> > wavelan.c:	range->max_qual.qual = MMR_SGNL_QUAL;
> > wavelan_cs.c:	range->max_qual.qual = MMR_SGNL_QUAL;
> > zd1201.c:	range->max_qual.qual = 128;
> 
> I know how it works with drivers that implement their own ioctl calls for the
> WEXT interface; however, the 3 that I mentioned all use mac80211 and get their
> WEXT support through cfg80211.

It's not really relevant what mac80211/cfg80211 uses for max_qual.qual.
What's relevant is that the calculation that the driver/stack makes for
quality is appropriate for the max_qual.qual.  Again, it doesn't matter
what the /XX number is, as long as you can take YY/XX and get something
between 0 and 100 (inclusive) that changes on a linear scale and is
usable for a generic "signal strength %" measure.

Dan


