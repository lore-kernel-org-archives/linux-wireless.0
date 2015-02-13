Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pa0-f53.google.com ([209.85.220.53]:54532 "EHLO
	mail-pa0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751594AbbBMHzt (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 13 Feb 2015 02:55:49 -0500
From: Mark Rustad <mrustad@gmail.com>
Message-ID: <54DDAE03.4000502@gmail.com> (sfid-20150213_085611_397646_FA569D67)
Date: Thu, 12 Feb 2015 23:55:47 -0800
MIME-Version: 1.0
To: Rasmus Villemoes <linux@rasmusvillemoes.dk>,
	"Rustad, Mark D" <mark.d.rustad@intel.com>
CC: Stanislaw Gruszka <sgruszka@redhat.com>,
	Kalle Valo <kvalo@codeaurora.org>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"netdev@vger.kernel.org" <netdev@vger.kernel.org>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] iwl4965: Enable checking of format strings
References: <1423695069-23436-1-git-send-email-linux@rasmusvillemoes.dk>	<60178C37-F104-430E-92EB-B6DDFAEB2F99@intel.com> <87vbj7zb0e.fsf@rasmusvillemoes.dk>
In-Reply-To: <87vbj7zb0e.fsf@rasmusvillemoes.dk>
Content-Type: text/plain; charset=windows-1252
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA1

On 2/12/15 2:20 AM, Rasmus Villemoes wrote:
> Rather weak arguments, but I have three of them :-)

Yes, weak. All three.

> (1) If I'm reading some code and spot a non-constant format
> argument, I sometimes track back to see how e.g. fmt_value is
> defined. If I then see it's a macro, I immediately think "ok, the
> compiler is doing type-checking". If it is a const char[], I have
> to remember that gcc also does it in that case (as opposed to for
> example const char*const).

GCC should check in both cases. The case you are replacing was not
const char * const, but only const char *. Still, the compiler really
should check either form, even though theoretically the pointer in the
latter case could be changed, but the initial const value should be a
good indication of what the parameters are expected to be. No real
reason for the compiler not to check it.

> (2) The names of these variables themselves may end up wasting a
> few bytes in the image.

Maybe in a debug image, but they should be stripped from any normal
image. Really not a factor.

> (3) gcc/the linker doesn't merge identical const char[] arrays
> across translation units. It also doesn't consider their tails for
> merging with string literals. So although these specific strings
> are unlikely to appear elsewhere, a string such as "%10u\n" or
> "max\n" couldn't be merged with one of the above.

I haven't checked, but there is no theoretical reason that const char
[] items could not be merged exactly as the literals are. Considering
the boundaries the compiler guys push on optimization, doing such
merging would be tame by comparison (speculative stores make me crazy).
-----BEGIN PGP SIGNATURE-----
Version: GnuPG/MacGPG2 v2.0.20 (Darwin)
Comment: GPGTools - http://gpgtools.org

iQIcBAEBAgAGBQJU3a3+AAoJEDwO/+eO4+5unvMP/jwxA4GmwC0d3VdGsVTJkMVd
zg+jwbkhnMiaEj6uPAwV5LXV/IGyuYFgNjoiNDg9RD3trV9/3YAxdAKw1ffO+PWe
lnmXSxaapLlCTapOsUdXPg88z9muQKrcfhnGyi+jt3BFeccXgtlHLsR0qVa4ddJw
KVHByPg+AlTSNzSnROxHH3UAbxEuZmDy+g+xfbEFLCKNCgtrSX5jGyG2vJIY3lhF
40VIdriUHz1QW4C1YYeJWMKwzml7Kln3u0T5MfDEtDfy6n7hiBhHczEgPjf7dnzd
aY4+VtKTyjPWLRhyDoJfR9maaV9TsYHpheSuUVzAGwvb85wH32ugdfmcW2RPnRfC
n9ThhtWd1WdJJpmq0xhLjc9bc3nrxJO8b2J/GMsT6SjGBhPGaaJSWY37UPhhOJOj
akKkA6QwD0u6Yoc3de7unGsiKWayD7e2k3w3bus+kCSspmyn/OnkzZRc0X3nXd20
suAWNZTalLWioqvI/hyvH3GMZxIuHTJoLRpTm+K7BQs7gBM9pD7OJOpn7XLtk2PM
zPfEj8fAUMV17lzFdBP+M+pGT3HzjWVwTIUgujdA4vL6eqB1W+3fR7kqjUuQYc69
aBaMde//i+HUPzTHZht2qXEb6K9EvSsz/XlhQrtAyu2gYY8PwchdZXH0NbAGqJ9C
4BEAO4HYJijd4vVSNBFO
=utge
-----END PGP SIGNATURE-----
