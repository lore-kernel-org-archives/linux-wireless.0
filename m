Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:42972 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756231AbZJTBJC (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 19 Oct 2009 21:09:02 -0400
Subject: Re: wlan oops
From: Johannes Berg <johannes@sipsolutions.net>
To: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: linux-wireless <linux-wireless@vger.kernel.org>,
	nbd <nbd@openwrt.org>
In-Reply-To: <1255916929.2139.1.camel@pasglop>
References: <1255916929.2139.1.camel@pasglop>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="=-jdGcS0VlxvEtYGsnZDKU"
Date: Tue, 20 Oct 2009 10:08:24 +0900
Message-Id: <1256000904.4475.4.camel@johannes.local>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-jdGcS0VlxvEtYGsnZDKU
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Mon, 2009-10-19 at 10:48 +0900, Benjamin Herrenschmidt wrote:

> [ 3698.908913] wlan0: Selected IBSS BSSID 22:48:99:ac:65:40 based on conf=
igured SSID
> [ 3698.932660] ------------[ cut here ]------------
> [ 3698.932701] WARNING: at net/wireless/scan.c:483 cfg80211_inform_bss_fr=
ame+0x151/0x190 [cfg80211]()
> [ 3698.932707] Hardware name: 7659AB8
> [ 3698.932711] Modules linked in: tun snd_hda_codec_analog snd_hda_intel =
snd_hda_codec binfmt_misc snd_pcm_oss snd_mixer_oss snd_pcm snd_seq_dummy s=
nd_seq_oss snd_seq_midi snd_rawmidi arc4 snd_seq_midi_event ecb snd_seq snd=
_timer snd_seq_device pcmcia bridge iwlagn stp iptable_filter sdhci_pci ppd=
ev snd iwlcore bnep ip_tables yenta_socket psmouse thinkpad_acpi sdhci soun=
dcore mac80211 x_tables lp ricoh_mmc btusb rsrc_nonstatic pcmcia_core serio=
_raw led_class nvram snd_page_alloc cfg80211 parport fbcon tileblit font bi=
tblit softcursor ohci1394 ieee1394 i915 e1000e drm i2c_algo_bit cfbcopyarea=
 video output cfbimgblt cfbfillrect intel_agp
> [ 3698.932822] Pid: 1345, comm: iwlagn Not tainted 2.6.31.4-14-benh #1
> [ 3698.932827] Call Trace:

> [ 3698.932875]  [<ffffffffa012a4b1>] cfg80211_inform_bss_frame+0x151/0x19=
0 [cfg80211]
> [ 3698.932916]  [<ffffffffa01a3cc4>] __ieee80211_sta_join_ibss+0x384/0x46=
0 [mac80211]
> [ 3698.932944]  [<ffffffffa01a427e>] ieee80211_sta_find_ibss+0x4de/0x4f0 =
[mac80211]
> [ 3698.932971]  [<ffffffffa01a4303>] ieee80211_ibss_notify_scan_completed=
+0x73/0xa0 [mac80211]
> [ 3698.932997]  [<ffffffffa01a0bc9>] ieee80211_scan_completed+0xc9/0x470 =
[mac80211]

This actually seems to be a bug in mac80211, not just random weird
frames being received.

johannes

--=-jdGcS0VlxvEtYGsnZDKU
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----

iQIcBAABAgAGBQJK3Q2EAAoJEODzc/N7+QmarT0QAMIt5z1jNEYNdhxZh7y5sCIA
QvTszbVUZnPBSGeJzVKMQbPwxuh3HzG+aZjrCoi1txqmiyYXIBe5iIgL9dyTC8jV
7BqXANrCtyOuBdU6xO9Su+jofvM9YNUJ02IqOODsof1SmMbl18EKW7RBZzFTvOF3
71x15p6HQnLPWxmN5bmv6Yzr5FOKInJ14vYf8GXnkeSSWMzmuORCkxtkdVQ+GWCe
Uu3LYfp9tvqBkslxi90eJw/2DPqrwISkq8O/xo2JjWcjf5OYSwXrNmgyqdh+JALx
HtAl/y/7115LhK1skXj7ko7bX4GfBjuR9NOXb6gYv9HHJO+9mQRleg9jLfHkjLAi
fiFfoc+lhR1aVQDisTpKK+CbFDHsVtW3sN/xfHGxv3nyPRGwDqzZMYCYeFy+kX4F
QV7/8KA0SkNjLn9/SY3h1Ir52qecF6mJFjYToe/9Jo4l7o5KYJkzT+7gF66ihs+V
uLoL44rI/NafQRg3QdyVdKy4rz5O9XZf60BAyEhzmL8TquVRqeNcKBGilCbnnCKT
CazBNJaZmWoRzQqARIDBzNM+0v6mXBf81CPiwR7GOfFY9y6JRBGN+cPRzRAgdAtp
muOnL6UrO1Y1NYOBxIHCfDEQl0vVn82bqXlaFp3wjOUk7J1AuOkBFLD63BtoOy6R
lB0nxuZR56HISCseJiKx
=OjBE
-----END PGP SIGNATURE-----

--=-jdGcS0VlxvEtYGsnZDKU--

