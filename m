Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from crystal.sipsolutions.net ([195.210.38.204]:48735 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757999AbXFRIgZ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 18 Jun 2007 04:36:25 -0400
Subject: Re: nl/cfg80211 scan result/event handling
From: Johannes Berg <johannes@sipsolutions.net>
To: Dan Williams <dcbw@redhat.com>
Cc: linux-wireless@vger.kernel.org
In-Reply-To: <1182093224.14209.7.camel@xo-28-0B-88.localdomain>
References: <1182023372.9058.68.camel@johannes.berg>
	 <1182093224.14209.7.camel@xo-28-0B-88.localdomain>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-2AM3M0WRPabJ9lCrsRQO"
Date: Mon, 18 Jun 2007 10:37:03 +0200
Message-Id: <1182155823.5924.3.camel@johannes.berg>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-2AM3M0WRPabJ9lCrsRQO
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Sun, 2007-06-17 at 11:13 -0400, Dan Williams wrote:

> Just to be clear, 'struct wireless_dev' isn't tied to mac80211 at all,
> right?  Cause we're going to need to use these functions in fullmac
> drivers too.

Right. It completely lives in net/wireless or include/net/wireless.h and
is just the abstraction that cfg80211 requires to know that a given
netdev is wireless and where cfg80211 stores stuff it needs. You
allocate this along with the struct netdev and whatever private struct
you need.

>   And is the n_results/**sr stuff supposed to allow multiple
> scan results to be added?  If that's the case, you might want to make
> the function end with an 's' too, just to be clear.  "add_scan_result"
> makes it sound like it should just add one scan result.

Yeah, makes sense to add the 's'. I was thinking that some drivers get
everything in one go so it's more efficient to build it in one go wrt.
allocating the netlink message, but others get results piecewise and we
don't need to bother them with storing them. I'm not sure though whether
cfg80211 should centrally cache and expire scan results for when scan
results are requested but no new scan should be done. I think it
probably should.

> Sounds fine to me; this is essentially what we've got now and I think it
> works ok.  There's two cases where this would be used: (a) a triggered
> scan, and (b) background scan.  Should work fine in both cases.

Yeah, that should work in both cases, although some care will have to be
taken that no background scan goes active while a triggered scan is
running or something like that.

johannes

--=-2AM3M0WRPabJ9lCrsRQO
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iD8DBQBGdkQv/ETPhpq3jKURAr1OAKCHgdkNo0AVpyX7MpswmrVnx8PMxgCeNNfs
9wyghaozCxOBWYG0M/D5cVo=
=COTz
-----END PGP SIGNATURE-----

--=-2AM3M0WRPabJ9lCrsRQO--

