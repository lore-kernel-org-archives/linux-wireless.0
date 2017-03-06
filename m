Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mout.gmx.net ([212.227.15.19]:61179 "EHLO mout.gmx.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752971AbdCFE6x (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Sun, 5 Mar 2017 23:58:53 -0500
Subject: Re: Hostapd driver issues in orange pi Zero
To: ravin goyal <ravirocks1021@gmail.com>, Jouni Malinen <j@w1.fi>,
        linux-wireless <linux-wireless@vger.kernel.org>,
        Arend Van Spriel <arend.vanspriel@broadcom.com>,
        wpa_supplicant <hostap@lists.infradead.org>
References: <CANU0Mn1D8pccK6QgZe1TuayFNbYHEXCJYJXZH8Z1dX6N6qhK1g@mail.gmail.com>
From: Oleksij Rempel <fishor@gmx.net>
Message-ID: <ba6f80ea-49fc-ea59-69f3-92eb11ab7eca@gmx.net> (sfid-20170306_055954_162629_342439B7)
Date: Mon, 6 Mar 2017 05:50:23 +0100
MIME-Version: 1.0
In-Reply-To: <CANU0Mn1D8pccK6QgZe1TuayFNbYHEXCJYJXZH8Z1dX6N6qhK1g@mail.gmail.com>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="ViKMuj2ucAUgaqccF53OfVfneSW95e5w6"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--ViKMuj2ucAUgaqccF53OfVfneSW95e5w6
Content-Type: multipart/mixed; boundary="GGCOPhG0MEmNo8xfxpNhAeuncLQWdfal2"
From: Oleksij Rempel <fishor@gmx.net>
To: ravin goyal <ravirocks1021@gmail.com>, Jouni Malinen <j@w1.fi>,
 linux-wireless <linux-wireless@vger.kernel.org>,
 Arend Van Spriel <arend.vanspriel@broadcom.com>,
 wpa_supplicant <hostap@lists.infradead.org>
Message-ID: <ba6f80ea-49fc-ea59-69f3-92eb11ab7eca@gmx.net>
Subject: Re: Hostapd driver issues in orange pi Zero
References: <CANU0Mn1D8pccK6QgZe1TuayFNbYHEXCJYJXZH8Z1dX6N6qhK1g@mail.gmail.com>
In-Reply-To: <CANU0Mn1D8pccK6QgZe1TuayFNbYHEXCJYJXZH8Z1dX6N6qhK1g@mail.gmail.com>

--GGCOPhG0MEmNo8xfxpNhAeuncLQWdfal2
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable

Hi

Am 05.03.2017 um 08:38 schrieb ravin goyal:
> Hi all,
>=20
> I am running hostapd 2.5 on orange pi zero running debian jessie and
> my wireless driver is xradio_wlan.

if i see it correctly, your wifi controller is Allwiner XR819. It looks
like SDIO device with own ram and firmware loaded to it. I don't have
specs for it, but i assume there is not enough RAM to work with more
then 9 devices.

> First it was running fine when I was testing without bridge settings
> in hostapd.conf.
>=20
> But when I set bridge=3Dbr0 in  hostapd.conf and restart the process, a=
s
> the number of STA's are getting connected to the hostapd access point.
>=20
> I noticed driver error allover in syslog and dmesg, I am sharing few
> logs from dmesg as below:
>=20
> [Sun Mar  5 07:46:46 2017] [AP_WRN] Multicast delivery timeout.
> [Sun Mar  5 07:46:52 2017] [WSM_ERR] wsm_flush_tx:No pengding, but
> hw_bufs_used=3D1
> [Sun Mar  5 07:47:48 2017] [WSM_ERR] wsm_flush_tx:No pengding, but
> hw_bufs_used=3D1
> [Sun Mar  5 07:48:16 2017] [AP_WRN] Multicast delivery timeout.
> [Sun Mar  5 07:49:56 2017] [WSM_ERR] wsm_flush_tx:No pengding, but
> hw_bufs_used=3D1
> [Sun Mar  5 07:51:14 2017] [AP_WRN] Multicast delivery timeout.
> [Sun Mar  5 07:51:57 2017] [WSM_ERR] wsm_flush_tx:No pengding, but
> hw_bufs_used=3D1
> [Sun Mar  5 07:52:07 2017] [WSM_ERR] wsm_flush_tx:No pengding, but
> hw_bufs_used=3D1
> [Sun Mar  5 07:52:14 2017] [WSM_ERR] wsm_flush_tx:No pengding, but
> hw_bufs_used=3D1
> [Sun Mar  5 07:52:18 2017] [AP_WRN] Multicast delivery timeout.
> [Sun Mar  5 07:53:30 2017] [WSM_ERR] wsm_flush_tx:No pengding, but
> hw_bufs_used=3D1
> [Sun Mar  5 07:56:09 2017] [WSM_ERR] wsm_flush_tx:No pengding, but
> hw_bufs_used=3D1
> [Sun Mar  5 07:59:00 2017] [BH_WRN] miss interrupt!
> [Sun Mar  5 08:00:00 2017] [AP_WRN] Multicast delivery timeout.
> [Sun Mar  5 08:00:38 2017] [WSM_ERR] wsm_flush_tx:No pengding, but
> hw_bufs_used=3D1
> [Sun Mar  5 08:01:16 2017] [WSM_ERR] wsm_flush_tx:No pengding, but
> hw_bufs_used=3D1
> [Sun Mar  5 08:01:48 2017] [AP_WRN] Multicast delivery timeout.
> [Sun Mar  5 08:02:21 2017] [STA_WRN] Inactivity Event Recieved for link=
_id 1
> [Sun Mar  5 08:02:21 2017] [STA_WRN]  Inactivity Deauth Frame sent for
> MAC SA 88:79:7e:13:5e:ce      and DA dc:44:6d:6b:43:18
> [Sun Mar  5 08:02:31 2017] [AP_WRN] Multicast delivery timeout.
> [Sun Mar  5 08:03:09 2017] [WSM_ERR] wsm_flush_tx:No pengding, but
> hw_bufs_used=3D1
> [Sun Mar  5 08:03:56 2017] [WSM_ERR] wsm_flush_tx:No pengding, but
> hw_bufs_used=3D1
> [Sun Mar  5 08:04:52 2017] [WSM_ERR] wsm_flush_tx:No pengding, but
> hw_bufs_used=3D1
> [Sun Mar  5 08:04:54 2017] [STA_WRN] Inactivity Event Recieved for link=
_id 3
> [Sun Mar  5 08:04:54 2017] [STA_WRN]  Inactivity Deauth Frame sent for
> MAC SA 88:79:7e:13:5e:ce      and DA dc:44:6d:6b:43:18
> [Sun Mar  5 08:04:59 2017] [AP_WRN] Multicast delivery timeout.
> [Sun Mar  5 08:05:44 2017] [WSM_ERR] wsm_flush_tx:No pengding, but
> hw_bufs_used=3D1
> [Sun Mar  5 08:06:50 2017] [WSM_ERR] wsm_flush_tx:No pengding, but
> hw_bufs_used=3D1
> [Sun Mar  5 08:07:11 2017] [WSM_ERR] wsm_flush_tx:No pengding, but
> hw_bufs_used=3D1
> [Sun Mar  5 08:07:26 2017] [BH_WRN] miss interrupt!
> [Sun Mar  5 08:08:02 2017] [WSM_ERR] wsm_flush_tx:No pengding, but
> hw_bufs_used=3D1
> [Sun Mar  5 08:08:16 2017] [WSM_ERR] wsm_flush_tx:No pengding, but
> hw_bufs_used=3D1
> [Sun Mar  5 08:08:48 2017] [WSM_ERR] wsm_flush_tx:No pengding, but
> hw_bufs_used=3D1
> [Sun Mar  5 08:10:04 2017] [WSM_ERR] wsm_flush_tx:No pengding, but
> hw_bufs_used=3D1
> [Sun Mar  5 08:10:26 2017] [WSM_ERR] wsm_flush_tx:No pengding, but
> hw_bufs_used=3D1
> [Sun Mar  5 08:11:22 2017] [WSM_ERR] wsm_flush_tx:No pengding, but
> hw_bufs_used=3D1
> [Sun Mar  5 08:12:31 2017] [WSM_ERR] wsm_flush_tx:No pengding, but
> hw_bufs_used=3D1
> [Sun Mar  5 08:17:18 2017] [BH_WRN] miss interrupt!
> [Sun Mar  5 08:18:52 2017] [WSM_ERR] wsm_flush_tx:No pengding, but
> hw_bufs_used=3D1
> [Sun Mar  5 08:21:28 2017] [STA_WRN] Inactivity Event Recieved for link=
_id 4
> [Sun Mar  5 08:21:28 2017] [STA_WRN]  Inactivity Deauth Frame sent for
> MAC SA 88:79:7e:13:5e:ce      and DA dc:44:6d:6b:43:18
> [Sun Mar  5 08:22:30 2017] [WSM_ERR] wsm_flush_tx:No pengding, but
> hw_bufs_used=3D1
> [Sun Mar  5 08:23:22 2017] [WSM_ERR] wsm_flush_tx:No pengding, but
> hw_bufs_used=3D1
> [Sun Mar  5 08:24:00 2017] [WSM_ERR] wsm_flush_tx:No pengding, but
> hw_bufs_used=3D1
> [Sun Mar  5 08:24:14 2017] [WSM_ERR] wsm_flush_tx:No pengding, but
> hw_bufs_used=3D1
> [Sun Mar  5 08:24:23 2017] [BH_WRN] miss interrupt!
>=20
> Internet is working fine on the connected devices but these errors are
> keep coming in syslog which are hard to ignore.
> Any idea about this ?
>=20
> Moreover One more thing I noticed is that I can connect atmost 9-10
> clients( I get to know this by running hostapd_cli all_sta) afterwards
> it just keeps showing status connecting... when a new clients try to
> connect until unless one or more clients that are already connected
> gets disconnected.
> I even has set max_num_sta=3D255 but no help ?
>=20
> Regards
> Ravin
>=20



--GGCOPhG0MEmNo8xfxpNhAeuncLQWdfal2--

--ViKMuj2ucAUgaqccF53OfVfneSW95e5w6
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iF4EAREIAAYFAli86pcACgkQHwImuRkmbWlWbgD8Cc9afeeJHo6cl7QxazJQOM3j
LZbr5rsICcAwyiGRpfoA/jDJCzcwMJM77KExjKm8hR406dq4coFA4wNtDZuvazM5
=9Eqa
-----END PGP SIGNATURE-----

--ViKMuj2ucAUgaqccF53OfVfneSW95e5w6--
