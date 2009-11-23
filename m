Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:60368 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756841AbZKWLNK (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 23 Nov 2009 06:13:10 -0500
Subject: Re: [PATCH] mwl8k: split driver by chipset
From: Johannes Berg <johannes@sipsolutions.net>
To: Lennert Buytenhek <buytenh@wantstofly.org>
Cc: Dan Williams <dcbw@redhat.com>, linux-wireless@vger.kernel.org,
	"John W. Linville" <linville@tuxdriver.com>
In-Reply-To: <20091123110211.GS20214@mail.wantstofly.org>
References: <1258931158.12095.33.camel@localhost.localdomain>
	 <20091123110211.GS20214@mail.wantstofly.org>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="=-oHWuxFzG4lAfEXszxybR"
Date: Mon, 23 Nov 2009 12:13:09 +0100
Message-ID: <1258974789.7094.162.camel@johannes.local>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-oHWuxFzG4lAfEXszxybR
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Mon, 2009-11-23 at 12:02 +0100, Lennert Buytenhek wrote:

> I was wondering if we should really make the support for each chip a
> different kernel module as you did in your patch, but then I figured
> that this might be a good way to let the user choose whether to load
> AP or STA firmware if we have both available, which was still one of
> the unsolved problems.  I.e., make mwl8366_ap and mwl8366_sta, and
> then let the user choose which one to load.  Or is there a better way
> of doing this?

Try to load both at probe() time (via the async firmware loading
interface that I fixed up recently [1], that patch will be in .33), and
hang on to the firmware images [2]. Register the wiphy with appropriate
bits depending on which firmware files you found (and fail + unbind if
you didn't find any, cf. my ar9170 patch [3]). Then you can upload the
right firmware depending on the type of interface the user is adding.

(Maybe, if needed for EMBEDDED, allow the user to configure which
firmware you load.)

johannes

[1] http://johannes.sipsolutions.net/patches/kernel/all/LATEST/NNN-firmware=
-class-nowait.patch
[2] that is what my patch allows doing
[3] http://johannes.sipsolutions.net/patches/kernel/all/LATEST/NNN-ar9170-f=
irmware-request-async.patch

--=-oHWuxFzG4lAfEXszxybR
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----

iQIcBAABAgAGBQJLCm5BAAoJEODzc/N7+Qma5eQQAIpjsWbpyc3Kgrng33r+WYkV
HYjPObDLJRhv6/+fg0l4Oio6+TDdcomFL/o7DhmW3XFOSWkvGV/U/u/06D+U+sfK
yl4aaLxHDBJMIxbQFainssFRosZqKj/9cNH6pfSTIjoFGaMzJ0N/8cQjDGsRB58Q
oEVPtB9wBo3vJBiD2VKKmf7Ic+tnpGclH1IWkVylZTXrcwmbgMXmr4D8QkcDwI5T
8EXdF4xjRditaRZbo614dg7ig6TFOpYPTwSYo0ShnRppD15jq0D8KgPAhLwzjFYX
128TCxeoxLr1225JMRm9wXXbACLa4wuhL2qpTwEmBU0I24dwrfECKCI50pKpVK/e
CT8UETO6ypqBbg42J65waI/tvhJtYb3uHnN7ZTQ4HDe/8VSRU6Y9tGsMuj/0Vnnt
4y+OGGGtuVPO+8nnDy0MNUuNTozwqRMBFMrCQQu/OzaYnR+YWfuueFp8mZ5RagrG
f3/QrbLM/YclMPpN436lU8VxMIqFAUN8EPpeooy9vKPGJmDIiJ5DOCOm9TFBM2k2
+J+yx6Hol7awcr623XPq9XH3ERDLK1jWr+0Di5yW7D3QCvYxWMRsXCO3LpyLs2UK
lH1niQqX/ohUbltOCSR1GY4I1X5HqSKAsU6WFAontUIISFBJGUjnnU+C0IV1jTQ5
obxQLEpKoD6jcH9XZ4jQ
=dRAJ
-----END PGP SIGNATURE-----

--=-oHWuxFzG4lAfEXszxybR--

