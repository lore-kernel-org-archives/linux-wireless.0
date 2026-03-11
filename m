Received: from sipsolutions.net (s3.sipsolutions.net [168.119.38.16])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 99E78248873
	for <linux-wireless@vger.kernel.org>; Wed, 11 Mar 2026 06:24:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=168.119.38.16
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773210250; cv=none; b=jbU++QnWC8lgwLxs05IW5ymS8oDFY03gpvThga/0v7xRvwbP2beyInylO3H76WOkpxAboZ1m2w6J0CmnBcq7lQnDYfGE/0AXMq9CYggrmi0D8D99V7xI0oB/8U/Z4LyJQZhJf+6+AmZbcG9rJ5ypzigXRIMzzZiTZr+rslWiEA4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773210250; c=relaxed/simple;
	bh=UPr6q8MlJF981lhJMuzJwHTNHBZ/fbK3tCL40nHd3/c=;
	h=Message-ID:Subject:From:To:Cc:Date:In-Reply-To:References:
	 Content-Type:MIME-Version; b=bxoPAgR8IvSLVIg1pF+XG+/ck24yk/rPwg8NummIGTTxKo/ygBdBB+Foa/hvNlINGNOoYMhHnHtOwz1WvsqiR7UVGGDyPFJy/sU3L5pe8GktKFZ6y46THdPNO8lpzwYZUtv3K60nOpVjW9K4B+/12y/uMRrRfxSm+bMtiYFAWZk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=sipsolutions.net; spf=pass smtp.mailfrom=sipsolutions.net; dkim=pass (2048-bit key) header.d=sipsolutions.net header.i=@sipsolutions.net header.b=x6XJH0i0; arc=none smtp.client-ip=168.119.38.16
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=sipsolutions.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=sipsolutions.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=sipsolutions.net header.i=@sipsolutions.net header.b="x6XJH0i0"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=sipsolutions.net; s=mail; h=MIME-Version:Content-Transfer-Encoding:
	Content-Type:References:In-Reply-To:Date:Cc:To:From:Subject:Message-ID:Sender
	:Reply-To:Content-ID:Content-Description:Resent-Date:Resent-From:Resent-To:
	Resent-Cc:Resent-Message-ID; bh=UPr6q8MlJF981lhJMuzJwHTNHBZ/fbK3tCL40nHd3/c=;
	t=1773210249; x=1774419849; b=x6XJH0i0EVVBcqsnEXKZSnxOioNl9iX/rexlYdNv3I2radd
	4QhUwICat1yRe/glZdMByJBWOmFL/H/A14CIG9vGYlGKqiWEbkpC5jbhsIR5lD48smy+YtNNLD+81
	xGC0R5IeZx0BrUw0J2hWz8PIWw7c1c5NMMSEFfhzPnD/W/kNWQtFr/5lOZzEAxlutsnHRFd1TTwyu
	M9SaUlLP2w4pqZH/WXhu2LNGiOPlBcyTod7SXzxxlXHUgimGl2gih5w+LOyP9/fvrnKRDHfiSt3WZ
	+CtKJI88qqLcNhJyw3l3zXLsZNJ4APpMB0Qt11GpunvIZmFmZxxdwxNvlXV/Rr2Q==;
Received: by sipsolutions.net with esmtpsa (TLS1.3:ECDHE_X25519__RSA_PSS_RSAE_SHA256__AES_256_GCM:256)
	(Exim 4.98.2)
	(envelope-from <johannes@sipsolutions.net>)
	id 1w0CzA-0000000Eg3I-3ngB;
	Wed, 11 Mar 2026 07:24:01 +0100
Message-ID: <62057e8c13c4b6358dcb42bd639aec2996cf2bca.camel@sipsolutions.net>
Subject: Re: [PATCH wireless-next] wifi: cfg80211: init S1G properly when
 creating chandef
From: Johannes Berg <johannes@sipsolutions.net>
To: Lachlan Hodges <lachlan.hodges@morsemicro.com>
Cc: linux-wireless@vger.kernel.org, arien.judge@morsemicro.com
Date: Wed, 11 Mar 2026 07:24:00 +0100
In-Reply-To: <20260311061800.517849-1-lachlan.hodges@morsemicro.com> (sfid-20260311_071817_345070_19A555FE)
References: <20260311061800.517849-1-lachlan.hodges@morsemicro.com>
	 (sfid-20260311_071817_345070_19A555FE)
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

On Wed, 2026-03-11 at 17:18 +1100, Lachlan Hodges wrote:
> When emulating channel contexts, the first chandef passed to the
> driver when starting an interface is the local->dflt_chandef
> via ieee80211_calc_hw_conf_chan(). This means that currently an
> S1G driver will be given a chandef with a width of 20MHz. This will
> lead to either the driver or firmware rejecting this configuration
> and a non-zero ret code - leading to a WARN within
> ieee80211_hw_conf_init().
>=20
> In the case of emulation, ensure we initialise with a width of
> 1MHz for S1G channels such that the default chandef is valid.

I haven't had my morning tea ;-)

But the commit message feels to me like it's conflating cfg80211 and
mac80211 concepts? You change cfg80211 - but then start out saying "when
emulating" which happens in mac80211?

johannes
