Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:48949 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753683AbYIGNtG (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 7 Sep 2008 09:49:06 -0400
Subject: Re: [PATCH 2/2 V2] mac80211: add direct probe before association
From: Johannes Berg <johannes@sipsolutions.net>
To: Tomas Winkler <tomasw@gmail.com>
Cc: linville@tuxdriver.com, yi.zhu@intel.com,
	linux-wireless@vger.kernel.org,
	Ron Rindjunsky <ron.rindjunsky@intel.com>
In-Reply-To: <1ba2fa240809061721k2082d038j63c272f5b29a66c6@mail.gmail.com> (sfid-20080907_022142_614088_FF8C10FE)
References: <1218240139-5009-1-git-send-email-tomas.winkler@intel.com>
	 <1220744663.21016.28.camel@johannes.berg>
	 <1ba2fa240809061721k2082d038j63c272f5b29a66c6@mail.gmail.com>
	 (sfid-20080907_022142_614088_FF8C10FE)
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-8UilL9GR3V/bgzmwwOyP"
Date: Sun, 07 Sep 2008 15:49:00 +0200
Message-Id: <1220795340.31304.10.camel@johannes.berg> (sfid-20080907_154918_366016_44B598D0)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-8UilL9GR3V/bgzmwwOyP
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Sun, 2008-09-07 at 03:21 +0300, Tomas Winkler wrote:
> On Sun, Sep 7, 2008 at 2:44 AM, Johannes Berg <johannes@sipsolutions.net>=
 wrote:
> > Hi,
> >
> > I was just pondering rewriting parts of the state machine (and you've
> > already seen the other cleanups I did today) and found this:
> >
> >> +     /* Direct probe is sent to broadcast address as some APs
> >> +      * will not answer to direct packet in unassociated state.
> >> +      */
> >> +     ieee80211_send_probe_req(dev, NULL,
> >> +                              ifsta->ssid, ifsta->ssid_len);
> >
> >> +     /* direct probe may be part of the association flow */
> >> +     if (test_and_clear_bit(IEEE80211_STA_REQ_DIRECT_PROBE,
> >> +                                                     &ifsta->request)=
) {
> >> +             printk(KERN_DEBUG "%s direct probe responded\n", dev->na=
me);
> >> +             ieee80211_authenticate(dev, ifsta);
> >
> > Doesn't the latter code have to check that the sender is the correct
> > one? First we broadcast the probe request, and then we may be getting
> > one from a different AP but still clear our direct probe association
> > flow step, no?
>=20
> Yep, this is not covered. Don't remember why it wasn't straight
> forward to implement...will look at it again after sunrise.

Actually, don't bother, I'm fixing it, was just trying to see if I was
missing anything and it was correct already.

johannes

--=-8UilL9GR3V/bgzmwwOyP
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIcBAABAgAGBQJIw9vIAAoJEKVg1VMiehFYd28QAJRF9FhLjlqX2WqXh7Fj/xMj
QLPprOWv7akU3tUC0vFswH2wL0GXe1DzYhA1qsolLcmeP9dU3LN8SwtsOQ/C1xIe
62r3hFHVIOXAy8NuseAkFKUF8YfcvrTuYI3pdOkKPw15RPWfka7H+wnCt8INl5A9
oHFuXoEI5iD0/+qMYKcpHoatzDnm+PstP5fbBAZed/23LuqnprkF0zrLCNFUx1kq
JkkdjtcjVO4kN0QtBDIzfSDHoLEMPkEXMYdSnyFWAftZSlVFaQyYNuZyNCu2MqxR
gcHjERA+WT4DCBetIjW6cHB8aGtg6jMxz03zfSFJwneW0VRVAHkvY2fo8NRRdUG4
h82kWla2kX3aiLu3MQdAsZcjre4M7lu5qCn5+7Yg8aRklHpGJlhI4Kjy6fSrtMSR
rq/HXDQu/LpvLDtDN5JEpKu5ZqgrIGyYAZh7Fl6Ub/HXST5LK3EdFtMjhbVaAzgh
/pht9ynK+X+5Xx3ECKFQYl8407CWLyUcsx+BO4cx6w2++UFSJtVHsfIDZ3Eewiao
blY2yoO5xrkGodugLuEG2hdP72+k2sO9/9OkxYVPphEsta6auLMc6FzSs7SPIovT
J52RSI5H7tOS60+On/TlWrs7ntEkzrjmWhJk1HX3NBj5IHJ/5lk436+eURabBMso
s2gaFqTLwCqthvqK28xS
=+xIC
-----END PGP SIGNATURE-----

--=-8UilL9GR3V/bgzmwwOyP--

