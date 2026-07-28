Received: from sipsolutions.net (s3.sipsolutions.net [168.119.38.16])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C5B083D9022;
	Tue, 28 Jul 2026 15:39:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=168.119.38.16
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785253180; cv=none; b=nZ6XrDQWuVFgsUDl5p6Ouvhbm4TpnyptkM+kDB5AuKupEjbSEbSzSn5Q1CUtLetP2rUrrd7fagDwsQ+Xog/u2ARK4RgytZ9wXciqb9qnt2Vg41YjUrGNJiG/0OqkAa4sfUt+GjQBdKpr9PFp5pKaPqdM02O3rpRwPNbTkSwnUf4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785253180; c=relaxed/simple;
	bh=yNQGFmwpDPwQYgRCcPYESKQ7eBvT2PUQEOclQUXGuzw=;
	h=Message-ID:Subject:From:To:Cc:Date:In-Reply-To:References:
	 Content-Type:MIME-Version; b=dvKsVcipsn65CNJz7x/f0oSyC2nx1CR1ubwWK3Yg4uspeuDnQlk6Lv4O0YfzA0p88PclWQqJJ30RZa3LZJs9qSdWr+8f0R4fq0PyitNvUxz5oYhSeYiMhpG4QgSW4e4z/cXSBHNll1H0kKdBCPs/AnqJn4IQ6UwPilYtqNz99oM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=permerror header.from=sipsolutions.net; spf=pass smtp.mailfrom=sipsolutions.net; dkim=pass (2048-bit key) header.d=sipsolutions.net header.i=@sipsolutions.net header.b=Lrn83tJt; arc=none smtp.client-ip=168.119.38.16
Authentication-Results: smtp.subspace.kernel.org; dmarc=permerror header.from=sipsolutions.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=sipsolutions.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=sipsolutions.net header.i=@sipsolutions.net header.b="Lrn83tJt"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=sipsolutions.net; s=mail; h=MIME-Version:Content-Transfer-Encoding:
	Content-Type:References:In-Reply-To:Date:Cc:To:From:Subject:Message-ID:Sender
	:Reply-To:Content-ID:Content-Description:Resent-Date:Resent-From:Resent-To:
	Resent-Cc:Resent-Message-ID; bh=yNQGFmwpDPwQYgRCcPYESKQ7eBvT2PUQEOclQUXGuzw=;
	t=1785253178; x=1786462778; b=Lrn83tJtVhHcT8Ru8RTtfwnnpRJHc8n1v1Y4Gv7fC3l4T4J
	XooqMlWMRGgB63IBbd96IIRz/5eU/iBucmi170TRkfm7ebRli4nhvOZIUMd0tF/mOM1HyKrrRtpW3
	e8CIykS+S39UnU/PadLR4RuWxPrZTGRWxJu3LcXAMXoph5kLWr7QQRU/+QRfAfEuN+nV3DSw0LoPR
	EgJfdUIn5fGO8NEEyhv/+A1m9PT3gzOJPClk83Z7/Wcl17ruV/1rx6MEBaSS/mkzcSFyB5irMAWZv
	41nTYvkCQ20O/HUabuyVflYoZRLV+F3N5zIuH/zzzzV4/RevAzk8Kw1EgeEWD49A==;
Received: by sipsolutions.net with esmtpsa (TLS1.3:ECDHE_X25519__ECDSA_SECP256R1_SHA256__AES_256_GCM:256)
	(Exim 4.98.2)
	(envelope-from <johannes@sipsolutions.net>)
	id 1woju2-0000000AjdT-3TuY;
	Tue, 28 Jul 2026 17:39:35 +0200
Message-ID: <fb275c7cfa0ef8b8f90c81d25985cf579bce90b7.camel@sipsolutions.net>
Subject: Re: [PATCH -next v2 00/12] wifi: cfg80211: consolidate cookie
 assignment for async ops
From: Johannes Berg <johannes@sipsolutions.net>
To: Arend van Spriel <arend.vanspriel@broadcom.com>
Cc: linux-wireless@vger.kernel.org, brcm80211@lists.linux.dev
Date: Tue, 28 Jul 2026 17:39:33 +0200
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

On Tue, 2026-07-28 at 16:45 +0200, Arend van Spriel wrote:
> NL80211_ATTR_COOKIE is a userspace-visible u64 that correlates an async
> nl80211 operation with its completion event. Three cfg80211 ops currently
> delegate cookie generation to the driver: remain_on_channel, mgmt_tx, and
> probe_peer. This produces inconsistent strategies across drivers: some us=
e
> an incrementing counter, some use get_random_u32(), some use a CID cast t=
o
> u64, and brcmfmac's mgmt_tx always assigned zero - which is arguably brok=
en
> since cfg80211 treats zero as an invalid cookie.

[snip]

Looks good to me, but I just finished merging for the day ;)

I'll let it soak for a while, and driver maintainers should have a
chance to review it as well, of course. We're in no hurry anyway...

Thanks! :)

johannes
