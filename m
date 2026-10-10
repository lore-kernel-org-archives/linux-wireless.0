Received: from mta1.migadu.com (out-246.mta1.migadu.com [95.215.58.246])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4E5923DDB02
	for <linux-wireless@vger.kernel.org>; Sat, 10 Oct 2026 06:17:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.246
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791613035; cv=none; b=cAMnozuCtKTbFZYDx0F+vmQaoT90crd11SC3lQpJvCNCgCdk6AqrnqPMtgi43RZlqEJkHHGqUZZ2xEljr1b4Jmje3V7VYbjc5EH81CnQLogZXGKkf6iu2CdpVaXUEUOY2DjeOO3l5/4ygA7MKy5EX8vzpgczwW6OrOEPSthaNL4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791613035; c=relaxed/simple;
	bh=2iFrwRhGd22kGBX3plIzfM8HTJAXORhzt8v2vENuhao=;
	h=MIME-Version:Date:Content-Type:From:Message-ID:Subject:To:Cc:
	 In-Reply-To:References; b=pMP1eckpsWSNQyzOpc3YrZGgmAUPCBtW0SkLueY4b3CGTbs0XlzWNKW0rU63DPAmlmFOMZsJ6oQDnMDFZzrSwRZXPn7LYJZJ3sPgGwiETt5AnRi03v92BcGmc2z8T2F/0JzV1iqJwwM5WOJKf13N+5fjrVNNHZsmWbhgf74eg0M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=noBlkf/b; arc=none smtp.client-ip=95.215.58.246
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="noBlkf/b"
X-Envelope-To: linux-wireless@vger.kernel.org
DKIM-Signature: a=rsa-sha256; bh=2iFrwRhGd22kGBX3plIzfM8HTJAXORhzt8v2vENuhao=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1791613028; v=1; x=1792217828;
 b=noBlkf/bgdA8EVe47Yl1XNzH4vPkyOmvprRkcCIOkiZWP7+uFu80jaJ2pdJd1LUO7uggchRR
 CnIMjTXcjD9kCVwuGgxlVCmGfkoxTqsKOsHMzK6BJLSGC5/hsboIP4k511a5/BoQXgtwah73kCM
 4i2YtUysXh48XWM0XLOVlxMY=
X-Envelope-To: linux-wireless@vger.kernel.org
Received: by smtp.migadu.com with ESMTPS id e87895b60daedb89;
	Sat, 10 Oct 2026 06:17:06 +0000
X-Mizu-Trace-ID: e87895b60daedb89
X-Migadu-Flow: FLOW_OUT
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Date: Sat, 10 Oct 2026 06:17:06 +0000
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: quoted-printable
From: "Luka Gejak" <luka.gejak@linux.dev>
Message-ID: <0b059e24d8c9b870b3db90d2f001a293896753d8@linux.dev>
TLS-Required: No
Subject: Re: [PATCH] wifi: rtw88: 8723b: avoid converting RX SNR twice
To: "Hungyu Lin" <dennylin0707@gmail.com>, pkshih@realtek.com
Cc: linux-wireless@vger.kernel.org, linux-kernel@vger.kernel.org,
 rtl8821cerfe2@gmail.com, straube.linux@gmail.com, "Hungyu Lin"
 <dennylin0707@gmail.com>
In-Reply-To: <20261010013249.35584-1-dennylin0707@gmail.com>
References: <20261010013249.35584-1-dennylin0707@gmail.com>

October 10, 2026 at 3:32 AM, "Hungyu Lin" <dennylin0707@gmail.com> wrote:


>=20
>=20rtw8723b_query_phy_status_ofdm() already divides the PHY SNR report b=
y
> two when filling pkt_stat->rx_snr. Shifting it again when copying it to
> dm_info->rx_snr halves the value shown in diagnostics and used for the
> average SNR.
>=20
>=20Copy the converted value directly.
>=20
>=20Fixes: d726c70ce082 ("wifi: rtw88: 8723b: add the RTL8723B chip drive=
r")
> Signed-off-by: Hungyu Lin <dennylin0707@gmail.com>
> ---
>  drivers/net/wireless/realtek/rtw88/rtw8723b.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>=20
>=20diff --git a/drivers/net/wireless/realtek/rtw88/rtw8723b.c b/drivers/=
net/wireless/realtek/rtw88/rtw8723b.c
> index 8bb9c03d769c..197add7cc110 100644
> --- a/drivers/net/wireless/realtek/rtw88/rtw8723b.c
> +++ b/drivers/net/wireless/realtek/rtw88/rtw8723b.c
> @@ -1291,7 +1291,7 @@ static void rtw8723b_query_phy_status_ofdm(struct=
 rtw_dev *rtwdev, void *phy_raw
>=20=20
>=20 dm_info->curr_rx_rate =3D pkt_stat->rate;
>  dm_info->rssi[RF_PATH_A] =3D pkt_stat->rssi;
> - dm_info->rx_snr[RF_PATH_A] =3D pkt_stat->rx_snr[RF_PATH_A] >> 1;
> + dm_info->rx_snr[RF_PATH_A] =3D pkt_stat->rx_snr[RF_PATH_A];
>  dm_info->cfo_tail[RF_PATH_A] =3D (pkt_stat->cfo_tail[RF_PATH_A] * 5) >=
> 1;
>=20=20
>=20 val_s8 =3D (s8)pkt_stat->rx_evm[RF_PATH_A];
>

For consistency, please do it the other way round: drop the /2 when
filling pkt_stat->rx_snr and keep the shift on the dm_info line.
rtw8723d.c, rtw8822b.c, rtw8822c.c and rtw8814a.c all store the raw repor=
t
and shift it once.

Also, rtw8703b.c has the same double conversion in query_phy_status_ofdm(=
).
That one is upstream, so a patch for it would be welcome.

Best regards,
Luka Gejak
