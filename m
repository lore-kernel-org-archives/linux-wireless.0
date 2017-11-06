Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-qt0-f176.google.com ([209.85.216.176]:44938 "EHLO
        mail-qt0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752501AbdKFJCG (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 6 Nov 2017 04:02:06 -0500
Received: by mail-qt0-f176.google.com with SMTP id 8so10023155qtv.1
        for <linux-wireless@vger.kernel.org>; Mon, 06 Nov 2017 01:02:06 -0800 (PST)
From: Sven Eckelmann <sven.eckelmann@openmesh.com>
To: Sebastian Gottschall <s.gottschall@dd-wrt.com>
Cc: Kalle Valo <kvalo@qca.qualcomm.com>, ath10k@lists.infradead.org,
        akolli@qti.qualcomm.com, linux-wireless@vger.kernel.org
Subject: Re: ath10k: Fix reported HT MCS rates with NSS > 1
Date: Mon, 06 Nov 2017 10:02:00 +0100
Message-ID: <1960925.hkIbv4gX65@bentobox> (sfid-20171106_100229_459013_781AE9BB)
In-Reply-To: <d27a10b1-6323-ebf0-5c2d-4a9c3b8d978d@dd-wrt.com>
References: <20170511090930.18205-1-sven.eckelmann@openmesh.com> <1728147.6Xy77nSgBU@bentobox> <d27a10b1-6323-ebf0-5c2d-4a9c3b8d978d@dd-wrt.com>
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="nextPart2548788.amK8YvZs1P"; micalg="pgp-sha512"; protocol="application/pgp-signature"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

--nextPart2548788.amK8YvZs1P
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"

On Montag, 6. November 2017 09:28:42 CET Sebastian Gottschall wrote:
> Am 06.11.2017 um 09:23 schrieb Sven Eckelmann:
> > On Sonntag, 5. November 2017 10:22:22 CET Sebastian Gottschall wrote:
> >> the assumption made in this patch is obviously wrong (at least for more
> >> recent firmwares and 9984)
> >> my log is flooded with messages like
> >> [208802.803537] ath10k_pci 0001:03:00.0: Invalid VHT mcs 15 peer stats
> >> [208805.108515] ath10k_pci 0001:03:00.0: Invalid VHT mcs 15 peer stats
> >> [208821.747621] ath10k_pci 0001:03:00.0: Invalid VHT mcs 15 peer stats
> >> [208822.516599] ath10k_pci 0001:03:00.0: Invalid VHT mcs 15 peer stats
> >> [208841.257780] ath10k_pci 0001:03:00.0: Invalid VHT mcs 15 peer stats
[...]
> > This patch only splits WMI_RATE_PREAMBLE_HT & WMI_RATE_PREAMBLE_VHT. And for
> > WMI_RATE_PREAMBLE_HT (*not VHT*), it uses a slightly different approach. But
> > the WMI_RATE_PREAMBLE_VHT part (which you see in your logs) is basically
> > untouched.
> 
> then a question follows up. is this check really neccessary?

Until we find out what the heck VHT MCS 15 should mean in this context - maybe.
But to the message - no, the message is most likely not necessary for each 
received "invalid" peer tx stat.

Kind regards.
	Sven
--nextPart2548788.amK8YvZs1P
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part.
Content-Transfer-Encoding: 7Bit

-----BEGIN PGP SIGNATURE-----

iQIzBAABCgAdFiEEF10rh2Elc9zjMuACXYcKB8Eme0YFAloAJQgACgkQXYcKB8Em
e0ZADw/+KXXFru7VdgfVkdKULuBzCdeF1XU0TSJkzCdTR04SHm+7cKWFB7qV+D7H
09Ujo8TvqafHF8o+N05LyxyVXxNrOVnCsHonwAgjTQRWt2pIa1csD6rbGLkw2NMH
hAjbiD4BRnqyuPmD979+ceJQrH7Gueai16pce+IEciDKWlkjhv1akMPdcZz/DeFh
Zgw8ZuzHSWK3odZdQBRxIvhu/rBMiH5HAHuxAkSpnU66gQcduqAY4aomwbwRcsMO
PllgZ8ElkJK/LAqQlO4X3PHOwGNyG+gZnhFm95X755dBf8hzhcBYpnthN30WIL9c
mgwVFWuhhfgOMPKAyscGfnmh7bxT8gRs7zxAWqyvdrZgjus3i158y+hr1bqrtGKn
swExmP/sFtErqzoUiVmhkirXKMo84a/Qdyxs9ZIqGmM+UNEEUxLVYqnYDZ4JSUPH
s0WArFBSv6Jbhv7x9acqGu1C9A3NMfkac2rS3ziuf5gYUg7rQZ5Sxlztv9+Ju2Rc
X++Dp0UqvZ7rxM/uUIrPWNcwm6Zg+ds9Qi1dDOoNMi3GUb78AbvF7NoSHQzgs3fb
qYuoUV73c+xvRAcviFIEIdud1hlBNgvc8mUOX5oKmGLUzrdZGYcPjez42kPqqFmf
NcmUAUR5gacYZ+pHBUxyOujhf4rhfknd7xVwdxnFCh0gssOtWGg=
=j5Ri
-----END PGP SIGNATURE-----

--nextPart2548788.amK8YvZs1P--
