Received: from dvalin.narfation.org (dvalin.narfation.org [213.160.73.56])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3D48F3624C7
	for <linux-wireless@vger.kernel.org>; Mon,  9 Feb 2026 09:17:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.160.73.56
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770628635; cv=none; b=mWv85AZjHWU3yVUV7CN6CWBw3kEbbTwwGauFBkcyVQFiTv7PK9moRmuD2fRf2e8rP/lK0RJqRkZvcyp0GStYURSq+nBrBKK0AHCbbh5ALsAjdakYQFB04tVDBrnXi644kEEv+JwgIXNJm5NiAg5o85ouQU0Teg7LgarD2MyJ0Pc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770628635; c=relaxed/simple;
	bh=K0E9osJpZYXRt5Wk0KibdvPph+aO07mx3fwhjQLwpvA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=QugJ380HDfImcgVqoU88hPfkVKl/QHcYTWmP1rtJiw/qlnkU3XKVxKQg3+o2YVJzlUZGcHaT/jRQ4Ep78NBJuHbkiGdQ/+I9nNgaNj55SBCzS63OZQcdfStkc445JN02enzm9IfJDem6IlH5uv0Y0g2YyqpRX/RCRtsbHjkoICQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=narfation.org; spf=pass smtp.mailfrom=narfation.org; dkim=pass (1024-bit key) header.d=narfation.org header.i=@narfation.org header.b=Pc8K8le2; arc=none smtp.client-ip=213.160.73.56
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=narfation.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=narfation.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=narfation.org header.i=@narfation.org header.b="Pc8K8le2"
Received: by dvalin.narfation.org (Postfix) id 7B52F21722;
	Mon, 09 Feb 2026 09:17:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=narfation.org;
	s=20121; t=1770628627;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=9ISR/mfVT+xDv1tvxnsCEeFByJ832c8OhCJ5RCB0HqM=;
	b=Pc8K8le2y3fVQxXWukrh6DaIZQ/AGYP+41/QZ3tu405GjjcUnGn1/FIC8xIzbOXqo4SH2B
	OsbXRLyg2e+BJVa0UhUF9hGm1Jjy+g9C+J49mEFL0eoUhqvvP/TfGy/I9T5n32iNOCwT5O
	wlNDNrcvn9sm9n3pokzdFb1bAFHFniE=
From: Sven Eckelmann <sven@narfation.org>
To: "robh@kernel.org" <robh@kernel.org>, Ryder Lee <Ryder.Lee@mediatek.com>
Cc: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
 "nbd@nbd.name" <nbd@nbd.name>,
 "linux-mediatek@lists.infradead.org" <linux-mediatek@lists.infradead.org>,
 Allen Ye =?UTF-8?B?KOiRieiKt+WLsyk=?= <Allen.Ye@mediatek.com>,
 "saravanak@kernel.org" <saravanak@kernel.org>
Subject:
 Re: [PATCH v2] wifi: mt76: fix backoff fields and max_power calculation
Date: Mon, 09 Feb 2026 10:17:03 +0100
Message-ID: <4713788.LvFx2qVVIh@ripper>
In-Reply-To: <278546e3f3e526288d245111d8e022b2d68d012e.camel@mediatek.com>
References:
 <54627282cfb8e5a89fe753da66552c0a084f6387.1769557863.git.ryder.lee@mediatek.com>
 <7906220.EvYhyI6sBW@ripper>
 <278546e3f3e526288d245111d8e022b2d68d012e.camel@mediatek.com>
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="nextPart2400649.ElGaqSPkdT";
 micalg="pgp-sha512"; protocol="application/pgp-signature"

--nextPart2400649.ElGaqSPkdT
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"; protected-headers="v1"
From: Sven Eckelmann <sven@narfation.org>
Date: Mon, 09 Feb 2026 10:17:03 +0100
Message-ID: <4713788.LvFx2qVVIh@ripper>
MIME-Version: 1.0

On Monday, 9 February 2026 08:48:50 CET Ryder Lee wrote:
> - In connac2, beamforming entries for BW20~BW160 and OFDM do not
> include 1T1ss.
> - In connac3, beamforming entries for BW20~BW160 and RU include 1T1ss,
> but OFDM beamforming does not include 1T1ss.

This doesn't seem to match the documentation [1]:

                  paths-ofdm-bf:
                    $ref: /schemas/types.yaml#/definitions/uint8-array
                    minItems: 4
                    maxItems: 4
                    description:
                      4 half-dBm backoff values for beamforming
                      (1 - 4 antennas, single spacial stream)
...
                  paths-ru-bf:
                    $ref: /schemas/types.yaml#/definitions/uint8-matrix
                    description:
                      Sets of half-dBm backoff (beamforming) values for 802.11ax
                      rates for 1T1ss (aka 1 transmitting antenna with 1 spacial
                      stream), 2T1ss, 3T1ss, 4T1ss, 2T2ss, 3T2ss, 4T2ss, 3T3ss,
                      4T3ss and 4T4ss.
                      Each set starts with the number of channel bandwidth or
                      resource unit settings for which the rate set applies,
                      followed by 10 power limit values. The order of the
                      channel resource unit settings is RU26, RU52, RU106,
                      RU242/SU20, RU484/SU40, RU996/SU80 and RU2x996/SU160.
                    minItems: 1
                    maxItems: 7
                    items:
                      minItems: 11
                      maxItems: 11

Regards,
	Sven
	
[1] https://www.kernel.org/doc/Documentation/devicetree/bindings/net/wireless/mediatek%2Cmt76.yaml
--nextPart2400649.ElGaqSPkdT
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part.
Content-Transfer-Encoding: 7Bit

-----BEGIN PGP SIGNATURE-----

iHUEABYKAB0WIQS81G/PswftH/OW8cVND3cr0xT1ywUCaYmmDwAKCRBND3cr0xT1
y0eTAP4x/wnJjrsntSDQSErh9wdbbDbTV2Us/Y9H167xWGX0lQEAixfhJF2XsZ7O
EqIwD6otwncazjb4ckPtxspWy4wzKAw=
=7NbR
-----END PGP SIGNATURE-----

--nextPart2400649.ElGaqSPkdT--



