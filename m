Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from crystal.sipsolutions.net ([195.210.38.204]:57072 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752129AbXCHPch (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 8 Mar 2007 10:32:37 -0500
Subject: Re: [PATCH] mac80211: Properly kill tasklets before shutdown
From: Johannes Berg <johannes@sipsolutions.net>
To: Michael Buesch <mb@bu3sch.de>
Cc: Jiri Benc <jbenc@suse.cz>, John Linville <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org
In-Reply-To: <200703061902.00001.mb@bu3sch.de>
References: <200703061902.00001.mb@bu3sch.de>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-tXLKUC5K2Blfxpc4NnKW"
Date: Thu, 08 Mar 2007 02:26:04 +0100
Message-Id: <1173317164.3546.41.camel@johannes.berg>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-tXLKUC5K2Blfxpc4NnKW
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Tue, 2007-03-06 at 19:01 +0100, Michael Buesch wrote:

> This fixes the tasklet related crash that was reported some time ago.

I agree with that :)
=20
> -	tasklet_disable(&local->tasklet);
> -	/* TODO: skb_queue should be empty here, no need to do anything? */
> +	tasklet_kill(&local->tx_pending_tasklet);
> +	tasklet_kill(&local->tasklet);

But I'm not sure this is sufficient. I think we can then leak pending
skbs. In my tests I've often gotten that warning message about the skb
queue not being empty (right before the crash). Or is that handled
elsewhere now?

johannes

--=-tXLKUC5K2Blfxpc4NnKW
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iD8DBQBF72Ys/ETPhpq3jKURAvTnAJsFqUKf7v+Y9g/R/4Ktl4rE31KAOACfdxW9
oZ+Fj4JTPmEA/0Emm7fqNnA=
=v/4f
-----END PGP SIGNATURE-----

--=-tXLKUC5K2Blfxpc4NnKW--

