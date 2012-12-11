Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from cdptpa-omtalb.mail.rr.com ([75.180.132.120]:60787 "EHLO
	cdptpa-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753781Ab2LKXXP (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 11 Dec 2012 18:23:15 -0500
Date: Tue, 11 Dec 2012 18:23:11 -0500
From: Solomon Peachy <pizza@shaftnet.org>
To: "John W. Linville" <linville@tuxdriver.com>
Cc: Steev Klimaszewski <steev@genesi-usa.com>,
	Janusz Dziedzic <janusz.dziedzic@gmail.com>,
	Dmitry Tarnyagin <abi.dmitryt@gmail.com>,
	Johannes Berg <johannes@sipsolutions.net>,
	linux-wireless@vger.kernel.org
Subject: Re: [PATCHv2 00/21] cw1200: ST-Ericsson cw1200 wlan device driver
Message-ID: <20121211232311.GA9080@shaftnet.org> (sfid-20121212_002319_456404_CBA652A5)
References: <1330720003-15866-1-git-send-email-dmitry.tarnyagin@stericsson.com>
 <CAMG6FYjYMqf9C15Bid3hAfzTcB=gEXq8RWRcM9n+HNtvckgVZQ@mail.gmail.com>
 <CAFED-jk84vKMRr_NDThMqhZrnXt6ddhViztitB_=M_nKbC6c8Q@mail.gmail.com>
 <CA+Bgp3N2gUDoey-cXV+4sN0q+2Jm7+rPcu776FMUWxaR4F0qwg@mail.gmail.com>
 <20120706201839.GE1879@tuxdriver.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="7AUc2qLy4jB3hD7Z"
In-Reply-To: <20120706201839.GE1879@tuxdriver.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--7AUc2qLy4jB3hD7Z
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Fri, Jul 06, 2012 at 04:18:40PM -0400, John W. Linville wrote:
> Sorry, I kinda lost track of this.  I guess I was expecting a repost,
> including Bob Copeland's patches and something to address the endian
> issues mentioned by Kevin Groenevel.  Was anyone planning to address
> those concerns?  Also, I'm not sure that bit about needing custom
> SDD files was fully addressed?

Unfortunately, the SDD needs to be supplied by the module vendor, as=20
it's specific to the design.  Even more troubling is that there's a=20
register value we have to program that also depends on the design, and=20
there's no way to know that generically.  I've solved this by resorting=20
to platform data.

Anyway.  Onto my main point.

ST-E hasn't publically done any work on this driver since around April=20
2012, and they haven't given me an answer on whether or not it's been=20
abandoned.  In light of recent announcements relating to ST-E's future,=20
I'm not hopeful that it'll see any more official support.

That said, I've done a ton of work on this driver for my employer.  It=20
has far fewer bugs than what ST-E has previously released; including=20
fixing up major endian problems (I brought it up on a uClinux m68k=20
target for another client).  It's also vastly more stable, now has SPI=20
support, and has also managed to pass WFA testing.  That's not to say=20
it's bug-free, but it at least can be counted on to not HACF randomly.

I've been maintaining it on top of compat-wireless, and I'm wanting to=20
give it another upstream push, and be listed as the maintainer.  What's=20
the best way for me to do that?  The patch series they posted originally=20
(one file per patch) seems rather silly, but at the same time, doing it=20
all at once is a rather substantial chunk to digest/review.

> On top of that, there were some style quirks that I was hoping
> someone could address.  There were "if 0" blocks in the code, which
> is rather questionable.  Was anyone planning to remove them?  Also,
> the block comment formats seemed a little random.  In particular, the
> single-line "/* ********* */" thing looks a bit funny.  Perhaps that
> isn't the worst thing ever but if you are going to respin anyway than
> I'd prefer if you just deleted them.

The code I have has a lot of changes there, but I imagine there are more=20
remaining.  I'll have to go back and audit things, as I've since given=20
up on keeping my code close to ST-E's "upstream"

> There was also talk of a mac80211 patch needed to fix a bug observed
> with the driver as posted?  Has that mac80211 fix been posted and
> merged?  If not, when will we see it?

IIRC it's because mac80211 doesn't provide a way of pre-allocating MIC=20
space at the tail end of the frame -- the hardware performs the work but=20
still needs the space in the payload.  The code I'm maintaining has=20
workarounds for this; not the most efficient solution but I'd rather see=20
the code merged as-is, and then we can incrementally improve things=20
(perhaps by enhancing mac80211 as needed)

> So anyway, it seems like a repost of the current version (i.e. with
> Bob's fixes, etc) is in order?

I'll have to go back and see if any of those fixes are still relevant.

Anyway, let me know how I should proceed from here..

 - Solomon
--=20
Solomon Peachy        		       pizza at shaftnet dot org	=20
Melbourne, FL                          ^^ (mail/jabber/gtalk) ^^
Quidquid latine dictum sit, altum viditur.

--7AUc2qLy4jB3hD7Z
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iD8DBQFQx8BfPuLgii2759ARAsb/AKCMQU6ul8oaB3mHixmesBq5C/pG5QCg9uYc
aSAl2UIcwlLyDNQ/WWbB6Tk=
=Ib20
-----END PGP SIGNATURE-----

--7AUc2qLy4jB3hD7Z--
