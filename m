Received: from mail.bues.ch (bues.ch [116.203.120.240])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9BE6C349CF8
	for <linux-wireless@vger.kernel.org>; Tue, 29 Sep 2026 06:14:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=116.203.120.240
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790662466; cv=none; b=fTYPYjC+N5pW9Zk+edjyapAUFpxuhHdhpTHDS1CLY+Aa5zZnDHknz9QluNXRo/YbAvUup6UOE7NAKGuAzT3iTQky4vME95/9Hy76ehGFpAampCAsYIM4ddvaoQsRm+hpnQHb2Vcp1AAZRQlcIyDCWYsorHcOwKLtpl69YnhVJqQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790662466; c=relaxed/simple;
	bh=A7Y5Q82w9XnCHrtBe34FxKN7FOJ3jIgBZUhLR7Hvop4=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=WK3t4SxdrjbjNrAbrSnBtYbDf+cxnfFMBxORz1pVr3i1dhNtJVm0qYCOCnCzlybLZ8Qkzg1Suisi6JynAgaCrBTFenpvT5y6+Drl9FWq5jWGTcSig0UY8rU501szfxvUfmcUe/v3cBvseYe0OZXJ8bkoPt53YZt6i+xlvOk3EhQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=bues.ch; spf=pass smtp.mailfrom=bues.ch; dkim=pass (2048-bit key) header.d=bues.ch header.i=@bues.ch header.b=ZhEkEdaT; arc=none smtp.client-ip=116.203.120.240
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=bues.ch
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=bues.ch
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=bues.ch header.i=@bues.ch header.b="ZhEkEdaT"
Date: Tue, 29 Sep 2026 08:14:03 +0200
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=bues.ch; s=main;
	t=1790662462;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=A7Y5Q82w9XnCHrtBe34FxKN7FOJ3jIgBZUhLR7Hvop4=;
	b=ZhEkEdaTci4o38T4xJOxKk9qJvhj6UTAcjLGiHQv1rdkN5aQyI6pdSZupCih+XTnPqNVbd
	/q/4P30P6WOOhlQ4CC9mUg+LVrYkZiDqNMWaU/e5KKbm4MNTwbrfM8b4SGt3GFdpsqWacO
	b8392WrwLnppwRKBqEt9nVkPm/MFigwTQkbpYLMUjObCkQ7O4cCXEljKSAIaXtSRBO11Au
	oOgjql0iLzqHxbukcy3zJ32bJrtzUew35olFUMF313iQkb1WByfkXnrDeW1cWA7/dwHMDa
	8keNVSsDzihmTOz+E61uJya/EjAc45axKA9B20G85vDjmdmEPBUd2hxwD8lidg==
From: Michael =?UTF-8?B?QsO8c2No?= <m@bues.ch>
To: "andreas.wendleder" <andreas.wendleder@proton.me>
Cc: "b43-dev@lists.infradead.org" <b43-dev@lists.infradead.org>,
 "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: Re: BCM4360 AC-PHY support for b43 =?UTF-8?B?4oCU?=
 reverse-engineered, seeking guidance on a clean path upstream
Message-ID: <20260929081403.6076a6da@barney>
In-Reply-To: <DL5AS1oidqGRAmMHt0Jcp3X4T3ob_Fa-lfhTmMMak3ATUnfcyETDn65CQf3iLvVeg4ExYoc_0GW7QMoaB1jEW4nzKAKFDv8bD0hqBEtkUKg=@proton.me>
References: <rOzY3WnW4q5L1osv7iagU81dLGldzZEsu3EqHxmH4d7Z4vxubBYvRNT0vsrbr8n-CUSEYyXxGFE3h9PHLHgePjm3_rMK_B_0m5loTpyxX-M=@proton.me>
 <ih-lXs5OlHxMhydtcZFtKNhGg3cGlR137CEMZ07_zFQcfCYAImW6MRWPDjkdwy-xK9bIwpDK9ImgerqHmQMsAxX3ckEjsiN8QoCSlpvIsSM=@proton.me>
 <20260928200309.01a36f5e@barney>
 <DL5AS1oidqGRAmMHt0Jcp3X4T3ob_Fa-lfhTmMMak3ATUnfcyETDn65CQf3iLvVeg4ExYoc_0GW7QMoaB1jEW4nzKAKFDv8bD0hqBEtkUKg=@proton.me>
X-Mailer: Claws Mail 4.4.0 (GTK 3.24.52; x86_64-pc-linux-gnu)
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="Sig_/=TQ00VYIxA1gmN_RQot4VUv";
 protocol="application/pgp-signature"; micalg=pgp-sha512

--Sig_/=TQ00VYIxA1gmN_RQot4VUv
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

On Mon, 28 Sep 2026 21:49:23 +0000
"andreas.wendleder" <andreas.wendleder@proton.me> wrote:

> if someone is interested in implementing it.

I think the number of people interested in working on this is probably
approaching zero these days.

Maybe we can find somebody doing an AI implementation from specs.
But then, why not publish yours instead?

--=20
Michael B=C3=BCsch
https://bues.ch/

--Sig_/=TQ00VYIxA1gmN_RQot4VUv
Content-Type: application/pgp-signature
Content-Description: OpenPGP digital signature

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCgAdFiEEihRzkKVZOnT2ipsS9TK+HZCNiw4FAmq7VysACgkQ9TK+HZCN
iw4jzA//VhLIjBKRiSGTRKJmR5SJ1RaDA0XbGskGstDBPDB84+xGeEbM2JLAINZp
Ijm87IIK7wnf6gqlz4B++rDwpo61c93V8P25uyrE46ORKt1Sx7Azwh5GHIGwzUQo
69cLvnOeMIFUfK1+6+ro5dyypZ+maaUitGMBKpWyAvXhqetb9nr12LPGHUKvzP8e
CraXMFeDVtNuEWPK3kn3CVbsdy6PbNxIFsl+GouiI0cBffXN/R/HOOl0MIP3QBsE
0nhWn7yw5tNuwq9WWgDV3d9zzxTm9cB2FFUW2AVT86Bn3irT2kzTG88GPs/0fZc3
arTTzltiJYqYF+Ov4tTJkkfKjmtojXo+sbuhETVhWGkcpKYmLY1xoIUyvT5cI29J
mkaKPOtJ3maRH8Y5n1jPMC2BJD2cJNmGs6XP89rb9jqgOsfxQey4/jxvkNQd+Q6Q
Lxuynzg4iZzXtNH35W913Emw9wbIkwN1o7Q1a+l8GvTXZPhrcPsYOMj91sGMFgEj
rpBkNC4NLW3+PaB5Dn973JSjvmSNjSK3WcPyhdWsPE6a8Gm0HUxvx2Fh55szU3sX
9MY1RMOAM1Z940nsfFzSUekVwtnLgaccYLT8F6YA+eZIQ1N8Yv9WF/zitxX04aPG
Q6NljlxI/a32dsPtQ+hoWoUiC5UFVx5X7ikYWKmFaJwsjw7aPAw=
=z9MO
-----END PGP SIGNATURE-----

--Sig_/=TQ00VYIxA1gmN_RQot4VUv--
