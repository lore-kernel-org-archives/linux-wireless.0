Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([144.76.43.152]:49432 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755610AbaEGLKC (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 7 May 2014 07:10:02 -0400
Message-ID: <1399460994.10517.13.camel@jlt4.sipsolutions.net> (sfid-20140507_131010_915250_8667BDE4)
Subject: Re: [PATCH v5] mac80211: implement multi-vif in-place reservations
From: Johannes Berg <johannes@sipsolutions.net>
To: Luca Coelho <luca@coelho.fi>
Cc: Michal Kazior <michal.kazior@tieto.com>,
	linux-wireless <linux-wireless@vger.kernel.org>,
	Simon Wunderlich <sw@simonwunderlich.de>
Date: Wed, 07 May 2014 13:09:54 +0200
In-Reply-To: <1399454858.6800.1.camel@dubbel>
References: <1397050174-26121-14-git-send-email-michal.kazior@tieto.com>
	 <1398849681-3606-1-git-send-email-michal.kazior@tieto.com>
	 <1399372915.4218.17.camel@jlt4.sipsolutions.net>
	 <CA+BoTQk1upg7yGK-QWoz8QhMeRzLBY60Lk=eUN=iQLaF2pUhQQ@mail.gmail.com>
	 <1399385141.4218.37.camel@jlt4.sipsolutions.net>
	 <CA+BoTQnGRtdOGfJ78EG43cmND2bD9m3WyvmSKx92uBFnKenPkw@mail.gmail.com>
	 <1399454858.6800.1.camel@dubbel>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 2014-05-07 at 12:27 +0300, Luca Coelho wrote:

> > > It's a separate issue really - but sure: the iwlwifi firmware API will
> > > likely not allow doing such trickery in the IBSS case, so we should have
> > > a bitmap of supported interface types (e.g. BIT(NL80211_IFTYPE_STATION)
> > > | ...) for the channel switch operation.
> > 
> > Ah, I get it now. Thanks.
> 
> I guess this should be done when the actual support for AP, STATION and
> so on is added? For example, add the station flag with the "mac80211:
> use chanctx reservation for STA CSA" patch and so on...

I don't know if we really want separate flags, rather than maybe a new
field with an interface types supported bitmap?

johannes

