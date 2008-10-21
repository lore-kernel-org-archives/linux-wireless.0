Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:38276 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751207AbYJUGnd (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 21 Oct 2008 02:43:33 -0400
Subject: Re: [PATCH v3] mac80211/drivers: rewrite the rate control API
From: Johannes Berg <johannes@sipsolutions.net>
To: Zhu Yi <yi.zhu@intel.com>
Cc: John Linville <linville@tuxdriver.com>,
	linux-wireless <linux-wireless@vger.kernel.org>,
	Vasanthakumar Thiagarajan <vasanth@atheros.com>,
	Felix Fietkau <nbd@openwrt.org>
In-Reply-To: <1224570194.24677.301.camel@debian.sh.intel.com>
References: <1223996147.10113.33.camel@johannes.berg>
	 (sfid-20081014_165703_092655_BE6BA58D) <1224052607.3027.20.camel@johannes.berg>
	 <1224484940.24677.169.camel@debian.sh.intel.com>
	 <1224485319.18024.9.camel@johannes.berg>
	 <1224486368.24677.184.camel@debian.sh.intel.com>
	 <1224486587.18024.25.camel@johannes.berg>
	 <1224562072.24677.277.camel@debian.sh.intel.com>
	 <1224570194.24677.301.camel@debian.sh.intel.com>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-0HK3SWfaktI8LoqWmlld"
Date: Tue, 21 Oct 2008 08:43:19 +0200
Message-Id: <1224571399.27899.67.camel@johannes.berg> (sfid-20081021_084338_263182_68255A45)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-0HK3SWfaktI8LoqWmlld
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Tue, 2008-10-21 at 14:23 +0800, Zhu Yi wrote:
> On Mon, 2008-10-20 at 22:07 -0600, Zhu Yi wrote:
> > The max retry rates number for iwl4965 is 16. See iwl-commands.h for
> > more details:
> >=20
> > a) Use the initial rate for only one entry.
> > b) For each following entry, reduce the rate to next lower available
> >    rate, until reaching the lowest available rate.
> > c) When reducing rate, also switch antenna selection.
> > d) Once lowest available rate is reached, repeat this rate until
> >    rate table is filled (16 entries), switching antenna each entry.

Thanks for the info.

> Now I even wonder if abstract the common MRR info is possible. Yes, the
> algorithm itself is hardware independent. But the one we use best
> utilizes the hardware capability and it communicates with the hardware
> frequently. I don't know about other hardware. But I highly doubt the
> interface is so easy to be defined within IEEE80211_SKB_CB.

Yeah, we definitely don't have enough space for 16 rates. If you want to
properly report all that to userspace you'd probably have to add some
radiotap information in the driver, but that's not currently possible...

For other HW, all I know is Atheros (4 different rates with up to 16
tries each iirc), Broadcom (2 different rates, but we can rewrite ucode)
and p54 (8 different rates, but no firmware influence)

I'll clean up the three things you pointed out in this patch, I don't
think we can achieve perfect reporting of what your hardware does at
this time.

johannes

--=-0HK3SWfaktI8LoqWmlld
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIcBAABAgAGBQJI/XoDAAoJEKVg1VMiehFYWY8P/0anpEEW7oYPzgpO9j3iZ32r
9lKgTNutq61SHpq3G8Ns0Xy2Ck0hQNc2MAZN6BQgy6dNLDTPnrmwqT+5xsindqnZ
OhPeDH2Y8gWSnMA8GGOcPfaiLub+a8fE4hdWwRODVD8RSpv7wY5Tmc2DrOUXZJtT
qb/6XGOIGpI/gKF0NhAuZvhlkCk2qs1fWS4A65SuNkwmTutouvXr5Obn+v6ZuCLB
QSMhbtqPxaw5VbOBuRKkjbfbyPWhfrBoRp4l1xsJAhO2VyIxl9YpsHTtrzK7+6QD
ZYC0+jKKYwRdM/QW/lm5DozTsKlcsNpG2TkV7fyBOBBjRLc2TaTlro3MhCrMhwGg
AHCumEn9hGVypZrEXhILMRM7thr0+uGD0TJMccnGJuNetwL0CQU1SajVZtlZn00s
MJnc7bwRw0XXfhvF2YTMuxvapU5PikE2EJzo5pwUtEElkqcvlj0PY27F1kSfHO4I
VEyEY4mmps2njw4H+3Hd0DNmGtpRmBeBaOLbu3j1MD8XKd0VCyaQBk5pedtmQc4/
NJ/6w8aCUbmGlEsmyHMUkL+GT819NRaAoF6anf/Xk2ijxOagRQhJjhDFCyinmDx7
DlEnMocNsiQs0/4dZFCkZ5Ap5T/Tf1dF6xF77ReYywjwhoWWYK+tj8x1+fJKzWcG
KtzfnZjSgS7bF4SVQKZR
=hRVP
-----END PGP SIGNATURE-----

--=-0HK3SWfaktI8LoqWmlld--

