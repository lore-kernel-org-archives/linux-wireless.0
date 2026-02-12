Received: from sipsolutions.net (s3.sipsolutions.net [168.119.38.16])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6030835972
	for <linux-wireless@vger.kernel.org>; Thu, 12 Feb 2026 17:36:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=168.119.38.16
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770917781; cv=none; b=O4NLe3xNEuIgdUrbDvO+hvj9xyEHsJXYagaTiK6zwGhttiujpBH5SVWH5yeTr1Wys0UiYmLT5c+cOsUJG4yacEWI+E9+bytYJUEN7t6HRy99s0q4C498POKdABMTxrbPRVmMWtgVtFqHJQYWI1mq28Sfrnp+Py4CJMJkTxBjsbI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770917781; c=relaxed/simple;
	bh=c4llVvf9Mo/wttF0k+pL6UmEXaoAAXFXj72mqESVFoE=;
	h=Message-ID:Subject:From:To:Cc:Date:In-Reply-To:References:
	 Content-Type:MIME-Version; b=W3vBzJ5AeB4jFEuLDxBAMkvisCwTdnDmYz3fSYMzL/ag5sMx0fD8QWE7gDx8xgYHI/04vJn88MzaC+CkOqwO90cEMDAtv+ZzrLR0mf4c3p5ydfFog7HvYeIXSThfJtgItkKHJVLVVcTl3DAnDZybSJuQXfpLxG79lNOv1RPmqVg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=sipsolutions.net; spf=pass smtp.mailfrom=sipsolutions.net; dkim=pass (2048-bit key) header.d=sipsolutions.net header.i=@sipsolutions.net header.b=Gbj4XcYs; arc=none smtp.client-ip=168.119.38.16
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=sipsolutions.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=sipsolutions.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=sipsolutions.net header.i=@sipsolutions.net header.b="Gbj4XcYs"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=sipsolutions.net; s=mail; h=MIME-Version:Content-Transfer-Encoding:
	Content-Type:References:In-Reply-To:Date:Cc:To:From:Subject:Message-ID:Sender
	:Reply-To:Content-ID:Content-Description:Resent-Date:Resent-From:Resent-To:
	Resent-Cc:Resent-Message-ID; bh=c4llVvf9Mo/wttF0k+pL6UmEXaoAAXFXj72mqESVFoE=;
	t=1770917780; x=1772127380; b=Gbj4XcYsK2V5lo7D4gmTMqTEBt7+8l3RD/SGs2afBvkEyAJ
	z4hTBj5vb+XUvuK/a7tulv6J1RasvH+HmTPvDAhuSu9pwHTBqSwxp9INrPxs58NzIvXZQDC3g2ldu
	c1W1nIY7cVl8J9bo+tirTKkYDbzcLbDDf1Efwrx8zkYrPSvfwpFEvprr2VzaXQJzai2G/GbV8LzmG
	xB265wioBS3AyqqdNyc+G8VH/OXOKGJboFC4+y86m2/imBSzfc5Caf3ExyZUV7oqQaDhtj9rF1rZK
	PvTHH5D+r76jefowWDGQe8Fc3HH/zVZVNX4giLLXWUh2YzhbsCLUsAV1ak8FeAAw==;
Received: by sipsolutions.net with esmtpsa (TLS1.3:ECDHE_X25519__RSA_PSS_RSAE_SHA256__AES_256_GCM:256)
	(Exim 4.98.2)
	(envelope-from <johannes@sipsolutions.net>)
	id 1vqabv-00000006Syu-3s3E;
	Thu, 12 Feb 2026 18:36:16 +0100
Message-ID: <c9353b48d4efdcdfcd46553e83a8131869c08b49.camel@sipsolutions.net>
Subject: Re: [PATCH wireless-next v2 00/02] wifi: ieee80211/mac80211: Add
 UHR (802.11bn) Capability and Operation parsing helpers
From: Johannes Berg <johannes@sipsolutions.net>
To: Karthikeyan Kathirvel <karthikeyan.kathirvel@oss.qualcomm.com>
Cc: linux-wireless@vger.kernel.org, ath12k@lists.infradead.org
Date: Thu, 12 Feb 2026 18:36:15 +0100
In-Reply-To: <20260212172401.234059-1-karthikeyan.kathirvel@oss.qualcomm.com>
References: <20260212172401.234059-1-karthikeyan.kathirvel@oss.qualcomm.com>
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

On Thu, 2026-02-12 at 22:53 +0530, Karthikeyan Kathirvel wrote:
> This series covers support for UHR capability and operation (11bn)
> parsing helpers for DPS/DBE/P-EDCA, and adds mac80211 hwsim changes.
>=20
> The code changes are based on the IEEE 802.11bn Draft P802.11bn/D1.3.
> There may be changes in the code to adopt upcoming 11bn spec changes.

Indeed. I hear Qualcomm prefers 8 bits for the NPCA primary channel
rather than the 4 bits for the NPCA primary channel (offset) ;-)

Anyway, I'm sure we'll adjust this all eventually. I just wanted to also
say that I'll try to post the NPCA changes I made soon, where I was also
adding NPCA to UHR capabilities in hwsim, but that doesn't really
matter.

johannes
