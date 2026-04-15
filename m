Received: from mail.bues.ch (bues.ch [116.203.120.240])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 47D5F39099A
	for <linux-wireless@vger.kernel.org>; Wed, 15 Apr 2026 17:42:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=116.203.120.240
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776274978; cv=none; b=EcWR/hUAv75zZocnGJE+Y499AeqYtrZf6QXijgSge2Rp1Yxgj+gA0QfibWIiU+3u1887gOaNIDF0CeXmd4SUbDTCxGD3lgWHQ/EybXdjo7xy1IJ1D0Z1aTgX2YgJ36KiaA4R9+d4bteICoOwetUfi7ppwbcrFt4VXwsoaLvehpQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776274978; c=relaxed/simple;
	bh=iMU8Q7tk0mzvGfxhQdx/C/pXwAGPrpTMzMu2PP4YAmI=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=mHHcnVjA1+BWRZwMFvD7RTXZ8irBuBol3mzLsWCexMfoxnx9/EXadNId7RV2862ANtiAYTkUN4IFah62OacKa43wzzOEbWHbgUmY0qUwLMp1xEeDVOBoOYYGOilpEedxhfjk7P4jLZha3lzlCLWJo4EaVsPow9/iV9TgFZ3RlgU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=bues.ch; spf=pass smtp.mailfrom=bues.ch; dkim=pass (2048-bit key) header.d=bues.ch header.i=@bues.ch header.b=HOM3+atI; arc=none smtp.client-ip=116.203.120.240
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=bues.ch
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=bues.ch
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=bues.ch header.i=@bues.ch header.b="HOM3+atI"
Date: Wed, 15 Apr 2026 19:41:50 +0200
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=bues.ch; s=main;
	t=1776274974;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=iMU8Q7tk0mzvGfxhQdx/C/pXwAGPrpTMzMu2PP4YAmI=;
	b=HOM3+atIPHRb4nfcOcS9numuJVQJCQtHAjo+ljFid+5XbI2ICaacgElaz9xAV0s4shEWPb
	2ssYa71UCKofBzWT4mayl6mpSecJ9MU4HyrNvhz8hiSMZ818j5A5vRqAZvl/fIHC2Qds+n
	hE13Np8rju1PojUPpujNFpnT41LeTC+/ZHQha3rE2iBR5eC8tiqrXJ0Iri4acAoO8/IQhm
	CuWZbj3xj/nJuL2wnXRSd28AjQNxGKSIxkbCuDrleKtCPj8SuImqb5l3Lo9QkvJHOUBDnU
	YPhygfkKnHqbMjbaUoDUI0egb5OYxwKZwYvCs20mADOgU/LL3NZkxPk/BXJPWw==
From: Michael =?UTF-8?B?QsO8c2No?= <m@bues.ch>
To: "Joshua Peisach" <jpeisach@ubuntu.com>
Cc: "Jonas Gorski" <jonas.gorski@gmail.com>, "Johannes Berg"
 <johannes@sipsolutions.net>, <linux-wireless@vger.kernel.org>,
 <b43-dev@lists.infradead.org>, "b43-dev"
 <b43-dev-bounces@lists.infradead.org>
Subject: Re: Firmware for reverse engineering b43?
Message-ID: <20260415194150.291dbe2d@barney>
In-Reply-To: <DHTW44HOVZLS.GFYBZTKJTMP4@ubuntu.com>
References: <DHS1BJ5XFYRC.GCF9PXS0OSRI@ubuntu.com>
	<c62a448843f189d78187de18d3fcb955f2779d13.camel@sipsolutions.net>
	<DHSUDVMGW0PS.2LYWKGG1C1135@ubuntu.com>
	<CAOiHx==kVm0OKWRKi4VHSEEr6ZygzrpNiA=zj+zEHT6_rgZ3CQ@mail.gmail.com>
	<DHTPAVC76140.1JLO3HNQARQ9Q@ubuntu.com>
	<CAOiHx=n8awRRvArvG8sWqEokojXL6ppFRJ8_SOuGAddDb1D32A@mail.gmail.com>
	<20260415175748.61aa7993@barney>
	<DHTW44HOVZLS.GFYBZTKJTMP4@ubuntu.com>
X-Mailer: Claws Mail 4.4.0 (GTK 3.24.52; x86_64-pc-linux-gnu)
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="Sig_/5GlhseULoQivVP7Dmr.YsLG";
 protocol="application/pgp-signature"; micalg=pgp-sha512

--Sig_/5GlhseULoQivVP7Dmr.YsLG
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

On Wed, 15 Apr 2026 13:04:40 -0400
"Joshua Peisach" <jpeisach@ubuntu.com> wrote:
> Well, if the regression risk is that high, then I guess I'll let it be.

> Sure. I might just make sure everything is using register definitions
> instead of hardcoded values, but then leave it there.

I mean, I don't want to discourage you from doing anything,
but I just wanted to point out that this is a lot more work than just imple=
ment
a TODO here and there.

For most of the code we don't really know what it does exactly.
That may change a bit, if you pull over some code from the newer drivers.
But I don't think the situation will improve fundamentally.

> So I guess this driver just sits here.. not quite pointless to be
> removed from the main tree, but not quite worth the effort to bring it
> up to speed.

Well, it probably still works well on the (few) devices it worked well on,
because it basically hasn't changed.
There are many devices which were never supported at all or were never supp=
orted
properly. It's not that just your device is missing to complete
the perfect picture :-)

There might be better uses of your time than working on this legacy stuff.
For example working on the microcode reverse engineering and tools and
get them updated for the current generation of devices is probably
much more useful. And I think much more fun, too.
Or something else altogether.

--=20
Michael B=C3=BCsch
https://bues.ch/

--Sig_/5GlhseULoQivVP7Dmr.YsLG
Content-Type: application/pgp-signature
Content-Description: OpenPGP digital signature

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCgAdFiEEihRzkKVZOnT2ipsS9TK+HZCNiw4FAmnfzd4ACgkQ9TK+HZCN
iw6hcRAAhtbf9pPiLjU6v5aNDqOs27ICOjU4ys4u4AYEUk1iYWSkY/oQTxbnX4r1
GdRFaRijhVwtxP2mzDGEbwi8LcjyZatA0ANhdPEO9h+UeXc1xjQAiMNgGVY2t3KH
56HllAN10+BgSQoFmysytW1jbxawzFvctetJ4mGWyX8SaoNn0MMCiACrWoP2rFH1
Wx5bTvImGPiR+KP8FV62gAsMHZ9tBw0WyvZ7fDFc17ePAMLFNqkYeWbY00fziRnd
9oLCTnu9k1Edky4+W30HaYSZdjCcM7Tx/bkyVFaKqhT61NsfubmZBI6ilw2lEbew
A0dZU/rTGaf2RczgTRK+QN4lAyykBFcb23VFYB05ybNb7BALXyD0NiI33rdrIoik
Lde/pe8KAME4+mLZCPBsIS8OOK5iQpIICneCvl3JjsLMTxZ5ejrPbqurDmgC9e7J
LUFJc71rpUPfstEbJ5N0t/Y7NThzXL6/uuyQ0GkPyyqJ5QeIaU4qFFa7GPrylsod
R+525VAMss0H2l7aO2Mog8P0bxYOmb2KpzxXe6icaNdxSgktVDMVkygAJh0IH1Ka
eq3sPCBMGmW/IBFgLyXiohW6uqU2WPWgCn7oTKpGK+hvrH/nivRbcMDPQw7wRDEA
3p0bU1uJ1L/xTSk9nUpc5cZX7OC+KCjVHfs3crE4WCPN0fMmXkw=
=BYmO
-----END PGP SIGNATURE-----

--Sig_/5GlhseULoQivVP7Dmr.YsLG--
