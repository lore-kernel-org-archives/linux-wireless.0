Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=211.75.126.72
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792554693;
	b=f0m4keDy1yRt/R5KPk3WtgOTrKrpF5qLL+arW+qpeqFuxZBEkBh2LFYITuLtwMnpgmZV
	 W+vRiRvlseuUEXt60ToIb8CDLgLF+3q7EYVcZc9SMD7OnB9ZPSyiyTi3G6PTC2s4t/0Il
	 uq7ggizW+z3MWDSQ54GpApTYM0JYpSsy1GquxwNkKbFSnAGLAuI9P2dumerSDPzMA53Gc
	 fs+RU2/D4u4NVLAHDJlQq+2hZD+oDJ6/0i0NoBv3KeNjC/VoYBJuFBToTLuwDaJZCJqnG
	 ELna7RRxeDqshfj3ILKNAvm++B+J6SFotPwtaAAqpuTySyLIN9b26iysfpQ3bkcZROg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792554693;
	h=DMARC-Filter:X-SpamFilter-By:DKIM-Signature:Received:Received:
	 Received:From:To:CC:Subject:Thread-Topic:Thread-Index:Date:Message-ID:
	 References:In-Reply-To:Accept-Language:Content-Language:
	 x-originating-ip:Content-Type:Content-Transfer-Encoding:MIME-Version;
	bh=5uW3szOcQZU8Y2E45JM8I/WfskyOf65JktlnF850cVg=;
	b=PU19er9f/vywLjWed6PW8vWd6r73X6DFL9cp4rnCOQqKOXuzvhavZGK5N8r9l9oQdxia
	 S74M7N+e5Zk6mGm2aa3llUjL2vBXGh34bp/HiAR2rzYFTCROh9zacapUL1NL5Bzlf+rCX
	 6cCXGo/TmItgQIjrl2rT+/+AjBp7/jMKwzSC6Xb/+3Ohhl+B6SeuzfmWc5C9D6bqp/8xs
	 qVDv3tXlK6Lx5xJ1JwXHMw/dAEdQAUVitHnqlarc1sKIntBb2U1+T5QxUvCRDfoOrO2w3
	 QXKxsdc/px934FbHiBLY467kiOxS50/PtRERtYzHfq9aW1E6EErr4+zj4nziXKXPxBg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=realtek.com;
	spf=pass smtp.mailfrom=realtek.com;
	dkim=pass header.d=realtek.com header.i=@realtek.com header.a=rsa-sha256 header.s=dkim header.b=MKnmVrj6;
	arc=none smtp.remote-ip=211.75.126.72
Received: from rtits2.realtek.com.tw (rtits2.realtek.com [211.75.126.72])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C25D2606A31A
	for <linux-wireless@vger.kernel.org>; Wed, 21 Oct 2026 03:51:32 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org C25D2606A31A
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=realtek.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=realtek.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=realtek.com header.i=@realtek.com header.a=rsa-sha256 header.s=dkim header.b=MKnmVrj6
X-SpamFilter-By: ArmorX SpamTrap 5.80 with qID 69L3pOiT53672246, This message is accepted by code: ctloc85258
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=realtek.com; s=dkim;
	t=1792554684; bh=5uW3szOcQZU8Y2E45JM8I/WfskyOf65JktlnF850cVg=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:Content-Transfer-Encoding:MIME-Version;
	b=MKnmVrj6CQMk5XSMQqfiy+Gdnk3Tnebi+4bWM3uM4tc3vuC//wjFcxqwlRTeYZ9E+
	 qBSNmiyV/KtHdqGtbPyiKzuL0JBrgAawwp2/RFgjhTu9PwDgVBbqw907E5o17/lxw9
	 dUm8GPJ9GbcVH31IwAIedqInZWhtJUY1YvOUZY92pUiLjwEIPD2wC3TPbdoGiuGGo5
	 +kY59lpOqYNqF7V/mprDlb/5lb0UNiyJGsxNYq8mAd6N+jtzhdmZO0W6RxLUE/W/yL
	 jqHP/8j8xkFMlKlkh5ogcq5d9stENtpJ+8Yaa6RmtTz1/nSbB7Y/b04BvkKLlDo8fI
	 i/CdR4sj98z7A==
Received: from mail.realtek.com (rtkexhmbs04.realtek.com.tw[10.21.1.54])
	by rtits2.realtek.com.tw (8.15.2/3.29/5.94) with ESMTPS id 69L3pOiT53672246
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
	Wed, 21 Oct 2026 11:51:24 +0800
Received: from RTKEXHMBS06.realtek.com.tw (10.21.1.56) by
 RTKEXHMBS04.realtek.com.tw (10.21.1.54) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.49; Wed, 21 Oct 2026 11:51:25 +0800
Received: from RTKEXHMBS06.realtek.com.tw ([::1]) by
 RTKEXHMBS06.realtek.com.tw ([fe80::b3cc:c263:b82d:e87c%10]) with mapi id
 15.02.2562.049; Wed, 21 Oct 2026 11:51:25 +0800
From: Ping-Ke Shih <pkshih@realtek.com>
To: Luka Gejak <luka.gejak@linux.dev>
CC: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: RE: [PATCH rtw-next] wifi: rtw88: 8723b: always report a single
 spatial stream
Thread-Topic: [PATCH rtw-next] wifi: rtw88: 8723b: always report a single
 spatial stream
Thread-Index: AQHdYOE6U0wnZFps6U6ZMXQhBWc/JbcHXJvw
Date: Wed, 21 Oct 2026 03:51:25 +0000
Message-ID: <c07aa592e1154c43a3def7c57fd8488e@realtek.com>
References: <20261020222009.9116-1-luka.gejak@linux.dev>
In-Reply-To: <20261020222009.9116-1-luka.gejak@linux.dev>
Accept-Language: en-US, zh-TW
Content-Language: zh-TW
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Post: <mailto:linux-wireless@vger.kernel.org>
List-Help: <mailto:linux-wireless+help@vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-wireless+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0

Luka Gejak <luka.gejak@linux.dev> wrote:
> RTL8723B only ever has one spatial stream. Set nss and ant_num to 1
> directly instead of deriving them from rf_path_num, which just happens
> to be 1 on this chip.
>=20
> Signed-off-by: Luka Gejak <luka.gejak@linux.dev>

Acked-by: Ping-Ke Shih <pkshih@realtek.com>


> ---
>  drivers/net/wireless/realtek/rtw88/rtw8723b.c | 9 +++------
>  1 file changed, 3 insertions(+), 6 deletions(-)
>=20
> diff --git a/drivers/net/wireless/realtek/rtw88/rtw8723b.c
> b/drivers/net/wireless/realtek/rtw88/rtw8723b.c
> index 8bb9c03d769c..89190dd4f5c7 100644
> --- a/drivers/net/wireless/realtek/rtw88/rtw8723b.c
> +++ b/drivers/net/wireless/realtek/rtw88/rtw8723b.c
> @@ -2365,12 +2365,9 @@ static int rtw8723b_read_efuse(struct rtw_dev *rtw=
dev, u8 *log_map)
>         if (efuse->power_track_type !=3D 0)
>                 rtw_warn(rtwdev, "unsupported power track type\n");
>=20
> -       /*
> -        * No firmware hardware feature report exists, so fill the hardwa=
re
> -        * capability here; a zero stream count kills the HT MCS set.
> -        */
> -       efuse->hw_cap.nss =3D max_t(u8, rtwdev->hal.rf_path_num, 1);
> -       efuse->hw_cap.ant_num =3D efuse->hw_cap.nss;

Curiously, is there real hardware encountered the problem?

> +       /* No firmware hardware feature report exists, so fill it in here=
. */
> +       efuse->hw_cap.nss =3D 1;
> +       efuse->hw_cap.ant_num =3D 1;
>         efuse->hw_cap.bw =3D BIT(RTW_CHANNEL_WIDTH_20) |
>                            BIT(RTW_CHANNEL_WIDTH_40);
>=20
> --
> 2.53.0

