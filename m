Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from crystal.sipsolutions.net ([195.210.38.204]:49855 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753358AbXFKIVx (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 11 Jun 2007 04:21:53 -0400
Subject: Re: [PATCH 2/6] mac80211: remove global tsinfo debugfs variables
From: Johannes Berg <johannes@sipsolutions.net>
To: Zhu Yi <yi.zhu@intel.com>
Cc: linux-wireless@vger.kernel.org,
	"John W. Linville" <linville@tuxdriver.com>
In-Reply-To: <1181530652.3042.27.camel@debian.sh.intel.com>
References: <20070608170342.GA17253@mail.intel.com>
	 <1181331767.6533.98.camel@johannes.berg>
	 <1181530652.3042.27.camel@debian.sh.intel.com>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-y0SxiQ9s8mquJ4F5ngCO"
Date: Mon, 11 Jun 2007 10:21:49 +0200
Message-Id: <1181550109.3566.38.camel@johannes.berg>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-y0SxiQ9s8mquJ4F5ngCO
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Mon, 2007-06-11 at 10:57 +0800, Zhu Yi wrote:

> When I sent the patch the first time which used sysfs, the comment was
> one value per file (Is this still true for debugfs?).

Hah, yeah, that's the regular rule for sysfs, but debugfs basically has
no rules ;)

> The DLS is easier because it only has one parameter (peer mac address)
> now. I programed it the same way as tspec. So when we find to need more
> parameters for DLS setup, we can add another debugfs file for the new
> parameter instead of combining multiple parameters in one file.

Alright. I don't think it matters much anyway.

> I'd agree I didn't pay a lot of attentions to the debugfs interface
> design since I thought it was used for occasional debug only. Please
> tell me what which do you prefer: one value per file or multiple values
> per file so that we can do one shot parameter passing? So I don't need
> to switch them back and forth.

No, don't bother, too much work for too little gain. Maybe gather some
thoughts on the nl80211 interface instead :) I personally prefer
one-shot parameter passing because it's closer to what we'll be doing
with nl80211 so we can model the interface like nl80211, however, the
interface between the debugfs and the regular mac80211 code could still
be modelled after nl80211 (it could even call some cfg80211 stuff when
that's added)

johannes

--=-y0SxiQ9s8mquJ4F5ngCO
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iD8DBQBGbQYd/ETPhpq3jKURAnwWAKCFUxWjPLsVePgqoI610XI9Js+46gCgl7Wv
dRnoUJBn9LBorIXtlbxkyVc=
=D2vj
-----END PGP SIGNATURE-----

--=-y0SxiQ9s8mquJ4F5ngCO--

