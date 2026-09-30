Received: from mta0.migadu.com (out-83.mta0.migadu.com [91.218.175.83])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2EB094FECDD
	for <linux-wireless@vger.kernel.org>; Wed, 30 Sep 2026 21:14:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.83
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790802889; cv=none; b=UrvbO4wKJrmzmhZYkjtzfusSIVQdjhgt1GejXkH5YYtdokrkRgx6YGuTKufK4oR7KzYa1Hgf3Yy6To8Y2S4/kYYw1T5cXCoM1beXoVNJmTEsgKBzZzygy3VQoXhlUM4gZ0eml9RznUrCvPgLspmWLNHjQyH17jNKu10ZP7yt+BU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790802889; c=relaxed/simple;
	bh=OhJ1JVkBjXZYdK4dsUnAfFBSP+ct1yGQHTyrFbZIrn4=;
	h=MIME-Version:Date:Content-Type:From:Message-ID:Subject:To:Cc:
	 In-Reply-To:References; b=vCO27kIJbHPcyx7YkMXJQyFMv8LFawoqw/9K3ILoFww3A6k48gwpn1/mltiHQh8Y8uhRrEzVB3cx1YAza77bD5RilotnuKbuQjljBDqWeC0YERwmYjVVIAB5CEQDLk3DRaTAiovPNbgRsbjyylV1ZHuyLd/rh+IEcrDTvvRUfEo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=K7IkIXxW; arc=none smtp.client-ip=91.218.175.83
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="K7IkIXxW"
X-Envelope-To: linux-wireless@vger.kernel.org
DKIM-Signature: a=rsa-sha256; bh=OhJ1JVkBjXZYdK4dsUnAfFBSP+ct1yGQHTyrFbZIrn4=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1790802885; v=1; x=1791407685;
 b=K7IkIXxW8VFEENPKm4RHAiCYOBYx7B34qivTsoaWmto2qu1Jt2rrzm1XMLItHFFtFzi4r9up
 Cc+nWVNjstwc51HQobiTDvUZkhdj0M4sz+j7vG/fxgeeGESwVz6FMmO8B8Ohin/gjAMl5/Vysur
 qv/jkd7E4uXv8g4biI6eO6Xo=
X-Envelope-To: linux-wireless@vger.kernel.org
Received: by smtp.migadu.com with ESMTPS id f78a63fa0a3d697d;
	Wed, 30 Sep 2026 21:14:45 +0000
X-Mizu-Trace-ID: f78a63fa0a3d697d
X-Migadu-Flow: FLOW_OUT
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Date: Wed, 30 Sep 2026 21:14:44 +0000
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: quoted-printable
From: "Luka Gejak" <luka.gejak@linux.dev>
Message-ID: <bfa45c2b84ee3d06018306c9f7ea599d81e9ec18@linux.dev>
TLS-Required: No
Subject: Re: [PATCH v5 rtw-next 5/7] wifi: rtw88: 8723b: add the RTL8723B
 chip driver
To: "Bitterblue Smith" <rtl8821cerfe2@gmail.com>, "Ping-Ke Shih"
 <pkshih@realtek.com>
Cc: linux-wireless@vger.kernel.org, linux-kernel@vger.kernel.org, "Michael
 Straube" <straube.linux@gmail.com>, "Peter Robinson"
 <pbrobinson@gmail.com>, luka.gejak@linux.dev
In-Reply-To: <6ce7307e-b753-4dd2-a47a-e347f5806100@gmail.com>
References: <20260930091604.52891-1-luka.gejak@linux.dev>
 <20260930091604.52891-6-luka.gejak@linux.dev>
 <6ce7307e-b753-4dd2-a47a-e347f5806100@gmail.com>

September 30, 2026 at 20:03, "Bitterblue Smith" <rtl8821cerfe2@gmail.com =
mailto:rtl8821cerfe2@gmail.com?to=3D%22Bitterblue%20Smith%22%20%3Crtl8821=
cerfe2%40gmail.com%3E > wrote:


>=20
>=20On 30/09/2026 12:16, Luka Gejak wrote:
>=20
>=20>=20
>=20> Add the Realtek RTL8723B 802.11n chip driver: the chip operations, =
the
> >  power sequences, the efuse layout, the RF and IQ calibration, and th=
e
> >  chip specific coexistence handling.
> >=20=20
[...]
>=20>  +/* The eight per-rate CCK transmit power registers are consecutiv=
e. */
> >  +#define REG_CCK_SWING 0x0a22
> >=20
>=20This should be in reg.h.
>=20

Will=20move it in v6.

> >=20
>=20> +#define RTW_CCK_SWING_REG_NUM 8
> >  +
[...]
> >  + /* Enable Rx DMA timer masking: clear 0x0[2:0] and 0x2[15:0] only.=
 */
> >  + val32 =3D rtw_read32(rtwdev, REG_SDIO_TX_CTRL);
> >  + val32 &=3D 0x0000fff8;
> >  + rtw_write32(rtwdev, REG_SDIO_TX_CTRL, val32);
> >=20
>=20This is only for SDIO, it shouldn't run for PCI and USB.
>=20

Understood,=20will add a check for SDIO.

> >=20
[...]
>=20>  + rtw_dbg(rtwdev, RTW_DBG_RFK,
> >  + "[IQK]0xc80 =3D 0x%x 0xc94 =3D 0x%x 0xc14 =3D 0x%x 0xca0 =3D 0x%x\=
n",
> >  + rtw_read32(rtwdev, REG_OFDM_0_XA_TX_IQ_IMBALANCE),
> >=20
>=20This is misaligned.
>=20
>=20>=20
>=20> + rtw_read32(rtwdev, REG_TXIQK_MATRIXA_LSB2_11N),
> >  + rtw_read32(rtwdev, REG_A_RXIQI),
> >  + rtw_read32(rtwdev, REG_RXIQK_MATRIX_LSB_11N));
> >  + rtw_dbg(rtwdev, RTW_DBG_RFK,
> >  + "[IQK]0xcd0 =3D 0x%x 0xcd4 =3D 0x%x 0xcd8 =3D 0x%x\n",
> >  + rtw_read32(rtwdev, REG_TXIQ_AB_S0),
> >=20
>=20This too.
>=20

My=20bad, and just one thing: checkpatch didn't catch these.
Will fix both either way.

Best regards,
Luka Gejak
