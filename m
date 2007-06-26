Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from crystal.sipsolutions.net ([195.210.38.204]:56014 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752213AbXFZLcX (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 26 Jun 2007 07:32:23 -0400
Received: from [131.234.77.29]
	by sipsolutions.net with esmtpsa (TLS-1.0:RSA_ARCFOUR_MD5:16)
	(Exim 4.67)
	(envelope-from <johannes@sipsolutions.net>)
	id 1I39HR-00044T-RA
	for linux-wireless@vger.kernel.org; Tue, 26 Jun 2007 12:32:21 +0100
Subject: Re: mac80211/bcm43xx deadlock
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
In-Reply-To: <1182848382.3830.5.camel@johannes.berg>
References: <1182848382.3830.5.camel@johannes.berg>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-Z2CC+Q3tjNQ9xSEM7tSj"
Date: Tue, 26 Jun 2007 12:14:09 +0200
Message-Id: <1182852849.3830.9.camel@johannes.berg>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-Z2CC+Q3tjNQ9xSEM7tSj
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Tue, 2007-06-26 at 10:59 +0200, Johannes Berg wrote:

> I haven't been able to analyse it yet, I dumped process stacks a few
> times and put the resulting log at
> http://johannes.sipsolutions.net/files/mac80211-bcm43xx-deadlock

Got it. ieee80211_sta_config_auth is running off the workqueue and doing
rtnl_lock while ieee80211_if_shutdown is trying to flush the workqueue
with the rtnl lock held. Nice one, anybody have ideas how to fix? Why
does ieee80211_sta_config_auth need to take the rtnl anyway?

johannes

--=-Z2CC+Q3tjNQ9xSEM7tSj
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iD8DBQBGgObx/ETPhpq3jKURAmGCAJ9M/CQLkVmHoHFyZ4lnKzsXXuJcbACcDaNp
Nr3PnkDl3YM5WWQnN9l2q9s=
=rod1
-----END PGP SIGNATURE-----

--=-Z2CC+Q3tjNQ9xSEM7tSj--

