Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail2.tohojo.dk ([77.235.48.147]:59536 "EHLO mail2.tohojo.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752279AbcHQNYL (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 17 Aug 2016 09:24:11 -0400
From: =?utf-8?Q?Toke_H=C3=B8iland-J=C3=B8rgensen?= <toke@toke.dk>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: make-wifi-fast@lists.bufferbloat.net,
	linux-wireless@vger.kernel.org, Felix Fietkau <nbd@nbd.name>
Subject: Re: [PATCH] mac80211: Move crypto IV generation to after TXQ dequeue.
References: <20160817125800.19154-1-toke@toke.dk>
	<1471439315.5173.7.camel@sipsolutions.net> <87h9aj5ydx.fsf@toke.dk>
	<1471439894.5173.9.camel@sipsolutions.net>
Date: Wed, 17 Aug 2016 15:23:28 +0200
In-Reply-To: <1471439894.5173.9.camel@sipsolutions.net> (Johannes Berg's
	message of "Wed, 17 Aug 2016 15:18:14 +0200")
Message-ID: <87d1l75y27.fsf@toke.dk> (sfid-20160817_152414_787440_3C4E60E9)
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Johannes Berg <johannes@sipsolutions.net> writes:

> On Wed, 2016-08-17 at 15:16 +0200, Toke H=C3=B8iland-J=C3=B8rgensen wrote:
>> Johannes Berg <johannes@sipsolutions.net> writes:
>>=20
>> >=20
>> > >=20
>> > > @@ -1573,6 +1574,7 @@ struct ieee80211_key_conf {
>> > > =C2=A0	u8 iv_len;
>> > > =C2=A0	u8 hw_key_idx;
>> > > =C2=A0	u8 flags;
>> > > +	u8 pn_offs;
>> > >=20
>> > This is completely wrong.
>>=20
>> Well, the ieee80211_fast_tx struct is not available in
>> ieee80211_tx_dequeue, and I need the offset there. I thought about
>> sticking it into ieee80211_tx_info, but that is kinda full, and since
>> the ieee80211_key_conf is already available there, carrying it there
>> seems to work.
>
> For very limited testing, perhaps. But this isn't static across all
> usages of the key, so this is still completely broken.

OK, noted.

>> What would be a better way to do this?
>>=20
>
> Some redesign/rearchitecture, probably. Or just do it all in the driver
> like iwlmvm?

Will look it over again. Should be possible to re-calculate the offset,
I guess.

-Toke
