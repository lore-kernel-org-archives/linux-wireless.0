Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from www.zeus03.de ([194.117.254.33]:45830 "EHLO mail.zeus03.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S933384AbdEYHSg (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 25 May 2017 03:18:36 -0400
Date: Thu, 25 May 2017 09:18:34 +0200
From: Wolfram Sang <wsa@the-dreams.de>
To: "Tobin C. Harding" <me@tobin.cc>
Cc: linux-wireless@vger.kernel.org, devel@linuxdriverproject.org
Subject: Re: drivers/staging/ks7010 hardware test
Message-ID: <20170525071834.GA1458@katana> (sfid-20170525_091848_153336_B6DB306B)
References: <20170525051135.GA18753@eros>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="6c2NcOVqGQ03X4Wi"
In-Reply-To: <20170525051135.GA18753@eros>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--6c2NcOVqGQ03X4Wi
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Hi Tobin,

> I began testing the card you sent today. I'm getting a firmware load
> error like you mentioned.

Nice. Firstly, that means the card is alive and survived the mailing.

> I checked out code from when you originally merged into staging,
> however I built the module in a 4.9 kernel.

I think building a vanilla 4.9 kernel is a good choice. I did test the
card with v4.9. I am quite (but not perfectly) sure, I also tested it
with v4.10.

> To help me track down the issue could you please tell me what testing
> you managed to do successfully in the past, and if you can,
> approximately the date you were doing the tests or the git commit of
> the code you tested.

The tests I did are described here:

http://elinux.org/Tests:SDIO-KS7010

The branch I used is mentioned there

https://git.kernel.org/pub/scm/linux/kernel/git/wsa/linux.git/log/?h=renesas/topic/gen3-sdio

but it is based on a branch called renesas-drivers (which is some kind
of stripped down linux-next targeted for Renesas R-Car hardware), so I'd
think v4.9 is the better choice.

The tests were all done End of May 2016.

> Thanks. Oh, also could you please indicate your level of interest my
> continued efforts. I don't want to send you copious emails if you
> would rather me not.

I'm definately interested. I might not be able to review patches, but
for high level questions like this, please CC me. However, give me a few
days for a response.

> The error code is -EILSEQ (Illegal byte sequence). It is returned by
> sdio_memcpy_fromio(). I do not know what it signifies?

I use it rarely, but in this case, I'd think bisecting from v4.9 onwards
is a good choice to tackle this down (given that v4.9 works; otherwise
we'll have to check the MMC layer).

Thanks and all the best,

   Wolfram


--6c2NcOVqGQ03X4Wi
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEOZGx6rniZ1Gk92RdFA3kzBSgKbYFAlkmhUUACgkQFA3kzBSg
KbaNDw//ZEye4Kc1a3qXnB8xYr04wWCFYDlFkyvBr7WT9WY/JeBPKWXmr+2Q3iXr
6hPg441Rmw2Hkk5SNXHUnCzfCDsuKCGlOWIWGrrGuCI1clITI8eL2e1tiPcVqvF8
dZVqKggyEhu3gewsvr1zyn5jbvpb1gpfZaSVB5uTh+j8cHK+03wai/I4Oq5ADLV3
UHLxXP4hD8uCHq0kMhv8YxwzU3xR3Y4oVI8LO9Nw1BDWwqlXAMFaVjBdUn84B3sZ
yHS1WNvPHoxRaBnnNidv7lpN56rRWi9wadp3SH6DKZInXfsXACUqsMLjFot/mJHl
MuG7YzAzxOawKIBmwu1hrPqO/rI2Dd9kzjfbjb/rEWDQFAVZurdRck8OWEhphN1n
Kqt4cUzlcHuqHWYEB6btGMIldHRnoxH3t/i4DlDm/iv7jmbi90vfBiBatixbAEs9
58APIusG/cJtSZcJ58blAkTkY7xQBtSxcxH3RW1zfvoD/0AzvtG8ZrD8RxO7gcPY
/nle141r6twafH8FDkLORA4ARUbeKSTCHtv5twDktpE98w2NvIpsoAP7lulMdOo/
xHss+HmnmZeAIScQAQnghywvwehfdye+HRVmaNJPhetUdsK3000rCqyQEP0m28Bi
/udGpS6059kri9PwOsXEvXNPF4F3ttolXQ+KT98Ck/4EeX4lddk=
=zyde
-----END PGP SIGNATURE-----

--6c2NcOVqGQ03X4Wi--
