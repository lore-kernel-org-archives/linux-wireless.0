Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx2.redhat.com ([66.187.237.31]:52835 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751479AbZBRMUp (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 18 Feb 2009 07:20:45 -0500
Subject: Re: Missing link quality with wireless-testing
From: Dan Williams <dcbw@redhat.com>
To: Jouni Malinen <j@w1.fi>
Cc: Marcel Holtmann <marcel@holtmann.org>,
	Johannes Berg <johannes@sipsolutions.net>,
	linux-wireless@vger.kernel.org
In-Reply-To: <20090218082520.GA26280@jm.kir.nu>
References: <1234896777.4678.7.camel@californication>
	 <1234899806.29785.35.camel@johannes.local>
	 <1234902294.4678.12.camel@californication>
	 <1234904111.29785.44.camel@johannes.local>
	 <1234904978.4678.31.camel@californication>
	 <1234913132.11832.10.camel@70-5-246-164.pools.spcsdns.net>
	 <1234933059.21412.28.camel@californication>
	 <20090218073104.GA23366@jm.kir.nu>
	 <1234944391.21412.47.camel@californication>
	 <20090218082520.GA26280@jm.kir.nu>
Content-Type: text/plain
Date: Wed, 18 Feb 2009 07:18:43 -0500
Message-Id: <1234959523.13950.47.camel@localhost> (sfid-20090218_132052_960524_888C1F9B)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 2009-02-18 at 10:25 +0200, Jouni Malinen wrote:
> On Wed, Feb 18, 2009 at 09:06:31AM +0100, Marcel Holtmann wrote:
> 
> > so it seems the missing value is affecting the details wpa_supplicant is
> > handing out via its D-Bus interface. I didn't check the code yet to see
> > what is actually happening or if I just happen to run an outdated
> > version.
> 
> Yes, it looks like the dbus interface will get all three wext values
> (quality, noise, level) regardless of whether they were available from
> kernel or not. This does not cause any issues for wpa_supplicant, but if
> other programs (e.g., NM) are using the "quality" value in preference to
> "level", they would be processing zeros for all BSSes. If I understood
> correctly, NM does indeed prefer to use "quality", so this will likely
> explain why you are seeing different behavior with the qual->qual value
> removed (= 0 for wpa_supplicant).
> 
> I don't know how NM would react to the "quality" value being removed,
> but it would sound reasonable to do that in wpa_supplicant (and same for

With WEXT, there are three ways to calculate pretty bars.  They *all*
require max_qual values returned from the GIWRANGE handler, because
otherwise you have no f**king clue what the upper or lower bounds are.

QUAL.QUAL
--------------

Requires:
  - max_qual.qual > 0
  - !(max_qual.updated & IW_QUAL_QUAL_INVALID)
  - !(qual.updated & IW_QUAL_QUAL_INVALID)

pct = 100 * (qual.qual / max_qual.qual)


QUAL.LEVEL in dBm
--------------

Requires:
  - max_qual.level == 0 (ie, dBm values)
  - !(max_qual.updated & IW_QUAL_LEVEL_INVALID)
  - !(qual.updated & IW_QUAL_LEVEL_INVALID)
  - (max_qual.noise > 0) && !(max_qual.updated & IW_QUAL_NOISE_INVALID)
      OR
    (qual.noise > 0) && !(qual.updated & IW_QUAL_NOISE_INVALID)

pct = (clamp driver values between -90 dBm and -20 dBm, then some voodoo)


QUAL.LEVEL in RSSI
--------------

Requires:
  - max_qual.level != 0
  - !(max_qual.updated & IW_QUAL_LEVEL_INVALID)
  - !(qual.updated & IW_QUAL_LEVEL_INVALID)

pct = 100 * (qual.level / max_qual.level)


Anyone think all this stuff really, really sucks?  Yes!!!  So lets just
have drivers/stack provide a few sane values that userspace really
doesn't have to go through this shit to calculate...

<rant ends>

NM is probably fine here with qual == 0 because I doubt the GIWRANGE
handler is returning a valid max_qual.qual > 0 anymore with Johannes'
patch.  Could be wrong though.

> "noise") if the value was not available from the driver (based on the
> WEXT flags or in case of nl80211, just based on the fact that these
> values are never reported). I would expect this change to go in shortly
> (assuming it does not trigger any critical issue with NM), but anyway,
> this does not help with old versions.

Ah right; the dbus interface shouldn't be appending "quality" to the
dict if the driver doesn't provide valid quality (ie, max_qual.updated
has the QUAL_INVALID bit set).  Same thing for noise and level.

Dan


