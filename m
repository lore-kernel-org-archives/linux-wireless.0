Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.atheros.com ([12.36.123.2]:23537 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754516AbYLVPzp (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 22 Dec 2008 10:55:45 -0500
Received: from mail.atheros.com ([10.10.20.108])
	by sidewinder.atheros.com
	for <linux-wireless@vger.kernel.org>; Mon, 22 Dec 2008 07:55:45 -0800
Date: Mon, 22 Dec 2008 07:55:38 -0800
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
To: Christian Lamparter <chunkeey@web.de>
CC: wireless <linux-wireless@vger.kernel.org>,
	Johannes Berg <johannes@sipsolutions.net>,
	"Luis R. Rodriguez" <mcgrof@gmail.com>
Subject: Re: [RFC/RFT] p54: regulatory domain hint
Message-ID: <20081222155538.GE11083@tesla> (sfid-20081222_165550_792915_B1187D4E)
References: <200812212336.31267.chunkeey@web.de>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
In-Reply-To: <200812212336.31267.chunkeey@web.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sun, Dec 21, 2008 at 02:36:30PM -0800, Christian Lamparter wrote:
> This patch adds a sub-routine that parses the default country eeprom entry
> and forwards the obtained Alpha2 identifier to the regulatory sub-system.
> 
> Luis,
> 
> I've a question about the regulatory domain numbers. (ref: 802.11-2007 14.8.2.2)
> As far as I can see zd1211rw driver (zd_mac.c) uses them to determine the country as well.
> So, how should I/we deal with this?

Since two drivers are using the same maps I'd say go ahead and consolidate the maps.
Keep in mind that 802.11-2007 14.8.2.2 is not complete and for the rest of the countries
vendors have used different values. Special values like 0x41 maybe be standard amongst a
few vendors but then what alpha2 do we map this to? Do we make an exception, create a J2
in the regulatory db? I'd be inclined that we only add special codes for things for which
we are sure we can be used in a country. An alternative is to use the reg_notifier() in
those drivers so that if 0x41 was used, after cfg80211 is done updating the channels we
can override the settings and disable channel 14. ETSI is another special case -- are we
OK to always use "DE" for it?

> Would you support a common helper function with a fixed list - like the one in zd_mac.c (or in this patch) -
> which takes regDomain values and converts them into alpha2?

That seems to make sense since > 1 driver is using it. In fact I think bcm can use this too?

I know ath5k/ath9k can use it too but we have a lot more country codes too so we will need a
larger map table for all the other values. We can probably still make use of it in ath5k/ath9k
and if there is no match then use our internal table for a larger set.

> Or do you have a secret plan instead?

Heh why would it be secret?

  Luis
