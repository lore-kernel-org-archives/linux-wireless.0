Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-bw0-f13.google.com ([209.85.218.13]:63051 "EHLO
	mail-bw0-f13.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755281AbYLKS2n (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 11 Dec 2008 13:28:43 -0500
Received: by bwz6 with SMTP id 6so2590767bwz.13
        for <linux-wireless@vger.kernel.org>; Thu, 11 Dec 2008 10:28:41 -0800 (PST)
From: Henning Rogge <hrogge@googlemail.com>
To: Johannes Berg <johannes@sipsolutions.net>
Subject: Re: [Patch] nl80211: Add signal strength and bandwith to nl80211station info
Date: Thu, 11 Dec 2008 19:22:43 +0100
Cc: Henning Rogge <rogge@fgan.de>,
	"Luis R. Rodriguez" <lrodriguez@atheros.com>,
	Luis Rodriguez <Luis.Rodriguez@atheros.com>,
	Marcel Holtmann <holtmann@linux.intel.com>,
	"linux-wireless" <linux-wireless@vger.kernel.org>,
	"nbd@openwrt.org" <nbd@openwrt.org>
References: <200811252131.30161.hrogge@googlemail.com> <200812111902.24289.hrogge@googlemail.com> <1229019287.8081.49.camel@johannes.berg>
In-Reply-To: <1229019287.8081.49.camel@johannes.berg>
MIME-Version: 1.0
Content-Type: multipart/signed;
  boundary="nextPart1538116.C9pKTrN11k";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Message-Id: <200812111922.49439.hrogge@googlemail.com> (sfid-20081211_192847_477793_EF55F95A)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

--nextPart1538116.C9pKTrN11k
Content-Type: text/plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline

On Thursday 11 December 2008 19:14:47 you wrote:
> > Okay... I have included a casting to s8 into cfg.c so everyone is
> > warned... the original signal field in the sta_info struct is an int, b=
ut
> > this structure is used by the drivers so I don't want to touch it.
>
> Right, not sure what happens when it's not in dBm anyway.
>
> Ok. I noticed a few more things, sorry:
no problem... I want to get the bugs out of the patch, not to get it "in" a=
s=20
soon as possible.

> > + * enum nl80211_rate_info - bitrate information
> > + *
> > + * These attribute types are used with %NL80211_STA_INFO_TXRATE
> > + * when getting information about the bitrate of a station.
> > + *
> > + * @__NL80211_RATE_INFO_INVALID: attribute number 0 is reserved
> > + * @NL80211_RATE_INFO_BITRATE: total bitrate (u16, 100kbit/s)
> > + * @NL80211_RATE_INFO_MCS: mcs index for 802.11n (u8)
> > + * @NL80211_RATE_INFO_40_MHZ_WIDTH: 40 Mhz dualchannel bitrate
> > + * @NL80211_RATE_INFO_SHORT_GI: 400ns guard interval
>
> This needs documentation for __...after_last and ..._max too, I think,
> or kernel-doc will complain, and then I get email on the next daily git
> update and complain ;)
Is there a script to check for mistakes like this ? I used checkpatch.pl an=
d=20
it did not complain...=20

> Other than that,
>
> Acked-by: Johannes Berg <johannes@sipsolutions.net>
>
> so feel free to add that into the patch when you resend.
I will... together with the iw patch.

Henning

--nextPart1538116.C9pKTrN11k
Content-Type: application/pgp-signature; name=signature.asc 
Content-Description: This is a digitally signed message part.

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.9 (GNU/Linux)

iEYEABECAAYFAklBWnkACgkQcenvcwAcHWeaeQCfWr9RFdvt85MAchopQFGiUxaZ
yHoAoI5RFEWDdXz6p5lpCrIAcRIzRDc9
=n2H+
-----END PGP SIGNATURE-----

--nextPart1538116.C9pKTrN11k--
