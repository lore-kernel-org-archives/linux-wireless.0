Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:45847 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750997AbZFVTIm (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 22 Jun 2009 15:08:42 -0400
Subject: Re: [PATCH 1/2 RFC] cfg80211: connect/disconnect API
From: Johannes Berg <johannes@sipsolutions.net>
To: Samuel Ortiz <sameo@linux.intel.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>,
	"Zhu, Yi" <yi.zhu@intel.com>
In-Reply-To: <20090622170409.GB30147@sortiz.org>
References: <20090622170409.GB30147@sortiz.org>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="=-DTuiJimn0TuqU936jy83"
Date: Mon, 22 Jun 2009 21:08:39 +0200
Message-Id: <1245697719.4184.1.camel@johannes.local>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-DTuiJimn0TuqU936jy83
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Mon, 2009-06-22 at 19:04 +0200, Samuel Ortiz wrote:

>  /**
> + * struct cfg80211_connect_params - Connection parameters
> + *
> + * This structure provides information needed to complete IEEE 802.11
> + * authentication and association.
> + *
> + * @channel: The channel to use or %NULL if not specified (auto-select b=
ased
> + *	on scan results)
> + * @bssid: The AP BSSID or %NULL if not specified (auto-select based on =
scan
> + *	results)
> + * @ssid: SSID
> + * @ssid_len: Length of ssid in octets
> + * @auth_type: Authentication type (algorithm)
> + * @assoc_ie: IEs for association request
> + * @assoc_ie_len: Length of assoc_ie in octets
> + * @control_port: Whether user space controls IEEE 802.1X port, i.e.,
> + *	sets/clears %NL80211_STA_FLAG_AUTHORIZED. If true, the driver is
> + *	required to assume that the port is unauthorized until authorized by
> + *	user space. Otherwise, port is marked authorized by default.

One question I just had -- if bssid is NULL, and the card selects the
BSSID, I suppose it will also roam by itself if it can [1]. Don't we
need a "roamed" event for that then, even if we're not yet adding a
->roam() call?

johannes

[1] yes, we need to have a way to export roaming capabilities of the
card to user space

--=-DTuiJimn0TuqU936jy83
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----

iQIcBAABAgAGBQJKP9a0AAoJEODzc/N7+Qmag6cP/iDzgSy5OdvzBqpMGvqW44CO
lG/CUrxN2wD3yHW74hB7pGr83zf9K1SjyW6ZO6Vrx0GpmUd6dEHB+9eFD9PwnuFp
RAdKZJPwnyzJB5JoADfcuNXCmJyst4KiQcqVUY5bs4RM09toh5eWktGrC6GRbcWR
FwMYteWeaxe9ACK/GzLOunyUrdn3Ved9bq3ItyazNV7cvH/rQBg8vUM2d+rTiO7E
nJGTW8yyykyRMouJmrOFYa9v0B/2ueBwnVQ3kYtzaLweoP/kd91u4IclT2kkHah7
cPtaN0ILf+gf/4rwxKZQyk4xps0aY9tbH0PsEW8mwZGdhk97pBmoOvQKBqW2xkUe
nr/e+V1bDqk2xOsCLzbanGjp7WmCrlMqFTopQsCmMhaa4yQzmoSVMuG6wxdKur3H
8dBIqBVqeLaddLEud6wJTPm0FZRc/3aHJ1pGbJTDk0Py/7OKK41VM+yG4zi4ZHef
649XFfFxqSu3LB3UMMq2qjWGE5eTE4sonwiNKiU5ShyoLYBkYH9+ApyMS/EB8rYm
zdcHBnc8t4ZZGIca4jJYeQhZaofzql39MCG/tkEO4itCWfH/8MLAPGdEWw2GadJG
9jvKp2PCK0Oe/d8lpc3NTimJXjdWvVy+TeTwKXYOrgaFMmHvXhpat4s0LMEvao15
tIG+gNlhHmqizprUAe+Y
=Cif0
-----END PGP SIGNATURE-----

--=-DTuiJimn0TuqU936jy83--

