Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mtiwmhc12.worldnet.att.net ([204.127.131.116]:35940 "EHLO
	mtiwmhc12.worldnet.att.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S965854AbXDIPsi (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 9 Apr 2007 11:48:38 -0400
Message-ID: <461A6092.20701@lwfinger.net>
Date: Mon, 09 Apr 2007 10:49:38 -0500
From: Larry Finger <larry.finger@lwfinger.net>
MIME-Version: 1.0
To: Dan Williams <dcbw@redhat.com>
CC: Michael Wu <flamingice@sourmilk.net>,
	John Linville <linville@tuxdriver.com>,
	Michael Buesch <mb@bu3sch.de>, Bcm43xx-dev@lists.berlios.de,
	linux-wireless@vger.kernel.org, Jiri Benc <jbenc@suse.cz>
Subject: Re: [PATCH] mac80211: Report correct wireless statistics
References: <461877ea.cyxM3SSnr6WhYkjX%Larry.Finger@lwfinger.net>	 <200704082031.59934.flamingice@sourmilk.net>	 <4619B90E.1030403@lwfinger.net>	 <200704090043.34436.flamingice@sourmilk.net> <1176120428.2693.12.camel@localhost.localdomain>
In-Reply-To: <1176120428.2693.12.camel@localhost.localdomain>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Dan Williams wrote:
> On Mon, 2007-04-09 at 00:43 -0400, Michael Wu wrote:
>> Yes, I did reverse your conventions, but it makes more sense this way. (R)SSI 
>> is always valid to assign to (struct iw_quality).level and signal ((struct 
>> iw_quality).qual) is quite arbitrary and cannot be specified in specific 
>> units.
>>
>> Signal should be probably be renamed to qual to make it more clear that it is 
>> arbitrary.
> 
> In WE, qual is arbitrary within a few limits:
> 
> a) qual _must_ change on a linear scale
> b) a valid max_qual.qual must be set
> c) qual must fall within the bounds of [0, max_qual.qual] inclusive

Note that the quantity supplied by the bcm43xx firmware (called jssi in the code) varies linearly 
with the strength of the signal, whereas the quantity derived from it in bcm43xx_rssi_postprocess is 
quasi logarithmic. The statement in a) above would argue against reversal of my conventions. What 
happens in the other drivers that use mac80211?
> 
> If you report 'level' in dBm, you must set the IW_QUAL_DBM flag.
> Otherwise, 'level' _may_ be assumed to be RSSI.  If 'level' is dBm,
> max_qual.level must be 0.  If 'level' is RSSI, max_qual.level must be
> greater than 0, and level must fall within the bounds of [0,
> max_qual.level] inclusive.  Replace 'level' with 'noise' here for the
> rules for noise.
> 
> I don't particularly care if level/noise is RSSI _as long as_ you give
> the max RSSI for your part.  Different radio parts have different max
> RSSI values, and if you're writing a driver you sure better know them or
> figure some reasonable ones out by experimentation.  RSSI is entirely
> vendor defined and does _not_ conform to any rules.  Therefore we need
> the max RSSI to get usable signal strength reports from your part.
> 
> I know that 0 dBm isn't actually the upper bound, but in practice most
> people aren't going to get parts that go above that.  0 dBm should be
> considered a _limitation_ of WEXT that we obviously fix with
> cfg80211/nl80211 when we bring some sanity to signal strength reporting.

If the IW_QUAL_DBM flag is set, the "maximum" for that quantity is actually interpreted as a minimum 
and the range is interpreted as [maximum..0] using s8 arithmetic.

> Again, if you report level in RSSI, you must provide the max RSSI for
> your part in max_qual.level.

Agreed.

Larry

