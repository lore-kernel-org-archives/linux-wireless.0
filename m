Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga14.intel.com ([143.182.124.37]:41621 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755267Ab2INN50 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 14 Sep 2012 09:57:26 -0400
Message-ID: <1347631355.5263.19.camel@sauron.fi.intel.com> (sfid-20120914_155739_466832_E192C723)
Subject: regression: tethering fails in 3.5 with iwlwifi
From: Artem Bityutskiy <artem.bityutskiy@linux.intel.com>
Reply-To: artem.bityutskiy@linux.intel.com
To: "Berg, Johannes" <johannes.berg@intel.com>
Cc: linux-wireless@vger.kernel.org
Date: Fri, 14 Sep 2012 17:02:35 +0300
In-Reply-To: <1DC40B07CD6EC041A66726C271A73AE6195AE9C8@IRSMSX102.ger.corp.intel.com>
References: <1347361823.26457.3.camel@sauron.fi.intel.com>
	 <1DC40B07CD6EC041A66726C271A73AE6195AE9C8@IRSMSX102.ger.corp.intel.com>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature";
	boundary="=-Q6/WRGZ28zHUYkPJXMpZ"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-Q6/WRGZ28zHUYkPJXMpZ
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Hi Johannes,

We are using iwlwifi driver in Tizen IVI. We were using kernel v3.4 and
wifi tethering worked fine. But after upgrading to v3.5 it stopped
working.

I am trying to bisect this already many hours - very difficult, because
tethering did not work in kernels around v3.4-rcX for some different
reasons, so just 'git bisect' does not work.

Anyway, what I found out is:

bad:  cb62ab7 Merge git://git.kernel.org/pub/scm/linux/kernel/git/davem/net=
-next
good: 31ed8e6 Merge branch 'dentry-cleanups' (dcache access cleanups and op=
timizations)

I spent a lot of time trying to bisect - tough, no luck. Then I the
following trick.

I reset to the last good commit: 31ed8e6

Now I know that Dave's tree broke tethering (merge cb62ab7 by Linus).

I start _partioally_ merge Dave's tree into 31ed8e6.

I found out this way the following:

bad:   816a785 David S. Miller Merge branch 'for-davem' of git://git.kernel=
.org/pub/scm/linux/kernel/git/linville/wireless-next
good:  011e3c6 David S. Miller Merge git://git.kernel.org/pub/scm/linux/ker=
nel/git/davem/net

Note, the second (good) line means that if you merge 011e3c6 to 31ed8e6
like this:

git reset --hard 31ed8e6
git merge 011e3c6

tethering works fine. The merge has no conflicts.

But if you merge 816a785 into 31ed8e6 like this:

git reset --hard 31ed8e6
git merge 011e3c6

then tethering does not work. There are non-trivial merge conflicts
though. Note also, that here I had to apply

bb3e10f mac80211: check IEEE80211_HW_QUEUE_CONTROL in ieee80211_check_queue=
s()

because without this patch there was an WARN() and nothing worked at
all.

This all means that one of the following broke tehering:

1. David's merge of the wireless tree which contains a lot of your
   iwlwifi changes.
2. The conflicts resolution.

How I resolved conflicts? I actually did the same David did it his
merge:

0d6c4a2 Merge git://git.kernel.org/pub/scm/linux/kernel/git/davem/net

This is maximum I can do without considerable amount of effort. Any idea
what would the bug be?

Could you also take a look at the conflict resolutions for iwlwifi in
0d6c4a2?

Thanks a lot!

--=20
Best Regards,
Artem Bityutskiy

--=-Q6/WRGZ28zHUYkPJXMpZ
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAABAgAGBQJQUzj7AAoJECmIfjd9wqK0o/kP/0sRRTqN03pKkqtne32cpZZ9
9lUBKQjjDXkkgULwK6eU8/OXxHi32cU4HPCmU/d3ky9+eE9GAh6NKQQn6CKVT+J0
5LuNSdGviuOm+oFf1k4BVDG4pfZaFIT6gwPjIWZTOsn5B3f6g+xIa/4Y73GsbtYW
6xybYPRuhV1MHbfNs48CO8PiwHVgY6ERcUCe9e6eqYb2zs92t1/jVX7CrmZI9UMf
IwTYPFwjcSenGg5TghR82ej1f3J81S1y5qEEaED7bm84AEDZaeGC/l/AFIMeitTj
sqSn5V8lkP6gKIsflHzpLRrbPWvlZtevoOHyqlJc5K07sGLIJcLX+Fp6RzUMDr6A
FSyTKoWUyLrmB8zN/iKmExFZr2aryKR6geQ5MScNuewO+TPrHRi+36NDSqUZcsSL
JtFQqB2780iql/CLDndZecHy7Bjioqv2csAerCJKd+/aic3ygS7leXiQjYq6MBiJ
i6y850wxIDSmlDcbcp632kC/nN2aphUvPkJY4GB3bjuOr7qpKcB1F+VmpADsUe6g
e51MkVnAF8Gl0GpvgGNMvH+Eq/TgRO3/ID6CElJwhlWpUKJtKHWr7yeG4QLUgq9T
VHH4BLKTpEBm8b/dhqXGa7hTXNFGnL3FALQEJmgx/7qm/jQWrmk7xZKGyjbUrC6y
+kbQqeTpG5JpNaCLRVf4
=NoZg
-----END PGP SIGNATURE-----

--=-Q6/WRGZ28zHUYkPJXMpZ--

