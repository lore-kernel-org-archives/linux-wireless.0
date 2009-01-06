Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:45026 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753686AbZAFUFR (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 6 Jan 2009 15:05:17 -0500
Subject: Re: [PATCH v2 0/3] mac80211 suspend/resume
From: Johannes Berg <johannes@sipsolutions.net>
To: Marcel Holtmann <marcel@holtmann.org>
Cc: Dan Williams <dcbw@redhat.com>, Bob Copeland <me@bobcopeland.com>,
	linux-wireless@vger.kernel.org, mabbaswireless@gmail.com
In-Reply-To: <1231270575.14901.6.camel@californication>
References: <1229313039-5544-1-git-send-email-me@bobcopeland.com>
	 <1229336057.4471.9.camel@johannes.berg>
	 <1229354532.12163.24.camel@localhost.localdomain>
	 <20081217174244.M36761@bobcopeland.com>
	 <1230064216.31228.46.camel@johannes> <20081224054951.GA32398@hash.localnet>
	 <1230102989.16960.14.camel@californication>
	 <1231260306.14565.21.camel@localhost.localdomain>
	 <1231261937.5246.16.camel@californication>
	 <1231267979.14565.34.camel@localhost.localdomain>
	 <1231270575.14901.6.camel@californication>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-upS0ev3rq2PbWNUF0B/w"
Date: Tue, 06 Jan 2009 21:05:26 +0100
Message-Id: <1231272326.3767.2.camel@johannes> (sfid-20090106_210521_198745_709D13EC)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-upS0ev3rq2PbWNUF0B/w
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Tue, 2009-01-06 at 20:36 +0100, Marcel Holtmann wrote:

> since mac80211 gets suspend/resume support, I think it is the best that
> we signal this to wpa_supplicant. In that case it can do the hard work
> here. Either it re-connects to the last AP or signals a disconnected
> state or trigger scanning.

Let me just say once again that all this discussion is entirely
orthogonal to properly supporting suspend/resume in mac80211, it's
always possible for userspace to do anything with the devices before
going into suspend, but the kernel should take some care to resume as it
was at suspend time, which is what we're aiming for here. Of course,
this may mean that at resume we lose the AP connection that we think we
still have right away, but that's great since then wpa_supplicant will
reconnect quickly.

johannes

--=-upS0ev3rq2PbWNUF0B/w
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIcBAABAgAGBQJJY7mDAAoJEKVg1VMiehFYbgMP/jTR4z6qVhKVWzjcYQ/IGf8M
BLTKIFr53qEOAEBPLaqcT9OcJW5Fgo3S+mP5uLctkegwht25Ty6UMnMpgKs+Vw+1
S0urhZIhnwlQ2nVAlo1Sto+pNez1cVbnao2Sj9gzzXDooeqnv6YfBzkZmM6rLEek
uYBEr5IbU8f6YSTJPYm1WWGao1yGmTkUCRxc6IOl4sUPMQJSFiMj+bul/3svQQ+9
M/4PH2BSuot2aUx+NubbvQeTDem9SoFr/sDxvsub7Halpdrqd/k6gGrqkhQ9cRAZ
9T1tPp5wwmy52Qg0iBG0S0LkTRfHn49tpx03UtQ68/9xf8IcE6MvyANs8aXegfYh
WYWabScCKVDwARt7caeLJP+qAIDTvA/CtnPqwSNTOW4sjrMEKw0MTMUnwXEwBitE
1tZm12m0hLoU7rzBycIlOVeXWmeK/b+x5Bb3fc3jyqX/NqSHISy/thhRPhUPywh7
UxOS2GvMB4dSiSjPt5caZ7GfqRKLT7PmqmHV0xu4zFqNcgml2MTD9PtBKmn7FJXG
/fX+StHb4YhYcOavx7uq4o8BKsKVJ/f0hAcVv56ygZdtYqyavedjTUnPJNibKpqh
w7fa8ltNzDOPDugqleeTz31SNnZsJpGbnKonXkABBY9huCM71uOGYJsY7nVVc2b0
6A4Kxi1Gqi0r4P90Bcir
=fYyW
-----END PGP SIGNATURE-----

--=-upS0ev3rq2PbWNUF0B/w--

