Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from crystal.sipsolutions.net ([195.210.38.204]:42790 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752064AbXKUPQL (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 21 Nov 2007 10:16:11 -0500
Subject: wpa_supplicant/key deletion with all-zeroes mac (was: security
	question)
From: Johannes Berg <johannes@sipsolutions.net>
To: mabbas <mabbas@linux.intel.com>
Cc: linux-wireless@vger.kernel.org, Dan Williams <dcbw@redhat.com>,
	linville@tuxdriver.com, Jouni Malinen <j@w1.fi>
In-Reply-To: <4743E5DF.9040603@linux.intel.com>
References: <4743E5DF.9040603@linux.intel.com>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-Sdmf8zcWwQeJS7hMN65B"
Date: Wed, 21 Nov 2007 16:17:34 +0100
Message-Id: <1195658254.12000.23.camel@johannes.berg> (sfid-20071121_151614_991067_D1F7CD89)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-Sdmf8zcWwQeJS7hMN65B
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

Hi,

> When I connect to an AP with wpa, then I receive deauth frame,=20
> ieee80211_rx_mgmt_deauth will be called, which will call=20
> ieee80211_set_associated(dev, ifsta, 0); to disconnect. In function=20
> ieee80211_set_associated, it calls wireless_send_event with SIOCGIWAP=20
> event and memset(wrqu.ap_addr.sa_data, 0, ETH_ALEN). wpa_supplicant will=20
> receives this event then call mac80211 to remove any old security key,=20
> the problem it will pass 00:00:00:00:00:00 as station address.=20
> ieee80211_set_encryption will fail since there are no station with=20
> 00:00:00:00:00:00. This will leave the old key which causes the problems=20
> in the next reconnection.

Interesting. I'd think this is a wpa_supplicant bug, Jouni, how is the
security wext stuff supposed to work here?

> diff --git a/net/mac80211/ieee80211_ioctl.c b/net/mac80211/ieee80211_ioct=
l.c
> index c84a26e..e08df5e 100644
> --- a/net/mac80211/ieee80211_ioctl.c
> +++ b/net/mac80211/ieee80211_ioctl.c
> @@ -97,7 +97,10 @@ static int ieee80211_set_encryption(struct net_device =
*dev, u8 *sta_addr,
>  			return -EINVAL;
>  		}
> =20
> -		sta =3D sta_info_get(local, sta_addr);
> +		if (is_zero_ether_addr(sta_addr))
> +			sta =3D sta_info_get(local, sdata->u.sta.bssid);
> +		else
> +			sta =3D sta_info_get(local, sta_addr);
>  		if (!sta) {
>  #ifdef CONFIG_MAC80211_VERBOSE_DEBUG
>  			printk(KERN_DEBUG "%s: set_encrypt - unknown addr "
>=20

--=-Sdmf8zcWwQeJS7hMN65B
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIVAwUAR0RMDaVg1VMiehFYAQIb0Q/+O+fBQ+znjnzrfF6mdLMQWUrjTpDd0yb6
l1h1yjVXz34EnbjhsMWHck4/NrvB/mohWtit6cJkNR9zENFJDAOM3OP8y86cUYCO
5tm00cFZz4rv5rKoJe5/WbCecsz25V5Y3sPFPusbFvw7e7tnBRCMT6X8GbdmbZmu
T4y+EPbc1zF0hFl4IwqCaK831s0vM9qwdVuxerI+Vx2+CxGLO+ONjvYjydTHhYKw
toD4/gUfneZbr1zVIMsJRo3+LRys7XofuKR0CTEtcpldYEqB+qz4RoMCkKvwlQjh
FvXynFneY8rh+fDLZK9gl6/jxs1mV6bv0EU7fztkrk2qP6V3RH3jqHwgwnHR+1bx
gGRf7H6MInAYW4apcFmTQBPPq7mPsd5KOS0yzM+BucVAKi60xjv6gAGge02kbWj2
L02+ulrZxfAMG0AZMxfx3NNRRtFexhgvaS7MhPmeIvZ1IUTtfeiPGJ3Xwp/3uggw
OhRTetrLeKlk4q+Pb5iQDXor/NeI4WXTDS6qkftWyJb7DHrLUsTD8FGZ+EDIjb1m
kL+GoAgtofqMYEdUIrPMcDdCG5rQBZ2clkmMPeg0AHqm0vWH8NgJ2Qlhak+iclcR
A12K6gg+Vrz2FJKqEwZMT6/q6zYVJECoiMTC6pimiumVXTkFEYF+oYkWIHX7JXDb
rCa64YaWWT8=
=gVUg
-----END PGP SIGNATURE-----

--=-Sdmf8zcWwQeJS7hMN65B--

