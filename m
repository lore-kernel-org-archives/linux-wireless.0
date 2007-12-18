Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from crystal.sipsolutions.net ([195.210.38.204]:51150 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755349AbXLRN5a (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 18 Dec 2007 08:57:30 -0500
Subject: Re: [PATCH 5/8] mac80211: A-MPDU Rx handling aggregation reordering
From: Johannes Berg <johannes@sipsolutions.net>
To: Ron Rindjunsky <ron.rindjunsky@intel.com>
Cc: linville@tuxdriver.com, linux-wireless@vger.kernel.org,
	flamingice@sourmilk.net, tomas.winkler@intel.com, yi.zhu@intel.com
In-Reply-To: <c85cb4470712180544m682a93b1v9a7a34d2148a770b@mail.gmail.com> (sfid-20071218_134457_890406_A2932F58)
References: <11979070692599-git-send-email-ron.rindjunsky@intel.com>
	 <11979070782762-git-send-email-ron.rindjunsky@intel.com>
	 <1197915515.4885.86.camel@johannes.berg>
	 <c85cb4470712180544m682a93b1v9a7a34d2148a770b@mail.gmail.com>
	 (sfid-20071218_134457_890406_A2932F58)
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-1DEagpIxRXNph4kijUnA"
Date: Tue, 18 Dec 2007 14:57:28 +0100
Message-Id: <1197986248.4885.149.camel@johannes.berg> (sfid-20071218_135734_436759_26243826)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-1DEagpIxRXNph4kijUnA
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable


> > > +     int ordered;
> >
> > That's not an int, and it's only used internally. Can we somehow avoid
> > putting it into the rx status, have it in the txrx status structure
> > instead and give it the proper type (txrx result)? More of a question
> > than a suggestion, I'd like to have that but I'm not sure it's doable.
>=20
> well, i was asking myself this same question, and went to
> ieee80211_rx_status as ieee80211_txrx_data derives its data from
> ieee80211_rx_status in __ieee80211_rx, so i have no other way to pass
> info per sk_buff.

Ok.

> type int was chosen as it is not a bool type (can be
> drop/continue/queue) so it can't be fit to flags.

No, I was thinking that it's enum txrx_result or whatever that is named.
But you can't use that type in mac80211.h since it's only defined in
ieee80211_i.h... Maybe you should put the declaration into mac80211.h
and use it here so that the compiler can error check this ordered field
better...

> > > @@ -1252,6 +1254,20 @@ void ieee80211_sta_stop_rx_BA_session(struct n=
et_device *dev, u8 *ra, u16 tid,
> > >               ieee80211_send_delba(dev, ra, tid, 0, reason);
> > >
> > >       /* free the reordering buffer */
> > > +     for (i =3D 0; i < sta->ampdu_mlme.tid_rx[tid].buf_size; i++) {
> > > +             if (sta->ampdu_mlme.tid_rx[tid].reorder_buf[i]) {
> > > +                     /* release the reordered frames to stack,
> > > +                      * but drop them there */
> > > +                     memcpy(&status, sta->ampdu_mlme.tid_rx[tid].
> > > +                             reorder_buf[i]->cb, sizeof(status));
> > > +                     status.ordered =3D TXRX_DROP;
> > > +                     __ieee80211_rx(hw, sta->ampdu_mlme.
> > > +                                    tid_rx[tid].reorder_buf[i],
> > > +                                    &status);
> >
> > This is strange. Why are they even passed to __ieee80211_rx?
>=20
> of course i can get rid from there here, but thought it will be more
> systematic and clearer to pass them back to __ieee80211_rx. if you
> have any objection to this (efficiency considerations or like) i will
> reconsider it.

I'm just not sure why you'd want to. As far as I can the frames already
passed __ieee80211_rx(), no? Maybe only as part of the aggregation?

> > > +static inline int seq_less(u16 sq1, u16 sq2)
> > > +{
> > > +     return (((sq1 - sq2) & SEQ_MASK) > (SEQ_MODULO >> 1));
> >
> > Is it really correct to subtract before masking?
>=20
> as these values are already "masked" as sequence numbers the answer is ye=
s.
> if this is not the case, and somehow we deal internally with sequence
> numbers > 4095 this function should be the least to worry about  ;-)

Heh, ok, I didn't really look where it was used.

> the fact these 2 #defines are 1 number apart shouldn't confuse. it is
> just a more
> convenient way for the 802.11 reader (used to sequence number limit)
> to look at it. i could have, if i would like, decide that pass
> criteria for seq_less is not 2048, but only the closest 200 frames, in
> that case i would have give it the value of 200.

Ah, ok. Makes sense, can you add a comment?

> > I think I need to take a second look at this patch to even understand
> > the problem it solves.
> >
>=20
> no one guarantees you get the frames in the right order... please see
> the patch description for such a case.

Ok, right. Still not quite sure I've understand the solution, I'll take
another look.

johannes

--=-1DEagpIxRXNph4kijUnA
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIVAwUAR2fRx6Vg1VMiehFYAQK7cg//dy+SnftaWvghs1LpECL2aQUPwiRT/xuU
POjyZrMJPm+V3/e7lFa26DbNRfQ5ytym6T1ND+l6jk89y1PiJou/XcVTYxERFvsY
a7Av2P61ciUmLeFrvg7hYWuNNIa19niGuljDMpCdE/PSrEQm405YVnuG5iPb/a2J
MomRI9NZaAEfS6lQOnT7VkbklfIfpwCLfBEDvaJ2jf7Hr9yVZ1EV7DWxORhwTej8
YeagHh+aa+ZPMb7utcYWh7WubPAIL6XJc4CfPLUC9t4pAkF5gvkpJgy/NKN9EbbD
GRdFBaLNGydRIFMVa+jUj0Bt/kJXVsrJll5hLyXhsuK0eRQFTfr0VW+P6HVZxgF5
Ng679gjteL5ncIGZ/3K5GRlXy+RmkzgQ3WIXvAuZlUgsMeFvuAJEG+xZ4fJh777r
MFv1DlNWEdqqLlB2R3fZVSx3lo8jC+843Zo6BuYtU9nuz/p/pdZPwc83CD/nSnMx
T/uRtjhCELeTOTPfExDocknxytPpiJ1pBsH2EwbekjUc4D3GCDxKBpm778r1SdpZ
WZABAO9l0vqdJFgHtcPbzZeDmbuHkXH7EQ7FmCLN9U07E3zcF1ZgzjIcFj8Y+/I1
gQtc7Ax71nuA7Sf2kaV2gq8AxJ7aqqx6egv0MJJVnM3H9lsUwAy6GUtqENawc2C1
reWQKxn0YBE=
=T1oh
-----END PGP SIGNATURE-----

--=-1DEagpIxRXNph4kijUnA--

