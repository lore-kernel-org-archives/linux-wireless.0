Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:35228 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751515AbZK3Lwa (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 30 Nov 2009 06:52:30 -0500
Subject: Re: [PATCH] mac80211: remove payload alignment warning
From: Johannes Berg <johannes@sipsolutions.net>
To: Kalle Valo <kalle.valo@iki.fi>
Cc: linux-wireless@vger.kernel.org
In-Reply-To: <20091130103908.30420.40019.stgit@tikku>
References: <20091130103908.30420.40019.stgit@tikku>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="=-fW27W5zvHbp00EFOZVQa"
Date: Mon, 30 Nov 2009 12:51:08 +0100
Message-ID: <1259581868.32171.12.camel@johannes.local>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-fW27W5zvHbp00EFOZVQa
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Mon, 2009-11-30 at 12:39 +0200, Kalle Valo wrote:
> From: Kalle Valo <kalle.valo@nokia.com>
>=20
> The payload alignment warning enabled by MAC80211_DEBUG_PACKET_ALIGNMENT =
is
> difficult. To fix it, a firmware change is needed but in most cases that'=
s
> very difficult. So the benefit from the warning is low and most probably
> it just creates more confusion for people who just enable all warnings
> (like it did for me).
>=20
> Remove the unaligned IP payload warning and the kconfig option. But
> leave the unlialigned packet warning, it will be enabled with
> MAC80211_VERBOSE_DEBUG.
>=20
> Signed-off-by: Kalle Valo <kalle.valo@nokia.com>

Thanks.

Acked-by: Johannes Berg <johannes@sipsolutions.net>

> ---
>  net/mac80211/Kconfig |   12 ------------
>  net/mac80211/rx.c    |   27 +++++++--------------------
>  2 files changed, 7 insertions(+), 32 deletions(-)
>=20
> diff --git a/net/mac80211/Kconfig b/net/mac80211/Kconfig
> index a10d508..a952b7f 100644
> --- a/net/mac80211/Kconfig
> +++ b/net/mac80211/Kconfig
> @@ -96,18 +96,6 @@ menuconfig MAC80211_DEBUG_MENU
>  	---help---
>  	  This option collects various mac80211 debug settings.
> =20
> -config MAC80211_DEBUG_PACKET_ALIGNMENT
> -	bool "Enable packet alignment debugging"
> -	depends on MAC80211_DEBUG_MENU
> -	---help---
> -	  This option is recommended for driver authors and strongly
> -	  discouraged for everybody else, it will trigger a warning
> -	  when a driver hands mac80211 a buffer that is aligned in
> -	  a way that will cause problems with the IP stack on some
> -	  architectures.
> -
> -	  Say N unless you're writing a mac80211 based driver.
> -
>  config MAC80211_NOINLINE
>  	bool "Do not inline TX/RX handlers"
>  	depends on MAC80211_DEBUG_MENU
> diff --git a/net/mac80211/rx.c b/net/mac80211/rx.c
> index 57b8a0a..18a0248 100644
> --- a/net/mac80211/rx.c
> +++ b/net/mac80211/rx.c
> @@ -361,7 +361,9 @@ static void ieee80211_parse_qos(struct ieee80211_rx_d=
ata *rx)
>   * boundary. In the case of regular frames, this simply means aligning t=
he
>   * payload to a four-byte boundary (because either the IP header is dire=
ctly
>   * contained, or IV/RFC1042 headers that have a length divisible by four=
 are
> - * in front of it).
> + * in front of it).  If the payload data is not properly aligned and the
> + * architecture doesn't support efficient unaligned operations, mac80211
> + * will align the data.
>   *
>   * With A-MSDU frames, however, the payload data address must yield two =
modulo
>   * four because there are 14-byte 802.3 headers within the A-MSDU frames=
 that
> @@ -375,25 +377,10 @@ static void ieee80211_parse_qos(struct ieee80211_rx=
_data *rx)
>   */
>  static void ieee80211_verify_alignment(struct ieee80211_rx_data *rx)
>  {
> -	struct ieee80211_hdr *hdr =3D (struct ieee80211_hdr *)rx->skb->data;
> -	int hdrlen;
> -
> -#ifndef CONFIG_MAC80211_DEBUG_PACKET_ALIGNMENT
> -	return;
> +#ifdef CONFIG_MAC80211_VERBOSE_DEBUG
> +	WARN_ONCE((unsigned long)rx->skb->data & 1,
> +		  "unaligned packet at 0x%p\n", rx->skb->data);
>  #endif
> -
> -	if (WARN_ONCE((unsigned long)rx->skb->data & 1,
> -		      "unaligned packet at 0x%p\n", rx->skb->data))
> -		return;
> -
> -	if (!ieee80211_is_data_present(hdr->frame_control))
> -		return;
> -
> -	hdrlen =3D ieee80211_hdrlen(hdr->frame_control);
> -	if (rx->flags & IEEE80211_RX_AMSDU)
> -		hdrlen +=3D ETH_HLEN;
> -	WARN_ONCE(((unsigned long)(rx->skb->data + hdrlen)) & 3,
> -		  "unaligned IP payload at 0x%p\n", rx->skb->data + hdrlen);
>  }
> =20
>=20
> @@ -1512,7 +1499,7 @@ ieee80211_deliver_skb(struct ieee80211_rx_data *rx)
>  	if (skb) {
>  		int align __maybe_unused;
> =20
> -#if defined(CONFIG_MAC80211_DEBUG_PACKET_ALIGNMENT) || !defined(CONFIG_H=
AVE_EFFICIENT_UNALIGNED_ACCESS)
> +#ifndef CONFIG_HAVE_EFFICIENT_UNALIGNED_ACCESS
>  		/*
>  		 * 'align' will only take the values 0 or 2 here
>  		 * since all frames are required to be aligned
>=20
>=20


--=-fW27W5zvHbp00EFOZVQa
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----

iQIcBAABAgAGBQJLE7GjAAoJEODzc/N7+QmaMyoQAIOaupYOCVAkZSnXJz5Evsuz
b4czXwIL373rKVDmifF5aTtOVSUFfJWt7UNkXWSAk0XFKKIKi4UUaAGBWOW6cVrX
yO2mMS3XKKsZwXAJWRrtQiMazLkOGPFJAkEZR1vdJ+OCiXvnpF46Ahhm42KjxssA
vZeg0IEXW+EApCSNfFJ/pa4ZIShigzGVkRGYoLkElfe/c462+bpLsxgsejtzdnJA
OYbPrwy/UnWGByOSqfxTxl0h+UDnoQ5tcYDvH8kmXmMs5dJB+qlQD/gYqR0xDlcs
1FhDuATwqLqSbU/QcDoqmJrlxcviZ5B+Sn4SiHWZ9NmTKqFyuvV0A9MvK5EOEzMO
H6B6R/ovWC9ekNv+Bal2JG7nGpLFUC2k6siz+w235vBbbPOPY37gtk4qO6LrkpCv
RqRNU07X7L2sSOL1HvLTO4NlNx10xP/rqEJkTHr/OkQMtZI11fg59qWEMoNuvJme
NtGqoWZF7V4EyXCzPixq9U/j30FzVfXQNzAS9zjYhRiDe1WNiOwAv+W/tGJh395v
7dxk4HswswVhsId/aILNuYb/l01Ton3WlWKbJbA7PmrTWVVrvGbNp6i+ASgDw49G
QTWfkxs43BTt+YdH2gfDQWeEcmQcrhlskHCIb1tfnV+Dt8fDyeDZIhA2E5bDx5Ua
3BX0WIFfCS89eowLId4K
=wp4y
-----END PGP SIGNATURE-----

--=-fW27W5zvHbp00EFOZVQa--

