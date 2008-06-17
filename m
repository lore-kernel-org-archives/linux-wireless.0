Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from hostap.isc.org ([149.20.54.63]:44094 "EHLO hostap.isc.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752862AbYFQSvl (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 17 Jun 2008 14:51:41 -0400
Date: Tue, 17 Jun 2008 21:50:45 +0300
From: Jouni Malinen <j@w1.fi>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless@vger.kernel.org
Subject: Re: [RFC PATCH 3/7] 802.11w: Add BIP (AES-128-CMAC)
Message-ID: <20080617185045.GH4974@jm.kir.nu> (sfid-20080617_205201_772012_8678BA97)
References: <20080617154008.883383150@localhost> <20080617155904.082926456@localhost> <1213721714.3803.83.camel@johannes.berg> <20080617180610.GC4974@jm.kir.nu> <1213726753.3803.103.camel@johannes.berg>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1213726753.3803.103.camel@johannes.berg>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, Jun 17, 2008 at 08:19:13PM +0200, Johannes Berg wrote:

> Well the thing is that you can't just call pskb_expand_head without
> orphaning the SKB first and all that truesize adjusting, because of
> truesize accounting, because it might now or later belong to a userspace
> socket.

OK. I don't want to do that here, so I'll see what can be done with
IEEE80211_ENCRYPT_TAILROOM.

> > Anyway, I would assume it would be possible to do this by changing
> > IEEE80211_ENCRYPT_TAILROOM from 12 to 22 which would waste 10 bytes
> > extra for every frame (well, not waste for BIP-protected frames but
> > there are next to none of them).
> 
> 22? Is there something else on the frame in addition to the MMIE?

Uhm.. Maybe I just cannot count anymore.. Or well, I did not remember
where the 12 comes from and decided to add 4 because of that. Anyway,
yes, now that I see that 12 is 8(MIC)+4(ICV) for TKIP, this 12 would
indeed change to 18.

> Yeah, true, and we actually have that in another place too. If we then
> remove the MMIE, the IE sanity checks should catch the bad frame anyway,
> when/if it is parsed. Except we removed those because APs were sending
> bogus information. I'm fine with this, but we should be aware of the
> consequence.

As long as we get the RX path implemented properly, this will only hit
if there is a bug in an MFP-enabled AP or someone is trying to attack
the network and both cases are very good candidates for dropping the
frame anyway. The key selection is supposed to pick BIP key only if the
sender (AP) has negotiated MFP and as such, all valid broadcast robust
management frames are guaranteed to have MMIE in the end.

-- 
Jouni Malinen                                            PGP id EFC895FA
