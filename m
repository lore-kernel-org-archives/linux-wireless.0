Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from crystal.sipsolutions.net ([195.210.38.204]:35553 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934345AbXFHKd7 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 8 Jun 2007 06:33:59 -0400
Subject: Re: userspace MLME
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Cc: "John W. Linville" <linville@tuxdriver.com>,
	Michael Wu <flamingice@sourmilk.net>, Jouni Malinen <j@w1.fi>,
	Zhu Yi <yi.zhu@intel.com>, Jiri Benc <jbenc@suse.cz>
In-Reply-To: <1181295319.6533.50.camel@johannes.berg>
References: <1181295319.6533.50.camel@johannes.berg>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-Wz6QH6wv94WW3yIgHklT"
Date: Fri, 08 Jun 2007 12:34:13 +0200
Message-Id: <1181298853.6533.58.camel@johannes.berg>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-Wz6QH6wv94WW3yIgHklT
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Fri, 2007-06-08 at 11:35 +0200, Johannes Berg wrote:

>  1) repost/integrate the injection patches

1b) do that filtering work we talked about
1c) implement the variety of monitor modes and that promisc bit
    passing through to drivers

> [1] Actually, I'd think that *all* commands should be forwarded to the
> userspace MLME except for commands *from* the userspace MLME. That way,
> the userspace MLME can act as a filter for commands which should make a
> whole bunch of things easier.

Ok so I just talked about this with Thomas Graf and Herbert Xu and
Herbert suggested that we solves the "single userspace MLME" only issue
in userspace. Then, we create a new multicast group for "userspace MLME"
that it signs up for. Then, we can use netlink_has_listeners to decide
whether there's a userspace MLME or not (we could even add a new command
"is userspace MLME present" based on that)

johannes

--=-Wz6QH6wv94WW3yIgHklT
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iD8DBQBGaTCl/ETPhpq3jKURAt8RAJ9IS8HyI+kn87AGr6Jz1X7uAcAEvgCfZsZl
i17LDgmTOF1kgVZI5pnDtK0=
=6MmS
-----END PGP SIGNATURE-----

--=-Wz6QH6wv94WW3yIgHklT--

