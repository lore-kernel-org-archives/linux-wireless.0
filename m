Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.rutgers.edu ([128.6.72.243]:40668 "EHLO
	annwn14.rutgers.edu" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S932299AbXBESOt (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 5 Feb 2007 13:14:49 -0500
From: Michael Wu <flamingice@sourmilk.net>
To: Johannes Berg <johannes@sipsolutions.net>
Subject: Re: [RFC PATCH 1/3] cfg80211 and nl80211
Date: Mon, 5 Feb 2007 13:14:17 -0500
Cc: "John W. Linville" <linville@tuxdriver.com>,
	linux-wireless <linux-wireless@vger.kernel.org>
References: <20070131013717.GA28076@tuxdriver.com> <200702051245.35452.flamingice@sourmilk.net> <1170697795.3572.32.camel@johannes.berg>
In-Reply-To: <1170697795.3572.32.camel@johannes.berg>
MIME-Version: 1.0
Content-Type: multipart/signed;
  boundary="nextPart8740476.D0fSR1xI37";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Message-Id: <200702051314.21627.flamingice@sourmilk.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

--nextPart8740476.D0fSR1xI37
Content-Type: text/plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline

On Monday 05 February 2007 12:49, Johannes Berg wrote:
> > Let's make monitor interfaces
> > resemble monitoring ethernet a little more by reporting both RXed frames
> > and TXed frames. *BSD does this too and it makes running ethereal on
> > monitor interfaces much more useful.
>
> We do this right now afaik.
>
Where? I don't remember getting TX frames when running ethereal on a monito=
r=20
interface.

> > TX frame reporting can be done simply in the
> > ieee80211_tx_status call, allowing the TX status to be reported on real
> > frames.
>
> I don't quite understand this comment. TX status reporting should go via
> nl80211.
>
If we report TXed frames at the point when the driver calls=20
ieee80211_tx_status, we know whether or not an ack was received. This=20
information can be added to the TX frame that is reported to the monitor=20
interface.

> > Doing this is actually somewhat orthogonal to packet injection via
> > netlink or monitor interface, but if we are reporting TXed frames with a
> > radiotap header, we might as well allow frame injection with a radiotap
> > frame for consistency.
>
> Well, it hasn't got much merit because for anything useful you'll need
> to get state information on nl80211.
>
I'm not sure what you mean. The program can get the configuration info it=20
needs from nl80211/cfg80211/WE and send/inject frames through the monitor=20
interface.

=2DMichael Wu

--nextPart8740476.D0fSR1xI37
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.5 (GNU/Linux)

iD8DBQBFx3P9T3Oqt9AH4aERAvQDAKCLzFWeIx3D1eI0Wf2LvoMUzCktpQCgqcR2
C5dzGkoMYVjZMLeE60DXX54=
=4qJR
-----END PGP SIGNATURE-----

--nextPart8740476.D0fSR1xI37--
-: 
To unsubscribe from this list: send the line "unsubscribe linux-wireless" in
the body of a message to majordomo@vger.kernel.org: 
More majordomo info at  http: //vger.kernel.org/majordomo-info.html
