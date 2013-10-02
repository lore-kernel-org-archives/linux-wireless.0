Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from cora.hrz.tu-chemnitz.de ([134.109.228.40]:55005 "EHLO
	cora.hrz.tu-chemnitz.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754248Ab3JBMkK (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 2 Oct 2013 08:40:10 -0400
Date: Wed, 2 Oct 2013 14:40:06 +0200
From: Simon Wunderlich <simon.wunderlich@s2003.tu-chemnitz.de>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: Simon Wunderlich <simon.wunderlich@s2003.tu-chemnitz.de>,
	linux-wireless@vger.kernel.org,
	Mathias Kretschmer <mathias.kretschmer@fokus.fraunhofer.de>,
	Simon Wunderlich <siwu@hrz.tu-chemnitz.de>
Subject: Re: [PATCH 2/4] nl80211/cfg80211: enable DFS for IBSS mode
Message-ID: <20131002124006.GA23903@pandem0nium> (sfid-20131002_144018_312927_1C9D3834)
References: <1378230201-25446-1-git-send-email-siwu@hrz.tu-chemnitz.de>
 <1378230201-25446-3-git-send-email-siwu@hrz.tu-chemnitz.de>
 <1380625757.14430.22.camel@jlt4.sipsolutions.net>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="XsQoSWH+UP9D9v3l"
In-Reply-To: <1380625757.14430.22.camel@jlt4.sipsolutions.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--XsQoSWH+UP9D9v3l
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, Oct 01, 2013 at 01:09:17PM +0200, Johannes Berg wrote:
> On Tue, 2013-09-03 at 19:43 +0200, Simon Wunderlich wrote:
> > To use DFS in IBSS mode, userspace is required to react to radar events.
> > It can inform nl80211 that it is capable of doing so by adding a
> > NL80211_ATTR_CONTROL_PORT_DFS attribute when joining the IBSS.
>=20
> I don't like that name, it makes no sense. This has nothing to do with
> the port control (802.1X-style) at all.
>=20

How about NL80211_ATTR_DFS_CAPABLE instead?


> > If this attribute is supplied, DFS channels may be used if the driver
> > supports it. Support will be checked even if a channel without DFS will
> > be joined, as the channel might change later due to scan activity or
> > channel switch announcements.
>=20
> You also really should document *what* is required of userspace here.
> You're kinda saying this needs to be implemented, but not saying what
> needs to be done. I can't even tell - what does it really have to do?

Yeah, I should document this a little more: Userspace should react to
radar events and apprioately switch the channel when this happens. As
non-capable tools (like wpa_supplicant in it's current state) do not
react on radar events but might select DFS channels when available, there
might be non-conforming behaviour. Therefore I'm introducing this flag.

Userspace programs are supposed to set this flag when they have channel
management and radar avoidance/channel change functionality is implemented
to unlock DFS channels.

> Don't you implement most of it in patches 3 and 4 anyway in the kernel?

Nope, I don't.

I can resend the patchset with some more documentation on this.

Thanks,
	Simon

--XsQoSWH+UP9D9v3l
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iEYEARECAAYFAlJMFCYACgkQrzg/fFk7axZPnQCg5fw/1QPkRQjVdM3cTqniPaVB
wzUAnR0+n8JiTBytxvMOduHOOKP49PzZ
=IgOH
-----END PGP SIGNATURE-----

--XsQoSWH+UP9D9v3l--
