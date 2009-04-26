Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from bu3sch.de ([62.75.166.246]:58110 "EHLO vs166246.vserver.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751629AbZDZImS (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sun, 26 Apr 2009 04:42:18 -0400
From: Michael Buesch <mb@bu3sch.de>
To: Johannes Berg <johannes@sipsolutions.net>
Subject: Re: [PATCH RFC] cfg80211: Add ies_allocated check before copying ies
Date: Sun, 26 Apr 2009 10:40:10 +0200
Cc: linux-wireless@vger.kernel.org, linville@tuxdriver.com
References: <200904252236.34802.mb@bu3sch.de> <1240734752.17781.3.camel@johannes.local>
In-Reply-To: <1240734752.17781.3.camel@johannes.local>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Message-Id: <200904261040.10838.mb@bu3sch.de> (sfid-20090426_104223_646600_498FC60A)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sunday 26 April 2009 10:32:32 Johannes Berg wrote:
> On Sat, 2009-04-25 at 22:36 +0200, Michael Buesch wrote:
> > I don't fully understand the code, but let's imagine the following situation:
> > 
> > - cfg80211_bss_update was called and the ie was stored to allocated space.
> > - The information_elements pointer is changed to the allocated space.
> > - cfg80211_bss_update is called again, but now the ie fits into the
> >   space after the "found" structure.
> > - But the information_elements pointer still points to the allocated space.
> >   So it may overrun the buffer and crash.
> > 
> > Is this scenario possible?
> > If yes, please consider the following patch.
> 
> Yeah, looks like a bug, good catch. I don't think the fix is correct
> though -- you lose the data in this case.
> 
> I think it should simply be:
> 
> >  			size_t ielen = res->pub.len_information_elements;
> >  
> > -			if (ksize(found) >= used + ielen) {
> > +			if (!found->ies_allocated && ksize(found) >= used + ielen) {
> >  				memcpy(found->pub.information_elements,
> >  				       res->pub.information_elements, ielen);
> >  				found->pub.len_information_elements = ielen;
> > 
> 
> so that the else branch gets a chance to reallocate if necessary, would
> you agree?

Yeah I first also considered this option, but I thought that the code likes to
prefer putting the stuff into the "found" tail, if it fits.
But yes, your fix is perfectly fine. If it was allocated once, it will always be
allocated (and grown) from then on.
It won't shrink the buffer anymore for future ies that are smaller, but I guess that's OK.

-- 
Greetings, Michael.
