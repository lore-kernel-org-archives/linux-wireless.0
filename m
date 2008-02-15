Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from crystal.sipsolutions.net ([195.210.38.204]:33348 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752351AbYBOMwe (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 15 Feb 2008 07:52:34 -0500
Subject: Re: [PATCH 1/3] mac80211: better definition of mactime
From: Johannes Berg <johannes@sipsolutions.net>
To: Bruno Randolf <bruno@thinktube.com>
Cc: ath5k-devel@lists.ath5k.org, mcgrof@gmail.com, jirislaby@gmail.com,
	mickflemm@gmail.com, linux-wireless@vger.kernel.org,
	linville@tuxdriver.com, flamingice@sourmilk.net, jbenc@suse.cz
In-Reply-To: <20080215070116.32461.80795.stgit@one>
References: <20080215070116.32461.80795.stgit@one>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-9QNgeKGW6reg+1MkD6Cz"
Date: Fri, 15 Feb 2008 13:52:19 +0100
Message-Id: <1203079939.8931.186.camel@johannes.berg> (sfid-20080215_125237_919690_18F0BC73)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-9QNgeKGW6reg+1MkD6Cz
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable


On Fri, 2008-02-15 at 16:01 +0900, Bruno Randolf wrote:
> define mactime as the time when the first data symbol arrived at the HW. =
the
> old definition was questionable because 802.11 defines timestamp only for
> beacon and probe response frames, and there it means the timestamp field.
>=20
> a stricter definition of mactime is necessary for correct merging of IBSS=
.
>=20
> note that it is up to the driver to convert whatever its hardware returns=
 to
> this definition. unfortunately we don't know for example when atheros har=
dware
> takes its rx timestamp exactly :(
>=20
> Signed-off-by: Bruno Randolf <bruno@thinktube.com>

Acked-by: Johannes Berg <johannes@sipsolutions.net>

> ---
>=20
>  include/net/mac80211.h |    3 ++-
>  1 files changed, 2 insertions(+), 1 deletions(-)
>=20
>=20
> diff --git a/include/net/mac80211.h b/include/net/mac80211.h
> index 460da54..1b807f4 100644
> --- a/include/net/mac80211.h
> +++ b/include/net/mac80211.h
> @@ -295,7 +295,8 @@ enum mac80211_rx_flags {
>   * The low-level driver should provide this information (the subset
>   * supported by hardware) to the 802.11 code with each received
>   * frame.
> - * @mactime: MAC timestamp as defined by 802.11
> + * @mactime: value in microseconds of the 64-bit Time Synchronization Fu=
nction
> + * 	(TSF) timer when the first data symbol (MPDU) arrived at the hardwar=
e.
>   * @band: the active band when this frame was received
>   * @freq: frequency the radio was tuned to when receiving this frame, in=
 MHz
>   * @ssi: signal strength when receiving this frame
>=20
>=20

--=-9QNgeKGW6reg+1MkD6Cz
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIVAwUAR7WLAqVg1VMiehFYAQLD6hAAiNQR/biV7Sgjk1PEPxlgxx73ecegD46W
zyd1K9ehws/0k7nwkEqfDis9p55U4lMG1RjwVWo7wZOz1M788PtpnjGWOa3O+jDg
guCbCR8EpP+9FU+lWkQc8/GoRRbFjg9xUanQoY9WA5QX3RmTbsBEgEAJJwSMC5ZY
q8QEyBOdSaANNN1D41Yovz982KvQbAkdUu55KQbR6mqADh7qf3awoVvMwpNnzMZp
UAsXxPSf/LwsIyFCL80GTph48zrEUTUHKq3CnW+8rDh9wAsRNnrJYCZjL6Xk+Jdy
/9F0nSy7APInpTJZBTNGirJYpc8SVobMhVYH9ZHrAG2K0kg8ozWdrMGhp40dpgnq
U4ihHS7sFjBtJp2rLfcS4FTvRaZc8ZP8AyDSJyGcxiz4YXr0sDHuyMwNU39R2dAu
tHIqSmLb5zscsDhKPrgPxtIYP3yLtEYNdUEtcBsLhPkDI/ydk51k6VkYscEuh+lL
uZJPycDNfpNh5WAgCl+Ru9k69iWZ2yP+wwdEQ/nxhpn/v9TnEWpDNXvDcmU14q1H
K2UveZrGV3/f/PsULWW2l6jLbMr6WXkUWrtpGOs/cOH+8gCBw3F29ljtuudMTDWX
OxAsfaHV2W4cqrrx+LWYabDoYsGeYpdabVzXot0daZjDSJzQTWlQtpvaRz4sPqRW
Jm9d6wurHWo=
=T13w
-----END PGP SIGNATURE-----

--=-9QNgeKGW6reg+1MkD6Cz--

