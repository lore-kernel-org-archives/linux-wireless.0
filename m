Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from crystal.sipsolutions.net ([195.210.38.204]:33580 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752325AbXKTQ2W (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 20 Nov 2007 11:28:22 -0500
Subject: RE: [PATCH] mac80211: hardware scan rework (V2)
From: Johannes Berg <johannes@sipsolutions.net>
To: "Cahill, Ben M" <ben.m.cahill@intel.com>
Cc: "Zhu, Yi" <yi.zhu@intel.com>, linville@tuxdriver.com,
	linux-wireless@vger.kernel.org,
	"Abbas, Mohamed" <mohamed.abbas@intel.com>
In-Reply-To: <4220499A1B034C4FA93B547BA01E1FF001746499@orsmsx413.amr.corp.intel.com>
References: <119553601948-git-send-email-yi.zhu@intel.com>
	 <1195566632.10920.39.camel@johannes.berg>
	 <4220499A1B034C4FA93B547BA01E1FF001746499@orsmsx413.amr.corp.intel.com>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-xw+nlWfuBKRKGmHnh+Ty"
Date: Tue, 20 Nov 2007 17:29:42 +0100
Message-Id: <1195576182.10920.54.camel@johannes.berg> (sfid-20071120_162826_525168_DE81EE68)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-xw+nlWfuBKRKGmHnh+Ty
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable


> The firmware-driven scan on 4965 (3945 also) returns to the original
> channel by itself. [...]

Right. Thanks for the description.

> Once done with the list, the scan engine returns to the service channel
> automatically.  While it *might* work okay to change or reset that
> channel, it is not necessary, and might be asking for trouble.

Well, in the patch right now the channel the user sets will be
completely ignored because the scan_finished thing doesn't reconfigure
the hardware as it should.

Since the user has an expectation that the working channel is changed
after setting it with the ioctl, the code should make sure. Since hw
scanning is mostly transparent to mac80211, the ioctl should imho be
passed to the driver right away. If there's a problem with setting it to
the hardware directly, the driver can cache it for until the firmware
scan finished, but I don't think we should do that in mac80211. It has
to be done somewhere though and just ignoring the setting is wrong.

johannes

--=-xw+nlWfuBKRKGmHnh+Ty
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIVAwUAR0MLdaVg1VMiehFYAQKAYw/+N3OCgND3F8vL8Hta1SJjaXWcqMqe2898
EDFhqWZAcZHv3KBMr08SL7Y3TR123/+t94VmqL0cRa6b+YnliAQnI8bDUXa50h4k
Fhi7J9HX3l+Ra4RCwPM01n3pLoyst751Skmc9bdX9RgVMLYbfWbztf7m/FQksKRa
dXtotDQGKJyd0CEmR0ZV3DCI7CYEfsp7gbOcPr7ABRaTw2VN0y/EVqBEDrxd+9uL
oApZijH/zjtPUSVGK3EiVa9GUhCpWSiGY5q0HlUQm5pC14l+4pmh6B/a213Izhf0
E4jtSwd48n9wM7GegeUD92n4l10LdFV4+wWkM0CXDrsO5IJ5mtnY97PLjNgYaUlU
zQRNkLOBa1kZjYkQP/Mw4oZAEvQWt4q8mP4Ui/ctpYUtQvxEJYtCbCoxqDHH8CSr
TjGfBTHaou38hnnDfF+WuVnDN1wrjfeQrCGxIRhHqDJV9d7rDRnV8wNUjNr3C8GA
FP1mIXlG+5TR3DcxALbFU6aIWyUNk9vxEPax2hEL/8p5USmgvVlxDV6yqYjn0FCB
CouagL/OgLdtjqvhElgXzwMqLMLOht/ABWQukbX7M6KPo7FuKVa/6zfL6hEaLoAi
Ujvt69iFuuXTxDXf4evvzTXL2UfgjrGFjsEzjkNOP+aXPCZ607+YXg2Aun+FVPeU
l3k0n3KcKcc=
=Lsdd
-----END PGP SIGNATURE-----

--=-xw+nlWfuBKRKGmHnh+Ty--

