Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793837704;
	b=Dl3SKRk+ULyoxdOfGp1p1hSfFrScxl4kNkdGzRIr+atvQ5FBwRpCJG1X2NGmNgH9HX/J
	 u0Q8i6egfsiuSzqAVENxUgNRVdB0Rxm6x1zKoxB2KBhqJbQ1q23yVZR0pJQGJQwvH+3QG
	 +IUiErlKruHOG8p3jh8xDAJWO+cWHquwyvuCT2puwWhwrCClSkaKHeCFRMEyqsvO7wYlQ
	 VuKz/pGQEhGmFxbCv4Oehqfdq4K8Euma6POj6drIw1TsPcTdOJBrfKBh0UGp1umCG1BQE
	 LyHBIugTAnJ7T8iyJxwVclz/NezvvQXgLE3czvWkknX4xSQo1zH7iKIvidF3RevaZjg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793837704;
	h=Received:DKIM-Signature:Date:From:To:Cc:Subject:Message-ID:
	 References:MIME-Version:Content-Type:Content-Disposition:In-Reply-To;
	bh=h8Fmxg7UPxc67bS2uxs2YzYplbP45zTEtp1G2uNOsoo=;
	b=WAY9QRRJ1dCiSTEzQEKRvuGTEZp3iQZR8rkLuTqBcBN6BxCgmWdW1SL2XAC55+3p9eLI
	 jPpsoOBCgcmoj+rw7OGc40H0fltJNHUtspkbJeSFwJNMos8GUmJHAbsqkP8Yvf2X6eu1N
	 rM8beU3toXua3uuAme+iSwe/I3/uDtM4d1i5Q4NbaUMkdRAp0zE62lEqjIcYpPo3peh4K
	 mPLWSGgBCflN21BdC5hMspbnIB8Q/NbmWQSv5oX75YeYRZ06t8TSjtH3fXqK7pWSNu2Bn
	 LsJtRnOQz8qk5m+lrjZLBOAiuZKOeuKYz2u6K3CDpIzi/EofQwMJjq++PuFPCCbEBrg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=Eyj1SBXP;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 15CDB606A32F;
	Thu,  5 Nov 2026 00:15:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=Eyj1SBXP
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 079AF1F000C1;
	Thu,  5 Nov 2026 00:15:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793837703;
	bh=h8Fmxg7UPxc67bS2uxs2YzYplbP45zTEtp1G2uNOsoo=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=Eyj1SBXP34nGkYF+2wuYVaD/j2oolhmzvd9LiQ48auwwAgnli3YmRHV6oAgegzkkX
	 VYMbhgBXhgGzmP+v33I6oC9Rrvlytgr78RaSq4XWZjhopYumwhTpCeuFAS+F/Fncso
	 /pVxQZjYLPraIu/4SIYVSbi3F66hrxL82BWc39O44QPi2BjF5AqrKKGQkYYMQLhHHJ
	 BhNNHpiWz6Uv9Ds1ZaU5nYGQ7cU8TGJX9DPEVHeIqhnyJu+j43n3dzvzHmj4pdvLOn
	 uP+wpHCp5h0WAqxzWU0Fq91+UhMieUnnEEjHEe0xt2JZKurh0Uj3RXjP4n1QKMxsYW
	 AKdruPm5Tzbsg==
Date: Thu, 5 Nov 2026 00:14:59 +0000
From: Conor Dooley <conor@kernel.org>
To: Alessio Ferri <alessio.ferri@mythread.it>
Cc: Rob Herring <robh@kernel.org>, Krzysztof Kozlowski <krzk+dt@kernel.org>,
	Conor Dooley <conor+dt@kernel.org>,
	=?utf-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>,
	Philipp Zabel <p.zabel@pengutronix.de>,
	Florian Fainelli <florian.fainelli@broadcom.com>,
	Broadcom internal kernel review list <bcm-kernel-feedback-list@broadcom.com>,
	Thomas Bogendoerfer <tsbogend@alpha.franken.de>,
	Jonas Gorski <jonas.gorski@gmail.com>,
	linux-wireless@vger.kernel.org, devicetree@vger.kernel.org,
	linux-kernel@vger.kernel.org, linux-mips@vger.kernel.org
Subject: Re: [PATCH v3 1/5] dt-bindings: bus: add Broadcom BCM6362 WLAN AXI
 backplane
Message-ID: <20261105-venomous-synergy-35533dee93fb@spud>
References: <20261104-bcm6362-wlan-v3-0-e46562b2ac12@mythread.it>
 <20261104-bcm6362-wlan-v3-1-e46562b2ac12@mythread.it>
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Post: <mailto:linux-wireless@vger.kernel.org>
List-Help: <mailto:linux-wireless+help@vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-wireless+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="BAb48XzL4ooHurrF"
Content-Disposition: inline
In-Reply-To: <20261104-bcm6362-wlan-v3-1-e46562b2ac12@mythread.it>

--BAb48XzL4ooHurrF
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Acked-by: Conor Dooley <conor.dooley@microchip.com>
pw-bot: not-applicable

--BAb48XzL4ooHurrF
Content-Type: application/pgp-signature; name=signature.asc

-----BEGIN PGP SIGNATURE-----

iHQEABYKAB0WIQRh246EGq/8RLhDjO14tDGHoIJi0gUCauvKggAKCRB4tDGHoIJi
0hVQAPUczhdTFcD3qKMUT/bDHMyvVJalz2jOijC0wpc4wOxxAPwLYoQkmaB9IQjs
IsueimLnhXos0tSXub7hPAZRxDG/Cg==
=Yh84
-----END PGP SIGNATURE-----

--BAb48XzL4ooHurrF--
