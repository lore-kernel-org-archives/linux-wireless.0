Received: from mail.bues.ch (bues.ch [116.203.120.240])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CCA8824503F
	for <linux-wireless@vger.kernel.org>; Sun,  8 Mar 2026 15:59:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=116.203.120.240
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772985599; cv=none; b=iCL5ZvbK5iCbaqK/XpESSKpOXPiSxuwLUMy9PdyFG6Ef+06knJwsjoWpdSrBfpOzA6I0/7mwP3hMq0R1oIO8ygmZQDI+prHuhaAE2dnpgj4/hh96//vv9XK8NYOK1IqfdvL/lRFr6F3fu0AQQ9SY7XyAu9z4fso12I/pCwkPbHI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772985599; c=relaxed/simple;
	bh=QsEootamH5rYIe2PKLPjJtYKxZZmo05HWkCkmo+1XkU=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=RvQs1WA5x7Rlbea9I5Hvunsn+3Z9sPPaL8lMnBriVohfY42h2yMyJxzl8oi/NqP2Uf3DAii6X+L4hLQQL+aigV3JuooD993vfCpdEcWiy2noVRK9jnwLSyDL+QvS0MbWPvsETDay+Kb2E2DALWbVo5iNEiqLmGUqqGt3VaCSAz8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=bues.ch; spf=pass smtp.mailfrom=bues.ch; dkim=pass (2048-bit key) header.d=bues.ch header.i=@bues.ch header.b=Bn47Aa0f; arc=none smtp.client-ip=116.203.120.240
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=bues.ch
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=bues.ch
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=bues.ch header.i=@bues.ch header.b="Bn47Aa0f"
Date: Sun, 8 Mar 2026 16:50:05 +0100
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=bues.ch; s=main;
	t=1772985023;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=ol9BeCZAQq4A7ib2l3MAH4Azy3kgUQyH8nvQOy82geY=;
	b=Bn47Aa0fmfMwXr87pkqRFoWh08+rZcLRQdtH7UPaGaMzZ9wre19UeM0i9H9o8fOx53TZzO
	2DpdKmOeqDwAbb1Lu8Fuzf9J7zdkqUwLKNv9k2Qx1Zw51feKckSf6Aimx68ljV6Rtioy/h
	2ULC4jvMPHgj1D9L2+++EkCxEQnZLcrxF8zpvoSboDRVJdAtAeGkvnNlVQPN8eloyrfcMk
	QGoSRUtMYnTks57tNER34tj7zMwFSVVcwsEL2q0yo5R0/N3SE8/iPJzAf2Jtek4Xu4SAcq
	Od0qbzwmjd9X+jUDiS9etMHogXvTXBDUT9+Oa9upCQfMpKhgNzPlbQ7tFyVgDQ==
From: Michael =?UTF-8?B?QsO8c2No?= <m@bues.ch>
To: Joshua Peisach <jpeisach@ubuntu.com>
Cc: linux-wireless@vger.kernel.org, b43-dev@lists.infradead.org, Francesco
 Dolcini <francesco.dolcini@toradex.com>, Johan Hovold <johan@kernel.org>,
 Johannes Berg <johannes.berg@intel.com>
Subject: Re: [PATCH] wifi: b43: use register definitions in
 nphy_op_software_rfkill
Message-ID: <20260308165005.20ef9b23@barney>
In-Reply-To: <20260307170135.167460-1-jpeisach@ubuntu.com>
References: <20260307170135.167460-1-jpeisach@ubuntu.com>
X-Mailer: Claws Mail 4.3.1 (GTK 3.24.51; x86_64-pc-linux-gnu)
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="Sig_/6X=jnq=CXy4.QK0L0rb9BSL";
 protocol="application/pgp-signature"; micalg=pgp-sha512

--Sig_/6X=jnq=CXy4.QK0L0rb9BSL
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

On Sat,  7 Mar 2026 12:01:35 -0500
Joshua Peisach <jpeisach@ubuntu.com> wrote:

> Replaces uses of hardcoded register addresses with proper definitions,
> for readability.
>=20
> Signed-off-by: Joshua Peisach <jpeisach@ubuntu.com>

Looks good to me. Generates the same object code.

Acked-by: Michael B=C3=BCsch <m@bues.ch>

--=20
Michael B=C3=BCsch
https://bues.ch/

--Sig_/6X=jnq=CXy4.QK0L0rb9BSL
Content-Type: application/pgp-signature
Content-Description: OpenPGP digital signature

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCgAdFiEEihRzkKVZOnT2ipsS9TK+HZCNiw4FAmmtmq0ACgkQ9TK+HZCN
iw4crBAAykOe7tIE+BQLd+zMiiv6NqN0krUWBfgXBU6cgnOsWuP3VW7w9ra81N9f
JCT5a5ZE/m+NpMLWIjMIxlxx+YU/cSlUl+1hiAWCRmHoobGj9cjRsc6OTokTQgEe
i/wNiLycxFthhmrgimtN270IIJ9tfi5LjtfliexG4NZ9rJvzEqJll3flFnPJm08A
HXiupCyNHmKvL9CoX96+IZkwtjUjQUJ2pwGHw3XMGn/NZySNCF19we0HTSVDnXzf
RjAyTSBkoZ+d9ZPQyGNT2H2iuBaz0dlEdzgIsRW0hX9SMskXjLNgGX7yRsHoDGNt
t7LLpIPXc06DPsBkaGM1DTqoSl2rqGwjAKNG/aOtximiZd5s7Ix+BXAJFn+J6fAa
37MFd9cMM4HKQHqGbfYA0b/NFMQQjDJUIXMbOoV0Zdiz8X07U+uFnJwSic9wb0Sk
5719fmpTOSA65MbuMMqTrUbt68B8fD8j9hKlQeYLEU4J9ggy7EsG8FbZKojnI90b
ORSgsWIlEUnmLkya4C6wTPKtWVI6syI8fv0ii5nmNUsFDt8nEqGO9vda4HOI2sTd
os54Ap7Sy0io5H3ktXDyf/WlddzYhoytwJb/LhFh/gKNp1sPjDEr5oLaVytqUqNB
GTWODa1XC/H2HYbOo8s6z+CIPFCGDD8slGf4CMe0E6JlXZqCbyI=
=blyG
-----END PGP SIGNATURE-----

--Sig_/6X=jnq=CXy4.QK0L0rb9BSL--
