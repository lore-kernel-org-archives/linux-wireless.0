Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from bues.ch ([80.190.117.144]:39942 "EHLO bues.ch"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750998Ab3CWKfi (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sat, 23 Mar 2013 06:35:38 -0400
Date: Sat, 23 Mar 2013 11:35:17 +0100
From: Michael =?UTF-8?B?QsO8c2No?= <m@bues.ch>
To: =?UTF-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>
Cc: Larry Finger <Larry.Finger@lwfinger.net>,
	linux-wireless@vger.kernel.org, b43-dev@lists.infradead.org,
	isedev@gmail.com
Subject: Re: [PATCH] b43: A fix for DMA transmission sequence errors
Message-ID: <20130323113517.01906b0b@milhouse> (sfid-20130323_113542_805052_A881409C)
In-Reply-To: <CACna6rz75ecyy5CdaJfi=dRjrTh_Rg793Ub+-0QdVnCZNyV+Lg@mail.gmail.com>
References: <514a07c7.ZQz6MhmMaq58WJlA%Larry.Finger@lwfinger.net>
	<CACna6rz75ecyy5CdaJfi=dRjrTh_Rg793Ub+-0QdVnCZNyV+Lg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/uKzXFLyv0QY2hOYTnefKETt"; protocol="application/pgp-signature"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

--Sig_/uKzXFLyv0QY2hOYTnefKETt
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

On Sat, 23 Mar 2013 00:27:30 +0100
Rafa=C5=82 Mi=C5=82ecki <zajec5@gmail.com> wrote:

> Today I've plugged my 14e4:4315 and (unfortunately?) it's working
> pretty well. I hoped to reproduce some problems but failed to do so. I
> was transmitting for an hour with average speed 11MiB/s and didn't
> notice any DMA issues.
>=20
> I was using iperf with interval of 60 seconds and only 3 results
> showed some problems (8.5MiB/s, 2.5MiB/s, 4.5MiB/s). No disconnections
> however and no DMA errors. I just got "Group rekeying completed..." in
> wpa_supplicant.
>=20
> So as I can't reproduce this, I can't find any other fix for this
> issue, and there's no reason to stop this workaround. I'll just apply
> it and test over weekend to check for any regressions, but they are
> highly unlikely.

I don't really believe in this being a firmware bug.

Some b43 DMA engines (all?) have some alignment and page-boundary-crossing
constraints. I would rather guess that on some kernels with some options
turned on, alignment and/or boundary constraints are violated every
now and then. (and thus the packet never reaches the firmware).

I don't remember the details, though. Too long since I worked on that.
But a few sanity checks could probably be added to the code to check
this hypothesis.

Does the failing kernel/machine have any special things w.r.t. memory?
Like iommu, hugepages, whetever...

--=20
Michael

--Sig_/uKzXFLyv0QY2hOYTnefKETt
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJRTYVlAAoJEPUyvh2QjYsO+xQP/3yIpevmrHAhTJ0fy2z3wkkm
KzYmOoDhY1uoCeQdtaqSJyiF0zRJ9HmGrzapptRVpv2GiMoUs+B0PnP4mhqCVbI3
hXL6hvLqNb3s2YadhQPG3NWRasZCElA1STVVRhWciOFXriIDohMijcW7lKa+0XWR
bWT1txeHhu9cUWnSB6aETWcx1EduAwGoDy1kVRyR/6gbe64quxHNviX2wZ88eKBu
WMWoyJMmEO1GZgfIEKK9stHZRYt9pjFHClzd2+uWxzjE557/wniwLH659CAeMULl
LYFsCo19cKOjgTQ19iF282OR9dkHKBjwLYXIUPIU48SjjGOqtjSFYPvM7Y1bDC8j
XcWY0b7rP6qzr8IMGCghoI6Nw9CeTeUdgWOd3dxazklDzreIkFYeLf2nJEDNvfmO
A7LLGeOPfQjlCYO9Rh0FL2vE6125lcsW4XzeRRqG++iqFz3DIbEPRjYD7D1GDGX5
ps172GVKcikbsFBvdlWIl7LfBiNEpD3yGJDlRX1ITdYLtBuEB65LmvTGoLeSGiq1
Nz4AB2I3mtIZgyPHmRBfs+Xx0c0xeMpGdQGRzm23NeUrPUp7oird8zKFAAwHVbyn
zVbbid6kPOU6UC1YYKBrhvxp9nfgkzsyNW0oGSr4x7eGxbZ2FnrRUxSp0Hdix9mv
M3qOPpWf9tUEoQDr22Xk
=x7a4
-----END PGP SIGNATURE-----

--Sig_/uKzXFLyv0QY2hOYTnefKETt--
