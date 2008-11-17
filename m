Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx33.mail.ru ([194.67.23.194]:29894 "EHLO mx33.mail.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754396AbYKQT3r (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 17 Nov 2008 14:29:47 -0500
From: Andrey Borzenkov <arvidjaar@mail.ru>
To: Dave <kilroyd@googlemail.com>
Subject: Re: [Orinoco-devel] Agere PCMCIA sometimes takes very long time to associate with 9.48 FW
Date: Mon, 17 Nov 2008 22:29:40 +0300
Cc: orinoco-devel@lists.sourceforge.net, linux-wireless@vger.kernel.org
References: <200810191436.13298.arvidjaar@mail.ru> <20081115145655.GB31553@tuxdriver.com> <491FEF89.3040100@gmail.com>
In-Reply-To: <491FEF89.3040100@gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed;
  boundary="nextPart3233995.1V3gSkvIjL";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Message-Id: <200811172229.41361.arvidjaar@mail.ru> (sfid-20081117_203022_718794_7E4E073F)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

--nextPart3233995.1V3gSkvIjL
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline

On Sunday 16 November 2008, Dave wrote:
> John W. Linville wrote:
> > On Sat, Nov 15, 2008 at 11:15:47AM +0300, Andrey Borzenkov wrote:
> >=20
> >> - we should not be doing it in ->open. It is technically legal to set
> >> wireless parameters before "icfonfig up" and we lose all of them. I wi=
ll
> >> try next week with similar patch in orinoco_stop().
> >=20
> > That seems wrong...
> >=20
> >> - I am still not even sure we should do it at all. What is sematic of
> >> ifconfig up/down w.r.t. wireless parameters? I.e. is "ifconfig down"
> >> expected to clean all device state and start from scratch?
> >=20
> > No.  Unfortunately, it is mostly a matter of opinion as to what
> > wireless extensions expects.
>=20
> Agreed with all the above. I'll discard the driver patch.
>=20
> There are two other things I can think of:
>=20
> 1. make sure wpa_supplicant is shut down before ifconfig ethX down, and
> restart it on resume.
>=20

That is exactly what happens currently.

> From the data you've provided it looks like your distribution brings the
> device down, but may leave wpa_supplicant running.=20

No, wpa_supplicant is started as part of ifup and stopped as part of ifdown.
Which are called on network start/stop.

> I've noticed that=20
> every time wpa_supplicant shuts down it removes most configuration
> settings. Or has that changed?
>=20

As far as I can tell - it should. I am not sure how to check for it; I do
not see any difference in output of either iwconfig or iwlist scan either
before or after "network stop".

We really need some more debugging code in orinoco.

Returning to the original problem. The only difference visible currently is
when association happens.

Good case:

[16992.355418] eth1: Lucent/Agere firmware doesn't support manual roaming
[16992.636475] eth1: New link status: Connected (0001)

As already mentioned, "error" message comes from SIOCSIWAP which is not
supported by Agere firmware. wpa_supplicant calls it as part of association
resuest in wpa_driver_wext_associate().

Bad case is always:

[ 7669.871273] eth1: New link status: Connected (0001)
[ 7670.046171] eth1: Lucent/Agere firmware doesn't support manual roaming
[ 7670.495779] eth1: Lucent/Agere firmware doesn't support manual roaming
[ 7675.774280] eth1: Lucent/Agere firmware doesn't support manual roaming
=2E..

i.e. it /looks/ like first card is connected to AP and then wpa_supplicant
request association. BTW, I just realized that I am not sure what "connecte=
d"
means exactly. Does it mean card is associated?

That is what let me believe that old parameters somehow are retained.

Looking at wpa_supplicant log intersting part is

Wireless event: cmd=3D0x8c07 len=3D32
AssocReq IE wireless event - hexdump(len=3D24): dd 16 00 50 f2 01 01 00 00 =
50 f2 02 01 00 00 50 f2 02 01 00 00 50 f2 02
RTM_NEWLINK: operstate=3D0 ifi_flags=3D0x11003 ([UP][LOWER_UP])
RTM_NEWLINK, IFLA_IFNAME: Interface 'eth1' added
Wireless event: cmd=3D0x8b15 len=3D20
Wireless event: new AP: 00:60:b3:ca:91:b0
Association info event
req_ies - hexdump(len=3D24): dd 16 00 50 f2 01 01 00 00 50 f2 02 01 00 00 5=
0 f2 02 01 00 00 50 f2 02
WPA: set own WPA/RSN IE - hexdump(len=3D24): dd 16 00 50 f2 01 01 00 00 50 =
f2 02 01 00 00 50 f2 02 01 00 00 50 f2 02
State: ASSOCIATING -> ASSOCIATED
wpa_driver_wext_set_operstate: operstate 0->0 (DORMANT)
WEXT: Operstate: linkmode=3D-1, operstate=3D5
Associated to a new BSS: BSSID=3D44:44:44:44:44:44

Which corresponds to this code:

static void wpa_supplicant_event_assoc(struct wpa_supplicant *wpa_s,
                                       union wpa_event_data *data)
{
        u8 bssid[ETH_ALEN];
        int ft_completed =3D wpa_ft_is_completed(wpa_s->wpa);

        if (data)
                wpa_supplicant_event_associnfo(wpa_s, data);

        wpa_supplicant_set_state(wpa_s, WPA_ASSOCIATED);
        if (wpa_s->use_client_mlme)
                os_memcpy(bssid, wpa_s->bssid, ETH_ALEN);
        if (wpa_s->use_client_mlme ||
            (wpa_drv_get_bssid(wpa_s, bssid) >=3D 0 &&
             os_memcmp(bssid, wpa_s->bssid, ETH_ALEN) !=3D 0)) {
                wpa_msg(wpa_s, MSG_DEBUG, "Associated to a new BSS: BSSID=
=3D"
                        MACSTR, MAC2STR(bssid));

in other words, wpa_drv_get_bssid() returns 44:... BSSID. I could not find
any place in kernel or wpa_supplicant that would set it, so I can only assu=
me
that firmware returns it for watever reason.

We really need more debugging in driver ...

--nextPart3233995.1V3gSkvIjL
Content-Type: application/pgp-signature; name=signature.asc 
Content-Description: This is a digitally signed message part.

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iEYEABECAAYFAkkhxiUACgkQR6LMutpd94wJuQCcCPGF9oz7Z3lwbIN4Xq050vM1
V+AAn2zD/Am4T48BnW6Q3XJ4F8AJcN4y
=vud9
-----END PGP SIGNATURE-----

--nextPart3233995.1V3gSkvIjL--
