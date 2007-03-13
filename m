Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from crystal.sipsolutions.net ([195.210.38.204]:54975 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752145AbXCMTls (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 13 Mar 2007 15:41:48 -0400
Subject: Re: wireless extensions vs. 64-bit architectures
From: Johannes Berg <johannes@sipsolutions.net>
To: jt@hpl.hp.com
Cc: Jouni Malinen <jkm@devicescape.com>, Michael Buesch <mb@bu3sch.de>,
	linux-wireless@vger.kernel.org, netdev <netdev@vger.kernel.org>,
	Jeff Garzik <jgarzik@pobox.com>, Dan Williams <dcbw@redhat.com>
In-Reply-To: <20070312175639.GA4048@bougret.hpl.hp.com>
References: <20070307020310.GA20466@bougret.hpl.hp.com>
	 <1173364747.14001.7.camel@johannes.berg>
	 <20070308184954.GA24485@bougret.hpl.hp.com>
	 <1173382042.3248.63.camel@johannes.berg>
	 <20070308193412.GG23040@devicescape.com>
	 <1173382802.3248.68.camel@johannes.berg>
	 <20070308221128.GA24884@bougret.hpl.hp.com>
	 <1173393326.3831.21.camel@johannes.berg>
	 <20070309213531.GA28070@bougret.hpl.hp.com>
	 <1173634801.3382.8.camel@johannes.berg>
	 <20070312175639.GA4048@bougret.hpl.hp.com>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-BhnTqRzedgficb9qNtSJ"
Date: Tue, 13 Mar 2007 20:42:05 +0100
Message-Id: <1173814925.12717.6.camel@johannes.berg>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-BhnTqRzedgficb9qNtSJ
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Mon, 2007-03-12 at 10:56 -0700, Jean Tourrilhes wrote:

> 	I did that in the e-mail to Jouni. The problem is that most
> people are unfamiliar with decoding iwevents, so can't grasp the
> explanation.
> 	Basically, for iwpoint, we have an outer lenght and an inner
> length. If they don't match, we have an alignement issue and just need
> to pick the payload 8 bytes after the expected location.
> 	For other events, they have a well known size. If the outer
> lenght is not the expected size, but is expected+4, you just pick the
> payload 4 bytes after the expected location.

Ok.

So the plan now is to put this document up somewhere maybe with some
graphics or whatever, and then send this to distros so they know what
happens when people hit this bug.

Does your new version work without padding even on 64-bit arches? Then
in a few years we can actually remove the padding completely in the
kernel, right?

johannes

--=-BhnTqRzedgficb9qNtSJ
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iD8DBQBF9v6N/ETPhpq3jKURAv02AJ4h2xXmx4/I80BpDB65r4bcKHhPLQCfZxF+
XAFf/5dT2bv11B6azhP0EGE=
=yJcz
-----END PGP SIGNATURE-----

--=-BhnTqRzedgficb9qNtSJ--

