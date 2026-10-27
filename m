Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=95.215.58.21
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793095208;
	b=aX/i7BQJCyIFUSb8dSi++zKI91AObNyWNdag8s0uE84YlYDe4X1fdI2YB4SxY+9ApNN6
	 hv2jNp8ORBoy+d4GZXR6yAGfrP4D+yluQOw9svsyLhvXn7eBMGbVx3Py2mGSks8wKeHj7
	 JXO5yaXcAW7qOGXR4Gw1NswbWnTIf3FBu3ew6QHleZeo7xzF/Le2Vm/Fbu/dmGunb8LF5
	 1tEcMo4S4Ze4XKNPf5wMr2oBUZ/OzT0lRM1rz36SX9EKDkmJSEe2a5Bcxl+sYc9oRosNk
	 7Km49WAEuGxSvBABmLKvBGt6NEelmGuH3cYiN4YcuARmdJqPdJwudIfU68pCd/GthVw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793095208;
	h=DMARC-Filter:X-Envelope-To:DKIM-Signature:X-Envelope-To:Received:
	 X-Mizu-Trace-ID:X-Migadu-Flow:MIME-Version:Date:Content-Type:
	 Content-Transfer-Encoding:From:Message-ID:TLS-Required:Subject:To:Cc:
	 In-Reply-To:References;
	bh=1HZaLJ3VfsBWwsUyLeKxbYeCIChpATR+0fJLCQMpzUA=;
	b=iIVdqPto4qqbP1bZuKaRMknoCAIr6ADmAlwu7oUeYKnKvQq4XaNbWMK+8wmHRgkasZtp
	 438dubFlXjvey77cZqiTubfFjSmiUplu5QO/b8yFDdgRrHFkS/owVLGZmWNet+WdvHbrn
	 MFpMqhW9HVc9afGwSTRRrUHNihHUV66uN0Kguzi355mXKW8B28dBIm8Ns8x1g2h4a8mzQ
	 VzEOoW7U+njH4fK3uxAZPubqaluPMpD05kf4d5vFsMFR3SFKH4ubxxtbBq6I8m11P1szF
	 njU6xKMQTE1R/lSuzfyYbcWno/jEmsH9V+ax3wq6YoTL1wXGkaponLUL3S1bvXMoLOg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=linux.dev;
	spf=pass smtp.mailfrom=linux.dev;
	dkim=pass header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=ZpcvD69n;
	arc=none smtp.remote-ip=95.215.58.21
Received: from mta1.migadu.com (out-21.mta1.migadu.com [95.215.58.21])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5B3FA606A31F
	for <linux-wireless@vger.kernel.org>; Tue, 27 Oct 2026 10:00:07 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 5B3FA606A31F
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=ZpcvD69n
X-Envelope-To: linux-wireless@vger.kernel.org
DKIM-Signature: a=rsa-sha256; bh=1HZaLJ3VfsBWwsUyLeKxbYeCIChpATR+0fJLCQMpzUA=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1793095205; v=1; x=1793700005;
 b=ZpcvD69nPhDa02ikOH6RWOyLKnYHPEOo+fRsZ5MI+GZHe//C+IYQh3WQyDxgwDxZbRWe/bve
 Or6p91J+rzW4xmS93MkBpSeWRTaosstIOwPBY7wSBJHY1HmovB8aNepDQ2WtcPMLrRd+v8QCBtW
 FYo8nsA+zDWUgnfLkc5StJ/k=
X-Envelope-To: linux-wireless@vger.kernel.org
Received: by smtp.migadu.com with ESMTPS id 71614f61cabf8515;
	Tue, 27 Oct 2026 10:00:04 +0000
X-Mizu-Trace-ID: 71614f61cabf8515
X-Migadu-Flow: FLOW_OUT
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Post: <mailto:linux-wireless@vger.kernel.org>
List-Help: <mailto:linux-wireless+help@vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-wireless+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Date: Tue, 27 Oct 2026 10:00:04 +0000
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: quoted-printable
From: "Luka Gejak" <luka.gejak@linux.dev>
Message-ID: <cf94eda9237629a07b9d5064870d71fe417d5483@linux.dev>
TLS-Required: No
Subject: Re: [PATCH ath-current] wifi: ath9k_htc: clear csa_vif when a switch
 is aborted
To: "Mehmet Fide" <mehmet.fide@gmail.com>,
 "=?utf-8?B?VG9rZSBIw7hpbGFuZC1Kw7hyZ2Vuc2Vu?=" <toke@toke.dk>
Cc: "Johannes Berg" <johannes@sipsolutions.net>,
 linux-wireless@vger.kernel.org, linux-kernel@vger.kernel.org,
 mehmet.fide@screeningeagle.com
In-Reply-To: <20261026152537.1272836-1-mehmet.fide@gmail.com>
References: <20261026152537.1272836-1-mehmet.fide@gmail.com>

October 26, 2026 at 4:25 PM, "Mehmet Fide" <mehmet.fide@gmail.com> wrote:


>=20
>=20From: Mehmet Fide <mehmet.fide@screeningeagle.com>
>=20
>=20priv->csa_vif is cleared only when the countdown completes or the
> interface is removed. When mac80211 aborts a switch and stops
> beaconing, as ieee80211_stop_ap() and ieee80211_stop_mesh() do, it
> stays set, and the next switch on the interface hits the WARN_ON() in
> ath9k_htc_channel_switch_beacon().
>=20
>=20Clear it when beaconing stops and the switch is no longer active.
> Off channel, beaconing stops with the switch still active and the
> countdown continues afterwards, so keep it then.
>=20
>=20Fixes: f0e449627e4a ("ath9k_htc: add support of channel switch")
> Reported-by: Luka Gejak <luka.gejak@linux.dev>
> Closes: https://lore.kernel.org/linux-wireless/c8bc5affa75d7519b424ea98=
c07c1d6b65942347@linux.dev/
> Signed-off-by: Mehmet Fide <mehmet.fide@screeningeagle.com>
> ---

Not an expert on ath family but, to my knowledge this is good.

Reviewed-by: Luka Gejak <luka.gejak@linux.dev>

Best regards,
Luka Gejak
