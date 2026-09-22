Received: from sipsolutions.net (s3.sipsolutions.net [168.119.38.16])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 54C403BF69A;
	Tue, 22 Sep 2026 08:49:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=168.119.38.16
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790066995; cv=none; b=Rjd2Aou9CXrx7FIMtALg81Op+Q1zoXIeu7ZkezUpUhAk+PeZnaCEyEdNzSLzo1WXolbGOeRBuWwStNCnUEh9+LGM39nBSyz756hs/hLfd1LeSa+XQZWvRk+76qEcWjjTeke610hjjQQuvpMX49DuDMUUjdEAAzGkHr2AtwxmlDI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790066995; c=relaxed/simple;
	bh=U8fDp+h/ENm5bFZyQFTlNQ1KY4CZ0VdVFYofRSDngZ0=;
	h=Message-ID:Subject:From:To:Cc:Date:In-Reply-To:References:
	 Content-Type:MIME-Version; b=Ylz9H5pq5elrT+4mUXWHKpCml4p37wJPl1PRPtUvgG3WV01rQp7LfJfiCw8rQpGdNYAeAVxmVoILt3zyvQu3WQ2UpHoXQ/gDdWaAYQQ4j/byPWaSndALP9jtLh5bpPU59+ats8LQX5n3FEj7+PoOVdX0m2oM2IfwwzF5vfwUYic=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=permerror header.from=sipsolutions.net; spf=pass smtp.mailfrom=sipsolutions.net; dkim=pass (2048-bit key) header.d=sipsolutions.net header.i=@sipsolutions.net header.b=HsNLlo32; arc=none smtp.client-ip=168.119.38.16
Authentication-Results: smtp.subspace.kernel.org; dmarc=permerror header.from=sipsolutions.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=sipsolutions.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=sipsolutions.net header.i=@sipsolutions.net header.b="HsNLlo32"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=sipsolutions.net; s=mail; h=MIME-Version:Content-Transfer-Encoding:
	Content-Type:References:In-Reply-To:Date:Cc:To:From:Subject:Message-ID:Sender
	:Reply-To:Content-ID:Content-Description:Resent-Date:Resent-From:Resent-To:
	Resent-Cc:Resent-Message-ID; bh=L4IUwwEhUcHmLxbAU4I9rSSDxUDhG9xZoLHVOLBQjzk=;
	t=1790066993; x=1791276593; b=HsNLlo32cOq3s4V2gnKhjLgD0DKP2fiS4gndwLGQbUPLmGZ
	l/aqoe9pyIwzfUkQVYIA5kgdQKSqiBx/DnORqJ96LOOO4BILhE/95mUKrNE3rzzepS4ecAcF1IDQD
	k9o1OBrpEpx1iU2BfzxmJ89EDLIjFL6ciufDbIn2ha4ywSp81uSZr+s/fbuJhWhuj/Sodf634xRZi
	069+uBugcogG0rnryKsZCw0G+kanEEu6AUnV4+2eWxgi6rLexxniJUTWArM3+1el9gofVe9BMlf7n
	GP2DdYmGkUlA8jDpjkLhtdt6J7hB7oldc/Tgf40EKiadSWHN+cBHYbPGFa9yuYLw==;
Received: by sipsolutions.net with esmtpsa (TLS1.3:ECDHE_X25519__ECDSA_SECP256R1_SHA256__AES_256_GCM:256)
	(Exim 4.98.2)
	(envelope-from <johannes@sipsolutions.net>)
	id 1x8wCC-00000006mYU-1Ss4;
	Tue, 22 Sep 2026 10:49:48 +0200
Message-ID: <1ba070b7bceb6cf1b912569fa802992ee15876b4.camel@sipsolutions.net>
Subject: Re: Missing signoff in the wireless tree
From: Johannes Berg <johannes@sipsolutions.net>
To: Wireless <linux-wireless@vger.kernel.org>, linux-kernel@vger.kernel.org,
 	linux-next@vger.kernel.org
Cc: Miriam Rachel Korenblit <miriam.rachel.korenblit@intel.com>
Date: Tue, 22 Sep 2026 10:49:47 +0200
In-Reply-To: <arI_TQnqQNOkjorm@sirena.co.uk>
References: <arI_TQnqQNOkjorm@sirena.co.uk>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.60.2 (3.60.2-2.fc44) 
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-malware-bazaar: not-scanned

On Tue, 2026-09-22 at 10:41 +0200, Mark Brown wrote:
> Commits
>=20
>   81550f0ead8c2 ("wifi: cfg80211: preserve hidden-group beacon IE ownersh=
ip")
>   d6846d11123d1 ("wifi: mac80211: keep fallback association elements aliv=
e")
>   81cbf8f3a3d68 ("wifi: mac80211: shut down RX BA session timer on teardo=
wn")
>=20
> are missing a Signed-off-by from their committers

Oops, added - which means a rebase. Judging from your other mail, only
iwlwifi was affected.

johannes
