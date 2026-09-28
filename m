Received: from mail.bues.ch (bues.ch [116.203.120.240])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5E92736B934
	for <linux-wireless@vger.kernel.org>; Mon, 28 Sep 2026 18:13:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=116.203.120.240
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790619227; cv=none; b=F4p8QlbQlk0/y8pjWMPNS8DE6DP2G/Gs0lHry9kLk5XVfj+M48/04C/xbsQFTBKBDtNzjojJoh/oPhQzG/XHHPqwaUv4WEhxnqD8li03fgT7FVA+yTbCFULIfh+4neLrWafFmljPAlqiBZYiuSYvMw8u0TQC9qkgQKAxz4Y5ka8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790619227; c=relaxed/simple;
	bh=kuNa70+mcMFBk8+GFEIeBAClK30mVrzEegm3PUow7O8=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=eQanHmHAVdybvF9XOR+AtRtR6s3eDfSV75m85Hgtz3lT0Sq48rSxMveZEnAqPjduxaTd8m3L9pFf2hjQDPQkKHhPXub+ebZsTUi3BboloyvET1YBMeyqdY+BVksmEy3CXcKqxtIzY0PNBNihHCuNotOOJDhM6jqB5/hATtlCUOQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=bues.ch; spf=pass smtp.mailfrom=bues.ch; dkim=pass (2048-bit key) header.d=bues.ch header.i=@bues.ch header.b=e0tuzH5r; arc=none smtp.client-ip=116.203.120.240
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=bues.ch
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=bues.ch
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=bues.ch header.i=@bues.ch header.b="e0tuzH5r"
Date: Mon, 28 Sep 2026 20:03:09 +0200
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=bues.ch; s=main;
	t=1790618626;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=kuNa70+mcMFBk8+GFEIeBAClK30mVrzEegm3PUow7O8=;
	b=e0tuzH5roshchw5pG/EIivSWI4UOEr2Irior3ypVn4Zl8QwYfC/G7OBDFOPUTrER2hogXz
	HOb4+0IBsrU7UC8fgTlNFCNREppIqAqPkz67CgC8K0g351l/xqcQnVQ4B5fnEW4xRHAH+d
	uJ8fwODLxSnQsQrM0kjsU8JYitDsdxUWuHT4AvI2+61d8k7nQB6Vg6f9QjymxNzVUryQJN
	/OErhWXaHW7ZkBWIQ7ur0i+2EI5nMaJewV3YmUZuXM2ai236EZD/X3Rw+Y+FxXNOoASo4+
	f/qUdUJqSdrsempCZ2K3BUoQXR5ehphisLhkQvxo5G3MgNOUITAqD5fTPiHT0g==
From: Michael =?UTF-8?B?QsO8c2No?= <m@bues.ch>
To: "andreas.wendleder" <andreas.wendleder@proton.me>
Cc: "b43-dev@lists.infradead.org" <b43-dev@lists.infradead.org>,
 "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: Re: BCM4360 AC-PHY support for b43 =?UTF-8?B?4oCU?=
 reverse-engineered, seeking guidance on a clean path upstream
Message-ID: <20260928200309.01a36f5e@barney>
In-Reply-To: <ih-lXs5OlHxMhydtcZFtKNhGg3cGlR137CEMZ07_zFQcfCYAImW6MRWPDjkdwy-xK9bIwpDK9ImgerqHmQMsAxX3ckEjsiN8QoCSlpvIsSM=@proton.me>
References: <rOzY3WnW4q5L1osv7iagU81dLGldzZEsu3EqHxmH4d7Z4vxubBYvRNT0vsrbr8n-CUSEYyXxGFE3h9PHLHgePjm3_rMK_B_0m5loTpyxX-M=@proton.me>
 <ih-lXs5OlHxMhydtcZFtKNhGg3cGlR137CEMZ07_zFQcfCYAImW6MRWPDjkdwy-xK9bIwpDK9ImgerqHmQMsAxX3ckEjsiN8QoCSlpvIsSM=@proton.me>
X-Mailer: Claws Mail 4.4.0 (GTK 3.24.52; x86_64-pc-linux-gnu)
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="Sig_/09TWaTfXf.=83_5ckO7e9tv";
 protocol="application/pgp-signature"; micalg=pgp-sha512

--Sig_/09TWaTfXf.=83_5ckO7e9tv
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

Hi Andreas,

I'm the former maintainer of b43, so I think I can give at least a few hint=
s.

The driver has largely been developed with a clean-room approach and with
a register-dump-then-implement approach. There were no lawyers involved.
Only common sense.
So I think if you use one of these approaches, you are fine.

It's also fine in my opinion to use AI assistance up to a point.
What I think is very risky is to use AI for the whole process. I think there
must be a human involved to review the specification for copyrighted materi=
al.
But also for quality control.

If the whole thing is based solely on register dumping, my personal lay opi=
nion
is that there cannot be much copyrighted material in there.

So, yeah. Feel free to post both your specification and your implementation=
 if you like.
Please also fully disclose how the intermediate steps were developed and
what role AI assistance played.
Then we can decide how to continue.

I hope that not too many changes to the existing common parts and other PHY=
s are
needed, to keep the regression risk low.

--=20
Michael B=C3=BCsch
https://bues.ch/

On Mon, 28 Sep 2026 13:42:42 +0000
"andreas.wendleder" <andreas.wendleder@proton.me> wrote:

> I've been working on adding 802.11ac AC-PHY support to b43 for the BCM436=
0 (MacBookAir6,1), since b43's existing phy_ac.c has only ever been a skele=
ton (allocate/free
> plumbing, no real init or tuning) and Broadcom's own wl driver is the onl=
y thing that's ever actually worked on this chip.
>=20
> I want to be upfront about how I got there, since it directly affects wha=
t (if anything) is submittable: I reverse-engineered wl.ko =E2=80=94 decomp=
iling it and capturing its
> live register/SHM writes on real hardware =E2=80=94 and used that to writ=
e a working driver. That driver is not clean-room and I'm not proposing to =
submit it as-is; having the
> proprietary driver's decompiled logic in view while writing it is a real =
provenance problem, not just a style one.
>=20
> What I am hoping is more useful: I've since written up a functional speci=
fication =E2=80=94 chip bring-up, channel tuning, TX/RX header formats, and=
 the specific pitfalls that
> cost real debugging time (a frame-lifetime register that silently stalls =
connections if left unset, an RX status bit that looks like "decrypt error"=
 but fires on
> unencrypted frames too) =E2=80=94 describing the hardware's required beha=
vior in my own words, with the intent that someone who's never seen wl.ko o=
r my driver could implement a
> working driver from just that document and the 802.11 spec. It's honest a=
bout what it doesn't include (the actual calibration/tuning table numbers, =
firmware, b43's
> existing generic infrastructure) and upfront that I'm not qualified to ju=
dge its legal soundness alone.
>=20
> The driver itself works: verified WPA2 association, DHCP, and sustained s=
table traffic on 2.4 GHz, on both the kernel this project started on and, a=
s of today, kernel
> 7.2.7 with no code changes needed. 5 GHz, hardware crypto, and full RF ca=
libration are out of scope so far. Given b43 is listed Orphan, I don't have=
 a specific person to
> ask, so: has this kind of provenance situation =E2=80=94 a reverse-engine=
ered spec intended to enable an independent clean-room implementation =E2=
=80=94 come up before for a wireless
> driver here? Is that a viable path at all, and if so, what would you want=
 to see before it's worth anyone's time to attempt the clean-room side?


--Sig_/09TWaTfXf.=83_5ckO7e9tv
Content-Type: application/pgp-signature
Content-Description: OpenPGP digital signature

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCgAdFiEEihRzkKVZOnT2ipsS9TK+HZCNiw4FAmq6q90ACgkQ9TK+HZCN
iw6VRQ//eY6/Ws+wW/AYJ3Gc1ZHQIfAtWjnYh3KHgI5yaMQR2l/awLcBtTs0MLb6
W3xqypYDzH6I+T8kBpsymDU2X0Hedgwju4aBM1fx0f6Dj1UNuFKb+vbjV9YrsNIQ
Kv8Tjk1QFzsKfb9hw5A5QTJA0BHAQi9yAwkgAAYaZg7mG+VaWQpoWatq319R4sCq
wY+tM8/IndC5H8MFjzVw9K/o4EF+l1yNMPWL83ghy7J6GgMZ1tycNgFMExFHVWbt
h/1SoLJBJHQde2lqiy+Be0WoRbkCHVkikzilZJyljX0N7RkuHd5ETB/cl/GUh5W8
4lGoA/G982dO6EapqGw1TIaO8Gs/Av92nSId412YLfmJ1aHCb2P0Qb9kpsPE5kRR
iuNGYbjMRybLJ3b0uRZj05sIWN6RbfsEJtUaGurMqvx1e5XudK0oPaUEnIQQhdDf
scsNkNUj1Nqef0zVwF3Gu61fFbQLJ4qL+YS54+QcOheyYdtVFHlO1MTF04Cvmmmz
GQrdoKsGeBXJey+MtmkeDjfVxVSl1TjqiJlkpnJC0u0V4iT+NE4GLAiGLut/i+8b
HkJfF/taogNAhkpZ8TbGS/bBluAmJny7v/cnqtqUug9VRijP3V55nF2D/irri21A
4DLG7n3ief89dypowNUo0dchPo6C1FnUl8nNHXipF2LURG9sN18=
=MTto
-----END PGP SIGNATURE-----

--Sig_/09TWaTfXf.=83_5ckO7e9tv--
