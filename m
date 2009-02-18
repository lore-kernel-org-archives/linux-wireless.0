Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx2.redhat.com ([66.187.237.31]:54278 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751925AbZBRNWk (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 18 Feb 2009 08:22:40 -0500
Subject: Re: Missing link quality with wireless-testing
From: Dan Williams <dcbw@redhat.com>
To: Jouni Malinen <j@w1.fi>
Cc: Marcel Holtmann <marcel@holtmann.org>,
	Johannes Berg <johannes@sipsolutions.net>,
	linux-wireless@vger.kernel.org
In-Reply-To: <1234961297.13950.55.camel@localhost>
References: <1234899806.29785.35.camel@johannes.local>
	 <1234902294.4678.12.camel@californication>
	 <1234904111.29785.44.camel@johannes.local>
	 <1234904978.4678.31.camel@californication>
	 <1234913132.11832.10.camel@70-5-246-164.pools.spcsdns.net>
	 <1234933059.21412.28.camel@californication>
	 <20090218073104.GA23366@jm.kir.nu>
	 <1234944391.21412.47.camel@californication>
	 <20090218082520.GA26280@jm.kir.nu> <1234959523.13950.47.camel@localhost>
	 <20090218123301.GA6152@jm.kir.nu>  <1234961297.13950.55.camel@localhost>
Content-Type: text/plain
Date: Wed, 18 Feb 2009 08:20:53 -0500
Message-Id: <1234963253.13950.68.camel@localhost> (sfid-20090218_142244_301617_990B7BE3)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 2009-02-18 at 07:48 -0500, Dan Williams wrote:
> On Wed, 2009-02-18 at 14:33 +0200, Jouni Malinen wrote:
> > On Wed, Feb 18, 2009 at 07:18:43AM -0500, Dan Williams wrote:
> > 
> > > With WEXT, there are three ways to calculate pretty bars.  They *all*
> > > require max_qual values returned from the GIWRANGE handler, because
> > > otherwise you have no f**king clue what the upper or lower bounds are.
> > 
> > > QUAL.LEVEL in dBm
> > > --------------
> > > 
> > > Requires:
> > >   - max_qual.level == 0 (ie, dBm values)
> > 
> > That is an area where NM (= 0) and mac80211 (= -110) do not agree.
> 
> Then mac80211 is not conforming to WEXT...  unless it's setting
> IW_QUAL_DBM in the updated field, which it probably is.
> 
> Before we added IW_QUAL_DBM, the switch between dBm and RSSI was
> max_qual.level; if it was 0, level was in dBm, because no cards in use
> in Linux at that time could support a signal of more 0 dBm.  Thus, if it
> was over 0, the value was in RSSI.
> 
> Here's the relevant bit of wireless.h:
> 
>         /* Quality range (link, level, noise)
>          * If the quality is absolute, it will be in the range [0 ; max_qual],
>          * if the quality is dBm, it will be in the range [max_qual ; 0].
> 
> That doc never got updated for IW_QUAL_DBM either.

And yeah, the NM method isn't entirely consistent with this comment in
wext.h either; however, it's pretty unclear how to actually figure out
from max_qual whether the driver is reporting absolute or dBm unless you
use IW_QUAL_DBM.

Dan

> > > NM is probably fine here with qual == 0 because I doubt the GIWRANGE
> > > handler is returning a valid max_qual.qual > 0 anymore with Johannes'
> > > patch.  Could be wrong though.
> > 
> > Well, it is not fine, but not only for that reason.. max_qual.qual is
> > still set to 100 and the IW_QUAL_QUAL_INVALID is not used for it.
> > However, even if I set IW_QUAL_QUAL_INVALID and remove "quality" from
> > wpa_supplicant dbus interface, I still get NM showing perfect 100%
> > signal all the time regardless of how close to losing the connection the
> > card really is..
> > 
> > I gave up on trying to understand all the cases, but my assumption is
> > that the remaining issue is in the disagreement on max_qua.level for the
> > dBm case. However, I'm not sure whether fixing that would automatically
> > resolve the issues with wext (it might be enough for the current nl80211
> > version with wpa_supplicant from git head).
> 
> NM doesn't really handle IW_QUAL_DBM (added in WE-19).  Mainly because
> stuff worked without it, and it wasn't implemented in drivers until
> quite recently.  NM should handle IW_QUAL_DBM.
> 
> > > Ah right; the dbus interface shouldn't be appending "quality" to the
> > > dict if the driver doesn't provide valid quality (ie, max_qual.updated
> > > has the QUAL_INVALID bit set).  Same thing for noise and level.
> > 
> > The unknown values are not included anymore in wpa_supplicant 0.7.x.
> 
> Just pulled; it doesn't show up in master.  Do you have a separate git
> repo for 0.7.x?
> 
> Dan
> 
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-wireless" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

