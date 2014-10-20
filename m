Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mout.gmx.net ([212.227.15.18]:50984 "EHLO mout.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753583AbaJTTJv (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 20 Oct 2014 15:09:51 -0400
Message-ID: <54455DDF.50305@rempel-privat.de> (sfid-20141020_211003_234775_62CEB57E)
Date: Mon, 20 Oct 2014 21:09:19 +0200
From: Oleksij Rempel <linux@rempel-privat.de>
MIME-Version: 1.0
To: "Li, Hongchun" <lihongchun@cn.fujitsu.com>,
	"(ath9k-devel@lists.ath9k.org)" <ath9k-devel@lists.ath9k.org>,
	Johannes Berg <johannes.berg@intel.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: Re: [ath9k-devel] IBSS network crashes after one device leaves network
References: <C7367401563A9D46BC5A92B9456C061D48D210@G08CNEXMBPEKD03.g08.fujitsu.local>
In-Reply-To: <C7367401563A9D46BC5A92B9456C061D48D210@G08CNEXMBPEKD03.g08.fujitsu.local>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="wNPkTLDFTVr8kt4rIO0HT2XnCNNrI6dWH"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--wNPkTLDFTVr8kt4rIO0HT2XnCNNrI6dWH
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable

Hi Johannes,

since this function was added by you, may be you can help here (commit
f09603a259). ath9k_htc support max 8 STAs in AP or ADHOC mode.  If more
then 8 stations connected, driver will return error, but
sta_info_insert_drv_state() setting it to zero.
What was initial purpose of this?
net/mac80211/sta_info.c:
        if (sdata->vif.type =3D=3D NL80211_IFTYPE_ADHOC) {
                sdata_info(sdata,
                           "failed to move IBSS STA %pM to state %d (%d)
- keeping it anyway\n",
                           sta->sta.addr, state + 1, err);
                err =3D 0;
        }


Am 18.10.2014 um 09:46 schrieb Li, Hongchun:
> I=E2=80=99m building an IBSS network using TP-Link TL-WN722N USB WiFi d=
ongle.
>=20
> I find that it is drived by ath9k.
>=20
> =20
>=20
> Here is a problem I encountered.
>=20
> First, I build an IBSS network with more than 8 devices.
>=20
> For example, a network consists of 9 devices, N1, N2, =E2=80=A6, N9.
>=20
> All devices have same WiFi module.
>=20
> =20
>=20
> When N9 joined network, kernel throws a warning, =E2=80=9CUnable to mov=
e IBSS
> STA MAC_ADDR to state 3 (-105)=E2=80=9D.
>=20
> However, the network works correctly. Any node can communicate with eac=
h
> other.
>=20
> =20
>=20
> But if I turn off one device, for example N3, the network crashes after=

> a few minutes.
>=20
> Ping command fails between any two devices in network.
>=20
> Get no warning/error message from kernel.
>=20
> After N3 is turned off and network crashes, I turned on N3 and network
> works correctly again.
>=20
> =20
>=20
> I find the number 8 is an macro in device driver code:
> drivers/net/wireless/ath/ath9k/htc.h
>=20
> 252 <http://lxr.free-electrons.com/source/drivers/net/wireless/ath/ath9=
k/htc.h?v=3D3.11#L252> #define ATH9K_HTC_MAX_STA <http://lxr.free-electro=
ns.com/ident?v=3D3.11;i=3DATH9K_HTC_MAX_STA> 8
>=20
> It seems like that when there are more than 8 devices in network, drive=
r
> returns an error ENOBUFS(-105).
>=20
> =20
>=20
> But in linux kernel source: net/mac80211/sta_info.c, I found this,
>=20
> 436
> <http://lxr.free-electrons.com/source/net/mac80211/sta_info.c?v=3D3.11#=
L436>=20
> if (sdata <http://lxr.free-electrons.com/ident?v=3D3.11;i=3Dsdata>->vif=
=2Etype
> <http://lxr.free-electrons.com/ident?v=3D3.11;i=3Dtype> =3D=3D
> NL80211_IFTYPE_ADHOC) {
>=20
> 437
> <http://lxr.free-electrons.com/source/net/mac80211/sta_info.c?v=3D3.11#=
L437>=20
>       sdata_info
> <http://lxr.free-electrons.com/ident?v=3D3.11;i=3Dsdata_info>(sdata
> <http://lxr.free-electrons.com/ident?v=3D3.11;i=3Dsdata>,
>=20
> 438
> <http://lxr.free-electrons.com/source/net/mac80211/sta_info.c?v=3D3.11#=
L438>=20
>                "failed to move IBSS STA %pM to state %d (%d) - keeping
> it anyway\n",
>=20
> 439
> <http://lxr.free-electrons.com/source/net/mac80211/sta_info.c?v=3D3.11#=
L439>=20
>                sta->sta.addr
> <http://lxr.free-electrons.com/ident?v=3D3.11;i=3Daddr>, state
> <http://lxr.free-electrons.com/ident?v=3D3.11;i=3Dstate> + 1, err
> <http://lxr.free-electrons.com/ident?v=3D3.11;i=3Derr>);
>=20
> 440
> <http://lxr.free-electrons.com/source/net/mac80211/sta_info.c?v=3D3.11#=
L440>=20
>      err <http://lxr.free-electrons.com/ident?v=3D3.11;i=3Derr> =3D 0;
>=20
> 441
> <http://lxr.free-electrons.com/source/net/mac80211/sta_info.c?v=3D3.11#=
L441>=20
> }
>=20
> So when it is an ad hoc network, kernel just ignore errors from driver.=

>=20
> This answers why ibss network work correctly when there are more than 8=

> devices.
>=20
> =20
>=20
> But I cannot figure out why the network crashes after one device is
> turned off.
>=20
> Does anyone have any idea how to solve this problem?
>=20
> =20
>=20
> Li Chun
>=20
> =20
>=20
>=20
>=20
> _______________________________________________
> ath9k-devel mailing list
> ath9k-devel@lists.ath9k.org
> https://lists.ath9k.org/mailman/listinfo/ath9k-devel
>=20


--=20
Regards,
Oleksij


--wNPkTLDFTVr8kt4rIO0HT2XnCNNrI6dWH
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iF4EAREIAAYFAlRFXeQACgkQHwImuRkmbWlyTAD/RyEnzigbbeR4IEVJr8p/V9Ft
5obYo4axzLYoA0yROfcA/RHGb6rE1mb+vnmb7UQFEAJ4jTUIjhPs5fD3Th6QIOj/
=br/e
-----END PGP SIGNATURE-----

--wNPkTLDFTVr8kt4rIO0HT2XnCNNrI6dWH--
