Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from crystal.sipsolutions.net ([195.210.38.204]:51535 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751781AbXLXKYJ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 24 Dec 2007 05:24:09 -0500
Subject: Re: [PATCH] mac80211: Restore rx.fc before every invocation of
	ieee80211_invoke_rx_handlers
From: Johannes Berg <johannes@sipsolutions.net>
To: Zhu Yi <yi.zhu@intel.com>
Cc: Helmut Schaa <hschaa@suse.de>, linville@tuxdriver.com,
	linux-wireless@vger.kernel.org
In-Reply-To: <1198467294.3065.180.camel@debian.sh.intel.com>
References: <200712211516.35731.hschaa@suse.de>
	 (sfid-20071221_141215_108356_0F4BE6F7) <1198401880.4116.6.camel@johannes.berg>
	 <20071223123517.17ds9zttxc4goo00@imap.suse.de>
	 <1198417706.4000.1.camel@johannes.berg>
	 <1198467294.3065.180.camel@debian.sh.intel.com>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-SgJeMQc3iUN3jBfpa1oF"
Date: Mon, 24 Dec 2007 11:23:51 +0100
Message-Id: <1198491831.4103.17.camel@johannes.berg> (sfid-20071224_102420_116392_3DDB1798)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-SgJeMQc3iUN3jBfpa1oF
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable


> The patch looks fine to me. Hardware scanning is a trigger that makes
> the condition more likely to happen, the patch itself fixes the more
> general problem for multiple interfaces.

Yeah, I think so too.

> An off-topic question: should wmaster0 continue to execute more rx
> handlers (i.e ieee80211_rx_h_remove_qos_control) even if it knows it
> will drop them finially?

I don't think it does, does it? In prepare_for_handlers frames aren't
sent to the master device while not scanning.

johannes

--=-SgJeMQc3iUN3jBfpa1oF
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIVAwUAR2+ItqVg1VMiehFYAQKSqQ//Sln2Apc8aQ2sIM5sJWXBmE5d6NWWWTat
IdGHJ0oPz0vwnrPD5rZFLybKtuZFrveo4F9CBMCto5fvG/McR8toZDZlCSuaTDuy
iKgj8aIS/1hTNFyrpg8gIy7L9mTbOwJncD0oM970W8oLbzRLNvP0SsUBILKzHoal
/ikZOWczpUQWQ7mM2O8LKL1sB+mQqvsIl7xU6i77CuRt1EdmodObdcDWYJm9sydt
NIk02GfNb2rJhsTpMF/7u2riECEU1C11NV70YHg8hihnkb9dVdzZ9/LN8G1G6bBs
+3QDVS6gyNO7QEyG9pjG9+S3tAnaHpK5dWP3Ri284lqYgbxU1BZVojBoF99K+oI5
MIT0Uy9tVOwFHbOdfpBFFbcoIb8w3hK/DEP1GxaLcW0RDYTzIVtd/a1Yzrvc5rse
MFb16+wznK52MOyLcThbmsN61uSHYfJ6JZoElaw+VSRLvtMwQ2MY6cyyxPrH5315
1g0/Qkyc8MXXj8lyxgBJvZP0lT2XqIco9pTYmheSbF43zG3XfZB/TlTWNuIjJVdl
LSULd3TzYZbKMg21MuOpowdieSBIx8+wTxTrPBtZVF0QQEMz+BExyM5dMxwg5xc4
xRu3CEih8oHbfwXpiyZowLpp5K7fCE5KmDkdy7b6b/+nQfznVZ3UPWyDqCVDXrTY
McTskiH8rz0=
=cZdf
-----END PGP SIGNATURE-----

--=-SgJeMQc3iUN3jBfpa1oF--

