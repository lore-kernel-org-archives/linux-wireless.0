Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from dedo.coelho.fi ([88.198.205.34]:42405 "EHLO dedo.coelho.fi"
	rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org with ESMTP
	id S1755607AbaEGLYw (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 7 May 2014 07:24:52 -0400
In-Reply-To: <1399460994.10517.13.camel@jlt4.sipsolutions.net>
References: <1397050174-26121-14-git-send-email-michal.kazior@tieto.com> <1398849681-3606-1-git-send-email-michal.kazior@tieto.com> <1399372915.4218.17.camel@jlt4.sipsolutions.net> <CA+BoTQk1upg7yGK-QWoz8QhMeRzLBY60Lk=eUN=iQLaF2pUhQQ@mail.gmail.com> <1399385141.4218.37.camel@jlt4.sipsolutions.net> <CA+BoTQnGRtdOGfJ78EG43cmND2bD9m3WyvmSKx92uBFnKenPkw@mail.gmail.com> <1399454858.6800.1.camel@dubbel> <1399460994.10517.13.camel@jlt4.sipsolutions.net>
MIME-Version: 1.0
Content-Type: text/plain;
 charset=UTF-8
From: Luca Coelho <luca@coelho.fi>
Date: Wed, 07 May 2014 14:24:36 +0300
To: Johannes Berg <johannes@sipsolutions.net>
CC: Michal Kazior <michal.kazior@tieto.com>,
	linux-wireless <linux-wireless@vger.kernel.org>,
	Simon Wunderlich <sw@simonwunderlich.de>
Message-ID: <d70278d8-0bda-45f3-89d4-ab970d7a868b@email.android.com> (sfid-20140507_132455_765211_0208266D)
Subject: Re: [PATCH v5] mac80211: implement multi-vif in-place reservations
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On May 7, 2014 2:09:54 PM EEST, Johannes Berg <johannes@sipsolutions.net> wrote:
>On Wed, 2014-05-07 at 12:27 +0300, Luca Coelho wrote:
>
>> > > It's a separate issue really - but sure: the iwlwifi firmware API
>will
>> > > likely not allow doing such trickery in the IBSS case, so we
>should have
>> > > a bitmap of supported interface types (e.g.
>BIT(NL80211_IFTYPE_STATION)
>> > > | ...) for the channel switch operation.
>> > 
>> > Ah, I get it now. Thanks.
>> 
>> I guess this should be done when the actual support for AP, STATION
>and
>> so on is added? For example, add the station flag with the "mac80211:
>> use chanctx reservation for STA CSA" patch and so on...
>
>I don't know if we really want separate flags, rather than maybe a new
>field with an interface types supported bitmap?

Yes, that's what I had in mind too (as we discussed offline). I meant STA, AP etc. flags in this new bitmask, not in the existing HW_CONF stuff.

--
Luca.


