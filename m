Received: from sipsolutions.net (s3.sipsolutions.net [168.119.38.16])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7C3204119FA;
	Tue,  8 Sep 2026 12:10:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=168.119.38.16
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788869413; cv=none; b=hWpK5v613u7xuZ/UtwMdqnhfXNZlR4SE9881Waq7GE3nLWNIkgmHJ2aqVhAHeKKULGaNChrng3+J7WRtLTh/lVEwqvHO4hGApgyu7BuwvdWJJkxTvhZUeAVLjze2d2Zk6xKbBHWR3KcfRnzRImwak5FoRMxW809IkzFyzLniy6c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788869413; c=relaxed/simple;
	bh=oKozBCCg1kGyxYMiaJulg4ZulR9HpOfXoYfb6mLsMuU=;
	h=Message-ID:Subject:From:To:Cc:Date:In-Reply-To:References:
	 Content-Type:MIME-Version; b=PCyueD20C2V6FpteHJbZtZJUAoPcO9dXoDpCh3zonNAp5PO92ziFSn/874TvsVI9hAkDDsOt0u134ZpDr/5kiBvaF+nFPe9oUk/3cl8dSccfmvuA+JntXXz+4T7bGrhxDW2lZIBi5yFwjukqUg1tNmi5N41IQX0TxSJTUNMR2bs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=permerror header.from=sipsolutions.net; spf=pass smtp.mailfrom=sipsolutions.net; dkim=pass (2048-bit key) header.d=sipsolutions.net header.i=@sipsolutions.net header.b=NA+vUnaG; arc=none smtp.client-ip=168.119.38.16
Authentication-Results: smtp.subspace.kernel.org; dmarc=permerror header.from=sipsolutions.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=sipsolutions.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=sipsolutions.net header.i=@sipsolutions.net header.b="NA+vUnaG"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=sipsolutions.net; s=mail; h=MIME-Version:Content-Transfer-Encoding:
	Content-Type:References:In-Reply-To:Date:Cc:To:From:Subject:Message-ID:Sender
	:Reply-To:Content-ID:Content-Description:Resent-Date:Resent-From:Resent-To:
	Resent-Cc:Resent-Message-ID; bh=iIrCCrZub8v+AoROsXt50ja4lv1+ARsgTH5VGRh2sek=;
	t=1788869406; x=1790079006; b=NA+vUnaGBnxoFSmunRRewCyAH9zx1FWDumxeF1wohoKzUD4
	lwgdf9vE3aXI73wCMC2JBOiYy4YuPGpoc0lNJ3pHgFJwU0vQ1ogsVP6uZe1D7e/mfipuSRRGLA9CX
	Agk2vWOYKvtC23rxfLD+DqDPFSPVtSQcA41oz4QpFRzvdJZbMSeIsNjS+F8HY7aov1uJm5Y/QEbSn
	V01fi/7g5ZYswa+eb5Ok22a9RXV8uw8/coIFiyVT5LKBfzU/N3Tys4vDdS9MNPXAh41tX5F/Wn57H
	NKU/8pLDbCd/osfdKznrYtQNNUSC6BH258U9iB6pLl/vKSsp0h0c8eESnMoeyDaQ==;
Received: by sipsolutions.net with esmtpsa (TLS1.3:ECDHE_X25519__ECDSA_SECP256R1_SHA256__AES_256_GCM:256)
	(Exim 4.98.2)
	(envelope-from <johannes@sipsolutions.net>)
	id 1x3ueF-000000065vi-2uiX;
	Tue, 08 Sep 2026 14:09:59 +0200
Message-ID: <81a49fcf5f1c6acf1d017d405d2aaf6d3ea417c5.camel@sipsolutions.net>
Subject: Re: [PATCH] wifi: libipw: reject TKIP frames without a full MIC
From: Johannes Berg <johannes@sipsolutions.net>
To: Daehyeon Ko <4ncienth@gmail.com>, Stanislav Yakovlev
	 <stas.yakovlev@gmail.com>
Cc: linux-wireless@vger.kernel.org, linux-kernel@vger.kernel.org
Date: Tue, 08 Sep 2026 14:09:58 +0200
In-Reply-To: <20260908082729.209627-1-4ncienth@gmail.com> (sfid-20260908_102749_361409_E04BC684)
References: <20260908082729.209627-1-4ncienth@gmail.com>
	 (sfid-20260908_102749_361409_E04BC684)
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

On Tue, 2026-09-08 at 17:27 +0900, Daehyeon Ko wrote:
> libipw_tkip_decrypt() accepts a frame containing the TKIP header and a
> valid encrypted ICV even when the plaintext MSDU is shorter than the
> eight-byte Michael MIC.  After it removes the header and ICV,
> libipw_michael_mic_verify() subtracts the missing MIC from skb->len.
>=20
> skb->len is unsigned, so a zero-byte plaintext makes
>=20
>         skb->len - 8 - hdr_len
>=20
> wrap to 4294967288.  michael_mic() then attempts 1073741822 four-byte
> reads starting at the end of the 802.11 header.  Generic KASAN reports a
> slab-out-of-bounds read once the loop leaves the skb allocation.
>=20
> The ipw2100 and ipw2200 receive paths call this from a tasklet while
> holding spin_lock_irqsave(), so the OOB access can panic the kernel or
> stall a CPU with local interrupts disabled.
>=20
> The trigger requires an affected IPW device using host TKIP
> verification, an active TKIP key, and a sender able to construct a
> non-replayed frame with a valid encrypted ICV.  This conservatively means
> a malicious AP or a peer holding the same TKIP key.
>=20
> Require the full MIC before entering the verifier.  A valid-MIC control
> continues to pass.  A zero-payload frame with a valid encrypted ICV is
> dropped without a KASAN report in three fresh boots through libipw_rx().
>=20
> The KASAN reproduction uses a white-box module and the registered TKIP
> crypto operations.  I do not have the hardware, so this has not been
> tested over the air.
>=20
> The initial candidate was supplied for validation.  AI-assisted tooling
> traced the source and receive paths, prepared the reproducer and fix, and
> ran the build and runtime checks.

Bla bla bla. Please rewrite the commit message.

> +++ b/drivers/net/wireless/intel/ipw2x00/libipw_crypto_tkip.c
> @@ -476,7 +476,7 @@ static int libipw_michael_mic_verify(struct sk_buff *=
skb, int keyidx,
>  	struct libipw_tkip_data *tkey =3D priv;
>  	u8 mic[8];
> =20
> -	if (!tkey->key_set)
> +	if (!tkey->key_set || skb->len < hdr_len + 8)
>  		return -1;

Why hardcode 8?

johannes
