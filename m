Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=95.215.58.103
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793095283;
	b=xVsvWaOi8vHqjAHzxM/imbO0t410BrIywKI+c7jferx0FRyPj6rI7oFe1tdXiWYkR5X+
	 MjJGh6bEwfY9krpNAm9pHwUOTmebQw7AjJQoQlMHJw/qwTYbBjG+AY6MIWLMeP2GGpATp
	 PfulG0MtM0IwM4R5V7+ZPwZ998TIK2GvErUx3I2oM3f2TEDnGzDhIM1dYzwyYWaec3YIo
	 GK67riyLbKUczH4GYzSFvpVHf/H5HwXlb2QbrcDL1u1NUE/KIex2JYYDVCTgJJEeIVUfR
	 zMuKz3UhuP2MpOR8pau9oUu7IC4P318/E9uYtpv1qINTnyjSsxWpUJrtAzlk9Zj0Jjg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793095283;
	h=DMARC-Filter:X-Envelope-To:DKIM-Signature:X-Envelope-To:Received:
	 X-Mizu-Trace-ID:X-Migadu-Flow:MIME-Version:Date:Content-Type:
	 Content-Transfer-Encoding:From:Message-ID:TLS-Required:Subject:To:Cc:
	 In-Reply-To:References;
	bh=L+gSpaQUQPt7P5ywYyn2q+jrj5cBWW+lBXUYhbSdfvo=;
	b=CuMawNfbgKEpbQ0CfrDRhM2XUqV8OOlYm6XlmXJB07ptCmko4ZLFuFrEdGuZek4Ad7ax
	 8rd79O2scUYg1iHq9YVHlwIKs4rHDcZDdhqpbq+n4AJxz3LyUlfdVNFUCcUsAHox+O5qb
	 c4Nuh8boiGXVYxwj1NcF2hbrLezpBQ/yfvhlhjzeFZ0yqDg4CYk2Mck4k0hRVnh/zjFnS
	 eGV81LJIu09WxupKZKRVvNRWrvSVZIZrDtskoOyJRwn3nBjb30NVHbw7hI9sxfbpQt9a9
	 88iTle/OSJjnq46ptfdUn6HgAJNlomkVIrM69SER4z6IsCLnpshlqifJhfTL3SYD/+g==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=linux.dev;
	spf=pass smtp.mailfrom=linux.dev;
	dkim=pass header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=rdiS49OP;
	arc=none smtp.remote-ip=95.215.58.103
Received: from mta1.migadu.com (out-103.mta1.migadu.com [95.215.58.103])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2D0DC606A31B
	for <linux-wireless@vger.kernel.org>; Tue, 27 Oct 2026 10:01:21 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 2D0DC606A31B
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=rdiS49OP
X-Envelope-To: linux-wireless@vger.kernel.org
DKIM-Signature: a=rsa-sha256; bh=0cM0mfrta2wbBP3arklI3bzBS+q6bMYED+sSee7wFis=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1793095280; v=1; x=1793700080;
 b=rdiS49OPxH+ER7Nfn1HSUDjk51CifKZYcuNZqOeCdwHssIavSy43pSYc63qFmh/NUUELy8ct
 LGslXsNp3gbINh0X7lBv8DxDGcPc1Um27FMrHI5fp6MOiawyYG1AIpDYsm48vhh27dmxbLLCH2X
 AI3fK3j3FX5fNlgzxDyBqNfc=
X-Envelope-To: linux-wireless@vger.kernel.org
Received: by smtp.migadu.com with ESMTPS id 8db34f6421d02374;
	Tue, 27 Oct 2026 10:01:20 +0000
X-Mizu-Trace-ID: 8db34f6421d02374
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
Date: Tue, 27 Oct 2026 10:01:19 +0000
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: quoted-printable
From: "Luka Gejak" <luka.gejak@linux.dev>
Message-ID: <5c3f973b90b90271771f6deaa8748f8ece50b370@linux.dev>
TLS-Required: No
Subject: Re: [PATCH wireless] wifi: mac80211: abort chanswitch when leaving
 an IBSS
To: "Mehmet Fide" <mehmet.fide@gmail.com>
Cc: "Johannes Berg" <johannes@sipsolutions.net>,
 "=?utf-8?B?VG9rZSBIw7hpbGFuZC1Kw7hyZ2Vuc2Vu?=" <toke@toke.dk>,
 linux-wireless@vger.kernel.org, linux-kernel@vger.kernel.org,
 mehmet.fide@screeningeagle.com
In-Reply-To: <20261026152543.1272978-1-mehmet.fide@gmail.com>
References: <20261026152543.1272978-1-mehmet.fide@gmail.com>

October 26, 2026 at 4:25 PM, "Mehmet Fide" <mehmet.fide@gmail.com> wrote:


>=20
>=20Hi Luka,
>=20
>=20>=20
>=20> So if I read it right, after leaving mid countdown and joining agai=
n, the
> >  next switch with a countdown now gets past mac80211 and runs into th=
is in
> >  ath9k_htc_channel_switch_beacon():
> >=20
>=20You read it right, I reproduced it on an AR9271 with this patch. A me=
sh
> point hits the same WARN already without it, since ieee80211_stop_mesh(=
)
> aborts the switch the same way.
>=20
>=20Dropping csa_vif whenever beaconing stops is too much though: off
> channel, e.g. a scan during the countdown, beaconing stops with the
> switch still active, and the switch then never completes. So the fix
> drops it only when the switch is no longer active, sent as "wifi:
> ath9k_htc: clear csa_vif when a switch is aborted". This patch should
> go in with or after that one.
>=20
>=20Mehmet
>

Thanks for sending the patch, for this one:

Reviewed-by: Luka Gejak <luka.gejak@linux.dev>

Best regards,
Luka Gejak
