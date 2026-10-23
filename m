Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=116.203.120.240
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792789107;
	b=Zgxrt4Wo9GcF+7vR0npLrC1XuJCT4E2LZCnc1uljDCNaGfYQG7cVFwU01YI5ckLkFuvK
	 /dKsFOja4ssm6dL3GFfyzt2WERV6FpdliC7ULiR2hd/PJAt8WkoIqOvBnEfuIILF6BzTH
	 pl9Qq7monbt7H1it7LEcO/4WaUzxf+9N+Lc0adC3zF8m8R/pXKHG1o0qPgWEQ0tWOx5OS
	 ipXAh3KpHa8n2OyHxiE+k/lXvEbCg0ihF+uFwDF/GPiPnAgx6nHFKFg+0vxWGeoL3Asdh
	 RoDKDzOqfZCG6Dimc71gUQy4lBtJ6uhx8JdGzOSVq62L9BqNs+UN20UkIC8zPv9ijPw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792789107;
	h=DMARC-Filter:Date:DKIM-Signature:From:To:Cc:Subject:Message-ID:
	 In-Reply-To:References:X-Mailer:MIME-Version:Content-Type;
	bh=VW4kqp4jTMad/WOhSJaLgDopHrGhg40Y8hWd4zWrhIc=;
	b=0UdVEPfO378q0bnRaWi8gP+nHdi3pCeL2CxcQvcO6Rng7ivf1kfGwiJBL2a0qcUVzhjG
	 I8pow7oiFJHw9gfljJZ5K434Llxw4MQfcJMiow/B3e37pE5VaepA81bqhUK1ruFKkb/62
	 M2HPylnIy/1EiQGPgp5ej3dDmfov8l6BuuhsDM8YunIr7Qoax92l9Wesj8qYFgDBALixA
	 v0TBf2WQLCd1h++TeIRwk0D/zSO5IK6FUhtfgZrcurWsuwNB7O2IdMq1sVqLuHXJbxoak
	 ENJehBZ04WK51B6ZQImbb9CvTbvhy1KW6s4WsgBB6BYUU0id0/SdfF5b6NlGd4g5O/Q==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=bues.ch;
	spf=pass smtp.mailfrom=bues.ch;
	dkim=pass header.d=bues.ch header.i=@bues.ch header.a=rsa-sha256 header.s=main header.b=PBI6pUzp;
	arc=none smtp.remote-ip=116.203.120.240
Received: from mail.bues.ch (bues.ch [116.203.120.240])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C661F606A31A;
	Fri, 23 Oct 2026 20:58:26 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org C661F606A31A
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=bues.ch
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=bues.ch
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=bues.ch header.i=@bues.ch header.a=rsa-sha256 header.s=main header.b=PBI6pUzp
Date: Fri, 23 Oct 2026 22:57:45 +0200
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=bues.ch; s=main;
	t=1792789104;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=VW4kqp4jTMad/WOhSJaLgDopHrGhg40Y8hWd4zWrhIc=;
	b=PBI6pUzp9+L6+6myz44gMsYou2OInsbSs9sNZUrZwCjNUW8lLOt0MLCuuYbom02PEBehxD
	vBeMWfRHqM1O4MNm9TExHHI2zEdrCR7j/ak3yV4d7nLoPl2Rw9rDracptoT/e0EgpEqgXF
	cj8BPoEdxTbWdW8SvwtecmAoMSr7gXXxXmrzq/M5zsQjJxvpvRi7oaL1rhJAkN/uOeXtyF
	k3iqDFLOIwZFIoRVOvFKYOtC2fXG/Mto0fBR5MvMoW6F0+s2ass/GD774JtQVcMvlm6xCK
	sqKXMyZE12wvj03L4L7VElWALpktvH2+QfaBgjCJM5jwROgelqMaQmWJPefNxQ==
From: Michael =?UTF-8?B?QsO8c2No?= <m@bues.ch>
To: Rosen Penev <rosenp@gmail.com>
Cc: linux-wireless@vger.kernel.org, "open list:B43 WIRELESS DRIVER"
 <b43-dev@lists.infradead.org>, open list <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH wireless] wifi: b43: map the RX buffers
 DMA_BIDIRECTIONAL
Message-ID: <20261023225745.696eef3c@barney>
In-Reply-To: <CAKxU2N_1XgjVPdSrCMYzZx4Rb6yjgEe7kBZYyG4RASyBv5BtMw@mail.gmail.com>
References: <20261023190653.70741-1-rosenp@gmail.com>
 <20261023221424.2722795e@barney>
 <20261023224140.465903eb@barney>
 <CAKxU2N_1XgjVPdSrCMYzZx4Rb6yjgEe7kBZYyG4RASyBv5BtMw@mail.gmail.com>
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
Content-Type: multipart/signed; boundary="Sig_/d5ecz=YuuTctGtG389yzND7";
 protocol="application/pgp-signature"; micalg=pgp-sha512

--Sig_/d5ecz=YuuTctGtG389yzND7
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

On Fri, 23 Oct 2026 13:44:44 -0700
Rosen Penev <rosenp@gmail.com> wrote:

> All code is tested on an Asus RT-N16. It runs on non-coherent MIPS.

Ok.

Describe your development process in human language during patch submission.
What has been tested?
What has not been tested?
What was wrong?
What has been fixed?
Why is this needed?
Why do we need bidirectional DMA and most important why wasn't it necessary=
 before?

AI is great for code generation, bug finding, etc.
But for patch submission, pull requests and commit messages it's absolutely=
 unusable.
Please don't do it.
Write your commit messages manually, please.

Please make your commit message be to the point and easy to review.
And please slow the process down.
You don't need to submit patches right away. Keep them in a queue and STABI=
LIZE them LOCALLY.

Please do a little bit of research whom to To and Cc. There are scripts for=
 that.

Thanks a lot.

--=20
Michael B=C3=BCsch
https://bues.ch/

--Sig_/d5ecz=YuuTctGtG389yzND7
Content-Type: application/pgp-signature
Content-Description: OpenPGP digital signature

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCgAdFiEEihRzkKVZOnT2ipsS9TK+HZCNiw4FAmrbykkACgkQ9TK+HZCN
iw6Y1BAAqtGhwT/GhDkRGpMeSnSCZoR5N/CXbPiJ/b0vdeDIiEOuiAzB+drw1i/i
+0sB6+lXs3ZIqAQvCN1v0mCM1WKLO69xqAM3qBuDnOajw7XEMMxgXsNvgHmpQu82
y9lW1rNYQco6pLlAeJQW3pkGUbJKPyvcBHqIKy6TM+JEmn1QlaI/8/UasHxwlEU2
X5Rmf22A3OzY7Mdza1+x/WX+3s8/1u5GfXwVWKaXqcM/egivW7QoOQ6Cehcx6MoB
Z/Y9LRXNQ/TMgrsNOBYlpC3X43cVTCkR2R+VDRK+op5gu55YbgixygVIrUjtRtYI
d8zbVV4JxUkjC505Y/VK5dIu+OfomifJvoqdoJu12iEdjfMW+vk+/kPeUoiA6P/v
n9Ftjw+skt7bmNEvJ/uEupAC7C2GX09Hnx8S4s6p5vr37iBHGxArhdHKdmGFvFZR
PbElkLNAG/NrdOTYguBhQiolme1OkNtCJZlAbzaiMhSOZ4zYuWMSSezEHQoNw0ly
tqySBSkRu5qtMbVEpa+Ot5izFU3nzWViwAGOzoTETgG34h815orm57ThEGYWq6GJ
PqvBzMFfEfyiOBQroTfaQxqZSt1cZDtwfIB8sNBvL7SRld5kzu0b6tzdYCz/f+sm
l4MYfPEfWXlEQpnwfwAJIr27J+iubLS7oqzsAfSRIv70GSehBnM=
=EOXg
-----END PGP SIGNATURE-----

--Sig_/d5ecz=YuuTctGtG389yzND7--
