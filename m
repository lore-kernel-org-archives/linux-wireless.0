Received: from sipsolutions.net (s3.sipsolutions.net [168.119.38.16])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 49654396D1A;
	Wed,  7 Oct 2026 10:44:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=168.119.38.16
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791369914; cv=none; b=drg0fzYIyl/KaDO6VyRlZK3pJK3GeSo8EDr0q7MS/aH0y2M9GbDoCGVKaWvMJWZGRUFmbb+5cDIxXO6TZj/MMUdaQNfy5kKjlONdik6oEL8yhleSsZkfvDAWbIlmIHqiR7Rf4TUdYdtX702Ba9W2/A5PP6VXWebfWust6xSrqtw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791369914; c=relaxed/simple;
	bh=C4LdKU7+HfWE/hERxLoZZiaQeFCIAuMkWkI7tBvQlh8=;
	h=Message-ID:Subject:From:To:Date:In-Reply-To:References:
	 Content-Type:MIME-Version; b=SMNcHUcDFzjcf0eQ/H99InkFNp6dsP0KxwBLbxOU/nBIbqmD/Jlbd7U/5bZmafOHsRsLQW0Y13GhHCBdJUHIBUs4FUiHtaYJIw9Df1ev7OStkuSRZz6uoa2dhH8J7J7WBnEh72qJvJzv3ORpQ0EoQgv48sweYxIqK4nCyeWQWVM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=permerror header.from=sipsolutions.net; spf=pass smtp.mailfrom=sipsolutions.net; dkim=pass (2048-bit key) header.d=sipsolutions.net header.i=@sipsolutions.net header.b=d90mys02; arc=none smtp.client-ip=168.119.38.16
Authentication-Results: smtp.subspace.kernel.org; dmarc=permerror header.from=sipsolutions.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=sipsolutions.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=sipsolutions.net header.i=@sipsolutions.net header.b="d90mys02"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=sipsolutions.net; s=mail; h=MIME-Version:Content-Type:References:
	In-Reply-To:Date:To:From:Subject:Message-ID:Content-Transfer-Encoding:Sender:
	Reply-To:Cc:Content-ID:Content-Description:Resent-Date:Resent-From:Resent-To:
	Resent-Cc:Resent-Message-ID; bh=qB5XLtUrKta+Vg2pME6/sZKkpQlF27LcMPib/SAbYdo=;
	t=1791369870; x=1792579470; b=d90mys02wfcD/dKBm8sdqacClkkWGVtMs2eJypOjrxIgn5G
	xw4Egvyt0gmLPL9tG+adDWrpan7Id56ZxzmDLHweAX+vvvrgHPghv79B4m5/piR1t0E6ugf2Qxbrw
	JYCeNn4F6g7pdno4RaDBINkPEobbHT1FTQy4MbDdd6U1oE9h1lhvA4gOoUln45S2kmvsV6jTUgrKz
	j1mWg4qrunsGUtgKo7FlR28MLDnLdziVlxYSZgjInGR/dAmPJEWx/oGVcAef0hip5aZqTaKYpw5If
	EnWFxN+sZIS5bg2BvvR0SEj0pN7ii9qdde9ivJHp1fYKGYTDMUevZkJ3QD1I93SA==;
Received: by sipsolutions.net with esmtpsa (TLS1.3:ECDHE_X25519__ECDSA_SECP256R1_SHA256__AES_256_GCM:256)
	(Exim 4.98.2)
	(envelope-from <johannes@sipsolutions.net>)
	id 1xEP8H-00000007zjt-1Ar9;
	Wed, 07 Oct 2026 12:44:21 +0200
Message-ID: <8733c371179651d5fa3f86dd28d8547e3994d3c2.camel@sipsolutions.net>
Subject: Re: Missing signoff in the wireless tree
From: Johannes Berg <johannes@sipsolutions.net>
To: Wireless <linux-wireless@vger.kernel.org>, linux-kernel@vger.kernel.org,
 	linux-next@vger.kernel.org
Date: Wed, 07 Oct 2026 12:44:15 +0200
In-Reply-To: <asYfk8onC1sBo23Y@sirena.co.uk>
References: <asYfk8onC1sBo23Y@sirena.co.uk>
Content-Type: multipart/signed; micalg="pgp-sha512";
	protocol="application/pgp-signature"; boundary="=-b9irYMaiWFyxhZ9SO1a5"
User-Agent: Evolution 3.60.2 (3.60.2-2.fc44) 
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-malware-bazaar: not-scanned
X-malware-bazaar-2: OK


--=-b9irYMaiWFyxhZ9SO1a5
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, 2026-10-07 at 12:31 +0200, Mark Brown wrote:
> Commit
>=20
>   6d41af9b469a3 ("wifi: mt76: mt7996: fix uninitialized buf read in mt799=
6_variant_fem_init()")
>=20
> is missing a Signed-off-by from its committer

Crap. That commit shouldn't even *exist*, but I'd made a mess the other
day and apparently didn't quite fix it.

Thanks for the heads-up, I'll be rebasing wireless to fix it (again).

johannes

--=-b9irYMaiWFyxhZ9SO1a5
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----

iQIzBAABCgAdFiEEpeA8sTs3M8SN2hR410qiO8sPaAAFAmrGIn8ACgkQ10qiO8sP
aAAu4g/+Nu5yQtBBdr6s8oWbh0asFQxTbnr4tw96eJkZsc43mQCJWB1QnGpEW5FI
kBGuWF17J8OacgXZzmG+55bOl4evY7u7HuQ4q7MQXNyjMpblXkvEN13lYUwuTpLL
cQNbhkfk0YZp512zeJi8mvD6WJdrRcO1VwcjdyeticgkIBW12paeZk0uxfeSOEst
yF/7TV7CIT7AxR1EdC16avEAvauyyvi4gP40V0TJBeTYQM1fLYLMYvOfEdGDKzn7
v4/In2UjKGrmNj6JtfSKXzwQEnmRXdti9v2fn147erSbxL5EUnLfkdcm4aEle7FO
BvfkWS4rW8RYNyYR1lNZTqax1ft+TVAMjqHCsKHEzVvboBOBjVfaFrVlpFN+FaRr
E5eeOkv0ndl2wqL0iT8z507bhjWUyZgNebV5GS2smHYYJV2DvTIU/P+nhIDRqaYN
ntfbSq7mepK6jL/4SviJOBYzmnvYIr1bZu4SX9Gxh0U2Yb+F3FE5FFzkEVM71WNn
Y2W50qBV+lg8BEOQUoNy4/rqj9uFwwUt7GC95KUFtib1OvWsNkAwRzeNkR6ogUMu
La4Vkk513acFV6uJm5F7T5gFVnNKl30pJ0TITE/lDcmLVY0P0Vb4QPFKRk1V1ZRW
5Pkt8vcdQgCAyR8fMcxsSBBHYHcRy5MbxQ/z12gpRPuGTF5Cc0k=
=hKKG
-----END PGP SIGNATURE-----

--=-b9irYMaiWFyxhZ9SO1a5--
