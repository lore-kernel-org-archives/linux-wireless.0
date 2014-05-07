Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from dedo.coelho.fi ([88.198.205.34]:42303 "EHLO dedo.coelho.fi"
	rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org with ESMTP
	id S1754472AbaEGJ16 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 7 May 2014 05:27:58 -0400
Message-ID: <1399454858.6800.1.camel@dubbel> (sfid-20140507_112801_720157_CA1B209D)
From: Luca Coelho <luca@coelho.fi>
To: Michal Kazior <michal.kazior@tieto.com>
Cc: Johannes Berg <johannes@sipsolutions.net>,
	linux-wireless <linux-wireless@vger.kernel.org>,
	Simon Wunderlich <sw@simonwunderlich.de>
Date: Wed, 07 May 2014 12:27:38 +0300
In-Reply-To: <CA+BoTQnGRtdOGfJ78EG43cmND2bD9m3WyvmSKx92uBFnKenPkw@mail.gmail.com>
References: <1397050174-26121-14-git-send-email-michal.kazior@tieto.com>
	 <1398849681-3606-1-git-send-email-michal.kazior@tieto.com>
	 <1399372915.4218.17.camel@jlt4.sipsolutions.net>
	 <CA+BoTQk1upg7yGK-QWoz8QhMeRzLBY60Lk=eUN=iQLaF2pUhQQ@mail.gmail.com>
	 <1399385141.4218.37.camel@jlt4.sipsolutions.net>
	 <CA+BoTQnGRtdOGfJ78EG43cmND2bD9m3WyvmSKx92uBFnKenPkw@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Subject: Re: [PATCH v5] mac80211: implement multi-vif in-place reservations
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 2014-05-07 at 08:05 +0200, Michal Kazior wrote:
> On 6 May 2014 16:05, Johannes Berg <johannes@sipsolutions.net> wrote:
> > On Tue, 2014-05-06 at 14:47 +0200, Michal Kazior wrote:
> >> > Separately, I think due to the complexities involved in the driver
> >> > implementation we'll probably need a bitmap indicating which interface
> >> > types are supported (this is not something we do today, and this would
> >> > be broken in iwlwifi for sure.)
> >>
> >> Care to elaborate?
> >
> > It's a separate issue really - but sure: the iwlwifi firmware API will
> > likely not allow doing such trickery in the IBSS case, so we should have
> > a bitmap of supported interface types (e.g. BIT(NL80211_IFTYPE_STATION)
> > | ...) for the channel switch operation.
> 
> Ah, I get it now. Thanks.

I guess this should be done when the actual support for AP, STATION and
so on is added? For example, add the station flag with the "mac80211:
use chanctx reservation for STA CSA" patch and so on...

--
Luca.

