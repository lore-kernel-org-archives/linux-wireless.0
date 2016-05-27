Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wm0-f46.google.com ([74.125.82.46]:38291 "EHLO
	mail-wm0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932456AbcE0Iq4 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 27 May 2016 04:46:56 -0400
Received: by mail-wm0-f46.google.com with SMTP id n129so128608994wmn.1
        for <linux-wireless@vger.kernel.org>; Fri, 27 May 2016 01:46:55 -0700 (PDT)
From: Sven Eckelmann <sven.eckelmann@open-mesh.com>
To: "Valo, Kalle" <kvalo@qca.qualcomm.com>
Cc: "ath10k@lists.infradead.org" <ath10k@lists.infradead.org>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH 0/2] ath10k: Add support for QCA9887
Date: Fri, 27 May 2016 10:46:49 +0200
Message-ID: <1505571.v1gM3hzMhG@bentobox> (sfid-20160527_104705_567396_23AE8ED3)
In-Reply-To: <87mvnc67yq.fsf@kamboji.qca.qualcomm.com>
References: <1568876.Six5hABE57@bentobox> <87mvnc67yq.fsf@kamboji.qca.qualcomm.com>
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="nextPart2241194.DfG80128bO"; micalg="pgp-sha512"; protocol="application/pgp-signature"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

--nextPart2241194.DfG80128bO
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"

On Thursday 26 May 2016 17:32:30 Valo, Kalle wrote:
> Sven Eckelmann <sven.eckelmann@open-mesh.com> writes:
> 
> > the QCA9887 chip is similar to the QCA988x chips. But it requires a special
> > firmware and uses a different calibration data source. Unfortunately, no
> > working firmware currently exists. But it is possible to create a semi working
> > one by binary patching the current version.
> 
> So what works and what doesn't?

We currently stopped everything related to QCA9887 and so I cannot give you an
exhaustive list. But right now basic AP functionality seems to work. The
signal level, coverage and performance was rather bad. I cannot give you
numbers anymore because the two actual tests with QCA9887 were done 1 year ago
and 1/2 year ago (you know why ;) ).

But maybe I should add that the results with the original AP147 firmware also
wasn't better.

The hardware also doesn't seem to be able to produce spectral frame results.
It is unknown whether it uses an incompatible format or whether the
firmware/hardware is just not capable to produce spectral results.

[...]
> I can upload a new version. So I need to add these flags:
> 
> ATH10K_FW_FEATURE_HAS_WMI_MGMT_TX
> ATH10K_FW_FEATURE_NO_P2P
> ATH10K_FW_FEATURE_SUPPORTS_SKIP_CLOCK_INIT
> 
> Anything else?

At least I didn't find more. Possible that more are needed - I would guess
that the question to the QCA firmware team is still pending.

[...]
> Should we add a warning message to ath10k that the QCA9887 support is
> experimental? That way users don't need to wonder why there are so many
> problems.

Yes, this would be a good idea. I personally wouldn't know where you want
to have this warning added. So maybe you just add it? Thanks

> There were some conflicts in patch 1. I fixed those now and pushed the
> patches to the pending branch for further testing:
> 
> https://git.kernel.org/cgit/linux/kernel/git/kvalo/ath.git/log/?h=master-pending
> 
> Unfortunately I don't have QCA9887 myself so I can't test these myself.
> I hope I didn't break anything.

Ah, yes. The new patches "clean up growing hw checks during safe and full reset"
and some QCA9884 stuff seems to have created some conflicts. I have redone my
patches on top of them and compared with your solution. We came up with the
exact same conflict resolution. So you can at least say that I would also
have broken it ;)

I have just created a compat-wireless based on your branch which I've tested
it with my QCA9887 test card. No new problems were detected.

Kind regards,
	Sven
--nextPart2241194.DfG80128bO
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part.
Content-Transfer-Encoding: 7Bit

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAABCgAGBQJXSAl5AAoJEF2HCgfBJntGmBQQAIbX6XHB2V6XKwF5b8tJzktH
SyVBLjcB+2qfV6IkKISpF7eMFKCL5X9yBJUxjJhVNo6HB+LUNfck307JnQIWOmVD
rQNBrM7yr6WsTUI/nkganps1PrPqyYOxK8xZ8p9yA1CtKXnPcFu7X+1NwmCaB1Lz
uBMx/KHM5pbBGcFXnr5GtBQibuoy2xhto+Zp5wvggKsA3hVt8xfV3Nt7E9jRDjVM
/qqoIwyVQ702GLx8/HKUaTYLWqb+Di2PDShiKtAPxLwwoa6vJVK30xHpb73eAJYX
pzLYcI4pnrAfMnBB68yk1pmdKwiJh828mX5p9wD+/ES40Zs+7/AfMeKiwwUoD/8u
UAIujDwXQp00HEDvbJg3C76E1OWzWHv//c/Okk+1Jqc5D0yurPVyFRIE+cHg82UR
DH8Cn4UlK6s0HOObhKOMV3tsIZBY2cwPEGamn+cScx0gFpgMromx+eFTbAYPqTHb
JZDL+1RvrPjllenlQt+0l7riBGtRG9DMrQ57tMtjuAUevOyKAyDFUo17jPuwSFgO
0QafvKTh5TIOnjr5WavwDMTSi51u9s3q2aiZZoyB358E6hDNC+q7UWrxtzKJKAqO
gP9Gmt+Fsbq3OOxZgLC1mpELRU895sxrX6aDxLI6xDwG/74PLd7ZfaV23d7ts4WV
R3UScxqNcXUrc83dSXn2
=3gHY
-----END PGP SIGNATURE-----

--nextPart2241194.DfG80128bO--

