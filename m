Received: from mail.bues.ch (bues.ch [116.203.120.240])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 926A527BF93
	for <linux-wireless@vger.kernel.org>; Thu,  6 Aug 2026 12:43:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=116.203.120.240
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786020203; cv=none; b=kuUA3oKayQ6gG26tu+M+LEiN8M0fZGa2uZ8fGcx9I5Ykr0VFCXWyPNottWKsb18WkFmUiPIMS+4lr4jyuWX6WY0BoECFdhyGE0RCzeBquaiCNDsTZA/GJScQDKGIPvKSN4bxuyAJT6vSppJG17Qxb8FMWAFbq+22wNvBuCfve5g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786020203; c=relaxed/simple;
	bh=gh8qYDw9jbdJL2uu/+yf6ldgamPP3/84xm8uuD3RjEg=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=kIAusNLsx0olJciOkJ4FKHz/iIBm16RbQcxsd4yowceSWsQjnLrBMxK1Ssv6nNf8d+ZvkhdbtxaRbbE049De520h332mAQu179R4yWLF4ugiRZw4ai1CO+Hqey1wGhScSNEe2aVxwUX9z5KIawB4NzR6C/h+3/+PON8ygVr7+1I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=bues.ch; spf=pass smtp.mailfrom=bues.ch; dkim=pass (2048-bit key) header.d=bues.ch header.i=@bues.ch header.b=EMjjTtK4; arc=none smtp.client-ip=116.203.120.240
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=bues.ch
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=bues.ch
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=bues.ch header.i=@bues.ch header.b="EMjjTtK4"
Date: Thu, 6 Aug 2026 14:34:46 +0200
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=bues.ch; s=main;
	t=1786019743;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=gh8qYDw9jbdJL2uu/+yf6ldgamPP3/84xm8uuD3RjEg=;
	b=EMjjTtK4vI1FSqoNDu3by+zmA8noF4Lmfqs8SfhJUboa/aT5HlF2uPSGAuV0FXNk4ipeTM
	nXHBqxrY7/ZnacRA3c1XeqckKYGyfRubkSLr7jw3DGM/ruBc1zWBC/cM6JVJWyyOWaFcGf
	tqKxC+9zD7eTv9dmyf//eZSgdiJwyiC/Ezu7o7mnEcUCiBhyJX/Jw0k6EB/+F4C4WCAJyk
	rjPqwq17TnrgqHiJlBsuVZjQQGtTdzW7BpkzeZqNyybBS3peSBiSdcfCkpQ+48rshb6fIB
	h6XzqY1gSp9hOHCckdzmGGo6lwWHn+nFA+ag1c92RwpsNHUbgf+qyW8lcBEXww==
From: Michael =?UTF-8?B?QsO8c2No?= <m@bues.ch>
To: Alessio Ferri <alessio.ferri@mythread.it>
Cc: b43-dev@lists.infradead.org, linux-wireless@vger.kernel.org
Subject: Re: b43: multiple parens bugs and double CORDIC_FIXED
Message-ID: <20260806143446.397b3f7d@barney>
In-Reply-To: <20260806104802.147ff076@DELL-MOBILE03.ad.smart.it>
References: <20260806104802.147ff076@DELL-MOBILE03.ad.smart.it>
X-Mailer: Claws Mail 4.4.0 (GTK 3.24.52; x86_64-pc-linux-gnu)
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="Sig_/xM/0pmNqu5+3uZQy=etzJXO";
 protocol="application/pgp-signature"; micalg=pgp-sha512

--Sig_/xM/0pmNqu5+3uZQy=etzJXO
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

On Thu, 6 Aug 2026 10:48:02 +0200
Alessio Ferri <alessio.ferri@mythread.it> wrote:

> I developed a tool to capture io traces of proprietary wl driver by
> hooking on its io accessors and then started to check mainline against
> the captured trace, i already spotted 3 bugs:

> I'll send patches in a few days once i verified them on hardware, do
> you see any problems with the capture & compare approach?

Great. Nice findings.
Please feel free to proceed with testing and sending patches.

--=20
Michael B=C3=BCsch
https://bues.ch/

--Sig_/xM/0pmNqu5+3uZQy=etzJXO
Content-Type: application/pgp-signature
Content-Description: OpenPGP digital signature

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCgAdFiEEihRzkKVZOnT2ipsS9TK+HZCNiw4FAmp0f2cACgkQ9TK+HZCN
iw5R3xAAyAKjRp0q50gHx79Xb0xLVRpTQyPK3w6xjbIL2FW967N5GKjgWlqlfFOP
RhtrDQwPr6yTGMpuCSnPrrqtyMAxkFNDAWGvMCp70oiEuKJV8StUI+T9WyTcIdd+
4aBQAsJWYKR4E6f5mU+n6apG0LsUxJ5/LaASiZdLEk81u+zxeWPsVMscmzfkAXEp
1TpoSeJQMgyWjx8HBVR/MBnS4DmMdkGpbuz6fQli3Ccntl3tbxHx5Czhfo0R+jmH
9M5WIINZNf7uqE/ycmt6fSS2ut5+dlRfK3M28X9L+2pcVDT0WeoWjt4W5GmV8wd4
gPgwVnWHPAwkoWPEwI/abXDpZUki6nf6MiIqB6k4vjH4mvenC4DdBmK58dBEYSFe
aaFcX8JydgOUGsItVFAQBy/ekgWRtgiEq+z/zsBiaKcysaEdOUWxWFB5fxpZJQ4M
49MdFt39R3tdsFm6NMUskIrI0DeemHlfvfXXnzvj7a6RiVT24Bjxu3v1NMHzN3XK
WMOgv0xtBFoerlhv9Sw05t7h3YxMsCvAG9JZfn9rlN76bLfuvaXg3Drf9k5k7vlh
w/K9k+KLQmzLeN/NfJqf5kaZkVdEHBdLTMHqSrHzls6S7FjxH+Ghe3/baAeaWZ8i
uMYP02/Vs+tR2wo+KYzMl2qw9OpZhuOMfLpTTG2f6HOlHwExM0c=
=Glk4
-----END PGP SIGNATURE-----

--Sig_/xM/0pmNqu5+3uZQy=etzJXO--
