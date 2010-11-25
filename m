Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mailout-de.gmx.net ([213.165.64.23]:36629 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with SMTP
	id S1752641Ab0KYXYp (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 25 Nov 2010 18:24:45 -0500
Message-ID: <4CEEF03A.1000608@gmx.net>
Date: Fri, 26 Nov 2010 00:24:42 +0100
From: Wolfgang Breyha <wbreyha@gmx.net>
MIME-Version: 1.0
To: Jouni Malinen <j@w1.fi>
CC: Helmut Schaa <helmut.schaa@googlemail.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: Re: Linux Client vs. CISCO AP with band select
References: <4CE6EA98.3020300@gmx.net> <20101120112753.GA12225@jm.kir.nu> <201011201304.48821.helmut.schaa@googlemail.com> <4CEBE834.9000303@gmx.net> <20101125211857.GB6907@jm.kir.nu>
In-Reply-To: <20101125211857.GB6907@jm.kir.nu>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 2010-11-25 22:18, Jouni Malinen wrote:
> I simulated the five most likely ways current APs could attempt to
> implement load balancing and fixed/optimized those in sme.c. Please take
> a look at following commits if you want to see more details:

Sure! I definitely will try a git checkout tomorrow and report back!

I did some more tests meanwhile. After hacking mac80211 to not send the
direct probe I was able to connect to 2.4GHz again as I already noted. What
I didn't recognize initially was that the AP responded to probes afterwards
for some time. But after a short time (0-5 Minutes) it stopped responding
again. I think that's the way load balancing works with CISCO APs.
wpa_supplicant deauthenticates then with "due to inactivity" and blacklists
the AP. And this is another case in which the same AP is tried again at the
next reconnect attempt because the blacklist count reaches only 1 in
events.c:wpa_supplicant_event_disassoc():1298

I tried to change events.c:472ff
        e = wpa_blacklist_get(wpa_s, bss->bssid);
        if (e && e->count > 1) {
                wpa_printf(MSG_DEBUG, "   skip - blacklisted");
                return 0;
        }
to "e->count >= 1" and had better results since a BSSID is never tried
again in the following retry. But your commitdiffs let me guess that it is
wanted in some other cases I'm not aware of.

Last but not least I talked to my college some days ago and he told me that
"band select" is not a feature he needs desperately. But "load balancing"
is indeed needed for our large audiences with up to 750 people. If the
decision is left to the clients alone some APs are pretty overcrowded very
fast.

We decided to keep both features active as long as I can help to get the
issues fixed for Linux. Afterwards we most likely will deactivate "band
select" until the fixes find their way into common Ubuntus, Fedoras & Co.

Greetings,
Wolfgang
-- 
Wolfgang Breyha <wbreyha@gmx.net> | http://www.blafasel.at/
Vienna University Computer Center | Austria
