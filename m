Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=168.119.38.16
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793863767;
	b=ovaafGbIcH2RSwy2EIfVtLYFuOZw2hNzhVf+YNYM+t7T0fq6ZMnuvX2Ho8ZHvA8qP69F
	 7jWnNovIQq+/2Qf8qzNsiVTBkdylNxnQF1K8cyuaF7NdgV8lPSOVbFIoWXdm+Ve+yBuxz
	 fpUGlfVGtdnvj2LBgxQs8ndzg355cNo6f6W3E+FJ8zFHQQpxALaEw/kEAIsr0G+nYhJ9y
	 qrp6wn/0KHpz4nekhZ9Vlq2jRmI6SpxzQ/QS4vVSXnPYZRijoPSODYlOvLIXWNlTmV7MP
	 6Wo82pEN6pUvIPbzDZktHU1PEj3wR6RpKwCBWy+HQ7bTOJvxkO70IrN1C73aFiNtzCw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793863767;
	h=DKIM-Signature:Received:Message-ID:Subject:From:To:Cc:Date:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:
	 User-Agent:MIME-Version:X-malware-bazaar;
	bh=BoRT1g7dlz6B1RXUbGcPf8lhXFO+4D4A2NHex2eXQRg=;
	b=FyfZ/PKXyzqpeUo+OnmyiO1nxoASUrI8vtBWGmtLZoXoQRPZWaMCAcEXjF+1fg57txyS
	 7P0SGhkhmLvUy+Z6KaBF16ULkggoRJLZ0VcH3Xww4s8sUYxMM1p1Y6wtQDdwH5KANP2Gn
	 0av7MVYsKyISct54pXKq3FgtDfta4IW6a3KtZGUrwB88eXO3hQq5jvjnDi54ZRopxlWix
	 o74KVdwD7WAfx61xx0C7z2RVWVp75sZB+jeK4VjoiJEYNvi2fq+n9ZKPv5GFEFn25ICRF
	 CCAlABMli9ZN4kw7sBUs2dnubmsHsLTKU7bwAlPYqCDmV5x1hVe86RXXkCHiJzcnEKA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=permerror header.from=sipsolutions.net;
	spf=pass smtp.mailfrom=sipsolutions.net;
	dkim=pass header.d=sipsolutions.net header.i=@sipsolutions.net header.a=rsa-sha256 header.s=mail header.b=UCprfuPt;
	arc=none smtp.remote-ip=168.119.38.16
Received: from sipsolutions.net (s3.sipsolutions.net [168.119.38.16])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (prime256v1) server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8FE92606A326
	for <linux-wireless@vger.kernel.org>; Thu,  5 Nov 2026 07:29:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=permerror header.from=sipsolutions.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=sipsolutions.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=sipsolutions.net header.i=@sipsolutions.net header.a=rsa-sha256 header.s=mail header.b=UCprfuPt
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=sipsolutions.net; s=mail; h=MIME-Version:Content-Transfer-Encoding:
	Content-Type:References:In-Reply-To:Date:Cc:To:From:Subject:Message-ID:Sender
	:Reply-To:Content-ID:Content-Description:Resent-Date:Resent-From:Resent-To:
	Resent-Cc:Resent-Message-ID; bh=BoRT1g7dlz6B1RXUbGcPf8lhXFO+4D4A2NHex2eXQRg=;
	t=1793863766; x=1795073366; b=UCprfuPt+PwcbIGEJIXHZrT7M+aA2UaglIATzWsFXYNG++W
	gFCyp/iIvMf585gfFmj5ym6PNJy4yVfzSXor6HuOnG6jXdbyD7t9lfKxwY6rqaJwehONOktAxxAWR
	gQp/BS+CrdnB0lbwcEEbNqEgVSDeRCJiw/NGoTA1a1WG8pCQCI+7jb1RW0E83DsXenyePm1brmciT
	yqhUsJ/Xb8ZcN2UNztHJCX5RuHWb2wjYyQT6Wwly5FP8dXQtupFdN3a3iYr7ZChcgPb5g4N4K+Kb8
	m0zx/J3uUDgOPFqxWV+mA8L/1LSGBYZV9XgiOpzpaG+sVRxr3b0OfBwZEA/Iqh1w==;
Received: by sipsolutions.net with esmtpsa (TLS1.3:ECDHE_X25519__ECDSA_SECP256R1_SHA256__AES_256_GCM:256)
	(Exim 4.98.2)
	(envelope-from <johannes@sipsolutions.net>)
	id 1xOruT-00000007Q4g-2RYq;
	Thu, 05 Nov 2026 08:29:21 +0100
Message-ID: <6792cdaa627ba4755fd0836a74474977496f9670.camel@sipsolutions.net>
Subject: Re: pull-request: ath-current-20261102
From: Johannes Berg <johannes@sipsolutions.net>
To: Jeff Johnson <jeff.johnson@oss.qualcomm.com>, 
	linux-wireless@vger.kernel.org
Cc: ath10k@lists.infradead.org, ath11k@lists.infradead.org, 
	ath12k@lists.infradead.org, jjohnson@kernel.org
Date: Thu, 05 Nov 2026 08:29:20 +0100
In-Reply-To: <61e49149-5096-4440-b261-ffe2d250f6f4@oss.qualcomm.com>
References: <8e38f8dc-88f9-4974-8f98-687795fb360a@oss.qualcomm.com>
	 <61e49149-5096-4440-b261-ffe2d250f6f4@oss.qualcomm.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.60.2 (3.60.2-3.fc44) 
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Post: <mailto:linux-wireless@vger.kernel.org>
List-Help: <mailto:linux-wireless+help@vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-wireless+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
X-malware-bazaar: not-scanned

Hi Jeff,

On Wed, 2026-11-04 at 17:11 -0800, Jeff Johnson wrote:
>=20
> I missed the window for your wireless-2026-11-02 release.

Very narrowly too ...

> Since you have now
> fast-forwarded I hope you can pick this up so that I can also fast-forwar=
d. I
> have a series that depends upon a revert that went straight into Linus' t=
ree.

I did, but I was also going to wait until net lands in Linus's tree,
which should be soon (today/tomorrow) and fast forward again, so we're
really aligned. Hope that's OK.

johannes
