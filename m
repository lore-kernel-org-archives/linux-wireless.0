Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:58245 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753754AbZDVJEW (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 22 Apr 2009 05:04:22 -0400
Subject: Re: Problem with IEEE80211_MONITORING_INTERVAL
From: Johannes Berg <johannes@sipsolutions.net>
To: Marcel Holtmann <marcel@holtmann.org>
Cc: linux-wireless@vger.kernel.org, Jouni Malinen <j@w1.fi>
In-Reply-To: <1240385542.3404.5.camel@localhost.localdomain>
References: <1239837672.11795.46.camel@violet>
	 (sfid-20090416_012123_293746_81110E23)  <1239875168.9737.10.camel@johannes.local>
	 <1240247636.5260.11.camel@localhost.localdomain>
	 <1240248008.4632.10.camel@johannes.local>
	 <1240248385.5260.15.camel@localhost.localdomain>
	 (sfid-20090420_192718_984250_38AB6869)  <1240248773.4632.13.camel@johannes.local>
	 <1240343775.3327.3.camel@localhost.localdomain>
	 <1240348792.17388.46.camel@johannes.local>
	 <1240385542.3404.5.camel@localhost.localdomain>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="=-0rj7da77B9o2LqsizkCB"
Date: Wed, 22 Apr 2009 11:03:49 +0200
Message-Id: <1240391029.20308.1.camel@johannes.local> (sfid-20090422_113345_450115_FD6F47A8)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-0rj7da77B9o2LqsizkCB
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

Hi,

> one other weird thing happens now (except wireless-testing tree and
> suspend/resume is broken). The first connection attempt fails horribly:
>=20
> CTRL-EVENT-SCAN-RESULTS=20
> Trying to authenticate with 00:23:ab:xx:xx:xx (SSID=3D'Guest' freq=3D2412=
 MHz)
> Trying to associate with 00:23:ab:xx:xx:xx (SSID=3D'Guest' freq=3D2412 MH=
z)
> Associated with 00:23:ab:xx:xx:xx
> CTRL-EVENT-CONNECTED - Connection to 00:23:ab:xx:xx:xx completed (auth) [=
id=3D2 id_str=3D]
> CTRL-EVENT-DISCONNECTED - Disconnect event - remove keys
> l2_packet_receive - recvfrom: Network is down
> Failed to initiate AP scan.
> Failed to initiate AP scan.
> ^CCTRL-EVENT-TERMINATING - signal 2 received
>=20
> So starting wpa_supplicant does its job fine, then running dhclient I
> end up in the disconnect and network down and after that scanning fails.

???

And the below kernel message is all yo uget?

> Killing wpa_supplicant and dhclient and then trying again works fine. So
> far I have seen that only after a fresh boot.
>=20
> Found this one in dmesg:
>=20
> ------------[ cut here ]------------
> WARNING: at net/wireless/nl80211.c:205 nl80211_send_wiphy+0x4b/0x988
> [cfg80211]()
> Hardware name: 7454CTO
> Modules linked in: fuse rfcomm sco bnep l2cap binfmt_misc
> snd_hda_codec_conexant iwlagn iwlcore snd_hda_intel i2400m_usb
> snd_hda_codec i2400m mac80211 uvcvideo snd_pcm btusb snd_timer snd wimax
> cfg80211 soundcore bluetooth snd_page_alloc uhci_hcd ehci_hcd [last
> unloaded: microcode]
> Pid: 3274, comm: wpa_supplicant Tainted: G        W  2.6.30-rc2-wl #1
> Call Trace:
>  [<ffffffff80236604>] warn_slowpath+0xb1/0xe5
>  [<ffffffff8039a44a>] ? extract_buf+0x84/0xe4
>  [<ffffffffa0055e04>] nl80211_send_wiphy+0x4b/0x988 [cfg80211]

What tree are you using? This warning totally confuses me -- there's no
code to produce it! It was a spurious warning Luis added some time ago,
we removed right away again and now it's haunting us.

johannes

--=-0rj7da77B9o2LqsizkCB
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIcBAABAgAGBQJJ7t1yAAoJEKVg1VMiehFYIBAP/RoI4c2E+R8s+Qi1clyqKber
hoRUMWAF/Lfw4uPx1mM83ehJ64uV6e3scqRq6tJklk1SthR/inUZCl2TfKLm9pho
LOeUlY5G6J+tblDaQQ+19JDj8r7cmC6RSxeEhcNkc7MLMhr2Xm8xLxgH4oZhcG8X
QkYlgKzJbto7G2a6nN6ytp4q6ufWt8+8u6R/zt0UHVZnqSUwZDe3BM6k8qgwLGZc
iGAQyuQuDVydXXwFKhbyjutrU5XmenHFvr4+tp53val3MxWDz1bllL4iIENWC96n
4g6I3s4aMgwc6iEfnUz/tbKkNERMCobl3HWs977i/8/YbIyWGpiAb0NRZmFyN257
ZhBfJSLSjufAfo1NhXbe7oziYP2iSQR0uLuMMQBwHSFZ1IBx8QkSwJUsyquDtrny
lhKZ0DGmX+OsUIAzKd8S0EyXSLhtynLpWktJhDFIOJ5J63blz2m3b4lU0c7g0Dtr
d+b2d8ggfEq4QdAC1vP95DoBPI/S2qtRqgTRhYxrejDHeoxxfY/7efhRbd4vkzJf
Qtuh5+Trgmo/N/+sOHmSTcs3d+9lDHFFgfM5M7JJ8G0Dy01Zz8cLVQml36//0u9q
czALDEld/rdfuyxUF1Z1KeG7S5hgF6BnC6n4t7SPK5eVrOUYxrbi4xdAXIweVnel
z+Yre74avKneDtlPwk02
=o0Df
-----END PGP SIGNATURE-----

--=-0rj7da77B9o2LqsizkCB--

