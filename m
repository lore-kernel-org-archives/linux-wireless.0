Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:52559 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751140AbYESMmZ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 19 May 2008 08:42:25 -0400
Subject: Re: [PATCHv2] mac80211: fix NULL pointer dereference in
	ieee80211_compatible_rates
From: Johannes Berg <johannes@sipsolutions.net>
To: Tomas Winkler <tomasw@gmail.com>
Cc: Helmut Schaa <hschaa@suse.de>,
	John Linville <linville@tuxdriver.com>,
	Larry Finger <Larry.Finger@lwfinger.net>,
	linux-wireless@vger.kernel.org
In-Reply-To: <1ba2fa240805180337h35bc3244od619e78c0d95d895@mail.gmail.com> (sfid-20080518_123728_719792_B4AF8DFE)
References: <20080517203531.vus3gj5ce8ksskkc@imap.suse.de>
	 <1ba2fa240805180337h35bc3244od619e78c0d95d895@mail.gmail.com>
	 (sfid-20080518_123728_719792_B4AF8DFE)
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-/mDnJcaT3XES+xKsgSMw"
Date: Mon, 19 May 2008 14:41:08 +0200
Message-Id: <1211200868.6252.37.camel@johannes.berg> (sfid-20080519_144642_822004_E3FC7607)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-/mDnJcaT3XES+xKsgSMw
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable


> Again, mac should rather solve the problem that we do not connect to
> AP's that are not in the BSS list

You're talking about this a lot without showing any willingness to work
on it. Personally, I don't care so I'm not going to work on making this
a valid assertion, obviously it is not.
=EF=BB=BF
> The other issue is that we call ieee80211_rx_bss_put(dev, bss); before
> this call in ieee80211_send_assoc.

Indeed, we (i.e. not just me!) should have caught this at the time the
original patch was merged.

Helmut, can you please make a patch that addresses both issues by
instead moving the compatible rates check into the "if (bss)" part in
ieee80211_send_assoc() right after ieee80211_rx_bss_get()? And you can
make "u64 rates =3D ~0;" the default to address the !bss case.

johannes

--=-/mDnJcaT3XES+xKsgSMw
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIVAwUASDF1Y6Vg1VMiehFYAQLFSg//TIPrkogchWh7HKX8CyDH8rzHflAY7Wma
cwoNgqe9veiAAmsuJo6tpiX618vkdDM+yPcZ+w3QyVWQBg9hPED5HDMh7ws8DnyW
cP+QSW/gBie0B9Tq/+V1aDNLz1c9RpNPcqublwfgZ4IIivzY++BUigtNbIOK2/4k
6S/5tKcv8MQNpJbUuH/eYs5wBoyLvdTP3sswCmqainkajRcJpkpDmWAJSrYuj3RH
QPsc7c8LuYi0HMYE7kPLPmwJWHtH20OH533O6XGeLiCP29aKOEzk9hwG49GrBSaM
GO2ld58eVJWMQxrTWiuoitwAEIuz1Z4vGgBAM/F4swgVIWo7m5+C9B/xcvTtEUlQ
6vAf0pKyGxIvDjT9Rb+D3aQXalRgMGOG7ZtZxIDxt+3LFhiTiP82PT0fPEpVMBvA
oEDLRSOXBwjBsjfQlxgeDaC8MMAUL6HRLULawFc/qqEPyyUI28DMlF+TQ/JSXwvA
9NNCIG6kvJa7q+J5P5BOb3/2x2wRKvWgzoqYnrNpYzeB7kPEDoeHe/mLQ+gvrdF3
gpbdPy/St7ihgg70IfpYrRRet6i8nynpuHPBL0jszv89XlwojS5U4qabGSVIxJwh
Tcu5qhEdwz6tgeHW0h78ARCqUWtMazUyDuUIay46ts4HU36Ipvxrbn6DEyd3sT/9
R9NLqqx6pVI=
=NMM5
-----END PGP SIGNATURE-----

--=-/mDnJcaT3XES+xKsgSMw--

