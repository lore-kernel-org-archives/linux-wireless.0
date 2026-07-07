Received: from sipsolutions.net (s3.sipsolutions.net [168.119.38.16])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6A1A33ACF15;
	Tue,  7 Jul 2026 07:21:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=168.119.38.16
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783408895; cv=none; b=S22EtRyxN1gNMUMMtoad6rZZEF3kMsau0eOaY0UDcli2ut+a0iNACwAkMvPvMTdYruRyTWthtVaI+3cVnK2RbbunBc6YxQom/YemKlFOyloWHMJ+luuKJ75NvOVSEouKsTY3ljDn68arQW3CVK908Bk04VWM1CAuBjfgfPNKPsI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783408895; c=relaxed/simple;
	bh=4wAZn1toglTpMljJWOWOgrot5isJ45N2ujp3EFbMuy4=;
	h=Message-ID:Subject:From:To:Cc:Date:In-Reply-To:References:
	 Content-Type:MIME-Version; b=hox0UuBbSA1h4D3BVurQWi2h1uxMbrMatcAsCbJEpcJ3TUI2+7B36fJM9RK+Gj2CZdRSV98aeP5zj0jk7878dZ8mBtHCsTh2j2U92dcfS6FX7C66CtWi5AUYTvFyBEy3N/Kn/ogLGC7nwo2VWDHtMymNJpjIhxU0gqgZXdQPLbc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=permerror header.from=sipsolutions.net; spf=none smtp.mailfrom=sipsolutions.net; dkim=pass (2048-bit key) header.d=sipsolutions.net header.i=@sipsolutions.net header.b=XIKXHDWA; arc=none smtp.client-ip=168.119.38.16
Authentication-Results: smtp.subspace.kernel.org; dmarc=permerror header.from=sipsolutions.net
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=sipsolutions.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=sipsolutions.net header.i=@sipsolutions.net header.b="XIKXHDWA"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=sipsolutions.net; s=mail; h=MIME-Version:Content-Transfer-Encoding:
	Content-Type:References:In-Reply-To:Date:Cc:To:From:Subject:Message-ID:Sender
	:Reply-To:Content-ID:Content-Description:Resent-Date:Resent-From:Resent-To:
	Resent-Cc:Resent-Message-ID; bh=4wAZn1toglTpMljJWOWOgrot5isJ45N2ujp3EFbMuy4=;
	t=1783408890; x=1784618490; b=XIKXHDWAxSvjwY3rX8d+cjcFP7hZ6or9XUSTmagHC+SS0e9
	IqvsYud/pQj9FPdVQxM4sV02d9PB6ZQnfm7gYXxzwoimL3Kr9xHn6Fw0dF05IVghshdaFe0ekE6qK
	LEvEqm6VwVwHZqMxvOKtZvaaUa68OtoiyVY9LOLcBv6NeHz/hEBLk9SxX8VnyBR+xy3+SJ79nfYEC
	BEfyRLZhPNAlF+JSL7rkCBYsLa15DZbyhR3emx4ksGRQXNDPW0FTVUuwwABrH3eYugaJER4qFJhI6
	uHNQI2N1Oih4pVq8sRl9psM9PvTkUcsGbVwoYK+qbcTAQG/5kSd0x5z++9lxrXgg==;
Received: by sipsolutions.net with esmtpsa (TLS1.3:ECDHE_X25519__ECDSA_SECP256R1_SHA256__AES_256_GCM:256)
	(Exim 4.98.2)
	(envelope-from <johannes@sipsolutions.net>)
	id 1wh07Q-0000000HPhN-1Zq0;
	Tue, 07 Jul 2026 09:21:24 +0200
Message-ID: <66f148d83eb9f0970b9abbccc85d1b61244e54ad.camel@sipsolutions.net>
Subject: Re: [PATCH 1/3] wifi: cfg80211: validate rx/tx MLME callback frame
 lengths before access
From: Johannes Berg <johannes@sipsolutions.net>
To: Zhao Li <enderaoelyther@gmail.com>
Cc: linux-wireless@vger.kernel.org, linux-kernel@vger.kernel.org
Date: Tue, 07 Jul 2026 09:21:23 +0200
In-Reply-To: <20260707025241.22223-1-enderaoelyther@gmail.com> (sfid-20260707_045255_477753_F3C5731E)
References: <20260612185042.66260-4-enderaoelyther@gmail.com>
	 <488ed9862d5196b8f5ecf23f037fa6725fbe9a52.camel@sipsolutions.net>
	 <20260707025241.22223-1-enderaoelyther@gmail.com>
	 (sfid-20260707_045255_477753_F3C5731E)
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

On Tue, 2026-07-07 at 10:52 +0800, Zhao Li wrote:
>=20
> mwifiex accepts a 4-address
> ieee80211_hdr plus the 2-byte firmware length prefix. After it strips
> the prefix and removes addr4, pkt_len can be exactly 24: a bare
> 3-address management header with no reason-code body.
> WARN_ON(len < 2) does not fire on that, and cfg80211_process_deauth()
> then reads u.deauth.reason_code as a two-byte access starting at offset
> 24, immediately past the 24-byte buffer.

Right, thanks for the explanations here (and in the other mail). I'm
fairly sure the firmware would (have to) discard such frames, but we
shouldn't rely on it. Looks like mwifiex is pretty much a trainwreck on
this anyway though, e.g. mwifiex_parse_mgmt_packet()? I vaguely remember
fixing something like this but I guess it was elsewhere ...

johannes
