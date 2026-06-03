Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D9D1039BFE5;
	Wed,  3 Jun 2026 07:17:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780471023; cv=none; b=Wn1uWHMK5JzB/1+VH2GIbox2sx8wTWxKpxUQBuzwh1PqHDfZLNgSVVq3XDfgUGw+1fJopYk9GLfkSVKWR2/4BLbjFWoUHx+taiUF9rSLiDa04P95xyNCJottKVZ6JkstYrDisMHexJU/1P8R24+jHp4Lvw+xLgywqTh/xd7RkRQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780471023; c=relaxed/simple;
	bh=Tv6HCRIHKg3T+9QBcnUv7zYmy7M3lPX5MIXOUnJE+yU=;
	h=Date:From:To:Cc:Subject:Message-ID:MIME-Version:Content-Type:
	 Content-Disposition; b=hNRT5hyIT1Zjz8ZUlmcW1esrutMeKxAyaGcgm/0rDlmn4+4XarFtA7W7LxSoiZWX1R2/8osSCHmGTEMc0lFwMS99QMwH0fzqXtxszRJ1eO0udR4nSysXranGFXWxGglqqAhdeEjid9yVHFEy7ort3xTb/Wrk39GNigEijnnixTA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=jN/ry5oC; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="jN/ry5oC"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8DBBD1F00893;
	Wed,  3 Jun 2026 07:17:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1780471022;
	bh=+nWUDLiP30W/RSvphRKxxD5tUXTNQPMjw7/UNGHo4UY=;
	h=Date:From:To:Cc:Subject;
	b=jN/ry5oC4t3CThAXvX5NISEhf5lE0BlIlfC9mer8doqd3j3YryrMRXBVrDRbnCfzI
	 vCi1GQW7s5T+/37zceHZfWUpkY2kZimlqzU8nbQjDNqHCDSxGoioHq/DxKgXa2G1vG
	 tGiQ0/kmRRNn1wSL9jjPWdaM1JJZyJi2RQADFvFXTxW63+weuFdAwEKM6TpQkBI5wh
	 7zYAV625y/9uBg0xaOxTYhHTUYRB1p+AqaigPMFzqwllzI+ah8QeIeBH4f/eXbpVtO
	 eRkold+rb0vXr2tzDLG6eKrJcDmGGzuZToLLnUFZcZPtTPnraSinK6l6c51BN7tKFJ
	 u/f24y3qHKcaw==
Date: Wed, 3 Jun 2026 08:16:59 +0100
From: Mark Brown <broonie@kernel.org>
To: Johannes Berg <johannes@sipsolutions.net>,
	Wireless <linux-wireless@vger.kernel.org>
Cc: linux-kernel@vger.kernel.org, linux-next@vger.kernel.org
Subject: Missing signoff in the wireless tree
Message-ID: <ah_U6xEhq5GSebBc@sirena.org.uk>
Mail-Followup-To: Johannes Berg <johannes@sipsolutions.net>,
	Wireless <linux-wireless@vger.kernel.org>,
	linux-kernel@vger.kernel.org, linux-next@vger.kernel.org
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="UDz1/u8MxfU41vlN"
Content-Disposition: inline


--UDz1/u8MxfU41vlN
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Commit

  1b659e979685b ("wifi: mac80211: fix NULL dereference of eht_oper in ieee80211_start_ap()")

is missing a Signed-off-by from its author

--UDz1/u8MxfU41vlN
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEreZoqmdXGLWf4p/qJNaLcl1Uh9AFAmof1OoACgkQJNaLcl1U
h9B6QAf/RubJMbmTNInUgIsCqZKNhdqvAW5vTyqejhp5W1aVyZ0dRAwYooAcDR1y
XWHdKHa4YxAzgIOjWVlxRBFVwjfoKCdXQPynQDqrfi4Nyy1o4oLRU9Njw4lAny4a
w1B941m4eTwxBa8JnWjFqaahL8aMfi2CPAXM5wS4kcKfHv3XZM6UUT6MQuGYgzyn
UA04krFqvNzQMykM03cyajLZ+5Gtvb8mwNFpfimAVBB1+h61yacU/LY8wnNbid9r
nU20jEVTcTeZKlsxfqPK47dBq4Eh+VpF9oed5NA+WjNVEU1oUHKrc2gTg5pnvMGu
3GbIShD+KqGau+KFzYFURRIs3OaiPA==
=qxje
-----END PGP SIGNATURE-----

--UDz1/u8MxfU41vlN--
