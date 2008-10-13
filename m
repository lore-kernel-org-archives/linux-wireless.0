Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from hostap.isc.org ([149.20.54.63]:46166 "EHLO hostap.isc.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754048AbYJMRzu (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 13 Oct 2008 13:55:50 -0400
Date: Mon, 13 Oct 2008 20:54:57 +0300
From: Jouni Malinen <j@w1.fi>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless <linux-wireless@vger.kernel.org>,
	Daniel Drake <dsd@gentoo.org>, Felix Fietkau <nbd@openwrt.org>
Subject: Re: [RFC] mac80211: fix short preamble determination
Message-ID: <20081013175457.GB30095@jm.kir.nu> (sfid-20081013_195557_189147_E10C9B74)
References: <1223713593.29811.38.camel@johannes.berg> <20081013155938.GA30095@jm.kir.nu> <1223919110.10113.1.camel@johannes.berg>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1223919110.10113.1.camel@johannes.berg>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, Oct 13, 2008 at 07:31:50PM +0200, Johannes Berg wrote:
> > Changing '!tx->sta ||' to 'tx->sta &&' sounds reasonable, but I'm not so
> > sure about the other change.. In theory, short preamble is negotiated
> > per STA and while we do current disable short preamble completely in the
> > BSS if a non-short-preamble-capable STA associates, I'm not sure whether
> > that would be an absolute requirement.
> 
> I don't see how it cannot be -- you need stations not capable of
> short-preamble to correctly update their NAV, no?

Well, if you have many such devices, yes, but one might try to live
without such protection if there are some with very limited transmit
needs. I don't know whether it would make much sense in most cases and
anyway, it would be possible to make APs reject all associations from
such devices. For example, I could see an attempt to dedicate one
channel for 11g (ERP) and short preamble supported STAs and make the
more modern implementations get somewhat better throughput there.

> > As far as management frames
> > (e.g., Probe Response) are concerned, IEEE 802.11-2007 18.2.2.2 has an
> > interesting statement: "all management traffic is returned with the same
> > type preamble as received". I have not been able to find normative
> > requirement for that being the case, though.
> 
> Yeah, I found that statement too, but no other information on it either,
> heh. Not that we can actually support that easily at all. And besides,
> it would be kinda weird to send probe _requests_ with short preamble to
> start with, since then you wouldn't find APs w/o short preamble...

I'll try to remember to file a comment to TGmb on this (they are still
collecting comments for fixing issues in 802.11 and published
amendments). Probe Request with this does not make much sense (unless
you are either only interested in BSSes that support short preamble
and/or you know that the AP you're interested is able to receive this).
Authentication, association, and public action frames might be more
likely candidates for this.

-- 
Jouni Malinen                                            PGP id EFC895FA
