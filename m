Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mo4-p00-ob.smtp.rzone.de ([81.169.146.160]:25642 "EHLO
        mo4-p00-ob.smtp.rzone.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753722AbcJDVNF (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 4 Oct 2016 17:13:05 -0400
Subject: Re: [PATCHv3] wireless: check A-MSDU inner frame source address on AP
 interfaces
To: Johannes Berg <johannes@sipsolutions.net>
References: <1475075672-30549-1-git-send-email-michael-dev@fami-braun.de>
 <1475229714.17481.18.camel@sipsolutions.net>
 <f9d33317-f23f-9d5e-8e9e-1e63eff1882a@fem.tu-ilmenau.de>
 <1475569759.5324.22.camel@sipsolutions.net>
 <1475570219.5324.28.camel@sipsolutions.net>
Cc: kvalo@codeaurora.org, akarwar@marvell.com, nishants@marvell.com,
        Larry.Finger@lwfinger.net, Jes.Sorensen@redhat.com,
        linux-wireless@vger.kernel.org, projekt-wlan@fem.tu-ilmenau.de
From: "M. Braun" <michael-dev@fami-braun.de>
Message-ID: <3948ce82-05d8-5c77-0ef1-04045555f48e@fami-braun.de> (sfid-20161004_231309_350407_C28BE3C0)
Date: Tue, 4 Oct 2016 23:12:25 +0200
MIME-Version: 1.0
In-Reply-To: <1475570219.5324.28.camel@sipsolutions.net>
Content-Type: text/plain; charset=utf-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

> Obviously, now that I think about it, your patch also would break
> client mode since it would refuse to accept any A-MSDU with SA != TA,
> which is highly unlikely in most cases, since traffic doesn't usually
> originate from the AP.

I still don't think my patch would break anything here, as it does only
filter on AP/AP_VLAN interfaces so stations are not affected at all.

I agree that asking for more cases to be filtered seems natural. But is
fixing all possible A-MSDU address mismatch problems required to fix the
one I currently care about most?

> We verify today that only multicast frames can be encrypted with the
> GTK, but that applies to the outer header, so we're susceptible to a
> variant of the hole-196 attack, afaict?

That exploited that an unicast arp reply can be injected using GTK, thus
bypassing AP filtering, right?

To counter, it would suffice to required multicast A-MSDU frames to only
carry multicast (inner) MSDUs?

I don't see how this could be inversed, that is an attack exploiting
multicast encrypted with PTK.

> Overall, it seems to me we should do the following:

I'm wondering if all this filtering is actually required or if it
filters out more than required?

>  * pass DA == RA for client mode (not when 4-addr)

If this implies that encapsulating multicast as unicast A-MSDU is not
permitted, then why? This would break multicast to unicast using A-MSDU
frames, which currently works with most clients for me.

In order to fully counter hole-196, one has to remove the shared key
property of GTK. That is, each multicast packet is send once for each
station using a different encryption key. This currently is slow due to
multicast rate and makes each station wake up and receive each copy of
the multicast frame, including all those it cannot decrypt.
Using A-MSDU based multicast to unicast, these effects can be mitigated
regardless of packet payload type by using faster unicast transmissions
instead, as the wireless stack is supposed to restore the original
(inner) frame.

>  * pass both on TDLS links

I don't know why TDLS links should carry multicast at all, so this seems
reasonable to me.

>  * pass both for IBSS mode (I think)

Why is multicast to unicast not permitted within IBSS?

Hole-196 does not really seem to apply, as we're lacking the AP filter
rules to be bypassed anyway?

michael
