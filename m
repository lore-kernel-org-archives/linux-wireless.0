Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:59545 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752836AbZA1SxF (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 28 Jan 2009 13:53:05 -0500
Subject: Re: [RFC PATCH v2 2/2] mac80211: use ps-poll when dynamic power
	save mode is disabled
From: Johannes Berg <johannes@sipsolutions.net>
To: Kalle Valo <kalle.valo@nokia.com>
Cc: vivek.natraj@gmail.com, linux-wireless@vger.kernel.org
In-Reply-To: <87hc3jgyu9.fsf@nokia.com>
References: <20090122114240.31443.18218.stgit@tikku>
	 <20090122114546.31443.79387.stgit@tikku>
	 <1232643729.5819.3.camel@johannes.local>  <87hc3jgyu9.fsf@nokia.com>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-lu1PfCUmHO8t7/Uz9BWG"
Date: Wed, 28 Jan 2009 19:52:17 +0100
Message-Id: <1233168737.4811.18.camel@johannes.local> (sfid-20090128_195323_624954_7C710144)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-lu1PfCUmHO8t7/Uz9BWG
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Wed, 2009-01-28 at 18:49 +0200, Kalle Valo wrote:

> > If we receive a frame, but don't send any, we'll still stay awake.
> > Should receiving update the dynamic timer as well, to avoid that case?
> > Here, I mean:
> >
> >> @@ -1816,9 +1851,24 @@ static void ieee80211_rx_mgmt_beacon(struct iee=
e80211_sub_if_data *sdata,
> > ...
> >> +                       if (local->hw.conf.dynamic_ps_timeout > 0) {
> >> +                               local->hw.conf.flags &=3D ~IEEE80211_C=
ONF_PS;
> >> +                               ieee80211_hw_config(local,
> >> +                                                   IEEE80211_CONF_CHA=
NGE_PS);
> >> +                               ieee80211_send_nullfunc(local, sdata, =
0);
>=20
> You mean case where directed_time is set, dynamic_ps_timeout is zero
> and station doesn't transmit anything? That's not a problem because in
> that case power save is not disabled at all, ps-poll is sent while
> power save mode is enabled. So there won't any problem.

No, I mean in the timeout > 0 case, what vivek mentioned too. We never
go back to sleep unless we send a packet.

johannes

--=-lu1PfCUmHO8t7/Uz9BWG
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIcBAABAgAGBQJJgKleAAoJEKVg1VMiehFYv4sQAMEU7v2IDGZ8acqt2e2V+XnK
hzJkQ85Nu4KPj+xO8dy28jJwbc/FJoBdRVcug5rdwft/oS10OeMfwEC4UNlPqShY
xxXI4UCaV597ywmGrrGHeiMO0XtPb8kCKJjrL80GuKhcF9ENkAgfmLfT6ysf5vE5
lyH0v1J/o0M7CegJSl9j3bGnWSY/VptUpe7x7rsLM1ouILiKKS1Zw7l3wK/ZHsLV
9p3v8TGxCo4VHx1w2gV36S2G++6pXDZXn9rElsKYL85l/g4VgQytmOFacul1mpCp
jhFpHti+MOeXhvc6rCc2rbm7W75ntRkE+t2Yo5lyElAFz/cmWHDfvqUpKJY9JP4Z
F3rcZ05EnW72BpjuBrA3M0qSZbC2GriMKgvPWNjMKPHw3pmKnX/UCtNDwpNulKb0
reTMYEKRtuo5rXfhmU1XWnOjAwPJ4BSyGIDhsTGsMuRf8RjltbHqF7zOfns43w2E
RtpkWWb05sM2B3bIfwAFrIGvcwfItzEBoiOXpfxHI5b/CDBCx2Y+9ijO6HvMbyta
1eZ/n2KdCkj+UgnAwTmUYPkKyVbdc/ou3XLj/vWmCBZiF0QZEiCvS7RIrj5mfWFe
HKEabLGJ6tDB/Wx0CmIdThSxA3iiVojTQhSaoasQKIi5bNNXmoBg08VeSxXYxEe2
fHf3oFiYvdmXh/G8ExGP
=R1mp
-----END PGP SIGNATURE-----

--=-lu1PfCUmHO8t7/Uz9BWG--

