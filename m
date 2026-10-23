Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=116.203.120.240
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792791679;
	b=nRfu8hcteCTL5lpYlTF/KSy/+IVpd37dDI7xp8iwMsDSet535KSsWyTQSgHr3NvsyEPG
	 I57w+36MxL7QYyoz3hCVsLTfrVWm0Q1gXdxA6myPd8tvyxiS8bdqZbHyI9NttkuNfUA+F
	 wqQyD+QO8v2ABJnhk6P3Ii7let+5lPdQcDOMQ+4f0vhamTjy9IA8CuBEzsDlMicO2wtsT
	 DN7tU+dKYJdD0QzLwfsfEQka8xPXmrev9z+LCH94VL82QO9kmugKE7AAaBOyAu30y7dPK
	 EVPnxFlf8HyYxjNJ1sEjNw8WBfGt/33uE1QL5Yibq9wijUZEMhIo9TLM4EQlNU4o+/A==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792791679;
	h=DMARC-Filter:Date:DKIM-Signature:From:To:Cc:Subject:Message-ID:
	 In-Reply-To:References:X-Mailer:MIME-Version:Content-Type;
	bh=0NkHIEu/vmmZL6hSATEhLaqxQwhA8tfKkg+Bnz/rxXM=;
	b=Qo4lDpVN23m1H6uoT4ZTpn8bBPl1R/qkQtnJEzKMK9qaS5sKs8SeqdiDXIRXNsokn01z
	 eyQdufK++xkiwTuBgbSxQqHe4GoVOgA1slrmR/GvRg/4CFEjVZXg6uP+z64ogpjg42AlM
	 CaK5I+j8LNb/Lpfio14nKHS4RfMA3ggbakkUsQ6eVS/NNBuob3zmadBujRnEJzKP2PPhB
	 zvfJhtTQZ9iuXXj5+xBPojyOD4AvrninDVR+gK5/bEJdsXmGRhdll1NHtkNlqgx1eCeM4
	 URTSYjfkFgdsDUwWrswUXw5bJmvKWT+YoVlKkTAWDjOhkAUiy1RqJdXP/6mk0wpzKlQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=bues.ch;
	spf=pass smtp.mailfrom=bues.ch;
	dkim=pass header.d=bues.ch header.i=@bues.ch header.a=rsa-sha256 header.s=main header.b=UDYiesLQ;
	arc=none smtp.remote-ip=116.203.120.240
Received: from mail.bues.ch (bues.ch [116.203.120.240])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BEED8606A31E;
	Fri, 23 Oct 2026 21:41:18 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org BEED8606A31E
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=bues.ch
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=bues.ch
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=bues.ch header.i=@bues.ch header.a=rsa-sha256 header.s=main header.b=UDYiesLQ
Date: Fri, 23 Oct 2026 23:39:53 +0200
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=bues.ch; s=main;
	t=1792791677;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=0NkHIEu/vmmZL6hSATEhLaqxQwhA8tfKkg+Bnz/rxXM=;
	b=UDYiesLQY1KDuLEUj2mYEDV4XPVOtkXLDByO3LTPXw2PB5aAtviN7v0bJnTM/I7S+DxQ7x
	ncskYwyQ34+eyKMGvCZl50HRiWMWF8GCz25OrFlYMLaWZhBK+e01VQpJMvEocQHxWvYO4j
	02Q+XqsVIQwBhm1EfwVIE9/KIa4RieaOfyNEyErbxBKMvVC9qvC5ETze1QW1MDzFcMqXE6
	B/1FFtud/7sVhQmZa9Y4jmU2cd31JJnGUuPha9UywFQmtUfZOmwLbZm2TbJB8StZ9cpAS6
	2vn7LH+iqxsZmOHgAlk6GGzrrDHv0sjYF697nwjQgs2xvSskrlXPrzyZC6K3PQ==
From: Michael =?UTF-8?B?QsO8c2No?= <m@bues.ch>
To: Rosen Penev <rosenp@gmail.com>
Cc: linux-wireless@vger.kernel.org, "open list:B43 WIRELESS DRIVER"
 <b43-dev@lists.infradead.org>, open list <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH wireless] wifi: b43: map the RX buffers
 DMA_BIDIRECTIONAL
Message-ID: <20261023233953.65c45360@barney>
In-Reply-To: <CAKxU2N9i6Dn1yKmd-_9DvET6P_GNctTywWgOBXYd2tWoWKY=Sg@mail.gmail.com>
References: <20261023190653.70741-1-rosenp@gmail.com>
 <20261023221424.2722795e@barney>
 <20261023224140.465903eb@barney>
 <CAKxU2N_1XgjVPdSrCMYzZx4Rb6yjgEe7kBZYyG4RASyBv5BtMw@mail.gmail.com>
 <20261023225745.696eef3c@barney>
 <CAKxU2N9i6Dn1yKmd-_9DvET6P_GNctTywWgOBXYd2tWoWKY=Sg@mail.gmail.com>
X-Mailer: Claws Mail 4.4.0 (GTK 3.24.52; x86_64-pc-linux-gnu)
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Post: <mailto:linux-wireless@vger.kernel.org>
List-Help: <mailto:linux-wireless+help@vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-wireless+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="Sig_/PGHhB_KIxckt4xeCgKNjilU";
 protocol="application/pgp-signature"; micalg=pgp-sha512

--Sig_/PGHhB_KIxckt4xeCgKNjilU
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

On Fri, 23 Oct 2026 14:21:27 -0700
Rosen Penev <rosenp@gmail.com> wrote:

>> Why do we need bidirectional DMA and most important why wasn't it necess=
ary before? =20
>Because the codepath is not fatal. One or two duplicated frames. Big deal.

I do not understand what this means.
Please explain this in human language.
Why is the code wrong?
Why did it work for almost two decades?
Why does it need to change?
Please explain it to a human being with code examples and failure scenarios=
 that are understandable.

It is completely Ok, if it *does* need to change.
I am just asking for an explanation that is not AI generated.

If you want me to read it, it should not be too much for you to type it dow=
n.

> > Write your commit messages manually, please. =20
> I've been burned by this many times before where maintainers ask me to
> reword or mention something. It's not practical and wastes everyone's
> time, which is why I'm almost banned from netdev.

I'm sorry, you are wrong.
This is not how software development works.

If you can't explain what you submit, I am going to NAK everything.
(even if I don't have the formal power anymore, see below)

> Do note this is an orphaned driver.

Yes, I know. I am the former maintainer.

>I expect [..] Fixes: to get in a bit easier.

No.
Fixes need to be explained to avoid regressions.

--=20
Michael B=C3=BCsch
https://bues.ch/

--Sig_/PGHhB_KIxckt4xeCgKNjilU
Content-Type: application/pgp-signature
Content-Description: OpenPGP digital signature

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCgAdFiEEihRzkKVZOnT2ipsS9TK+HZCNiw4FAmrb1CkACgkQ9TK+HZCN
iw6YOQ/9GA6pmW0kusXU0wJyOhu/DEfGo0aS1f6jDOxO4XYQuZYi0CcyhLUHyNRQ
AWXv2wenyTUG6X3wnmg2q9GZPyMopnpK5TIm9H3B1UaVPzvT6vvb2O01fnQE1CO8
ZlHKiHtGSKWqRsS60Z5utPTESGIcCUgQ0pOwJAhUyFPTS4D6efSpGCLxTfWZGvLt
ujUzFviy9InpzA7aES/8vkYTfzDWzc0zHFaLkjqsURcGOsnGxKpe9ZPopSRmcyu2
3nDLEBgUX+sOJQfZNMELf84w6aGAWNQ4/m64A4ZVKMcLQu/6v0viGxz0PR/SFBm9
jIz9Ppai7zy6YWuUeCTVGcUQUrK4S5/SN5AnfXq2dYu4r5aXc5YqgQ6DBF2Asztn
YLXD/txr708CnE0DLjhXvcvxAPVS2wHktQ+nTaJ01XAopeZwLFDHfsUAFMu2xtVY
7qxpN1DQUkdqUJmc9dG85apmzqVU7dGcxcQXQB8gn40J+3sl9RiDlnCjm8f1s+gV
Rj3jhtKrnDhgSC1TWOLEHa3vrL5Q7NrRdoZ8c36teMWFyzg+immrkpoFgj8j0wnN
JhHKIkqNH1Lg3D1ixBRhp+LWOxBCKDsjbazBnUzqP4i/+oqIiFoNEM3A6KR66l8E
LCSe0h/r7+50Ge8owfG6ie7YFen6PWd8lpSkYtFzz6HYJxlBD6Y=
=ErUq
-----END PGP SIGNATURE-----

--Sig_/PGHhB_KIxckt4xeCgKNjilU--
