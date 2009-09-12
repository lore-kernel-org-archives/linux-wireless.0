Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:52191 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753682AbZILNMZ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 12 Sep 2009 09:12:25 -0400
Subject: Re: [PATCH 07/13] iwlwifi: clean up ht config a little
From: Johannes Berg <johannes@sipsolutions.net>
To: =?ISO-8859-1?Q?G=E1bor?= Stefanik <netrolller.3d@gmail.com>
Cc: Reinette Chatre <reinette.chatre@intel.com>,
	linville@tuxdriver.com, linux-wireless@vger.kernel.org,
	ipw3945-devel@lists.sourceforge.net
In-Reply-To: <69e28c910909111046m23414728nb9b56c53960340ea@mail.gmail.com>
References: <1252690699-25796-1-git-send-email-reinette.chatre@intel.com>
	 <1252690699-25796-8-git-send-email-reinette.chatre@intel.com>
	 <69e28c910909111046m23414728nb9b56c53960340ea@mail.gmail.com>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="=-ldXEBb6yPjJIiFSt62ZN"
Date: Sat, 12 Sep 2009 07:12:19 -0600
Message-Id: <1252761139.23427.22.camel@johannes.local>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-ldXEBb6yPjJIiFSt62ZN
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Fri, 2009-09-11 at 19:46 +0200, G=C3=A1bor Stefanik wrote:
> On Fri, Sep 11, 2009 at 7:38 PM, Reinette Chatre
> <reinette.chatre@intel.com> wrote:
> > From: Johannes Berg <johannes@sipsolutions.net>
> >
> > is_ht can be bool instead of u8, and there's
> > no need to use IWL_CHANNEL_WIDTH_* constants
> > in supported_chan_width when that could just
> > be named is_40mhz instead.
>=20
> What about is_ht40?

Wrong approach. If you want to clean it up further, I would suggest
replacing both "is_ht" and "is_40mhz" by the channel type as passed by
mac80211, or using conf_is_ht40() etc. instead. Didn't feel motivated
enough at this point though and just wanted to get rid of the extra
constants.

johannes

--=-ldXEBb6yPjJIiFSt62ZN
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----

iQIcBAABAgAGBQJKq54vAAoJEODzc/N7+QmafIAP/2ufHU10pWJ7qBCMzEoHzu/6
IEz7lb6847HtFTxCQo3iqvTNdSbvAwOZndgwZKmBb6jZ0t5G5TscnmUA6mzCWuTU
PXIlF5f3vCafcpCEVnsCpdNrGOe6DgoO/VYffbs+5aBZezTwCKPjWyTXgGmFEsuy
qtnWYO3v/0zIYxPKVvqIw++gq3GlfyjJdMMQ7BB7Or60MP8gvDimo32HyWZCQlFG
gHGQcx1kLe7Iusv8MVXDkMTA7EeMiWGaXLiBPitI7DNrZQdqJAhigLxIUR/7jJAF
oJzfBgiBLp8fq+m4MWLAr/tdolJTz/YWTeKQ/6fTJ6dtiB0u+rdCux2W4Rrif6aC
MH6yjIS9mv7wnPxwkF/caj3E5MRUWPVo5q/+g+X1yE3AE3JJkCCc7ahTWoLyaz3c
K6zKpxkNf7FM8lMvYHqjT1vXWys/AC8y7GBQr3oXuMIu5Ytvk5Nf55Pspkrzs5E+
Uj/6XZ3xvhkROlgyTNonJFWIYPc0oah/GTHbYxxUVph3qy7xcGGhuyhQQwiXetuq
CbRqk0ce9qII/CEeOs8QTDoobvHhyQbRQSIIPZM0g05Fgz5JKs68ap4ihUZlSzvw
LasBZtBkepMX3XwY45fqsIft+1kO7djKB+4FMp+zB1aS92NC3HHgRxKZG4etLW56
WzvatdCiMtPznwdHP7GK
=bxAW
-----END PGP SIGNATURE-----

--=-ldXEBb6yPjJIiFSt62ZN--

