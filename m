Received: from mta0.migadu.com (out-24.mta0.migadu.com [91.218.175.24])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4032F39CCF9
	for <linux-wireless@vger.kernel.org>; Sat, 10 Oct 2026 18:50:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.24
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791658243; cv=none; b=ogrJgAOm3/yX/ZQV7wYmSNMzG+wCGSqUyCF/wKbtoNn8m0Rp21iQgpY2/tm4zvcvB4WUiFsAwp2HEkFgEXpPDyYyUtjRVkn7YjhRJQ6WViLGZDMvCQCxXgXdqCCgim9G3ZQ82mxR3scJx9u+1Z1oMRIFAv/KtiaCFL9OsvlDRok=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791658243; c=relaxed/simple;
	bh=+DpowwWUzElzCL/0v1vsGuDgjoOiYBAkmXuXHCLjLnw=;
	h=MIME-Version:Date:Content-Type:From:Message-ID:Subject:To:Cc:
	 In-Reply-To:References; b=c4W1NaVZKriqBFgfx+QmlhQ+0mQKN2igknN5tLVsIP0lZQjBHdC1jhD9atJxfhA+3t59if5Q2TNzx+C+H80zS7pPiv2Si0hQIGrnPHw824Ni8Hy7Ted37+x5CwE89kaYGQuloVELpoSZsqoXI2wu/bJ4ToJyZTdRhmxnA8jL5TA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=MKPo6JIe; arc=none smtp.client-ip=91.218.175.24
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="MKPo6JIe"
X-Envelope-To: linux-wireless@vger.kernel.org
DKIM-Signature: a=rsa-sha256; bh=+DpowwWUzElzCL/0v1vsGuDgjoOiYBAkmXuXHCLjLnw=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1791658239; v=1; x=1792263039;
 b=MKPo6JIerwzpiJDMsZU66wkKMKYB41VW8fxTaMshJ8Gg2Ptp2a3N9URYCoQ54WHFYZ/p0rO4
 CDNW3NJk/p+dzy2vHAt3G5J0dUWaCQJ3Fn08ulTYNqMHdrjuqulDpR0EhH5K5wsNztQbvD+NbjL
 X3JI2kyOVEcXVZjz7tcNUgTY=
X-Envelope-To: linux-wireless@vger.kernel.org
Received: by smtp.migadu.com with ESMTPS id 634365af05cf6c2d;
	Sat, 10 Oct 2026 18:50:20 +0000
X-Mizu-Trace-ID: 634365af05cf6c2d
X-Migadu-Flow: FLOW_OUT
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Date: Sat, 10 Oct 2026 18:50:20 +0000
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: quoted-printable
From: "Luka Gejak" <luka.gejak@linux.dev>
Message-ID: <08bc0316b09cb28d4f660af89d249a222ce4be6f@linux.dev>
TLS-Required: No
Subject: Re: [PATCH] wifi: rtw88: 8703b: avoid converting RX SNR twice
To: "Hungyu Lin" <dennylin0707@gmail.com>, pkshih@realtek.com
Cc: linux-wireless@vger.kernel.org, linux-kernel@vger.kernel.org,
 fiona.klute@gmx.de, kvalo@kernel.org, "Hungyu Lin"
 <dennylin0707@gmail.com>
In-Reply-To: <20261010183629.39748-1-dennylin0707@gmail.com>
References: <20261010183629.39748-1-dennylin0707@gmail.com>

October 10, 2026 at 8:36 PM, "Hungyu Lin" <dennylin0707@gmail.com mailto:=
dennylin0707@gmail.com?to=3D%22Hungyu%20Lin%22%20%3Cdennylin0707%40gmail.=
com%3E > wrote:


>=20
>=20query_phy_status_ofdm() divides the SNR report by two when filling
> pkt_stat->rx_snr, then shifts it again when updating dm_info->rx_snr.
> This halves the SNR used for diagnostics and average statistics.
>=20
>=20Store the raw report in pkt_stat->rx_snr and convert it only when
> updating dm_info->rx_snr, as the other chip drivers do.
>=20
>=20Fixes: 61a486bcd782 ("wifi: rtw88: Add rtw8703b.c")
> Signed-off-by: Hungyu Lin <dennylin0707@gmail.com>
> ---
>  drivers/net/wireless/realtek/rtw88/rtw8703b.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>=20
>=20diff --git a/drivers/net/wireless/realtek/rtw88/rtw8703b.c b/drivers/=
net/wireless/realtek/rtw88/rtw8703b.c
> index 25456f0367b2..1920277d626f 100644
> --- a/drivers/net/wireless/realtek/rtw88/rtw8703b.c
> +++ b/drivers/net/wireless/realtek/rtw88/rtw8703b.c
> @@ -959,7 +959,7 @@ static void query_phy_status_ofdm(struct rtw_dev *r=
twdev, u8 *phy_raw,
>  val_s8 =3D phy_status->path_agc[RF_PATH_A].gain & 0x3F;
>  pkt_stat->rx_power[RF_PATH_A] =3D (val_s8 * 2) - 110;
>  pkt_stat->rssi =3D rtw_phy_rf_power_2_rssi(pkt_stat->rx_power, 1);
> - pkt_stat->rx_snr[RF_PATH_A] =3D (s8)(phy_status->path_rxsnr[RF_PATH_A=
] / 2);
> + pkt_stat->rx_snr[RF_PATH_A] =3D phy_status->path_rxsnr[RF_PATH_A];
>=20=20
>=20 /* signal power reported by HW */
>  val_s8 =3D phy_status->cck_sig_qual_ofdm_pwdb_all >> 1;
>

Looking good to me.

Reviewed-by: Luka Gejak <luka.gejak@linux.dev>

Best regards,
Luka Gejak
