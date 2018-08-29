Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.toke.dk ([52.28.52.200]:50983 "EHLO mail.toke.dk"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726858AbeH2NXO (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 29 Aug 2018 09:23:14 -0400
From: Toke =?utf-8?Q?H=C3=B8iland-J=C3=B8rgensen?= <toke@toke.dk>
To: Johannes Berg <johannes@sipsolutions.net>,
        linux-wireless@vger.kernel.org
Cc: make-wifi-fast@lists.bufferbloat.net, Felix Fietkau <nbd@nbd.name>
Subject: Re: [RFC v2 2/4] mac80211: Add airtime accounting and scheduling to TXQs
In-Reply-To: <1535528658.5215.19.camel@sipsolutions.net>
References: <153115421866.7447.6363834356268564403.stgit@alrua-x1> <153115422499.7447.2570671473822724496.stgit@alrua-x1> <1535528658.5215.19.camel@sipsolutions.net>
Date: Wed, 29 Aug 2018 11:27:13 +0200
Message-ID: <877ek94j66.fsf@toke.dk> (sfid-20180829_112717_742561_2E79AD10)
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Johannes Berg <johannes@sipsolutions.net> writes:

> On Mon, 2018-07-09 at 18:37 +0200, Toke H=C3=B8iland-J=C3=B8rgensen wrote:
>>=20
>> @@ -427,6 +428,8 @@ struct sta_info *sta_info_alloc(struct ieee80211_sub=
_if_data *sdata,
>>  	sta->cparams.interval =3D MS2TIME(100);
>>  	sta->cparams.ecn =3D true;
>>=20=20
>> +	sta->airtime.weight =3D 1;
>
> Perhaps it might be useful to start with a higher default (even
> something like 1<<8) as that would allow adjusting up/down single
> stations, without having to adjust all stations and listening to new
> additions to adjust them quickly etc?
>
> Theoretically this doesn't really matter, but from a practical POV it
> may be easier to leave them all at the default and just adjust the ones
> that need adjustment for some reason.

Hmm, the problem with a higher weight is that weight*quantum becomes the
time each station is scheduled, so having a higher value means higher
latency. This could be fixed by replacing the station weights with
per-station quantums, but I felt that this was exposing an
implementation detail in the API; if we ever change the enforcement
mechanism to not be quantum-based (as may be necessary for MU-MIMO for
instance), we'll have to convert values in the kernel. Whereas weights
are a conceptual measure that is not tied to any particular
implementation.

>> ieee80211_sta_register_airtime
>
> Do we really need this? We already have at least TX status with
> airtime, for ieee80211_sta_tx_notify() and friends, and the station
> pointer in that context, so couldn't we piggy-back on this? At least
> WMM-AC already requires the driver to provide this.

For the drivers that get airtime as part of TX completion, sure; but as
I understand it, at least ath10k gets airtime information in out of band
status reports, so there would need to be a callback for that in any
case...

-Toke
