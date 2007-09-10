Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from crystal.sipsolutions.net ([195.210.38.204]:40834 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751772AbXIJKuz (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 10 Sep 2007 06:50:55 -0400
Subject: Re: zd-mac80211: Fix TX status reports.
From: Johannes Berg <johannes@sipsolutions.net>
To: Michael Buesch <mb@bu3sch.de>
Cc: Ulrich Kunitz <kune@deine-taler.de>, Daniel Drake <dsd@gentoo.org>,
	John Linville <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org
In-Reply-To: <200709091259.00237.mb@bu3sch.de>
References: <200709082341.31720.mb@bu3sch.de>
	 <20070909100530.GB12021@deine-taler.de>  <200709091259.00237.mb@bu3sch.de>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-CzyHl8NNF2c1jAajd01s"
Date: Mon, 10 Sep 2007 12:52:21 +0200
Message-Id: <1189421542.4506.46.camel@johannes.berg>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-CzyHl8NNF2c1jAajd01s
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Sun, 2007-09-09 at 12:58 +0200, Michael Buesch wrote:

> Basically, the TX status report is only useful for the rate control
> algorithm. So it's basically "only" statistics. But we have to
> get these statistics approximately right to get the RC algo working
> correctly. That is what this patch does. With it, the RC algo properly
> scales up and down if the signal gets better or worse.

Michael, this is unfortunately not true. At least hostapd relies on the
ack callback because it requires stations to acknowledge the association
response before advancing the state machine, and we have also made
monitoring outgoing packets depend on the ack callback.

> > > Johannes, to me it seems that there's also a bug in mac80211.
> > > I never get a frame with the REQ_TX_STATUS bit set, so frames
> > > will always end up on the "unreliable" tx status queue.

Yes, this is by design, you will only get the bit set on any frame if
hostapd requested it via setting one of the version bits when sending a
frame on the management interface.

> Well, I think the driver should ignore that flag in any case, as
> mac80211 does handle it internally.
> Especially on devices like the zd, which don't support TX status
> reporting in hw, we should gather as much information as possible
> and pass it to mac80211 to get the RC algorithm working.
> mac80211 will handle the unrequested status requests with more care,
> so that's OK.

This is a really fine line to walk. For "good" rate scaling like
minstrel or such you really need multiple retry rates per packet and
such; for "simple" rate scaling just statistics are sufficient. However,
in the case of hostapd, having the tx status callback be precise is
actually required for *correctness*.

johannes

--=-CzyHl8NNF2c1jAajd01s
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iD8DBQBG5SHl/ETPhpq3jKURAleDAJ0UpZs0NWUbpZOdc0BQ4USExE5mfQCfX118
RVxRRWy0iUayVpmABjX5A+Y=
=+tg2
-----END PGP SIGNATURE-----

--=-CzyHl8NNF2c1jAajd01s--

