Received: from sipsolutions.net (s3.sipsolutions.net [168.119.38.16])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4C5C53D5222;
	Fri,  4 Sep 2026 07:49:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=168.119.38.16
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788508190; cv=none; b=R+R8pbxoCLXOmiBPC7VFvVP9qmh/sKrHxeQxpSmpTIIrXibITyTKbG7KahEMFNQr4LJWgGzwc5ZOoKG9x8innfWEUrVivbct5WD6fxPIIe2sTCLbLnpg5gWLcJwJqloGwCzETXGQfXPwApgI2YJRBkSmb5rrr/UdZQMAoWT0V4I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788508190; c=relaxed/simple;
	bh=QJVjAEDWwnIMRV/6wvJBcNRbekzd7s7/hBp/6OZMJuc=;
	h=Message-ID:Subject:From:To:Cc:Date:In-Reply-To:References:
	 Content-Type:MIME-Version; b=S6xfq2K8PNcgcRanHEUnO7COsZwg62AsOmOjI2SjVyXMtQOzkZTopTDkZm0EIskgk2IVarA8bvBDquTSxw5saYZnUVVo+uE0Ktn6Xb15QHO13ocV1eRwclW9QNOlnCGIo+9Hs8zquV9FkXU/vITTgE08LcsxwGxO7YR4M4/W7fI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=permerror header.from=sipsolutions.net; spf=pass smtp.mailfrom=sipsolutions.net; dkim=pass (2048-bit key) header.d=sipsolutions.net header.i=@sipsolutions.net header.b=gJERBbZf; arc=none smtp.client-ip=168.119.38.16
Authentication-Results: smtp.subspace.kernel.org; dmarc=permerror header.from=sipsolutions.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=sipsolutions.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=sipsolutions.net header.i=@sipsolutions.net header.b="gJERBbZf"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=sipsolutions.net; s=mail; h=MIME-Version:Content-Transfer-Encoding:
	Content-Type:References:In-Reply-To:Date:Cc:To:From:Subject:Message-ID:Sender
	:Reply-To:Content-ID:Content-Description:Resent-Date:Resent-From:Resent-To:
	Resent-Cc:Resent-Message-ID; bh=QJVjAEDWwnIMRV/6wvJBcNRbekzd7s7/hBp/6OZMJuc=;
	t=1788508187; x=1789717787; b=gJERBbZfIBq6bank+CtofSqXttFTvoWTo7jKvEZ27zpHzHt
	Jv/S0hyW3CF1MYggTXbKc981ecWuI1ZJ0HxndNIk2rCeuHM8dOcMrAMXqOG54CMm4PVifLSKwHBIc
	51n9KgI4mW115M0eUqU28L/4df92yITcNC4+VdnMdto/iASvM46G4YN667rJMB4a90n0+KZinUyzM
	P/YcR89Nv1TwO2k2sDKpeDdlwHc1kuBBagozaIbt5UdA8Ho2oi0GiXSQ2NLjOkb+wkfrBUxi8WZ5n
	h64Hq06YLo9u6C/OqaGFrOtSuPrvttRDMaiGG9ppvWyvEQOIIegJIXUPTXxQ3VJw==;
Received: by sipsolutions.net with esmtpsa (TLS1.3:ECDHE_X25519__ECDSA_SECP256R1_SHA256__AES_256_GCM:256)
	(Exim 4.98.2)
	(envelope-from <johannes@sipsolutions.net>)
	id 1x2OgB-00000001FMI-2VvZ;
	Fri, 04 Sep 2026 09:49:43 +0200
Message-ID: <8019b79321a8c846f5a4232c2f7fed778c0a1cc7.camel@sipsolutions.net>
Subject: Re: [PATCH wireless] wifi: mac80211: drop the monitor filter counts
 on stop, not just sometimes
From: Johannes Berg <johannes@sipsolutions.net>
To: Devin Wittmayer <lucid_duck@justthetip.ca>
Cc: Alexander Wetzel <Alexander@wetzel-home.de>, Felix Fietkau
 <nbd@nbd.name>, 	linux-wireless@vger.kernel.org,
 linux-kernel@vger.kernel.org
Date: Fri, 04 Sep 2026 09:49:42 +0200
In-Reply-To: <20260825043754.66918-1-lucid_duck@justthetip.ca>
References: <20260825043754.66918-1-lucid_duck@justthetip.ca>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.60.2 (3.60.2-1.fc44) 
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-malware-bazaar: not-scanned

On Mon, 2026-08-24 at 21:37 -0700, Devin Wittmayer wrote:
> Bringing a monitor up raises the filter counts that track what userspace
> asked to see: frames that failed their checksum, control frames, other-BS=
S
> traffic. Taking it down again should lower them.

Seems legit, but ...

> The rise happens for every monitor. The fall sits inside the branch that
> retires the virtual monitor, so it is skipped for an active monitor, and
> on any driver setting NO_VIRTUAL_MONITOR. For those, every up and down
> leaves another increment behind.
>=20
> So once anything has asked to see frames that failed their checksum, the
> hardware keeps handing them up long afterwards, to monitors that never
> asked for them. The other counts accumulate the same way, including the
> one that keeps TX status reporting armed once it has been used.
>=20
> Changing the flags on a running monitor still balances, so the
> accumulation boils down to the open and stop pair.
>=20
> Reproduced on mac80211_hwsim: an active monitor brought up and down
> leaves one unmatched increment behind, while a passive monitor on the
> same phy balances.
>=20
> The two sides matched until cooked monitor support was taken off the
> heat. The decrement got baked into the new conditional along with the
> virtual monitor bookkeeping and never came back out. Move it out again
> so it mirrors the increment.

Ugh. Please rewrite this manually to not just be LLM fluff, to be
something one can actually consume at human speed.

johannes
