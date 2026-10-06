Received: from rtits2.realtek.com.tw (rtits2.realtek.com [211.75.126.72])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 496DF1F63D9;
	Tue,  6 Oct 2026 02:09:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=211.75.126.72
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791252558; cv=none; b=YhKMGfm61ovotBLOsbZrBOyOPR33hbF9rarw8OV3dj9Gkat6K6+GqYbGGIcFqbdzkLYKvBALIL7KW5q5v+THfBFCpnLtMDB40BZNlygzSdGjXYNEM50jcpQf5Sf7UMJOf5urhaDZgmdLW1SEMTgxrBXbN+7tQ8DTIOoL5yvZHGw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791252558; c=relaxed/simple;
	bh=3ottqOmBN4Wo+w1BMDfmgqHHuzS4Su0pmGlPhwkuOyQ=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=cLyH+MWuDLmS3N6ZlwIKJ0OtRQaEMJqMnro7bdj4700/CUEvy4wzaW4GgWTbBP8pv+St6KOc3MBbLO/DziRgtNUIJXIJHLq6iIl9BoizV5M2CfclCyNM+orrDbg2PVOdNH65UEZ+6P8it+kuKkn+JKDL9+qDfT/pv82MHJT3+H4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=realtek.com; spf=pass smtp.mailfrom=realtek.com; dkim=pass (2048-bit key) header.d=realtek.com header.i=@realtek.com header.b=AiXUowHs; arc=none smtp.client-ip=211.75.126.72
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=realtek.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=realtek.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=realtek.com header.i=@realtek.com header.b="AiXUowHs"
X-SpamFilter-By: ArmorX SpamTrap 5.80 with qID 69628o7322462138, This message is accepted by code: ctloc85258
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=realtek.com; s=dkim;
	t=1791252530; bh=fbyAlXUJjTciw2fak58IzyI3J8S+q0g6yKmD6SPFDWw=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:Content-Transfer-Encoding:MIME-Version;
	b=AiXUowHsy2MpiDWiEBN7nfmttPQwW/scd5QuomLrZiIYIsl+v5FE1uv+UcJhtKFfx
	 N+xqjmd77hSV/uiH7okkPZC2WlXjYd1NTK3sCxn9S1Vfd5NQrxbRQm/yhvyFnJHjZ6
	 nWMjvL902gRHoA8orSkIIzCkcWxS52aZ+SyM3erVg/QCy2+dIhvBwaZ8z+kXsujIbV
	 XRJkg8NMr9D1TBE/q/ofWCEQ8yq+oo2HL9HxBJalEAFBRc689LgpWTomztoLDkDyd1
	 zom/zCgsT6W14g2588SpSyJc0JofJgWtacu/Ro9DsrpQTVc7kjRtlwFZYmg0o5BEgK
	 vQgWWDshuM7jg==
Received: from mail.realtek.com (rtkexhmbs04.realtek.com.tw[10.21.1.54])
	by rtits2.realtek.com.tw (8.15.2/3.29/5.94) with ESMTPS id 69628o7322462138
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
	Tue, 6 Oct 2026 10:08:50 +0800
Received: from RTKEXHMBS06.realtek.com.tw (10.21.1.56) by
 RTKEXHMBS04.realtek.com.tw (10.21.1.54) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.49; Tue, 6 Oct 2026 10:08:50 +0800
Received: from RTKEXHMBS06.realtek.com.tw (10.21.1.56) by
 RTKEXHMBS06.realtek.com.tw (10.21.1.56) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.49; Tue, 6 Oct 2026 10:08:49 +0800
Received: from RTKEXHMBS06.realtek.com.tw ([::1]) by
 RTKEXHMBS06.realtek.com.tw ([fe80::b3cc:c263:b82d:e87c%10]) with mapi id
 15.02.2562.049; Tue, 6 Oct 2026 10:08:49 +0800
From: Ping-Ke Shih <pkshih@realtek.com>
To: Alastair D'Silva <alastair@d-silva.org>, "linux-wireless@vger.kernel.org"
	<linux-wireless@vger.kernel.org>, Kalle Valo <kvalo@kernel.org>
CC: Luka Gejak <luka.gejak@linux.dev>, Martin Blumenstingl
	<martin.blumenstingl@googlemail.com>, Jernej Skrabec
	<jernej.skrabec@gmail.com>, Ulf Hansson <ulfh@kernel.org>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: [PATCH rtw-next v4 4/4] wifi: rtw88: sdio: Split rtw_sdio_rx_isr
 into 8051 and 3081 variants
Thread-Topic: [PATCH rtw-next v4 4/4] wifi: rtw88: sdio: Split rtw_sdio_rx_isr
 into 8051 and 3081 variants
Thread-Index: AQHdVKaLchx00TtWGUua9TwlnVUPurbvxasw
Date: Tue, 6 Oct 2026 02:08:49 +0000
Message-ID: <121a23706c144a898e71441ed89c3cb3@realtek.com>
References: <20261005084849.3109337-1-alastair@d-silva.org>
 <20261005084849.3109337-5-alastair@d-silva.org>
In-Reply-To: <20261005084849.3109337-5-alastair@d-silva.org>
Accept-Language: en-US, zh-TW
Content-Language: zh-TW
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0

Alastair D'Silva <alastair@d-silva.org> wrote:
> Split rtw_sdio_rx_isr() into separate 8051 and 3081 variants to be
> clear. The two differences between the architectures are:
> - Register size: REG_SDIO_RX0_REQ_LEN is 16-bit on 8051, 32-bit on 3081.
> - HISR behavior: 8051 re-reads REG_SDIO_HISR on each iteration, while
>   3081 drains based on rx_len without re-reading HISR.
>=20
> This is a refactoring without any logic changes.
>=20
> Assisted-by: LLM
> Signed-off-by: Alastair D'Silva <alastair@d-silva.org>

Acked-by: Ping-Ke Shih <pkshih@realtek.com>


[...]

> +               /* Stop if no more RX requests are pending, even if

nit: keep first line of block comment as empty.=20

> +                * rx_len could be greater than zero in the next
> +                * iteration. This is needed because the RX buffer may
> +                * already contain data while either HW or FW are not
> +                * done filling that buffer yet. Still reading the
> +                * buffer can result in packets where
> +                * rtw_rx_pkt_stat.pkt_len is zero or points beyond the
> +                * end of the buffer.
> +                */
> +               hisr =3D rtw_read32(rtwdev, REG_SDIO_HISR);
>         } while (total_rx_bytes < SZ_64K && hisr & REG_SDIO_HISR_RX_REQUE=
ST);
>  }
>=20


