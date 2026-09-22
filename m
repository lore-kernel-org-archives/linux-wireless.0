Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D1EDC522F0E;
	Tue, 22 Sep 2026 08:41:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790066521; cv=none; b=e0C9jXMKo8spQvojqnzMdRYinCa/J8cJtnUbl2KJDwjlF04oTlxIZK7Mf1FIAumHnM2IAdie8XFvEN+6nB4xsMfG7034w9EMC7/jiN848FLgEWe98tWAUPuhSF6SirBb6uJoWQz63IOgxQAN/zbtWDCekziDfWFaZN8Oa4+9OUM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790066521; c=relaxed/simple;
	bh=TiKWjd9v+drgIKSLvOtt9iAuMKHDigQCof8eUU0cBxg=;
	h=Date:From:To:Cc:Subject:Message-ID:MIME-Version:Content-Type:
	 Content-Disposition; b=vDsiEgPRiZH4oSnzy+ElR1e4bgdlKBZD8zKMi56skFXSmX9j3hQkI5L1cWUwTNattRB5fPDg1XH5SMxXBDyWhdHam4/DBEEzXW0jftmgG6jsbIR0ddGGWIn9lZOLnlvKQYmGbJIzIB7uRUp8P2RkDVwr2vTm2WJcUwZtb2jBciY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=L7ud7gvn; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="L7ud7gvn"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9DF5C1F000FF;
	Tue, 22 Sep 2026 08:41:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790066517;
	bh=7ERpZppPw+B96P8rxonvuoC5Vn+kA3gwdE/13K6aiRM=;
	h=Date:From:To:Cc:Subject;
	b=L7ud7gvnaVOPPKVWs2t71QgucONHzudAMTM7vWZpfeOULO01xxbDW7cMe5TbElB79
	 AH18ifRme1jes9OYxuZlmsHLnM5dh9RWBGKXszJo+dKKxh9NGiZq7RlJKxpe8pBIzC
	 O3rcI7YAtKILj0L1Pa+baD6Dp2Sh0x/ILIMYb4lUSbp+8Wwt4i0hjPN7c0JaU6Fzpb
	 lfv+Yv+U97pMVoJYrLhrC08G8g9JhS3WeIGcCZThMeJdBpAZNETLao2sx3HY0QCw2p
	 0HgMt+y0D61NBDSyyDhYYeGqdancn2kSeFE7TAeyi2adOXLUsLut3qNMajdr4/aL+g
	 ZkYqo+ptmVydg==
Received: by finisterre.sirena.org.uk (Postfix, from userid 1000)
	id 2519A1AC56BF; Tue, 22 Sep 2026 09:41:49 +0100 (BST)
Date: Tue, 22 Sep 2026 10:41:49 +0200
From: Mark Brown <broonie@kernel.org>
To: Johannes Berg <johannes@sipsolutions.net>,
	Wireless <linux-wireless@vger.kernel.org>
Cc: linux-kernel@vger.kernel.org, linux-next@vger.kernel.org
Subject: Missing signoff in the wireless tree
Message-ID: <arI_TQnqQNOkjorm@sirena.co.uk>
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
	protocol="application/pgp-signature"; boundary="i5dxdJal1a7Kz1Qb"
Content-Disposition: inline


--i5dxdJal1a7Kz1Qb
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Commits

  81550f0ead8c2 ("wifi: cfg80211: preserve hidden-group beacon IE ownership")
  d6846d11123d1 ("wifi: mac80211: keep fallback association elements alive")
  81cbf8f3a3d68 ("wifi: mac80211: shut down RX BA session timer on teardown")

are missing a Signed-off-by from their committers

--i5dxdJal1a7Kz1Qb
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEreZoqmdXGLWf4p/qJNaLcl1Uh9AFAmqyP0wACgkQJNaLcl1U
h9D5rAf/Z4KITYhxhdxVNFDx4L+ZMw8oaQXKbf7NhAFTG8vr41oEnKPcxhppQo21
8NzzmOrC2GFty5YlOWifRLwAQYQXImjKe4vpI2Q71LEMXLhp+QeztGMt0If/oCPr
8YB6Sp4JKDaFddFMsyH9u6gDlTNnWnUG6LTMMwvpnoYq8oriPfGscwjTjLymOo/C
vPj1/9+SOZkJgnUaMbfUN3d3YJ5lLzZBuvjiAMv83L0549hUZ8M5hh4JCFsGE/fF
N6bMu4UqJYNRCVq8uLtuOc6FLFL2DjBo/65miItgnQb5mAkzjdO6vR+UbF/k1zoE
/GWWj8mQlpBZq4EsFoNyt0cWvfgRtg==
=5CI2
-----END PGP SIGNATURE-----

--i5dxdJal1a7Kz1Qb--
