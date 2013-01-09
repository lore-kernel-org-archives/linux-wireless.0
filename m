Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from forward7.mail.yandex.net ([77.88.61.37]:56571 "EHLO
	forward7.mail.yandex.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751694Ab3AIG36 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 9 Jan 2013 01:29:58 -0500
Message-ID: <50ED0CE4.1000502@mva.name> (sfid-20130109_073002_431165_3C790F91)
Date: Wed, 09 Jan 2013 13:23:32 +0700
From: "Vadim A. Misbakh-Soloviov" <mva@mva.name>
MIME-Version: 1.0
To: linux-wireless@vger.kernel.org
CC: brcm80211-dev-list@broadcom.com
Subject: brcmsmac problems
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="------------enig02853AAD404DA20A09270F8D"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This is an OpenPGP/MIME signed message (RFC 2440 and 3156)
--------------enig02853AAD404DA20A09270F8D
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

Hello there!
Unfortunately, all the time I use laptops with broadcom WiFi cards I
experience problems with them. So, I feel unlucky with it.

Currenlty, I've Lenovo IdeaPad B570 laptop with
>> 03:00.0 Network controller [0280]: Broadcom Corporation BCM4313
802.11b/g/n Wireless LAN Controller [14e4:4727] (rev 01)

First of all, I can't get it to work on 11n wifi. My maximum
download/upload speed is 1.7-2 Mbytes/s, while if I insert atheros card
=E2=80=94 I get 8-10Mbytes/s. And NetworkManager says "connection speed" =
is
12-18-28.9Mb/s on bcm4313 and 140+Mb/s on atheros. So, I guess it really
works in 11g, but not 11n.

Secondly, I've a bunch of issues with it:
I can't get it to work with broadcom-sta (wl) driver, so using
b43/brcmsmac for a long time.
All the time I using it =E2=80=94 sometimes I experience connection-freez=
es (no
incoming packets from AP) for few minutes, or until I stop services like
avahi or torrent or IMAP-client.
Sometimes I even experience reconnect-loops, and sometimes I even
experience kernel-oops like this:

Jan  6 19:23:51 localhost kernel: [77873.116584] ------------[ cut here
]------------
Jan  6 19:23:51 localhost kernel: [77873.116611] WARNING: at
drivers/net/wireless/brcm80211/brcmsmac/main.c:7993
brcms_c_wait_for_tx_completion+0x91/0xa0 [brcmsmac]()
Jan  6 19:23:51 localhost kernel: [77873.116615] Hardware name:
HuronRiver Platform
Jan  6 19:23:51 localhost kernel: [77873.116618] Modules linked in:
vhba(O) brcmsmac brcmutil b43 ssb bcma mac80211 bbswitch(O)
Jan  6 19:23:51 localhost kernel: [77873.116637] Pid: 21940, comm:
kworker/u:2 Tainted: G           O 3.7.1-geek-note #1
Jan  6 19:23:51 localhost kernel: [77873.116640] Call Trace:
Jan  6 19:23:51 localhost kernel: [77873.116664]  [<ffffffff81004988>]
dump_trace+0x88/0x300
Jan  6 19:23:51 localhost kernel: [77873.116679]  [<ffffffff81b3915e>]
dump_stack+0x72/0x78
Jan  6 19:23:51 localhost kernel: [77873.116684]  [<ffffffff8105d9eb>]
warn_slowpath_common+0x7b/0xc0
Jan  6 19:23:51 localhost kernel: [77873.116690]  [<ffffffffa00f8421>]
brcms_c_wait_for_tx_completion+0x91/0xa0 [brcmsmac]
Jan  6 19:23:51 localhost kernel: [77873.116709]  [<ffffffffa00eb1a2>]
brcms_ops_flush+0x32/0x50 [brcmsmac]
Jan  6 19:23:51 localhost kernel: [77873.116717]  [<ffffffffa0029ecc>]
ieee80211_mgd_probe_ap.part.44+0x12c/0x150 [mac80211]
Jan  6 19:23:51 localhost kernel: [77873.116754]  [<ffffffff81074b42>]
process_one_work+0x112/0x370
Jan  6 19:23:51 localhost kernel: [77873.116758]  [<ffffffff8107633a>]
worker_thread+0x15a/0x3e0
Jan  6 19:23:51 localhost kernel: [77873.116762]  [<ffffffff8107af03>]
kthread+0xb3/0xc0
Jan  6 19:23:51 localhost kernel: [77873.116766]  [<ffffffff81b469ac>]
ret_from_fork+0x7c/0xb0
Jan  6 19:23:51 localhost kernel: [77873.116770] ---[ end trace
37aa45c524256334 ]---

Can somebody help me to debug this issue and finally fix it?

--
Best regards,
mva


--------------enig02853AAD404DA20A09270F8D
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.19 (GNU/Linux)
Comment: Using GnuPG with undefined - http://www.enigmail.net/

iQIcBAEBAgAGBQJQ7QzkAAoJECZQPTSbOzNLabEQAIVc+JQjgjY6AajXKRlVfn/E
NI90unRZu80wKQHgqTH2V8YqasTNqrjWqioU4lzw/30B0Wb2EFE0NOwIMens73y+
ZdX17FKrR67JChoUdz+uDLE7D6rAhbRHFNpf/kPWLKwuVYyrYsiRWa6xpwHlN0xA
6vzjNsNBWDT1iakhmwq1VMGztxtxUU9u0V9uXIUKcG1WUTJqkwDjteYAGgSPvSZa
e510QyZSX2M90DdNBczxg030n6kuSNt6aeqYtT2FTOICFCqj4UjOu68C8MU4b85p
cD/HFSRK5uJRgn+uCv4MIq4OS+kcX3jVfHvlkJ+9FwNWNNVzEgQc4EBpFMts+RC5
7Geahy2xaR8JoH35nVJ/2WyZTQmiO+4uaD0Vpc80Tvvs+7+V0gGCa6T5zN1+9qxV
d9FzuhkPQIJyAv9x+SlysK/EmHgL6LINm5qnzLj0pRJiA71YP8sLw7e3BvRDD0JM
9ipxi42aM60wjmLOEadDDZNJzq2il9GPfiJroEHCnLtd7UqRERIYNJrvYqNQVxZv
2UlKiBoMZlml7XY43VbGoAJEYF5yX9/mHwpSNhNp+2YekAuUQ6CVoomYJH6zX3LC
0UzDHW91Oh5T/IxavhzAfUEV8uBZbqbyFJW9wMw+kKsJ0NdJoiBxfk/zm3pUpv6Q
2fYyNxDl3jS0aFdjQ4mV
=3IJz
-----END PGP SIGNATURE-----

--------------enig02853AAD404DA20A09270F8D--
