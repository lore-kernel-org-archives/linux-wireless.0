Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:56682 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753913AbYETM6n (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 20 May 2008 08:58:43 -0400
Subject: Re: [PATCHv5] mac80211: fix NULL pointer dereference in
	ieee80211_compatible_rates
From: Johannes Berg <johannes@sipsolutions.net>
To: Tomas Winkler <tomasw@gmail.com>
Cc: Helmut Schaa <hschaa@suse.de>,
	John Linville <linville@tuxdriver.com>,
	Larry Finger <Larry.Finger@lwfinger.net>,
	linux-wireless@vger.kernel.org
In-Reply-To: <1ba2fa240805200554w9354d14v9abc70f676540b9b@mail.gmail.com> (sfid-20080520_145427_097098_2E2CBB5A)
References: <20080520095637.2cq5p5ohhc8440o4@imap.suse.de>
	 <1ba2fa240805200554w9354d14v9abc70f676540b9b@mail.gmail.com>
	 (sfid-20080520_145427_097098_2E2CBB5A)
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-cmrIPJop+5c1r5EU63YM"
Date: Tue, 20 May 2008 14:57:31 +0200
Message-Id: <1211288251.6252.86.camel@johannes.berg> (sfid-20080520_145846_640351_E6B8FE62)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-cmrIPJop+5c1r5EU63YM
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Tue, 2008-05-20 at 15:54 +0300, Tomas Winkler wrote:
> On Tue, May 20, 2008 at 10:56 AM, Helmut Schaa <hschaa@suse.de> wrote:
> > Fix a possible NULL pointer dereference in ieee80211_compatible_rates
> > introduced in the patch "mac80211: fix association with some APs". If n=
o bss
> > is available just use all supported rates in the association request.
> >
> > Signed-off-by: Helmut Schaa <hschaa@suse.de>
> > ---
> >
> > diff --git a/net/mac80211/mlme.c b/net/mac80211/mlme.c
> > index 76ad4ed..3f7f92a 100644
> > --- a/net/mac80211/mlme.c
> > +++ b/net/mac80211/mlme.c
> > @@ -721,7 +721,17 @@ static void ieee80211_send_assoc(struct net_device
> > *dev,
> >                        capab |=3D WLAN_CAPABILITY_PRIVACY;
> >                if (bss->wmm_ie)
> >                        wmm =3D 1;
> > +
> > +               /* get all rates supported by the device and the AP as
> > +                * some APs don't like getting a superset of their rate=
s
> > +                * in the association request (e.g. D-Link DAP 1353 in
> > +                * b-only mode) */
> > +               rates_len =3D ieee80211_compatible_rates(bss, sband, &r=
ates);
> > +
> >                ieee80211_rx_bss_put(dev, bss);
> > +       } else {
> > +               rates =3D ~0;
> > +               rates_len =3D sband->n_bitrates;
> >        }
> >
> >        mgmt =3D (struct ieee80211_mgmt *) skb_put(skb, 24);
> > @@ -752,10 +762,7 @@ static void ieee80211_send_assoc(struct net_device
> > *dev,
> >        *pos++ =3D ifsta->ssid_len;
> >        memcpy(pos, ifsta->ssid, ifsta->ssid_len);
> >
> > -       /* all supported rates should be added here but some APs
> > -        * (e.g. D-Link DAP 1353 in b-only mode) don't like that
> > -        * Therefore only add rates the AP supports */
> > -       rates_len =3D ieee80211_compatible_rates(bss, sband, &rates);
> > +       /* add all rates which were marked to be used above */
> >        supp_rates_len =3D rates_len;
> >        if (supp_rates_len > 8)
> >                supp_rates_len =3D 8;
> >
> >
>=20
> I found one  ieee80211_rx_bss_{get,put} imbalance   in
> ieee80211_sta_join_ibss function
> That may cause this problem yet it doesn't look like this is the case.
> ieee80211_sta_join_ibss
> calls ieee80211_rx_bss_put on 'bss' that it receives as an argument
> Keep searching.

Hm. Send a patch? :)

> I suggest to insert at least some WARN_ON(1) for the else case.

Disagree, not until somebody audits the code. We already know it can
happen and a WARN() won't help us track it down because it provides no
additional information (stack trace is useless)

johannes

--=-cmrIPJop+5c1r5EU63YM
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIVAwUASDLKuqVg1VMiehFYAQLJUw/+PLflhScrjrssO2Ybxp2+H9B6QeB6LJ6B
y1Zce0rvWdoKgkcnBNghHEU3fkRdmXibjwP8MhoIakN+QPTX2tsGSI7pwc8HHvaD
nH/woRdR2PMLps6Idvwyr2Yl1AaMHxyLorruPa4IAngPf/lKdUmn7YS+ldKRD8MM
rlqYEMRLAAPhtXZLW7085nyMODuZ8uApTgzo+Yng0tHUzEEuOmtLxUNICq9mFEYt
mkIpKgiZIHmEnPM3Ap/+4iZQdwbIv6CbiSK2s8wxNErT/RA3G6AVFeJonXj/GLvi
yqhNxfZr4iT8KIUWj5jkXs3PWPn532ENInhF+zNNcdiRuJcvUfPEaN2j1NjCsJ+Q
t9KhjD6V/yiXEV+oNh8ZxY3r3h9nLhzHmyVSewo3JymkvhcxapWEgts3C24XUS/P
6eqJviuORSZmHW3VQ9bbNN8G2BINaylVKvudOAF2fgg4an5cTgo3JJQjpsuLaoTL
B+MADIw1T30XNsfl7OThARqiPWyUBnibZS8/+d+esWca7y2PJ1bSzXttTzjUwtsu
AA7dYnd9OGx7QBkp5JJ/R7Bi1sfwYfG9F0DdX9dS+lfPQf1kLIeJROWSmraPGq7j
H908g0/FuiZ0zu9TiZBRZOnYJxIH8xFdXYzpYxd8KrLYbMYsv7cXEI2z7DSGOyxz
ufMzP2pZlNs=
=A73s
-----END PGP SIGNATURE-----

--=-cmrIPJop+5c1r5EU63YM--

