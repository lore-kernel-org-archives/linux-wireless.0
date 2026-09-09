Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5EC2454EEB3;
	Wed,  9 Sep 2026 12:12:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788955931; cv=none; b=X+aEQC9t7f+N98ppE778SJnXOVxXF83vA0KMIg4ymOkEUF3gnXKEJg9KPxSMrb2PeYjebA44UfDF0202Y5HotVTEfz08dueKVjW0T6rO4uVsf49ffeAJ7mYZm1wqHZnPNIadIJxgnQAoy6yj4pA5qx8+aCohfN0aHsEBJ/FzQ6I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788955931; c=relaxed/simple;
	bh=4PH4y3k0de09TdOF5qlJ/6Hxx7brRNxvCZNHYZol6as=;
	h=Date:From:To:Cc:Subject:Message-ID:MIME-Version:Content-Type:
	 Content-Disposition; b=C2MCAXczXGnFQJKeOdz1hIjy9WifRSmbCG2CT2MhpGJwvlQ/chzjgLXJAfoo70Qi/51BPjNJ+aio7QRJdzgr5W5Lz4ICDGtIPglH1E2kRGiuNQMocsHCbYbB55XZ1Tv1tHoqlKTz5be9SQDQgjh9samRCG0AfHSG/ThYzKd4kfY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=BjFb4141; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="BjFb4141"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 267D01F00A3D;
	Wed,  9 Sep 2026 12:12:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788955930;
	bh=AGhYemJFbAqxKPpz2HFhWV2CmUaaRta6PwmF9mbHN1A=;
	h=Date:From:To:Cc:Subject;
	b=BjFb41414CcVAv+k84Fgw3LgKi1AF4WCCiJTw5fAmG4L9RXaqD1u6vqNGC07aINUt
	 qUpkoFmiw1t9P5bS7VscLujdPkpX2Iek6FXUzXjXRA78/S4KcLyWhvI+rdkSF6OaYU
	 sx4kmLCg8J+FqJdh++154lkyu0W/58iua3Cdb1AAlz/HyfJcVqOPdI00WfYJTzp4Jp
	 hNPIuJfbdZFIMl1s954KCy4HKLUm0gmFg7Ct2kkxj8ZarO7iMIkjdHFnUEOGFkmmKF
	 F6OAh3AUmjsZNgoBofEGWz5qm0o5q1o7paUksu0Y+VypDS1fWqlb2yTN5QMVG7ygbt
	 yj9N1BgtRidxw==
Date: Wed, 9 Sep 2026 13:12:06 +0100
From: Mark Brown <broonie@kernel.org>
To: Johannes Berg <johannes@sipsolutions.net>,
	Wireless <linux-wireless@vger.kernel.org>
Cc: linux-kernel@vger.kernel.org, linux-next@vger.kernel.org
Subject: Fixes tags need work in the wireless tree
Message-ID: <aqFNFqrtwTvTTvZl@sirena.org.uk>
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
	protocol="application/pgp-signature"; boundary="P6garEj5/8Eysyka"
Content-Disposition: inline


--P6garEj5/8Eysyka
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

In commit

  bea22601ee301 ("wifi: cfg80211: don't free driver-owned scan requests")

Fixes tag

  Fixes: 4a58e7c38443 ("cfg80211: don't 'leak' uncompleted scans")

has these problem(s):

  - Subject does not match target commit subject
    Just use
	git log -1 --format='Fixes: %h ("%s")'

--P6garEj5/8Eysyka
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEreZoqmdXGLWf4p/qJNaLcl1Uh9AFAmqhTRUACgkQJNaLcl1U
h9Dauwf/RRCmT5O6mQnrX9hV9xeMtRayPtut4LLSwyIENt0I0dQNEYPkVj9s8hjE
1CkFXqrrSL9IVeA5xI/A6DoT9cvIk76e/2R77ou7HHPD9MU6VlpfeFoZg2qg1Pnd
mGc9OMCkZSDFZhmqh3Vd9fNUlESnZL4zIiDk9+sjsUn3nyKX41gZQT7oaVv7LhmH
9SNxKBd7GJj37VADGvkNZGvXrQkIxW61XEj6B434vEwvoTwd5ilhqAVsYSuZsrt5
dGQVS/hcM/semD+dwPOp0jCwCLeZ3GBE3jZ++81GI3nlTye/x6l4SQ64x45sCst0
54B0vTqCuY42CEHKRhXMcnFy4U44Bw==
=/fRv
-----END PGP SIGNATURE-----

--P6garEj5/8Eysyka--
