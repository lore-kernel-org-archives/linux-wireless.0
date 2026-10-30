Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=95.215.58.248
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793388778;
	b=px79rjvt0al2cbbxCbnCXT9FhnpmSqjzYNE8Y6vnHp43t4GUJmJP3P4Om8BpEhaHa3jT
	 ytvLMl0k0WO+Amnx2j+ZsbTyjucMjCZXParXeC3n5IbxQv+tdn4wjQ9InrNTeEA2NauY4
	 bqBwdYl23fxXyryx3m5uRbFrOCL8L7gweqC/BLawrydtx9L9FClT1cq8KiBv++wsUjfO8
	 r+lZ3jHCsVEQZAdxQOsKNpMidO0CYsdFYjpqvIg7Ksp1hVl0o2PZSrl20k5b2EllNlB+I
	 6spsDNLDNSP+XPgSRpICZl1h7Mu5/hiJbaED+D6zjTW23IrWL4Dcijbt0Ix/6dWRpbg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793388778;
	h=DMARC-Filter:X-Envelope-To:DKIM-Signature:X-Envelope-To:Received:
	 X-Mizu-Trace-ID:X-Migadu-Flow:MIME-Version:Date:Content-Type:
	 Content-Transfer-Encoding:From:Message-ID:TLS-Required:Subject:To:Cc:
	 In-Reply-To:References;
	bh=YS+grbdduDJikrXIuugP6G07Jny6hR3fuIP7acPZrdA=;
	b=0erIpCNWaSsrieGoxsAnDRe5D4/ZzgPLnb+iZSUDUAq3E4Gao5HWMZqPJUbG4m6abru8
	 pDZNYAwK8zocTcwyCQS+cMbhTGRW8N+gf++wPO6favryAnaacr3XKGU8y6ocMm0HEtJbV
	 p0FSBvVTIXZdOX3B6hqXGFMeOGpocMsMM92a0l5QTYAtku/ITacd76Z2gOrDSXqI5f3ox
	 6T6ycXq2EpUv1sFoLDw9OaeewDu72QVOfurU1rJyXH62FaZz7fTkLpSe23Vl3DqSVi2bm
	 MDfQFrWcB40f0BDPno+7zR3G2Xg2fpJSo9EdObgBBCF2+XF+ShBaW9gQb9xICdq+5dw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=linux.dev;
	spf=pass smtp.mailfrom=linux.dev;
	dkim=pass header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=E2DYeszn;
	arc=none smtp.remote-ip=95.215.58.248
Received: from mta1.migadu.com (out-248.mta1.migadu.com [95.215.58.248])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F22D160A2606
	for <linux-wireless@vger.kernel.org>; Fri, 30 Oct 2026 19:32:55 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org F22D160A2606
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=E2DYeszn
X-Envelope-To: linux-wireless@vger.kernel.org
DKIM-Signature: a=rsa-sha256; bh=YS+grbdduDJikrXIuugP6G07Jny6hR3fuIP7acPZrdA=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1793388773; v=1; x=1793993573;
 b=E2DYesznKOThTyfgNTzmdgW5SQeshz2mPG4Pn6n9+ZVIa6GngmCNRfvy2kz00s5iOrpvMNNa
 mWJACVkx2R8nnOjkBKslHNud8Zbv2smpYWY32iEocyRbsYW5X2QrGkOnk5Hahd8Yzwzljd37dmH
 1v4XaCgGwcLLRfy5kvjKlTvw=
X-Envelope-To: linux-wireless@vger.kernel.org
Received: by smtp.migadu.com with ESMTPS id 2266e724e659835c;
	Fri, 30 Oct 2026 19:32:53 +0000
X-Mizu-Trace-ID: 2266e724e659835c
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
Date: Fri, 30 Oct 2026 19:32:49 +0000
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: quoted-printable
From: "Luka Gejak" <luka.gejak@linux.dev>
Message-ID: <bfef11e436435bc10bd398897adbc15518969e2d@linux.dev>
TLS-Required: No
Subject: Re: [PATCH rtw-next v3] wifi: rtw88: usb: don't report the
 aggregation buffer as a frame
To: "Ho Jie Feng" <hjf3108@gmail.com>, "Ping-Ke Shih" <pkshih@realtek.com>
Cc: linux-wireless@vger.kernel.org, "Ho Jie Feng" <hjf3108@gmail.com>, "Kalle
 Valo" <kvalo@kernel.org>, "neo_jou" <neo_jou@realtek.com>, "Hans Ulli
 Kroll" <linux@ulli-kroll.de>, "Sascha Hauer" <s.hauer@pengutronix.de>,
 linux-kernel@vger.kernel.org
In-Reply-To: <20261030165451.365591-1-hjf3108@gmail.com>
References: <20261030165451.365591-1-hjf3108@gmail.com>

October 30, 2026 at 5:54 PM, "Ho Jie Feng" <hjf3108@gmail.com> wrote:

>=20
>=20When rtw_usb_tx_agg_skb() has more than one frame queued, it copies t=
hem
> into a new buffer. That buffer was also handed to mac80211, as one
> additional TX completion.
>=20
>=20Report TX status only for the original frames, and free the aggregate
> buffer without passing it to mac80211.
>=20
>=20Fixes: a82dfd33d123 ("wifi: rtw88: Add common USB chip support")
> Signed-off-by: Ho Jie Feng <hjf3108@gmail.com>
> ---

Looks good to me,

Reviewed-by: Luka Gejak <luka.gejak@linux.dev>

Best regards,
Luka Gejak
