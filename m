Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:59527 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752765AbYJGR1R (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 7 Oct 2008 13:27:17 -0400
Subject: Re: [PATCH 2/4] mac80211: add multi-rate retry support
From: Johannes Berg <johannes@sipsolutions.net>
To: Felix Fietkau <nbd@openwrt.org>
Cc: linux-wireless <linux-wireless@vger.kernel.org>,
	Derek Smithies <derek@indranet.co.nz>,
	Nick Kossifidis <mickflemm@gmail.com>,
	"Luis R. Rodriguez" <mcgrof@gmail.com>
In-Reply-To: <48EB98A6.4050406@openwrt.org>
References: <48E8E48E.5090300@openwrt.org> <48E8E528.7060501@openwrt.org>
	 <48E8E588.30001@openwrt.org> <1223329786.3778.38.camel@johannes.berg>
	 <48EB98A6.4050406@openwrt.org>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-YEpu/4mWzq6nY6hxHQCS"
Date: Tue, 07 Oct 2008 19:27:16 +0200
Message-Id: <1223400436.7328.54.camel@johannes.berg> (sfid-20081007_192720_880325_D56F69A0)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-YEpu/4mWzq6nY6hxHQCS
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Tue, 2008-10-07 at 19:13 +0200, Felix Fietkau wrote:
> Johannes Berg wrote:
> > On Sun, 2008-10-05 at 18:04 +0200, Felix Fietkau wrote:
> >> This patch adjusts the rate control API to allow multi-rate retry
> >> if supported by the driver. The ieee80211_hw struct specifies how
> >> many alternate rate selections the driver supports.
> >=20
> > Don't those drivers that announce supporting max_altrates =3D 1 have to
> > update the status for alternative rates too? Also, should
> > max_altrate_tries =3D=3D 0 indicate that that is fixed?
> IMHO yes.

Should we document that?

> > But b43 with the
> > default firmware actually _is_ capable of changing the number of retrie=
s
> > (default to 3/3 or 3/4 I think), just not per frame. Should we have tha=
t
> > in the API too?

> Minstrel won't use it, because the value that it selects is dependent
> on the rate that is to be used there. Maybe it'd make sense for other=20
> stuff, though.

No idea.

> When using MRR and the get_rate function determines that it's time to do
> some sampling, and the sampling rate it selected is lower than the calcul=
ated
> max throughput rate, it wouldn't make sense to put the sampling rate in t=
he
> first stage of the MRR chain, because that would lower the effective
> throughput unnecessarily.
>=20
> Instead it throws the sampling rate in the second stage of the MRR chain
> and increases a separate counter to prevent it from doing large bursts of
> sampling attempts.
>=20
> However if the hw never gets to the second MRR stage, because the first o=
ne
> worked just fine, it should not mark this as a successful sampling, becau=
se
> the sample rate was not actually attempted.

Heh, ok, I didn't really care about those details.

> The IEEE80211_TX_CTL_RATE_CTRL_PROBE flag is used to tell the tx_status
> function that there is a sampling rate in the second MRR stage, so that
> it can update the sampling counter accordingly, in case the sampling rate
> actually got used.

So if I read that correctly you're saying it's not part of the driver
API but just something to be preserved from tx to tx-status. Can you
document that in the header file too please?

johannes

--=-YEpu/4mWzq6nY6hxHQCS
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIcBAABAgAGBQJI65vwAAoJEKVg1VMiehFY7pYP/ibBnyHuyKp9y6HDfH9R/dYF
6KokfJ/6l7MXKYHmfqJh3l5EFHCaCJAneWR7k9BGc33MbLvz+P2AR3Te6fB9QSo0
mC2JkH5VRGLAcv7K3IWjJUmFvf1AHR7DnEnjaM/6bQtBvfCYDLvXhI7IOM5ATkI3
7pn4ECJrQuehWdByv0XozQF5JKatowL6inxmFyLwXUzeeJqSC7luMvd1TOrSi4K9
KiSxqOlEnEtaXHEiLx2HrgdGs6ekUbSpN2PHXhEv10Ivia1Aci4sXfVlxH2sbxGc
osG+ugReqjW4INSnK5R1wl9SWL64YNxADM8h4i9F+CusBR1ggx/JZxymxEuUNGBU
hDCmGiU0tRaqbuwbVhHjOy/JUInlUS8sZh8OB79PwFIFoLYzoM50k4erpF8dlBRQ
BKeDDXOXiFozf5hyApv6S6k6hppXhLnTPvUG28DP+Zy7uuqrHCWikRNSUT2WHBXL
B7jri5wLWMDG0HTCY3wZCmZhqSktUEVP2i4ip6AJq6oXR+tRExZPPXyhsNFDYbGV
qdjExeU59fdgJBCK+ZHHCp2VZxZzulb+etxNcfePwQgI3Xond96ZxVGePMCaOCZ/
/kZcyCaQxUP3fW5n+BRCqEBkM3erNZyjuI1hNysEonJF5UvBJkM65dMzf4XsKrmO
HVWkS7qLLFqVrAH8Nh9I
=zTON
-----END PGP SIGNATURE-----

--=-YEpu/4mWzq6nY6hxHQCS--

