Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from parez.praha12.net ([78.102.11.253]:59843 "EHLO
	parez.praha12.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761123AbZLOVfI (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 15 Dec 2009 16:35:08 -0500
From: =?utf-8?q?Luk=C3=A1=C5=A1_Turek?= <8an@praha12.net>
Reply-To: 8an@praha12.net
To: "Luis R. Rodriguez" <lrodriguez@atheros.com>
Subject: Re: [ath5k-devel] [PATCH 5/5] ath5k: Implement mac80211 callback set_coverage_class
Date: Tue, 15 Dec 2009 22:35:01 +0100
Cc: "linville@tuxdriver.com" <linville@tuxdriver.com>,
	"johannes@sipsolutions.net" <johannes@sipsolutions.net>,
	"ath5k-devel@lists.ath5k.org" <ath5k-devel@lists.ath5k.org>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
References: <1260899813-17585-1-git-send-email-8an@praha12.net> <1260899813-17585-6-git-send-email-8an@praha12.net> <20091215185016.GB2123@tux>
In-Reply-To: <20091215185016.GB2123@tux>
MIME-Version: 1.0
Content-Type: multipart/signed;
  boundary="nextPart23360816.Kqs5amPV6y";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Message-Id: <200912152235.01490.8an@praha12.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

--nextPart23360816.Kqs5amPV6y
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline

On 15.12.2009 19:50 you wrote:
> Can you move this last line setting the sc->ah->ah_coverage_class
> to ath5k_hw_set_coverage_class() instead?
ath5k_hw_set_coverage_class() is also called after interface reset:
ath5k_hw_set_coverage_class(ah, ah->ah_coverage_class);

So it would be quite strange if it set the value again...
But I see your point, and don't see a better solution.

> Also -- if an ath_hw_set_coverage_class(common, coverage_class) can be
> defined on drivers/net/wireless/ath/hw.c along with:
>
> ath_hw_set_slot_time(common, slot_time),
> ath_hw_set_ack_timeout(common, ack_timeout);
> ath_hw_set_cts_timeout(common, cts_timeout);
Unfortunately the functions are really hardware specific, they write a=20
register that even differs between chip versions, and also depend on chip=20
clock rate.

It would be possible to move ath_hw_set_coverage_class() to ath to share th=
e=20
calculation, but that would require exporting six functions from the module=
s.

> Wonder if ar9170 can support setting these too.
It seems it supports setting slot time, but I don't see a register with ACK=
=20
timeout, which is required too.

Lukas Turek

--nextPart23360816.Kqs5amPV6y
Content-Type: application/pgp-signature; name=signature.asc 
Content-Description: This is a digitally signed message part.

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.11 (GNU/Linux)

iQIcBAABAgAGBQJLKAEFAAoJEEBjvk/UOfYwXisP/3FVVre593fd0sTnK4Vn1BuL
Ndc//6m2l9j5ZK17PBAuyjIdmE4mCX2CbhXFUdY3NRM0Ffj0jPOmyBnT/jMSJ2Z7
cP6gctI6EOwroAEYTxwbU70u9a4xrQFiSE2hnSgpurkfMdL/pBG9jeEohAhmmphf
X7EKSq7ieaPG+aoQ9pItXSOY3U2aAopNmaBe2fDFcQysf/GMwnUMeVr82CRZ+YtU
DI4x9DIJ+7SFyfoO8c6Iqa+ZUbnxuSkptrIdvNO2plcmlLrbXftpnfXO8tk9NEfe
ZtncFWSBEzWPbxYzLX4dUpPoI8Vm56jOhGoY+6KjWRo3IiBti1/QFpP5p0Stfab3
IHL9jU+yW+NBVBw23HFgo2qLzQCjRMmTr2ARKumun6Oq51vCq/fwr6MVFpzNycOq
Ew1xYOAGMhDLwLCNnuwsyccks15KDBtIKz1eVXwol5V7fGYytIQRhw9vfRGiA/Bt
r9SLseYZBPJXBk9hGJ8piksb/QcAWj3vlZsudxx6vwfD3/3iIkpN0Mataf3hc9qE
IC8rdz2pFgDI29ojWNiHvqbf+k3kCmeEND1k9yoJD10Bk2l+OB2iZWX9q02iXiLV
NDStl210GraxseUhzKEsICS+2ku7dcta8USyhxPRHRMbbS7SkGBiIMtez3yVPd6b
4pfg4QbE3+XQwlVA1SlJ
=I0AK
-----END PGP SIGNATURE-----

--nextPart23360816.Kqs5amPV6y--
