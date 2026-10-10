Received: from mta1.migadu.com (out-251.mta1.migadu.com [95.215.58.251])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BB35D469829
	for <linux-wireless@vger.kernel.org>; Sat, 10 Oct 2026 11:14:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.251
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791630879; cv=none; b=O07MA08yAO8PhrLqcOJK6Sjtf49UbdcOZRKCJanuIKeWq9KK90XLMa6kTZfBF0YuD/r4OznjFf1FLgQlzLxxBY/3RW+cFTACGacuchDH/dE7OTyBLHnbnlvDyPq985S1rFkougw7i6BJs0hG6B3D7ArJsenzIqK/RpbBo0sMPxc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791630879; c=relaxed/simple;
	bh=yn4p2s9JivjvBTqbIsK6tSDnIq73X7zd5BQ9ePHoMnI=;
	h=MIME-Version:Date:Content-Type:From:Message-ID:Subject:To:Cc:
	 In-Reply-To:References; b=ualUPG/9/COYaEiNsbwtEc9qCBLGaHimsrE5R0j+H6k5bL1bxhTlRqhll/NLiyTDAJqyG/Kwd1DbhRRD2Tb8cA0pF4YNU0olEJF96UE5GcjOkEv4JJyBlB7WRPbxl0izJ2AXB+/ANN9cxsmY4nAVEdHcocADeB1xlpEqAwZVOaE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=XkvEz/FM; arc=none smtp.client-ip=95.215.58.251
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="XkvEz/FM"
X-Envelope-To: linux-wireless@vger.kernel.org
DKIM-Signature: a=rsa-sha256; bh=yn4p2s9JivjvBTqbIsK6tSDnIq73X7zd5BQ9ePHoMnI=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1791630872; v=1; x=1792235672;
 b=XkvEz/FM5/D9yAV3zvtso4HqPuiP4eXF/G6dx2bR1zg4buWnzPeJxMTxSU16wl79sSqguJBI
 kECoJmQdPlbQWbf6NY5nrIUY5vhV8zcvLs9lkudJk6UQbXSqYBkG37GFO/DpRyOlp2VxraD1NXJ
 lpY/cRu0B34MBwfk6Vt823tU=
X-Envelope-To: linux-wireless@vger.kernel.org
Received: by smtp.migadu.com with ESMTPS id 1c509de7a57eaea1;
	Sat, 10 Oct 2026 11:14:32 +0000
X-Mizu-Trace-ID: 1c509de7a57eaea1
X-Migadu-Flow: FLOW_OUT
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Date: Sat, 10 Oct 2026 11:14:32 +0000
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: quoted-printable
From: "Luka Gejak" <luka.gejak@linux.dev>
Message-ID: <ce5a3b408acc48642aa31866df39630aec7792f6@linux.dev>
TLS-Required: No
Subject: Re: [PATCH v2] wifi: rtw88: 8723b: avoid converting RX SNR twice
To: "Hungyu Lin" <dennylin0707@gmail.com>, pkshih@realtek.com
Cc: linux-wireless@vger.kernel.org, linux-kernel@vger.kernel.org,
 rtl8821cerfe2@gmail.com, straube.linux@gmail.com, "Hungyu Lin"
 <dennylin0707@gmail.com>
In-Reply-To: <3c89d2ac770c659eacd532134c89b4725be9ab97.1791627615.git.dennylin0707@gmail.com>
References: <3c89d2ac770c659eacd532134c89b4725be9ab97.1791627615.git.dennylin0707@gmail.com>

October 10, 2026 at 12:47 PM, "Hungyu Lin" <dennylin0707@gmail.com mailto=
:dennylin0707@gmail.com?to=3D%22Hungyu%20Lin%22%20%3Cdennylin0707%40gmail=
.com%3E > wrote:


>=20
>=20rtw8723b_query_phy_status_ofdm() divides the SNR report by two when
> filling pkt_stat->rx_snr, then shifts it again when updating
> dm_info->rx_snr. This halves the SNR used for diagnostics and average
> statistics.
>=20
>=20Store the raw report in pkt_stat->rx_snr and convert it only when
> updating dm_info->rx_snr, as the other chip drivers do.
>=20
>=20Fixes: d726c70ce082 ("wifi: rtw88: 8723b: add the RTL8723B chip drive=
r")
> Signed-off-by: Hungyu Lin <dennylin0707@gmail.com>

Ping-Ke should fixes tag be present here if this commit isn't in
mainline yet?

> ---
> Changes in v2:
> - Store the raw SNR report in pkt_stat->rx_snr and keep the shift when
>  updating dm_info->rx_snr.
>=20
>=20 drivers/net/wireless/realtek/rtw88/rtw8723b.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>=20
>=20diff --git a/drivers/net/wireless/realtek/rtw88/rtw8723b.c b/drivers/=
net/wireless/realtek/rtw88/rtw8723b.c
> index 8bb9c03d769c..18bd2b108ccb 100644
> --- a/drivers/net/wireless/realtek/rtw88/rtw8723b.c
> +++ b/drivers/net/wireless/realtek/rtw88/rtw8723b.c
> @@ -1280,7 +1280,7 @@ static void rtw8723b_query_phy_status_ofdm(struct=
 rtw_dev *rtwdev, void *phy_raw
>  pkt_stat->rx_power[RF_PATH_A] =3D (val_s8 * 2) - 110;
>=20=20
>=20 pkt_stat->rssi =3D rtw_phy_rf_power_2_rssi(pkt_stat->rx_power, 1);
> - pkt_stat->rx_snr[RF_PATH_A] =3D (s8)(phy_status->path_rxsnr[RF_PATH_A=
] / 2);
> + pkt_stat->rx_snr[RF_PATH_A] =3D phy_status->path_rxsnr[RF_PATH_A];
>=20=20
>=20 /* signal power reported by HW */
>  val_s8 =3D phy_status->cck_sig_qual_ofdm_pwdb_all >> 1;
>

Either way change looks good to me.

Reviewed-by: Luka Gejak <luka.gejak@linux.dev>

Best regards,
Luka Gejak
