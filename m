Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:49829 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760760AbYEPO5v (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 16 May 2008 10:57:51 -0400
Subject: Re: Association broken with wpa_supplicant
From: Johannes Berg <johannes@sipsolutions.net>
To: Michael Buesch <mb@bu3sch.de>
Cc: John Linville <linville@tuxdriver.com>,
	Abhijeet Kolekar <abhijeet.kolekar@intel.com>,
	linux-wireless@vger.kernel.org
In-Reply-To: <200805160030.11244.mb@bu3sch.de> (sfid-20080516_003051_817717_1A6121D9)
References: <200805160030.11244.mb@bu3sch.de>
	 (sfid-20080516_003051_817717_1A6121D9)
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-NreY8u7U4lL0R9O77UbA"
Date: Fri, 16 May 2008 16:57:33 +0200
Message-Id: <1210949853.6381.19.camel@johannes.berg> (sfid-20080516_165832_166845_0262E32E)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-NreY8u7U4lL0R9O77UbA
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Fri, 2008-05-16 at 00:30 +0200, Michael Buesch wrote:
> Hi John,
>=20
> Association is broken in latest wireless-testing when using
> wpa_supplicant. It tells me
>=20
> Trying to associate with REAL_BSSID...
> Authentication with 00:00:00:00:00:00 timed out.
>=20
> The commit responsible for the breakage is
>=20
> Author: Abhijeet Kolekar <abhijeet.kolekar@intel.com>  2008-05-09 18:35:4=
1
> Committer: John W. Linville <linville@tuxdriver.com>  2008-05-15 22:11:19
> Parent: 6d7ef8714c227884346aebd9f4e5eea302db6d22 (hostap: fix "registers"=
 registration in procfs)
> Child:  d67ec7fb2b8ce69709def2421ab893517b101591 (libertas: fix command t=
imeout after firmware failure)
> Branches: master, remotes/origin/master
> Follows: master-2008-05-14
> Precedes: master-2008-05-15
>=20
>     mac80211 : Association with 11n hidden ssid ap.

Ok, so after knowing what breaks, I can tell you why :)

The original code looks like this:

-        if (!(ifsta->flags & (IEEE80211_STA_AUTO_SSID_SEL |
-            IEEE80211_STA_AUTO_BSSID_SEL | IEEE80211_STA_AUTO_CHANNEL_SEL)=
)) {
-                ifsta->state =3D IEEE80211_AUTHENTICATE;
-                ieee80211_sta_reset_auth(dev, ifsta);
-                return 0;
-        }

        spin_lock_bh(&local->sta_bss_lock);
        freq =3D local->oper_channel->center_freq;
        list_for_each_entry(bss, &local->sta_bss_list, list) {
                if (!(bss->capability & WLAN_CAPABILITY_ESS))=20
                        continue;

                if (!!(bss->capability & WLAN_CAPABILITY_PRIVACY) ^
                    !!sdata->default_key)
                        continue;

[...]


Now, with the marked code removed, observe what will happen with the
last if statement here when wpa supplicant sets all parameters (i.e.
none of the auto flags are set): It will continue the loop because
wpa_supplicant hasn't yet set a key, which of course, it cannot.

We cannot remove that test either because that would break regular WEP
operation; we could "enhance" the test with a huge check for all the
flags but I think that's stretching it.

Let's work on making cfg80211 work for this instead where we can add any
number of flags for these things.

johannes

--=-NreY8u7U4lL0R9O77UbA
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIVAwUASC2g3KVg1VMiehFYAQIi3Q//QGpEURlqD4F17+xs385XAnY9voVJKw4C
PCCwroEa2oteozvWnQ5ot1ne+5GfLIBM0cJydsdmn4fXS38YoUGvFOGbiN4QOiwn
Qmf5JO5ZpP1FdczJ2UX5ZnLGOgCi5rel+1e995whN5vkDobVzfUyQrrU8KhZqJvP
urcEqGMiB45boWmlBT2zpzDvl2FqL77bVEgvld4ARoHIQrMezjWATYUMDiELGgZH
X5G2yRKj2h7OUfOU7Bg55yLqIzdkc/KcyEVFLLYry6owN5lm8aYpBtCdf2vFY2zj
zaGQ1ZkVHhoWbC+71QNithR8RRWBCLVSgzTTVg+MuQA3ZmgYzeT85z6ZcZ2IqeEG
yYjkKdUCaOWRLVS+zHORF/CgshljXwMBmVdRO/aopkXblRVj0FjkZ6sCM4umeFUK
W3A9b3vbAfXs8plz8ZOnbPf87uNrxWuo7eeZV//KqGJBrdpKBhdohIc9vP1kV2S/
sOPUXBeDCldQpg9shgYGSoU4BXUcQJR0TMmjS5sUWRwOrzChkSYo6bYhs1VXxOuY
qPSDzJQ4pBnfTixGHr1tZvNN516UeUaMCrqehM/weCScTZXyp7vpyBQ4GtMIKkMW
M3xHV/W1nnPXphsQ9KmUmz2NqG4Z0kF9W2t8lZaH8QXbL4qsG/A+h0T7Lzv2lCTp
Zhj+7DATJdE=
=gGl5
-----END PGP SIGNATURE-----

--=-NreY8u7U4lL0R9O77UbA--

