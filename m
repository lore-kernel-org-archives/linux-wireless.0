Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:34967 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750982AbYJUHFd (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 21 Oct 2008 03:05:33 -0400
Subject: Re: New Regulatory Domain Api.
From: Johannes Berg <johannes@sipsolutions.net>
To: "Luis R. Rodriguez" <lrodriguez@atheros.com>
Cc: Zhu Yi <yi.zhu@intel.com>,
	Marcel Holtmann <holtmann@linux.intel.com>,
	Luis Rodriguez <Luis.Rodriguez@atheros.com>,
	Tomas Winkler <tomasw@gmail.com>,
	"John W. Linville" <linville@tuxdriver.com>,
	"Kolekar, Abhijeet" <abhijeet.kolekar@intel.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
In-Reply-To: <43e72e890810201937l3be24156t2172590138fda132@mail.gmail.com> (sfid-20081021_043804_334625_50CEDAE0)
References: <20081015112517.GF6509@tesla>
	 <1224484685.18024.5.camel@johannes.berg>
	 <43e72e890810192346q5e0eadbcm26febe45392a2172@mail.gmail.com>
	 <1224485431.18024.12.camel@johannes.berg>
	 <43e72e890810192359g2bc75316v49377ddc9eded934@mail.gmail.com>
	 <1224487340.24677.192.camel@debian.sh.intel.com>
	 <1224520999.9386.72.camel@californication>
	 <1224552899.24677.245.camel@debian.sh.intel.com>
	 <43e72e890810201842o44db616ekd8d5bc66cd1006f@mail.gmail.com>
	 <1224554323.24677.248.camel@debian.sh.intel.com>
	 <43e72e890810201937l3be24156t2172590138fda132@mail.gmail.com>
	 (sfid-20081021_043804_334625_50CEDAE0)
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-sOEzeegg83su20ONg4ia"
Date: Tue, 21 Oct 2008 09:05:22 +0200
Message-Id: <1224572722.27899.87.camel@johannes.berg> (sfid-20081021_090538_222319_A3027F6E)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-sOEzeegg83su20ONg4ia
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Mon, 2008-10-20 at 19:37 -0700, Luis R. Rodriguez wrote:

> As I mentioned in my previous e-mail, the real problem is what you are
> asking for changes the entire regulatory design from: "disable
> everything and enable only this" to "enable everything except for
> elements I don't define in the band I tell you to".

I don't think I agree.

>  There are many
> design flaws with this; an obvious problem to this is what is a band?
> In my patch I took the liberty to define that a frequency is part of a
> band if a rule was present within 2 GHz of itself. This works but it
> is trying to make a definition out of something that doesn't exist --
> its trying to solve the wrong problem. Since regulatory database is in
> KHz it is designed to allow us to grow regardless of band notions or
> associations. In the regulatory database we allow for 2 GHz, 5 GHz,
> etc KH  definitions for any country and this was designed to account
> for misinformation on drivers to help the user be more compliant. By
> changing the design to what you are suggesting you'd have to add a
> dummy rule for every frequency "band" if you really want to disable
> all other bands.

Yes, this is a problem, but then again it's fairly well-defined which is
2.4 and which is 5 GHz band, and it probably doesn't matter much at this
point. cfg80211 _has_ a notion of bands.

If we really wanted to have band-specific hints to let a driver say
"nay, sorry, I know nothing about 5 GHz" then we can I think do this,
subject to a few constraints:
 * first hint that contains a band wins this band
 * without any other information, a band that we know nothing about is
   disabled (just like the default state would be when we know nothing
   at all)

This ought to be possible, maybe by simply moving from

regulatory_hint(alpha2, structure)

to
regulatory_hint(alpha2)

regulatory_struct_hint(structure, bandflags)

where bandflags can be BIT(IEEE80211_BAND_2GHZ) or
BIT(IEEE80211_BAND_5GHZ). It would be fairly easy to keep track of that
information and build a common struct. No need to even bother looking at
the frequencies, when you have a 2GHZ hint and get a 5GHZ one you simply
add all the rules from the new hint. Yes, that could be abused to add
more 2GHz rules, but we can "police" that code. And it can only be
abused once because when the bit is already set we ignore the hint
anyway.

> The proper solution is to either add 5 GHz regulatory rules to your
> regulatory_hint()=20

I strongly disagree with that. It's not correct in any way.

> and/or rely on crda to enable the 5 GHz channels
> required for the country the user is in. It is true that you need
> manual intervention and the way I am trying to resolve that is not by
> changing the design of the current regulatory infrastructure, instead
> I want to add country selection support to say wpa_supplicant or
> Network Manager. That, IMO, is how to address the problem correctly.

This is, of course, the solution for !EMBEDDED, but I don't think that's
really what we're talking about.

johannes

--=-sOEzeegg83su20ONg4ia
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIbBAABAgAGBQJI/X8uAAoJEKVg1VMiehFYwrMP8QF6/BBNKz5WE4UW8LqiMGzz
ZCnNiPbpvAGOd6/SasNR8LpuJ0rz9fYk2A2otH8SjImzI5F2tc5fq1W4T6wkEu8D
VsBuzNo23bzIToYLXLkGSmDaSuFNyxU/NM8ggPkNd/KRyxkuupFM17agnnluCRjB
RLEbuUUb8zr5cHD+8hCZRDEBoRS4L6ijRyCfAft2K4rZCnCFnCjsFGxPY4d+IgN7
x8PoixFKM6BtcEQtCUS2Bj+UR1lQb2lFnRhBKnrM8O1XYexOq1H51fexe/XxL3jh
SvcktiFzy/vv7mkVBOwtRBkTaGTnZ6rOBx+m0YTrcIFMJe+xiXPlz00IX1FMZpTo
hrFAYYTQg3Dox+TNQbcvVcYv0lzROSdJFGWPh278hURJ5Jk7XBcXO2ipHz4XSrAk
tc7j3NZT4DKQsDVSsw3AypsJwGWCPdvxMehRG3Yk6LJRZGwGdpbUOi1SmKDPtf+O
lkMZ6FVhIpcPuyTnO0Rj9TGx8doJVBAAp7hAknSl7uJotyMCtbYNqeKED4gAVC4O
FFFHm7cO4sE0LCFrNVxoLmViBqkqfCLcPQDs4KY3LjVW+sOYwdGmFKp9jNIz3jBj
TPis5Jj99vv+U4Qk01nvL232YFzabyyTMxbqaPVxyoaXkZBm4EPpsuokgcOHqLoT
I63oSdLzEL9FxAnWvAA=
=VyWS
-----END PGP SIGNATURE-----

--=-sOEzeegg83su20ONg4ia--

