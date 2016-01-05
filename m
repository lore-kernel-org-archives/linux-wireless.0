Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:38232 "EHLO sipsolutions.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751603AbcAEPuc (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 5 Jan 2016 10:50:32 -0500
Message-ID: <1452009029.12357.37.camel@sipsolutions.net> (sfid-20160105_165035_399383_17862CAB)
Subject: Re: Mac80211 : Wpa rekeying issue
From: Johannes Berg <johannes@sipsolutions.net>
To: Matthias May <matthias.may@neratec.com>,
	Emmanuel Grumbach <egrumbach@gmail.com>,
	voncken <cedric.voncken@acksys.fr>
Cc: linux-wireless <linux-wireless@vger.kernel.org>
Date: Tue, 05 Jan 2016 16:50:29 +0100
In-Reply-To: <568BA0E3.5080905@neratec.com>
References: <773DB8A82AB6A046AE0195C68612A31901C5B5A9@sbs2003.acksys.local>
	 <CANUX_P2k-Feexi5=gBm+UxsFkoic7FeGDFcNa_D3J2ujYL2ghQ@mail.gmail.com>
	 <0a5101d1424c$eb46d2d0$c1d47870$@acksys.fr>
	 <0a6a01d143a2$fcb77720$f6266560$@acksys.fr>
	 <CANUX_P2pF_He3mruTxMU_poBXzZpa9rXA7AgYV_RQ4BJ9wS6Mg@mail.gmail.com>
	 <568B912F.8070100@neratec.com> <1451987939.12357.18.camel@sipsolutions.net>
	 <568BA0E3.5080905@neratec.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, 2016-01-05 at 11:54 +0100, Matthias May wrote:
> 
> Not safe as in "access to stuff which has to be locked", or not safe
> as 
> in "a CCMP replay attack is possible"?
> When changing this we argumented that since we are not really
> connected 
> yet, a CCMP replay attack doesn't really make sense.
> 

It's a bit more complicated than my first look suggested, it seems.

However, I'm not sure what effect your patch is supposed to have.
You're skipping CCMP replay checking and update when not authorized
yet, at which point the station isn't receiving frames anyway (though
they'd be checked for all this, they'd later be discarded).

Once it becomes authorized, you do the checks. However, it never
becomes unauthorized again, even for rekeying, so for the PTK rekeying
issue at hand it's pretty much a no-op?

johannes

PS: the comment in your patch is also wrong:

> +               /* If we are a station update the ccmp counter only when we are
> +                * authorised. For all other modes always update. */
> +               if (!rx->sta ||
> +                   (rx->sta && test_sta_flag(rx->sta, WLAN_STA_AUTHORIZED)) ) {

There's no check for "if we are a station" here.
