Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.toke.dk ([52.28.52.200]:56827 "EHLO mail.toke.dk"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1753741AbdIDOXr (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 4 Sep 2017 10:23:47 -0400
From: Toke =?utf-8?Q?H=C3=B8iland-J=C3=B8rgensen?= <toke@toke.dk>
To: Johannes Berg <johannes@sipsolutions.net>,
        linux-wireless@vger.kernel.org
Cc: nbd@nbd.name
Subject: Re: [PATCH 3/3] mac80211: fix VLAN handling with TXQs
In-Reply-To: <1504517620.9797.3.camel@sipsolutions.net>
References: <20170622102030.9795-1-johannes@sipsolutions.net> <20170622102030.9795-3-johannes@sipsolutions.net> <87378lvyfz.fsf@toke.dk> <1504517620.9797.3.camel@sipsolutions.net>
Date: Mon, 04 Sep 2017 16:23:44 +0200
Message-ID: <87mv6a35lb.fsf@toke.dk> (sfid-20170904_162352_217661_E8850EA1)
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Johannes Berg <johannes@sipsolutions.net> writes:

> On Mon, 2017-08-21 at 15:32 +0200, Toke H=C3=B8iland-J=C3=B8rgensen wrote:
>>=20
>> > +			struct ieee80211_vif *vif;
>> > =C2=A0			struct ieee80211_key_conf *hw_key;
>> > =C2=A0			u32 flags;
>> > -			/* 4 bytes free */
>> > +			codel_time_t enqueue_time;
>>=20
>> A side effect of this is that enqueue_time will be valid in the
>> driver; which is good as far as I'm concerned (I've been thinking
>> about using it to make decisions about when to stop retrying a
>> frame).
>
> Well, I think we need to do a lot more to allow that, but I guess
> ultimately it would be possible - though we have this as codel_time_t
> so the driver doesn't really know the reference etc. immediately.

Well, the driver could be taught how to handle CoDel timestamps, but
you're right that that would be somewhat cludgy. Which is another reason
to use the tstamp; guess I'll ask Eric about that.

>> If we want to save the four bytes, is there any reason we can't just
>> change the codel code to use skb->tstamp instead?
>
> I didn't really want to go into that.
>
> Any comments on the patch itself? I don't think I even merged this
> yet.

Hmm, not apart from agreeing with you that it would be better to not
drop everything when removing a VLAN. Not sure how often this happens,
though (and hence how big of a problem it is). What happens in scenarios
where hostapd is setup to automatically generate a bunch of VLANs for
every client, for instance?

-Toke
