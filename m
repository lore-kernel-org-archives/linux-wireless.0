Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:36236 "EHLO sipsolutions.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751503AbcAEJTk (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 5 Jan 2016 04:19:40 -0500
Message-ID: <1451985576.12357.10.camel@sipsolutions.net> (sfid-20160105_101946_150717_D96729D3)
Subject: Re: Mac80211 : Wpa rekeying issue
From: Johannes Berg <johannes@sipsolutions.net>
To: Emmanuel Grumbach <egrumbach@gmail.com>,
	voncken <cedric.voncken@acksys.fr>
Cc: linux-wireless <linux-wireless@vger.kernel.org>
Date: Tue, 05 Jan 2016 10:19:36 +0100
In-Reply-To: <CANUX_P2pF_He3mruTxMU_poBXzZpa9rXA7AgYV_RQ4BJ9wS6Mg@mail.gmail.com> (sfid-20151231_094154_715579_53F875A2)
References: <773DB8A82AB6A046AE0195C68612A31901C5B5A9@sbs2003.acksys.local>
	 <CANUX_P2k-Feexi5=gBm+UxsFkoic7FeGDFcNa_D3J2ujYL2ghQ@mail.gmail.com>
	 <0a5101d1424c$eb46d2d0$c1d47870$@acksys.fr>
	 <0a6a01d143a2$fcb77720$f6266560$@acksys.fr>
	 <CANUX_P2pF_He3mruTxMU_poBXzZpa9rXA7AgYV_RQ4BJ9wS6Mg@mail.gmail.com>
	 (sfid-20151231_094154_715579_53F875A2)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, 2015-12-31 at 10:41 +0200, Emmanuel Grumbach wrote:

> It simply disables the replay attack detection :)
> You could receive the same (encrypted) packet twice and not throw
> away the second one.

Correct.

> PTK rekeying is a problem from the spec point of view. 

Which was/is being addressed too, with different key index being
allowed now. We just haven't implemented it yet, and in the case at
hand the AP also won't be requesting it and the enhancement wouldn't be
used anyway.

> In Intel, we
> did inquiries and in the end we understood that what we should really
> do whenever we get to a situation where we need to rekey the PTK is
> to disconnect and reconnect. Only weird configuration allow to change
> the PTK more frequently than after X packet (don't remember what X is
> but something like 2^32 which is big enough to hold the connection
> for days...).

wpa_supplicant could easily disconnect.

> IIRC, Intel devices don't have problems in Tx while we rekey because
> we give the key material along with the packet itself, so that we
> can't get to a situation where we have old PN and new key.

Yeah, that's my recollection as well. Emmanuel, remember though we're
going to change this, which could become problematic. We might want to
implement the disconnection once we change it, and also implement the
new spec way of PTK rekeying (with key index).

>  The Atheros
> devices separate the key material and the Tx packet (which is a
> perfectly valid design decision), but this introduce the possibility
> to use the old PN with a new key meaning that the recipient could
> decrypt the packet after the new key has been installed, but it would
> also update the PN to be high and discard all the next packets that
> will come with a new (low) PN.
> So essentially, this is a bug in the TX'ing side. Fixing it requires
> to hit the performance which is not something people are willing to
> do, when the bug is really in the spec.
> That's what I remember, but I may be wrong.

It matches what I remember too :)

johannes
