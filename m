Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from 128-177-27-249.ip.openhosting.com ([128.177.27.249]:49965 "EHLO
	jmalinen.user.openhosting.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751941Ab0KYVTH (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 25 Nov 2010 16:19:07 -0500
Date: Thu, 25 Nov 2010 23:18:57 +0200
From: Jouni Malinen <j@w1.fi>
To: Wolfgang Breyha <wbreyha@gmx.net>
Cc: Helmut Schaa <helmut.schaa@googlemail.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: Re: Linux Client vs. CISCO AP with band select
Message-ID: <20101125211857.GB6907@jm.kir.nu>
References: <4CE6EA98.3020300@gmx.net>
 <20101120112753.GA12225@jm.kir.nu>
 <201011201304.48821.helmut.schaa@googlemail.com>
 <4CEBE834.9000303@gmx.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <4CEBE834.9000303@gmx.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, Nov 23, 2010 at 05:13:40PM +0100, Wolfgang Breyha wrote:
> The patch from Helmut didn't change anything. I even tried to send both
> broadcast and direct probes in triples to check if that's the threshold
> which is configured in band select as retries. It's not;-)
> 
> After that I tried a dirty hack on wpa_supplicant 0.7.3:

...

> In other words I reused the code found in sme_event_assoc_reject() to
> add the BSSID to the blacklist. To speed up things further I add it
> twice;-) I don't know why wpa_supplicant needs a blacklist count of 2 to
> finally try an other BSSID.

Thanks! This was indeed one of the problems (but not the only one). The
1 vs. 2 part comes from five years ago (needed to go through the commit
log messages to remember that one..). It avoids getting stuck with worse
networks when multiple network blocks are configured. So yes,
incrementing the blacklist count by two is indeed the way to go here in
some cases.

I simulated the five most likely ways current APs could attempt to
implement load balancing and fixed/optimized those in sme.c. Please take
a look at following commits if you want to see more details:

http://w1.fi/gitweb/gitweb.cgi?p=hostap.git;a=commitdiff;h=7e6646c794ccd1df8d38b9927d11e101c0d45517
http://w1.fi/gitweb/gitweb.cgi?p=hostap.git;a=commitdiff;h=f47d639d495b32f0348c09a0fd0ff5b5791720d4

With those in place, it should now be possible to recover from the
authentication failure (this no Probe Request looks like auth timeout
with mac80211) or association failure (e.g., AP rejecting association
with status code 17) in about 0.5 seconds or so (or a bit more if there
are APs in multiple channels). Though, please note that this is only the
case with nl80211 as the driver interface (-Dnl80211). WEXT will still
go through three full scans in this type of case (i.e., two full scans
to recover vs. one scan with just the known channels when using
nl80211).

> And it helps a lot. With this change wpa_supplicant stops retrying the
> same BSSID all the time and tries a 5GHz one pretty fast. And I think
> that's exactly what CISCO tries to achieve.

Yes, I would assume so.

> Finally there is another timeout in the EAP stage (SUPP_BE) I can't
> pinpoint. I attached the wpa_supplicant.log.

That looks like a lost EAPOL packet to me based on that log.. Would
likely need to use a wireless sniffer to take a closer look at where the
packet is dropped.

> Knowing where to search and how to hack mac80211 and wpa_supplicant I'll
> try to find some details which probes CISCO responds to reaching the
> threshold.

I don't think that that would be very critical to figure out anymore
with the current wpa_supplicant (-Dnl80211). Sure, we could consider
removing the need-a-probe-response-before-auth case from mac80211, but
actually, in this particular case, it would result in not following the
not-so-gently hint from the AP.

> I can still provide packet traces if you need/want them. In case of the
> load balancing feature it may take some time because I've not found a
> trick to provoke it. But I think a well and fast trained blacklist will
> help in this case, too.

For band enforcement, I think the behavior is clear enough and no
additional information is needed. I can easily simulate this type of
behavior by modifying hostapd. For load balancing while being
associated, it would be interesting to hear if it behaves badly, i.e.,
if there is a long gap in connectivity etc. user visible badness. I
would assume I can easily simulate those for testing, but to do that, I
would need to first see how the particular AP/network is behaving.

-- 
Jouni Malinen                                            PGP id EFC895FA
