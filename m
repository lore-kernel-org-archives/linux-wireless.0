Received: from sipsolutions.net (s3.sipsolutions.net [168.119.38.16])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 29FC0298CC4;
	Thu,  5 Feb 2026 08:18:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=168.119.38.16
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770279486; cv=none; b=pJRVAfVe3kwTxlKkAtjIwL+BEIrr4cXS/tCzGnOGBN5vPCuy8kv9MF+/5Zor3oL18gS9hNqSr6VQkktUCRu0CWn4hFkX5MtQMNzIDuXBMRSDcfdEuJfl1SL8xfaULNT/Sh73TE09ZxkYFKpTWjdtnJMZkBaFCmP+1YW81bkQ8MI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770279486; c=relaxed/simple;
	bh=d6czF1Mp6LaftRex5Z5Cx76eLZM9ZX6QUdrLafdNhT4=;
	h=Message-ID:Subject:From:To:Cc:Date:In-Reply-To:References:
	 Content-Type:MIME-Version; b=eRgof2HBF8PrX1RlncqYHaf6od4VmcjMGACbu2YzpSTe79ab/hX7Wfb1aY7rerdCVgn1zo/BTyn82RTeFPwEsL6VbrjFkRw1M0oEaKCJosqPEO0cJBAobg47OAiCEgRrcyl56LDbxIxTMdEyaGMlB/u7e0vmFcWioB4f4CIW6l0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=sipsolutions.net; spf=pass smtp.mailfrom=sipsolutions.net; dkim=pass (2048-bit key) header.d=sipsolutions.net header.i=@sipsolutions.net header.b=QAqvwzND; arc=none smtp.client-ip=168.119.38.16
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=sipsolutions.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=sipsolutions.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=sipsolutions.net header.i=@sipsolutions.net header.b="QAqvwzND"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=sipsolutions.net; s=mail; h=MIME-Version:Content-Transfer-Encoding:
	Content-Type:References:In-Reply-To:Date:Cc:To:From:Subject:Message-ID:Sender
	:Reply-To:Content-ID:Content-Description:Resent-Date:Resent-From:Resent-To:
	Resent-Cc:Resent-Message-ID; bh=d6czF1Mp6LaftRex5Z5Cx76eLZM9ZX6QUdrLafdNhT4=;
	t=1770279486; x=1771489086; b=QAqvwzND6abR7j5+Fw3o4nVyZm5ick36cxv3TUqxjvWmwfr
	1YTlJr/blHkIIM/l3rTZeV7EPuWkq+sonW1Nn6gbED0ESoS7S/65GQ56PENNu83ol/hqOIdQvix12
	puxJ2KtDzCVJVQ87vnSr9dablATtMzKDoxZ6SmNQGVoPlIkOfBAQ6DiR2xXpqFsBDWCymnQ8kcHoQ
	avJ+JrEHp6Y+Vcg4PQtI0hc4k0W/fKcE0gXgeaBCecMVvCbDO+vp0CCXQ7JKsJ6NaljwnLA4s/QM9
	28MfVU6hoxNnR4qA3vAAmIjP+QJAUyI0qc6YowBUztYCY16tZ15qOLSdI+FWpFgQ==;
Received: by sipsolutions.net with esmtpsa (TLS1.3:ECDHE_X25519__RSA_PSS_RSAE_SHA256__AES_256_GCM:256)
	(Exim 4.98.2)
	(envelope-from <johannes@sipsolutions.net>)
	id 1vnuYp-0000000FNdu-3zeV;
	Thu, 05 Feb 2026 09:18:00 +0100
Message-ID: <6006da6281d43f4f5a55dd6434d40eedfc7ae4fd.camel@sipsolutions.net>
Subject: Re: [PATCH net-next] net: intel: fix PCI device ID conflict between
 i40e and ipw2200
From: Johannes Berg <johannes@sipsolutions.net>
To: "Loktionov, Aleksandr" <aleksandr.loktionov@intel.com>, Ethan
 Nelson-Moore <enelsonmoore@gmail.com>, "netdev@vger.kernel.org"
 <netdev@vger.kernel.org>,  "linux-wireless@vger.kernel.org"	
 <linux-wireless@vger.kernel.org>
Cc: "stable@vger.kernel.org" <stable@vger.kernel.org>, "Nguyen, Anthony L"	
 <anthony.l.nguyen@intel.com>, "Kitszel, Przemyslaw"	
 <przemyslaw.kitszel@intel.com>, Andrew Lunn <andrew+netdev@lunn.ch>, "David
 S. Miller" <davem@davemloft.net>, Eric Dumazet <edumazet@google.com>, Jakub
 Kicinski <kuba@kernel.org>,  Paolo Abeni <pabeni@redhat.com>, Stanislav
 Yakovlev <stas.yakovlev@gmail.com>, Alice Michael	 <alice.michael@intel.com>
Date: Thu, 05 Feb 2026 09:17:59 +0100
In-Reply-To: <IA3PR11MB89868B6110780F90795E4ED7E599A@IA3PR11MB8986.namprd11.prod.outlook.com>
References: <20260205075445.43347-1-enelsonmoore@gmail.com>
	 <IA3PR11MB89868B6110780F90795E4ED7E599A@IA3PR11MB8986.namprd11.prod.outlook.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.58.3 (3.58.3-1.fc43) 
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-malware-bazaar: not-scanned

On Thu, 2026-02-05 at 08:13 +0000, Loktionov, Aleksandr wrote:
> >=20
> Commit message could be more detailed.
> - Why the PCI ID is being reused (if known) Is this actually a reuse afte=
r EOL, or is there a misunderstanding? The commit message hand-waves this c=
ritical detail.

Well, if you and I can't figure this out internally to Intel, I doubt
anyone _else_ can. Sure, ipw2200 is EOL for *long*, but Intel still
shouldn't have reused the IDs even if the old ones got carried forward
from PCI to PCIe.

> - Whether this is documented in hardware datasheets

Good luck finding any documentation on ipw2200 these days. Those devices
shipped 20+ years ago.

> - If there are bug reports of the conflict in the wild

Does it matter? If you have a system with either of those, you'll get
lucky if it works, and get a mess if it doesn't. ipw2200 driver will
probably bind to just about any device with the right IDs since it
doesn't do much in probe().

johannes
