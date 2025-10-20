Received: from mail.simonwunderlich.de (mail.simonwunderlich.de [23.88.38.48])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 58B391D5170;
	Mon, 20 Oct 2025 09:30:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=23.88.38.48
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760952646; cv=none; b=FJ4gbO3gtG1i4xBqIwpD5W1k3QE6lKz6ywvkHQlL+G6of+v6IRyb9oyS7qcP4ipd/nOr5BsRMNpPaj1DefQA1pf/cTEmTxKFJFM5ajBMg4CvKR2a5+sBDiIh3XLHKsSdPpBlESy0mfUHlhrUAW1r25aJvyaJNRGBxXbl0IjEra0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760952646; c=relaxed/simple;
	bh=FNMnx5+bZoNhpZBbNBNDjAZYL0dDEYjhSeKmd3AymaQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=ZcHMn0UZd5j93vhBrS6DPT2KqmJMHa0LyiOz+6XbEES9UqB1ZfNE6YrlMosgVSTbkVa+QYJ19EnWkV2HPRnEJUFKrkO5OkbNgUhywXtsibs+xMLAvgjIeuBI4Fj40vHXgGrzR7B7cki/WeIBEwejOlcX1mR5YqARv/XBG0aWohk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=simonwunderlich.de; spf=pass smtp.mailfrom=simonwunderlich.de; arc=none smtp.client-ip=23.88.38.48
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=simonwunderlich.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=simonwunderlich.de
Received: from ripper.localnet (p200300c59748F6e00000000000000c00.dip0.t-ipconnect.de [IPv6:2003:c5:9748:f6e0::c00])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by mail.simonwunderlich.de (Postfix) with ESMTPSA id 2476BFA130;
	Mon, 20 Oct 2025 11:30:38 +0200 (CEST)
From: Sven Eckelmann <se@simonwunderlich.de>
To: Felix Fietkau <nbd@nbd.name>, Lorenzo Bianconi <lorenzo@kernel.org>,
 Ryder Lee <ryder.lee@mediatek.com>, Shayne Chen <shayne.chen@mediatek.com>,
 Sean Wang <sean.wang@mediatek.com>,
 Matthias Brugger <matthias.bgg@gmail.com>,
 AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>
Cc: linux-wireless@vger.kernel.org, linux-kernel@vger.kernel.org,
 linux-arm-kernel@lists.infradead.org, linux-mediatek@lists.infradead.org,
 stable@vger.kernel.org
Subject:
 Re: [PATCH mt76 v3] wifi: mt76: Fix DTS power-limits on little endian systems
Date: Mon, 20 Oct 2025 11:30:37 +0200
Message-ID: <2453774.NG923GbCHz@ripper>
In-Reply-To: <20251020-fix-power-limits-v3-1-019d2e49239a@simonwunderlich.de>
References: <20251020-fix-power-limits-v3-1-019d2e49239a@simonwunderlich.de>
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="nextPart880480923.0ifERbkFSE";
 micalg="pgp-sha512"; protocol="application/pgp-signature"

--nextPart880480923.0ifERbkFSE
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"; protected-headers="v1"
From: Sven Eckelmann <se@simonwunderlich.de>
Date: Mon, 20 Oct 2025 11:30:37 +0200
Message-ID: <2453774.NG923GbCHz@ripper>
MIME-Version: 1.0

On Monday, 20 October 2025 11:20:53 CEST Sven Eckelmann (Plasma Cloud) wrote:
> The power-limits for ru and mcs and stored in the devicetree as bytewise
> array (often with sizes which are not a multiple of 4). These arrays have a
> prefix which defines for how many modes a line is applied. This prefix is
> also only a byte - but the code still tried to fix the endianness of this
> byte with a be32 operation. As result, loading was mostly failing or was
> sending completely unexpected values to the firmware.
> 
> Since the other rates are also stored in the devicetree as bytewise arrays,
> just drop the u32 access + be32_to_cpu conversion and directly access them
> as bytes arrays.
> 
> Cc: stable@vger.kernel.org
> Fixes: 22b980badc0f ("mt76: add functions for parsing rate power limits from DT")
> Fixes: a9627d992b5e ("mt76: extend DT rate power limits to support 11ax devices")
> Signed-off-by: Sven Eckelmann (Plasma Cloud) <se@simonwunderlich.de>
> ---
> Changes in v3:
> - add "mt76" as addition prefix after "PATCH" as requested by Zhi-Jun You
> - Link to v2: https://lore.kernel.org/r/20250926-fix-power-limits-v2-1-c2bc7881eb6d@simonwunderlich.de

Seems like the v2 was already picked up [1] and I've simply missed it.

Sorry about the noise,
	Sven

[1] https://github.com/nbd168/wireless/commit/3d63b5084c50607fff84d17d2727c3bab8190d8e

--nextPart880480923.0ifERbkFSE
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part.
Content-Transfer-Encoding: 7Bit

-----BEGIN PGP SIGNATURE-----

iHUEABYKAB0WIQS81G/PswftH/OW8cVND3cr0xT1ywUCaPYBPQAKCRBND3cr0xT1
y4ebAQCwb9tDygtnPh36+fO93hSzJLDBcmb2cPfpL0IU63CHWAD/VAvazvuQmmS1
TBo61BmhKvF9W99jw9t2dIur+vxrSA0=
=hC3z
-----END PGP SIGNATURE-----

--nextPart880480923.0ifERbkFSE--



