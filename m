Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from packetmixer.de ([79.140.42.25]:40868 "EHLO
        mail.mail.packetmixer.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753209AbdDROu4 (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 18 Apr 2017 10:50:56 -0400
From: Simon Wunderlich <sw@simonwunderlich.de>
To: Kalle Valo <kvalo@codeaurora.org>
Cc: ath10k@lists.infradead.org, ath9k-devel@qca.qualcomm.com,
        linux-wireless@vger.kernel.org,
        Mathias Kretschmer <mathias.kretschmer@fit.fraunhofer.de>,
        Ben Greear <greearb@candelatech.com>,
        Julian Calaby <julian.calaby@gmail.com>
Subject: Re: [v2,1/3] ath9k: Support channels in licensed bands
Date: Tue, 18 Apr 2017 16:50:52 +0200
Message-ID: <3170657.DNPqgEf8fi@prime> (sfid-20170418_165102_054888_5B1373BB)
In-Reply-To: <20170418143654.8AC0A60FAA@smtp.codeaurora.org>
References: <20170323133048.30062-2-sw@simonwunderlich.de> <20170418143654.8AC0A60FAA@smtp.codeaurora.org>
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="nextPart2143168.6jItE74DCN"; micalg="pgp-sha512"; protocol="application/pgp-signature"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

--nextPart2143168.6jItE74DCN
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"

Hi,

On Tuesday, April 18, 2017 2:36:54 PM CEST Kalle Valo wrote:
> Simon Wunderlich <sw@simonwunderlich.de> wrote:
> > From: Ben Greear <greearb@candelatech.com>
> > 
> > Many chips support channels in licensed bands. Add support for those,
> > along with a corresponding kernel config option to disable them by
> > default. Note that these channels are not selectable even if the
> > option has been compiled unless the user modifies the regulatory
> > database to explicitly enable the corresponding channels.
> > 
> > NOTE:  These channels must not be used in most regulatory
> > domains unless you have a license from the FCC or similar!
> > 
> > Signed-off-by: Ben Greear <greearb@candelatech.com>
> > [Hide this support behind a Kconfig option]
> > Signed-off-by: Julian Calaby <julian.calaby@gmail.com>
> > [only use the 20 mhz channels, add 5 ghz, change to 4.9ghz to licensed
> > bands, simplify] Signed-off-by: Simon Wunderlich <sw@simonwunderlich.de>
> > Signed-off-by: Mathias Kretschmer <mathias.kretschmer@fit.fraunhofer.de>
> 
> I am not sure that we should support unlicensed bands in Linux and hence
> hesitant to apply these. My view is that due to regulatory restrictions we
> should not make it too easy to use unlicensed bands. But I'm open for
> discussion, this is a challenging area and my knowledge here is limited.

thanks for your reply! I agree that we should not make it too easy, and 
therefore there are the following "obstacles" which should avoid accidental 
use of license bands:

 * we have the kernel CONFIG option which features a big fat warning
 * regulatory database must be tampered with to enabel the channels. In 
distributions, the regdb also gets signed. There is also the "internal regdb" 
CONFIG option if you compile your own kernel (rarely used, except for 
OpenWRT). In each case, a user must actively add the 4.9 GHz channels into it, 
because they are not included in the default regdb (and this should not 
change).
 * CFG80211_CERTIFICATION_ONUS is also required, which also says "you are on 
your own".

I had a comparison with ath5k, which also allows using those channels without 
at least the special configuration option (there is one enabling even more 
channels). The regdb "obstacle" is in place as well. However, ath5k is for 
very old chips and therefore the threat is limited.

In my personal view, we have quite a few obstacles which I consider "enough", 
but would be interesting to hear others opinions ...

Cheers,
      Simon
--nextPart2143168.6jItE74DCN
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part.
Content-Transfer-Encoding: 7Bit

-----BEGIN PGP SIGNATURE-----

iQIzBAABCgAdFiEE1ilQI7G+y+fdhnrfoSvjmEKSnqEFAlj2J8wACgkQoSvjmEKS
nqFFmBAAmdGgMdLutorSFpPauYucnNYi2aAIN0yaKgGz968dI6OYn2eYXkZKGjYo
kTIdLTDt1SORb41PU6Csda8FwDDdv+A9WJZT7mUZz4uD1/fRZpj5irq0Er9+5ikA
wbcmpSUlYKYnoWU1eRv5XMB7SjyWwAziPlZLA4+lGo+ga/YOXxq3dkIP/q2Xz5IF
Hc+X+OtYH1QWZSxraH3KRIjZke6y6ak82Ef/geqJ6WiPhbOcAFI5oNuRKGnZy3Ts
/srLgssUjWWBYTZ5+lc4cXEPT9PCtA31NoOvME7U12nA3v42NncdJVbjaDp+CSQJ
f3fvFd+r7mOWhxc4SwWtFL87XMww4HyikiSXFAjpJcbJpxOyEfiPgW/wSH74MGC/
lGeR+F4LYpG2Ymzob42XoxswFbik5BXhncMgih5F4qzC9qI9pfWEWRBh6PzNn2ZV
ImmEolkGq7OKjig0sO9xJxKG3f6xlbI+r2A+SUJiTafSLyxKnTqZ+Eu5YhrsdIrt
WRGEKLH3VHRfgYetGutEFB2PGXkTpLsKpu6vXjSvgFpPKAX7gQwZuszXiHHmsc95
X5ygcv0xvzgwwbBnQNB6jHmLCXr44r4TE6oO5oQL7A128XXWEnp3vR407woYwKOv
Dk9CNsdPfe5LtdqCq2ghob47rEcamA3q4oh5ni5xdVW0RyZKe7c=
=71q+
-----END PGP SIGNATURE-----

--nextPart2143168.6jItE74DCN--
