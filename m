Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from packetmixer.de ([79.140.42.25]:52540 "EHLO
        mail.mail.packetmixer.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753138AbdAZJ4A (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 26 Jan 2017 04:56:00 -0500
From: Simon Wunderlich <sw@simonwunderlich.de>
To: Felix Fietkau <nbd@nbd.name>
Cc: linux-wireless@vger.kernel.org, kvalo@codeaurora.org
Subject: Re: [PATCH 3/4] ath9k: check for deaf rx path state
Date: Thu, 26 Jan 2017 10:50:19 +0100
Message-ID: <4839692.lfma8z9lJt@prime> (sfid-20170126_105610_526617_D002D8CE)
In-Reply-To: <20170125163654.66431-3-nbd@nbd.name>
References: <20170125163654.66431-1-nbd@nbd.name> <20170125163654.66431-3-nbd@nbd.name>
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="nextPart2169679.elQF2hiPPI"; micalg="pgp-sha512"; protocol="application/pgp-signature"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

--nextPart2169679.elQF2hiPPI
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"

Hey Felix,


On Wednesday, January 25, 2017 5:36:53 PM CET Felix Fietkau wrote:
> Various chips occasionally run into a state where the tx path still
> appears to be working normally, but the rx path is deaf.
> 
> There is no known register signature to check for this state explicitly,
> so use the lack of rx interrupts as an indicator.
> 
> This detection is prone to false positives, since a device could also
> simply be in an environment where there are no frames on the air.
> However, in this case doing a reset should be harmless since it's
> obviously not interrupting any real activity. To avoid confusion, call
> the reset counters in this case "Rx path inactive" instead of something
> like "Rx path deaf", since it may not be an indication of a real
> hardware failure.
> 
> Signed-off-by: Felix Fietkau <nbd@nbd.name>

As we observed in the field, it may happen that there are still RX interrupts 
triggered, but just a very low number - in which case I believe your version 
wouldn't fix the problem. Therefore we had a threshold in our original patch 
[1].

We would also appreciate if you can at least briefly mention our work if you 
resend/rework our stuff.

Thank you,
    Simon

[1] https://patchwork.kernel.org/patch/9433621/
--nextPart2169679.elQF2hiPPI
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part.
Content-Transfer-Encoding: 7Bit

-----BEGIN PGP SIGNATURE-----

iQIzBAABCgAdFiEE1ilQI7G+y+fdhnrfoSvjmEKSnqEFAliJxlsACgkQoSvjmEKS
nqGPhg//eN9e4wb9wz5rN6Ykin2nvw6lXFn6qq0p/kta9YXo4Dzy7vz9BGcX/BaS
LcyrwCQg9VGqUuTU30R6XAUOOx1C1/c0tk5KCyrURXODxmXvCt82Qdt+R78yq2n4
PDYDpCggjjBbvorlasOiIIcs09PvA7ak3nQfHwgSsUZcD10lbzEMT4GRq5TPHM1v
mhPlKb/yn/vXNZY7g6fL43pbACW87e1DhHTEyVPw25p1RnPLysTPxDvHkBoToraC
ZKbG/bcwQAIZ3xszcw7QMTKvpgGxlGw7aeBAhR6n4Qzg3xH3NXTX/HNrffyV+eRR
w3qdehVfAuSrQiOM8Ls7V8k+1//tAYMKFpEvqqMUZ56K1yqDC13gn7Fekv/JmL9K
7QjYdZ7U2sxziVre6TlS1wTuxT7x8Tk0ot9SMtlkfO7c6fBIUmZG5QJ06LOxNhHn
oriJVEHk1OXN2Rg24liQrAD9cJ77ldpttkeXJe1lxZ4yKQhoE4wHV1yXv8gu1pXs
rAQ0NJItjNjsZda1F5R+VHcLoNrRYZXD8eWSGEVnh0upIWncRe3uyIgFjqC2u75v
JmSIxEamEyzChPlF5n9VXedP1GnsVW9fovidf1JuuM/O0C3naIZpWBKtKy/Cnjm7
l5S1hsG3GgYBxvUGbKQw3FH30UlAVp54gFp4Unjv2BcAgIYK/YY=
=qLFs
-----END PGP SIGNATURE-----

--nextPart2169679.elQF2hiPPI--
