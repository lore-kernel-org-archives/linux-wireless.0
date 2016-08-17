Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail2.tohojo.dk ([77.235.48.147]:59302 "EHLO mail2.tohojo.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751774AbcHQNQb (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 17 Aug 2016 09:16:31 -0400
From: =?utf-8?Q?Toke_H=C3=B8iland-J=C3=B8rgensen?= <toke@toke.dk>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: make-wifi-fast@lists.bufferbloat.net,
	linux-wireless@vger.kernel.org, Felix Fietkau <nbd@nbd.name>
Subject: Re: [PATCH] mac80211: Move crypto IV generation to after TXQ dequeue.
References: <20160817125800.19154-1-toke@toke.dk>
	<1471439315.5173.7.camel@sipsolutions.net>
Date: Wed, 17 Aug 2016 15:16:26 +0200
In-Reply-To: <1471439315.5173.7.camel@sipsolutions.net> (Johannes Berg's
	message of "Wed, 17 Aug 2016 15:08:35 +0200")
Message-ID: <87h9aj5ydx.fsf@toke.dk> (sfid-20160817_151634_334227_C864B1F0)
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Johannes Berg <johannes@sipsolutions.net> writes:

>> @@ -1573,6 +1574,7 @@ struct ieee80211_key_conf {
>> =C2=A0	u8 iv_len;
>> =C2=A0	u8 hw_key_idx;
>> =C2=A0	u8 flags;
>> +	u8 pn_offs;
>>=20
> This is completely wrong.

Well, the ieee80211_fast_tx struct is not available in
ieee80211_tx_dequeue, and I need the offset there. I thought about
sticking it into ieee80211_tx_info, but that is kinda full, and since
the ieee80211_key_conf is already available there, carrying it there
seems to work.

What would be a better way to do this?

-Toke
