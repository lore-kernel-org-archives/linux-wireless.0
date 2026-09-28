Received: from sipsolutions.net (s3.sipsolutions.net [168.119.38.16])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1C4CF4E56D1
	for <linux-wireless@vger.kernel.org>; Mon, 28 Sep 2026 16:15:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=168.119.38.16
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790612126; cv=none; b=MCLpiX1n9piZCGEOcHX4Vz0gJZegwKkN+DJhy6W+BSCa/ECziPG0AhlzbPFUDh35jKE9gAmHhvemMYRpUpkPPNTpcO0Hb1eUnYRGfzo55BY9ve6fmapmr7IEpRkZ3aW7LRaF6s62hDPjobYo63up5K0Xb6QUlC0pb0tL/ciPFYE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790612126; c=relaxed/simple;
	bh=nLiMalS7lt4W2pzm8i3o4d3mOCqOdhjF1t1GoEIROn4=;
	h=Message-ID:Subject:From:To:Date:In-Reply-To:References:
	 Content-Type:MIME-Version; b=GThfl+q+IYuTD4jXWyXfQwHKa43ZiAGUteLiOdrnG+Z8R2yZWe+ESksQZ44ED8MnDIlZfVnwLwd22cz0oKgErk7ClLWJZR+HlfgZlH6+C1QXlAY6t7/Vc0MjIPMQOZ5w0kXVUGDijYjSN6z1VNvIlARVCDMIQm2KNRylEj0ik+0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=permerror header.from=sipsolutions.net; spf=pass smtp.mailfrom=sipsolutions.net; dkim=pass (2048-bit key) header.d=sipsolutions.net header.i=@sipsolutions.net header.b=OdRlgTQr; arc=none smtp.client-ip=168.119.38.16
Authentication-Results: smtp.subspace.kernel.org; dmarc=permerror header.from=sipsolutions.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=sipsolutions.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=sipsolutions.net header.i=@sipsolutions.net header.b="OdRlgTQr"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=sipsolutions.net; s=mail; h=MIME-Version:Content-Transfer-Encoding:
	Content-Type:References:In-Reply-To:Date:To:From:Subject:Message-ID:Sender:
	Reply-To:Cc:Content-ID:Content-Description:Resent-Date:Resent-From:Resent-To:
	Resent-Cc:Resent-Message-ID; bh=lWxa43YYDgIvnUuo+3Yki2rVU06HYBf4a7kPFA2Efvg=;
	t=1790612123; x=1791821723; b=OdRlgTQrOPNVDy/s84+Q0qLRACWJocYTW4unPekmL6vR+C7
	Fkaas8UZV6EtwvdKGlJ873IEp3XBwfswOQoz1SOm7nNYeF7HAJM4fiOaoOZoFgMSIFHyhruSYGgEj
	VwSgMmo0Zl4V4zMVMTU+gC1uK85XJw0zGCrx7Jm9c5zfWhL81GJhJy1q2yTHebIH9z5Qq4pZwBDkx
	+xMBAPBT0wfilB6eWKKeSPO+byQA33/NLws8+V/GsgVhY7YjsSWtDaPXsizKmrnLjRLymlF2vIisK
	AeE6DxwZVsh7Gwmh59t0re8b++K849JzeXkv7ZxS5TEP8WBk1krL/w898xa1Wk9w==;
Received: by sipsolutions.net with esmtpsa (TLS1.3:ECDHE_X25519__ECDSA_SECP256R1_SHA256__AES_256_GCM:256)
	(Exim 4.98.2)
	(envelope-from <johannes@sipsolutions.net>)
	id 1xBE0c-0000000DhUD-2hgr
	for linux-wireless@vger.kernel.org;
	Mon, 28 Sep 2026 18:15:18 +0200
Message-ID: <6187a33f3fe4f34d30bd179f2e5c64ee98dcd6eb.camel@sipsolutions.net>
Subject: Re: [PATCH wireless-next 1/2] wifi: mac80211: fix TPE in channel
 switch wrapper parsing
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Date: Mon, 28 Sep 2026 18:15:18 +0200
In-Reply-To: <20260928144357.2e38718bb504.I8b07b323ba83173b570bc07ed61f4130b8aff04f@changeid>
References: 
	<20260928144357.2e38718bb504.I8b07b323ba83173b570bc07ed61f4130b8aff04f@changeid>
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

On Mon, 2026-09-28 at 14:43 +0200, Johannes Berg wrote:
> From: Johannes Berg <johannes.berg@intel.com>
>=20
> WLAN_EID_TX_POWER_ENVELOPE is a regular (non-extended) element,
> but I accidentally used find_ext_elem() for it. Fix this.
>=20
> Fixes: 4540568136fe ("wifi: mac80211: handle TPE element during CSA")
> Signed-off-by: Johannes Berg <johannes.berg@intel.com>
> ---
>  net/mac80211/parse.c | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
>=20
> diff --git a/net/mac80211/parse.c b/net/mac80211/parse.c
> index 3b66ca7d7a5c..4ff726eef453 100644
> --- a/net/mac80211/parse.c
> +++ b/net/mac80211/parse.c
> @@ -692,8 +692,8 @@ _ieee802_11_parse_elems_full(struct ieee80211_elems_p=
arse_params *params,
>  						IEEE80211_PARSE_ERR_BAD_ELEM_SIZE;
>  			}
> =20
> -			subelem =3D cfg80211_find_ext_elem(WLAN_EID_TX_POWER_ENVELOPE,
> -							 pos, elen);
> +			subelem =3D cfg80211_find_elem(WLAN_EID_TX_POWER_ENVELOPE,
> +						     pos, elen);

Actually, this should also be a loop.

johannes
