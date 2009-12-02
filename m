Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:59511 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751793AbZLBBng (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 1 Dec 2009 20:43:36 -0500
Subject: Re: [PATCH] mac80211: allow disabling 40MHz on 2.4GHz
From: Johannes Berg <johannes@sipsolutions.net>
To: Pavel Roskin <proski@gnu.org>
Cc: "Luis R. Rodriguez" <mcgrof@gmail.com>,
	John Linville <linville@tuxdriver.com>,
	linux-wireless <linux-wireless@vger.kernel.org>
In-Reply-To: <1259716754.11611.6.camel@mj>
References: <1259688582.32171.97.camel@johannes.local>
	 <1259691446.4806.12.camel@mj>  <1259692053.32171.98.camel@johannes.local>
	 <43e72e890912011118w535781a4id4e4572df16267f4@mail.gmail.com>
	 <1259716754.11611.6.camel@mj>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="=-1Bft5ms4P5oij5gdvc2S"
Date: Wed, 02 Dec 2009 02:43:10 +0100
Message-ID: <1259718190.32171.146.camel@johannes.local>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-1Bft5ms4P5oij5gdvc2S
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, 2009-12-01 at 20:19 -0500, Pavel Roskin wrote:

> Anyway, I think that using module parameters for any configuration
> creates a bad precedent.  Disabling HT40 in the 2.4GHz band is a "fine
> tuning" compared to other settings.  But there may be many other such
> "knobs" (e.g. ACK timeout), and if they all are controlled by mac80211
> parameters, it would be a maintenance nightmare.

ACK timeout is a quite different knob. This particular setting is mostly
required for some interoperability testing, but otherwise serves no real
purpose since the AP can always disable 40 MHz anyway, and if it doesn't
then it's very likely that somebody will use 40 MHz with the AP.

In this case, the real solution to the interoperability problem would be
using the frequency broker, but that can hardly be implemented in a
reasonable time frame.

However, the real problem lies with interoperability testing and
certification with a system based around mac80211. In that case, the
frequency broker does not help even if it were implemented.

As such, I believe using a module parameter for a rarely used setting is
a good trade-off, there's no real need to set this on the fly, but it
does sometimes need to be set on boot (which is much easier to achieve
this way) -- yet most of the time, apart from building complete systems
based on the software, nobody cares.

Now, you could make a point that it could be an out-of-tree patch for
those systems that actually do require this type of interoperability
testing and certification that requires this setting, but that is not
very maintainable.

> If module parameters are discourages for the drivers, mac80211 should
> be held to the same standard.

And I would argue that it is -- module parameters are still discouraged,
that doesn't change with adding one. We currently have one in mac80211
to chose the rate control algorithm, but it too is a special case and
ought to not be required.

I don't see this parameter as configuration like ack timeout or 10mhz
channels or ... I think this parameter solves a systems integration
issue, not a configuration issue.

johannes

--=-1Bft5ms4P5oij5gdvc2S
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----

iQIcBAABAgAGBQJLFcYqAAoJEODzc/N7+QmaDyEP/3Np/YZpEYrQ2+Z80YZfNoKJ
5IMKAv76fJz3UR7icb0XGf1VAShQ6sOlXIfWqbRHauZy6sKGZf9yR5SAcACkOG1K
/cvgr6brTAHoPL+wyPHFOsrqg95JyhctpDvL+dhz+LMm87Kmu9t3ZVjZVBlR+jI7
QSEu9NnRDQ4G13l9cMu04EqVECMCh3rghwjk1+1SMiNczPQ8PmIevdjQlxfRXzS9
SOON4gqqSvcWen9wljHYkB+IT8EYvQAUiJOd7irtIS8NRSLRkWpuGObtSQviS6Am
+8KUpio7zGVsTEyLtU2w9qu4wYlzTjtbLYqu/mgLdt8fbpfEtthVk3nwITX5TRzt
nUXZdfjKfriI1/QC9NAj8U0jLPLgxVjo8f7CTafWPYAibVbl90VbBOkvRPxqHl+t
RtRtEK+TnqTgOtw83udOsIsW6e+3rxO3CWBYfOWeUsxWDFJYAuBR3r+XAIM3LIc/
OmlbjVkIYlzdkj2CdtCcoHqHYRlX23YJtEKK3Um9rRPzWm2DRiMngPFQZrMXc9qU
y2Rx981NYy6FbBJb44q9lEdeSAbknJNLYA1aUE7IarMQoQ6+l8wLF7/JdPVSK6Zw
4CRP3JtvpegTuk0dTVkoaVpA5fIieAZYXEHQohfV4p9nSeEJCjgMeKuxYqg01CHW
+KDlEknpbmW/8LjSXHYL
=6tiZ
-----END PGP SIGNATURE-----

--=-1Bft5ms4P5oij5gdvc2S--

