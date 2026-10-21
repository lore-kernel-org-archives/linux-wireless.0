Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=95.215.58.115
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792556340;
	b=cAkjj7DC6QoKd8b91Tn72LK0uKwdXxpNSXm6/j8FiQSLPgMjM1Nuk/8d5ijGsp1W1cmP
	 cDw4CQYDUWT1/pT9IhOhca8gTTmQYChufxeDsIlegOjoK6jGnrTV/pGmaEasCsZZHN3ds
	 dCw30Fj6znF4j0GoXsOX6f2kYklSjt4Bxi31TQVXPe0CH8QZR4SDDZW8nAA70hyK/6oqv
	 EXofVuHrzMrjjAzMzvq7S+oPX2p1kMr3ySOyaHeVk1fwrxbZlU35Yj5cN1lxhcjbLsgCe
	 tH6Zux5a6yss48YHjXdf879K+A5ZDww8zv/PhxEOXDat2bgX3DtzmR0WSFTW9+LoJzQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792556340;
	h=DMARC-Filter:X-Envelope-To:DKIM-Signature:X-Envelope-To:Received:
	 X-Mizu-Trace-ID:X-Migadu-Flow:MIME-Version:Date:Content-Type:
	 Content-Transfer-Encoding:From:Message-ID:TLS-Required:Subject:To:Cc:
	 In-Reply-To:References;
	bh=k3gRok5LleEF2yD/HwWADu78npxb1vP3eyLcOQu44Sk=;
	b=YmYj59/ovXXzDd8iQLlbqA2kQqhfczJlRceQ/bYf5LNxdTRyGR13c08DZy16zxhWwWV8
	 h4ttUJa2+eyo96GChJoBi/elXH3bu32nAZzPjdeFDrJ8m422IVOTL/1x18yJYS0rq5qSw
	 lFcU8xGkHg/Kt7RoErdfVRVU5w7qZBUC6P5bQyjyJ4IOc50L9k5jrHxOH7LhtVtA9KpkQ
	 aPXSYVSiGbejwxA0SfkJVsiz0SLpnp+qwZRksAa0GiML6ia/i6aX4WR23rSTm9uS/hx7L
	 k8fuZKW5AEGWCJ4kR3gG1MQoTVDozkNve6Sh34K19PMjpioWcIC9buj28oKHAjs1Lbw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=linux.dev;
	spf=pass smtp.mailfrom=linux.dev;
	dkim=pass header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=hg7XcCPw;
	arc=none smtp.remote-ip=95.215.58.115
Received: from mta1.migadu.com (out-115.mta1.migadu.com [95.215.58.115])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E54E8606A319
	for <linux-wireless@vger.kernel.org>; Wed, 21 Oct 2026 04:18:58 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org E54E8606A319
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=hg7XcCPw
X-Envelope-To: linux-wireless@vger.kernel.org
DKIM-Signature: a=rsa-sha256; bh=xn4Zg5bRsa3gGRycSm2LyjdhcHwBqAQNETHDH1kr8cU=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1792556336; v=1; x=1793161136;
 b=hg7XcCPwUafClbDNopta63pW8PoBvhDUBClda9+fbxZ/BP3yhMzdu4RYztg4OSS9es4Qp+4+
 xoM7Za0j4IiWEYzpf0WA7Bk/MSMqW2kIPFvPtzh970P5sbmhKyTxkjH2sYz3wH3DQ8IcJxQ1CU0
 UAx/aRbdjEzXtqmK5YOlmyHg=
X-Envelope-To: linux-wireless@vger.kernel.org
Received: by smtp.migadu.com with ESMTPS id c7da5271c5476c1f;
	Wed, 21 Oct 2026 04:18:56 +0000
X-Mizu-Trace-ID: c7da5271c5476c1f
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
Date: Wed, 21 Oct 2026 04:18:53 +0000
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: quoted-printable
From: "Luka Gejak" <luka.gejak@linux.dev>
Message-ID: <8a1729fff0ea514f9e0acdecf08543c09374856d@linux.dev>
TLS-Required: No
Subject: Re: [PATCH rtw-next] wifi: rtw88: 8723b: always report a single
 spatial stream
To: "Ping-Ke Shih" <pkshih@realtek.com>
Cc: linux-wireless@vger.kernel.org
In-Reply-To: <c07aa592e1154c43a3def7c57fd8488e@realtek.com>
References: <20261020222009.9116-1-luka.gejak@linux.dev>
 <c07aa592e1154c43a3def7c57fd8488e@realtek.com>

October 21, 2026 at 5:51 AM, "Ping-Ke Shih" <pkshih@realtek.com> wrote:


>=20
>=20Luka Gejak <luka.gejak@linux.dev> wrote:
>=20
>=20>=20
>=20> RTL8723B only ever has one spatial stream. Set nss and ant_num to 1
> >  directly instead of deriving them from rf_path_num, which just happe=
ns
> >  to be 1 on this chip.
> >=20=20
>=20>  Signed-off-by: Luka Gejak <luka.gejak@linux.dev>
> >=20
>=20Acked-by: Ping-Ke Shih <pkshih@realtek.com>
>=20
>=20>=20
>=20> ---
> >  drivers/net/wireless/realtek/rtw88/rtw8723b.c | 9 +++------
> >  1 file changed, 3 insertions(+), 6 deletions(-)
> >=20=20
>=20>  diff --git a/drivers/net/wireless/realtek/rtw88/rtw8723b.c
> >  b/drivers/net/wireless/realtek/rtw88/rtw8723b.c
> >  index 8bb9c03d769c..89190dd4f5c7 100644
> >  --- a/drivers/net/wireless/realtek/rtw88/rtw8723b.c
> >  +++ b/drivers/net/wireless/realtek/rtw88/rtw8723b.c
> >  @@ -2365,12 +2365,9 @@ static int rtw8723b_read_efuse(struct rtw_dev=
 *rtwdev, u8 *log_map)
> >  if (efuse->power_track_type !=3D 0)
> >  rtw_warn(rtwdev, "unsupported power track type\n");
> >=20=20
>=20>  - /*
> >  - * No firmware hardware feature report exists, so fill the hardware
> >  - * capability here; a zero stream count kills the HT MCS set.
> >  - */
> >  - efuse->hw_cap.nss =3D max_t(u8, rtwdev->hal.rf_path_num, 1);
> >  - efuse->hw_cap.ant_num =3D efuse->hw_cap.nss;
> >=20
>=20Curiously, is there real hardware encountered the problem?
>=20

No,=20but Bitterblue pointed out it's unnecessary code.

> >=20
>=20> + /* No firmware hardware feature report exists, so fill it in here=
. */
> >  + efuse->hw_cap.nss =3D 1;
> >  + efuse->hw_cap.ant_num =3D 1;
> >  efuse->hw_cap.bw =3D BIT(RTW_CHANNEL_WIDTH_20) |
> >  BIT(RTW_CHANNEL_WIDTH_40);
> >=20=20
>=20>  --
> >  2.53.0
> >
>
