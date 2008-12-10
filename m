Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:39709 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752467AbYLJNgq (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 10 Dec 2008 08:36:46 -0500
Subject: Re: [RFC]: atk5k: fix FCS corruption for ACKs
From: Johannes Berg <johannes@sipsolutions.net>
To: Bob Copeland <me@bobcopeland.com>
Cc: Patrick McHardy <kaber@trash.net>, linux-wireless@vger.kernel.org,
	Jiri Slaby <jirislaby@gmail.com>, mickflemm@gmail.com,
	mcgrof@gmail.com
In-Reply-To: <20081210132440.GA12873@hash.localnet> (sfid-20081210_142450_421041_6465C830)
References: <493F4DC5.9090801@trash.net>
	 <20081210132440.GA12873@hash.localnet>
	 (sfid-20081210_142450_421041_6465C830)
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-1bAmtDWquLuvFhWvWqnT"
Date: Wed, 10 Dec 2008 14:36:06 +0100
Message-Id: <1228916166.15837.0.camel@johannes.berg> (sfid-20081210_143650_535546_FE505D3C)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-1bAmtDWquLuvFhWvWqnT
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Wed, 2008-12-10 at 08:24 -0500, Bob Copeland wrote:

> It seems very plausible to me.  Though, why doesn't ath9k also have this
> problem?  Luis, it looks like in that case ath9k could trim two extra
> bytes if ath9k hw behaves the same.
>=20
> main.c:
>=20
>    951          /* see if any padding is done by the hw and remove it */
>    952          if (hdrlen & 3) {
>    953                  padsize =3D hdrlen % 4;
>    954                  memmove(skb->data + padsize, skb->data, hdrlen);
>    955                  skb_pull(skb, padsize);
>    956          }
>=20
>    957          /* remove FCS before passing up to protocol stack */
>    958          skb_trim(skb, (skb->len - FCS_LEN));

It also shouldn't remove the FCS, sometimes you want to see that on
wireshark and mac80211 handles removing the FCS itself just fine, just
set the HW flag.

johannes

--=-1bAmtDWquLuvFhWvWqnT
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIcBAABAgAGBQJJP8XCAAoJEKVg1VMiehFYqe0P/iwZ/t1DEaB93DwRs46RoHJv
bAFiMgDgG78NnRUynqVE+42EevBhp4Z/EzgstkfB5batJ+lQAC7Utz2CsAgPGyUG
iLHb77+M+Kx0/sCXOfhqDa9exNjEtKRExsjXdbwxZbSf9PfQh8PgXqmcO5OVu6JN
fqe8Lh2GoDaK9iSiPtn44hHEpQ3chayfeDKXKrRBrPT8651ibh+RXnIdFFfkzg4h
2vnV/siPaKchzxxna93VZ6IiOSj7ZqnkubBoqOGSiGATDUXFXlQUIIyC1QccEvO+
XSndrw9yjT5PiWJ1ZJJHNzlZFAOdACi/96frCVbO4HsmbUAWLUGzIFLuDcP8ZD12
uA22gGQx/nSH6DJfIMZPMUfo4RRPtS3H0L+cmH5tmCyv5DySIHNgWApS10EQ0SgY
eD2BaVqzCK25DzNTp41eD0k9Ttj3UsCiDX/2X7rcESEw2w9trDkWvVaFYbPsf0f1
k3cPAt+tKBqYV/ieNLVd6n7G/ou485YIsNOuPda7nLk0U/W0UKsq/VTMDl96IHos
K4AfdgCd+w/tsiYn4/OAdTI9yszAGhaklkYDBSzmmvOxgAEVQDF3C2Rr6Z1EKH33
oFKQH/JX+ZIlPvQLwtZBRlZNV4NOpLb9qvNug/O/+M9OQco5lgO2xR+CTiAn0mAp
nbqXbWjhwrypbG4PEH+P
=ezod
-----END PGP SIGNATURE-----

--=-1bAmtDWquLuvFhWvWqnT--

