Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx5.mail.ru ([194.67.23.25]:30735 "EHLO mx5.mail.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751105AbYKVH40 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sat, 22 Nov 2008 02:56:26 -0500
From: Andrey Borzenkov <arvidjaar@mail.ru>
To: Dave <kilroyd@googlemail.com>
Subject: Re: [Orinoco-devel] Agere PCMCIA sometimes takes very long time to associate with 9.48 FW
Date: Sat, 22 Nov 2008 10:56:21 +0300
Cc: orinoco-devel@lists.sourceforge.net, linux-wireless@vger.kernel.org
References: <200810191436.13298.arvidjaar@mail.ru> <200811172229.41361.arvidjaar@mail.ru> <4921D616.3040207@gmail.com>
In-Reply-To: <4921D616.3040207@gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed;
  boundary="nextPart4388712.nQBSq0meGh";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Message-Id: <200811221056.22061.arvidjaar@mail.ru> (sfid-20081122_085629_578096_F2C99455)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

--nextPart4388712.nQBSq0meGh
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline

On Monday 17 November 2008, Dave wrote:

> > Looking at wpa_supplicant log intersting part is
> >=20
> > Wireless event: cmd=3D0x8c07 len=3D32
> > AssocReq IE wireless event - hexdump(len=3D24): dd 16 00 50 f2 01 01 00=
 00 50 f2 02 01 00 00 50 f2 02 01 00 00 50 f2 02
> > RTM_NEWLINK: operstate=3D0 ifi_flags=3D0x11003 ([UP][LOWER_UP])
> > RTM_NEWLINK, IFLA_IFNAME: Interface 'eth1' added
> > Wireless event: cmd=3D0x8b15 len=3D20
> > Wireless event: new AP: 00:60:b3:ca:91:b0
> > Association info event
> > req_ies - hexdump(len=3D24): dd 16 00 50 f2 01 01 00 00 50 f2 02 01 00 =
00 50 f2 02 01 00 00 50 f2 02
> > WPA: set own WPA/RSN IE - hexdump(len=3D24): dd 16 00 50 f2 01 01 00 00=
 50 f2 02 01 00 00 50 f2 02 01 00 00 50 f2 02
> > State: ASSOCIATING -> ASSOCIATED
> > wpa_driver_wext_set_operstate: operstate 0->0 (DORMANT)
> > WEXT: Operstate: linkmode=3D-1, operstate=3D5
> > Associated to a new BSS: BSSID=3D44:44:44:44:44:44
>=20
> > in other words, wpa_drv_get_bssid() returns 44:... BSSID. I could not f=
ind
> > any place in kernel or wpa_supplicant that would set it, so I can only =
assume
> > that firmware returns it for watever reason.
>=20
> It is a firmware value, but I don't know what the it means. I know
> hostap checks for it in hostap_main:prism2_sta_deauth.
>=20

In some place wpa_supplicant is using this to mark invalid BSSID; I
do not think it leaks it into the driver now though.

And it is value that is use by Hermes to indicate invalid BSSID. It is even
documents in iwconfig.c :)

/*
 * Display an Wireless Access Point Socket Address in readable format.
 * Note : 0x44 is an accident of history, that's what the Orinoco/PrismII
 * chipset report, and the driver doesn't filter it.
 */

Anyway I now have Yet Another Theory that actually fits quite well into
what I have seen in wpa_supplicant logs and explains 44:... BSSID as well.

Mandriva is using approximately the following sequence to start wireless:

ifconfig eth1 up
iwconfig eth1 whatever-is-set-for-it
wpa_supplicant eth1

Now I had these parameters for eth1:

### WIRELESS_MODE=3DManaged
### WIRELESS_ESSID=3D"Home, sweet home"
WIRELESS_WPA_DRIVER=3Dwext
### WIRELESS_POWER=3Don
### WIRELESS_SENS=3D3

Notice WIRELESS_ESSID. So what happened was apparently this

iwcofnig eth1 ESSID
                      driver starts associating
wpa_supplicant starts
                      driver associated and send IWEVASSOCREQIE
wpa_supplicant calls SIOCSIWESSID  |
         +-------------------------+
         |
         |            driver *again* starts associating
        /
wpa_supplicant receives SIOCSIWESSID
wpa_supplicant calls SIOCGIWAP
                      at this point driver has not yet
                        completed *second* association
                        so it returns invalid BSSID
                        (44:44:44:44:44:44)


So it looks like user space issue after all. There is little driver can
do (except returning "officially blessed" indication for invalid BSSID).
As it is now, wpa_supplicant does not seem to check for invalid BSSID
from SIOCGIWAP in wpa_supplicant_event_assoc() at all. It enters quite a
long retry loop using invalid value until it finally decides to trigger
association again.

It also explains why nobody was able to reproduce it - it is really
quite unique timing issue. Any change in scheduling could have "fixed" it.

--nextPart4388712.nQBSq0meGh
Content-Type: application/pgp-signature; name=signature.asc 
Content-Description: This is a digitally signed message part.

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iEYEABECAAYFAkknuyUACgkQR6LMutpd94zwXQCgjrQtxr069cDA7zwdCRk/d4G0
ABMAn3VJ8NDyCglU5kgF6IlJ6baZ4k1K
=x/YQ
-----END PGP SIGNATURE-----

--nextPart4388712.nQBSq0meGh--
