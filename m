Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from 128-177-27-249.ip.openhosting.com ([128.177.27.249]:35177 "EHLO
	jmalinen.user.openhosting.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753366AbZBRMd2 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 18 Feb 2009 07:33:28 -0500
Date: Wed, 18 Feb 2009 14:33:01 +0200
From: Jouni Malinen <j@w1.fi>
To: Dan Williams <dcbw@redhat.com>
Cc: Marcel Holtmann <marcel@holtmann.org>,
	Johannes Berg <johannes@sipsolutions.net>,
	linux-wireless@vger.kernel.org
Subject: Re: Missing link quality with wireless-testing
Message-ID: <20090218123301.GA6152@jm.kir.nu> (sfid-20090218_133406_302377_77CA0CEF)
References: <1234899806.29785.35.camel@johannes.local> <1234902294.4678.12.camel@californication> <1234904111.29785.44.camel@johannes.local> <1234904978.4678.31.camel@californication> <1234913132.11832.10.camel@70-5-246-164.pools.spcsdns.net> <1234933059.21412.28.camel@californication> <20090218073104.GA23366@jm.kir.nu> <1234944391.21412.47.camel@californication> <20090218082520.GA26280@jm.kir.nu> <1234959523.13950.47.camel@localhost>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1234959523.13950.47.camel@localhost>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, Feb 18, 2009 at 07:18:43AM -0500, Dan Williams wrote:

> With WEXT, there are three ways to calculate pretty bars.  They *all*
> require max_qual values returned from the GIWRANGE handler, because
> otherwise you have no f**king clue what the upper or lower bounds are.

> QUAL.LEVEL in dBm
> --------------
> 
> Requires:
>   - max_qual.level == 0 (ie, dBm values)

That is an area where NM (= 0) and mac80211 (= -110) do not agree.

> NM is probably fine here with qual == 0 because I doubt the GIWRANGE
> handler is returning a valid max_qual.qual > 0 anymore with Johannes'
> patch.  Could be wrong though.

Well, it is not fine, but not only for that reason.. max_qual.qual is
still set to 100 and the IW_QUAL_QUAL_INVALID is not used for it.
However, even if I set IW_QUAL_QUAL_INVALID and remove "quality" from
wpa_supplicant dbus interface, I still get NM showing perfect 100%
signal all the time regardless of how close to losing the connection the
card really is..

I gave up on trying to understand all the cases, but my assumption is
that the remaining issue is in the disagreement on max_qua.level for the
dBm case. However, I'm not sure whether fixing that would automatically
resolve the issues with wext (it might be enough for the current nl80211
version with wpa_supplicant from git head).

> Ah right; the dbus interface shouldn't be appending "quality" to the
> dict if the driver doesn't provide valid quality (ie, max_qual.updated
> has the QUAL_INVALID bit set).  Same thing for noise and level.

The unknown values are not included anymore in wpa_supplicant 0.7.x.

-- 
Jouni Malinen                                            PGP id EFC895FA
