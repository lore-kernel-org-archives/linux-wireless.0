Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:47366 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754635AbYFPIrZ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 16 Jun 2008 04:47:25 -0400
Subject: Re: [PATCH] iwlwifi: fix oops on wep key insertion
From: Johannes Berg <johannes@sipsolutions.net>
To: Tomas Winkler <tomasw@gmail.com>
Cc: Joonwoo Park <joonwpark81@gmail.com>,
	"John W. Linville" <linville@tuxdriver.com>,
	Dan Williams <dcbw@redhat.com>, JMF <tolas_feup@hotmail.com>,
	linux-wireless@vger.kernel.org
In-Reply-To: <1ba2fa240806150953t4b61b213y3488940ef05b762e@mail.gmail.com> (sfid-20080615_185357_450305_0D547871)
References: <1211865214-1640-1-git-send-email-joonwpark81@gmail.com>
	 <1ba2fa240805262341s62f017e7ka7502cbe55c1d348@mail.gmail.com>
	 <loom.20080527T105701-941@post.gmane.org>
	 <1ba2fa240805270541wadf0f16t2001528f39b37ea8@mail.gmail.com>
	 <1211896423.1746.9.camel@localhost.localdomain>
	 <20080528004100.GG7779@tuxdriver.com> <20080615164617.GA27699@tp64>
	 <1ba2fa240806150953t4b61b213y3488940ef05b762e@mail.gmail.com>
	 (sfid-20080615_185357_450305_0D547871)
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-ZW+EENb7dK0cWFvM1rPW"
Date: Mon, 16 Jun 2008 10:46:29 +0200
Message-Id: <1213605989.3803.24.camel@johannes.berg> (sfid-20080616_104729_393768_560CAD8A)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-ZW+EENb7dK0cWFvM1rPW
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable


> > [PATCH] wireless: Limit wep key size to 128/104-bits
> >
> > This patch prevents overflow which is occured by invalid long wep key
> > insertion
> >
> > $sudo iwconfig wlan0 enc AAAA-AAAA-AAAA-AAAA-AAAA-AAAA-AAAA-AAAA-AAAA-A=
AAA-AAAA-AAAA-AAAA-AAAA-AAAA-AAAA
> >
> > BUG: unable to handle kernel NULL pointer dereference at 00000000000000=
00
> > IP: [memcpy_c+0xb/0x20] memcpy_c+0xb/0x20
> > PGD 13a590067 PUD 12e471067 PMD 0
> > Oops: 0000 [1] PREEMPT SMP
> > CPU 1
> > ...
> > Pid: 10, comm: events/1 Not tainted 2.6.26-rc2 #9
> > ...
> > Call Trace:
> >  [iwl4965:iwl4965_rx_scan_start_notif+0xb/0x20] ? :iwl4965:iwl4965_enqu=
eue_hcmd+0x12b/0x220
> >  [hci_usb:init_module+0xe97/0x28cb0] :iwlcore:iwl_send_cmd_sync+0x67/0x=
290
> >  [save_trace+0x3f/0xb0] ? save_trace+0x3f/0xb0
> > ...
> >
> > Signed-off-by: Joonwoo Park <joonwpark81@gmail.com>
> > ---
> >  net/wireless/wext.c |   11 ++++++++++-

I'm sure Jean will cry murder because he expects there are some stupid
full-mac cards that actually support other sizes.

Can't somebody just post a patch to mac80211 that only accepts the two
correct sizes like cfg80211 does?

johannes

--=-ZW+EENb7dK0cWFvM1rPW
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIcBAABAgAGBQJIVihiAAoJEKVg1VMiehFYvykQAKCrECkMaa4XsoXklpRodsVv
Mc3+hrmhxvutV2l9WgH7G0lFf+0jJ2ZQY6JRRShvTAwIEIAmhv01ItR2P1GONECh
FeEDFwsaL/1GZ4c1beO+Cr+mkDOnOf1gviaDxh+RGFuZcWchniLwxC0JNrsVvnIO
QXeU4TmU9C8+kXgCAl9kAc8JlB5aYp30SpXX9e8ZfXsQZQm6w5j0yc9xV1yPNAXw
AQC4sNgjRgr9hIN98alb6lmtwdyeW+aXGzizJGv3uMkXlpx4tTYLIL5AFKPrSfd5
wFwQFbt3uHH673IAk0BUeIPtBY5v345HUHNRh67vOhPb/TOCiOpqRV8arnqKXuDe
zEWTnjZdgofbnufgXtt3E2fWRwtQaICO/iUcDHYMgUB4ucv83Nt1wLN0EQUTFtLF
gWPreBJvHKCluUWPOIpAYVRKZROP7tKVv2HmfeN8NaFbE+6UbPM1iKZzdzCtRdYp
TsqIbWgYBOfo+z6AhGK24MuNe1k66MEQneiChKpQG+TT3rd6NlEv3d391SR9Oeps
C4AyOQ36OV3B3zYqut6HeEjdoLi6xgwgbBjmlw/yNV98/3GFStx6vfrMDruxBLIY
dKmSSIh3lMd6tlSxESvpMgwOPSfpUFkGtvSCNmOY/t1xymhZQPkes+QUDA1GPyZe
Ul4lp1FSvXDrECCCpklz
=rJgu
-----END PGP SIGNATURE-----

--=-ZW+EENb7dK0cWFvM1rPW--

