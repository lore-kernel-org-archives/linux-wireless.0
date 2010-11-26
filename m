Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from 128-177-27-249.ip.openhosting.com ([128.177.27.249]:33660 "EHLO
	jmalinen.user.openhosting.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753395Ab0KZJs7 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 26 Nov 2010 04:48:59 -0500
Date: Fri, 26 Nov 2010 11:48:47 +0200
From: Jouni Malinen <j@w1.fi>
To: Wolfgang Breyha <wbreyha@gmx.net>
Cc: Helmut Schaa <helmut.schaa@googlemail.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: Re: Linux Client vs. CISCO AP with band select
Message-ID: <20101126094847.GA28425@jm.kir.nu>
References: <4CE6EA98.3020300@gmx.net>
 <20101120112753.GA12225@jm.kir.nu>
 <201011201304.48821.helmut.schaa@googlemail.com>
 <4CEBE834.9000303@gmx.net>
 <20101125211857.GB6907@jm.kir.nu>
 <4CEEF03A.1000608@gmx.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <4CEEF03A.1000608@gmx.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, Nov 26, 2010 at 12:24:42AM +0100, Wolfgang Breyha wrote:
> I did some more tests meanwhile. After hacking mac80211 to not send the
> direct probe I was able to connect to 2.4GHz again as I already noted. What
> I didn't recognize initially was that the AP responded to probes afterwards
> for some time. But after a short time (0-5 Minutes) it stopped responding
> again. I think that's the way load balancing works with CISCO APs.

Interesting.. I'm not sure whether that would get many stations leaving
the current AP, so there may be other more aggressive options that the
AP ends up using in the end, though. I think that mac80211 was just
modified to use another AP probing mechanism (data nullfunc instead of
Probe Request), so mac80211-based drivers may not react to the probe
response changes while associated anymore.

> wpa_supplicant deauthenticates then with "due to inactivity" and blacklists
> the AP. And this is another case in which the same AP is tried again at the
> next reconnect attempt because the blacklist count reaches only 1 in
> events.c:wpa_supplicant_event_disassoc():1298
>         e = wpa_blacklist_get(wpa_s, bss->bssid);
>         if (e && e->count > 1) {
>                 wpa_printf(MSG_DEBUG, "   skip - blacklisted");

> to "e->count >= 1" and had better results since a BSSID is never tried
> again in the following retry. But your commitdiffs let me guess that it is
> wanted in some other cases I'm not aware of.

Yes, but that only applies for the case where more than a single network
configuration block is enabled. I changed wpa_supplicant to change
between 0 and 1 in this check based on the number of enabled networks.
In addition, I extended the optimized scan after auth/assoc failure
mechanism to apply for the disconnection event, too. That should speed
up recovery from this type of situation quite a bit.

> Last but not least I talked to my college some days ago and he told me that
> "band select" is not a feature he needs desperately. But "load balancing"
> is indeed needed for our large audiences with up to 750 people. If the
> decision is left to the clients alone some APs are pretty overcrowded very
> fast.

Could you please send me a wireless capture log with some of the Beacon
and Probe Response frames from those APs? I would like to see what kind
of information they advertise and whether there would be anything worth
using in BSS selection to avoid being kicked off from the network based
on more aggressive load balancing mechanisms.

-- 
Jouni Malinen                                            PGP id EFC895FA
