Received: from sipsolutions.net (s3.sipsolutions.net [168.119.38.16])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1A6C8370AD5;
	Tue, 28 Jul 2026 16:18:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=168.119.38.16
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785255531; cv=none; b=idDIb5uezc1BRrGKLE/qE3tkWkV4YuEI6cMeB+nPGCfXeQSa+zuJzhdfs2h36dBFRRgpwWduHBzMe7v4udSCzAflIBjkl4BR7I8FIPoW2a6dKch/ZXHXcQuzsAZoahTMLj8ejOFUgFhB+HgLMRFKGFnEk/eV1hZXnwaPFi6mXTM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785255531; c=relaxed/simple;
	bh=xdyRuNhvai6vLQ9lbbu56Hq+n766w5hDZRgDygh+VC0=;
	h=Message-ID:Subject:From:To:Cc:Date:In-Reply-To:References:
	 Content-Type:MIME-Version; b=Y5Kl681IE3xA+dgweN8c7nvCt1fWLitN/TrF8xpBYc/S25NmPvBedhMXCBhuFB3EEbMTM7vhbzbqJ/9S4PBfWUj2MRgMrsK/enAJU0uAB5HtBsGhRevtrGbKOd8/T2MXbsxu4vVJFwDbXCMhxsZL74PrTKJiEwOefWG2LAO7A5I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=permerror header.from=sipsolutions.net; spf=pass smtp.mailfrom=sipsolutions.net; dkim=pass (2048-bit key) header.d=sipsolutions.net header.i=@sipsolutions.net header.b=o8yVRYCZ; arc=none smtp.client-ip=168.119.38.16
Authentication-Results: smtp.subspace.kernel.org; dmarc=permerror header.from=sipsolutions.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=sipsolutions.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=sipsolutions.net header.i=@sipsolutions.net header.b="o8yVRYCZ"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=sipsolutions.net; s=mail; h=MIME-Version:Content-Transfer-Encoding:
	Content-Type:References:In-Reply-To:Date:Cc:To:From:Subject:Message-ID:Sender
	:Reply-To:Content-ID:Content-Description:Resent-Date:Resent-From:Resent-To:
	Resent-Cc:Resent-Message-ID; bh=xdyRuNhvai6vLQ9lbbu56Hq+n766w5hDZRgDygh+VC0=;
	t=1785255530; x=1786465130; b=o8yVRYCZfKY/bKx3/D4QVm5Sj5P39n06MrZJsBlqZqfHM8+
	nVaVKlcNhA5wSKEclGkzLrPvQAnfXs9/fN6Srny4GfreSM+fV5q7W0RzsWyZ63RTL/METcZVDcWFS
	5ztBjcI5WxC9jYM8vWFhMCBdle7N2ny9KDYlaSuVHLoKheToz3B66vgmGVJP5lAYUTQh1LTvmqMy+
	RF4tUPDyLxs62v4+sZfigbGmpT26Co26Hvox88aPAT3A410r8Z4Ge9Q6lhuYxPAmRXaU6xbVgmA/6
	egf1Q370MXv2NCaSCTM72b+Dvlfufk5CAMSz1Vegn4OcDZ7o3U6DO3yfybPGXFLg==;
Received: by sipsolutions.net with esmtpsa (TLS1.3:ECDHE_X25519__ECDSA_SECP256R1_SHA256__AES_256_GCM:256)
	(Exim 4.98.2)
	(envelope-from <johannes@sipsolutions.net>)
	id 1wokVz-0000000BNuD-04KR;
	Tue, 28 Jul 2026 18:18:47 +0200
Message-ID: <03bb72fdab133a4efa84bd57cad966d222fadb73.camel@sipsolutions.net>
Subject: Re: [PATCH -next v2 00/12] wifi: cfg80211: consolidate cookie
 assignment for async ops
From: Johannes Berg <johannes@sipsolutions.net>
To: Arend van Spriel <arend.vanspriel@broadcom.com>
Cc: linux-wireless@vger.kernel.org, brcm80211@lists.linux.dev
Date: Tue, 28 Jul 2026 18:18:46 +0200
In-Reply-To: <20260728144549.2207061-1-arend.vanspriel@broadcom.com> (sfid-20260728_164608_178238_1CE18783)
References: <20260728144549.2207061-1-arend.vanspriel@broadcom.com>
	 (sfid-20260728_164608_178238_1CE18783)
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

Hmm. Maybe it's not too hard to update the staging driver?

https://netdev-ctrl.bots.linux.dev/logs/build-wireless/1136007/14715755/bui=
ld_32bit/summary

johannes
