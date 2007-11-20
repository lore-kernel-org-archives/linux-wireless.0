Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from crystal.sipsolutions.net ([195.210.38.204]:56942 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755105AbXKTO7J (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 20 Nov 2007 09:59:09 -0500
Subject: Re: [PATCH 1/1] mac80211: restructuring data Rx handlers
From: Johannes Berg <johannes@sipsolutions.net>
To: Ron Rindjunsky <ron.rindjunsky@intel.com>
Cc: linville@tuxdriver.com, linux-wireless@vger.kernel.org,
	flamingice@sourmilk.net, tomas.winkler@intel.com
In-Reply-To: <c85cb4470711200650p3a90955aha2825676ee31c4c6@mail.gmail.com> (sfid-20071120_145029_210134_F65064CF)
References: <11954792971872-git-send-email-ron.rindjunsky@intel.com>
	 <1195503670.19479.20.camel@johannes.berg>
	 <c85cb4470711200650p3a90955aha2825676ee31c4c6@mail.gmail.com>
	 (sfid-20071120_145029_210134_F65064CF)
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-6Fo6zxFhNgF32iju7Z+R"
Date: Tue, 20 Nov 2007 16:00:22 +0100
Message-Id: <1195570822.10920.50.camel@johannes.berg> (sfid-20071120_145912_686806_B5580991)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-6Fo6zxFhNgF32iju7Z+R
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable


> > > -int ieee80211_is_eapol(const struct sk_buff *skb);
> > > +int ieee80211_is_eapol(const struct sk_buff *skb, int hdrlen);
> >
> > That's just an optimisation, right?
>=20
> main reason is that ieee80211_is_eapol is called both in Tx and Rx
> flows, so the caller is reaponsible for passing the header length
> (802.3 in Rx and 802.11 in Tx).

Right. I noticed later but forgot to remove the comment.

> > Any reason you're getting rid of the MAC printk? It's a debug-only
> > message so whatever, just curious really.
> >
>=20
> as ieee80211_802_1x_pae is not a 802.11 specific any more, it has no know=
ledge
> about the header, therefore no knowledge about mac address. I could
> pass to it the mac address as well, but looks odd to do that only for
> debug printing.

Oh ok, right.

> > > +     if (ieee80211_data_to_8023(rx) =3D=3D TXRX_DROP)
> > > +             return TXRX_DROP;
> > > +     if (ieee80211_802_1x_pae(rx, sizeof(struct ethhdr)) =3D=3D TXRX=
_DROP)
> > > +             return TXRX_DROP;
> > > +     if (ieee80211_drop_unencrypted(rx, sizeof(struct ethhdr)) =3D=
=3D TXRX_DROP)
> > > +             return TXRX_DROP;
> >
> > The sizeof() doesn't look right, shouldn't that get the hdrlen from the
> > frame control? Ah, no, I see now, it's already converted at this point.
> > Do we need to pass the hdrlen at all then? I think it would make sense
> > to specify (in comments) that those functions get a converted (to 802.3
> > framing) skb instead. And then hardcode the frame offsets/header length=
.
>=20
> those functions can be used now for 802.11 or 802.3 frames so caller
> should pass header length for them
>=20
> >
> > Also, I think the return value of those functions shouldn't be the
> > txrx_result but rather just a bool.
> >
>=20
> Hmmm... yes, it will probebly look better. i'll just do a slight
> change in function's names so it will be clearer to reader.

Great, thanks.

> > I think it would make sense to have another function
> > ieee80211_is_eapol_checked(tx->skb) that does the hdrlen calculation to
> > save doing it unconditionally here for the (common) case where we're
> > using a sta or default key.
>=20
> I agree, thanks for the remark.
> Yet, i wouldn't like to add another function that does basically the
> same as ieee80211_is_eapol (or sending an indication for
> ieee80211_is_eapol about header type what will lessen its
> flexsibility)
> I was thinking to move ieee80211_get_hdrlen to:
> ieee80211_is_eapol(tx->skb, ieee80211_get_hdrlen(fc))
> this way i keep flexibility in ieee80211_is_eapol and won't calculate
> header length unless really needed.

Oh sure, that works too. I guess you could inline all of it even
ieee80211_is_eapol(tx->skb,
                   ieee80211_get_hdrlen(le16_to_cpu(hdr->frame_control)))

But yeah, whatever, I'm not concerned about the byteswap.

johannes

--=-6Fo6zxFhNgF32iju7Z+R
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIVAwUAR0L2haVg1VMiehFYAQL6KhAAoYI6Z65Pz7JATttVhQgrbOyyoeLhkJeQ
uO1RaZulhoA37qTgOb99Z2OI4wOoIaSdo3Mq9Vf2B3Yh/eLT0cT1+mFXgfyVdryv
em8PzY4/aZ2kV718Dn2NNd8/NGKuEVKkjPXTmzryluj3f3o37p/aTu/PlOGb9wHI
dDGMs1pw9ex5FMQ4lqqRUXB+TtRnWEDM7Oi3YfpJNz1Z6zZ0gajhpMPiFNHDmUOZ
onYYhYFAG6w5mnNmZ5u0uOU9INLY/0ADoa+/Uyla6UB3zfC45NWKV2hGWx8+uB8n
NlpfQnNboXxOqOfw+PB3XtgC+TCNBA+EDHfMV2HPH9Cl1sMeGsbXcYy09794PzMc
AafbwhpbkdGEUdxu+YNQAUvuUYcTBuDl3V3WeSUO9z4Wge9O9uB7V7lQAi6cGPg6
vOkHbdSMn87IxfjSRkvC32DHMmK/zp2tIb7+lcpJGxMzsIPbLIac+aI5XFu4mcFf
yehs3lktTqFC1uOLQNKdq8dGzKKYvuslxJPnZcoC95FBZmpcvhWYesO/73ncxatr
nd3Iv3MahwGM7OAeXeM1pdCcg/4edC0xRlya8Bxc+bKBDMP1NnXpPqk0aYnKdWH2
4puywB+V60kVUvEmNHt2kf1sGwmFnCtmGuX8nhhe1n38UfHA5NmGVrPFfA2c0Ufr
yfaEJGeD+tY=
=k0nr
-----END PGP SIGNATURE-----

--=-6Fo6zxFhNgF32iju7Z+R--

