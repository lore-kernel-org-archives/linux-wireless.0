Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from crystal.sipsolutions.net ([195.210.38.204]:56497 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752710AbXLJQXj (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 10 Dec 2007 11:23:39 -0500
Subject: Re: coding style lesson: iwlwifi vs. endianness
From: Johannes Berg <johannes@sipsolutions.net>
To: Tomas Winkler <tomasw@gmail.com>
Cc: "John W. Linville" <linville@tuxdriver.com>,
	Dan Williams <dcbw@redhat.com>,
	linux-wireless <linux-wireless@vger.kernel.org>,
	Zhu Yi <yi.zhu@intel.com>,
	Reinette Chatre <reinette.chatre@intel.com>
In-Reply-To: <1ba2fa240712100810s1216bee4v8142fb9a279feedf@mail.gmail.com> (sfid-20071210_161015_599477_99D634D7)
References: <1196189059.6058.95.camel@johannes.berg>
	 <1ba2fa240711281020n6052980cl610f6c790788d2da@mail.gmail.com>
	 <1196286192.4967.29.camel@localhost.localdomain>
	 <20071129005810.GA6161@tuxdriver.com>
	 <1ba2fa240711291502k65cefd5au60f2c22d6f436c82@mail.gmail.com>
	 <1197286949.6035.49.camel@johannes.berg>
	 <1ba2fa240712100618g35a8e13ve143f8687f1b531a@mail.gmail.com>
	 <1197299937.6035.81.camel@johannes.berg>
	 <1ba2fa240712100810s1216bee4v8142fb9a279feedf@mail.gmail.com>
	 (sfid-20071210_161015_599477_99D634D7)
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-ZsAXAw7OYljvyTrwss33"
Date: Mon, 10 Dec 2007 17:23:13 +0100
Message-Id: <1197303793.6035.98.camel@johannes.berg> (sfid-20071210_162342_470258_2A9EA820)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-ZsAXAw7OYljvyTrwss33
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable


> I'm not only loading the structure I'm using it all over the code. I
> don't have clean cut. You can blame me for that but that's another
> discussion.

I actually thought that was intentional to reduce the number of local
variables.

> We are going around the same issue all gain. I already agreed that
> your approach will be correct if we had more code of your example type
> then setting bits. But we are mostly setting bits.

Going from the definitions in the header files that's not true. I'm too
lazy to do actual stats though. Yes, there are many bits, but very often
you have two/three-bit values intermingled with flags.

> This is really arguing about taste and feel.=20

Sort of. Maybe all I'm saying is that you're (artificially) limiting the
number of people who can work on your drivers because all non-Intel
drivers use the opposing style of defining things in native byte-order
while you're hiding the endian conversion in the defines rather than
making it explicit in the code which is much easier to understand.

johannes

--=-ZsAXAw7OYljvyTrwss33
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIVAwUAR11n8KVg1VMiehFYAQLP/BAAsb/UooNZgbiKpTXdOmJFELGmn2ZtUcP/
oEcgv/jgcIkVzxF72uOsuo/OuNHI9Rxcf7TVULhVsY1aHlgEkgAhSyUb19FBYJFb
3JAubQT4lOG+fRS36azZ/YSqV25SwcqXv+AAMI5tJGM4VXx+a5UqWuEtU5KmW+by
QygS2c3UnL5tFb8N9WDyHLVTBW96w41I0eCykPQjsqOmu6xRG9m+A86vnuxtgUOF
KLz44mJVYq3BVkmxHnHERD9iEKwbFe181SZ1BNoFAsvaA1Ww52bIVbFIUXXY63dW
g/ajRFysuYkCrsAYxk0W3tjPFZI1i09culpgFk8TWXH1hFzpwOPQuqnTzjfH/xuv
84JLI/Gh16ED7mzsfUsu7c8WpWzJewg3HNTw2HAqqX9tD4KblS/GNJ9mWBDk4paH
4w9ZjZCOLJXCd7L3D/NxHeTkE1foW7t2jeaOSDXztwPUXn39DSkbNNMo90PxVHvm
HUJnX3vutPpWwu8qWsDJaPMe06y/qpASh4H2iWVT/d59q+qsZ2QphBIT2HjLLRaw
zauog3UyevYU+5kP83OYTqVe3rejLPDTwBi/D+RgOM6Xll1S3ctLmthfDEzskqrT
u8JZMjyx9JDWAcXMSV2T+tuyuQrYd814KCiRgReaJfW15nDlggPplwbRH/Ni+nrG
TumFzMHvQSY=
=BSAx
-----END PGP SIGNATURE-----

--=-ZsAXAw7OYljvyTrwss33--

