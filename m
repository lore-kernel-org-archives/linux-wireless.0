Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from crystal.sipsolutions.net ([195.210.38.204]:38255 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755949AbXH1J2k (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 28 Aug 2007 05:28:40 -0400
Subject: Re: [PATCH V2] Add iwlwifi wireless drivers
From: Johannes Berg <johannes@sipsolutions.net>
To: Zhu Yi <yi.zhu@intel.com>
Cc: Christoph Hellwig <hch@infradead.org>,
	linux-wireless@vger.kernel.org,
	"John W.Linville" <linville@tuxdriver.com>,
	Jeff Garzik <jgarzik@pobox.com>
In-Reply-To: <1188292031.13078.262.camel@debian.sh.intel.com>
References: <1188192012.13078.177.camel@debian.sh.intel.com>
	 <20070827131026.GA21137@infradead.org>
	 <1188285945.13078.242.camel@debian.sh.intel.com>
	 <1188291015.7837.67.camel@johannes.berg>
	 <1188292031.13078.262.camel@debian.sh.intel.com>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-Hy1WnAzDE7Mhzt+RUJx6"
Date: Tue, 28 Aug 2007 11:28:57 +0200
Message-Id: <1188293337.7837.79.camel@johannes.berg>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-Hy1WnAzDE7Mhzt+RUJx6
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Tue, 2007-08-28 at 17:07 +0800, Zhu Yi wrote:

> Because of the difference of the two hardwares (for example, in
> iwl-command.h, iwl_rxon_assoc_cmd differs between 3945 and 4965),
> runtime supporting is difficult if not possible (hw structures differs).
> So we select to do it statically by generating two drivers from one
> source code.

We used to be able to even runtime-select transmit headers in bcm43xx.

> Do you think if it is a good idea to split them into two drivers and
> make each of them "#include iwl-base.c"? Please don't hesitate to share
> if you have better ideas.

I thought that's what you do now?

I haven't looked into what the differences are.

Some things I plain don't understand, like this:
#if IWL =3D=3D 4965
#ifdef CONFIG_IWLWIFI_SENSITIVITY

why not just make the latter depend on 4965 in Kconfig? Same with HT.

johannes

--=-Hy1WnAzDE7Mhzt+RUJx6
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iD8DBQBG0+rZ/ETPhpq3jKURAqqmAJ0VX0s6x3tTg8xvKnaImJ0Fb2ytfwCfUuQE
7EmxyB4bmXwfim9QIkXe98E=
=up53
-----END PGP SIGNATURE-----

--=-Hy1WnAzDE7Mhzt+RUJx6--

